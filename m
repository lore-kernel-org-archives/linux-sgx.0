Return-Path: <SRS0=Nb5J=TY=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49951C282E1
	for <linux-sgx@archiver.kernel.org>; Fri, 24 May 2019 22:41:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12E2C2175B
	for <linux-sgx@archiver.kernel.org>; Fri, 24 May 2019 22:41:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbfEXWlJ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 24 May 2019 18:41:09 -0400
Received: from mga07.intel.com ([134.134.136.100]:15291 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727091AbfEXWlJ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 24 May 2019 18:41:09 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 May 2019 15:41:08 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga002.jf.intel.com with ESMTP; 24 May 2019 15:41:07 -0700
Date:   Fri, 24 May 2019 15:41:07 -0700
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
Message-ID: <20190524224107.GJ365@linux.intel.com>
References: <20190523234044.GC12078@linux.intel.com>
 <CALCETrV4DVEfW6EJ6DnQGGYDJAiA5M1QcuYJTiroumOM+D6Jjg@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F654E8956@ORSMSX116.amr.corp.intel.com>
 <dda0912b-cb15-3c07-d368-345159e995f7@tycho.nsa.gov>
 <20190524174243.GA365@linux.intel.com>
 <20190524175458.GB365@linux.intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F654E8E1D@ORSMSX116.amr.corp.intel.com>
 <CALCETrUw5sEr-MHPMU4CzEzkrejDs-JOThHB9Buhoxo5-rdpRw@mail.gmail.com>
 <20190524200333.GF365@linux.intel.com>
 <CALCETrUyAAhnQ+RUeN1L41TKj-vcD2CNt-FJ9siO=Zo6gvH1Aw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUyAAhnQ+RUeN1L41TKj-vcD2CNt-FJ9siO=Zo6gvH1Aw@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, May 24, 2019 at 02:27:34PM -0700, Andy Lutomirski wrote:
> On Fri, May 24, 2019 at 1:03 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> >
> > On Fri, May 24, 2019 at 12:37:44PM -0700, Andy Lutomirski wrote:
> > > On Fri, May 24, 2019 at 11:34 AM Xing, Cedric <cedric.xing@intel.com> wrote:
> > > >
> > > > If "initial permissions" for enclaves are less restrictive than shared
> > > > objects, then it'd become a backdoor for circumventing LSM when enclave
> > > > whitelisting is *not* in place. For example, an adversary may load a page,
> > > > which would otherwise never be executable, as an executable page in EPC.
> > > >
> > > > In the case a RWX page is needed, the calling process has to have a RWX
> > > > page serving as the source for EADD so PROCESS__EXECMEM will have been
> > > > checked. For SGX2, changing an EPC page to RWX is subject to FILE__EXECMEM
> > > > on /dev/sgx/enclave, which I see as a security benefit because it only
> > > > affects the enclave but not the whole process hosting it.
> > >
> > > So the permission would be like FILE__EXECMOD on the source enclave
> > > page, because it would be mapped MAP_ANONYMOUS, PROT_WRITE?
> > > MAP_SHARED, PROT_WRITE isn't going to work because that means you can
> > > modify the file.
> >
> > Was this in response to Cedric's comment, or to my comment?
> 
> Yours.  I think that requiring source pages to be actually mapped W is
> not such a great idea.

I wasn't requiring source pages to be mapped W.  At least I didn't intend
to require W.  What I was trying to say is that SGX could trigger an
EXECMEM check if userspace attempted to EADD or EAUG an enclave page with
RWX permissions, e.g.:

  if ((SECINFO.PERMS & RWX) == RWX) {
      ret = security_mmap_file(NULL, RWX, ???);
      if (ret)
          return ret;
  }

But that's a moot point if we add security_enclave_load() or whatever.

> 
> >
> > > I'm starting to think that looking at the source VMA permission bits
> > > or source PTE permission bits is putting a bit too much policy into
> > > the driver as opposed to the LSM.  How about delegating the whole
> > > thing to an LSM hook?  The EADD operation would invoke a new hook,
> > > something like:
> > >
> > > int security_enclave_load_bytes(void *source_addr, struct
> > > vm_area_struct *source_vma, loff_t source_offset, unsigned int
> > > maxperm);
> > >
> > > Then you don't have to muck with mapping anything PROT_EXEC.  Instead
> > > you load from a mapping of a file and the LSM applies whatever policy
> > > it feels appropriate.  If the first pass gets something wrong, the
> > > application or library authors can take it up with the SELinux folks
> > > without breaking the whole ABI :)
> > >
> > > (I'm proposing passing in the source_vma because this hook would be
> > > called with mmap_sem held for read to avoid a TOCTOU race.)
> > >
> > > If we go this route, the only substantial change to the existing
> > > driver that's needed for an initial upstream merge is the maxperm
> > > mechanism and whatever hopefully minimal API changes are needed to
> > > allow users to conveniently set up the mappings.  And we don't need to
> > > worry about how to hack around mprotect() calling into the LSM,
> > > because the LSM will actually be aware of SGX and can just do the
> > > right thing.
> >
> > This doesn't address restricting which processes can run which enclaves,
> > it only allows restricting the build flow.  Or are you suggesting this
> > be done in addition to whitelisting sigstructs?
> 
> In addition.
> 
> But I named the function badly and gave it a bad signature, which
> confused you.  Let's try again:
> 
> int security_enclave_load_from_memory(const struct vm_area_struct
> *source, unsigned int maxperm);

I prefer security_enclave_load(), "from_memory" seems redundant at best.

> Maybe some really fancy future LSM would also want loff_t
> source_offset, but it's probably not terribly useful.  This same
> callback would be used for EAUG.
> 
> Following up on your discussion with Cedric about sigstruct, the other
> callback would be something like:
> 
> int security_enclave_init(struct file *sigstruct_file);
> 
> The main issue I see is that we also want to control the enclave's
> ability to have RWX pages or to change a W page to X.  We might also
> want:
> 
> int security_enclave_load_zeros(unsigned int maxperm);

What's the use case for this?  @maxperm will always be at least RW in
this case, otherwise the page is useless to the enclave, and if the
enclave can write the page, the fact that it started as zeros is
irrelevant.

> An enclave that's going to modify its own code will need memory with
> maxperm = RWX or WX.
> 
> But this is a bit awkward if the LSM's decision depends on the
> sigstruct.  We could get fancy and require that the sigstruct be
> supplied before any EADD operations so that the maxperm decisions can
> depend on the sigstruct.
> 
> Am I making more sense now?

Yep.  Requiring .sigstruct at ECREATE would be trivial.  If we wanted
flexibility we could do:

   int security_enclave_load(struct file *file, struct vm_area_struct *vma,
                             unsigned long prot);

And for ultimate flexibility we could pass both .sigstruct and the file
pointer for /dev/sgx/enclave, but that seems a bit ridiculous.

Passing both would allow tying EXECMOD to /dev/sgx/enclave as Cedric
wanted (without having to play games and pass /dev/sgx/enclave to
security_enclave_load()), but I don't think there's anything fundamentally
broken with using .sigstruct for EXECMOD.  It requires more verbose
labeling, but that's not a bad thing.
