Return-Path: <SRS0=KK61=O3=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 457E1C43387
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Dec 2018 05:55:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04AEF21841
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Dec 2018 05:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1545112524;
	bh=RO+qVZqc56lHf609ezk3owYaE70TiFxtMxpkPgvQVRo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=r/pi4sr5M+d2oQvOHt9AjWy5zq2CkfQ+kxq4D9fUlOlCW3hAs4SV9Zq4z8Ysk69sw
	 KU/W0HnWv3HKdbftZ8+cCvel74Ujr7MdmnkLktAI/RAkVOLIfDbIz2vOFfEvFZh1/x
	 0VOYEdfLcaMv04iRpbTwECOq1/aOkoaFthSr6t0o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbeLRFzX (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 18 Dec 2018 00:55:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:57224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726314AbeLRFzX (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 18 Dec 2018 00:55:23 -0500
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF96521871
        for <linux-sgx@vger.kernel.org>; Tue, 18 Dec 2018 05:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1545112522;
        bh=RO+qVZqc56lHf609ezk3owYaE70TiFxtMxpkPgvQVRo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=YNUbVDZy5irkZTXfhrp8rP+SaoZzgTsyuaGchFZ5ItPVh+FFYTjJj/YYkFBawa9LQ
         23oro2ARZq2ZyS52EurrgjSoQlLYkNDAWpTkh1paUh8TQ6brF1SAKKybwHuUg3heDY
         OMJ2HAMvClKppfukgKOsd7IABSUzlqmKjUmlWMr0=
Received: by mail-wr1-f54.google.com with SMTP id s12so14141545wrt.4
        for <linux-sgx@vger.kernel.org>; Mon, 17 Dec 2018 21:55:21 -0800 (PST)
X-Gm-Message-State: AA+aEWaTegJkPH/csxiuvXjrxcQnG06EnecTmMXEwC3z8uESClm5Sgvy
        rFqGZAjYtwIoKQy8lg3J9S71xfYDYmuILES4h4ulKw==
X-Google-Smtp-Source: AFSGD/VAGbeu4zHizrDiiOyqfyzKT7Sbq4qqUaIbgL5AkBMjvoW2w4fErOn0Vkww1rCPPjaGVVervLvuCIgh9TDSJFM=
X-Received: by 2002:adf:e08c:: with SMTP id c12mr12348514wri.199.1545112520053;
 Mon, 17 Dec 2018 21:55:20 -0800 (PST)
MIME-Version: 1.0
References: <20181116010412.23967-1-jarkko.sakkinen@linux.intel.com> <20181116010412.23967-19-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <20181116010412.23967-19-jarkko.sakkinen@linux.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 17 Dec 2018 21:55:08 -0800
X-Gmail-Original-Message-ID: <CALCETrX1XG1kCrVfx1athBaCWp4H0xoKnjoDjFOqR4nf_VqBrA@mail.gmail.com>
Message-ID: <CALCETrX1XG1kCrVfx1athBaCWp4H0xoKnjoDjFOqR4nf_VqBrA@mail.gmail.com>
Subject: Re: [PATCH v17 18/23] platform/x86: Intel SGX driver
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
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
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Nov 15, 2018 at 5:08 PM Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
>
> Intel Software Guard eXtensions (SGX) is a set of CPU instructions that
> can be used by applications to set aside private regions of code and
> data. The code outside the enclave is disallowed to access the memory
> inside the enclave by the CPU access control.

This is a very partial review.

> +int sgx_encl_find(struct mm_struct *mm, unsigned long addr,
> +                 struct vm_area_struct **vma)
> +{
> +       struct vm_area_struct *result;
> +       struct sgx_encl *encl;
> +
> +       result = find_vma(mm, addr);
> +       if (!result || result->vm_ops != &sgx_vm_ops || addr < result->vm_start)
> +               return -EINVAL;
> +
> +       encl = result->vm_private_data;
> +       *vma = result;
> +
> +       return encl ? 0 : -ENOENT;
> +}

I realize that this function may go away entirely but, if you keep it:
what are the locking rules?  What, if anything, prevents another
thread from destroying the enclave after sgx_encl_find() returns?

> +static int sgx_validate_secs(const struct sgx_secs *secs,
> +                            unsigned long ssaframesize)
> +{

...

> +       if (secs->attributes & SGX_ATTR_MODE64BIT) {
> +               if (secs->size > sgx_encl_size_max_64)
> +                       return -EINVAL;
> +       } else {
> +               /* On 64-bit architecture allow 32-bit encls only in
> +                * the compatibility mode.
> +                */
> +               if (!test_thread_flag(TIF_ADDR32))
> +                       return -EINVAL;
> +               if (secs->size > sgx_encl_size_max_32)
> +                       return -EINVAL;
> +       }

Why do we need the 32-bit-on-64-bit check?  In general, anything that
checks per-task or per-mm flags like TIF_ADDR32 is IMO likely to be
problematic.  You're allowing 64-bit enclaves in 32-bit tasks, so I'm
guessing you could just delete the check.

> +
> +       if (!(secs->xfrm & XFEATURE_MASK_FP) ||
> +           !(secs->xfrm & XFEATURE_MASK_SSE) ||
> +           (((secs->xfrm >> XFEATURE_BNDREGS) & 1) !=
> +            ((secs->xfrm >> XFEATURE_BNDCSR) & 1)) ||
> +           (secs->xfrm & ~sgx_xfrm_mask))
> +               return -EINVAL;

Do we need to check that the enclave doesn't use xfeatures that the
kernel doesn't know about?  Or are they all safe by design in enclave
mode?

> +static int sgx_encl_pm_notifier(struct notifier_block *nb,
> +                               unsigned long action, void *data)
> +{
> +       struct sgx_encl *encl = container_of(nb, struct sgx_encl, pm_notifier);
> +
> +       if (action != PM_SUSPEND_PREPARE && action != PM_HIBERNATION_PREPARE)
> +               return NOTIFY_DONE;

Hmm.  There's an argument to made that omitting this would better
exercise the code that handles fully asynchronous loss of an enclave.
Also, I think you're unnecessarily killing enclaves when suspend is
attempted but fails.

> +
> +static int sgx_get_key_hash(const void *modulus, void *hash)
> +{
> +       struct crypto_shash *tfm;
> +       int ret;
> +
> +       tfm = crypto_alloc_shash("sha256", 0, CRYPTO_ALG_ASYNC);
> +       if (IS_ERR(tfm))
> +               return PTR_ERR(tfm);
> +
> +       ret = __sgx_get_key_hash(tfm, modulus, hash);
> +
> +       crypto_free_shash(tfm);
> +       return ret;
> +}
> +

I'm so sorry you had to deal with this API.  Once Zinc lands, you
could clean this up :)


> +static int sgx_encl_get(unsigned long addr, struct sgx_encl **encl)
> +{
> +       struct mm_struct *mm = current->mm;
> +       struct vm_area_struct *vma;
> +       int ret;
> +
> +       if (addr & (PAGE_SIZE - 1))
> +               return -EINVAL;
> +
> +       down_read(&mm->mmap_sem);
> +
> +       ret = sgx_encl_find(mm, addr, &vma);
> +       if (!ret) {
> +               *encl = vma->vm_private_data;
> +
> +               if ((*encl)->flags & SGX_ENCL_SUSPEND)
> +                       ret = SGX_POWER_LOST_ENCLAVE;
> +               else
> +                       kref_get(&(*encl)->refcount);
> +       }

Hmm.  This version has explicit refcounting.

> +static int sgx_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +       vma->vm_ops = &sgx_vm_ops;
> +       vma->vm_flags |= VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP | VM_IO |
> +                        VM_DONTCOPY;
> +
> +       return 0;
> +}
> +
> +static unsigned long sgx_get_unmapped_area(struct file *file,
> +                                          unsigned long addr,
> +                                          unsigned long len,
> +                                          unsigned long pgoff,
> +                                          unsigned long flags)
> +{
> +       if (len < 2 * PAGE_SIZE || (len & (len - 1)))
> +               return -EINVAL;
> +
> +       if (len > sgx_encl_size_max_64)
> +               return -EINVAL;
> +
> +       if (len > sgx_encl_size_max_32 && test_thread_flag(TIF_ADDR32))
> +               return -EINVAL;

Generally speaking, this type of check wants to be
in_compat_syscall().  But I'm not sure I understand why you need it at
all.

> +static void sgx_ipi_cb(void *info)
> +{
> +}
> +
> +void sgx_flush_cpus(struct sgx_encl *encl)
> +{
> +       on_each_cpu_mask(mm_cpumask(encl->mm), sgx_ipi_cb, NULL, 1);
> +}

Please add a comment explaining what this promises to do.
