Return-Path: <SRS0=nxNq=UC=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34B00C04AB5
	for <linux-sgx@archiver.kernel.org>; Mon,  3 Jun 2019 17:15:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B406275EA
	for <linux-sgx@archiver.kernel.org>; Mon,  3 Jun 2019 17:15:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbfFCRPv (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 3 Jun 2019 13:15:51 -0400
Received: from mga18.intel.com ([134.134.136.126]:8535 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726823AbfFCRPv (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 3 Jun 2019 13:15:51 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Jun 2019 10:15:50 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by fmsmga007.fm.intel.com with ESMTP; 03 Jun 2019 10:15:49 -0700
Date:   Mon, 3 Jun 2019 10:15:49 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     "Xing, Cedric" <cedric.xing@intel.com>
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
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
        David Rientjes <rientjes@google.com>,
        "Roberts, William C" <william.c.roberts@intel.com>,
        "Tricca, Philip B" <philip.b.tricca@intel.com>
Subject: Re: [RFC PATCH 0/9] security: x86/sgx: SGX vs. LSM
Message-ID: <20190603171549.GE13384@linux.intel.com>
References: <20190531233159.30992-1-sean.j.christopherson@intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F654EC5FD@ORSMSX116.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <960B34DE67B9E140824F1DCDEC400C0F654EC5FD@ORSMSX116.amr.corp.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sun, Jun 02, 2019 at 12:29:35AM -0700, Xing, Cedric wrote:
> Hi Sean,
> 
> > From: Christopherson, Sean J
> > Sent: Friday, May 31, 2019 4:32 PM
> > 
> > This series is the result of a rather absurd amount of discussion over how to get SGX to play
> > nice with LSM policies, without having to resort to evil shenanigans or put undue burden on
> > userspace.  The discussion definitely wandered into completely insane territory at times, but
> > I think/hope we ended up with something reasonable.
> > 
> > The basic gist of the approach is to require userspace to declare what protections are
> > maximally allowed for any given page, e.g. add a flags field for loading enclave pages that
> > takes ALLOW_{READ,WRITE,EXEC}.  LSMs can then adjust the allowed protections, e.g. clear
> > ALLOW_EXEC to prevent ever mapping the page with PROT_EXEC.  SGX enforces the allowed perms
> > via a new mprotect() vm_ops hook, e.g. like regular mprotect() uses MAY_{READ,WRITE,EXEC}.
> > 
> > ALLOW_EXEC is used to deny hings like loading an enclave from a noexec file system or from a
> > file without EXECUTE permissions, e.g. without the ALLOW_EXEC concept, on SGX2 hardware
> > (regardless of kernel support) userspace could EADD from a noexec file using read-only
> > permissions, and later use mprotect() and ENCLU[EMODPE] to gain execute permissions.
> > 
> > ALLOW_WRITE is used in conjuction with ALLOW_EXEC to enforce SELinux's EXECMOD (or EXECMEM).
> > 
> > This is very much an RFC series.  It's only compile tested, likely has obvious bugs, the
> > SELinux patch could be completely harebrained, etc...
> > My goal at this point is to get feedback at a macro level, e.g. is the core concept
> > viable/acceptable, are there objection to hooking mprotect(), etc...
> > 
> > Andy and Cedric, hopefully this aligns with your general expectations based on our last
> > discussion.
> 
> I couldn't understand the real intentions of ALLOW_* flags until I saw them
> in code. I have to say C is more expressive than English in that regard :)
> 
> Generally I agree with your direction but think ALLOW_* flags are completely
> internal to LSM because they can be both produced and consumed inside an LSM
> module. So spilling them into SGX driver and also user mode code makes the
> solution ugly and in some cases impractical because not every enclave host
> process has a priori knowledge on whether or not an enclave page would be
> EMODPE'd at runtime.

In this case, the host process should tag *all* pages it *might* convert
to executable as ALLOW_EXEC.  LSMs can (and should/will) be written in
such a way that denying ALLOW_EXEC is fatal to the enclave if and only if
the enclave actually attempts mprotect(PROT_EXEC).

Take the SELinux path for example.  The only scenario in which PROT_WRITE
is cleared from @allowed_prot is if the page *starts* with PROT_EXEC.
If PROT_EXEC is denied on a page that starts RW, e.g. an EAUG'd page,
then PROT_EXEC will be cleared from @allowed_prot.

As Stephen pointed out, auditing the denials on @allowed_prot means the
log will contain false positives of a sort.  But this is more of a noise
issue than true false positives.  E.g. there are three possible outcomes
for the enclave.

  - The enclave does not do EMODPE[PROT_EXEC] in any scenario, ever.
    Requesting ALLOW_EXEC is either a straightforward a userspace bug or
    a poorly written generic enclave loader.

  - The enclave conditionally performs EMODPE[PROT_EXEC].  In this case
    the denial is a true false positive.
  
  - The enclave does EMODPE[PROT_EXEC] and its host userspace then fails
    on mprotect(PROT_EXEC), i.e. the LSM denial is working as intended.
    The audit log will be noisy, but viewed as a whole the denials aren't
    false positives.

The potential for noisy audit logs and/or false positives is unfortunate,
but it's (by far) the lesser of many evils.

> Theoretically speaking, what you really need is a per page flag (let's name
> it WRITTEN?) indicating whether a page has ever been written to (or more
> precisely, granted PROT_WRITE), which will be used to decide whether to grant
> PROT_EXEC when requested in future. Given the fact that all mprotect() goes
> through LSM and mmap() is limited to PROT_NONE, it's easy for LSM to capture
> that flag by itself instead of asking user mode code to provide it.
>
> That said, here is the summary of what I think is a better approach.
> * In hook security_file_alloc(), if @file is an enclave, allocate some data
>   structure to store for every page, the WRITTEN flag as described above.
>   WRITTEN is cleared initially for all pages.

This would effectively require *every* LSM to duplicate the SGX driver's
functionality, e.g. track per-page metadata, implement locking to prevent
races between multiple mm structs, etc...

>   Open: Given a file of type struct file *, how to tell if it is an enclave (i.e. /dev/sgx/enclave)?
> * In hook security_mmap_file(), if @file is an enclave, make sure @prot can
>   only be PROT_NONE. This is to force all protection changes to go through
>   security_file_mprotect().
> * In the newly introduced hook security_enclave_load(), set WRITTEN for pages
>   that are requested PROT_WRITE.

How would an LSM associate a page with a specific enclave?  vma->vm_file
will point always point at /dev/sgx/enclave.  vma->vm_mm is useless
because we're allowing multiple processes to map a single enclave, not to
mention that by mm would require holding a reference to the mm.

> * In hook security_file_mprotect(), if @vma->vm_file is an enclave, look up
>   and use WRITTEN flags for all pages within @vma, along with other global
>   flags (e.g. PROCESS__EXECMEM/FILE__EXECMOD in the case of SELinux) to decide
>   on allowing/rejecting @prot.

vma->vm_file will always be /dev/sgx/enclave at this point, which means
LSMs don't have the necessary anchor back to the source file, e.g. to
enforce FILE__EXECUTE.  The noexec file system case is also unaddressed.

> * In hook security_file_free(), if @file is an  enclave, free storage
>   allocated for WRITTEN flags.
