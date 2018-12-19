Return-Path: <SRS0=HOZE=O4=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FCABC43387
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Dec 2018 05:22:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4832021850
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Dec 2018 05:22:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbeLSFWJ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 19 Dec 2018 00:22:09 -0500
Received: from mga05.intel.com ([192.55.52.43]:2781 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726833AbeLSFWJ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 19 Dec 2018 00:22:09 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Dec 2018 21:22:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,371,1539673200"; 
   d="scan'208";a="102633722"
Received: from cqinghon-mobl2.ccr.corp.intel.com (HELO localhost) ([10.249.254.218])
  by orsmga008.jf.intel.com with ESMTP; 18 Dec 2018 21:22:01 -0800
Date:   Wed, 19 Dec 2018 07:22:00 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     X86 ML <x86@kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        nhorman@redhat.com, npmccallum@redhat.com,
        "Ayoun, Serge" <serge.ayoun@intel.com>, shay.katz-zamir@intel.com,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Svahn, Kai" <kai.svahn@intel.com>, mark.shanahan@intel.com,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v17 18/23] platform/x86: Intel SGX driver
Message-ID: <20181219052200.GA14909@linux.intel.com>
References: <20181116010412.23967-1-jarkko.sakkinen@linux.intel.com>
 <20181116010412.23967-19-jarkko.sakkinen@linux.intel.com>
 <CALCETrX1XG1kCrVfx1athBaCWp4H0xoKnjoDjFOqR4nf_VqBrA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrX1XG1kCrVfx1athBaCWp4H0xoKnjoDjFOqR4nf_VqBrA@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Dec 17, 2018 at 09:55:08PM -0800, Andy Lutomirski wrote:
> On Thu, Nov 15, 2018 at 5:08 PM Jarkko Sakkinen
> <jarkko.sakkinen@linux.intel.com> wrote:
> >
> > Intel Software Guard eXtensions (SGX) is a set of CPU instructions that
> > can be used by applications to set aside private regions of code and
> > data. The code outside the enclave is disallowed to access the memory
> > inside the enclave by the CPU access control.
> 
> This is a very partial review.

Thank you, appreciate it.

> > +int sgx_encl_find(struct mm_struct *mm, unsigned long addr,
> > +                 struct vm_area_struct **vma)
> > +{
> > +       struct vm_area_struct *result;
> > +       struct sgx_encl *encl;
> > +
> > +       result = find_vma(mm, addr);
> > +       if (!result || result->vm_ops != &sgx_vm_ops || addr < result->vm_start)
> > +               return -EINVAL;
> > +
> > +       encl = result->vm_private_data;
> > +       *vma = result;
> > +
> > +       return encl ? 0 : -ENOENT;
> > +}
> 
> I realize that this function may go away entirely but, if you keep it:
> what are the locking rules?  What, if anything, prevents another
> thread from destroying the enclave after sgx_encl_find() returns?

The kref inside the enclave is used to manage this but this function
directly does not prevent it (see for example sgx_encl_get). But yes,
this function does not give any guarantees (should probably have
a documentation stating this).

> > +static int sgx_validate_secs(const struct sgx_secs *secs,
> > +                            unsigned long ssaframesize)
> > +{
> 
> ...
> 
> > +       if (secs->attributes & SGX_ATTR_MODE64BIT) {
> > +               if (secs->size > sgx_encl_size_max_64)
> > +                       return -EINVAL;
> > +       } else {
> > +               /* On 64-bit architecture allow 32-bit encls only in
> > +                * the compatibility mode.
> > +                */
> > +               if (!test_thread_flag(TIF_ADDR32))
> > +                       return -EINVAL;
> > +               if (secs->size > sgx_encl_size_max_32)
> > +                       return -EINVAL;
> > +       }
> 
> Why do we need the 32-bit-on-64-bit check?  In general, anything that
> checks per-task or per-mm flags like TIF_ADDR32 is IMO likely to be
> problematic.  You're allowing 64-bit enclaves in 32-bit tasks, so I'm
> guessing you could just delete the check.

I guess you are right. I can remove this.


> 
> > +
> > +       if (!(secs->xfrm & XFEATURE_MASK_FP) ||
> > +           !(secs->xfrm & XFEATURE_MASK_SSE) ||
> > +           (((secs->xfrm >> XFEATURE_BNDREGS) & 1) !=
> > +            ((secs->xfrm >> XFEATURE_BNDCSR) & 1)) ||
> > +           (secs->xfrm & ~sgx_xfrm_mask))
> > +               return -EINVAL;
> 
> Do we need to check that the enclave doesn't use xfeatures that the
> kernel doesn't know about?  Or are they all safe by design in enclave
> mode?

Really good catch BTW. We don't check what kernel doesn't know about.

I'm not sure what harm this would have as the enclave cannot have much
effect to the outside world. Is there easy way to get similar mask
of kernel supported features as sgx_xfrm_mask? The safe play would
be to use such here as I don't have definitive answer to your second
question.

> 
> > +static int sgx_encl_pm_notifier(struct notifier_block *nb,
> > +                               unsigned long action, void *data)
> > +{
> > +       struct sgx_encl *encl = container_of(nb, struct sgx_encl, pm_notifier);
> > +
> > +       if (action != PM_SUSPEND_PREPARE && action != PM_HIBERNATION_PREPARE)
> > +               return NOTIFY_DONE;
> 
> Hmm.  There's an argument to made that omitting this would better
> exercise the code that handles fully asynchronous loss of an enclave.
> Also, I think you're unnecessarily killing enclaves when suspend is
> attempted but fails.

Are you proposing to not do anything at all to the enclaves? There was
is a problem that it could lead to infinite #PF loop if we don't do
it.


> 
> > +
> > +static int sgx_get_key_hash(const void *modulus, void *hash)
> > +{
> > +       struct crypto_shash *tfm;
> > +       int ret;
> > +
> > +       tfm = crypto_alloc_shash("sha256", 0, CRYPTO_ALG_ASYNC);
> > +       if (IS_ERR(tfm))
> > +               return PTR_ERR(tfm);
> > +
> > +       ret = __sgx_get_key_hash(tfm, modulus, hash);
> > +
> > +       crypto_free_shash(tfm);
> > +       return ret;
> > +}
> > +
> 
> I'm so sorry you had to deal with this API.  Once Zinc lands, you
> could clean this up :)
> 
> 
> > +static int sgx_encl_get(unsigned long addr, struct sgx_encl **encl)
> > +{
> > +       struct mm_struct *mm = current->mm;
> > +       struct vm_area_struct *vma;
> > +       int ret;
> > +
> > +       if (addr & (PAGE_SIZE - 1))
> > +               return -EINVAL;
> > +
> > +       down_read(&mm->mmap_sem);
> > +
> > +       ret = sgx_encl_find(mm, addr, &vma);
> > +       if (!ret) {
> > +               *encl = vma->vm_private_data;
> > +
> > +               if ((*encl)->flags & SGX_ENCL_SUSPEND)
> > +                       ret = SGX_POWER_LOST_ENCLAVE;
> > +               else
> > +                       kref_get(&(*encl)->refcount);
> > +       }
> 
> Hmm.  This version has explicit refcounting.
> 
> > +static int sgx_mmap(struct file *file, struct vm_area_struct *vma)
> > +{
> > +       vma->vm_ops = &sgx_vm_ops;
> > +       vma->vm_flags |= VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP | VM_IO |
> > +                        VM_DONTCOPY;
> > +
> > +       return 0;
> > +}
> > +
> > +static unsigned long sgx_get_unmapped_area(struct file *file,
> > +                                          unsigned long addr,
> > +                                          unsigned long len,
> > +                                          unsigned long pgoff,
> > +                                          unsigned long flags)
> > +{
> > +       if (len < 2 * PAGE_SIZE || (len & (len - 1)))
> > +               return -EINVAL;
> > +
> > +       if (len > sgx_encl_size_max_64)
> > +               return -EINVAL;
> > +
> > +       if (len > sgx_encl_size_max_32 && test_thread_flag(TIF_ADDR32))
> > +               return -EINVAL;
> 
> Generally speaking, this type of check wants to be
> in_compat_syscall().  But I'm not sure I understand why you need it at
> all.

I'll remove it.

> 
> > +static void sgx_ipi_cb(void *info)
> > +{
> > +}
> > +
> > +void sgx_flush_cpus(struct sgx_encl *encl)
> > +{
> > +       on_each_cpu_mask(mm_cpumask(encl->mm), sgx_ipi_cb, NULL, 1);
> > +}
> 
> Please add a comment explaining what this promises to do.

Will do.

/Jarkko
