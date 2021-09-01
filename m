Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DDEAC4320A
	for <linux-sgx@archiver.kernel.org>; Wed,  1 Sep 2021 05:33:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6103661074
	for <linux-sgx@archiver.kernel.org>; Wed,  1 Sep 2021 05:33:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233857AbhIAFeX (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 1 Sep 2021 01:34:23 -0400
Received: from mga12.intel.com ([192.55.52.136]:20959 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232334AbhIAFeX (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 1 Sep 2021 01:34:23 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10093"; a="198195320"
X-IronPort-AV: E=Sophos;i="5.84,368,1620716400"; 
   d="scan'208";a="198195320"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2021 22:33:27 -0700
X-IronPort-AV: E=Sophos;i="5.84,368,1620716400"; 
   d="scan'208";a="541386505"
Received: from rortega-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.25.13])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2021 22:33:24 -0700
Date:   Wed, 1 Sep 2021 17:33:22 +1200
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
Message-Id: <20210901173322.78f94b694b4be6b1225bee98@intel.com>
In-Reply-To: <04b90a702328712204430db604b2a92ddfe8f990.camel@kernel.org>
References: <20210825235234.153013-1-jarkko@kernel.org>
        <20210825235234.153013-2-jarkko@kernel.org>
        <20210826141959.5f13ff3c9c560c23b58443b1@intel.com>
        <54923ac01fc303e5105cadca06b7c5cbd322d815.camel@kernel.org>
        <20210828000335.1d40dfff0f408b2d91467491@intel.com>
        <04b90a702328712204430db604b2a92ddfe8f990.camel@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, 01 Sep 2021 05:02:45 +0300 Jarkko Sakkinen wrote:
> On Sat, 2021-08-28 at 00:03 +1200, Kai Huang wrote:
> > > > > -/* The free page list lock protected variables prepend the lock. */
> > > > > +/* The number of usable EPC pages in the system. */
> > > > > +unsigned long sgx_nr_all_pages;
> > > > > +
> > > > > +/* The number of free EPC pages in all nodes. */
> > > > >  static unsigned long sgx_nr_free_pages;
> > > > >  
> > > > >  /* Nodes with one or more EPC sections. */
> > > > > @@ -656,6 +659,8 @@ static bool __init sgx_setup_epc_section(u64 phys_addr, u64 size,
> > > > >  		list_add_tail(&section->pages[i].list, &sgx_dirty_page_list);
> > > > >  	}
> > > > >  
> > > > > +	sgx_nr_all_pages += nr_pages;
> > > > > +
> > > > 
> > > > EPC sections can be freed again in sgx_init() after they are successfully
> > > > initialized, when any further initialization fails (i.e. when fails to create
> > > > ksgxd, or fails to register /dev/sgx_provision).  In which case, I think
> > > > sgx_nr_all_pages should also be cleared.  But current sgx_init() seems doesn't
> > > > reset it.  Do you need to fix that too?
> > > 
> > > sgx_nr_all_pages tells just the total pages in the system, i.e. it's a constant.
> > > 
> > > Maybe a rename to "sgx_nr_total_pages" would be a good idea? Would match with
> > > the meminfo field better too.
> > 
> > I don't have preference on name.  I just think if there's no actual user of
> > EPC (when both driver and KVM SGX cannot be enabled), it's pointless to print
> > number of EPC pages.
> 
> I'd presume that you refer to the code, which prints the number of *bytes* in
> the system because code printing the number of pages does not exist in this
> patch set.
> 
> I have troubles the decipher your statement.
> 
> You think that only if both the driver and KVM are *both* enabled, only then
> it makes sense to have this information available for sysadmin?

Only if at least one of them is enabled.

> 
> I don't get this logic, if I understood what you mean in the first place.
>
