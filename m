Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D5ADC432BE
	for <linux-sgx@archiver.kernel.org>; Fri, 27 Aug 2021 12:03:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E96060E77
	for <linux-sgx@archiver.kernel.org>; Fri, 27 Aug 2021 12:03:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231271AbhH0MEa (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 27 Aug 2021 08:04:30 -0400
Received: from mga07.intel.com ([134.134.136.100]:19525 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231191AbhH0MEa (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 27 Aug 2021 08:04:30 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10088"; a="281664712"
X-IronPort-AV: E=Sophos;i="5.84,356,1620716400"; 
   d="scan'208";a="281664712"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2021 05:03:41 -0700
X-IronPort-AV: E=Sophos;i="5.84,356,1620716400"; 
   d="scan'208";a="426457876"
Received: from ivillega-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.59.186])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2021 05:03:37 -0700
Date:   Sat, 28 Aug 2021 00:03:35 +1200
From:   Kai Huang <kai.huang@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     linux-sgx@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v3 2/2] x86/sgx: Add SGX_MemTotal to /proc/meminfo
Message-Id: <20210828000335.1d40dfff0f408b2d91467491@intel.com>
In-Reply-To: <54923ac01fc303e5105cadca06b7c5cbd322d815.camel@kernel.org>
References: <20210825235234.153013-1-jarkko@kernel.org>
        <20210825235234.153013-2-jarkko@kernel.org>
        <20210826141959.5f13ff3c9c560c23b58443b1@intel.com>
        <54923ac01fc303e5105cadca06b7c5cbd322d815.camel@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org


> > > -/* The free page list lock protected variables prepend the lock. */
> > > +/* The number of usable EPC pages in the system. */
> > > +unsigned long sgx_nr_all_pages;
> > > +
> > > +/* The number of free EPC pages in all nodes. */
> > >  static unsigned long sgx_nr_free_pages;
> > >  
> > >  /* Nodes with one or more EPC sections. */
> > > @@ -656,6 +659,8 @@ static bool __init sgx_setup_epc_section(u64 phys_addr, u64 size,
> > >  		list_add_tail(&section->pages[i].list, &sgx_dirty_page_list);
> > >  	}
> > >  
> > > +	sgx_nr_all_pages += nr_pages;
> > > +
> > 
> > EPC sections can be freed again in sgx_init() after they are successfully
> > initialized, when any further initialization fails (i.e. when fails to create
> > ksgxd, or fails to register /dev/sgx_provision).  In which case, I think
> > sgx_nr_all_pages should also be cleared.  But current sgx_init() seems doesn't
> > reset it.  Do you need to fix that too?
> 
> sgx_nr_all_pages tells just the total pages in the system, i.e. it's a constant.
> 
> Maybe a rename to "sgx_nr_total_pages" would be a good idea? Would match with
> the meminfo field better too.

I don't have preference on name.  I just think if there's no actual user of
EPC (when both driver and KVM SGX cannot be enabled), it's pointless to print
number of EPC pages.

> 
> > 
> > >  	return true;
> > >  }
> > >  
> > > diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
> > > index ad8a5c586a35..82bb09c298de 100644
> > > --- a/arch/x86/mm/pat/set_memory.c
> > > +++ b/arch/x86/mm/pat/set_memory.c
> > > @@ -29,6 +29,7 @@
> > >  #include <asm/proto.h>
> > >  #include <asm/memtype.h>
> > >  #include <asm/set_memory.h>
> > > +#include <asm/sgx.h>
> > 
> > How about only include <asm/sgx.h> when CONFIG_X86_SGX is on, then you don't
> > have to do #ifdef CONFIG_X86_SGX changes to sgx.h?
> 
> Why do it that way instead of doing it once in sgx.h for every site that wants
> to include the file?

Just my preference.  You only need sgx_nr_all_pages here, while <asm/sgx.h>
has bunch of others such as SGX data structures.  It seems it's not worth to
include <asm/sgx.h> directly.
