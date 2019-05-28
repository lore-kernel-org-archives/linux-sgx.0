Return-Path: <SRS0=9BeY=T4=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,T_DKIMWL_WL_HIGH
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C04C7C04E84
	for <linux-sgx@archiver.kernel.org>; Tue, 28 May 2019 20:48:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A2AA208CB
	for <linux-sgx@archiver.kernel.org>; Tue, 28 May 2019 20:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1559076499;
	bh=09fiq5hr450uLlQErWMLSzmFaRn8vpvPljqSobF7zzA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=JTEyYGsG/ZCZrlfGC53hRk44U5FFu6n6DciqOAiWqe+Yhqfby3sqfnByrbi5TdNsa
	 SZfrh9lhKi45Yg5qfeea6jWmg4jN4L6YBkaHrtNybEmnlKnXj2BuoThq/eP578KO0I
	 IDpDj3/V8ZraxtB58IFPMngMWe2dELY3kT32zxMI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727614AbfE1UsS (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 28 May 2019 16:48:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:47638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727624AbfE1UsR (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 28 May 2019 16:48:17 -0400
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDC7B21881
        for <linux-sgx@vger.kernel.org>; Tue, 28 May 2019 20:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559076496;
        bh=09fiq5hr450uLlQErWMLSzmFaRn8vpvPljqSobF7zzA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=P2BxM5+iaCCWzV10l9+LJOerpkRqR7PglpuZG1P7yBQvlxzx41KMXR1P3T7gdDoNU
         mwXC6X6HhG+DLa+31xDsebU08JByElYUh7NGrL8W9ki/h/q8iV0vWM2orDNC0mB9Wu
         A+u2qJpWMLolcsAS476kX6wVnzmuGNwMQPJzvQfA=
Received: by mail-wm1-f42.google.com with SMTP id u78so45837wmu.5
        for <linux-sgx@vger.kernel.org>; Tue, 28 May 2019 13:48:15 -0700 (PDT)
X-Gm-Message-State: APjAAAXpZq6nAUlLgGYQrBcuSg9hTfHmUC6EFQnrIst0DWDm8HQ8SaD+
        Y4Er3HGuKu2XkimGB7uE9gLnYEg7JU4U90+EJ7z7aw==
X-Google-Smtp-Source: APXvYqx4s6KiYO9iuS9RzXUbYyKUC1M48WgXEIXnga5FAp1M8HhXiDaY+DyEDGrIPknas+a+CoEObrZ3RFzPjlPi3eY=
X-Received: by 2002:a05:600c:489:: with SMTP id d9mr4212013wme.173.1559076494093;
 Tue, 28 May 2019 13:48:14 -0700 (PDT)
MIME-Version: 1.0
References: <20190524175458.GB365@linux.intel.com> <960B34DE67B9E140824F1DCDEC400C0F654E8E1D@ORSMSX116.amr.corp.intel.com>
 <CALCETrUw5sEr-MHPMU4CzEzkrejDs-JOThHB9Buhoxo5-rdpRw@mail.gmail.com>
 <20190524200333.GF365@linux.intel.com> <CALCETrUyAAhnQ+RUeN1L41TKj-vcD2CNt-FJ9siO=Zo6gvH1Aw@mail.gmail.com>
 <20190524224107.GJ365@linux.intel.com> <683B5E3D-AFB6-4B45-8D39-B00847312209@amacapital.net>
 <960B34DE67B9E140824F1DCDEC400C0F654E965F@ORSMSX116.amr.corp.intel.com>
 <CALCETrXXVMutX8eZk6nnkOAeS+Tj0sQd0FkW+wk6Rx8hQxCe6w@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F654E9824@ORSMSX116.amr.corp.intel.com> <20190528202407.GB13158@linux.intel.com>
In-Reply-To: <20190528202407.GB13158@linux.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Tue, 28 May 2019 13:48:02 -0700
X-Gmail-Original-Message-ID: <CALCETrWTXCb1jru1G5G3sOp5AV8iYUtrffiSxE-5gotXtrZD-g@mail.gmail.com>
Message-ID: <CALCETrWTXCb1jru1G5G3sOp5AV8iYUtrffiSxE-5gotXtrZD-g@mail.gmail.com>
Subject: Re: SGX vs LSM (Re: [PATCH v20 00/28] Intel SGX1 support)
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     "Xing, Cedric" <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, May 28, 2019 at 1:24 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> On Sat, May 25, 2019 at 11:09:38PM -0700, Xing, Cedric wrote:
> > > From: Andy Lutomirski [mailto:luto@kernel.org]
> > > Sent: Saturday, May 25, 2019 5:58 PM
> > >
> > > On Sat, May 25, 2019 at 3:40 PM Xing, Cedric <cedric.xing@intel.com> =
wrote:
> > > >
> > > > If we think of EADD as a way of mmap()'ing an enclave file into mem=
ory,
> > > > would this
> > > security_enclave_load() be the same as
> > > security_mmap_file(source_vma->vm_file, maxperm, MAP_PRIVATE), except=
 that
> > > the target is now EPC instead of regular pages?
> > >
> > > Hmm, that's clever.  Although it seems plausible that an LSM would wa=
nt to
> > > allow RX or RWX of a given file page but only in the context of an ap=
proved
> > > enclave, so I think it should still be its own hook.
> >
> > What do you mean by "in the context of an approved enclave"? EPC pages =
are
> > *inaccessible* to any software until after EINIT. So it would never be =
a
> > security concern to EADD a page with wrong permissions as long as the e=
nclave
> > would be denied eventually by LSM at EINIT.
> >
> > But I acknowledge the difference between loading a page into regular me=
mory
> > vs. into EPC. So it's beneficial to have a separate hook, which if not
> > hooked, would pass through to security_mmap_file() by default?
>
> Mapping the enclave will still go through security_mmap_file(), the extra
> security_enclave_load() hook allows the mmap() to use PROT_NONE.
>
> > > If it's going to be in an arbitrary file, then I think the signature =
needs to be more like:
> > >
> > > int security_enclave_init(struct vm_area_struct *sigstruct_vma, loff_=
t sigstruct_offset,
> > > const sgx_sigstruct *sigstruct);
> > >
> > > So that the LSM still has the opportunity to base its decision on the=
 contents of the
> > > SIGSTRUCT.  Actually, we need that change regardless.
> >
> > Wouldn't the pair of { sigstruct_vma, sigstruct_offset } be the same as=
 just
> > a pointer, because the VMA could be looked up using the pointer and the
> > offset would then be (pointer - vma->vm_start)?
>
> VMA has vm_file, e.g. the .sigstruct file labeled by LSMs.  That being
> said, why does the LSM need the VMA?  E.g. why not this?
>
>   int security_enclave_init(struct file *file, struct sgx_sigstruct *sigs=
truct);
>
> > > > Loosely speaking, an enclave (including initial contents of all of =
its pages and their
> > > permissions) and its MRENCLAVE are a 1-to-1 correspondence (given the=
 collision resistant
> > > property of SHA-2). So only one is needed for a decision, and either =
one would lead to the
> > > same decision. So I don't see anything making any sense here.
> > > >
> > > > Theoretically speaking, if LSM can make a decision at EINIT by mean=
s of
> > > security_enclave_load(), then security_enclave_load() is never needed=
.
> > > >
> > > > In practice, I support keeping both because security_enclave_load()=
 can only approve an
> > > enumerable set while security_enclave_load() can approve a non-enumer=
able set of enclaves.
> > > Moreover, in order to determine the validity of a MRENCLAVE (as in de=
velopment of a policy
> > > or in creation of a white/black list), system admins will need the au=
dit log produced by
> > > security_enclave_load().
> > >
> > > I'm confused.  Things like MRSIGNER aren't known until the SIGSTRUCT =
shows
> > > up.  Also, security_enclave_load() provides no protection against loa=
ding a
> > > mishmash of two different enclave files.  I see security_enclave_init=
() as
> > > "verify this SIGSTRUCT against your policy on who may sign enclaves a=
nd/or
> > > grant EXECMOD depending on SIGSTRUCT" and security_enclave_load() as
> > > "implement your EXECMOD / EXECUTE / WRITE / whatever policy and possi=
bly
> > > check enclave files for some label."
> >
> > Sorry for the confusion. I was saying the same thing except that the de=
cision
> > of security_enclave_load() doesn't have to depend on SIGSTRUCT. Given y=
our
> > prototype of security_enclave_load(), I think we are on the same page. =
I made
> > the above comment to object to the idea of "require that the sigstruct =
be
> > supplied before any EADD operations so that the maxperm decisions can d=
epend
> > on the sigstruct".
>
> Except that having the sigstruct allows using the sigstruct as the proxy
> for the enclave.  I think the last big disconnect is that Andy and I want
> to tie everything to an enclave-specific file, i.e. sigstruct, while you
> are proposing labeling /dev/sgx/enclave.  If someone wants to cram severa=
l
> sigstructs into a single file, so be it, but using /dev/sgx/enclave means
> users can't do per-enclave permissions, period.
>
> What is your objection to working on the sigstruct?
>
> > > > > > Passing both would allow tying EXECMOD to /dev/sgx/enclave as
> > > > > > Cedric wanted (without having to play games and pass
> > > > > > /dev/sgx/enclave to security_enclave_load()), but I don't think
> > > > > > there's anything fundamentally broken with using .sigstruct for
> > > > > > EXECMOD.  It requires more verbose labeling, but that's not a b=
ad thing.
> > > > >
> > > > > The benefit of putting it on .sigstruct is that it can be per-enc=
lave.
> > > > >
> > > > > As I understand it from Fedora packaging, the way this works on
> > > > > distros is generally that a package will include some files and
> > > > > their associated labels, and, if the package needs EXECMOD, then =
the
> > > > > files are labeled with EXECMOD and the author of the relevant cod=
e might get a dirty
> > > look.
> > > > >
> > > > > This could translate to the author of an exclave that needs RWX
> > > > > regions getting a dirty look without leaking this permission into=
 other enclaves.
> > > > >
> > > > > (In my opinion, the dirty looks are actually the best security
> > > > > benefit of the entire concept of LSMs making RWX difficult.  A
> > > > > sufficiently creative attacker can almost always bypass W^X
> > > > > restrictions once they=E2=80=99ve pwned you, but W^X makes it har=
der to pwn
> > > > > you in the first place, and SELinux makes it really obvious when
> > > > > packaging a program that doesn=E2=80=99t respect W^X.  The upshot=
 is that a
> > > > > lot of programs got fixed.)
> > > >
> > > > I'm lost here. Dynamically linked enclaves, if running on SGX2, wou=
ld need RW->RX, i.e.
> > > FILE__EXECMOD on /dev/sgx/enclave. But they never need RWX, i.e. PROC=
ESS__EXECMEM.
> > >
> > > Hmm.  If we want to make this distinction, we need something a big ri=
cher
> > > than my proposed callbacks.  A check of the actual mprotect() / mmap(=
)
> > > permissions would also be needed.  Specifically, allowing MAXPERM=3DR=
WX
> > > wouldn't imply that PROT_WRITE | PROT_EXEC is allowed.
>
> Actually, I think we do have everything we need from an LSM perspective.
> LSMs just need to understand that sgx_enclave_load() with a NULL vma
> implies a transition from RW.  For example, SELinux would interpret
> sgx_enclave_load(NULL, RX) as requiring FILE__EXECMOD.

You lost me here.  What operation triggers this callback?  And
wouldn't sgx_enclave_load(NULL, RX) sometimes be a transition from RO
or just some fresh executable zero bytes?

>
> As Cedric mentioned earlier, the host process doesn't necessarily know
> which pages will end up RW vs RX, i.e. sgx_enclave_load(NULL, RX)
> already has to be invoked at runtime, and when that happens, the kernel
> can take the opportunity to change the VMAs from MAY_RW to MAY_RX.
>
> For simplicity in the kernel and clarity in userspace, it makes sense to
> require an explicit ioctl() to add the to-be-EAUG'd range.  That just
> leaves us wanting an ioctl() to set the post-EACCEPT{COPY} permissions.
>
> E.g.:
>
>     ioctl(<prefix>_ADD_REGION, { NULL }) /* NULL =3D=3D EAUG, MAY_RW */
>
>     mprotect(addr, size, RW);
>     ...
>
>     EACCEPTCOPY -> EAUG /* page fault handler */
>
>     ioctl(<prefix>_ACTIVATE_REGION, { addr, size, RX}) /* MAY_RX */
>
>     mprotect(addr, size, RX);

In the maxperm model, this mprotect() will fail unless MAXPERM
contains RX, which could only happen if MAXPERM=3DRWX.  So, regardless
of how it's actually mapped to SELinux policy, MAXPERM=3DRWX is
functionally like EXECMOD and actual RWX PTEs are functionally like
EXECMEM.

>
>     ...
>
> And making ACTIVATE_REGION a single-shot per page eliminates the need for
> the MAXPERMS concept (see below).
>
> > If we keep only one MAXPERM, wouldn't this be the current behavior of
> > mmap()/mprotect()?
> >
> > To be a bit more clear, system admin sets MAXPERM upper bound in the fo=
rm of
> > FILE__{READ|WRITE|EXECUTE|EXECMOD} of /dev/sgx/enclave. Then for a
> > process/enclave, if what it requires falls below what's allowed on
> > /dev/sgx/enclave, then everything will just work. Otherwise, it fails i=
n the
> > form of -EPERM returned from mmap()/mprotect(). Please note that MAXPER=
M here
> > applies to "runtime" permissions, while "initial" permissions are taken=
 care
> > of by security_enclave_{load|init}. "initial" permissions could be more
> > permissive than "runtime" permissions, e.g., RX is still required for i=
nitial
> > code pages even though system admins could disable dynamically loaded c=
ode
> > pages by *not* giving FILE__{EXECUTE|EXECMOD}. Therefore, the "initial"
> > mapping would still have to be done by the driver (to bypass LSM), eith=
er via
> > a new ioctl or as part of IOC_EINIT.
>
> Aha!
>
> Starting with Cedric's assertion that initial permissions can be taken
> directly from SECINFO:
>
>   - Initial permissions for *EADD* pages are explicitly handled via
>     sgx_enclave_load() with the exact SECINFO permissions.
>
>   - Initial permissions for *EAUG* are unconditionally RW.  EACCEPTCOPY
>     requires the target EPC page to be RW, and EACCEPT with RO is useless=
.
>
>   - Runtime permissions break down as follows:
>       R   - N/A, subset of RW (EAUG)
>       W   - N/A, subset of RW (EAUG) and x86 paging can't do W
>       X   - N/A, subset of RX (x86 paging can't do XO)

Sure it can!  You just have a hypervisor that maps a PA bit to EPT
no-read.  Then you can use that PA bit to suppress read.  Also, Linux
already abuses PKRU to simulate XO, although that won't work for
enclaves.

>       RW  - Handled by EAUG LSM hook (uses RW unconditionally)
>       WX  - N/A, subset of RWX (x86 paging can't do WX)
>       RX  - Handled by ACTIVATE_REGION
>       RWX - Handled by ACTIVATE_REGION
>
> In other words, if we define the SGX -> LSM calls as follows (minus the
> file pointer and other params for brevity):
>
>   - <prefix>_ACTIVATE_REGION(vma, perms) -> sgx_enclave_load(NULL, perms)
>
>   - <prefix>_ADD_REGION(vma) -> sgx_enclave_load(vma, SECINFO.perms)
>
>   - <prefix>_ADD_REGION(NULL) -> sgx_enclave_load(NULL, RW)
>
> then SGX and LSMs have all the information and hooks needed.  The catch
> is that the LSM semantics of sgx_enclave_load(..., RW) would need to be
> different than normal shared memory, e.g. FILE__WRITE should *not* be
> required, but that's ok since it's an SGX specific hook.  And if for some
> reason an LSM wanted to gate access to EAUG *without* FILE__EXECMOD, it'd
> have the necessary information to do so.
>
> The userspace changes are fairly minimal:
>
>   - For SGX1, use PROT_NONE for the initial mmap() and refactor ADD_PAGE
>     to ADD_REGION.
>
>   - For SGX2, do an explicit ADD_REGION on the ranges to be EAUG'd, and a=
n
>     ACTIVATE_REGION to make a region RX or R (no extra ioctl() required t=
o
>     keep RW permissions).
>
> Because ACTIVATE_REGION can only be done once per page, to do *abitrary*
> mprotect() transitions, userspace would need to set the added/activated
> permissions to be a superset of the transitions, e.g. RW -> RX would
> require RWX, but that's a non-issue.
>

I may be misunderstanding or just be biased to my own proposal, but
this seems potentially more complicated and less flexible than the
MAXPERM model.  One of the main things that made me come up with
MAXPERM is that I wanted to avoid any complicated PTE/VMA modification
or runtime changes.  So, with MAXPERM, we still need to track the
MAXPERM bits per page, but we don't ever need to *change* them or to
worry about what is or is not mapped anywhere at any given time.  With
ACTIVATE_REGION, don't we need to make sure that we don't have a
second VMA pointing at the same pages?  Or am I just confused?

>   - For SGX1 it's a nop since it's impossible to change the EPCM
>     permissions, i.e. the page would need to be RWX regardless.

I may still be missing something, but, for SGX1, it's possible at
least in principle for the enclave to request, via ocall or similar,
that the untrusted runtime do mprotect().  It's not even such a bad
idea.  Honestly, enclaves *shouldn't* have anything actually writable
and executable at once because the enclaves don't want to be easily
exploited.

>
>   - For SGX2, userspace can suck it up and request RWX to do completely
>     arbitrary transitions (working as intended), or the kernel can suppor=
t
>     trimming (removing) pages from an enclave, which would allow userspac=
e
>     to do "arbitrary" transitions by first removing the page.
