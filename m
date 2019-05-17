Return-Path: <SRS0=W/GT=TR=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9029BC04AB4
	for <linux-sgx@archiver.kernel.org>; Fri, 17 May 2019 18:33:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5790021726
	for <linux-sgx@archiver.kernel.org>; Fri, 17 May 2019 18:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558118033;
	bh=zBXRbeIQrwFN+otrC2SUsB1tTk/+5ebPtDQk7hrMMvE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=Eok1hvdo/YtXNqT7JebhwPcdwsBrOfWJa1sGUUrpAI27yDYemOJOstSHjwLOkE0AA
	 cpv/tRaK9VCXGF4ZtR0MFxA5hTAV5+FcNzm1hVmefmwsOMjAX92t0sF7dD+9beX7LF
	 E/pvm03wORyeu6a4af1pxVcx2+T475Tc1ASnirmk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbfEQSdw (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 17 May 2019 14:33:52 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:41403 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726282AbfEQSdw (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 17 May 2019 14:33:52 -0400
Received: by mail-lf1-f66.google.com with SMTP id d8so6004152lfb.8
        for <linux-sgx@vger.kernel.org>; Fri, 17 May 2019 11:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oO/GMUgT+1j7VBkn8MyV9uRSDi94nW1hm071Hw5jVSo=;
        b=Fg3ijOgmH36WIunWDge4wgVr1HpSUVX9oAp+UCHPw0NDKT8DXkwZR5Mut0XUVphKdk
         7WE868HzNhOuKCXNTdn21kpMbzVCMJsRd2eClEQCb4geolrkgNdveLxZ1t0pqQciLaT5
         bwxxuYpv6Ki2BW9/dHBX6rwlLrcuW+6kpcRCs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oO/GMUgT+1j7VBkn8MyV9uRSDi94nW1hm071Hw5jVSo=;
        b=cm/Q2FH4JqMyIzeIsajsfceHPuIfiYhnBNlsuB6EFU2OS135LCNIhDmEgvq02LXGcK
         gyXSreipT36S206xE3Q0FefqbgeQwtLLilg2ef0DKeq2xKTGN3lVfyKStZ11Cezy6YTh
         4HvpxjjplTrZn4rNl5RMzsLFhJstmaoxOZKbAFYPnjltA7LNmvo9vl+GPFM/le7cxWwc
         WTzUaXbipSsrjPT5lfYalUuiy234YDWOVIhCrk8fBy60iFryJTjq/PNF4VrNnVZmRi01
         mP5PVSo6YWseBvbz/eLsjP/MOlD0xh3AMepopEgBWOTgMUexD/XTH7wDBzgyF2Og6brQ
         bXvg==
X-Gm-Message-State: APjAAAVMWcbIMXeu60nu2xsLpaA9wcItFz2CFe9fbD6t6BHGJ2vlwpO5
        vqsnou+W5jE3ti8OfyfIW5j54jqaUk8=
X-Google-Smtp-Source: APXvYqw0Q8wjIuUdRQC6oDQV01saSviPC/Z6q7W2LOglH1xaEujSrG4wMAFgyZ4tQtcFFsR6Gv843w==
X-Received: by 2002:ac2:510b:: with SMTP id q11mr26721593lfb.11.1558118029440;
        Fri, 17 May 2019 11:33:49 -0700 (PDT)
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com. [209.85.208.171])
        by smtp.gmail.com with ESMTPSA id v24sm1696174lje.25.2019.05.17.11.33.46
        for <linux-sgx@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 May 2019 11:33:46 -0700 (PDT)
Received: by mail-lj1-f171.google.com with SMTP id d15so7138547ljc.7
        for <linux-sgx@vger.kernel.org>; Fri, 17 May 2019 11:33:46 -0700 (PDT)
X-Received: by 2002:a2e:9546:: with SMTP id t6mr8446776ljh.51.1558118026162;
 Fri, 17 May 2019 11:33:46 -0700 (PDT)
MIME-Version: 1.0
References: <CALCETrUfmyQ7ivNzQic0FyPXe1fmAnoK093jnz0i8DRn2LvdSA@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F654E3FB9@ORSMSX116.amr.corp.intel.com>
 <6a97c099-2f42-672e-a258-95bc09152363@tycho.nsa.gov> <20190517150948.GA15632@linux.intel.com>
 <ca807220-47e2-5ec2-982c-4fb4a72439c6@tycho.nsa.gov> <80013cca-f1c2-f4d5-7558-8f4e752ada76@tycho.nsa.gov>
 <20190517172953.GC15006@linux.intel.com> <DFE03E0C-694A-4289-B416-29CDC2644F94@amacapital.net>
 <20190517175500.GE15006@linux.intel.com> <CAHk-=wgH2FBzBG3_RZSuatpYCj8DCQZipJYp9vh3Wy_S3Qt4-g@mail.gmail.com>
 <20190517182124.GF15006@linux.intel.com>
In-Reply-To: <20190517182124.GF15006@linux.intel.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 17 May 2019 11:33:30 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi6N1ckASALGDSydzj+YXwAUq26uVPZD0r2q4Mjwss7hw@mail.gmail.com>
Message-ID: <CAHk-=wi6N1ckASALGDSydzj+YXwAUq26uVPZD0r2q4Mjwss7hw@mail.gmail.com>
Subject: Re: SGX vs LSM (Re: [PATCH v20 00/28] Intel SGX1 support)
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        "Xing, Cedric" <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Dr. Greg" <greg@enjellic.com>,
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
        David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, May 17, 2019 at 11:21 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> I agree that conceptually EPC is private memory, but because EPC is
> managed as a separate memory pool, SGX tags it VM_PFNMAP and manually
> inserts PFNs, i.e. EPC effectively it gets classified as IO memory.
>
> And vmf_insert_pfn_prot() doesn't like writable private IO mappings:
>
>    BUG_ON((vma->vm_flags & VM_PFNMAP) && is_cow_mapping(vma->vm_flags));

Hmm. I haven't looked into why you want to do your own page insertion
and not just "use existing pages", but I'm sure there's some reason.

It looks like the "shared vs private" inode part is a red herring,
though. You might as well give each opener of the sgx node its own
inode - and you probably should. Then you can keep track of the pages
that have been added in the inode->i_mapping, and you could avoid the
whole PFN thing entirely. I still am not a huge fan of the device node
in the first place, but I guess it's just one more place where a
system admin can then give (or deny) access to a kernel feature from
users. I guess the kvm people do the same thing, for not necessarily
any better reasons.

With the PFNMAP model I guess the SGX memory ends up being unswappable
- at least done the obvious way.

Again, the way I'd expect it to be done is as a shmem inode - that
would I think be a better model. But I think that's a largely internal
design decision, and the device node could just do that eventually
(and the mmap could just map the populated shmem information into
memory, no PFNMAP needed - the inode and the mapping could be
"read-only" as far as the _user_ is concerned, but the i_mapping then
gets populated by the ioctl's).

I have not actually looked at any of the SGX patches, so maybe you're
already doing something like that (although the PFNMAP comment makes
me think not), and quite possibly there's some fundamental reason why
you can't just use the shmem approach.

So my high-level reaction here may be just the rantings of somebody
who just isn't familiar with what you do. My "why not shmem and
regular mmap" questions come from a 30000ft view without knowing any
of the details.

                   Linus
