Return-Path: <SRS0=DpJx=UD=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,T_DKIMWL_WL_HIGH autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37217C282CE
	for <linux-sgx@archiver.kernel.org>; Tue,  4 Jun 2019 20:23:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EED6820859
	for <linux-sgx@archiver.kernel.org>; Tue,  4 Jun 2019 20:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1559679834;
	bh=Q1cile9P1BeRtbU7f54V0HvX+wlr5/zEe0r+8JmcA24=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=xkaUlHDN/DbiBiHFIRUCh4jHg7aQFRNM8BvCebaRDoq284OJlVlGk5jarsP6oNwqK
	 IcaffyB84tVFBw2bCulrewEnk3ToD45784YCGAX9ApBtCkCHroabgt01qE6vjEldJs
	 jOFBwU3Y8+K0i7O02cDLNeozm92ANh8fMsyMWxhw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbfFDUXx (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 4 Jun 2019 16:23:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:54606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726317AbfFDUXx (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 4 Jun 2019 16:23:53 -0400
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B3DE212F5
        for <linux-sgx@vger.kernel.org>; Tue,  4 Jun 2019 20:23:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559679832;
        bh=Q1cile9P1BeRtbU7f54V0HvX+wlr5/zEe0r+8JmcA24=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ni8Mao9ymvJnv6YkpaQA8KpjdHJWO5zC+kqqlz92Th3RfTmiT5OdYwDksSx2D5//0
         YW3xOyQexHGWCbY/d7qMKCD57/vrPJj+XHMuWNJpYGtUVloD/BFpoyE7H1C7Yf3gmk
         bOwLzNftE7X8wFeSHWB3nbIJgBmpvRnGXQhWmi0E=
Received: by mail-wm1-f45.google.com with SMTP id w9so241290wmd.1
        for <linux-sgx@vger.kernel.org>; Tue, 04 Jun 2019 13:23:52 -0700 (PDT)
X-Gm-Message-State: APjAAAVftpiwlubX+vcacBg8UYYt9PZepLF1DoFSOCjR3VI/DC8/NJAE
        Lb033TTEmYIGXPC4lYLqIMErCIeg/mRpHDdFRJwKFg==
X-Google-Smtp-Source: APXvYqxttHOHoYrVfNwbnoF4AjBX9KYICjmss2q13A1PhtTVNk/y4AIjl6szEFJt0Q4AjwSwuOho/tYnWwU8XuLYdvQ=
X-Received: by 2002:a1c:6242:: with SMTP id w63mr15855116wmb.161.1559679830930;
 Tue, 04 Jun 2019 13:23:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190531233159.30992-1-sean.j.christopherson@intel.com> <20190531233159.30992-7-sean.j.christopherson@intel.com>
In-Reply-To: <20190531233159.30992-7-sean.j.christopherson@intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Tue, 4 Jun 2019 13:23:40 -0700
X-Gmail-Original-Message-ID: <CALCETrU1mV0NQoG=ba0BVf5WpeqfdJkhcGnyo9Jk+hFo9eCXUw@mail.gmail.com>
Message-ID: <CALCETrU1mV0NQoG=ba0BVf5WpeqfdJkhcGnyo9Jk+hFo9eCXUw@mail.gmail.com>
Subject: Re: [RFC PATCH 6/9] x86/sgx: Require userspace to provide allowed
 prots to ADD_PAGES
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
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

On Fri, May 31, 2019 at 4:32 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> ...to support (the equivalent) of existing Linux Security Module
> functionality.
>
> Because SGX manually manages EPC memory, all enclave VMAs are backed by
> the same vm_file, i.e. /dev/sgx/enclave, so that SGX can implement the
> necessary hooks to move pages in/out of the EPC.  And because EPC pages
> for any given enclave are fundamentally shared between processes, i.e.
> CoW semantics are not possible with EPC pages, /dev/sgx/enclave must
> always be MAP_SHARED.  Lastly, all real world enclaves will need read,
> write and execute permissions to EPC pages.  As a result, SGX does not
> play nice with existing LSM behavior as it is impossible to apply
> policies to enclaves with any reasonable granularity, e.g. an LSM can
> deny access to EPC altogether, but can't deny potentially dangerous
> behavior such as mapping pages RW->RW or RWX.
>
> To give LSMs enough information to implement their policies without
> having to resort to ugly things, e.g. holding a reference to the vm_file
> of each enclave page, require userspace to explicitly state the allowed
> protections for each page (region), i.e. take ALLOW_{READ,WRITE,EXEC}
> in the ADD_PAGES ioctl.
>
> The ALLOW_* flags will be passed to LSMs so that they can make informed
> decisions when the enclave is being built, i.e. when the source vm_file
> is available.  For example, SELinux's EXECMOD permission can be
> required if an enclave is requesting both ALLOW_WRITE and ALLOW_EXEC.
>
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
>         __u64   src;
>  };
>
> +/* Supported flags for struct sgx_enclave_add_pages. */
> +#define SGX_ALLOW_READ VM_READ
> +#define SGX_ALLOW_WRITE        VM_WRITE
> +#define SGX_ALLOW_EXEC VM_EXEC
> +
>  /**
>   * struct sgx_enclave_add_pages - parameter structure for the
>   *                                %SGX_IOC_ENCLAVE_ADD_PAGES ioctl
> @@ -39,6 +44,7 @@ struct sgx_enclave_create  {
>   * @secinfo:   address for the SECINFO data (common to all pages)
>   * @nr_pages:  number of pages (must be virtually contiguous)
>   * @mrmask:    bitmask for the measured 256 byte chunks (common to all pages)
> + * @flags:     flags, e.g. SGX_ALLOW_{READ,WRITE,EXEC} (common to all pages)
>   */
>  struct sgx_enclave_add_pages {
>         __u64   addr;
> @@ -46,7 +52,8 @@ struct sgx_enclave_add_pages {
>         __u64   secinfo;
>         __u32   nr_pages;
>         __u16   mrmask;
> -} __attribute__((__packed__));
> +       __u16   flags;

Minor nit: I would use at least u32 for flags.  It's not like the size
saving is important.

>  static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long addr,
>                              unsigned long src, struct sgx_secinfo *secinfo,
> -                            unsigned int mrmask)
> +                            unsigned int mrmask, unsigned int flags)
>  {
> +       unsigned long prot = secinfo->flags & (VM_READ | VM_WRITE | VM_EXEC);
> +       unsigned long allowed_prot = flags & (VM_READ | VM_WRITE | VM_EXEC);

...

> +       if (prot & ~allowed_prot)
> +               return -EACCES;

This seems like a well-intentioned sanity check, but it doesn't really
accomplish anything with SGX2, so I tend to think it would be better
to omit it.
