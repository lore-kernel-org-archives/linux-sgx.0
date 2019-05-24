Return-Path: <SRS0=Nb5J=TY=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D2E9C282E1
	for <linux-sgx@archiver.kernel.org>; Fri, 24 May 2019 21:11:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4D8921848
	for <linux-sgx@archiver.kernel.org>; Fri, 24 May 2019 21:11:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404202AbfEXVLN (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 24 May 2019 17:11:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:51843 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404197AbfEXVLN (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 24 May 2019 17:11:13 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 May 2019 14:11:12 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by fmsmga006.fm.intel.com with ESMTP; 24 May 2019 14:11:11 -0700
Date:   Fri, 24 May 2019 14:11:11 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     "Xing, Cedric" <cedric.xing@intel.com>
Cc:     Stephen Smalley <sds@tycho.nsa.gov>,
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
Subject: Re: SGX vs LSM (Re: [PATCH v20 00/28] Intel SGX1 support)
Message-ID: <20190524211111.GI365@linux.intel.com>
References: <CALCETrUzx3LPAKCLFf75P-XshAkRcr+JLET3LA_kHDs9MA11FA@mail.gmail.com>
 <20190523234044.GC12078@linux.intel.com>
 <CALCETrV4DVEfW6EJ6DnQGGYDJAiA5M1QcuYJTiroumOM+D6Jjg@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F654E8956@ORSMSX116.amr.corp.intel.com>
 <dda0912b-cb15-3c07-d368-345159e995f7@tycho.nsa.gov>
 <20190524174243.GA365@linux.intel.com>
 <20190524175458.GB365@linux.intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F654E8E1D@ORSMSX116.amr.corp.intel.com>
 <20190524191344.GD365@linux.intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F654E8FC2@ORSMSX116.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <960B34DE67B9E140824F1DCDEC400C0F654E8FC2@ORSMSX116.amr.corp.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, May 24, 2019 at 01:42:13PM -0700, Xing, Cedric wrote:
> > From: linux-sgx-owner@vger.kernel.org [mailto:linux-sgx-
> > owner@vger.kernel.org] On Behalf Of Sean Christopherson
> > Sent: Friday, May 24, 2019 12:14 PM
> > 
> > My point is that enclaves have different properties than shared objects.
> > 
> > Normal LSM behavior with regard to executing files is to label files
> > with e.g. FILE__EXECUTE.  Because an enclave must be built to the exact
> > specifications of .sigstruct, requring FILE__EXECUTE on the .sigstruct
> > is effectively the same as requiring FILE__EXECUTE on the enclave itself.
> > 
> > Addressing your scenario of loading an executable page in EPC, doing so
> > would require one of the following:
> > 
> >   - Ability to install a .sigstruct with FILE__EXECUTE
> > 
> >   - PROCESS__EXECMEM
> > 
> >   - FILE__EXECMOD and SGX2 support
> 
> Now I got your point. It sounds a great idea to me!
> 
> But instead of using .sigstruct file, I'd still recommend using file mapping
> (i.e. SIGSTRUCT needs to reside in executable memory). But then there'll be a

Why?  Even in the Graphene case the final .sigstruct can be known ahead of
time.  Userspace can always use memfd() if it's generating SIGSTRUCT on
the fly.

> hole - a process having FILE__EXECMOD on any file could use that file as a
> SIGSTRUCT. Probably we'll need a new type in SELinux to label
> enclave/sigstruct files.
>
> > I don't see a fundamental difference between having RWX in an enclave
> > and RWX in normal memory, either way the process can execute arbitrary
> > code, i.e. PROCESS__EXECMEM is appropriate.  Yes, an enclave will #UD on
> > certain instructions, but that's easily sidestepped by having a
> > trampoline in the host (marked RX) and piping arbitrary code into the
> > enclave.  Or using EEXIT to do a bit of ROP.
> 
> I'm with you.
> 
> With your proposal only FILE__EXECMOD is needed on /dev/sgx/enclave to launch
> Graphene enclaves or the like.

It wouldn't even need FILE__EXECMOD, assuming Graphene does all of its
libc rewriting before building the enclave, i.e. doesn't EADD RWX pages.

> > > > > No changes are required to LSMs, SGX1 has a single LSM touchpoint
> > > > > in
> > > > its
> > > > > mmap(), and I *think* the only required userspace change is to
> > > > > mmap() PROT_NONE when allocating the enclave's virtual address
> > range.
> > >
> > > I'm not sure I understand the motivation behind this proposal to
> > > decouple initial EPC permissions from source pages.
> > 
> > Pulling permissions from source pages means userspace needs to fully map
> > the in normal memory, including marking pages executable.  That exposes
> > the loader to having executable pages in its address space that it has
> > no intention of executing (outside of the enclave).  And for Graphene,
> > it means having to actively avoid PROCESS__EXECMEM, e.g. by using a
> > dummy backing file to build the enclave instead of anon memory.
> 
> Agreed.
> 
> > 
> > > I don't think it a big deal to fully mmap() enclave files, which have
> > > to be parsed by user mode anyway to determine various things including
> > > but not limited to the size of heap(s), size and number of
> > > TCSs/stacks/TLS areas, and the overall enclave size. So with PHDRs
> > > parsed, it's trivial to mmap() each segment with permissions from its
> > PHDR.
> > >
> > > > > As for Graphene, it doesn't need extra permissions to run its
> > > > > enclaves, it just needs a way to install .sigstruct, which is a
> > > > > generic permissions problem and not SGX specific.
> > > > >
> > > > >
> > > > > For SGX2 maybe:
> > > > >
> > > > >   - No additional requirements to map an EAUG'd page as RW page.
> > Not
> > > > >     aligned with standard MAP_SHARED behavior, but we really don't
> > want
> > > > >     to require FILE__WRITE, and thus allow writes to .sigstruct.
> > > > >
> > > > >   - Require FILE__EXECMOD on the .sigstruct to map previously
> > writable
> > > > >     page as executable (which indirectly includes all EAUG'd
> > pages).
> > > > >     Wiring this up will be a little funky, but we again we don't
> > want
> > > > >     to require FILE__WRITE on .sigstruct.
> > > > >
> > >
> > > I'm lost. Why is EAUG tied to permissions on .sigstruct?
> > 
> > Because for the purposes of LSM checks, .sigstruct is the enclave's
> > backing file, and mapping a previously writable enclave page as
> > exectuable is roughly equivalent to mapping a CoW'd page as exectuable.
> 
> I think I've got your idea. You are trying to use permissions on .sigstruct
> to determine whether EAUG will be available to that specific enclave. Am I
> right?

Yep.

> I'd tie EAUG to the permissions of /dev/sgx/enclave instead. But why? There
> are couple of reasons. For one, a SIGSTRUCT identifies the behavior of the
> enclave, hence the SGX features needed by that enclave. So if an enclave
> requires EAUG, the .sigstruct has to allow EAUG or the enclave wouldn't work.
> That means the system admin wouldn't have a choice but to match up what's
> needed by the enclave. For two, whether to allow, say loading code
> dynamically into an enclave, depends on whether the host process can tolerate
> the inherent risk. And that decision is seldom made on individual enclaves
> but to the host process as a whole. And /dev/sgx/enclave serves that purpose.

I think I'd be ok either way?  What I really care about is having line of
sight to a sane way to support for SGX2, and both seem sane.  I.e. we can
hash this detail out when SGX2 goes in.
