Return-Path: <SRS0=ABp+=Y5=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A464C5DF60
	for <linux-sgx@archiver.kernel.org>; Tue,  5 Nov 2019 22:52:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E7784206BA
	for <linux-sgx@archiver.kernel.org>; Tue,  5 Nov 2019 22:52:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730184AbfKEWwY (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 5 Nov 2019 17:52:24 -0500
Received: from mga09.intel.com ([134.134.136.24]:21897 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730054AbfKEWwX (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 5 Nov 2019 17:52:23 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Nov 2019 14:52:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,271,1569308400"; 
   d="scan'208";a="285471803"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga001.jf.intel.com with ESMTP; 05 Nov 2019 14:52:23 -0800
Date:   Tue, 5 Nov 2019 14:52:23 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for v24 v2 4/4] x86/sgx: add @count to
 &sgx_enclave_add_pages
Message-ID: <20191105225223.GC23297@linux.intel.com>
References: <20191105112056.21452-1-jarkko.sakkinen@linux.intel.com>
 <20191105112056.21452-4-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191105112056.21452-4-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Nov 05, 2019 at 01:20:56PM +0200, Jarkko Sakkinen wrote:
> Add @count write the number of bytes added as there is not any good reason
> to overwrite input parameters.

I disagree, overwriting the params means userspace doesn't need to adjust
the values to restart the ioctl().  Ditto for printing out the failing
address if the ioctl() fails.

> Also, three parameters are unnecessarily
> overwritten as the amount of change is the same for each of them.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  arch/x86/include/uapi/asm/sgx.h |  2 ++
>  arch/x86/kernel/cpu/sgx/ioctl.c | 17 ++++++-----------
>  2 files changed, 8 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
> index 88644b6ad849..e196cfd44b70 100644
> --- a/arch/x86/include/uapi/asm/sgx.h
> +++ b/arch/x86/include/uapi/asm/sgx.h
> @@ -45,6 +45,7 @@ struct sgx_enclave_create  {
>   * @length:	length of the data (multiple of the page size)
>   * @secinfo:	address for the SECINFO data
>   * @flags:	page control flags
> + * @count:	number of bytes added (multiple of the page size)
>   */
>  struct sgx_enclave_add_pages {
>  	__u64	src;
> @@ -52,6 +53,7 @@ struct sgx_enclave_add_pages {
>  	__u64	length;
>  	__u64	secinfo;
>  	__u64	flags;
> +	__u64	count;
>  };
>  
>  /**
> diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
> index deca49bd4f58..e8697d145dfb 100644
> --- a/arch/x86/kernel/cpu/sgx/ioctl.c
> +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
> @@ -491,11 +491,6 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long src,
>   * permissions. In effect, this allows mmap() with PROT_NONE to be used to seek
>   * an address range for the enclave that can be then populated into SECS.
>   *
> - * @arg->addr, @arg->src and @arg->length are adjusted to reflect the
> - * remaining pages that need to be added to the enclave, e.g. userspace can
> - * re-invoke SGX_IOC_ENCLAVE_ADD_PAGES using the same struct in response to an
> - * ERESTARTSYS error.
> - *
>   * Return:
>   *   0 on success,
>   *   -EACCES if an executable source page is located in a noexec partition,
> @@ -506,6 +501,7 @@ static long sgx_ioc_enclave_add_pages(struct sgx_encl *encl, void __user *arg)
>  {
>  	struct sgx_enclave_add_pages addp;
>  	struct sgx_secinfo secinfo;
> +	unsigned long c;
>  	int ret;
>  
>  	if (!(atomic_read(&encl->flags) & SGX_ENCL_CREATED))
> @@ -534,7 +530,7 @@ static long sgx_ioc_enclave_add_pages(struct sgx_encl *encl, void __user *arg)
>  	if (sgx_validate_secinfo(&secinfo))
>  		return -EINVAL;
>  
> -	for ( ; addp.length > 0; addp.length -= PAGE_SIZE) {
> +	for (c = 0 ; c < addp.length; c += PAGE_SIZE) {
>  		if (signal_pending(current)) {
>  			ret = -ERESTARTSYS;
>  			break;
> @@ -543,15 +539,14 @@ static long sgx_ioc_enclave_add_pages(struct sgx_encl *encl, void __user *arg)
>  		if (need_resched())
>  			cond_resched();
>  
> -		ret = sgx_encl_add_page(encl, addp.src, addp.offset,
> -					addp.length, &secinfo, addp.flags);
> +		ret = sgx_encl_add_page(encl, addp.src + c, addp.offset + c,
> +					addp.length - c, &secinfo, addp.flags);
>  		if (ret)
>  			break;
> -
> -		addp.offset += PAGE_SIZE;
> -		addp.src += PAGE_SIZE;
>  	}
>  
> +	addp.count = c;
> +
>  	if (copy_to_user(arg, &addp, sizeof(addp)))
>  		return -EFAULT;
>  
> -- 
> 2.20.1
> 
