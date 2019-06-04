Return-Path: <SRS0=DpJx=UD=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,T_DKIMWL_WL_HIGH autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C12CC282CE
	for <linux-sgx@archiver.kernel.org>; Tue,  4 Jun 2019 14:51:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2641F2166E
	for <linux-sgx@archiver.kernel.org>; Tue,  4 Jun 2019 14:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1559659912;
	bh=5ctEf83W1rzW6eB+79+i8bY5zg2vYEZv2TuztgDU1RY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=ci9pyKpX61dVXEGsI6N3a6q8zsvagghh/OxVcj9MJfxQ4fqiu+Rj/553sZTrPESWz
	 lKmKJbr1DKHlvVm5T4w1OSAsr0i7F3xU5NGovkbqytJEl7jCSAlHc065VBZfkAt5DR
	 0KArXnj7QoZybdCwbA2tYPvb+WZ0ryZI8c8MDg28=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727677AbfFDOvv (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 4 Jun 2019 10:51:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:33702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727650AbfFDOvv (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 4 Jun 2019 10:51:51 -0400
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83E4D2445E
        for <linux-sgx@vger.kernel.org>; Tue,  4 Jun 2019 14:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559659909;
        bh=5ctEf83W1rzW6eB+79+i8bY5zg2vYEZv2TuztgDU1RY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Z5muKAvqiH60dr+oNPEC5AgAynLm9WObA1y/7r3P5vBrYOMRVlNWOziGBm96tx8jy
         33EdItZ/kx1zx2ArVzadldXmio1CnXaZVB+cf5KkQBUyoV+JBNsoC/Zc17ggxYccHH
         rsc7CH3kNqzgv6bujbnoiS28SXtUqo/CVBeSFWsI=
Received: by mail-wr1-f43.google.com with SMTP id p11so11318777wre.7
        for <linux-sgx@vger.kernel.org>; Tue, 04 Jun 2019 07:51:49 -0700 (PDT)
X-Gm-Message-State: APjAAAV+g2xWmMBSC/s9Bod5MRHn7HAMiRVba6MwjUoPJoEbQJe7weXp
        PtzLuZyBHV0w2xU6p4eqFAbBw5NPfzoErhW0Qr/Xig==
X-Google-Smtp-Source: APXvYqwSuFe0LRPOuT6rqk2lttgw4kckoPd0dgTaQOVZmyVeGTJe31yqRs0TFMt3H2on2lXIznmhTkbDYf/W+odaTKU=
X-Received: by 2002:adf:fe90:: with SMTP id l16mr6870186wrr.221.1559659907969;
 Tue, 04 Jun 2019 07:51:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190531233159.30992-1-sean.j.christopherson@intel.com> <20190531233159.30992-5-sean.j.christopherson@intel.com>
In-Reply-To: <20190531233159.30992-5-sean.j.christopherson@intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Tue, 4 Jun 2019 07:51:36 -0700
X-Gmail-Original-Message-ID: <CALCETrWjZBp4Br2Lo03aBu9_PhH0Cr4Az_ywLADo-rztu4Y67Q@mail.gmail.com>
Message-ID: <CALCETrWjZBp4Br2Lo03aBu9_PhH0Cr4Az_ywLADo-rztu4Y67Q@mail.gmail.com>
Subject: Re: [RFC PATCH 4/9] mm: Introduce vm_ops->mprotect()
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
> SGX will use the mprotect() hook to prevent userspace from circumventing
> various security checks, i.e. Linux Security Modules.
>
> Enclaves are built by copying data from normal memory into the Enclave
> Page Cache (EPC).  Due to the nature of SGX, the EPC is represented by a
> single file that must be MAP_SHARED, i.e. mprotect() only ever sees a
> single MAP_SHARED vm_file.  Furthermore, all enclaves will need read,
> write and execute pages in the EPC.
>
> As a result, LSM policies cannot be meaningfully applied, e.g. an LSM
> can deny access to the EPC as a whole, but can't deny PROT_EXEC on page
> that originated in a non-EXECUTE file (which is long gone by the time
> mprotect() is called).
>
> By hooking mprotect(), SGX can make explicit LSM upcalls while an
> enclave is being built, i.e. when the kernel has a handle to origin of
> each enclave page, and enforce the result of the LSM policy whenever
> userspace maps the enclave page in the future.
>
> Alternatively, SGX could play games with MAY_{READ,WRITE,EXEC}, but
> that approach is quite ugly, e.g. would require userspace to call an
> SGX ioctl() prior to using mprotect() to extend a page's protections.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  include/linux/mm.h |  2 ++
>  mm/mprotect.c      | 15 +++++++++++----
>  2 files changed, 13 insertions(+), 4 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 0e8834ac32b7..50a42364a885 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -458,6 +458,8 @@ struct vm_operations_struct {
>         void (*close)(struct vm_area_struct * area);
>         int (*split)(struct vm_area_struct * area, unsigned long addr);
>         int (*mremap)(struct vm_area_struct * area);
> +       int (*mprotect)(struct vm_area_struct * area, unsigned long start,
> +                       unsigned long end, unsigned long prot);
>         vm_fault_t (*fault)(struct vm_fault *vmf);
>         vm_fault_t (*huge_fault)(struct vm_fault *vmf,
>                         enum page_entry_size pe_size);
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index bf38dfbbb4b4..e466ca5e4fe0 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -547,13 +547,20 @@ static int do_mprotect_pkey(unsigned long start, size_t len,
>                         goto out;
>                 }
>
> -               error = security_file_mprotect(vma, reqprot, prot);
> -               if (error)
> -                       goto out;
> -
>                 tmp = vma->vm_end;
>                 if (tmp > end)
>                         tmp = end;
> +
> +               if (vma->vm_ops && vma->vm_ops->mprotect) {
> +                       error = vma->vm_ops->mprotect(vma, nstart, tmp, prot);
> +                       if (error)
> +                               goto out;
> +               }
> +
> +               error = security_file_mprotect(vma, reqprot, prot);
> +               if (error)
> +                       goto out;
> +

I think that, if you're going to do it like this, you need to call it
mprotect_and_check_security or something.  Or you could just add
.may_mprotect, which is allowed to fail but, on success, falls through
to call security_file_mprotect and mprotect_fixup().

--Andy
