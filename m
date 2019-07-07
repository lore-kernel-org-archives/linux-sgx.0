Return-Path: <SRS0=QGFU=VE=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 043ECC48BE1
	for <linux-sgx@archiver.kernel.org>; Sun,  7 Jul 2019 19:03:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC9422082F
	for <linux-sgx@archiver.kernel.org>; Sun,  7 Jul 2019 19:03:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727357AbfGGTDO (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 7 Jul 2019 15:03:14 -0400
Received: from mga14.intel.com ([192.55.52.115]:62680 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726044AbfGGTDO (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 7 Jul 2019 15:03:14 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Jul 2019 12:03:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,463,1557212400"; 
   d="scan'208";a="364025853"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.165])
  by fmsmga006.fm.intel.com with ESMTP; 07 Jul 2019 12:03:12 -0700
Date:   Sun, 7 Jul 2019 12:03:12 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org,
        Bill Roberts <william.c.roberts@intel.com>,
        Casey Schaufler <casey.schaufler@intel.com>,
        James Morris <jmorris@namei.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>,
        Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [RFC PATCH v4 05/12] x86/sgx: Enforce noexec filesystem
 restriction for enclaves
Message-ID: <20190707190312.GD19593@linux.intel.com>
References: <20190619222401.14942-1-sean.j.christopherson@intel.com>
 <20190619222401.14942-6-sean.j.christopherson@intel.com>
 <20190621012654.GI20474@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190621012654.GI20474@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Jun 21, 2019 at 04:26:54AM +0300, Jarkko Sakkinen wrote:
> On Wed, Jun 19, 2019 at 03:23:54PM -0700, Sean Christopherson wrote:
> > Do not allow an enclave page to be mapped with PROT_EXEC if the source
> > vma does not have VM_MAYEXEC.  This effectively enforces noexec as
> > do_mmap() clears VM_MAYEXEC if the vma is being loaded from a noexec
> > path, i.e. prevents executing a file by loading it into an enclave.
> > 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >  arch/x86/kernel/cpu/sgx/driver/ioctl.c | 42 +++++++++++++++++++++++---
> >  1 file changed, 37 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> > index e18d2afd2aad..1fca70a36ce3 100644
> > --- a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> > +++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> > @@ -564,6 +564,39 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long addr,
> >  	return ret;
> >  }
> >  
> > +static int sgx_encl_page_copy(void *dst, unsigned long src, unsigned long prot)
> 
> I will probably forget the context with this name after this has been
> merged :-) So many functions dealing with enclave pages. Two
> alternatives that come up to my mind:
> 
> 1. sgx_encl_page_user_import()
> 2. sgx_encl_page_user_copy_from()

What about sgx_encl_page_copy_from_user() to align with copy_from_user()?
 
> Not saying that they are beatiful names but at least you immediately
> know the context.
> 
> > +{
> > +	struct vm_area_struct *vma;
> > +	int ret;
> > +
> > +	/* Hold mmap_sem across copy_from_user() to avoid a TOCTOU race. */
> > +	down_read(&current->mm->mmap_sem);
> > +
> > +	/* Query vma's VM_MAYEXEC as an indirect path_noexec() check. */
> > +	if (prot & PROT_EXEC) {
> > +		vma = find_vma(current->mm, src);
> > +		if (!vma) {
> > +			ret = -EFAULT;
> > +			goto out;
> 
> Should this be -EINVAL instead?

copy_from_user() failure is handled via -EFAULT, this is effectively an
equivalent check.
