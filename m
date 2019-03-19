Return-Path: <SRS0=vqpH=RW=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E50A7C43381
	for <linux-sgx@archiver.kernel.org>; Tue, 19 Mar 2019 22:22:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8DE12175B
	for <linux-sgx@archiver.kernel.org>; Tue, 19 Mar 2019 22:22:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726875AbfCSWWC (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 19 Mar 2019 18:22:02 -0400
Received: from mga01.intel.com ([192.55.52.88]:13240 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726851AbfCSWWC (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 19 Mar 2019 18:22:02 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Mar 2019 15:22:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,246,1549958400"; 
   d="scan'208";a="124073261"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.181])
  by orsmga007.jf.intel.com with ESMTP; 19 Mar 2019 15:22:01 -0700
Date:   Tue, 19 Mar 2019 15:22:01 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        akpm@linux-foundation.org, dave.hansen@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com
Subject: Re: [PATCH v19 19/27] x86/sgx: ptrace() support for the SGX driver
Message-ID: <20190319222201.GK25575@linux.intel.com>
References: <20190317211456.13927-1-jarkko.sakkinen@linux.intel.com>
 <20190317211456.13927-20-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190317211456.13927-20-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sun, Mar 17, 2019 at 11:14:48PM +0200, Jarkko Sakkinen wrote:
> Add VMA callbacks for ptrace() that can be used with debug enclaves.
> With debug enclaves data can be read and write the memory word at a time
> by using ENCLS(EDBGRD) and ENCLS(EDBGWR) leaf instructions.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/encl.c | 97 ++++++++++++++++++++++++++++++++++
>  1 file changed, 97 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> index 1b8874699dd3..5b5fc933ee19 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -256,10 +256,107 @@ static unsigned int sgx_vma_fault(struct vm_fault *vmf)
>  	return ret;
>  }
>  
> +static int sgx_edbgrd(struct sgx_encl *encl, struct sgx_encl_page *page,
> +		      unsigned long addr, void *data)
> +{
> +	unsigned long offset;
> +	int ret;
> +
> +	offset = addr & ~PAGE_MASK;
> +
> +	if ((page->desc & SGX_ENCL_PAGE_TCS) &&
> +	    offset > offsetof(struct sgx_tcs, gs_limit))
> +		return -ECANCELED;
> +
> +	ret = __edbgrd(sgx_epc_addr(page->epc_page) + offset, data);
> +	if (ret)
> +		return -EIO;
> +
> +	return 0;
> +}
> +
> +static int sgx_edbgwr(struct sgx_encl *encl, struct sgx_encl_page *page,
> +		      unsigned long addr, void *data)
> +{
> +	unsigned long offset;
> +	int ret;
> +
> +	offset = addr & ~PAGE_MASK;
> +
> +	/* Writing anything else than flags will cause #GP */
> +	if ((page->desc & SGX_ENCL_PAGE_TCS) &&
> +	    offset != offsetof(struct sgx_tcs, flags))
> +		return -ECANCELED;
> +
> +	ret = __edbgwr(sgx_epc_addr(page->epc_page) + offset, data);
> +	if (ret)
> +		return -EIO;
> +
> +	return 0;
> +}
> +
> +static int sgx_vma_access(struct vm_area_struct *vma, unsigned long addr,
> +			  void *buf, int len, int write)
> +{
> +	struct sgx_encl *encl = vma->vm_private_data;
> +	struct sgx_encl_page *entry = NULL;
> +	unsigned long align;
> +	char data[sizeof(unsigned long)];
> +	int offset;
> +	int cnt;
> +	int ret = 0;
> +	int i;
> +
> +	/* If process was forked, VMA is still there but vm_private_data is set
> +	 * to NULL.
> +	 */
> +	if (!encl)
> +		return -EFAULT;
> +
> +	if (!(encl->flags & SGX_ENCL_DEBUG) ||
> +	    !(encl->flags & SGX_ENCL_INITIALIZED) ||
> +	    (encl->flags & SGX_ENCL_DEAD))
> +		return -EFAULT;
> +
> +	for (i = 0; i < len; i += cnt) {
> +		entry = sgx_encl_reserve_page(encl, (addr + i) & PAGE_MASK);

Taking a lock indirectly via sgx_encl_reserve_page() and releasing it
directly via mutex_unlock() is a bit difficult to follow, having a helper
to pair up with sgx_encl_reserve_page() would be more readable.  Open
coding sgx_encl_reserve_page() would probably be even better since this
is the only user AFAICT.

All that being said, I prefer the old approach of marking the page RESERVED
instead of holding the enclave's lock, even though it was slightly more
complex.

> +		if (IS_ERR(entry)) {
> +			ret = PTR_ERR(entry);
> +			break;
> +		}
> +
> +		align = ALIGN_DOWN(addr + i, sizeof(unsigned long));
> +		offset = (addr + i) & (sizeof(unsigned long) - 1);
> +		cnt = sizeof(unsigned long) - offset;
> +		cnt = min(cnt, len - i);
> +
> +		ret = sgx_edbgrd(encl, entry, align, data);
> +		if (ret)
> +			goto out;
> +
> +		if (write) {
> +			memcpy(data + offset, buf + i, cnt);
> +			ret = sgx_edbgwr(encl, entry, align, data);
> +			if (ret)
> +				goto out;
> +		} else
> +			memcpy(buf + i, data + offset, cnt);
> +
> +out:
> +		mutex_unlock(&encl->lock);
> +
> +		if (ret)
> +			break;
> +	}
> +
> +	return ret < 0 ? ret : i;
> +}
> +
>  const struct vm_operations_struct sgx_vm_ops = {
>  	.close = sgx_vma_close,
>  	.open = sgx_vma_open,
>  	.fault = sgx_vma_fault,
> +	.access = sgx_vma_access,
>  };
>  EXPORT_SYMBOL_GPL(sgx_vm_ops);
>  
> -- 
> 2.19.1
> 
