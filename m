Return-Path: <SRS0=nxNq=UC=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A19BEC28CC6
	for <linux-sgx@archiver.kernel.org>; Mon,  3 Jun 2019 18:31:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8336C26D93
	for <linux-sgx@archiver.kernel.org>; Mon,  3 Jun 2019 18:31:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbfFCSa7 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 3 Jun 2019 14:30:59 -0400
Received: from mga11.intel.com ([192.55.52.93]:52844 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726055AbfFCSa7 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 3 Jun 2019 14:30:59 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Jun 2019 11:30:56 -0700
X-ExtLoop1: 1
Received: from orsmsx104.amr.corp.intel.com ([10.22.225.131])
  by fmsmga006.fm.intel.com with ESMTP; 03 Jun 2019 11:30:55 -0700
Received: from orsmsx121.amr.corp.intel.com (10.22.225.226) by
 ORSMSX104.amr.corp.intel.com (10.22.225.131) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Mon, 3 Jun 2019 11:30:55 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.165]) by
 ORSMSX121.amr.corp.intel.com ([169.254.10.64]) with mapi id 14.03.0415.000;
 Mon, 3 Jun 2019 11:30:55 -0700
From:   "Xing, Cedric" <cedric.xing@intel.com>
To:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>
CC:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
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
        "Linus Torvalds" <torvalds@linux-foundation.org>,
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
Subject: RE: [RFC PATCH 0/9] security: x86/sgx: SGX vs. LSM
Thread-Topic: [RFC PATCH 0/9] security: x86/sgx: SGX vs. LSM
Thread-Index: AQHVGAkeu//pWDttTk+JsIicrUDwLaaG/FIQgAOo7oD//5fa8A==
Date:   Mon, 3 Jun 2019 18:30:54 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F654ED042@ORSMSX116.amr.corp.intel.com>
References: <20190531233159.30992-1-sean.j.christopherson@intel.com>
 <960B34DE67B9E140824F1DCDEC400C0F654EC5FD@ORSMSX116.amr.corp.intel.com>
 <20190603171549.GE13384@linux.intel.com>
In-Reply-To: <20190603171549.GE13384@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYWFjMzI5YmEtNDY0My00MGEzLWFjZjktMjAyODQwYmJjZGFmIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiME9ubWtHN2FDV0pWS2NKKzVKaGpJYTUzVE5ySG5tSlhtUFVsKzl5YWZ5dFVaMWxUMWtaR2RSMktPVGdEVkh1ZSJ9
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

> From: Christopherson, Sean J
> Sent: Monday, June 03, 2019 10:16 AM
> 
> On Sun, Jun 02, 2019 at 12:29:35AM -0700, Xing, Cedric wrote:
> > Hi Sean,
> >
> > Generally I agree with your direction but think ALLOW_* flags are
> > completely internal to LSM because they can be both produced and
> > consumed inside an LSM module. So spilling them into SGX driver and
> > also user mode code makes the solution ugly and in some cases
> > impractical because not every enclave host process has a priori
> > knowledge on whether or not an enclave page would be EMODPE'd at
> runtime.
> 
> In this case, the host process should tag *all* pages it *might* convert
> to executable as ALLOW_EXEC.  LSMs can (and should/will) be written in
> such a way that denying ALLOW_EXEC is fatal to the enclave if and only
> if the enclave actually attempts mprotect(PROT_EXEC).

What if those pages contain self-modifying code but the host doesn't know ahead of time? Would it require ALLOW_WRITE|ALLOW_EXEC at EADD? Then would it prevent those pages to start with PROT_EXEC?

Anyway, my point is that it is unnecessary even if it works.

> 
> Take the SELinux path for example.  The only scenario in which
> PROT_WRITE is cleared from @allowed_prot is if the page *starts* with
> PROT_EXEC.
> If PROT_EXEC is denied on a page that starts RW, e.g. an EAUG'd page,
> then PROT_EXEC will be cleared from @allowed_prot.
> 
> As Stephen pointed out, auditing the denials on @allowed_prot means the
> log will contain false positives of a sort.  But this is more of a noise
> issue than true false positives.  E.g. there are three possible outcomes
> for the enclave.
> 
>   - The enclave does not do EMODPE[PROT_EXEC] in any scenario, ever.
>     Requesting ALLOW_EXEC is either a straightforward a userspace bug or
>     a poorly written generic enclave loader.
> 
>   - The enclave conditionally performs EMODPE[PROT_EXEC].  In this case
>     the denial is a true false positive.
> 
>   - The enclave does EMODPE[PROT_EXEC] and its host userspace then fails
>     on mprotect(PROT_EXEC), i.e. the LSM denial is working as intended.
>     The audit log will be noisy, but viewed as a whole the denials
> aren't
>     false positives.

What I was talking about was EMODPE[PROT_WRITE] on an RX page.

> 
> The potential for noisy audit logs and/or false positives is unfortunate,
> but it's (by far) the lesser of many evils.
> 
> > Theoretically speaking, what you really need is a per page flag (let's
> > name it WRITTEN?) indicating whether a page has ever been written to
> > (or more precisely, granted PROT_WRITE), which will be used to decide
> > whether to grant PROT_EXEC when requested in future. Given the fact
> > that all mprotect() goes through LSM and mmap() is limited to
> > PROT_NONE, it's easy for LSM to capture that flag by itself instead of
> asking user mode code to provide it.
> >
> > That said, here is the summary of what I think is a better approach.
> > * In hook security_file_alloc(), if @file is an enclave, allocate some
> data
> >   structure to store for every page, the WRITTEN flag as described
> above.
> >   WRITTEN is cleared initially for all pages.
> 
> This would effectively require *every* LSM to duplicate the SGX driver's
> functionality, e.g. track per-page metadata, implement locking to
> prevent races between multiple mm structs, etc...

Architecturally we shouldn't dictate how LSM makes decisions. ALLOW_* are no difference than PROCESS__* or FILE__* flags, which are just artifacts to assist particular LSMs in decision making. They are never considered part of the LSM interface, even if other LSMs than SELinux may adopt the same/similar approach.

If code duplication is what you are worrying about, you can put them in a library, or implement/export them in some new file (maybe security/enclave.c?) as utility functions. But spilling them into user mode is what I think is unacceptable.

> 
> >   Open: Given a file of type struct file *, how to tell if it is an
> enclave (i.e. /dev/sgx/enclave)?
> > * In hook security_mmap_file(), if @file is an enclave, make sure
> @prot can
> >   only be PROT_NONE. This is to force all protection changes to go
> through
> >   security_file_mprotect().
> > * In the newly introduced hook security_enclave_load(), set WRITTEN
> for pages
> >   that are requested PROT_WRITE.
> 
> How would an LSM associate a page with a specific enclave?  vma->vm_file
> will point always point at /dev/sgx/enclave.  vma->vm_mm is useless
> because we're allowing multiple processes to map a single enclave, not
> to mention that by mm would require holding a reference to the mm.

Each open("/dev/sgx/enclave") syscall creates a *new* instance of struct file to uniquely identify one enclave instance. What I mean is @vma->vm_file, not @vma->vm_file->f_path or @vma->vm_file->f_inode.

> 
> > * In hook security_file_mprotect(), if @vma->vm_file is an enclave,
> look up
> >   and use WRITTEN flags for all pages within @vma, along with other
> global
> >   flags (e.g. PROCESS__EXECMEM/FILE__EXECMOD in the case of SELinux)
> to decide
> >   on allowing/rejecting @prot.
> 
> vma->vm_file will always be /dev/sgx/enclave at this point, which means
> LSMs don't have the necessary anchor back to the source file, e.g. to
> enforce FILE__EXECUTE.  The noexec file system case is also unaddressed.

vma->vm_file identifies an enclave instance uniquely. FILE__EXECUTE is checked by security_enclave_load() using @source_vma->vm_file. Once a page has been EADD'ed, whether to allow RW->RX depends on .sigstruct file (more precisely, the file backing SIGSTRUCT), whose FILE__* attributes could be cached in vma->vm_file->f_security by security_enclave_init().
 
The noexec case should be addressed in IOC_ADD_PAGES by testing @source_vma->vm_flags & VM_MAYEXEC.

> 
> > * In hook security_file_free(), if @file is an  enclave, free storage
> >   allocated for WRITTEN flags.
