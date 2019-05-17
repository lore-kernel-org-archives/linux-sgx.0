Return-Path: <SRS0=W/GT=TR=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF066C04AB4
	for <linux-sgx@archiver.kernel.org>; Fri, 17 May 2019 18:52:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A285020848
	for <linux-sgx@archiver.kernel.org>; Fri, 17 May 2019 18:52:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726732AbfEQSwv (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 17 May 2019 14:52:51 -0400
Received: from mga06.intel.com ([134.134.136.31]:38676 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726293AbfEQSwu (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 17 May 2019 14:52:50 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 May 2019 11:52:50 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga003.jf.intel.com with ESMTP; 17 May 2019 11:52:49 -0700
Date:   Fri, 17 May 2019 11:52:49 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andy Lutomirski <luto@amacapital.net>,
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
Subject: Re: SGX vs LSM (Re: [PATCH v20 00/28] Intel SGX1 support)
Message-ID: <20190517185249.GA16487@linux.intel.com>
References: <6a97c099-2f42-672e-a258-95bc09152363@tycho.nsa.gov>
 <20190517150948.GA15632@linux.intel.com>
 <ca807220-47e2-5ec2-982c-4fb4a72439c6@tycho.nsa.gov>
 <80013cca-f1c2-f4d5-7558-8f4e752ada76@tycho.nsa.gov>
 <20190517172953.GC15006@linux.intel.com>
 <DFE03E0C-694A-4289-B416-29CDC2644F94@amacapital.net>
 <20190517175500.GE15006@linux.intel.com>
 <CAHk-=wgH2FBzBG3_RZSuatpYCj8DCQZipJYp9vh3Wy_S3Qt4-g@mail.gmail.com>
 <20190517182124.GF15006@linux.intel.com>
 <CAHk-=wi6N1ckASALGDSydzj+YXwAUq26uVPZD0r2q4Mjwss7hw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wi6N1ckASALGDSydzj+YXwAUq26uVPZD0r2q4Mjwss7hw@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, May 17, 2019 at 11:33:30AM -0700, Linus Torvalds wrote:
> On Fri, May 17, 2019 at 11:21 AM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > I agree that conceptually EPC is private memory, but because EPC is
> > managed as a separate memory pool, SGX tags it VM_PFNMAP and manually
> > inserts PFNs, i.e. EPC effectively it gets classified as IO memory.
> >
> > And vmf_insert_pfn_prot() doesn't like writable private IO mappings:
> >
> >    BUG_ON((vma->vm_flags & VM_PFNMAP) && is_cow_mapping(vma->vm_flags));
> 
> Hmm. I haven't looked into why you want to do your own page insertion
> and not just "use existing pages", but I'm sure there's some reason.

Outside of the SGX subsystem, the kernel is unaware of EPC memory, e.g.
BIOS enumerates it as reserved memory in the e820 tables, or not at all.

On current hardware, EPC is backed by system memory, but it's protected
by a range registers (and other stuff) and can't be accessed directly
except when the CPU is in "enclave mode", i.e. executing an enclave in
CPL3.  To execute an enclave it must first be built, and because EPC
memory can't be written outside of enclave mode, the only way to build
the enclave is via dedicated CPL0 ISA, e.g. ENCLS[EADD].

> It looks like the "shared vs private" inode part is a red herring,
> though. You might as well give each opener of the sgx node its own
> inode - and you probably should. Then you can keep track of the pages
> that have been added in the inode->i_mapping, and you could avoid the
> whole PFN thing entirely. I still am not a huge fan of the device node
> in the first place, but I guess it's just one more place where a
> system admin can then give (or deny) access to a kernel feature from
> users. I guess the kvm people do the same thing, for not necessarily
> any better reasons.
> 
> With the PFNMAP model I guess the SGX memory ends up being unswappable
> - at least done the obvious way.

EPC memory is swappable in it's own terms, e.g. pages can be swapped
from EPC to system RAM and vice versa, but again moving pages in and out
of the EPC can only be done through dedicated CPL0 ISA.  And there are
additional TLB flushing requirements, evicted pages need to be refcounted
against the enclave, evicted pages need an anchor in the EPC to ensure
freshness, etc...

Long story short, we decided to manage EPC in the SGX subsystem as a
separate memory pool rather than modify the kernel's MMU to teach it
how to deal with EPC.

> Again, the way I'd expect it to be done is as a shmem inode - that
> would I think be a better model. But I think that's a largely internal
> design decision, and the device node could just do that eventually
> (and the mmap could just map the populated shmem information into
> memory, no PFNMAP needed - the inode and the mapping could be
> "read-only" as far as the _user_ is concerned, but the i_mapping then
> gets populated by the ioctl's).
> 
> I have not actually looked at any of the SGX patches, so maybe you're
> already doing something like that (although the PFNMAP comment makes
> me think not), and quite possibly there's some fundamental reason why
> you can't just use the shmem approach.
> 
> So my high-level reaction here may be just the rantings of somebody
> who just isn't familiar with what you do. My "why not shmem and
> regular mmap" questions come from a 30000ft view without knowing any
> of the details.
> 
>                    Linus
