Return-Path: <SRS0=8b/w=UU=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E939C43613
	for <linux-sgx@archiver.kernel.org>; Fri, 21 Jun 2019 01:49:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E3F72064B
	for <linux-sgx@archiver.kernel.org>; Fri, 21 Jun 2019 01:49:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725936AbfFUBt2 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 20 Jun 2019 21:49:28 -0400
Received: from mga06.intel.com ([134.134.136.31]:4923 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725906AbfFUBt1 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 20 Jun 2019 21:49:27 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Jun 2019 18:27:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,398,1557212400"; 
   d="scan'208";a="335677470"
Received: from mudigirx-mobl1.gar.corp.intel.com (HELO localhost) ([10.252.61.12])
  by orsmga005.jf.intel.com with ESMTP; 20 Jun 2019 18:26:56 -0700
Date:   Fri, 21 Jun 2019 04:26:54 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
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
Message-ID: <20190621012654.GI20474@linux.intel.com>
References: <20190619222401.14942-1-sean.j.christopherson@intel.com>
 <20190619222401.14942-6-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190619222401.14942-6-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jun 19, 2019 at 03:23:54PM -0700, Sean Christopherson wrote:
> Do not allow an enclave page to be mapped with PROT_EXEC if the source
> vma does not have VM_MAYEXEC.  This effectively enforces noexec as
> do_mmap() clears VM_MAYEXEC if the vma is being loaded from a noexec
> path, i.e. prevents executing a file by loading it into an enclave.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/driver/ioctl.c | 42 +++++++++++++++++++++++---
>  1 file changed, 37 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> index e18d2afd2aad..1fca70a36ce3 100644
> --- a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> +++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> @@ -564,6 +564,39 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long addr,
>  	return ret;
>  }
>  
> +static int sgx_encl_page_copy(void *dst, unsigned long src, unsigned long prot)

I will probably forget the context with this name after this has been
merged :-) So many functions dealing with enclave pages. Two
alternatives that come up to my mind:

1. sgx_encl_page_user_import()
2. sgx_encl_page_user_copy_from()

Not saying that they are beatiful names but at least you immediately
know the context.

> +{
> +	struct vm_area_struct *vma;
> +	int ret;
> +
> +	/* Hold mmap_sem across copy_from_user() to avoid a TOCTOU race. */
> +	down_read(&current->mm->mmap_sem);
> +
> +	/* Query vma's VM_MAYEXEC as an indirect path_noexec() check. */
> +	if (prot & PROT_EXEC) {
> +		vma = find_vma(current->mm, src);
> +		if (!vma) {
> +			ret = -EFAULT;
> +			goto out;

Should this be -EINVAL instead?

/Jarkko
