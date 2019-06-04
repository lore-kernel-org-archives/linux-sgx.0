Return-Path: <SRS0=DpJx=UD=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32FEAC282CE
	for <linux-sgx@archiver.kernel.org>; Tue,  4 Jun 2019 15:32:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FE1B2190D
	for <linux-sgx@archiver.kernel.org>; Tue,  4 Jun 2019 15:32:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728002AbfFDPc0 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 4 Jun 2019 11:32:26 -0400
Received: from mga06.intel.com ([134.134.136.31]:2019 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727972AbfFDPc0 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 4 Jun 2019 11:32:26 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Jun 2019 08:32:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,550,1549958400"; 
   d="scan'208";a="181589010"
Received: from tvuori-mobl1.ger.corp.intel.com (HELO localhost) ([10.251.93.210])
  by fmsmga002.fm.intel.com with ESMTP; 04 Jun 2019 08:32:16 -0700
Date:   Tue, 4 Jun 2019 18:32:15 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Cedric Xing <cedric.xing@intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>, selinux@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        linux-sgx@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, nhorman@redhat.com,
        npmccallum@redhat.com, Serge Ayoun <serge.ayoun@intel.com>,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Haitao Huang <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Kai Svahn <kai.svahn@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        Kai Huang <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>,
        William Roberts <william.c.roberts@intel.com>,
        Philip Tricca <philip.b.tricca@intel.com>
Subject: Re: [RFC PATCH 5/9] x86/sgx: Restrict mapping without an enclave
 page to PROT_NONE
Message-ID: <20190604153201.GA3811@linux.intel.com>
References: <20190531233159.30992-1-sean.j.christopherson@intel.com>
 <20190531233159.30992-6-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190531233159.30992-6-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, May 31, 2019 at 04:31:55PM -0700, Sean Christopherson wrote:
> To support LSM integration, SGX will require userspace to explicitly
> specify the allowed protections for each page.  The allowed protections
> will be supplied to and modified by LSMs (based on their policies).

How the allowed protections are modified by LSMs? AFAIK they don't touch
the PROT_* flags but I could be wrong too.

> To prevent userspace from circumventing the allowed protections, do not
> allow PROT_{READ,WRITE,EXEC} mappings to an enclave without an
> associated enclave page (which will track the allowed protections).
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/driver/main.c |  5 +++++
>  arch/x86/kernel/cpu/sgx/encl.c        | 30 +++++++++++++++++++++++++++
>  arch/x86/kernel/cpu/sgx/encl.h        |  3 +++
>  3 files changed, 38 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/driver/main.c b/arch/x86/kernel/cpu/sgx/driver/main.c
> index 129d356aff30..65a87c2fdf02 100644
> --- a/arch/x86/kernel/cpu/sgx/driver/main.c
> +++ b/arch/x86/kernel/cpu/sgx/driver/main.c
> @@ -63,6 +63,11 @@ static long sgx_compat_ioctl(struct file *filep, unsigned int cmd,
>  static int sgx_mmap(struct file *file, struct vm_area_struct *vma)
>  {
>  	struct sgx_encl *encl = file->private_data;
> +	int ret;
> +
> +	ret = sgx_map_allowed(encl, vma->vm_start, vma->vm_end, vma->vm_flags);
> +	if (ret)
> +		return ret;
>  
>  	vma->vm_ops = &sgx_vm_ops;
>  	vma->vm_flags |= VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP | VM_IO;
> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> index f23ea0fbaa47..955d4f430adc 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -235,6 +235,35 @@ static void sgx_vma_close(struct vm_area_struct *vma)
>  	kref_put(&encl->refcount, sgx_encl_release);
>  }
>  
> +int sgx_map_allowed(struct sgx_encl *encl, unsigned long start,
> +		    unsigned long end, unsigned long prot)

Documentation missing.

> +{
> +	struct sgx_encl_page *page;
> +	unsigned long addr;
> +
> +	prot &= (VM_READ | VM_WRITE | VM_EXEC);
> +	if (!prot || !encl)
> +		return 0;
> +
> +	mutex_lock(&encl->lock);
> +
> +	for (addr = start; addr < end; addr += PAGE_SIZE) {
> +		page = radix_tree_lookup(&encl->page_tree, addr >> PAGE_SHIFT);
> +		if (!page)
> +			return -EACCES;
> +	}
> +
> +	mutex_unlock(&encl->lock);
> +
> +	return 0;
> +}
> +
> +static int sgx_vma_mprotect(struct vm_area_struct *vma, unsigned long start,
> +			    unsigned long end, unsigned long prot)
> +{
> +	return sgx_map_allowed(vma->vm_private_data, start, end, prot);
> +}
> +
>  static unsigned int sgx_vma_fault(struct vm_fault *vmf)
>  {
>  	unsigned long addr = (unsigned long)vmf->address;
> @@ -372,6 +401,7 @@ static int sgx_vma_access(struct vm_area_struct *vma, unsigned long addr,
>  const struct vm_operations_struct sgx_vm_ops = {
>  	.close = sgx_vma_close,
>  	.open = sgx_vma_open,
> +	.mprotect = sgx_vma_mprotect,
>  	.fault = sgx_vma_fault,
>  	.access = sgx_vma_access,
>  };
> diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
> index c557f0374d74..6e310e3b3fff 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.h
> +++ b/arch/x86/kernel/cpu/sgx/encl.h
> @@ -106,6 +106,9 @@ static inline unsigned long sgx_pcmd_offset(pgoff_t page_index)
>  	       sizeof(struct sgx_pcmd);
>  }
>  
> +int sgx_map_allowed(struct sgx_encl *encl, unsigned long start,
> +		    unsigned long end, unsigned long prot);
> +
>  enum sgx_encl_mm_iter {
>  	SGX_ENCL_MM_ITER_DONE		= 0,
>  	SGX_ENCL_MM_ITER_NEXT		= 1,
> -- 
> 2.21.0

This is missing explanation why it is OK to have a mismatch between
the SECINFO flags and VM_* flags. Maybe that could be explained in
sgx_map_allowed() documentation.

/Jarkko
