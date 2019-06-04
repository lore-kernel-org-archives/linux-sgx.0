Return-Path: <SRS0=DpJx=UD=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,T_DKIMWL_WL_HIGH,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD54AC282CE
	for <linux-sgx@archiver.kernel.org>; Tue,  4 Jun 2019 20:32:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87BD22070B
	for <linux-sgx@archiver.kernel.org>; Tue,  4 Jun 2019 20:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1559680359;
	bh=S4TVF7E2iuUumroeAZ+UX1mM+MIND0JGN/wS2NYA7x4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=yrEQ4fkzoZDko/IElfpkZaJ4Jkd5jACa4Bq+32/Gcs+lxuzYnQSHT5JIWzwlja4EM
	 6BrUknYWDAIWDwjhPRHQ5zxX6/xz5VPAD1Zrhv9BJeyPi0Vy1fZ6uvnLwdt7n8iiUy
	 lY1lchPGikCvQmL3bxAFQtqpwTlAZD3yR7JZX5Zg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbfFDUc0 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 4 Jun 2019 16:32:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:60392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726791AbfFDUcY (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 4 Jun 2019 16:32:24 -0400
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7C8F208C3
        for <linux-sgx@vger.kernel.org>; Tue,  4 Jun 2019 20:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559679979;
        bh=S4TVF7E2iuUumroeAZ+UX1mM+MIND0JGN/wS2NYA7x4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=TZBQqTNxxTzP1mGVaees7RCepfLJrDp5RqAlHnL/Ymc/ao63W7bUZ2+GUYPGLR70H
         NfXQhyKCul5pGMw0cZZoSHpg0S1JbeoCbhmSuGPei3w66RYX2/ENL8maMPOo/zBUsi
         cFK3D30x08WNFrS12M+rfNw1TJIvGfAx/SxwGo54=
Received: by mail-wr1-f42.google.com with SMTP id d18so17186209wrs.5
        for <linux-sgx@vger.kernel.org>; Tue, 04 Jun 2019 13:26:18 -0700 (PDT)
X-Gm-Message-State: APjAAAVPHlOGAtAyBDRXN5b//2ABB5NMuyd6RR81HEuF309G1SNQd7s+
        DVhVl1qtWKMrMbfeGFaqVqSWh7iZP6DlUq2D8oB+sQ==
X-Google-Smtp-Source: APXvYqwa0ftoy0sMT67Ri2vN0Uz4JEOrVwQyRXQKgM3vFKhn6zeRoO/sOuA5vu06dNe8x+pyx4YNLtPF6kNlT7kOoDU=
X-Received: by 2002:a5d:610e:: with SMTP id v14mr22433987wrt.343.1559679977366;
 Tue, 04 Jun 2019 13:26:17 -0700 (PDT)
MIME-Version: 1.0
References: <20190531233159.30992-1-sean.j.christopherson@intel.com>
 <20190531233159.30992-8-sean.j.christopherson@intel.com> <960B34DE67B9E140824F1DCDEC400C0F654ECC53@ORSMSX116.amr.corp.intel.com>
In-Reply-To: <960B34DE67B9E140824F1DCDEC400C0F654ECC53@ORSMSX116.amr.corp.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Tue, 4 Jun 2019 13:26:06 -0700
X-Gmail-Original-Message-ID: <CALCETrVnpFFxNr0=PB9DWqQLeuNoFaa8_iihAcxcQMNrm5ChzA@mail.gmail.com>
Message-ID: <CALCETrVnpFFxNr0=PB9DWqQLeuNoFaa8_iihAcxcQMNrm5ChzA@mail.gmail.com>
Subject: Re: [RFC PATCH 7/9] x86/sgx: Enforce noexec filesystem restriction
 for enclaves
To:     "Xing, Cedric" <cedric.xing@intel.com>
Cc:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>,
        "Roberts, William C" <william.c.roberts@intel.com>,
        "Tricca, Philip B" <philip.b.tricca@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sun, Jun 2, 2019 at 11:29 PM Xing, Cedric <cedric.xing@intel.com> wrote:
>
> > From: Christopherson, Sean J
> > Sent: Friday, May 31, 2019 4:32 PM
> >
> > Do not allow an enclave page to be mapped with PROT_EXEC if the source page is backed by a
> > file on a noexec file system.
> >
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> > ---
> >  arch/x86/kernel/cpu/sgx/driver/ioctl.c | 26 ++++++++++++++++++++++++--
> >  1 file changed, 24 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> > b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> > index c30acd3fbbdd..5f71be7cbb01 100644
> > --- a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> > +++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
> > @@ -576,6 +576,27 @@ static int __sgx_encl_add_page(struct sgx_encl *encl, unsigned long
> > addr,
> >       return ret;
> >  }
> >
> > +static int sgx_encl_page_protect(unsigned long src, unsigned long prot,
> > +                              unsigned long *allowed_prot)
> > +{
> > +     struct vm_area_struct *vma;
> > +
> > +     if (!(*allowed_prot & VM_EXEC))
> > +             goto do_check;
> > +
> > +     down_read(&current->mm->mmap_sem);
> > +     vma = find_vma(current->mm, src);
> > +     if (!vma || (vma->vm_file && path_noexec(&vma->vm_file->f_path)))
> > +             *allowed_prot &= ~VM_EXEC;
>
> Testing (vma->vm_flags & VM_MAYEXEC) == 0 should be a better approach.

I think I agree, although that would need a comment explaining why it works.
