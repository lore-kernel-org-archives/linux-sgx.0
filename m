Return-Path: <SRS0=9BeY=T4=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DE90C04AB6
	for <linux-sgx@archiver.kernel.org>; Tue, 28 May 2019 21:41:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E77DD208CB
	for <linux-sgx@archiver.kernel.org>; Tue, 28 May 2019 21:41:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbfE1VlJ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 28 May 2019 17:41:09 -0400
Received: from mga03.intel.com ([134.134.136.65]:54923 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726492AbfE1VlJ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 28 May 2019 17:41:09 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 May 2019 14:41:08 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga003.jf.intel.com with ESMTP; 28 May 2019 14:41:07 -0700
Date:   Tue, 28 May 2019 14:41:07 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     "Xing, Cedric" <cedric.xing@intel.com>,
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
Subject: Re: SGX vs LSM (Re: [PATCH v20 00/28] Intel SGX1 support)
Message-ID: <20190528214107.GD13158@linux.intel.com>
References: <CALCETrUw5sEr-MHPMU4CzEzkrejDs-JOThHB9Buhoxo5-rdpRw@mail.gmail.com>
 <20190524200333.GF365@linux.intel.com>
 <CALCETrUyAAhnQ+RUeN1L41TKj-vcD2CNt-FJ9siO=Zo6gvH1Aw@mail.gmail.com>
 <20190524224107.GJ365@linux.intel.com>
 <683B5E3D-AFB6-4B45-8D39-B00847312209@amacapital.net>
 <960B34DE67B9E140824F1DCDEC400C0F654E965F@ORSMSX116.amr.corp.intel.com>
 <CALCETrXXVMutX8eZk6nnkOAeS+Tj0sQd0FkW+wk6Rx8hQxCe6w@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F654E9824@ORSMSX116.amr.corp.intel.com>
 <20190528202407.GB13158@linux.intel.com>
 <CALCETrWTXCb1jru1G5G3sOp5AV8iYUtrffiSxE-5gotXtrZD-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWTXCb1jru1G5G3sOp5AV8iYUtrffiSxE-5gotXtrZD-g@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, May 28, 2019 at 01:48:02PM -0700, Andy Lutomirski wrote:
> On Tue, May 28, 2019 at 1:24 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > Actually, I think we do have everything we need from an LSM perspective.
> > LSMs just need to understand that sgx_enclave_load() with a NULL vma
> > implies a transition from RW.  For example, SELinux would interpret
> > sgx_enclave_load(NULL, RX) as requiring FILE__EXECMOD.
> 
> You lost me here.  What operation triggers this callback?  And
> wouldn't sgx_enclave_load(NULL, RX) sometimes be a transition from RO
> or just some fresh executable zero bytes?

An explicit ioctl() after EACCEPTCOPY to update the allowed permissions.
For all intents and purposes, the EAUG'd page must start RW.  Maybe a
better way to phrase it is that at some point the page must be writable
to have any value whatsover.  EACCEPTCOPY explicitly requires the page to
be at least RW.  EACCEPT technically doesn't require RW, but a RO or RX
zero page is useless.  Userspace could still EACCEPT with RO or RX, but
SGX would assume a minimum of RW for the purposes of the LSM check.

> > As Cedric mentioned earlier, the host process doesn't necessarily know
> > which pages will end up RW vs RX, i.e. sgx_enclave_load(NULL, RX)
> > already has to be invoked at runtime, and when that happens, the kernel
> > can take the opportunity to change the VMAs from MAY_RW to MAY_RX.
> >
> > For simplicity in the kernel and clarity in userspace, it makes sense to
> > require an explicit ioctl() to add the to-be-EAUG'd range.  That just
> > leaves us wanting an ioctl() to set the post-EACCEPT{COPY} permissions.
> >
> > E.g.:
> >
> >     ioctl(<prefix>_ADD_REGION, { NULL }) /* NULL == EAUG, MAY_RW */
> >
> >     mprotect(addr, size, RW);
> >     ...
> >
> >     EACCEPTCOPY -> EAUG /* page fault handler */
> >
> >     ioctl(<prefix>_ACTIVATE_REGION, { addr, size, RX}) /* MAY_RX */
> >
> >     mprotect(addr, size, RX);
> 
> In the maxperm model, this mprotect() will fail unless MAXPERM
> contains RX, which could only happen if MAXPERM=RWX.  So, regardless
> of how it's actually mapped to SELinux policy, MAXPERM=RWX is
> functionally like EXECMOD and actual RWX PTEs are functionally like
> EXECMEM.

Yep, same idea, except in the proposed flow ACTIVATE_REGION.

> >     ...
> >
> > And making ACTIVATE_REGION a single-shot per page eliminates the need for
> > the MAXPERMS concept (see below).
> >
> > > If we keep only one MAXPERM, wouldn't this be the current behavior of
> > > mmap()/mprotect()?
> > >
> > > To be a bit more clear, system admin sets MAXPERM upper bound in the form of
> > > FILE__{READ|WRITE|EXECUTE|EXECMOD} of /dev/sgx/enclave. Then for a
> > > process/enclave, if what it requires falls below what's allowed on
> > > /dev/sgx/enclave, then everything will just work. Otherwise, it fails in the
> > > form of -EPERM returned from mmap()/mprotect(). Please note that MAXPERM here
> > > applies to "runtime" permissions, while "initial" permissions are taken care
> > > of by security_enclave_{load|init}. "initial" permissions could be more
> > > permissive than "runtime" permissions, e.g., RX is still required for initial
> > > code pages even though system admins could disable dynamically loaded code
> > > pages by *not* giving FILE__{EXECUTE|EXECMOD}. Therefore, the "initial"
> > > mapping would still have to be done by the driver (to bypass LSM), either via
> > > a new ioctl or as part of IOC_EINIT.
> >
> > Aha!
> >
> > Starting with Cedric's assertion that initial permissions can be taken
> > directly from SECINFO:
> >
> >   - Initial permissions for *EADD* pages are explicitly handled via
> >     sgx_enclave_load() with the exact SECINFO permissions.
> >
> >   - Initial permissions for *EAUG* are unconditionally RW.  EACCEPTCOPY
> >     requires the target EPC page to be RW, and EACCEPT with RO is useless.
> >
> >   - Runtime permissions break down as follows:
> >       R   - N/A, subset of RW (EAUG)
> >       W   - N/A, subset of RW (EAUG) and x86 paging can't do W
> >       X   - N/A, subset of RX (x86 paging can't do XO)
> 
> Sure it can!  You just have a hypervisor that maps a PA bit to EPT
> no-read.  Then you can use that PA bit to suppress read.  Also, Linux
> already abuses PKRU to simulate XO, although that won't work for
> enclaves.

Heh, I intentionally said "x86 paging" to rule out EPT :-)  I'm pretty
sure it's a moot point though, I have a hard time believing an LSM will
allow RW->X and not RW->RX.

> >       RW  - Handled by EAUG LSM hook (uses RW unconditionally)
> >       WX  - N/A, subset of RWX (x86 paging can't do WX)
> >       RX  - Handled by ACTIVATE_REGION
> >       RWX - Handled by ACTIVATE_REGION
> >
> > In other words, if we define the SGX -> LSM calls as follows (minus the
> > file pointer and other params for brevity):
> >
> >   - <prefix>_ACTIVATE_REGION(vma, perms) -> sgx_enclave_load(NULL, perms)
> >
> >   - <prefix>_ADD_REGION(vma) -> sgx_enclave_load(vma, SECINFO.perms)
> >
> >   - <prefix>_ADD_REGION(NULL) -> sgx_enclave_load(NULL, RW)
> >
> > then SGX and LSMs have all the information and hooks needed.  The catch
> > is that the LSM semantics of sgx_enclave_load(..., RW) would need to be
> > different than normal shared memory, e.g. FILE__WRITE should *not* be
> > required, but that's ok since it's an SGX specific hook.  And if for some
> > reason an LSM wanted to gate access to EAUG *without* FILE__EXECMOD, it'd
> > have the necessary information to do so.
> >
> > The userspace changes are fairly minimal:
> >
> >   - For SGX1, use PROT_NONE for the initial mmap() and refactor ADD_PAGE
> >     to ADD_REGION.
> >
> >   - For SGX2, do an explicit ADD_REGION on the ranges to be EAUG'd, and an
> >     ACTIVATE_REGION to make a region RX or R (no extra ioctl() required to
> >     keep RW permissions).
> >
> > Because ACTIVATE_REGION can only be done once per page, to do *abitrary*
> > mprotect() transitions, userspace would need to set the added/activated
> > permissions to be a superset of the transitions, e.g. RW -> RX would
> > require RWX, but that's a non-issue.
> >
> 
> I may be misunderstanding or just be biased to my own proposal, but
> this seems potentially more complicated and less flexible than the
> MAXPERM model.  One of the main things that made me come up with
> MAXPERM is that I wanted to avoid any complicated PTE/VMA modification
> or runtime changes.  So, with MAXPERM, we still need to track the
> MAXPERM bits per page, but we don't ever need to *change* them or to
> worry about what is or is not mapped anywhere at any given time.  With
> ACTIVATE_REGION, don't we need to make sure that we don't have a
> second VMA pointing at the same pages?  Or am I just confused?

In theory, it's still your MAXPERM model, but with the unnecessary states
removed and the others enforced/handled by the natural SGX transitions
instead of explictly in ioctls.  Underneath the hood the SGX driver would
still need to track the MAXPERM.

With SGX1, SECINFO == MAXPERM.  With SGX2, ACTIVATE_REGION == MAXPERM,
with the implication that the previous state is always RW.

> >   - For SGX1 it's a nop since it's impossible to change the EPCM
> >     permissions, i.e. the page would need to be RWX regardless.
> 
> I may still be missing something, but, for SGX1, it's possible at
> least in principle for the enclave to request, via ocall or similar,
> that the untrusted runtime do mprotect().  It's not even such a bad
> idea.  Honestly, enclaves *shouldn't* have anything actually writable
> and executable at once because the enclaves don't want to be easily
> exploited.

Yes, but the *EPCM* permissions are immutable.  So if an enclave wants
to do RW->RX it has to intialize its pages to RWX.  And because the
untrusted runtime is, ahem, untrusted, the enclave cannot rely on
userspace to never map its pages RWX.  In other words, from a enclave
security perspective, an SGX1 enclave+runtime that uses RW->RX is no
different than an enclave that uses RWX.  Using your earlier terminology,
an SGX1 enclave *should* get a dirty looks if maps a page RWX in the EPCM,
even if it only intends RW->RX behavior.

> >   - For SGX2, userspace can suck it up and request RWX to do completely
> >     arbitrary transitions (working as intended), or the kernel can support
> >     trimming (removing) pages from an enclave, which would allow userspace
> >     to do "arbitrary" transitions by first removing the page.
