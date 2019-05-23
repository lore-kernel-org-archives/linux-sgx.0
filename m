Return-Path: <SRS0=njgX=TX=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3B5DC282DD
	for <linux-sgx@archiver.kernel.org>; Thu, 23 May 2019 23:40:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 45A642133D
	for <linux-sgx@archiver.kernel.org>; Thu, 23 May 2019 23:40:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388232AbfEWXkr (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 23 May 2019 19:40:47 -0400
Received: from mga06.intel.com ([134.134.136.31]:12427 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388129AbfEWXkr (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 23 May 2019 19:40:47 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 May 2019 16:40:46 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by fmsmga004.fm.intel.com with ESMTP; 23 May 2019 16:40:44 -0700
Date:   Thu, 23 May 2019 16:40:44 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>, selinux@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        "Xing, Cedric" <cedric.xing@intel.com>,
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
Message-ID: <20190523234044.GC12078@linux.intel.com>
References: <20190521155140.GE22089@linux.intel.com>
 <20190522132022.GC31176@linux.intel.com>
 <20190522132227.GD31176@linux.intel.com>
 <0e183cce-c4b4-0e10-dbb6-bd81bea58b66@tycho.nsa.gov>
 <20190522153836.GA24833@linux.intel.com>
 <CALCETrUS8xyF1JJmQs18BGTDhPRXf+s81BkMZCZwmY73r7M+zg@mail.gmail.com>
 <20190523023517.GA31950@linux.intel.com>
 <20190523102628.GC10955@linux.intel.com>
 <20190523141752.GA12078@linux.intel.com>
 <CALCETrUzx3LPAKCLFf75P-XshAkRcr+JLET3LA_kHDs9MA11FA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUzx3LPAKCLFf75P-XshAkRcr+JLET3LA_kHDs9MA11FA@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, May 23, 2019 at 08:38:17AM -0700, Andy Lutomirski wrote:
> On Thu, May 23, 2019 at 7:17 AM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > On Thu, May 23, 2019 at 01:26:28PM +0300, Jarkko Sakkinen wrote:
> > > On Wed, May 22, 2019 at 07:35:17PM -0700, Sean Christopherson wrote:
> > > > But actually, there's no need to disallow mmap() after ECREATE since the
> > > > LSM checks also apply to mmap(), e.g. FILE__EXECUTE would be needed to
> > > > mmap() any enclave pages PROT_EXEC.  I guess my past self thought mmap()
> > > > bypassed LSM checks?  The real problem is that mmap()'ng an existing
> > > > enclave would require FILE__WRITE and FILE__EXECUTE, which puts us back
> > > > at square one.
> > >
> > > I'm lost with the constraints we want to set.
> >
> > As is today, SELinux policies would require enclave loaders to have
> > FILE__WRITE and FILE__EXECUTE permissions on /dev/sgx/enclave.  Presumably
> > other LSMs have similar requirements.  Requiring all processes to have
> > FILE__{WRITE,EXECUTE} permissions means the permissions don't add much
> > value, e.g. they can't be used to distinguish between an enclave that is
> > being loaded from an unmodified file and an enclave that is being
> > generated on the fly, e.g. Graphene.
> >
> > Looking back at Andy's mail, he was talking about requiring FILE__EXECUTE
> > to run an enclave, so perhaps it's only FILE__WRITE that we're trying to
> > special case.
> >
> 
> I thought about this some more, and I have a new proposal that helps
> address the ELRANGE alignment issue and the permission issue at the
> cost of some extra verbosity.  Maybe you all can poke holes in it :)
> The basic idea is to make everything more explicit from a user's
> perspective.  Here's how it works:
> 
> Opening /dev/sgx/enclave gives an enclave_fd that, by design, doesn't
> give EXECUTE or WRITE.  mmap() on the enclave_fd only works if you
> pass PROT_NONE and gives the correct alignment.  The resulting VMA
> cannot be mprotected or mremapped.  It can't be mmapped at all until

I assume you're thinking of clearing all VM_MAY* flags in sgx_mmap()?

> after ECREATE because the alignment isn't known before that.

I don't follow.  The alignment is known because userspace knows the size
of its enclave.  The initial unknown is the address, but that becomes
known once the initial mmap() completes.

> Associated with the enclave are a bunch (up to 7) "enclave segment

I assume 7 = R, W, X, RW, RX, WX and RWX?

> inodes".  These are anon_inodes that are created automagically.  An
> enclave segment is a group of pages, not necessary contiguous, with an
> upper bound on the memory permissions.  Each enclave page belongs to a
> segment.  When you do EADD, you tell the driver what segment you're
> adding to. [0]  This means that EADD gets an extra argument that is a
> permission mask for the page -- in addition to the initial SECINFO,
> you also pass to EADD something to the effect of "I promise never to
> map this with permissions greater than RX".
>
> Then we just need some way to mmap a region from an enclave segment.
> This could be done by having a way to get an fd for an enclave segment
> or it could be done by having a new ioctl SGX_IOC_MAP_SEGMENT.  User
> code would use this operation to replace, MAP_FIXED-style, ranges from
> the big PROT_NONE mapping with the relevant pages from the enclave
> segment.  The resulting vma would only have VM_MAYWRITE if the segment
> is W, only have VM_MAYEXEC if the segment is X, and only have
> VM_MAYREAD if the segment is R.  Depending on implementation details,
> the VMAs might need to restrict mremap() to avoid mapping pages that
> aren't part of the segment in question.

If my above assumptions regarding VM_MAY* and the "7 segments" are
correct, IIUC you're proposing that an LSM could have policies for each
of the anon inodes, e.g. grant/deny RWX vs. RW vs RX.  Am I in the
ballpark?

> It's plausible that this whole thing works without the magic segment
> inodes under the hood, but figuring that out would need a careful look
> at how all the core mm bits and LSM bits work together.
>
> To get all the LSM stuff to work, SELinux will need some way to
> automatically assign an appropriate label to the segment inodes.  I
> assume that such a mechanism already exists and gets used for things
> like sockets, but I haven't actually confirmed this.

I (obviously) don't fully understand your proposal, but I don't think we
want to hook inodes, e.g. AppArmor doesn't implement inode_permission()
but does implement file_mprotect() and mmap_file(), which feel like the
natural hooks for this sort of thing.  I also think it's overkill, e.g.
AppArmor doesn't have a concept of EXECMOD, EXECMEM, EXECHEAP, etc.., so
I don't think we need to go beyond detecting W+X scenarios.

Starting with your original idea of tracking "safe to execute" and
Cedric's of propagating the permissions from the source VMA, but tweaked
with your new idea of clearing VM_MAY* and a custom MAP_FIXED/mprotect().

Add SGX_IOC_MPROTECT (or SGX_IOC_MAP_REGION?) that works as follows:

  1. Track VM_MAY{READ,WRITE,EXEC} flags for each enclave page.
  2. SGX_IOC_ADD_REGION, i.e. EADD, initializes the VM_MAY* flags for each
     enclave page based on the source VMA.
  3. sgx_mmap() only works with PROT_NONE, skips alignment stuff if
     MAP_FIXED, and clears VM_MAY{READ,WRITE,EXEC}.
  4. mprotect() on /dev/sgx/enclave doesn't work because the VMA doesn't
     have any VM_MAY{READ,WRITE,EXEC} capabilities.
  5. Deny mremap() post-ECREATE as the address and size of the enclave
     are fixed at ECREATE (in hardware).
  6. SGX_IOC_MPROTECT works like normal mprotect(), except the VM_MAY*
     flags are pulled from the enclave pages, and its call to
     security_file_mprotect() is VM_READ|VM_EXEC by default.  The LSM call
     sets VM_WRITE iff the enclave page has both VM_MAYWRITE and
     VM_MAYEXEC.  The idea here is to require READ and EXECUTE to run an
     enclave, and only require WRITE on /dev/sgx/enclave when the enclave
     can execute modified memory.

To support SGX2 down the road, which will want to convert a page to
executable on the fly, we could add:

  7. SGX_IOC_EXTEND_PERMISSIONS enables userspace to extend the VM_MAY*
     flags for an enclave page, e.g. to make a page executable.
     SGX_IOC_MPROTECT is still required to actually map the page.
     Notably, adding a RW page to the enclave, e.g. to grow its heap,
     doesn't require WRITE, whereas adding a RWX page, e.g. for dynamic
     loading, would require WRITE.  This can only extend!  E.g. userspace
     can't circumvent the WRITE requirement by clearing VM_MAYWRITE.

Note, FILE__WRITE on /dev/sgx/enclave is essentially equivalent to
FILE__EXECMOD.  Using FILE__WRITE in this way means there are no changes
to SELinux (triggering FILE__EXECMOD would be awkward), and AppArmor also
picks up extra protections for enclaves.

> [0] There needs to be some vaguely intelligent semantics if you EADD
> the *same* address more than once.  A simple solution would be to
> disallow it if the segments don't match.

I don't see any reason to allow duplicate EADD as it serves no purpose,
e.g. doing so changes the enclave's measurement and that's it.
