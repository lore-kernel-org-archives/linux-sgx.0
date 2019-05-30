Return-Path: <SRS0=2c9w=T6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55278C28CC0
	for <linux-sgx@archiver.kernel.org>; Thu, 30 May 2019 18:01:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D39825EEA
	for <linux-sgx@archiver.kernel.org>; Thu, 30 May 2019 18:01:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726330AbfE3SBO (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 30 May 2019 14:01:14 -0400
Received: from mga05.intel.com ([192.55.52.43]:6657 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726125AbfE3SBN (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 30 May 2019 14:01:13 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 May 2019 11:01:11 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga006.jf.intel.com with ESMTP; 30 May 2019 11:01:10 -0700
Date:   Thu, 30 May 2019 11:01:10 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Stephen Smalley <sds@tycho.nsa.gov>,
        "Xing, Cedric" <cedric.xing@intel.com>,
        William Roberts <bill.c.roberts@gmail.com>,
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
Message-ID: <20190530180110.GB23930@linux.intel.com>
References: <960B34DE67B9E140824F1DCDEC400C0F654E965F@ORSMSX116.amr.corp.intel.com>
 <CALCETrXXVMutX8eZk6nnkOAeS+Tj0sQd0FkW+wk6Rx8hQxCe6w@mail.gmail.com>
 <960B34DE67B9E140824F1DCDEC400C0F654E9824@ORSMSX116.amr.corp.intel.com>
 <20190528202407.GB13158@linux.intel.com>
 <285f279f-b500-27f0-ab42-fb1dbcc5ab18@tycho.nsa.gov>
 <960B34DE67B9E140824F1DCDEC400C0F654EB487@ORSMSX116.amr.corp.intel.com>
 <678a37af-797d-7bd5-a406-32548a270e3d@tycho.nsa.gov>
 <CALCETrWXB9fNNDH7gZxPTx05F78Og6K=ZtAr2aA++BDwY09Wbg@mail.gmail.com>
 <c1135352-0b5e-4694-b1a9-105876095877@tycho.nsa.gov>
 <CALCETrWsEXzUC33eJpGCpdMCBO4aYVviZLRD-CLMNaG5Jv-TCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWsEXzUC33eJpGCpdMCBO4aYVviZLRD-CLMNaG5Jv-TCA@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, May 30, 2019 at 09:14:10AM -0700, Andy Lutomirski wrote:
> On Thu, May 30, 2019 at 8:04 AM Stephen Smalley <sds@tycho.nsa.gov> wrote:
> >
> > On 5/30/19 10:31 AM, Andy Lutomirski wrote:
> > > Hi all-
> > >
> > > After an offline discussion with Sean yesterday, here are some updates
> > > to the user API parts of my proposal.
> > >
> > > Unfortunately, Sean convinced me that MAXPERM doesn't work the way I
> > > described it because, for SGX2, the enclave loader won't know at load
> > > time whether a given EAUG-ed page will ever be executed.  So here's an
> > > update.
> > >
> > > First, here are the requrements as I see them, where EXECUTE, EXECMOD,
> > > and EXECMEM could be substituted with other rules at the LSM's
> > > discretion:
> > >
> > >   - You can create a WX or RWX mapping if and only if you have EXECMEM.
> > >
> > >   - To create an X mapping of an enclave page that has ever been W, you
> > > need EXECMOD.
> >
> > EXECMOD to what file? The enclave file from which the page's content
> > originated, the sigstruct file, or /dev/sgx/enclave?
> 
> I leave that decision to you :)  The user should need permission to do
> an execmod thing on an enclave, however that wants to be encoded.

But that decision dictates how the SGX API handles sigstruct.  If LSMs
want to associate EXECMOD with sigstruct, then SGX needs to take sigstruct
early and hold a reference to the file for the lifetime of the enclave.
And if we're going to do that, the whole approach of inheriting
permissions from source VMAs becomes unnecessary complexity.

> >
> > >   - To create an X mapping of an enclave page that came from EADD, you
> > > need EXECUTE on the source file.  Optionally, we could also permit
> > > this if you have EXECMOD.
> >
> > What is the "source file" i.e. the target of the check?  Enclave file,
> > sigstruct file, or /dev/sgx/enclave?
> 
> Enclave file -- that is, the file backing the vma from which the data is loaded.

It wasn't explicitly called out in Andy's proposal(s), but the idea is
that the SGX driver would effectively inherit permissions from the source
VMA (EADD needs a source for the initial value of the encave page).

I have two gripes with that approach:

  - Requires enclave builder to mark enclave pages executable in the
    non-enclave VMAs, which may unnecessarily require EXECMOD on the
    source file, or even worse, EXECMEM, and potentially increases the
    attack surface since the file must be executable.

  - Is completely unnecessary if the enclave holds a reference to the
    sigstruct file, as LSMs can easily apply labels to the sigstruct,
    e.g. EXECUTE on the sigstruct instead of EXECUTE on the source file.


After the bajillion mails we've generated, AIUI we've come up with two
concepts that are viable: inheriting permissions from the source VMA
vs. using sigstruct as a proxy for the enclave.  Andy's proposals rely on
the inheritance concept.  The proposal below is based on the sigstruct
proxy concept.

For those not familiar with SGX details, sigstruct can be used as a proxy
because hardware enforces that the measurement stored in the sigstruct
exactly matches the measurement generated by the enclave build process,
e.g. adding a page as RX instead of R will change the measurement.

Core Concepts:
  - FILE_{READ,WRITE,EXEC} on /dev/sgx/enclave effectively gates access to
    EPC.  All real world enclaves will need all three permissions.
  - sigstruct is the proxy for enclave from an LSM perspective, e.g.
    SELinux can define ENCLAVE__EXECUTE and ENCLAVE__EXECMOD and apply
    them to the sigstruct file.
  - Take sigstruct at ECREATE so that ADD_REGION immediately followed by
    mprotect() works as expected (because SGX.mprotect() needs sigstruct
    to pass to security_enclave_mprotect(), see below).
  - SGX driver takes a reference to the backing sigstruct file if it
    exists so that the file can be provided to LSMs during mprotect().
  - Optional: SGX driver *requires* sigstruct to be backed by file, purely
    to enforce userspace infrastructure is in place for LSM support.

W^X handling:
  - mmap() to /dev/sgx/enclave only allowed with PROT_NONE, i.e. force
    userspace through mprotect() to simplify the kernel implementation.
  - Add vm_ops mprotect() ops hook (I'll refer to SGX's implementation
    as SGX.mprotect())
  - Take explicit ALLOW_WRITE at ADD_REGION, a.k.a. EADD
  - ADD_REGION also used to describe EAUG region (tentatively for SGX2).
  - Track "can be written at some point in time (past or future)" as
    ALLOW_WRITE (to avoid confusiong with MAY_WRITE).  A priori knowledge
    of writability avoids having to track/coordinate PROT_WRITE across
    VMAs and MMs.
  - SGX.mprotect() returns -EPERM if PROT_WRITE && !ALLOW_WRITE.
  - Add security_enclave_mprotect() LSM hook, called by SGX.mprotect(),
    e.g. int security_enclave_mprotect(struct file *sigstruct,
                                       unsigned long prot,
                                       bool allow_write)
  - Intention is that EXECMOD is required if PROT_EXEC and ALLOW_WRITE.

Enclave {white,black}listing:
  - Optional/Future: add security_enclave_create(), invoked during
    SGX ECREATE ioctl(), e.g.
       int security_enclave_create(struct vm_area_struct *sigstruct)

  - If this LSM hook is implemented, having sigstruct at ECREATE
    allows LSMs to determine whether or not the enclave is allowed to
    execute before allocating EPC for the enclave, e.g. unwanted enclaves
    can't DoS wanted enclaves.

LSM implementation possibilities:

  - Define ENCLAVE__EXECUTE and ENCLAVE__EXECMOD, require them on the
    process.  Does not require sigstruct to be backed by file, but cannot
    achieve per-enclave granularity.  

  - Define ENCLAVE__EXECUTE and ENCLAVE__EXECMOD, require them on the
    sigstruct, i.e. force sigstruct to reside in filesystem.  Allows
    per-enclave granularity.

  - Reuse FILE__EXECUTE and FILE__EXECMOD on sigstruct.  Likely has
    implications that may or may not be concerning, e.g. the sigstruct
    file itself is weirdly executable.

  - Adding ENCLAVE__EXECUTE and ENCLAVE__EXECMOD means the sigstruct,
    which may be emdedded in the same file as the enclave, does *not*
    require FILE__EXECUTE or FILE__EXECMOD, e.g. can be read-only.

  - LSMs can (will?) require ENCLAVE__EXECUTE and ENCLAVE__EXECMOD to
    effectively map an enclave, even if the process acquired the enclave
    via SCM_RIGHTS (enclaves are tracked by fds).  This is good or bad
    depending on your perspective.

Userspace changes:

  - EADD ioctl adds flags param to take ALLOW_WRITE

  - ECREATE ioctl takes sigstruct instead of EINIT

  - Initial mmap() must be PROT_NONE.

  - sigstruct likely needs to reside in a file (this may not affect
    some userspace implementations).
