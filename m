Return-Path: <SRS0=R9U0=T2=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,T_DKIMWL_WL_HIGH
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7184C07542
	for <linux-sgx@archiver.kernel.org>; Sun, 26 May 2019 00:57:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 862302081C
	for <linux-sgx@archiver.kernel.org>; Sun, 26 May 2019 00:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558832275;
	bh=szgalg1kkBBACh2gq4UQkPUK9T9XSL2GwSE++sZPomU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=UmGFbIrqhKkXkGLRh2A7O0vg6jKfEDr4OUrgiiaA6QK/5OSbEL2aZx5cnqEUwD6qq
	 ugO5J1dZVptjbEHsoIFUVvzGUM9eKF4gukRFE+axeJ2ftp2Wg6/KwT/yn7WlJ5/BWw
	 zyP94/iNHWwXx6x9VyTDeQq7H3VxT/xpGpcSD5lo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727544AbfEZA5z (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 25 May 2019 20:57:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:37552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727527AbfEZA5z (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 25 May 2019 20:57:55 -0400
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBF78216C4
        for <linux-sgx@vger.kernel.org>; Sun, 26 May 2019 00:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558832273;
        bh=szgalg1kkBBACh2gq4UQkPUK9T9XSL2GwSE++sZPomU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=fZfa9COfDCmNUj6+Uw1tUiw9SyHE4rJtGFhI3njP3Dd6V3c26uJuDVgoQmm7ykgRs
         fe5tbrm5bLsB63clYdD+zhQ4OcWdGLXregBnOjdPQIszhg/+9Jo/oiR9A0M3z502ht
         lAqQlFKcSgDerz2F7rGGCjU98aTQOHaxvLTx0dZA=
Received: by mail-wr1-f50.google.com with SMTP id e2so4621335wrv.6
        for <linux-sgx@vger.kernel.org>; Sat, 25 May 2019 17:57:52 -0700 (PDT)
X-Gm-Message-State: APjAAAW7s294xgi/K1MQWA8HuVDkoHqE0jDo1IVyC7JxcidgESX4kWP3
        7596bUoUFAxudnetM44MEnLnEtbauLplqrUh+9X7Tg==
X-Google-Smtp-Source: APXvYqzIZkI8DfyRrKavoI0Tq13f4hHX8e+WkHLNeFzkweg8oakxX2jRZ+KZQ1wPZsmUE5850re+D6kmTIUKKX3IVWg=
X-Received: by 2002:a5d:6207:: with SMTP id y7mr47387540wru.265.1558832271430;
 Sat, 25 May 2019 17:57:51 -0700 (PDT)
MIME-Version: 1.0
References: <20190523234044.GC12078@linux.intel.com> <CALCETrV4DVEfW6EJ6DnQGGYDJAiA5M1QcuYJTiroumOM+D6Jjg@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F654E8956@ORSMSX116.amr.corp.intel.com>
 <dda0912b-cb15-3c07-d368-345159e995f7@tycho.nsa.gov> <20190524174243.GA365@linux.intel.com>
 <20190524175458.GB365@linux.intel.com> <960B34DE67B9E140824F1DCDEC400C0F654E8E1D@ORSMSX116.amr.corp.intel.com>
 <CALCETrUw5sEr-MHPMU4CzEzkrejDs-JOThHB9Buhoxo5-rdpRw@mail.gmail.com>
 <20190524200333.GF365@linux.intel.com> <CALCETrUyAAhnQ+RUeN1L41TKj-vcD2CNt-FJ9siO=Zo6gvH1Aw@mail.gmail.com>
 <20190524224107.GJ365@linux.intel.com> <683B5E3D-AFB6-4B45-8D39-B00847312209@amacapital.net>
 <960B34DE67B9E140824F1DCDEC400C0F654E965F@ORSMSX116.amr.corp.intel.com>
In-Reply-To: <960B34DE67B9E140824F1DCDEC400C0F654E965F@ORSMSX116.amr.corp.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Sat, 25 May 2019 17:57:37 -0700
X-Gmail-Original-Message-ID: <CALCETrXXVMutX8eZk6nnkOAeS+Tj0sQd0FkW+wk6Rx8hQxCe6w@mail.gmail.com>
Message-ID: <CALCETrXXVMutX8eZk6nnkOAeS+Tj0sQd0FkW+wk6Rx8hQxCe6w@mail.gmail.com>
Subject: Re: SGX vs LSM (Re: [PATCH v20 00/28] Intel SGX1 support)
To:     "Xing, Cedric" <cedric.xing@intel.com>
Cc:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
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

On Sat, May 25, 2019 at 3:40 PM Xing, Cedric <cedric.xing@intel.com> wrote:
>
> > From: Andy Lutomirski [mailto:luto@amacapital.net]
> > Sent: Friday, May 24, 2019 4:42 PM
> >
> > > On May 24, 2019, at 3:41 PM, Sean Christopherson <sean.j.christophers=
on@intel.com> wrote:
> > >
> > >> On Fri, May 24, 2019 at 02:27:34PM -0700, Andy Lutomirski wrote:
> > >> On Fri, May 24, 2019 at 1:03 PM Sean Christopherson
> > >> <sean.j.christopherson@intel.com> wrote:
> > >>>
> > >>>> On Fri, May 24, 2019 at 12:37:44PM -0700, Andy Lutomirski wrote:
> > >>>>> On Fri, May 24, 2019 at 11:34 AM Xing, Cedric <cedric.xing@intel.=
com> wrote:
> > >>>>>
> > >>>>> If "initial permissions" for enclaves are less restrictive than
> > >>>>> shared objects, then it'd become a backdoor for circumventing LSM
> > >>>>> when enclave whitelisting is *not* in place. For example, an
> > >>>>> adversary may load a page, which would otherwise never be executa=
ble, as an executable
> > page in EPC.
> > >>>>>
> > >>>>> In the case a RWX page is needed, the calling process has to have
> > >>>>> a RWX page serving as the source for EADD so PROCESS__EXECMEM wil=
l
> > >>>>> have been checked. For SGX2, changing an EPC page to RWX is
> > >>>>> subject to FILE__EXECMEM on /dev/sgx/enclave, which I see as a
> > >>>>> security benefit because it only affects the enclave but not the =
whole process hosting
> > it.
> > >>>>
> > >>>> So the permission would be like FILE__EXECMOD on the source enclav=
e
> > >>>> page, because it would be mapped MAP_ANONYMOUS, PROT_WRITE?
> > >>>> MAP_SHARED, PROT_WRITE isn't going to work because that means you
> > >>>> can modify the file.
> > >>>
> > >>> Was this in response to Cedric's comment, or to my comment?
> > >>
> > >> Yours.  I think that requiring source pages to be actually mapped W
> > >> is not such a great idea.
> > >
> > > I wasn't requiring source pages to be mapped W.  At least I didn't
> > > intend to require W.  What I was trying to say is that SGX could
> > > trigger an EXECMEM check if userspace attempted to EADD or EAUG an
> > > enclave page with RWX permissions, e.g.:
> > >
> > >  if ((SECINFO.PERMS & RWX) =3D=3D RWX) {
> > >      ret =3D security_mmap_file(NULL, RWX, ???);
> > >      if (ret)
> > >          return ret;
> > >  }
> > >
> > > But that's a moot point if we add security_enclave_load() or whatever=
.
> > >
> > >>
> > >>>
> > >>>> I'm starting to think that looking at the source VMA permission
> > >>>> bits or source PTE permission bits is putting a bit too much polic=
y
> > >>>> into the driver as opposed to the LSM.  How about delegating the
> > >>>> whole thing to an LSM hook?  The EADD operation would invoke a new
> > >>>> hook, something like:
> > >>>>
> > >>>> int security_enclave_load_bytes(void *source_addr, struct
> > >>>> vm_area_struct *source_vma, loff_t source_offset, unsigned int
> > >>>> maxperm);
> > >>>>
> > >>>> Then you don't have to muck with mapping anything PROT_EXEC.
> > >>>> Instead you load from a mapping of a file and the LSM applies
> > >>>> whatever policy it feels appropriate.  If the first pass gets
> > >>>> something wrong, the application or library authors can take it up
> > >>>> with the SELinux folks without breaking the whole ABI :)
> > >>>>
> > >>>> (I'm proposing passing in the source_vma because this hook would b=
e
> > >>>> called with mmap_sem held for read to avoid a TOCTOU race.)
> > >>>>
> > >>>> If we go this route, the only substantial change to the existing
> > >>>> driver that's needed for an initial upstream merge is the maxperm
> > >>>> mechanism and whatever hopefully minimal API changes are needed to
> > >>>> allow users to conveniently set up the mappings.  And we don't nee=
d
> > >>>> to worry about how to hack around mprotect() calling into the LSM,
> > >>>> because the LSM will actually be aware of SGX and can just do the
> > >>>> right thing.
> > >>>
> > >>> This doesn't address restricting which processes can run which
> > >>> enclaves, it only allows restricting the build flow.  Or are you
> > >>> suggesting this be done in addition to whitelisting sigstructs?
> > >>
> > >> In addition.
> > >>
> > >> But I named the function badly and gave it a bad signature, which
> > >> confused you.  Let's try again:
> > >>
> > >> int security_enclave_load_from_memory(const struct vm_area_struct
> > >> *source, unsigned int maxperm);
> > >
> > > I prefer security_enclave_load(), "from_memory" seems redundant at be=
st.
> >
> > Fine with me.
>
> If we think of EADD as a way of mmap()'ing an enclave file into memory, w=
ould this security_enclave_load() be the same as security_mmap_file(source_=
vma->vm_file, maxperm, MAP_PRIVATE), except that the target is now EPC inst=
ead of regular pages?

Hmm, that's clever.  Although it seems plausible that an LSM would
want to allow RX or RWX of a given file page but only in the context
of an approved enclave, so I think it should still be its own hook.

>
> >
> > >
> > >> Maybe some really fancy future LSM would also want loff_t
> > >> source_offset, but it's probably not terribly useful.  This same
> > >> callback would be used for EAUG.
>
> EAUG always zeroes the EPC page before making it available to an enclave.=
 So I don't think there's anything needed to done here.

Duh.  So security_enclave_load_zeros() for EAUG.  See below.

>
> > >>
> > >> Following up on your discussion with Cedric about sigstruct, the
> > >> other callback would be something like:
> > >>
> > >> int security_enclave_init(struct file *sigstruct_file);
>
> I'd still insist in using a pointer rather than a file, for reasons that =
we've discussed before. For those who can't recall, the major reason is tha=
t most implementation would embed SIGSTRUCT into the same file as the encla=
ve (or at least I don't want to prevent anyone from doing so), which could =
also be part of another file, such as a shared object or even the main exec=
utable itself. It could be difficult to obtain a fd in those cases. memfd w=
on't work because it can't retain the same attributes of the original file =
containing the SIGSTRUCT.
>
> After all, what matters is the attributes associated with the backing fil=
e, which could be easily retrieve from vm_file of the covering VMA. So for =
the sake of flexibility, let's stay with what we've agreed before - a point=
er to SIGSTRUCT.

I'm okay with this, except for one nastiness: there's a big difference
between a file that is just a sigstruct and a file that contains
essentially arbitrary data plus a sigstruct at an arbitrary offset.
We could do something tricky like saying that SIGSTRUCT can be in a
file that's just a SIGSTRUCT or it can be in a special SIGSTRUCT ELF
note in a file that isn't just a SIGSTRUCT, but that could be
annoyingly restrictive.

If it's going to be in an arbitrary file, then I think the signature
needs to be more like:

int security_enclave_init(struct vm_area_struct *sigstruct_vma, loff_t
sigstruct_offset, const sgx_sigstruct *sigstruct);

So that the LSM still has the opportunity to base its decision on the
contents of the SIGSTRUCT.  Actually, we need that change regardless.

>
> > >>
> > >> The main issue I see is that we also want to control the enclave's
> > >> ability to have RWX pages or to change a W page to X.  We might also
> > >> want:
> > >>
> > >> int security_enclave_load_zeros(unsigned int maxperm);
> > >
> > > What's the use case for this?  @maxperm will always be at least RW in
> > > this case, otherwise the page is useless to the enclave, and if the
> > > enclave can write the page, the fact that it started as zeros is
> > > irrelevant.
> >
> > This is how EAUG could ask if RWX is okay. If an enclave is internally =
doing dynamic loading,
> > the it will need a heap page with maxperm =3D RWX.  (If it=E2=80=99s we=
ll designed, it will make it RW
> > and then RX, either by changing SECINFO or by asking the host to mprote=
ct() it, but it still
> > needs the overall RWX mask.).
>
> Any new page EAUG'ed will start in RW (as dictated by SGX ISA). EACCEPTCO=
PY will then change it to RX. RWX is never needed for all practical purpose=
s. This in fact could be gated by mprotect() and the attributes associated =
with /dev/sgx/enclave. In the case of SELinux, FILE__EXECMOD is the right a=
ttribute and mprotect() will take care of all the rest. I don't see why the=
 driver need a role here.

I find the SDM's discussion of EAUG, EACCEPT, and EACCEPTCOPY to be
extremely confusing.  My copy of the SDM has EACCEPT's SECINFO
argument as "Read access permitted by Non Enclave".  Is that an error?
 And is EACCEPTCOPY just EACCEPT + memcpy or is there some other
fundamental difference?  38.5.7 doesn't even mention EACCEPTCOPY.

Anyway, all my confusion aside, I was talking about the page table,
not the EPCM.  I think the enclave should need permission to write its
own content into a page that will ever become X, and the enclave's
untrusted host library would do this by adding the page with
MAXPERM=3DRWX and then mapping/mprotecting it as PROT_WRITE and then
(later or simultaneously) PROT_EXEC.

Since SGX2 doesn't seem to have a way to add an initialized page to
EPC after an enclave starts, I guess that it's impossible to have the
enclave do something like dlopen() without MAXPERM=3DRWX.  So be it.
Maybe someone will find this annoying someday and SGX3 will add
EAUG-but-don't-zero and EACCEPT-with-existing-contents.

>
> >
> > Also, do real SGX1 enclave formats have BSS? If so, then either we need=
 an ioctl or load zeros
> > or user code is going to load from /dev/zero or just from the heap, but=
 the LSM is going to
> > play better with an ioctl, I suspect :)
>
> Yes, it does. But an enclave would either measure BSS, in which case the =
initial bytes have to be zero or MRENCLAVE will change; or zero BSS explici=
tly in its initialization code.
>
> But from LSM's perspective it makes no difference than EADD'ing a page wi=
th non-zero content. And security_enclave_load(NULL, RW) would take care of=
 it in exactly in the same way.

Sure, I suppose the same hook with NULL parameters would be equivalent.

>
> >
> > >
> > >> An enclave that's going to modify its own code will need memory with
> > >> maxperm =3D RWX or WX.
>
> With SGX2/EDMM, RWX is *never* needed for all practical purposes.
>
> In theory, in terms of security, no page shall be made executable while i=
t is still being prepared. So W and X shall always be mutually exclusive, r=
egardless it's in EPC or regular memory.
>
> RWX is only needed in SGX1, as a workaround for certain usages, because E=
PCM permissions can never change at runtime.

As above, I think I disagree.  MAXPERM is intended as an upper bound
on the permissions that a page can ever have, at least until it's
EREMOVEd and re-added.  Since there's no EAUG-but-don't-zero, EAUG
with MAXPERM.W=3D0 is basically useless because the page can never
contain anything other than zeros, so a dynamically allocated page
that is ever executed has to have MAXPERM=3DRWX or MAXPERM=3DWX.  And that
will need special permissions, which I think is consistent with your
recent emails on how this could all map to SELinux permissions.

>
> > >>
> > >> But this is a bit awkward if the LSM's decision depends on the
> > >> sigstruct.  We could get fancy and require that the sigstruct be
> > >> supplied before any EADD operations so that the maxperm decisions ca=
n
> > >> depend on the sigstruct.
> > >>
> > >> Am I making more sense now?
> > >
> > > Yep.  Requiring .sigstruct at ECREATE would be trivial.  If we wanted
> > > flexibility we could do:
> > >
> > >   int security_enclave_load(struct file *file, struct vm_area_struct =
*vma,
> > >                             unsigned long prot);
> > >
> > > And for ultimate flexibility we could pass both .sigstruct and the
> > > file pointer for /dev/sgx/enclave, but that seems a bit ridiculous.
> >
> > I agree.
>
> Loosely speaking, an enclave (including initial contents of all of its pa=
ges and their permissions) and its MRENCLAVE are a 1-to-1 correspondence (g=
iven the collision resistant property of SHA-2). So only one is needed for =
a decision, and either one would lead to the same decision. So I don't see =
anything making any sense here.
>
> Theoretically speaking, if LSM can make a decision at EINIT by means of s=
ecurity_enclave_load(), then security_enclave_load() is never needed.
>
> In practice, I support keeping both because security_enclave_load() can o=
nly approve an enumerable set while security_enclave_load() can approve a n=
on-enumerable set of enclaves. Moreover, in order to determine the validity=
 of a MRENCLAVE (as in development of a policy or in creation of a white/bl=
ack list), system admins will need the audit log produced by security_encla=
ve_load().

I'm confused.  Things like MRSIGNER aren't known until the SIGSTRUCT
shows up.  Also, security_enclave_load() provides no protection
against loading a mishmash of two different enclave files.  I see
security_enclave_init() as "verify this SIGSTRUCT against your policy
on who may sign enclaves and/or grant EXECMOD depending on SIGSTRUCT"
and security_enclave_load() as "implement your EXECMOD / EXECUTE /
WRITE / whatever policy and possibly check enclave files for some
label."

>
> >
> > >
> > > Passing both would allow tying EXECMOD to /dev/sgx/enclave as Cedric
> > > wanted (without having to play games and pass /dev/sgx/enclave to
> > > security_enclave_load()), but I don't think there's anything
> > > fundamentally broken with using .sigstruct for EXECMOD.  It requires
> > > more verbose labeling, but that's not a bad thing.
> >
> > The benefit of putting it on .sigstruct is that it can be per-enclave.
> >
> > As I understand it from Fedora packaging, the way this works on distros=
 is generally that a
> > package will include some files and their associated labels, and, if th=
e package needs EXECMOD,
> > then the files are labeled with EXECMOD and the author of the relevant =
code might get a dirty
> > look.
> >
> > This could translate to the author of an exclave that needs RWX regions=
 getting a dirty look
> > without leaking this permission into other enclaves.
> >
> > (In my opinion, the dirty looks are actually the best security benefit =
of the entire concept
> > of LSMs making RWX difficult.  A sufficiently creative attacker can alm=
ost always bypass W^X
> > restrictions once they=E2=80=99ve pwned you, but W^X makes it harder to=
 pwn you in the first place,
> > and SELinux makes it really obvious when packaging a program that doesn=
=E2=80=99t respect W^X.  The
> > upshot is that a lot of programs got fixed.)
>
> I'm lost here. Dynamically linked enclaves, if running on SGX2, would nee=
d RW->RX, i.e. FILE__EXECMOD on /dev/sgx/enclave. But they never need RWX, =
i.e. PROCESS__EXECMEM.

Hmm.  If we want to make this distinction, we need something a big
richer than my proposed callbacks.  A check of the actual mprotect() /
mmap() permissions would also be needed.  Specifically, allowing
MAXPERM=3DRWX wouldn't imply that PROT_WRITE | PROT_EXEC is allowed.
