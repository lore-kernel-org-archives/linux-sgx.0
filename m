Return-Path: <SRS0=2c9w=T6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBC87C28CC3
	for <linux-sgx@archiver.kernel.org>; Thu, 30 May 2019 05:38:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F5CF26076
	for <linux-sgx@archiver.kernel.org>; Thu, 30 May 2019 05:38:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbfE3FiJ convert rfc822-to-8bit (ORCPT
        <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 30 May 2019 01:38:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:58205 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725961AbfE3FiJ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 30 May 2019 01:38:09 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 May 2019 22:38:08 -0700
X-ExtLoop1: 1
Received: from orsmsx108.amr.corp.intel.com ([10.22.240.6])
  by FMSMGA003.fm.intel.com with ESMTP; 29 May 2019 22:38:07 -0700
Received: from orsmsx162.amr.corp.intel.com (10.22.240.85) by
 ORSMSX108.amr.corp.intel.com (10.22.240.6) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Wed, 29 May 2019 22:38:07 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.165]) by
 ORSMSX162.amr.corp.intel.com ([169.254.3.190]) with mapi id 14.03.0415.000;
 Wed, 29 May 2019 22:38:07 -0700
From:   "Xing, Cedric" <cedric.xing@intel.com>
To:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "Andy Lutomirski" <luto@kernel.org>
CC:     Stephen Smalley <sds@tycho.nsa.gov>,
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
Subject: RE: SGX vs LSM (Re: [PATCH v20 00/28] Intel SGX1 support)
Thread-Topic: SGX vs LSM (Re: [PATCH v20 00/28] Intel SGX1 support)
Thread-Index: AQHVC0vUmIXibKT8TUm/EUnHn2XAfqZu5q2AgAAGWoCABXOKgIABz2SAgAAI9ACAAWgPAIAAAJWAgAAJhACAAByGAIAAdoKAgABA+ICAAIOmAIAAQKcAgAAWeICAAIbLAIAAGyYA///WAeCAARtHgIAAIeCAgAADbAD//5AmcIAAjJAAgAAHN4CAABd5AIAAFI2AgAARBICAAPo7MIAArTmA///E0eAAlLibAAAA1a8AAAHamoAAMz8G0A==
Date:   Thu, 30 May 2019 05:38:06 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F654EB439@ORSMSX116.amr.corp.intel.com>
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
 <20190528214107.GD13158@linux.intel.com>
In-Reply-To: <20190528214107.GD13158@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNWUyNTI4ODktOThjYS00OTNjLTljODMtZmQwNDMwMGUyYWM3IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiZ2hUUHhiTnF3UGNSYks4eEZ1Q3RNWHlBcXl1eldrcHJmZlZ2WU9lVWVMeGhjcUExdmZaa0VqODk4XC9kN0c0R08ifQ==
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

> From: Christopherson, Sean J
> Sent: Tuesday, May 28, 2019 2:41 PM
> 
> On Tue, May 28, 2019 at 01:48:02PM -0700, Andy Lutomirski wrote:
> > On Tue, May 28, 2019 at 1:24 PM Sean Christopherson
> > <sean.j.christopherson@intel.com> wrote:
> > >
> > > Actually, I think we do have everything we need from an LSM perspective.
> > > LSMs just need to understand that sgx_enclave_load() with a NULL vma
> > > implies a transition from RW.  For example, SELinux would interpret
> > > sgx_enclave_load(NULL, RX) as requiring FILE__EXECMOD.
> >
> > You lost me here.  What operation triggers this callback?  And
> > wouldn't sgx_enclave_load(NULL, RX) sometimes be a transition from RO
> > or just some fresh executable zero bytes?
> 
> An explicit ioctl() after EACCEPTCOPY to update the allowed permissions.
> For all intents and purposes, the EAUG'd page must start RW.  Maybe a better way to phrase
> it is that at some point the page must be writable to have any value whatsover.
> EACCEPTCOPY explicitly requires the page to be at least RW.  EACCEPT technically doesn't
> require RW, but a RO or RX zero page is useless.  Userspace could still EACCEPT with RO or
> RX, but SGX would assume a minimum of RW for the purposes of the LSM check.

Why is an explicit ioctl() necessary after EACCEPTCOPY? Or why is mprotect() not sufficient?

I tend to agree on Andy's MAXPERM model where MAXPERM never changes once established.

> 
> > > As Cedric mentioned earlier, the host process doesn't necessarily
> > > know which pages will end up RW vs RX, i.e. sgx_enclave_load(NULL,
> > > RX) already has to be invoked at runtime, and when that happens, the
> > > kernel can take the opportunity to change the VMAs from MAY_RW to MAY_RX.
> > >
> > > For simplicity in the kernel and clarity in userspace, it makes
> > > sense to require an explicit ioctl() to add the to-be-EAUG'd range.
> > > That just leaves us wanting an ioctl() to set the post-EACCEPT{COPY} permissions.
> > >
> > > E.g.:
> > >
> > >     ioctl(<prefix>_ADD_REGION, { NULL }) /* NULL == EAUG, MAY_RW */
> > >
> > >     mprotect(addr, size, RW);
> > >     ...
> > >
> > >     EACCEPTCOPY -> EAUG /* page fault handler */
> > >
> > >     ioctl(<prefix>_ACTIVATE_REGION, { addr, size, RX}) /* MAY_RX */
> > >
> > >     mprotect(addr, size, RX);
> >
> > In the maxperm model, this mprotect() will fail unless MAXPERM
> > contains RX, which could only happen if MAXPERM=RWX.  So, regardless
> > of how it's actually mapped to SELinux policy, MAXPERM=RWX is
> > functionally like EXECMOD and actual RWX PTEs are functionally like
> > EXECMEM.
> 
> Yep, same idea, except in the proposed flow ACTIVATE_REGION.


> 
> > >     ...
> > >
> > > And making ACTIVATE_REGION a single-shot per page eliminates the
> > > need for the MAXPERMS concept (see below).
> > >
> > > > If we keep only one MAXPERM, wouldn't this be the current behavior
> > > > of mmap()/mprotect()?
> > > >
> > > > To be a bit more clear, system admin sets MAXPERM upper bound in
> > > > the form of FILE__{READ|WRITE|EXECUTE|EXECMOD} of
> > > > /dev/sgx/enclave. Then for a process/enclave, if what it requires
> > > > falls below what's allowed on /dev/sgx/enclave, then everything
> > > > will just work. Otherwise, it fails in the form of -EPERM returned
> > > > from mmap()/mprotect(). Please note that MAXPERM here applies to
> > > > "runtime" permissions, while "initial" permissions are taken care
> > > > of by security_enclave_{load|init}. "initial" permissions could be
> > > > more permissive than "runtime" permissions, e.g., RX is still
> > > > required for initial code pages even though system admins could disable dynamically
> loaded code pages by *not* giving FILE__{EXECUTE|EXECMOD}. Therefore, the "initial"
> > > > mapping would still have to be done by the driver (to bypass LSM),
> > > > either via a new ioctl or as part of IOC_EINIT.
> > >
> > > Aha!
> > >
> > > Starting with Cedric's assertion that initial permissions can be
> > > taken directly from SECINFO:
> > >
> > >   - Initial permissions for *EADD* pages are explicitly handled via
> > >     sgx_enclave_load() with the exact SECINFO permissions.
> > >
> > >   - Initial permissions for *EAUG* are unconditionally RW.  EACCEPTCOPY
> > >     requires the target EPC page to be RW, and EACCEPT with RO is useless.
> > >
> > >   - Runtime permissions break down as follows:
> > >       R   - N/A, subset of RW (EAUG)
> > >       W   - N/A, subset of RW (EAUG) and x86 paging can't do W
> > >       X   - N/A, subset of RX (x86 paging can't do XO)
> >
> > Sure it can!  You just have a hypervisor that maps a PA bit to EPT
> > no-read.  Then you can use that PA bit to suppress read.  Also, Linux
> > already abuses PKRU to simulate XO, although that won't work for
> > enclaves.
> 
> Heh, I intentionally said "x86 paging" to rule out EPT :-)  I'm pretty sure it's a moot
> point though, I have a hard time believing an LSM will allow RW->X and not RW->RX.
> 
> > >       RW  - Handled by EAUG LSM hook (uses RW unconditionally)
> > >       WX  - N/A, subset of RWX (x86 paging can't do WX)
> > >       RX  - Handled by ACTIVATE_REGION
> > >       RWX - Handled by ACTIVATE_REGION
> > >
> > > In other words, if we define the SGX -> LSM calls as follows (minus
> > > the file pointer and other params for brevity):
> > >
> > >   - <prefix>_ACTIVATE_REGION(vma, perms) -> sgx_enclave_load(NULL,
> > > perms)

I'm not sure on what security_enclave_load()'s decision would be based.

> > >
> > >   - <prefix>_ADD_REGION(vma) -> sgx_enclave_load(vma, SECINFO.perms)
> > >
> > >   - <prefix>_ADD_REGION(NULL) -> sgx_enclave_load(NULL, RW)
> > >
> > > then SGX and LSMs have all the information and hooks needed.  The
> > > catch is that the LSM semantics of sgx_enclave_load(..., RW) would
> > > need to be different than normal shared memory, e.g. FILE__WRITE
> > > should *not* be required, but that's ok since it's an SGX specific
> > > hook.  And if for some reason an LSM wanted to gate access to EAUG
> > > *without* FILE__EXECMOD, it'd have the necessary information to do so.
> > >
> > > The userspace changes are fairly minimal:
> > >
> > >   - For SGX1, use PROT_NONE for the initial mmap() and refactor ADD_PAGE
> > >     to ADD_REGION.
> > >
> > >   - For SGX2, do an explicit ADD_REGION on the ranges to be EAUG'd, and an
> > >     ACTIVATE_REGION to make a region RX or R (no extra ioctl() required to
> > >     keep RW permissions).
> > >
> > > Because ACTIVATE_REGION can only be done once per page, to do
> > > *abitrary*
> > > mprotect() transitions, userspace would need to set the
> > > added/activated permissions to be a superset of the transitions,
> > > e.g. RW -> RX would require RWX, but that's a non-issue.
> > >
> >
> > I may be misunderstanding or just be biased to my own proposal, but
> > this seems potentially more complicated and less flexible than the
> > MAXPERM model.  One of the main things that made me come up with
> > MAXPERM is that I wanted to avoid any complicated PTE/VMA modification
> > or runtime changes.  So, with MAXPERM, we still need to track the
> > MAXPERM bits per page, but we don't ever need to *change* them or to
> > worry about what is or is not mapped anywhere at any given time.  With
> > ACTIVATE_REGION, don't we need to make sure that we don't have a
> > second VMA pointing at the same pages?  Or am I just confused?
> 
> In theory, it's still your MAXPERM model, but with the unnecessary states removed and the
> others enforced/handled by the natural SGX transitions instead of explictly in ioctls.
> Underneath the hood the SGX driver would still need to track the MAXPERM.

What are the "unnecessary states" removed? 

I'm not sure understand the proposal fully. The whole thing looks to me like the driver is undertaking things that should/would otherwise be done by mmap()/mprotect() syscalls. It also imposes unnecessary restrictions on user mode code, such as mmap(PROT_NONE), ACTIVATE_REGION can be called only once, etc. What'd happen if ACTIVATE_REGION is called with a range spanning multiple/partial VMAs? What'd happen if an enclave was unmapped than mapped again? I'd say the proposal is unintuitive at least.

In theory, if the driver can keep track of MAXPERM for all pages within an enclave, then it could fail mmap() if the requested prot conflicts with any page's MAXPERM within that range. Otherwise, MAXPERM could be copied into VM_MAY* flags then mprotect() will just follow through. Wouldn't that be a much simpler and more intuitive approach?

> 
> With SGX1, SECINFO == MAXPERM.  With SGX2, ACTIVATE_REGION == MAXPERM, with the
> implication that the previous state is always RW.
> 
> > >   - For SGX1 it's a nop since it's impossible to change the EPCM
> > >     permissions, i.e. the page would need to be RWX regardless.
> >
> > I may still be missing something, but, for SGX1, it's possible at
> > least in principle for the enclave to request, via ocall or similar,
> > that the untrusted runtime do mprotect().  It's not even such a bad
> > idea.  Honestly, enclaves *shouldn't* have anything actually writable
> > and executable at once because the enclaves don't want to be easily
> > exploited.
> 
> Yes, but the *EPCM* permissions are immutable.  So if an enclave wants to do RW->RX it has
> to intialize its pages to RWX.  And because the untrusted runtime is, ahem, untrusted, the
> enclave cannot rely on userspace to never map its pages RWX.  In other words, from a
> enclave security perspective, an SGX1 enclave+runtime that uses RW->RX is no different
> than an enclave that uses RWX.  Using your earlier terminology, an SGX1 enclave *should*
> get a dirty looks if maps a page RWX in the EPCM, even if it only intends RW->RX behavior.
> 
> > >   - For SGX2, userspace can suck it up and request RWX to do completely
> > >     arbitrary transitions (working as intended), or the kernel can support
> > >     trimming (removing) pages from an enclave, which would allow userspace
> > >     to do "arbitrary" transitions by first removing the page.
