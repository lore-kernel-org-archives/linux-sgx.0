Return-Path: <SRS0=W/GT=TR=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DADDC04AB4
	for <linux-sgx@archiver.kernel.org>; Fri, 17 May 2019 18:53:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB7322177B
	for <linux-sgx@archiver.kernel.org>; Fri, 17 May 2019 18:53:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20150623.gappssmtp.com header.i=@amacapital-net.20150623.gappssmtp.com header.b="ip6rP4a7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728136AbfEQSxD (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 17 May 2019 14:53:03 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44139 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727461AbfEQSxD (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 17 May 2019 14:53:03 -0400
Received: by mail-pg1-f194.google.com with SMTP id z16so3686745pgv.11
        for <linux-sgx@vger.kernel.org>; Fri, 17 May 2019 11:53:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Zedk+akRmRCkjlP2v+DLCTRSwVyK89TYIDPpzH+WlCo=;
        b=ip6rP4a7K7+zXEf5W8Wi59dm82XG6OS0S9ZuQM/R3m4HZBPDpbEsryeSQAiNCUMo9n
         Npyu0Ex/7I6LSTU0Hn0T9B9ff3Qt7UHKpZ4kb10dgIjtzru1QNEgtg06cvgOrtmkvSb1
         ISueCn1+o+BjU7M/al9zR680IGNP81M2Qw5lkhqS3odOPIG4Szuv1+huK6X2LpmcVRNu
         D1YAcdMthvyCXOXfPq1Xk3wBo9rPn/9ozeUV9V07aIpTgpZegpqlAGe46klScMYLO4lD
         h7qUu9d/skpnGxNs/BXnYhbOSYwMNq17RQoSytbin/2RaC9iv4MkDYZ+yHk4Ncsq5ugT
         fCGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Zedk+akRmRCkjlP2v+DLCTRSwVyK89TYIDPpzH+WlCo=;
        b=T0ivXzpfMTYHjOZUEtQybNBTlqp/QeW4nOArayev9F2sDQ0Ed/FcR1lViKevVjNu4L
         3+Z74lAGaC3l52Jt7tzeKqAO+eOBZeKnjt1KPZZNCGxmyeStmzmHvkvi089bDOD4rYil
         H9NX/DTQYGbluWHYBM6ieEobhHYGs7G2NbVhTICJocwToacpd6H0FoKwI7FYSSBZ0F4+
         kNF6GgLu8Yt9IyGoVAzyD2Jd4d0CAXWCBhHLOxxP4xoV2ClEkRsmSXnRx7YAtyf249lC
         pOX6eXvuVa44UpI6aEcp9QUQQyC8w9ql+06DtqdkkiiiIc5vBfEMEVhBxCFDr11/AboM
         vtwQ==
X-Gm-Message-State: APjAAAVj2I0Brr1J5y+kr5s62Mpo7FQlLH7pRrvEbT10L339DiBGUcVF
        JJJ8LFzwhZ2NFkzEUkY52RUQ3A==
X-Google-Smtp-Source: APXvYqyTd69tqkuVEARG8Y+9ZovVDRZ6Vc29b6lGDGKyVcTXVijdT6jmM3t9cOKJjq1rFQRiuTEvwA==
X-Received: by 2002:aa7:8a11:: with SMTP id m17mr40233878pfa.122.1558119182522;
        Fri, 17 May 2019 11:53:02 -0700 (PDT)
Received: from ?IPv6:2600:1010:b04b:10dc:8986:2c48:2978:531d? ([2600:1010:b04b:10dc:8986:2c48:2978:531d])
        by smtp.gmail.com with ESMTPSA id t142sm529350pgb.32.2019.05.17.11.53.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 May 2019 11:53:01 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: SGX vs LSM (Re: [PATCH v20 00/28] Intel SGX1 support)
From:   Andy Lutomirski <luto@amacapital.net>
X-Mailer: iPhone Mail (16E227)
In-Reply-To: <20190517182124.GF15006@linux.intel.com>
Date:   Fri, 17 May 2019 11:53:00 -0700
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
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
Content-Transfer-Encoding: quoted-printable
Message-Id: <3FECC02D-C65C-4D35-B538-D32EC7D722D5@amacapital.net>
References: <CALCETrUfmyQ7ivNzQic0FyPXe1fmAnoK093jnz0i8DRn2LvdSA@mail.gmail.com> <960B34DE67B9E140824F1DCDEC400C0F654E3FB9@ORSMSX116.amr.corp.intel.com> <6a97c099-2f42-672e-a258-95bc09152363@tycho.nsa.gov> <20190517150948.GA15632@linux.intel.com> <ca807220-47e2-5ec2-982c-4fb4a72439c6@tycho.nsa.gov> <80013cca-f1c2-f4d5-7558-8f4e752ada76@tycho.nsa.gov> <20190517172953.GC15006@linux.intel.com> <DFE03E0C-694A-4289-B416-29CDC2644F94@amacapital.net> <20190517175500.GE15006@linux.intel.com> <CAHk-=wgH2FBzBG3_RZSuatpYCj8DCQZipJYp9vh3Wy_S3Qt4-g@mail.gmail.com> <20190517182124.GF15006@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org



> On May 17, 2019, at 11:21 AM, Sean Christopherson <sean.j.christopherson@i=
ntel.com> wrote:
>=20
>> On Fri, May 17, 2019 at 11:04:22AM -0700, Linus Torvalds wrote:
>> On Fri, May 17, 2019 at 10:55 AM Sean Christopherson
>> <sean.j.christopherson@intel.com> wrote:
>>>=20
>>> In this snippet, IS_PRIVATE() is true for anon inodes, false for
>>> /dev/sgx/enclave.  Because EPC memory is always shared, SELinux will nev=
er
>>> check PROCESS__EXECMEM for mprotect() on/dev/sgx/enclave.
>>=20
>> Why _does_ the memory have to be shared? Shared mmap() is
>> fundamentally less secure than private mmap, since by definition it
>> means "oh, somebody else has access to it too and might modify it
>> under us".
>>=20
>> Why does the SGX logic care about things like that? Normal executables
>> are just private mappings of an underlying file, I'm not sure why the
>> SGX interface has to have that shared thing, and why the interface has
>> to have a device node in the first place when  you have system calls
>> for setup anyway.
>>=20
>> So why don't the system calls just work on perfectly normal anonymous
>> mmap's? Why a device node, and why must it be shared to begin with?
>=20
> I agree that conceptually EPC is private memory, but because EPC is
> managed as a separate memory pool, SGX tags it VM_PFNMAP and manually
> inserts PFNs, i.e. EPC effectively it gets classified as IO memory.=20
>=20
> And vmf_insert_pfn_prot() doesn't like writable private IO mappings:
>=20
>   BUG_ON((vma->vm_flags & VM_PFNMAP) && is_cow_mapping(vma->vm_flags));

I don=E2=80=99t see how it could be anonymous even in principle.  The kernel=
 can=E2=80=99t *read* the memory =E2=80=94 how could we possibly CoW it?  An=
d we can=E2=80=99t share an RO backing pages between two different enclaves b=
ecause the CPU won=E2=80=99t let us =E2=80=94 each EPC page belongs to a par=
ticular enclave.  And fork()ing an enclave is right out.

So I agree that MAP_ANONYMOUS would be nice conceptually, but I don=E2=80=99=
t see how it would work.=
