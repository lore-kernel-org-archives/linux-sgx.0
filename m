Return-Path: <SRS0=DpJx=UD=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34CA4C282CE
	for <linux-sgx@archiver.kernel.org>; Tue,  4 Jun 2019 16:23:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 053C620693
	for <linux-sgx@archiver.kernel.org>; Tue,  4 Jun 2019 16:23:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728280AbfFDQXT (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 4 Jun 2019 12:23:19 -0400
Received: from mga04.intel.com ([192.55.52.120]:48308 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728270AbfFDQXS (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 4 Jun 2019 12:23:18 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Jun 2019 09:23:17 -0700
X-ExtLoop1: 1
Received: from tvuori-mobl1.ger.corp.intel.com (HELO localhost) ([10.251.93.210])
  by fmsmga007.fm.intel.com with ESMTP; 04 Jun 2019 09:23:07 -0700
Date:   Tue, 4 Jun 2019 19:23:06 +0300
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
Subject: Re: [RFC PATCH 6/9] x86/sgx: Require userspace to provide allowed
 prots to ADD_PAGES
Message-ID: <20190604162306.GB3811@linux.intel.com>
References: <20190531233159.30992-1-sean.j.christopherson@intel.com>
 <20190531233159.30992-7-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190531233159.30992-7-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, May 31, 2019 at 04:31:56PM -0700, Sean Christopherson wrote:
> ...to support (the equivalent) of existing Linux Security Module
> functionality.

Long and short descriptions should be separate. Also this does not
make any sense. LSM is a framework with a set of hook to make access
decisions and there various implementations of it.

How this replicates LSMs and why that even would be a goal?

My guess is that you are trying to do something else. I'm just saying
that the idea to do equivalent of LSMs to another subsystems would be
insane if it was done.

> always be MAP_SHARED.  Lastly, all real world enclaves will need read,
> write and execute permissions to EPC pages.  As a result, SGX does not
> play nice with existing LSM behavior as it is impossible to apply
> policies to enclaves with any reasonable granularity, e.g. an LSM can
> deny access to EPC altogether, but can't deny potentially dangerous
> behavior such as mapping pages RW->RW or RWX.

The mapping must be shared given that it is iomem but why enclave pages
would need RWX for all pages? The information that is missing from this
paragraph is the explanation why an LSM could not deny dangerous
behavior in PTE level.

> To give LSMs enough information to implement their policies without
> having to resort to ugly things, e.g. holding a reference to the vm_file
> of each enclave page, require userspace to explicitly state the allowed
> protections for each page (region), i.e. take ALLOW_{READ,WRITE,EXEC}
> in the ADD_PAGES ioctl.

I would keep descriptions such as "ugly things" away from commit
messages as it is easy way to be not clear and explicit what you are
trying to say.

> The ALLOW_* flags will be passed to LSMs so that they can make informed
> decisions when the enclave is being built, i.e. when the source vm_file
> is available.  For example, SELinux's EXECMOD permission can be
> required if an enclave is requesting both ALLOW_WRITE and ALLOW_EXEC.

There should be some explanation what ALLOW_* flag are. It is now like
as it was in common knowledge. SECINFO already has protection flags to
name an example and without any explanation all of this is just very
confusing.

This should address SECINFO and ALLOW_* relationship and differences.

> Update the mmap()/mprotect() hooks to enforce the ALLOW_* protections,
> a la the standard VM_MAY{READ,WRITE,EXEC} flags.
> 
> The ALLOW_EXEC flag also has a second (important) use in that it can
> be used to prevent loading an enclave from a noexec file system, on
> SGX2 hardware (regardless of kernel support for SGX2), userspace could
> EADD from a noexec path using read-only permissions and later mprotect()
> and ENCLU[EMODPE] the page to gain execute permissions.  By requiring
> ALLOW_EXEC up front, SGX will be able to enforce noexec paths when
> building the enclave.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/include/uapi/asm/sgx.h        |  9 ++++++++-
>  arch/x86/kernel/cpu/sgx/driver/ioctl.c | 23 +++++++++++++++++------
>  arch/x86/kernel/cpu/sgx/encl.c         |  2 +-
>  arch/x86/kernel/cpu/sgx/encl.h         |  1 +
>  4 files changed, 27 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
> index 4a12d6abbcb7..4489e92fa0dc 100644
> --- a/arch/x86/include/uapi/asm/sgx.h
> +++ b/arch/x86/include/uapi/asm/sgx.h
> @@ -31,6 +31,11 @@ struct sgx_enclave_create  {
>  	__u64	src;
>  };
>  
> +/* Supported flags for struct sgx_enclave_add_pages. */
> +#define SGX_ALLOW_READ	VM_READ
> +#define SGX_ALLOW_WRITE	VM_WRITE
> +#define SGX_ALLOW_EXEC	VM_EXEC

Why these flags are even defined if they are the same as VM_* flags?

> +
>  /**
>   * struct sgx_enclave_add_pages - parameter structure for the
>   *                                %SGX_IOC_ENCLAVE_ADD_PAGES ioctl
> @@ -39,6 +44,7 @@ struct sgx_enclave_create  {
>   * @secinfo:	address for the SECINFO data (common to all pages)
>   * @nr_pages:	number of pages (must be virtually contiguous)
>   * @mrmask:	bitmask for the measured 256 byte chunks (common to all pages)
> + * @flags:	flags, e.g. SGX_ALLOW_{READ,WRITE,EXEC} (common to all pages)
>   */
>  struct sgx_enclave_add_pages {
>  	__u64	addr;
> @@ -46,7 +52,8 @@ struct sgx_enclave_add_pages {
>  	__u64	secinfo;
>  	__u32	nr_pages;
>  	__u16	mrmask;
> -} __attribute__((__packed__));
> +	__u16	flags;
> +};
>  
>  /**
>   * struct sgx_enclave_init - parameter structure for the
> diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> index 6acfcbdeca9a..c30acd3fbbdd 100644
> --- a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> +++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> @@ -235,7 +235,8 @@ static int sgx_validate_secs(const struct sgx_secs *secs,
>  }
>  
>  static struct sgx_encl_page *sgx_encl_page_alloc(struct sgx_encl *encl,
> -						 unsigned long addr)
> +						 unsigned long addr,
> +						 unsigned long allowed_prot)
>  {
>  	struct sgx_encl_page *encl_page;
>  	int ret;
> @@ -247,6 +248,7 @@ static struct sgx_encl_page *sgx_encl_page_alloc(struct sgx_encl *encl,
>  		return ERR_PTR(-ENOMEM);
>  	encl_page->desc = addr;
>  	encl_page->encl = encl;
> +	encl_page->allowed_prot = allowed_prot;
>  	ret = radix_tree_insert(&encl->page_tree, PFN_DOWN(encl_page->desc),
>  				encl_page);
>  	if (ret) {
> @@ -530,7 +532,7 @@ static int sgx_encl_queue_page(struct sgx_encl *encl,
>  
>  static int __sgx_encl_add_page(struct sgx_encl *encl, unsigned long addr,
>  			       void *data, struct sgx_secinfo *secinfo,
> -			       unsigned int mrmask)
> +			       unsigned int mrmask, unsigned long allowed_prot)
>  {
>  	u64 page_type = secinfo->flags & SGX_SECINFO_PAGE_TYPE_MASK;
>  	struct sgx_encl_page *encl_page;
> @@ -556,7 +558,7 @@ static int __sgx_encl_add_page(struct sgx_encl *encl, unsigned long addr,
>  		goto out;
>  	}
>  
> -	encl_page = sgx_encl_page_alloc(encl, addr);
> +	encl_page = sgx_encl_page_alloc(encl, addr, allowed_prot);
>  	if (IS_ERR(encl_page)) {
>  		ret = PTR_ERR(encl_page);
>  		goto out;
> @@ -576,12 +578,20 @@ static int __sgx_encl_add_page(struct sgx_encl *encl, unsigned long addr,
>  
>  static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long addr,
>  			     unsigned long src, struct sgx_secinfo *secinfo,
> -			     unsigned int mrmask)
> +			     unsigned int mrmask, unsigned int flags)
>  {
> +	unsigned long prot = secinfo->flags & (VM_READ | VM_WRITE | VM_EXEC);

Even if the secinfo flags have the exactly the same values you should
not do this as they are kind of from different type. This is confusing
to read.

> +	unsigned long allowed_prot = flags & (VM_READ | VM_WRITE | VM_EXEC);

Why you take the trouble defining those macros and do not then use them
even yourself?

>  	struct page *data_page;
>  	void *data;
>  	int ret;
>  
> +	BUILD_BUG_ON(SGX_SECINFO_R != VM_READ || SGX_SECINFO_W != VM_WRITE ||
> +		     SGX_SECINFO_X != VM_EXEC);

Why this check?

> +
> +	if (prot & ~allowed_prot)
> +		return -EACCES;
> +
>  	data_page = alloc_page(GFP_HIGHUSER);
>  	if (!data_page)
>  		return -ENOMEM;
> @@ -593,7 +603,8 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long addr,
>  		goto out;
>  	}
>  
> -	ret = __sgx_encl_add_page(encl, addr, data, secinfo, mrmask);
> +	ret = __sgx_encl_add_page(encl, addr, data, secinfo, mrmask,
> +				  allowed_prot);
>  out:
>  	kunmap(data_page);
>  	__free_page(data_page);
> @@ -645,7 +656,7 @@ static long sgx_ioc_enclave_add_pages(struct file *filep, unsigned int cmd,
>  
>  		ret = sgx_encl_add_page(encl, addp->addr + i*PAGE_SIZE,
>  					addp->src + i*PAGE_SIZE,
> -					&secinfo, addp->mrmask);
> +					&secinfo, addp->mrmask, addp->flags);
>  	}
>  	return ret;
>  }
> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> index 955d4f430adc..e5847571a265 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -249,7 +249,7 @@ int sgx_map_allowed(struct sgx_encl *encl, unsigned long start,
>  
>  	for (addr = start; addr < end; addr += PAGE_SIZE) {
>  		page = radix_tree_lookup(&encl->page_tree, addr >> PAGE_SHIFT);
> -		if (!page)
> +		if (!page || (prot & ~page->allowed_prot))
>  			return -EACCES;
>  	}

However this goes it would be good idea to have only ony patch in the
patch set that fully defines this function. Impossible to review
properly with this split.

>  
> 
> diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
> index 6e310e3b3fff..7cca076a4987 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.h
> +++ b/arch/x86/kernel/cpu/sgx/encl.h
> @@ -41,6 +41,7 @@ enum sgx_encl_page_desc {
>  
>  struct sgx_encl_page {
>  	unsigned long desc;
> +	unsigned long allowed_prot;
>  	struct sgx_epc_page *epc_page;
>  	struct sgx_va_page *va_page;
>  	struct sgx_encl *encl;
> -- 
> 2.21.0
> 

This patch left me very confused. I don't get it.

/Jarkko
