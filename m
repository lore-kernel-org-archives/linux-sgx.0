Return-Path: <SRS0=Nb5J=TY=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB1BEC072B5
	for <linux-sgx@archiver.kernel.org>; Fri, 24 May 2019 17:54:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72ECA2133D
	for <linux-sgx@archiver.kernel.org>; Fri, 24 May 2019 17:54:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=amacapital-net.20150623.gappssmtp.com header.i=@amacapital-net.20150623.gappssmtp.com header.b="xsYcq8Zf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732001AbfEXRyh (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 24 May 2019 13:54:37 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42042 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726071AbfEXRyh (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 24 May 2019 13:54:37 -0400
Received: by mail-pg1-f195.google.com with SMTP id 33so2476577pgv.9
        for <linux-sgx@vger.kernel.org>; Fri, 24 May 2019 10:54:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20150623.gappssmtp.com; s=20150623;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=AiMq7X5uRUkfXWr/ckuGxaqgoZKW7dxJE49YSCmv3tk=;
        b=xsYcq8ZfW6SqZcBbIa0/V8+xcIXwI0l1zVXr2xWrNReCk0h9CVlougOI1XggA/M0nl
         LQzNvJNqQjYenemF25dgf0n29it65/GaYpITe4UFHzYQUxYrLetYTKx2x3dHHYS2zNIY
         m5QMClj7/RML+Zo0ANSYT0y9IOGrlkdTZQTi6NfS+YBSFAgddu8EnMssVsiW6NIZCOsZ
         sfPNxJR6B8z+BWJI1zQUAl+5t0RK0vuU7q8DwyTd5pfsXY7vhzS6L/w4So5b/J1fMf7P
         OGzpH3p4NqOKB1lKVCYY543Sp6vXaH3zCqJvaB7TsaddIwmJu6mR9FAvPh9aRG0ga517
         qqAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=AiMq7X5uRUkfXWr/ckuGxaqgoZKW7dxJE49YSCmv3tk=;
        b=fjvlMI4L/opLfl0h46B4ZFtjKwxKtxpu3ZxRqqDH0L2yceH6Yq1GtNGydeDeJOuixi
         oub4gAzeVT88pRztckLrBzW8PO9RLhwnRgV/AFaKC97s18g0nQdRY43W3YGNSfvDlN2I
         EocoSx6DpGySoe0hepbMxLAKQjxZMq5K5EJu9Fe1M8DUophRpX/+WJTzHaAUyGpZgywg
         OujZfCmPDBJM4mFDdXXv2hzitHUJ4wDZhefESo2s9YH0jM6AQF9x0DFsCB3blTDx6rQt
         QgE0bgn6gHCKTHU7RE7V8JnV7YwGlsUw8ChXQE0+9oDdjWaPW0s6BQXzI5U86MRexgKX
         ERvg==
X-Gm-Message-State: APjAAAUlbtVMgy6jMiPUXOeslLj9lFPd+0RXiU77nBDz1MH5yz5kqdwB
        D6NKrv9OlwYggJ+j8MNhRQwE/g==
X-Google-Smtp-Source: APXvYqwhceudFEnABJG5KjuF1THk0ddwVSYE5f+E/bItsNyrOdizHLXZ4zANMS6vhBdtXIKf04YIDg==
X-Received: by 2002:a63:184:: with SMTP id 126mr80473568pgb.420.1558720476456;
        Fri, 24 May 2019 10:54:36 -0700 (PDT)
Received: from ?IPv6:2601:646:c200:1ef2:25e7:e273:cc72:2b04? ([2601:646:c200:1ef2:25e7:e273:cc72:2b04])
        by smtp.gmail.com with ESMTPSA id g83sm3432782pfb.158.2019.05.24.10.54.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 May 2019 10:54:35 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (1.0)
Subject: Re: SGX vs LSM (Re: [PATCH v20 00/28] Intel SGX1 support)
From:   Andy Lutomirski <luto@amacapital.net>
X-Mailer: iPhone Mail (16E227)
In-Reply-To: <20190524174243.GA365@linux.intel.com>
Date:   Fri, 24 May 2019 10:54:34 -0700
Cc:     Stephen Smalley <sds@tycho.nsa.gov>,
        "Xing, Cedric" <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
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
Message-Id: <56EA6C7C-F69E-42EB-9CFB-CD0300549298@amacapital.net>
References: <20190522153836.GA24833@linux.intel.com> <CALCETrUS8xyF1JJmQs18BGTDhPRXf+s81BkMZCZwmY73r7M+zg@mail.gmail.com> <20190523023517.GA31950@linux.intel.com> <20190523102628.GC10955@linux.intel.com> <20190523141752.GA12078@linux.intel.com> <CALCETrUzx3LPAKCLFf75P-XshAkRcr+JLET3LA_kHDs9MA11FA@mail.gmail.com> <20190523234044.GC12078@linux.intel.com> <CALCETrV4DVEfW6EJ6DnQGGYDJAiA5M1QcuYJTiroumOM+D6Jjg@mail.gmail.com> <960B34DE67B9E140824F1DCDEC400C0F654E8956@ORSMSX116.amr.corp.intel.com> <dda0912b-cb15-3c07-d368-345159e995f7@tycho.nsa.gov> <20190524174243.GA365@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org



> On May 24, 2019, at 10:42 AM, Sean Christopherson <sean.j.christopherson@i=
ntel.com> wrote:
>=20
>> On Fri, May 24, 2019 at 11:41:29AM -0400, Stephen Smalley wrote:
>>> On 5/24/19 3:24 AM, Xing, Cedric wrote:
>>> /**
>>> * Summary:
>>> * - The enclave file resembles a shared object that contains RO/RX/RW se=
gments
>>> * - FILE__* are assigned to /dev/sgx/enclave, to determine acceptable pe=
rmissions to mmap()/mprotect(), valid combinations are
>>> *   + FILE__READ - Allow SGX1 enclaves only
>>> *   + FILE__READ|FILE__WRITE - Allow SGX2 enclaves to expand data segmen=
ts (e.g. heaps, stacks, etc.)
>>> *   + FILE__READ|FILE__WRITE|FILE__EXECUTE - Allow SGX2 enclaves to expe=
nd both data and code segments. This is necessary to support dynamically lin=
ked enclaves (e.g. Graphene)
>>> *   + FILE__READ|FILE__EXECUTE - Allow RW->RX changes for SGX1 enclaves -=
 necessary to support dynamically linked enclaves (e.g. Graphene) on SGX1. E=
XECMEM is also required for this to work
>>=20
>> I think EXECMOD would fit better than EXECMEM for this case; the former i=
s
>> applied for RW->RX changes for private file mappings while the latter is
>> applied for WX private file mappings.
>>=20
>>> *   + <None> - Disallow the calling process to launch any enclaves
>>> */
>>>=20
>>> /* Step 1: mmap() the enclave file according to the segment attributes (=
similar to what dlopen() would do for regular shared objects) */
>>> int image_fd =3D open("/path/to/enclave/file", O_RDONLY);
>>=20
>> FILE__READ checked to enclave file upon open().
>>=20
>>> foreach phdr in loadable segments /* phdr->p_type =3D=3D PT_LOAD */ {
>>>    /* <segment permission> below is subject to LSM checks */
>>>    loadable_segments[i] =3D mmap(NULL, phdr->p_memsz, MAP_PRIATE, <segme=
nt permission>, image_fd, phdr->p_offset);
>>=20
>> FILE__READ revalidated and FILE__EXECUTE checked to enclave file upon mma=
p()
>> for PROT_READ and PROT_EXEC respectively.  FILE__WRITE not checked even f=
or
>> PROT_WRITE mappings since it is a private file mapping and writes do not
>> reach the file.  EXECMEM checked if any segment permission has both W and=
 X
>> simultaneously.  EXECMOD checked on any subsequent mprotect() RW->RX chan=
ges
>> (if modified).
>=20
> Hmm, I've been thinking more about pulling permissions from the source
> page.  Conceptually I'm not sure we need to meet the same requirements as
> non-enclave DSOs while the enclave is being built, i.e. do we really need
> to force userspace to fully map the enclave in normal memory?
>=20
> Consider the Graphene scenario where it's building an enclave on the fly.
> Pulling permissions from the source VMAs means Graphene has to map the
> code pages of the enclave with X.  This means Graphene will need EXEDMOD
> (or EXECMEM if Graphene isn't careful).  In a non-SGX scenario this makes
> perfect sense since there is no way to verify the end result of RW->RX.
>=20
> But for SGX, assuming enclaves are whitelisted by their sigstruct (checked=

> at EINIT) and because page permissions affect sigstruct.MRENCLAVE, it *is*=

> possible to verify the resulting RX contents.  E.g. for the purposes of
> LSMs, can't we use the .sigstruct file as a proxy for the enclave and
> require FILE__EXECUTE on the .sigstruct inode to map/run the enclave?

I think it=E2=80=99s sound for some but not all use cases. I would imagine t=
hat a lot of users won=E2=80=99t restrict sigstruct at all =E2=80=94 the =E2=
=80=9Cuse this as a sigstruct=E2=80=9D permission will be granted to everyth=
ing and maybe even to memfd. But even users like that might want to force th=
eir enclaves to be hardened such that writable pages are never executable, i=
n which case Graphene may need an exception to run.

But maybe I=E2=80=99m nuts.
