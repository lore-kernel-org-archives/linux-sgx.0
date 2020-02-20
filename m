Return-Path: <SRS0=Uuw6=4I=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63517C11D0C
	for <linux-sgx@archiver.kernel.org>; Thu, 20 Feb 2020 18:51:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32E142467B
	for <linux-sgx@archiver.kernel.org>; Thu, 20 Feb 2020 18:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582224712;
	bh=BIb7muBRiTMmDaTPFIJ2G/FP0hMlkSebaL/qJ/Le4dQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=WGnvEcRNAHZ928J4SUkwUpxu1PozKfEnb/er+KeckAYkJLg/uu6mMWXMz0DmSzquK
	 TENDOB7ZtJOAOVquT3+4TThXa6azxF49JareRhe6h4/KE8yA2vzlyIQpcwXmb9Qq0K
	 0yS06eLAxJLfEtu14EGa1P/LUA/NusMoTUC4ZBFg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728237AbgBTSvw (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 20 Feb 2020 13:51:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:48400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728111AbgBTSvv (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 20 Feb 2020 13:51:51 -0500
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7B7D2467A
        for <linux-sgx@vger.kernel.org>; Thu, 20 Feb 2020 18:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582224711;
        bh=BIb7muBRiTMmDaTPFIJ2G/FP0hMlkSebaL/qJ/Le4dQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=IgQMqpweoIv/kUDzsl9CIjVqxdzBRhoNct5ut+/3c/1W+bp4IzRC93ES5d/Q6qJp/
         LUBa1hF5XZyH4Y7787+lNucQDReqAwCt2GAEglW2y7I/GPE7vuVwwYgCsJzO8WPHkb
         j3rBW+QzM8+0tyzkAB3FCqGRt6XWTAYNgHWFMFpk=
Received: by mail-wr1-f46.google.com with SMTP id y11so5810811wrt.6
        for <linux-sgx@vger.kernel.org>; Thu, 20 Feb 2020 10:51:50 -0800 (PST)
X-Gm-Message-State: APjAAAU+Z1YDaqX27pbSpobuK3zxt0/OThDIl+LUd9g++UOFn2vPu8pU
        49qA+gwaFWyRjBuEyGoO34k7E/VXNjHtU3oOSHYhTw==
X-Google-Smtp-Source: APXvYqxegNzYJn6ARUk+PJRm7v093kishGL72Bi413I9Bqd/49GjAa+reA0TGzaRyvGBRYkR2gwg9ESP1UT6PDqC+jg=
X-Received: by 2002:adf:a354:: with SMTP id d20mr43299256wrb.257.1582224709127;
 Thu, 20 Feb 2020 10:51:49 -0800 (PST)
MIME-Version: 1.0
References: <20200209212609.7928-1-jarkko.sakkinen@linux.intel.com>
 <20200209212609.7928-11-jarkko.sakkinen@linux.intel.com> <15074c16-4832-456d-dd12-af8548e46d6d@linux.microsoft.com>
 <20200220181345.GD3972@linux.intel.com>
In-Reply-To: <20200220181345.GD3972@linux.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Thu, 20 Feb 2020 10:51:37 -0800
X-Gmail-Original-Message-ID: <CALCETrVXnSR8fBQtqv=3zFxJCFhcHE-6XNAy3suPW+uPgFvfvg@mail.gmail.com>
Message-ID: <CALCETrVXnSR8fBQtqv=3zFxJCFhcHE-6XNAy3suPW+uPgFvfvg@mail.gmail.com>
Subject: Re: [PATCH v26 10/22] x86/sgx: Linux Enclave Driver
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jordan Hand <jorhand@linux.microsoft.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        linux-sgx@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Neil Horman <nhorman@redhat.com>, npmccallum@redhat.com,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Svahn, Kai" <kai.svahn@intel.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        Andrew Lutomirski <luto@kernel.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>,
        "Xing, Cedric" <cedric.xing@intel.com>, puiterwijk@redhat.com,
        LSM List <linux-security-module@vger.kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Haitao Huang <haitao.huang@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Feb 20, 2020 at 10:13 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Tue, Feb 18, 2020 at 07:26:31PM -0800, Jordan Hand wrote:
> > I ran our validation tests for the Open Enclave SDK against this patch
> > set and came across a potential issue.
> >
> > On 2/9/20 1:25 PM, Jarkko Sakkinen wrote:
> > > +/**
> > > + * sgx_encl_may_map() - Check if a requested VMA mapping is allowed
> > > + * @encl:          an enclave
> > > + * @start:         lower bound of the address range, inclusive
> > > + * @end:           upper bound of the address range, exclusive
> > > + * @vm_prot_bits:  requested protections of the address range
> > > + *
> > > + * Iterate through the enclave pages contained within [@start, @end) to verify
> > > + * the permissions requested by @vm_prot_bits do not exceed that of any enclave
> > > + * page to be mapped.  Page addresses that do not have an associated enclave
> > > + * page are interpreted to zero permissions.
> > > + *
> > > + * Return:
> > > + *   0 on success,
> > > + *   -EACCES if VMA permissions exceed enclave page permissions
> > > + */
> > > +int sgx_encl_may_map(struct sgx_encl *encl, unsigned long start,
> > > +                unsigned long end, unsigned long vm_prot_bits)
> > > +{
> > > +   unsigned long idx, idx_start, idx_end;
> > > +   struct sgx_encl_page *page;
> > > +
> > > +   /* PROT_NONE always succeeds. */
> > > +   if (!vm_prot_bits)
> > > +           return 0;
> > > +
> > > +   idx_start = PFN_DOWN(start);
> > > +   idx_end = PFN_DOWN(end - 1);
> > > +
> > > +   for (idx = idx_start; idx <= idx_end; ++idx) {
> > > +           mutex_lock(&encl->lock);
> > > +           page = radix_tree_lookup(&encl->page_tree, idx);
> > > +           mutex_unlock(&encl->lock);
> > > +
> > > +           if (!page || (~page->vm_max_prot_bits & vm_prot_bits))
> > > +                   return -EACCES;
> > > +   }
> > > +
> > > +   return 0;
> > > +}
> > > +static struct sgx_encl_page *sgx_encl_page_alloc(struct sgx_encl *encl,
> > > +                                            unsigned long offset,
> > > +                                            u64 secinfo_flags)
> > > +{
> > > +   struct sgx_encl_page *encl_page;
> > > +   unsigned long prot;
> > > +
> > > +   encl_page = kzalloc(sizeof(*encl_page), GFP_KERNEL);
> > > +   if (!encl_page)
> > > +           return ERR_PTR(-ENOMEM);
> > > +
> > > +   encl_page->desc = encl->base + offset;
> > > +   encl_page->encl = encl;
> > > +
> > > +   prot = _calc_vm_trans(secinfo_flags, SGX_SECINFO_R, PROT_READ)  |
> > > +          _calc_vm_trans(secinfo_flags, SGX_SECINFO_W, PROT_WRITE) |
> > > +          _calc_vm_trans(secinfo_flags, SGX_SECINFO_X, PROT_EXEC);
> > > +
> > > +   /*
> > > +    * TCS pages must always RW set for CPU access while the SECINFO
> > > +    * permissions are *always* zero - the CPU ignores the user provided
> > > +    * values and silently overwrites them with zero permissions.
> > > +    */
> > > +   if ((secinfo_flags & SGX_SECINFO_PAGE_TYPE_MASK) == SGX_SECINFO_TCS)
> > > +           prot |= PROT_READ | PROT_WRITE;
> > > +
> > > +   /* Calculate maximum of the VM flags for the page. */
> > > +   encl_page->vm_max_prot_bits = calc_vm_prot_bits(prot, 0);
> >
> > During mprotect (in mm/mprotect.c line 525) the following checks if
> > READ_IMPLIES_EXECUTE and a PROT_READ is being requested. If so and
> > VM_MAYEXEC is set, it also adds PROT_EXEC to the request.
> >
> >       if (rier && (vma->vm_flags & VM_MAYEXEC))
> >               prot |= PROT_EXEC;
> >
> > But if we look at sgx_encl_page_alloc(), we see vm_max_prot_bits is set
> > without taking VM_MAYEXEC into account:
> >
> >       encl_page->vm_max_prot_bits = calc_vm_prot_bits(prot, 0);
> >
> > sgx_encl_may_map() checks that the requested protection can be added with:
> >
> >       if (!page || (~page->vm_max_prot_bits & vm_prot_bits))
> >               return -EACCESS
> >
> > This means that for any process where READ_IMPLIES_EXECUTE is set and
> > page where (vma->vm_flags & VM_MAYEXEC) == true, mmap/mprotect calls to
> > that request PROT_READ on a page that was not added with PROT_EXEC will
> > fail.
>
> I could've sworn this was discussed on the SGX list at one point, but
> apparently we only discussed it internally.  Anyways...
>
> More than likely, the READ_IMPLIES_EXECUTE (RIE) crud rears its head
> because part of the enclave loader is written in assembly.  Unless
> explicitly told otherwise, the linker assumes that any program with
> assembly code may need an executable stack, which leads to the RIE
> personality being set for the process.  Here's a fantastic write up for
> more details: https://www.airs.com/blog/archives/518
>
> There are essentially two paths we can take:
>
>  1) Exempt EPC pages from RIE during mmap()/mprotect(), i.e. don't add
>     PROT_EXEC for enclaves.

Seems reasonable.

Honestly, it probably makes sense to try to exempt almost everything
from RIE.  I'd be a bit surprised if RIE is actually useful for
anything other than plain anonymous pages and private file mappings.
