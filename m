Return-Path: <SRS0=DpJx=UD=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,T_DKIMWL_WL_HIGH,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD41CC28CC3
	for <linux-sgx@archiver.kernel.org>; Tue,  4 Jun 2019 20:37:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7EF520717
	for <linux-sgx@archiver.kernel.org>; Tue,  4 Jun 2019 20:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1559680644;
	bh=cFvISWqZtenk/itmER7f+dDnKlLEKMgxPk2A4pPepQo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=MhZQ/cTwOnc65RM0v1WJgx/OH0PHwdxohNzLbtyRVkvUVZi9UwqIa8aXU37SjFd4m
	 nY98pa/FYwiPPVa7+B8mzchVAt0QWgK/XBlkFwTkGiDH67XQDvZJ8ejR8I4Dg/5tpE
	 W7J3xml5HbGjNAxsISza9WUF7wvi53thOEtLPVhw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbfFDUhY (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 4 Jun 2019 16:37:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:33724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726416AbfFDUhY (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 4 Jun 2019 16:37:24 -0400
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB6E720862
        for <linux-sgx@vger.kernel.org>; Tue,  4 Jun 2019 20:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559680163;
        bh=cFvISWqZtenk/itmER7f+dDnKlLEKMgxPk2A4pPepQo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=2HRcWilzppDkhdZc4TaBjrV5UIkT55QL43VjaSXEiVplRVpcAxBwNkDcNug+37B+Y
         t9fbgeUJZIdsTchPZypFGwlhJLgpyuR/aNqVnzXAOqtuoX8oEoU5j1y8GrjbLYqYJn
         ogGs6TSf8PXi12+IZT5rOfJH6kFTruNBQ6p9qQWM=
Received: by mail-wr1-f46.google.com with SMTP id n9so4764521wru.0
        for <linux-sgx@vger.kernel.org>; Tue, 04 Jun 2019 13:29:22 -0700 (PDT)
X-Gm-Message-State: APjAAAV516/X+VaeeEVnr/9Ch0TjzdVU5sVkRVxgjwJjCA/Jc11OA5Zh
        V6AT1TlKa+tfqdNuwbxcER9znnIZt0qV4/SLy4H3+A==
X-Google-Smtp-Source: APXvYqzggKbEmevf1hAGqsqkg6nyK2jhLYRBA68/pK6t43ULfTO2FFzNf9MvZev2j4Pu6QQWtmJouUP2ZUsabFVGcpo=
X-Received: by 2002:adf:f2c8:: with SMTP id d8mr92723wrp.221.1559680161582;
 Tue, 04 Jun 2019 13:29:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190531233159.30992-1-sean.j.christopherson@intel.com> <20190531233159.30992-9-sean.j.christopherson@intel.com>
In-Reply-To: <20190531233159.30992-9-sean.j.christopherson@intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Tue, 4 Jun 2019 13:29:10 -0700
X-Gmail-Original-Message-ID: <CALCETrXf3ujAn6uOwWMU8SRZOvBRb8ALvo_LQvwxc899mrakwQ@mail.gmail.com>
Message-ID: <CALCETrXf3ujAn6uOwWMU8SRZOvBRb8ALvo_LQvwxc899mrakwQ@mail.gmail.com>
Subject: Re: [RFC PATCH 8/9] LSM: x86/sgx: Introduce ->enclave_load() hook for
 Intel SGX
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
> enclave_load() is roughly analogous to the existing file_mprotect().
>
> Due to the nature of SGX and its Enclave Page Cache (EPC), all enclave
> VMAs are backed by a single file, i.e. /dev/sgx/enclave, that must be
> MAP_SHARED.  Furthermore, all enclaves need read, write and execute
> VMAs.  As a result, file_mprotect() does not provide any meaningful
> security for enclaves since an LSM can only deny/grant access to the
> EPC as a whole.
>
> security_enclave_load() is called when SGX is first loading an enclave
> page, i.e. copying a page from normal memory into the EPC.  The notable
> difference from file_mprotect() is the allowed_prot parameter, which
> is essentially an SGX-specific version of a VMA's MAY_{READ,WRITE,EXEC}
> flags.  The purpose of allowed_prot is to enable checks such as
> SELinux's FILE__EXECMOD permission without having to track and update
> VMAs across multiple mm structs, i.e. SGX can ensure userspace doesn't
> overstep its bounds simply by restricting an enclave VMA's protections
> by vetting what is maximally allowed during build time.
>
> An alternative to the allowed_prot approach would be to use an enclave's
> SIGSTRUCT (a smallish structure that can uniquely identify an enclave)
> as a proxy for the enclave.  For example, SGX could take and hold a
> reference to the file containing the SIGSTRUCT (if it's in a file) and
> call security_enclave_load() during mprotect().  While the SIGSTRUCT
> approach would provide better precision, the actual value added was
> deemed to be negligible.  On the other hand, pinning a file for the
> lifetime of the enclave is ugly, and essentially caching LSM policies
> in each page's allowed_prot avoids having to make an extra LSM upcall
> during mprotect().
>
> Note, extensive discussion yielded no sane alternative to some form of
> SGX specific LSM hook[1].
>
> [1] https://lkml.kernel.org/r/CALCETrXf8mSK45h7sTK5Wf+pXLVn=Bjsc_RLpgO-h-qdzBRo5Q@mail.gmail.com
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/driver/ioctl.c | 14 +++++++++-----
>  include/linux/lsm_hooks.h              | 16 ++++++++++++++++
>  include/linux/security.h               |  2 ++
>  security/security.c                    |  8 ++++++++
>  4 files changed, 35 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> index 5f71be7cbb01..260417ecbcff 100644
> --- a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> +++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> @@ -8,6 +8,7 @@
>  #include <linux/highmem.h>
>  #include <linux/ratelimit.h>
>  #include <linux/sched/signal.h>
> +#include <linux/security.h>
>  #include <linux/shmem_fs.h>
>  #include <linux/slab.h>
>  #include <linux/suspend.h>
> @@ -580,21 +581,24 @@ static int sgx_encl_page_protect(unsigned long src, unsigned long prot,
>                                  unsigned long *allowed_prot)
>  {
>         struct vm_area_struct *vma;
> +       int ret = 0;
>
> -       if (!(*allowed_prot & VM_EXEC))
> +       if (!(*allowed_prot & VM_EXEC) && !IS_ENABLED(CONFIG_SECURITY))
>                 goto do_check;
>
>         down_read(&current->mm->mmap_sem);
>         vma = find_vma(current->mm, src);
>         if (!vma || (vma->vm_file && path_noexec(&vma->vm_file->f_path)))
>                 *allowed_prot &= ~VM_EXEC;
> +#ifdef CONFIG_SECURITY
> +       ret = security_enclave_load(vma, prot, allowed_prot);
> +#endif
>         up_read(&current->mm->mmap_sem);
>
>  do_check:
> -       if (prot & ~*allowed_prot)
> -               return -EACCES;
> -
> -       return 0;
> +       if (!ret && (prot & ~*allowed_prot))
> +               ret = -EACCES;
> +       return ret;
>  }
>
>  static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long addr,
> diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
> index 47f58cfb6a19..0562775424a0 100644
> --- a/include/linux/lsm_hooks.h
> +++ b/include/linux/lsm_hooks.h
> @@ -1446,6 +1446,14 @@
>   * @bpf_prog_free_security:
>   *     Clean up the security information stored inside bpf prog.
>   *
> + * Security hooks for Intel SGX enclaves.
> + *
> + * @enclave_load:
> + *     On success, returns 0 and optionally adjusts @allowed_prot
> + *     @vma: the source memory region of the enclave page being loaded.
> + *     @prot: the initial protection of the enclave page.

What do you mean "initial"?  The page is always mapped PROT_NONE when
this is called, right?  I feel like I must be missing something here.
