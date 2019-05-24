Return-Path: <SRS0=Nb5J=TY=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88E43C282E1
	for <linux-sgx@archiver.kernel.org>; Fri, 24 May 2019 23:42:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4BD9E217F9
	for <linux-sgx@archiver.kernel.org>; Fri, 24 May 2019 23:42:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20150623.gappssmtp.com header.i=@amacapital-net.20150623.gappssmtp.com header.b="H+YEoYZ5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726102AbfEXXmH (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 24 May 2019 19:42:07 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37119 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726024AbfEXXmG (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 24 May 2019 19:42:06 -0400
Received: by mail-pf1-f195.google.com with SMTP id a23so6198862pff.4
        for <linux-sgx@vger.kernel.org>; Fri, 24 May 2019 16:42:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=2WVyrwyoR+Miiyf53lPdpTDFqJtRFdKUz05NfzTWxQk=;
        b=H+YEoYZ5/bL+lZ3PN1AOE2ZrYyGPfFiEqkbUvCO2YrFErto3JeP6+D56wdPa+nXNnc
         twQMX1JBpW80lFrmq8PGCyYvGMQkpEIdC4k+CeMvpPynTzEozIb0HDS7pQXb8iLrYQWI
         86Z0vEXrJmsOhjfT2A+ryc2oSlmUq8NVuchIa9+6+kfz0spjQAoPeM/nDQxXVylAaLs6
         52GZFp+bWbU6fM4r9ytbpHAd4E+n5fRIawGtLuj3VU0EnHeFgK2Qz0afcE/bcaS3KYog
         zriV2VOs1Ab4ceGEzVVf9Ia01ejsnETeb1M7c9i4ieHXAZj+t4yYDsGo88GrNeqJ/XW9
         kBMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=2WVyrwyoR+Miiyf53lPdpTDFqJtRFdKUz05NfzTWxQk=;
        b=fvNNBtHkgqr7r3ob+NwvtquRuAa6524D287Bpjwq56loZqBs0jf2ugledCXzJ6rty6
         oRtlY3txiV0D8g83XmOahlN6NXiOay3L9nRW0soogd5ozgyHntbiqRdnEJwkfZAhy+hc
         uBbteD3nfAL5QmvcCWhuEoCV1wW+OSXhNzl0DvnP1AwMV2BIU/4BLKjM9FZ5+iYc6ALm
         1shh+TNXGSDOnm9+BDmkIlC194mHLHQLgfbZgfeE6Pmn0w8XEzWR/sQw84BV6Ty2h7MB
         SGtrPRzDPFDuxqPhycebKBqTdPwDQ8pX27CFvS408rDYsXZx1hP1LzEovA2prAngphsn
         2Bgg==
X-Gm-Message-State: APjAAAUpTrC0NOGVkY7aVE17RZYO+tPUIuI6PMwfuI5asZLymYpvBrTd
        WF7HTpRyIoNxvxP7hh3YiodeqA==
X-Google-Smtp-Source: APXvYqzGDIUfGSUjlwrYLOEcA/mL7phVDD2lSgoP5FutrUmtvK03CiHGMdyhZUjZA/SPWtvLIBE6yg==
X-Received: by 2002:a62:e117:: with SMTP id q23mr116579179pfh.60.1558741325678;
        Fri, 24 May 2019 16:42:05 -0700 (PDT)
Received: from ?IPv6:2600:1010:b01d:ffa2:d9bd:516:12f0:5e2d? ([2600:1010:b01d:ffa2:d9bd:516:12f0:5e2d])
        by smtp.gmail.com with ESMTPSA id e10sm6420074pfm.137.2019.05.24.16.42.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 May 2019 16:42:03 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: SGX vs LSM (Re: [PATCH v20 00/28] Intel SGX1 support)
From:   Andy Lutomirski <luto@amacapital.net>
X-Mailer: iPhone Mail (16E227)
In-Reply-To: <20190524224107.GJ365@linux.intel.com>
Date:   Fri, 24 May 2019 16:42:01 -0700
Cc:     Andy Lutomirski <luto@kernel.org>,
        "Xing, Cedric" <cedric.xing@intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Dr. Greg" <greg@enjellic.com>,
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
        David Rientjes <rientjes@google.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <683B5E3D-AFB6-4B45-8D39-B00847312209@amacapital.net>
References: <20190523234044.GC12078@linux.intel.com> <CALCETrV4DVEfW6EJ6DnQGGYDJAiA5M1QcuYJTiroumOM+D6Jjg@mail.gmail.com> <960B34DE67B9E140824F1DCDEC400C0F654E8956@ORSMSX116.amr.corp.intel.com> <dda0912b-cb15-3c07-d368-345159e995f7@tycho.nsa.gov> <20190524174243.GA365@linux.intel.com> <20190524175458.GB365@linux.intel.com> <960B34DE67B9E140824F1DCDEC400C0F654E8E1D@ORSMSX116.amr.corp.intel.com> <CALCETrUw5sEr-MHPMU4CzEzkrejDs-JOThHB9Buhoxo5-rdpRw@mail.gmail.com> <20190524200333.GF365@linux.intel.com> <CALCETrUyAAhnQ+RUeN1L41TKj-vcD2CNt-FJ9siO=Zo6gvH1Aw@mail.gmail.com> <20190524224107.GJ365@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org



> On May 24, 2019, at 3:41 PM, Sean Christopherson <sean.j.christopherson@in=
tel.com> wrote:
>=20
>> On Fri, May 24, 2019 at 02:27:34PM -0700, Andy Lutomirski wrote:
>> On Fri, May 24, 2019 at 1:03 PM Sean Christopherson
>> <sean.j.christopherson@intel.com> wrote:
>>>=20
>>>> On Fri, May 24, 2019 at 12:37:44PM -0700, Andy Lutomirski wrote:
>>>>> On Fri, May 24, 2019 at 11:34 AM Xing, Cedric <cedric.xing@intel.com> w=
rote:
>>>>>=20
>>>>> If "initial permissions" for enclaves are less restrictive than shared=

>>>>> objects, then it'd become a backdoor for circumventing LSM when enclav=
e
>>>>> whitelisting is *not* in place. For example, an adversary may load a p=
age,
>>>>> which would otherwise never be executable, as an executable page in EP=
C.
>>>>>=20
>>>>> In the case a RWX page is needed, the calling process has to have a RW=
X
>>>>> page serving as the source for EADD so PROCESS__EXECMEM will have been=

>>>>> checked. For SGX2, changing an EPC page to RWX is subject to FILE__EXE=
CMEM
>>>>> on /dev/sgx/enclave, which I see as a security benefit because it only=

>>>>> affects the enclave but not the whole process hosting it.
>>>>=20
>>>> So the permission would be like FILE__EXECMOD on the source enclave
>>>> page, because it would be mapped MAP_ANONYMOUS, PROT_WRITE?
>>>> MAP_SHARED, PROT_WRITE isn't going to work because that means you can
>>>> modify the file.
>>>=20
>>> Was this in response to Cedric's comment, or to my comment?
>>=20
>> Yours.  I think that requiring source pages to be actually mapped W is
>> not such a great idea.
>=20
> I wasn't requiring source pages to be mapped W.  At least I didn't intend
> to require W.  What I was trying to say is that SGX could trigger an
> EXECMEM check if userspace attempted to EADD or EAUG an enclave page with
> RWX permissions, e.g.:
>=20
>  if ((SECINFO.PERMS & RWX) =3D=3D RWX) {
>      ret =3D security_mmap_file(NULL, RWX, ???);
>      if (ret)
>          return ret;
>  }
>=20
> But that's a moot point if we add security_enclave_load() or whatever.
>=20
>>=20
>>>=20
>>>> I'm starting to think that looking at the source VMA permission bits
>>>> or source PTE permission bits is putting a bit too much policy into
>>>> the driver as opposed to the LSM.  How about delegating the whole
>>>> thing to an LSM hook?  The EADD operation would invoke a new hook,
>>>> something like:
>>>>=20
>>>> int security_enclave_load_bytes(void *source_addr, struct
>>>> vm_area_struct *source_vma, loff_t source_offset, unsigned int
>>>> maxperm);
>>>>=20
>>>> Then you don't have to muck with mapping anything PROT_EXEC.  Instead
>>>> you load from a mapping of a file and the LSM applies whatever policy
>>>> it feels appropriate.  If the first pass gets something wrong, the
>>>> application or library authors can take it up with the SELinux folks
>>>> without breaking the whole ABI :)
>>>>=20
>>>> (I'm proposing passing in the source_vma because this hook would be
>>>> called with mmap_sem held for read to avoid a TOCTOU race.)
>>>>=20
>>>> If we go this route, the only substantial change to the existing
>>>> driver that's needed for an initial upstream merge is the maxperm
>>>> mechanism and whatever hopefully minimal API changes are needed to
>>>> allow users to conveniently set up the mappings.  And we don't need to
>>>> worry about how to hack around mprotect() calling into the LSM,
>>>> because the LSM will actually be aware of SGX and can just do the
>>>> right thing.
>>>=20
>>> This doesn't address restricting which processes can run which enclaves,=

>>> it only allows restricting the build flow.  Or are you suggesting this
>>> be done in addition to whitelisting sigstructs?
>>=20
>> In addition.
>>=20
>> But I named the function badly and gave it a bad signature, which
>> confused you.  Let's try again:
>>=20
>> int security_enclave_load_from_memory(const struct vm_area_struct
>> *source, unsigned int maxperm);
>=20
> I prefer security_enclave_load(), "from_memory" seems redundant at best.

Fine with me.

>=20
>> Maybe some really fancy future LSM would also want loff_t
>> source_offset, but it's probably not terribly useful.  This same
>> callback would be used for EAUG.
>>=20
>> Following up on your discussion with Cedric about sigstruct, the other
>> callback would be something like:
>>=20
>> int security_enclave_init(struct file *sigstruct_file);
>>=20
>> The main issue I see is that we also want to control the enclave's
>> ability to have RWX pages or to change a W page to X.  We might also
>> want:
>>=20
>> int security_enclave_load_zeros(unsigned int maxperm);
>=20
> What's the use case for this?  @maxperm will always be at least RW in
> this case, otherwise the page is useless to the enclave, and if the
> enclave can write the page, the fact that it started as zeros is
> irrelevant.

This is how EAUG could ask if RWX is okay. If an enclave is internally doing=
 dynamic loading, the it will need a heap page with maxperm =3D RWX.  (If it=
=E2=80=99s well designed, it will make it RW and then RX, either by changing=
 SECINFO or by asking the host to mprotect() it, but it still needs the over=
all RWX mask.).

Also, do real SGX1 enclave formats have BSS? If so, then either we need an i=
octl or load zeros or user code is going to load from /dev/zero or just from=
 the heap, but the LSM is going to play better with an ioctl, I suspect :)

>=20
>> An enclave that's going to modify its own code will need memory with
>> maxperm =3D RWX or WX.
>>=20
>> But this is a bit awkward if the LSM's decision depends on the
>> sigstruct.  We could get fancy and require that the sigstruct be
>> supplied before any EADD operations so that the maxperm decisions can
>> depend on the sigstruct.
>>=20
>> Am I making more sense now?
>=20
> Yep.  Requiring .sigstruct at ECREATE would be trivial.  If we wanted
> flexibility we could do:
>=20
>   int security_enclave_load(struct file *file, struct vm_area_struct *vma,=

>                             unsigned long prot);
>=20
> And for ultimate flexibility we could pass both .sigstruct and the file
> pointer for /dev/sgx/enclave, but that seems a bit ridiculous.

I agree.

>=20
> Passing both would allow tying EXECMOD to /dev/sgx/enclave as Cedric
> wanted (without having to play games and pass /dev/sgx/enclave to
> security_enclave_load()), but I don't think there's anything fundamentally=

> broken with using .sigstruct for EXECMOD.  It requires more verbose
> labeling, but that's not a bad thing.

The benefit of putting it on .sigstruct is that it can be per-enclave.

As I understand it from Fedora packaging, the way this works on distros is g=
enerally that a package will include some files and their associated labels,=
 and, if the package needs EXECMOD, then the files are labeled with EXECMOD a=
nd the author of the relevant code might get a dirty look.

This could translate to the author of an exclave that needs RWX regions gett=
ing a dirty look without leaking this permission into other enclaves.

(In my opinion, the dirty looks are actually the best security benefit of th=
e entire concept of LSMs making RWX difficult.  A sufficiently creative atta=
cker can almost always bypass W^X restrictions once they=E2=80=99ve pwned yo=
u, but W^X makes it harder to pwn you in the first place, and SELinux makes i=
t really obvious when packaging a program that doesn=E2=80=99t respect W^X. =
 The upshot is that a lot of programs got fixed.)=
