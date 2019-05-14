Return-Path: <SRS0=nHr/=TO=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 774D2C04AB4
	for <linux-sgx@archiver.kernel.org>; Tue, 14 May 2019 15:08:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F9CD216F4
	for <linux-sgx@archiver.kernel.org>; Tue, 14 May 2019 15:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1557846499;
	bh=uFBOIAJuJJn9eG4hdMOo/0HtgolIWidCe+VP9TR2ric=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=DXXXdTLV8oMeBpnleyGNEv7odIGe/37HRi+OlHCeq1ppyYKQ13DaxPtNLjQrjRIpA
	 cvIilqJ//ZYUpVEf9vDZW/II1KfLx8kf5lh7sDMO2nrpfhdJfpKwSIsVNe7H4yXeUd
	 tYYhfW6P+UeEnSl+OiuAYQ6TLTtaED8WZ6p7eTFk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726302AbfENPIT (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 14 May 2019 11:08:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:45674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725854AbfENPIS (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 14 May 2019 11:08:18 -0400
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8DAF216F4
        for <linux-sgx@vger.kernel.org>; Tue, 14 May 2019 15:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557846497;
        bh=uFBOIAJuJJn9eG4hdMOo/0HtgolIWidCe+VP9TR2ric=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=hn4XsD7rdUBM3zAWlZfe8yiZd3281ar20Nbm6W0BukStHsuEiKJy6FxsZcmHeo2/R
         tUjDqmspcbUBpm25xFDUQlRxhqeTYKgFNU5juzte7d8bDl+ImqzTybE/Yq5apRAMEQ
         PDeuT0LwUFzzv5En0iC10ez7V08HIBC1lXKsjoyI=
Received: by mail-wr1-f52.google.com with SMTP id l2so19620432wrb.9
        for <linux-sgx@vger.kernel.org>; Tue, 14 May 2019 08:08:16 -0700 (PDT)
X-Gm-Message-State: APjAAAVQ2N1Wbk4knhqe6x07buvWdOBdTIbhGDG0Qo+Y2sFjqDxTX/Gj
        o/wvjjGuPSVRo5TVsq8yUr8tPZ1p4odgMoRETahvNQ==
X-Google-Smtp-Source: APXvYqwboTitGEVChl2NUfxveIybzxOQsclHqlk9rDMOmaKeaoNVIsosLJp6sEzpEOh5ANUnFkp5DjE1yTzmE+Gx5rw=
X-Received: by 2002:a5d:4907:: with SMTP id x7mr10042481wrq.199.1557846495382;
 Tue, 14 May 2019 08:08:15 -0700 (PDT)
MIME-Version: 1.0
References: <20190417103938.7762-1-jarkko.sakkinen@linux.intel.com>
 <alpine.DEB.2.21.1904192233390.3174@nanos.tec.linutronix.de>
 <8c5133bc-1301-24ca-418d-7151a6eac0e2@fortanix.com> <alpine.DEB.2.21.1904192248550.3174@nanos.tec.linutronix.de>
 <e1478f70-7e44-6e3e-2aaf-1b12a96328ed@fortanix.com> <2AE80EA3-799E-4808-BBE4-3872F425BCF8@amacapital.net>
 <49b28ca1-6e66-87d9-2202-84c58f13fb99@fortanix.com> <444537E3-4156-41FB-83CA-57C5B660523F@amacapital.net>
 <f9d93291-9b59-7b66-de9f-af92246f1c9c@fortanix.com> <alpine.DEB.2.21.1904192337160.3174@nanos.tec.linutronix.de>
 <5854e66a-950e-1b12-5393-d9cdd15367dc@fortanix.com> <CALCETrV7CcDnx1hVtmBnDNABG11GuMqyspJMMpV+zHpVeFu3ow@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F4E885F9D@ORSMSX116.amr.corp.intel.com>
 <979615a8-fd03-e3fd-fbdb-65c1e51afd93@fortanix.com> <8fe520bb-30bd-f246-a3d8-c5443e47a014@intel.com>
 <358e9b36-230f-eb18-efdb-b472be8438b4@fortanix.com> <960B34DE67B9E140824F1DCDEC400C0F4E886094@ORSMSX116.amr.corp.intel.com>
 <6da269d8-7ebb-4177-b6a7-50cc5b435cf4@fortanix.com> <CALCETrWCZQwg-TUCm58DVG43=xCKRsMe1tVHrR8vdt06hf4fWA@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F4E886394@ORSMSX116.amr.corp.intel.com>
In-Reply-To: <960B34DE67B9E140824F1DCDEC400C0F4E886394@ORSMSX116.amr.corp.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Tue, 14 May 2019 08:08:03 -0700
X-Gmail-Original-Message-ID: <CALCETrU9Ry0MpoZTKmzxys7kVsTJfKrC_3ZxMYgc6z2V36bfZg@mail.gmail.com>
Message-ID: <CALCETrU9Ry0MpoZTKmzxys7kVsTJfKrC_3ZxMYgc6z2V36bfZg@mail.gmail.com>
Subject: Re: [PATCH v20 00/28] Intel SGX1 support
To:     "Xing, Cedric" <cedric.xing@intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Dr. Greg" <greg@enjellic.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
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
Content-Transfer-Encoding: quoted-printable
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, May 10, 2019 at 6:06 PM Xing, Cedric <cedric.xing@intel.com> wrote:
>
> Hi Andy and Jethro,
>
> > > > You have probably misread my email. By mmap(), I meant the enclave
> > file would be mapped via *multiple* mmap() calls, in the same way as
> > what dlopen() would do in loading regular shared object. The intention
> > here is to make the enclave file subject to the same checks as regular
> > shared objects.
> > >
> > > No, I didn't misread your email. My original point still stands:
> > > requiring that an enclave's memory is created from one or more mmap
> > > calls of a file puts significant restrictions on the enclave's on-dis=
k
> > > representation.
> > >
>
> I was talking in the context of ELF, with the assumption that changing RW=
 pages to RX is disallowed by LSM. And in that case mmap()would be the only=
 way to load a page from disk without having to "write" to it. But that's j=
ust an example but not the focus of the discussion.
>
> The point I was trying to make was, that the driver is going to copy both=
 content and permissions from the source so the security properties establi=
shed (by IMA/LSM) around that source page would be carried onto the EPC pag=
e being EADD'ed. The driver doesn't care how that source page came into exi=
stence. It could be mapped from an ELF file as in the example, or it could =
be a result from JIT as long as LSM allows it. The driver will be file form=
at agnostic.
>
> >
> > For a tiny bit of background, Linux (AFAIK*) makes no effort to ensure
> > the complete integrity of DSOs.  What Linux *does* do (if so
> > configured) is to make sure that only approved data is mapped
> > executable.  So, if you want to have some bytes be executable, those
> > bytes have to come from a file that passes the relevant LSM and IMA
> > checks.  So we have two valid approaches, I think.
> >
> > Approach 1: we treat SGX exactly the same way and make it so that only
> > bytes that pass the relevant checks can be mapped as code within an
> > enclave.  This imposes no particular restrictions on the file format
> > -- we just need some API that takes an fd, an offset, and a length,
> > and adds those bytes as code to an enclave.  (It could also take a
> > pointer and a length and make sure that the pointer points to
> > executable memory -- same effect.)
>
> I assume "some API" is some user mode API so this approach is the same as=
 what I suggested in my last email. Am I correct?

I meant kernel, but SGX_IOC_ADD_ENCLAVE_PAGE could be that API.

The only benefit I can see to making the kernel API take an fd instead
of a pointer is that it allows loading an enclave without mapping it
first, but that seems unlikely to be very important.

>
> >
> > Approach 2: we decide that we want a stronger guarantee and that we
> > *will* ensure the integrity of the enclave.  This means:
> >
> > 2a) that we either need to load the entire thing from some approved
> > file, and we commit to supporting one or more file formats.
> >
> > 2b) we need to check that the eventual enclave hash is approved.  Or
> > we could have a much shorter file that is just the hash and we check
> > that.  At its simplest, the file could be *only* the hash, and there
> > could be an LSM callback to check it.  In the future, if someone wants
> > to allow enclaves to be embedded in DSOs, we could have a special ELF
> > note or similar that contains an enclave hash or similar.
> >
> > 2c) same as 2b except that we expose the whole SIGSTRUCT, not just the
> > hash.
> >
> > Here are some pros and cons of various bits:
> >
> > 1 and 2a allow anti-virus software to scan the enclave code, and 2a
> > allows it to scan the whole enclave.  I don't know if this is actually
> > imporant.
>
> I guess anti-virus software can scan any enclave file in *all* cases as l=
ong as it understands the format of that enclave. It doesn't necessary mean=
 the kernel has to understand that enclave format (as enclave file could be=
 parsed in user mode) or the anti-virus software has to understand all form=
ats (if any) supported natively by the kernel.

True, but in 2a it can be scanned even without understanding the
format.  That's probably not terribly important.

>
> >
> > 2a is by far the most complicated kernel implementation.
> >
>
> Agreed. I don't see any reason 2a would be necessary.
>
> > 2b and 2c are almost file-format agnostic.  1 is completely file
> > format agnostic but, in exchange, it's much weaker.
>
> I'd say 1 and (variants of) 2 are orthogonal. SGX always enforces integri=
ties so not doing integrity checks at EADD doesn't mean the enclave integri=
ty is not being enforced. 1 and 2 are basically 2 different checkpoints whe=
re LSM hooks could be placed. And a given LSM implementation/policy may enf=
orce either 1 or 2, or both, or neither.

They're not orthogonal in the sense that verifying the SIGSTRUCT
implicitly verifies the executable contents.

>
> >
> > 2b and 2c should solve most (but not all) of the launch control
> > complaints that Dr. Greg cares about, in the sense that the LSM policy
> > quite literally validates that the enclave is approved.
> >
> > As a straw man design, I propose the following, which is mostly 2c.
> > The whole loading process works almost as in Jarkko's current driver,
> > but the actual ioctl that triggers EINIT changes.  When you issue the
> > ioctl, you pass in an fd and the SIGSTRUCT is loaded and checked from
> > the fd.  The idea is that software that ships an enclave will ship a
> > .sgxsig file that is literally a SIGSTRUCT for the enclave.  With
> > SELinux, that file gets labeled something like
> > sgx_enclave_sigstruct_t.  And we have the following extra twist: if
> > you're calling the EADD ioctl to add *code* to the enclave, the driver
> > checks that the code being loaded is mapped executable.  This way
> > existing code-signing policies don't get subverted, and policies that
> > want to impose full verification on the enclave can do so by verifying
> > the .sigstruct file.
>
> I'm with you that it's desirable/necessary to add an LSM hook at EINIT, b=
ut don't see the need for .sigstruct file or its fd as input to EINIT ioctl=
.
>
> Generally speaking, LSM needs to decide whether or not to launch the encl=
ave in question. And that decision could be based upon either the enclave i=
tself (i.e. bytes comprising the enclave, or its MRENCLAVE, or its signatur=
e, all equivalent from cryptographic standpoint), or some external attribut=
es associated with the enclave (e.g. DAC/MAC context associated with the en=
clave file), or both. In the former case, what matters is the content of th=
e SIGSTRUCT but not where it came from; while in the latter case it could b=
e gated at open() syscall so that no fd to SIGSTRUCT (or the enclave image =
file) could ever be obtained by the calling process if it was not allowed t=
o launch that enclave at all. In either case, no fd is necessary to be pass=
ed to EINIT ioctl. That said, by providing a SIGSTRUCT to EINIT ioctl, the =
calling process has implicitly proven its access to needed file(s) at the f=
ile system level, so only the content (i.e. MRENCLAVE or signing key) of th=
e SIGSTRUCT needs to be checked by LSM, while the integrity of the enclave =
will be enforced by SGX hardware.
>

I agree with you except that there's a difference in how the
configuration works.  If the whole .sigstruct is in a file, then
teaching your policy to accept an enclave works just like teaching
your policy to accept a new ELF program -- you just put it in a file
and mark the file trusted (by labeling it, for example).  If the
.sigstruct comes from unverifiable application memory, then an
out-of-band mechanism will likely be needed.

> Putting everything together, I'd suggest to:
>   - Change EADD ioctl to take source page's VMA permission as ("upper bou=
nd" of) EPCM permission. This make sure no one can circumvent LSM to genera=
te executable code on the fly using SGX driver.
>   - Change EINIT ioctl to invoke (new?) LSM hook to validate SIGSTRUCT be=
fore issuing EINIT.

I'm okay with this if the consensus is that having a .sigstruct file
is too annoying.

(Note that a .sigstruct file does not, strictly speaking, require that
it comes from a real file.  It could come from memfd, and it will then
fail to load if the LSM doesn't like it.  So you can still easily
download and run an enclave if you think that's a good idea.)
