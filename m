Return-Path: <SRS0=NOB7=AP=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D992AC433E1
	for <linux-sgx@archiver.kernel.org>; Sat,  4 Jul 2020 00:14:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA7E320739
	for <linux-sgx@archiver.kernel.org>; Sat,  4 Jul 2020 00:14:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbgGDAOS (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 3 Jul 2020 20:14:18 -0400
Received: from mga17.intel.com ([192.55.52.151]:2517 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726791AbgGDAOQ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 3 Jul 2020 20:14:16 -0400
IronPort-SDR: lTM1D0B/e4ZMvNQh7TblpAW4C2ByE74QpELwGlTlP92oAsGYKsAabTQIPCC9ZWa1r8ORbaakd2
 KreFC7kNyGDg==
X-IronPort-AV: E=McAfee;i="6000,8403,9671"; a="127298621"
X-IronPort-AV: E=Sophos;i="5.75,309,1589266800"; 
   d="scan'208";a="127298621"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2020 17:14:12 -0700
IronPort-SDR: eJRY+1ecntHBpMZOJLiwjmRRhQug3fIxAxxrHFfZROzbKRy3v+MCRA/X9gQ7+0QAOltKukiwEg
 N+Y8L65KMHiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,309,1589266800"; 
   d="scan'208";a="456036891"
Received: from ntohan-mobl.ger.corp.intel.com (HELO localhost) ([10.252.53.15])
  by orsmga005.jf.intel.com with ESMTP; 03 Jul 2020 17:13:57 -0700
Date:   Sat, 4 Jul 2020 03:13:56 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        tglx@linutronix.de, yaozhangx@google.com
Subject: Re: [PATCH v33 11/21] x86/sgx: Linux Enclave Driver
Message-ID: <20200704001356.GB104749@linux.intel.com>
References: <20200617220844.57423-1-jarkko.sakkinen@linux.intel.com>
 <20200617220844.57423-12-jarkko.sakkinen@linux.intel.com>
 <20200626153400.GE27151@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200626153400.GE27151@zn.tnic>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Jun 26, 2020 at 05:34:00PM +0200, Borislav Petkov wrote:
> On Thu, Jun 18, 2020 at 01:08:33AM +0300, Jarkko Sakkinen wrote:
> 
> ...
> 
> This could use some commenting along the lines of:
> 
> "— If the enclave developer requires measurement of the page as a
> proof for the content, use EEXTEND to add a measurement for 256 bytes of
> the page. Repeat this operation until the entire page is measured."
> 
> At least this text from the SDM maps to the 256 bytes below. Otherwise
> it is magic.

Copied with pride:

/*
 * If the caller requires measurement of the page as a proof for the content,
 * use EEXTEND to add a measurement for 256 bytes of the page. Repeat this
 * operation until the entire page is measured."
 */

> > +static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long src,
> > +			     unsigned long offset, unsigned long length,
> > +			     struct sgx_secinfo *secinfo, unsigned long flags)
> > +{
> > +	struct sgx_encl_page *encl_page;
> > +	struct sgx_epc_page *epc_page;
> > +	int ret;
> > +
> > +	encl_page = sgx_encl_page_alloc(encl, offset, secinfo->flags);
> > +	if (IS_ERR(encl_page))
> > +		return PTR_ERR(encl_page);
> > +
> > +	epc_page = __sgx_alloc_epc_page();
> > +	if (IS_ERR(epc_page)) {
> > +		kfree(encl_page);
> > +		return PTR_ERR(epc_page);
> > +	}
> > +
> > +	if (atomic_read(&encl->flags) &
> > +	    (SGX_ENCL_INITIALIZED | SGX_ENCL_DEAD)) {
> > +		ret = -EFAULT;
> > +		goto err_out_free;
> > +	}
> 
> You can do this first thing when you enter the function so that
> you don't have to allocate needlessly in the error case, when
> SGX_ENCL_INITIALIZED | SGX_ENCL_DEAD is set.

Updated version:

static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long src,
			     unsigned long offset, unsigned long length,
			     struct sgx_secinfo *secinfo, unsigned long flags)
{
	struct sgx_encl_page *encl_page;
	struct sgx_epc_page *epc_page;
	struct sgx_va_page *va_page;
	int ret;

	if (atomic_read(&encl->flags) & SGX_ENCL_INITIALIZED)
		return -EFAULT;

SGX_ENCL_DEAD check is unnecessary altogether as this flag cannot be
possibly be unset inside ioctl. 'sgx_release()' will set it which is
the release callback for the enclave file.

'sgx_ioctl()' also unnecessarily has this check I just noticed (and
removed).

> "uninitialized"?
> 
> Where is the test for SGX_ENCL_INITIALIZED and erroring out otherwise?
> 
> I.e., what happens if you add pages to an initialized enclave?

Because of historical reasons it is in sgx_encl_add_page(). Then we
allowed ioctl's operate on enclave concurrently. Today we enforce
sequential operation on a single enclave with SGX_ENCL_IOCTL flag
because that is the only sane way to use the construction operations.

Therefore the check can be moved to sgx_ioc_encl_add_pages() if you
request so but first I have one remark to discuss.

I noticed that sometimes wrong state flags turn into -EINVAL and
sometimes into -EFAULT (like in the previous case). I'd suggest
that when the ioctl is blocked based encl->flags and only on that,
the ioctl would return -ENOIOCTLCMD in both cases, i.e. this
command is not available.

That would give much better aids for debugging user space code.

> 
> > + * measurement with the contents of the page. The address range of pages must
> > + * be contiguous.
> 
> Must? Who is enforcing this? I'm trying to find where...

Unfortunately I cannot recall what I meant when I wrote that. I removed
that sentence. I'm not sure what I meant exactly when I used 'contiguous'
here.

> > The SECINFO and measurement mask are applied to all pages.
> > + *
> > + * A SECINFO for a TCS is required to always contain zero permissions because
> > + * CPU silently zeros them. Allowing anything else would cause a mismatch in
> > + * the measurement.
> > + *
> > + * mmap()'s protection bits are capped by the page permissions. For each page
> > + * address, the maximum protection bits are computed with the following
> > + * heuristics:
> > + *
> > + * 1. A regular page: PROT_R, PROT_W and PROT_X match the SECINFO permissions.
> > + * 2. A TCS page: PROT_R | PROT_W.
> > + *
> > + * mmap() is not allowed to surpass the minimum of the maximum protection bits
> > + * within the given address range.
> > + *
> > + * If ENCLS opcode fails, that effectively means that EPC has been invalidated.
> > + * When this happens the enclave is destroyed and -EIO is returned to the
> > + * caller.
> > + *
> > + * Return:
> > + *   0 on success,
> > + *   -EACCES if an executable source page is located in a noexec partition,
> > + *   -EIO if either ENCLS[EADD] or ENCLS[EEXTEND] fails
> > + *   -errno otherwise
> > + */
> > +static long sgx_ioc_enclave_add_pages(struct sgx_encl *encl, void __user *arg)
> > +{
> > +	struct sgx_enclave_add_pages addp;
> > +	struct sgx_secinfo secinfo;
> > +	unsigned long c;
> > +	int ret;
> > +
> > +	if (!(atomic_read(&encl->flags) & SGX_ENCL_CREATED))
> > +		return -EINVAL;
> > +
> > +	if (copy_from_user(&addp, arg, sizeof(addp)))
> > +		return -EFAULT;
> > +
> > +	if (!IS_ALIGNED(addp.offset, PAGE_SIZE) ||
> > +	    !IS_ALIGNED(addp.src, PAGE_SIZE))
> > +		return -EINVAL;
> > +
> > +	if (!(access_ok(addp.src, PAGE_SIZE)))
> > +		return -EFAULT;
> > +
> > +	if (addp.length & (PAGE_SIZE - 1))
> > +		return -EINVAL;
> 
> How many pages are allowed? Unlimited? I'm hoping some limits are
> checked somewhere...

SGX_IOC_ENCLAVE_CREATE defines the address range, and thus sets the
limit on how many pages in total can be added to the enclave.

sgx_encl_size_max_64 contains the maximum size for the address range
and is initialized as follows:

cpuid_count(SGX_CPUID, 0, &eax, &ebx, &ecx, &edx);
sgx_encl_size_max_64 = 1ULL << ((edx >> 8) & 0xFF);

[derived from sgx_drv_init()]

> > +
> > +	if (addp.offset + addp.length - PAGE_SIZE >= encl->size)
> > +		return -EINVAL;
> > +
> > +	if (copy_from_user(&secinfo, (void __user *)addp.secinfo,
> > +			   sizeof(secinfo)))
> > +		return -EFAULT;
> > +
> > +	if (sgx_validate_secinfo(&secinfo))
> > +		return -EINVAL;
> > +
> > +	for (c = 0 ; c < addp.length; c += PAGE_SIZE) {
> > +		if (signal_pending(current)) {
> > +			ret = -EINTR;
> > +			break;
> > +		}
> > +
> > +		if (need_resched())
> > +			cond_resched();
> > +
> > +		ret = sgx_encl_add_page(encl, addp.src + c, addp.offset + c,
> > +					addp.length - c, &secinfo, addp.flags);
> > +		if (ret)
> > +			break;
> > +	}
> > +
> > +	addp.count = c;

If you referred with your previous question, how to limit the number of
pages that this ioctl can process in one run, it is already supported
in the API with 'addp.count'.

It'd be possible to add this if required:

addp.length = min(addp.length, SGX_ENCLAVE_IOC_ADD_PAGES_MAX_LENGTH));

/Jarkko
