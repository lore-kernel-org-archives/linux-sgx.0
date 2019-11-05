Return-Path: <SRS0=ABp+=Y5=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.2 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D250ACA9ED3
	for <linux-sgx@archiver.kernel.org>; Tue,  5 Nov 2019 02:17:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A46B8214E0
	for <linux-sgx@archiver.kernel.org>; Tue,  5 Nov 2019 02:17:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729526AbfKECRW (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 4 Nov 2019 21:17:22 -0500
Received: from mga12.intel.com ([192.55.52.136]:24068 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728987AbfKECRW (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 4 Nov 2019 21:17:22 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Nov 2019 18:17:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,269,1569308400"; 
   d="scan'208";a="204819309"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga003.jf.intel.com with ESMTP; 04 Nov 2019 18:17:20 -0800
Date:   Mon, 4 Nov 2019 18:17:20 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for v24 1/3] x86/sgx: Use GFP_KERNEL for allocations
Message-ID: <20191105021720.GE5960@linux.intel.com>
References: <20191104200141.5385-1-jarkko.sakkinen@linux.intel.com>
 <20191104204602.GA5960@linux.intel.com>
 <20191104222658.GA3606@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191104222658.GA3606@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Nov 05, 2019 at 12:26:58AM +0200, Jarkko Sakkinen wrote:
> On Mon, Nov 04, 2019 at 12:46:02PM -0800, Sean Christopherson wrote:
> > On Mon, Nov 04, 2019 at 10:01:39PM +0200, Jarkko Sakkinen wrote:
> > > The reasoning is the same as in
> > > 
> > > http://git.infradead.org/users/jjs/linux-tpmdd.git/commit/abd55954f91a3aacc1d260d2411cf776ec4d5fd2
> > > 
> > > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > > ---
> > >  arch/x86/kernel/cpu/sgx/ioctl.c | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
> > > index 5b28a9c0cb68..d53aee5a64c1 100644
> > > --- a/arch/x86/kernel/cpu/sgx/ioctl.c
> > > +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
> > > @@ -259,7 +259,7 @@ static long sgx_ioc_enclave_create(struct sgx_encl *encl, void __user *arg)
> > >  	if (copy_from_user(&ecreate, arg, sizeof(ecreate)))
> > >  		return -EFAULT;
> > >  
> > > -	secs_page = alloc_page(GFP_HIGHUSER);
> > > +	secs_page = alloc_page(GFP_KERNEL);
> > >  	if (!secs_page)
> > >  		return -ENOMEM;
> > >  
> > > @@ -674,7 +674,7 @@ static long sgx_ioc_enclave_init(struct sgx_encl *encl, void __user *arg)
> > >  	if (copy_from_user(&einit, arg, sizeof(einit)))
> > >  		return -EFAULT;
> > >  
> > > -	initp_page = alloc_page(GFP_HIGHUSER);
> > > +	initp_page = alloc_page(GFP_KERNEL);
> > 
> > Would it make sense to use GFP_KERNEL_ACCOUNT?  The accounting would be
> > weird for the case where userspace is using a builder process, but even in
> > that case it's not flat out wrong to account per-enclave memory allocations.
> 
> I did not find a single call site that would use that for allocating
> memory for function-internal data.

Actually, the fact that the allocations are transient is an even better
argument for accounting the memory, as the weirdness I was referring to
doesn't exist for the builder concept.

But looking more closely, Documentation/core-api/memory-allocation.rst
states:

  * Untrusted allocations triggered from userspace should be a subject
    of kmem accounting and must have ``__GFP_ACCOUNT`` bit set. There
    is the handy ``GFP_KERNEL_ACCOUNT`` shortcut for ``GFP_KERNEL``
    allocations that should be accounted.


That means all uses of GFP_KERNEL except in sgx_alloc_epc_section() should
be converted to GFP_KERNEL_ACCOUNTED.  As is, depending on fd limits[*], a
single process can easily burn through multiple GBs of memory simply by
opening /dev/sgx/enclave in a loop.

[*] AFAICT, systemd is upping the max number of open files to 1M on my
    systems.  I don't _think_ I changed a setting anywhere?
