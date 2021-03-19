Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93DE1C433DB
	for <linux-sgx@archiver.kernel.org>; Fri, 19 Mar 2021 09:13:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5339564F62
	for <linux-sgx@archiver.kernel.org>; Fri, 19 Mar 2021 09:13:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbhCSJMg (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 19 Mar 2021 05:12:36 -0400
Received: from mga02.intel.com ([134.134.136.20]:44911 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229863AbhCSJMH (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 19 Mar 2021 05:12:07 -0400
IronPort-SDR: Yc6m2VWb2jnRj8GGG0Or5QqkJ9Na/HVTiWimT8vMTf0j/LC0zVHdj5VmjlKu6d/1uJY/eAf8zQ
 eZkyj62FO5NQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9927"; a="176989548"
X-IronPort-AV: E=Sophos;i="5.81,261,1610438400"; 
   d="scan'208";a="176989548"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2021 02:12:06 -0700
IronPort-SDR: Azm9ygHTZEpBGjfqRQbToN3wtv+hmLroSUVdxRJgdBknpTemxk1Uxmc1fiDnCI5O7PWmYrn8Ba
 Sci3eoru78ng==
X-IronPort-AV: E=Sophos;i="5.81,261,1610438400"; 
   d="scan'208";a="406708400"
Received: from dlmeisen-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.255.229.165])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2021 02:12:04 -0700
Date:   Fri, 19 Mar 2021 22:12:01 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Borislav Petkov <bp@alien8.de>, <x86@kernel.org>,
        <linux-sgx@vger.kernel.org>, <jarkko@kernel.org>,
        <dave.hansen@linux.intel.com>, <dave.hansen@intel.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/sgx: Avoid returning NULL in __sgx_alloc_epc_page()
Message-Id: <20210319221201.3ee4f744a58ed348df498a4a@intel.com>
In-Reply-To: <20210319220141.8bf20c54fdb06c6f93cde448@intel.com>
References: <20210319040602.178558-1-kai.huang@intel.com>
        <20210319084523.GA6251@zn.tnic>
        <20210319220141.8bf20c54fdb06c6f93cde448@intel.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, 19 Mar 2021 22:01:41 +1300 Kai Huang wrote:
> On Fri, 19 Mar 2021 09:45:23 +0100 Borislav Petkov wrote:
> > On Fri, Mar 19, 2021 at 05:06:02PM +1300, Kai Huang wrote:
> > > Below kernel bug happened when running simple SGX application when EPC
> > > is under pressure.  The root cause is with commit 5b8719504e3a
> > > ("x86/sgx: Add a basic NUMA allocation scheme to sgx_alloc_epc_page()"),
> > > __sgx_alloc_epc_page() returns NULL when there's no free EPC page can be
> > > allocated, while old behavior was it always returned ERR_PTR(-ENOMEM) in
> > > such case.
> > > 
> > > Fix by directly returning the page if __sgx_alloc_epc_page_from_node()
> > > allocates a valid page in fallback to non-local allocation, and always
> > > returning ERR_PTR(-ENOMEM) if no EPC page can be allocated.
> > > 
> > > [  253.474764] BUG: kernel NULL pointer dereference, address: 0000000000000008
> > > [  253.500101] #PF: supervisor write access in kernel mode
> > > [  253.525462] #PF: error_code(0x0002) - not-present page
> > > ...
> > > [  254.102041] Call Trace:
> > > [  254.126699]  sgx_ioc_enclave_add_pages+0x241/0x770
> > > [  254.151305]  sgx_ioctl+0x194/0x4b0
> > > [  254.174976]  ? handle_mm_fault+0xd0/0x260
> > > [  254.198470]  ? do_user_addr_fault+0x1ef/0x570
> > > [  254.221827]  __x64_sys_ioctl+0x91/0xc0
> > > [  254.244546]  do_syscall_64+0x38/0x90
> > > [  254.266728]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> > > [  254.289232] RIP: 0033:0x7fdc4cf4031b
> > > ...
> > > [  254.711480] CR2: 0000000000000008
> > > [  254.735494] ---[ end trace 970dce6d4cdf7f64 ]---
> > > [  254.759915] RIP: 0010:sgx_alloc_epc_page+0x46/0x152
> > > ...
> > > 
> > > Fixes: 5b8719504e3a("x86/sgx: Add a basic NUMA allocation scheme to sgx_alloc_epc_page()")
> > > Signed-off-by: Kai Huang <kai.huang@intel.com>
> > > ---
> > >  arch/x86/kernel/cpu/sgx/main.c | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > I was on the verge whether to merge that into the original patch since
> > it is the top patch on the branch or create a new one but opted for
> > former because this way it won't break bisection and people won't have
> > to pay attention whether there's a fix patch to the NUMA patch too, in
> > case they wanna backport and whatnot.
> 
> Sure.
> 
> [...]
> 
> > +
> > +	/* Fall back to the non-local NUMA nodes: */
> > +	while (true) {
> > +		nid = next_node_in(nid, sgx_numa_mask);
> > +		if (nid == nid_of_current)
> > +			break;
> >  
> > -		page = __sgx_alloc_epc_page_from_section(section);
> > +		page = __sgx_alloc_epc_page_from_node(nid);
> >  		if (page)
> >  			return page;
> >  	}
> 
> It seems "return ERR_PTR(-ENOMEM)" is missing at the bottom of this function?

Oh my fault. This line is not shown in patch probably due to it is not changed
by this patch. Please ignore this.
