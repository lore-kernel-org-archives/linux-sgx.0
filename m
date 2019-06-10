Return-Path: <SRS0=YVcv=UJ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,T_DKIMWL_WL_HIGH
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74476C31E43
	for <linux-sgx@archiver.kernel.org>; Mon, 10 Jun 2019 16:45:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 452A220820
	for <linux-sgx@archiver.kernel.org>; Mon, 10 Jun 2019 16:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1560185110;
	bh=Y8E+4PLVaGcBC0QnRuAjUawfq3/72hXoE582Tg5tIuw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=q7Xk6YeznmIZdByHU9jytzOtGBu823ctd7RL598rJyjAQ1EW6qL5v+jTKSvMpHIkv
	 o53hBSx15tUzvSh3NCBV3zhTl0i0/p2k5wZ5KOyAmSm8+m6LPUj42y/yo7Xco433wm
	 Bl7JEjrdiV3udVSjuPlyLvJknr/JcNZcyGX3K/5k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725811AbfFJQpK (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 10 Jun 2019 12:45:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:51200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726514AbfFJQpJ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 10 Jun 2019 12:45:09 -0400
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AADCD208E3
        for <linux-sgx@vger.kernel.org>; Mon, 10 Jun 2019 16:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560185108;
        bh=Y8E+4PLVaGcBC0QnRuAjUawfq3/72hXoE582Tg5tIuw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=J6HRPNNWuT4LA6l5MNHQZ+sRmWPpcNrrf9JUFPeKcbzU0CkUBtn/xFRSTx0+NY6uf
         vPexidZG/FjkmyoqpoLwiDazEMcHkIk/ffRkl05K1WlkgtxNOc4UV+rBCJvbbB9Fmg
         Wa+Wo4qXzj14suHaq7aB2GCf5ZoQO5x3HwpaEGb8=
Received: by mail-wr1-f42.google.com with SMTP id d18so9890205wrs.5
        for <linux-sgx@vger.kernel.org>; Mon, 10 Jun 2019 09:45:08 -0700 (PDT)
X-Gm-Message-State: APjAAAUAEf74L713387uxkzwHesZ70Oda6aTpgfE4mFpS4MqXuj1TB0K
        0+XNQH+r8jy3eLKpukZ39CnIgRzeH/zmmiQhoKDmQA==
X-Google-Smtp-Source: APXvYqzYkr99eA23CbFFE0bAMXptfrueXWcrQU2TMu+R/pORoCW0lJCU07jWbIkOi7KgS2qyV0BaNVqRqxtywNB94M0=
X-Received: by 2002:a5d:4d06:: with SMTP id z6mr19532206wrt.343.1560185107248;
 Mon, 10 Jun 2019 09:45:07 -0700 (PDT)
MIME-Version: 1.0
References: <20190606021145.12604-1-sean.j.christopherson@intel.com>
 <20190606021145.12604-4-sean.j.christopherson@intel.com> <20190610160005.GC3752@linux.intel.com>
In-Reply-To: <20190610160005.GC3752@linux.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 10 Jun 2019 09:44:55 -0700
X-Gmail-Original-Message-ID: <CALCETrVovr8XNZSroey7pHF46O=kj_c5D9K8h=z2T_cNrpvMig@mail.gmail.com>
Message-ID: <CALCETrVovr8XNZSroey7pHF46O=kj_c5D9K8h=z2T_cNrpvMig@mail.gmail.com>
Subject: Re: [RFC PATCH v2 3/5] x86/sgx: Enforce noexec filesystem restriction
 for enclaves
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
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
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Jun 10, 2019 at 9:00 AM Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
>
> On Wed, Jun 05, 2019 at 07:11:43PM -0700, Sean Christopherson wrote:
> > +             goto out;
> > +     }
> > +
> > +     /*
> > +      * Query VM_MAYEXEC as an indirect path_noexec() check (see do_mmap()),
> > +      * but with some future proofing against other cases that may deny
> > +      * execute permissions.
> > +      */
> > +     if (!(vma->vm_flags & VM_MAYEXEC)) {
> > +             ret = -EACCES;
> > +             goto out;
> > +     }
> > +
> > +     if (copy_from_user(dst, (void __user *)src, PAGE_SIZE))
> > +             ret = -EFAULT;
> > +     else
> > +             ret = 0;
> > +
> > +out:
> > +     up_read(&current->mm->mmap_sem);
> > +
> > +     return ret;
> > +}
>
> I would suggest to express the above instead like this for clarity
> and consistency:
>
>                 goto err_map_sem;
>         }
>
>         /* Query VM_MAYEXEC as an indirect path_noexec() check
>          * (see do_mmap()).
>          */
>         if (!(vma->vm_flags & VM_MAYEXEC)) {
>                 ret = -EACCES;
>                 goto err_mmap_sem;
>         }
>
>         if (copy_from_user(dst, (void __user *)src, PAGE_SIZE)) {
>                 ret = -EFAULT;
>                 goto err_mmap_sem;
>         }
>
>         return 0;
>
> err_mmap_sem:
>         up_read(&current->mm->mmap_sem);
>         return ret;
> }
>
> The comment about future proofing is unnecessary.
>

I'm also torn as to whether this patch is needed at all.  If we ever
get O_MAYEXEC, then enclave loaders should use it to enforce noexec in
userspace.  Otherwise I'm unconvinced it's that special.
