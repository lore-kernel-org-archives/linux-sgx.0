Return-Path: <SRS0=YfUE=Y6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.2 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C70BDC5DF63
	for <linux-sgx@archiver.kernel.org>; Wed,  6 Nov 2019 21:59:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9DC852173E
	for <linux-sgx@archiver.kernel.org>; Wed,  6 Nov 2019 21:59:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727196AbfKFV7q (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 6 Nov 2019 16:59:46 -0500
Received: from mga18.intel.com ([134.134.136.126]:44593 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727123AbfKFV7q (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 6 Nov 2019 16:59:46 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Nov 2019 13:59:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,275,1569308400"; 
   d="scan'208";a="196348821"
Received: from ksterken-mobl6.amr.corp.intel.com (HELO localhost) ([10.252.10.117])
  by orsmga008.jf.intel.com with ESMTP; 06 Nov 2019 13:59:43 -0800
Date:   Wed, 6 Nov 2019 23:59:42 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for v24 1/3] x86/sgx: Use GFP_KERNEL for allocations
Message-ID: <20191106215942.GA10732@linux.intel.com>
References: <20191104200141.5385-1-jarkko.sakkinen@linux.intel.com>
 <20191104204602.GA5960@linux.intel.com>
 <20191104222658.GA3606@linux.intel.com>
 <20191105021720.GE5960@linux.intel.com>
 <20191106215438.GA8715@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191106215438.GA8715@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Nov 06, 2019 at 11:54:38PM +0200, Jarkko Sakkinen wrote:
> On Mon, Nov 04, 2019 at 06:17:20PM -0800, Sean Christopherson wrote:
> > On Tue, Nov 05, 2019 at 12:26:58AM +0200, Jarkko Sakkinen wrote:
> > > On Mon, Nov 04, 2019 at 12:46:02PM -0800, Sean Christopherson wrote:
> > > > On Mon, Nov 04, 2019 at 10:01:39PM +0200, Jarkko Sakkinen wrote:
> > > > > The reasoning is the same as in
> > > > > 
> > > > > http://git.infradead.org/users/jjs/linux-tpmdd.git/commit/abd55954f91a3aacc1d260d2411cf776ec4d5fd2
> > > > > 
> > > > > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > > > > ---
> > > > >  arch/x86/kernel/cpu/sgx/ioctl.c | 4 ++--
> > > > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > > > 
> > > > > diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
> > > > > index 5b28a9c0cb68..d53aee5a64c1 100644
> > > > > --- a/arch/x86/kernel/cpu/sgx/ioctl.c
> > > > > +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
> > > > > @@ -259,7 +259,7 @@ static long sgx_ioc_enclave_create(struct sgx_encl *encl, void __user *arg)
> > > > >  	if (copy_from_user(&ecreate, arg, sizeof(ecreate)))
> > > > >  		return -EFAULT;
> > > > >  
> > > > > -	secs_page = alloc_page(GFP_HIGHUSER);
> > > > > +	secs_page = alloc_page(GFP_KERNEL);
> > > > >  	if (!secs_page)
> > > > >  		return -ENOMEM;
> > > > >  
> > > > > @@ -674,7 +674,7 @@ static long sgx_ioc_enclave_init(struct sgx_encl *encl, void __user *arg)
> > > > >  	if (copy_from_user(&einit, arg, sizeof(einit)))
> > > > >  		return -EFAULT;
> > > > >  
> > > > > -	initp_page = alloc_page(GFP_HIGHUSER);
> > > > > +	initp_page = alloc_page(GFP_KERNEL);
> > > > 
> > > > Would it make sense to use GFP_KERNEL_ACCOUNT?  The accounting would be
> > > > weird for the case where userspace is using a builder process, but even in
> > > > that case it's not flat out wrong to account per-enclave memory allocations.
> > > 
> > > I did not find a single call site that would use that for allocating
> > > memory for function-internal data.
> > 
> > Actually, the fact that the allocations are transient is an even better
> > argument for accounting the memory, as the weirdness I was referring to
> > doesn't exist for the builder concept.
> > 
> > But looking more closely, Documentation/core-api/memory-allocation.rst
> > states:
> > 
> >   * Untrusted allocations triggered from userspace should be a subject
> >     of kmem accounting and must have ``__GFP_ACCOUNT`` bit set. There
> >     is the handy ``GFP_KERNEL_ACCOUNT`` shortcut for ``GFP_KERNEL``
> >     allocations that should be accounted.
> > 
> > That means all uses of GFP_KERNEL except in sgx_alloc_epc_section() should
> > be converted to GFP_KERNEL_ACCOUNTED.  As is, depending on fd limits[*], a
> > single process can easily burn through multiple GBs of memory simply by
> > opening /dev/sgx/enclave in a loop.
> 
> What does the documentation mean by untrusted allocaton?
> 
> __GFP_ACCOUNT kernel and GFP_KERNEL_ACCOUNT are both quite alien flags
> to me as is kmemcg. Things that I know that exist but have never had to
> deal with them.
> 
> Looking at the kernel source code they rarely get used. Many drivers
> have process bound data structures but none of the drivers use these
> flags. I'm wondering why.
> 
> Why sgx_alloc_epc_section() is a use case given that it is something
> that allocates memory for the global EPC database?
> 
> > [*] AFAICT, systemd is upping the max number of open files to 1M on my
> >     systems.  I don't _think_ I changed a setting anywhere?

Anyway, the tree is now updated:

diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 5b82670bb79a..d53aee5a64c1 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -259,7 +259,7 @@ static long sgx_ioc_enclave_create(struct sgx_encl *encl, void __user *arg)
 	if (copy_from_user(&ecreate, arg, sizeof(ecreate)))
 		return -EFAULT;

-	secs_page = alloc_page(GFP_HIGHUSER);
+	secs_page = alloc_page(GFP_KERNEL);
 	if (!secs_page)
 		return -ENOMEM;

@@ -427,12 +427,20 @@ static int sgx_encl_add_page(struct sgx_encl *encl,

 	if (addp->flags & SGX_PAGE_MEASURE) {
 		ret = __sgx_encl_extend(encl, epc_page);
-		if (ret)
+
+		/*
+		 * Destroy the enclave if EEXTEND fails, EADD can't be undone.
+		 * Note, destroy() also frees the resources for the added page.
+		 */
+		if (ret) {
 			sgx_encl_destroy(encl);
-		else
-			sgx_mark_page_reclaimable(encl_page->epc_page);
+			goto out_unlock;
+		}
 	}

+	sgx_mark_page_reclaimable(encl_page->epc_page);
+
+out_unlock:
 	mutex_unlock(&encl->lock);
 	up_read(&current->mm->mmap_sem);
 	return ret;
@@ -666,7 +674,7 @@ static long sgx_ioc_enclave_init(struct sgx_encl *encl, void __user *arg)
 	if (copy_from_user(&einit, arg, sizeof(einit)))
 		return -EFAULT;

-	initp_page = alloc_page(GFP_HIGHUSER);
+	initp_page = alloc_page(GFP_KERNEL);
 	if (!initp_page)
 		return -ENOMEM;

Hope that all the updates will be fairly localized :-)

/Jarkko
