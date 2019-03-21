Return-Path: <SRS0=6pva=RY=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65A37C43381
	for <linux-sgx@archiver.kernel.org>; Thu, 21 Mar 2019 15:02:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 34AA420850
	for <linux-sgx@archiver.kernel.org>; Thu, 21 Mar 2019 15:02:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727823AbfCUPC0 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 21 Mar 2019 11:02:26 -0400
Received: from mga18.intel.com ([134.134.136.126]:12909 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726551AbfCUPCZ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 21 Mar 2019 11:02:25 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Mar 2019 08:02:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,253,1549958400"; 
   d="scan'208";a="329373034"
Received: from dilu-mobl2.ccr.corp.intel.com (HELO localhost) ([10.249.254.184])
  by fmsmga006.fm.intel.com with ESMTP; 21 Mar 2019 08:02:16 -0700
Date:   Thu, 21 Mar 2019 17:02:15 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        akpm@linux-foundation.org, dave.hansen@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com
Subject: Re: [PATCH v19 19/27] x86/sgx: ptrace() support for the SGX driver
Message-ID: <20190321150215.GQ4603@linux.intel.com>
References: <20190317211456.13927-1-jarkko.sakkinen@linux.intel.com>
 <20190317211456.13927-20-jarkko.sakkinen@linux.intel.com>
 <20190319222201.GK25575@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190319222201.GK25575@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Mar 19, 2019 at 03:22:01PM -0700, Sean Christopherson wrote:
> On Sun, Mar 17, 2019 at 11:14:48PM +0200, Jarkko Sakkinen wrote:
> > Add VMA callbacks for ptrace() that can be used with debug enclaves.
> > With debug enclaves data can be read and write the memory word at a time
> > by using ENCLS(EDBGRD) and ENCLS(EDBGWR) leaf instructions.
> > 
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > ---
> >  arch/x86/kernel/cpu/sgx/encl.c | 97 ++++++++++++++++++++++++++++++++++
> >  1 file changed, 97 insertions(+)
> > 
> > diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
> > index 1b8874699dd3..5b5fc933ee19 100644
> > --- a/arch/x86/kernel/cpu/sgx/encl.c
> > +++ b/arch/x86/kernel/cpu/sgx/encl.c
> > @@ -256,10 +256,107 @@ static unsigned int sgx_vma_fault(struct vm_fault *vmf)
> >  	return ret;
> >  }
> >  
> > +static int sgx_edbgrd(struct sgx_encl *encl, struct sgx_encl_page *page,
> > +		      unsigned long addr, void *data)
> > +{
> > +	unsigned long offset;
> > +	int ret;
> > +
> > +	offset = addr & ~PAGE_MASK;
> > +
> > +	if ((page->desc & SGX_ENCL_PAGE_TCS) &&
> > +	    offset > offsetof(struct sgx_tcs, gs_limit))
> > +		return -ECANCELED;
> > +
> > +	ret = __edbgrd(sgx_epc_addr(page->epc_page) + offset, data);
> > +	if (ret)
> > +		return -EIO;
> > +
> > +	return 0;
> > +}
> > +
> > +static int sgx_edbgwr(struct sgx_encl *encl, struct sgx_encl_page *page,
> > +		      unsigned long addr, void *data)
> > +{
> > +	unsigned long offset;
> > +	int ret;
> > +
> > +	offset = addr & ~PAGE_MASK;
> > +
> > +	/* Writing anything else than flags will cause #GP */
> > +	if ((page->desc & SGX_ENCL_PAGE_TCS) &&
> > +	    offset != offsetof(struct sgx_tcs, flags))
> > +		return -ECANCELED;
> > +
> > +	ret = __edbgwr(sgx_epc_addr(page->epc_page) + offset, data);
> > +	if (ret)
> > +		return -EIO;
> > +
> > +	return 0;
> > +}
> > +
> > +static int sgx_vma_access(struct vm_area_struct *vma, unsigned long addr,
> > +			  void *buf, int len, int write)
> > +{
> > +	struct sgx_encl *encl = vma->vm_private_data;
> > +	struct sgx_encl_page *entry = NULL;
> > +	unsigned long align;
> > +	char data[sizeof(unsigned long)];
> > +	int offset;
> > +	int cnt;
> > +	int ret = 0;
> > +	int i;
> > +
> > +	/* If process was forked, VMA is still there but vm_private_data is set
> > +	 * to NULL.
> > +	 */
> > +	if (!encl)
> > +		return -EFAULT;
> > +
> > +	if (!(encl->flags & SGX_ENCL_DEBUG) ||
> > +	    !(encl->flags & SGX_ENCL_INITIALIZED) ||
> > +	    (encl->flags & SGX_ENCL_DEAD))
> > +		return -EFAULT;
> > +
> > +	for (i = 0; i < len; i += cnt) {
> > +		entry = sgx_encl_reserve_page(encl, (addr + i) & PAGE_MASK);
> 
> Taking a lock indirectly via sgx_encl_reserve_page() and releasing it
> directly via mutex_unlock() is a bit difficult to follow, having a helper
> to pair up with sgx_encl_reserve_page() would be more readable.  Open
> coding sgx_encl_reserve_page() would probably be even better since this
> is the only user AFAICT.
> 
> All that being said, I prefer the old approach of marking the page RESERVED
> instead of holding the enclave's lock, even though it was slightly more
> complex.

For me the big rationale is to minimize the amount of state in the
context of this patch set. And this approach should work just fine.

/Jarkko
