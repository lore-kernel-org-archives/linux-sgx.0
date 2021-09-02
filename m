Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E3DCC433FE
	for <linux-sgx@archiver.kernel.org>; Thu,  2 Sep 2021 21:56:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 272CE60FA0
	for <linux-sgx@archiver.kernel.org>; Thu,  2 Sep 2021 21:56:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347926AbhIBV5f (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 2 Sep 2021 17:57:35 -0400
Received: from mga14.intel.com ([192.55.52.115]:41290 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347809AbhIBV5W (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 2 Sep 2021 17:57:22 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10095"; a="218963659"
X-IronPort-AV: E=Sophos;i="5.85,263,1624345200"; 
   d="scan'208";a="218963659"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2021 14:56:21 -0700
X-IronPort-AV: E=Sophos;i="5.85,263,1624345200"; 
   d="scan'208";a="500007646"
Received: from mmijoce-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.255.94.151])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2021 14:56:18 -0700
Date:   Fri, 3 Sep 2021 09:56:16 +1200
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
Message-Id: <20210903095616.9806a6dd4938c021aa204b33@intel.com>
In-Reply-To: <41e9b099f6492c389b3ed3bbe107d61804a307e9.camel@kernel.org>
References: <20210825235234.153013-1-jarkko@kernel.org>
        <20210825235234.153013-2-jarkko@kernel.org>
        <20210826141959.5f13ff3c9c560c23b58443b1@intel.com>
        <54923ac01fc303e5105cadca06b7c5cbd322d815.camel@kernel.org>
        <20210828000335.1d40dfff0f408b2d91467491@intel.com>
        <04b90a702328712204430db604b2a92ddfe8f990.camel@kernel.org>
        <20210901173322.78f94b694b4be6b1225bee98@intel.com>
        <6a9fccdb6a458960e43a63afcce87cc62184adf9.camel@kernel.org>
        <20210901174705.3b1a943ef8c4bb09323c6d76@intel.com>
        <41e9b099f6492c389b3ed3bbe107d61804a307e9.camel@kernel.org>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, 02 Sep 2021 15:15:51 +0300 Jarkko Sakkinen wrote:
> On Wed, 2021-09-01 at 17:47 +1200, Kai Huang wrote:
> > On Wed, 01 Sep 2021 08:41:12 +0300 Jarkko Sakkinen wrote:
> > > On Wed, 2021-09-01 at 17:33 +1200, Kai Huang wrote:
> > > > On Wed, 01 Sep 2021 05:02:45 +0300 Jarkko Sakkinen wrote:
> > > > > On Sat, 2021-08-28 at 00:03 +1200, Kai Huang wrote:
> > > > > > > > > -/* The free page list lock protected variables prepend the lock. */
> > > > > > > > > +/* The number of usable EPC pages in the system. */
> > > > > > > > > +unsigned long sgx_nr_all_pages;
> > > > > > > > > +
> > > > > > > > > +/* The number of free EPC pages in all nodes. */
> > > > > > > > >  static unsigned long sgx_nr_free_pages;
> > > > > > > > >  
> > > > > > > > >  /* Nodes with one or more EPC sections. */
> > > > > > > > > @@ -656,6 +659,8 @@ static bool __init sgx_setup_epc_section(u64 phys_addr, u64 size,
> > > > > > > > >  		list_add_tail(&section->pages[i].list, &sgx_dirty_page_list);
> > > > > > > > >  	}
> > > > > > > > >  
> > > > > > > > > +	sgx_nr_all_pages += nr_pages;
> > > > > > > > > +
> > > > > > > > 
> > > > > > > > EPC sections can be freed again in sgx_init() after they are successfully
> > > > > > > > initialized, when any further initialization fails (i.e. when fails to create
> > > > > > > > ksgxd, or fails to register /dev/sgx_provision).  In which case, I think
> > > > > > > > sgx_nr_all_pages should also be cleared.  But current sgx_init() seems doesn't
> > > > > > > > reset it.  Do you need to fix that too?
> > > > > > > 
> > > > > > > sgx_nr_all_pages tells just the total pages in the system, i.e. it's a constant.
> > > > > > > 
> > > > > > > Maybe a rename to "sgx_nr_total_pages" would be a good idea? Would match with
> > > > > > > the meminfo field better too.
> > > > > > 
> > > > > > I don't have preference on name.  I just think if there's no actual user of
> > > > > > EPC (when both driver and KVM SGX cannot be enabled), it's pointless to print
> > > > > > number of EPC pages.
> > > > > 
> > > > > I'd presume that you refer to the code, which prints the number of *bytes* in
> > > > > the system because code printing the number of pages does not exist in this
> > > > > patch set.
> > > > > 
> > > > > I have troubles the decipher your statement.
> > > > > 
> > > > > You think that only if both the driver and KVM are *both* enabled, only then
> > > > > it makes sense to have this information available for sysadmin?
> > > > 
> > > > Only if at least one of them is enabled.
> > > 
> > > OK, thank you, that does make sense.
> > > 
> > > What would happen if neither is enabled is that SGX_MemTotal would
> > > state that there is zero bytes of EPC. 
> > 
> > This is the problem I pointed out at the beginning, that (if I read code
> > correctly), it seems your current patch doesn't clear sgx_nr_all_pages when
> > neither is enabled (in sgx_init() in sgx/main.c).
> 
> It's initialized to zero, so are you talking about fallback when something
> fails?
> 
> /Jarkko

Yes, shouldn't you have something similar to below?

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 63d3de02bbcc..270f6103b6c0 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -836,6 +836,7 @@ static int __init sgx_init(void)
                vfree(sgx_epc_sections[i].pages);
                memunmap(sgx_epc_sections[i].virt_addr);
        }
+       sgx_nr_all_pages = 0;
 
        return ret;
 }

