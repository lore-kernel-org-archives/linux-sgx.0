Return-Path: <SRS0=X4GA=UB=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F143CC282DC
	for <linux-sgx@archiver.kernel.org>; Sun,  2 Jun 2019 07:29:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB0CC27825
	for <linux-sgx@archiver.kernel.org>; Sun,  2 Jun 2019 07:29:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbfFBH3i convert rfc822-to-8bit (ORCPT
        <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 2 Jun 2019 03:29:38 -0400
Received: from mga03.intel.com ([134.134.136.65]:8281 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725875AbfFBH3i (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 2 Jun 2019 03:29:38 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Jun 2019 00:29:36 -0700
X-ExtLoop1: 1
Received: from orsmsx109.amr.corp.intel.com ([10.22.240.7])
  by orsmga006.jf.intel.com with ESMTP; 02 Jun 2019 00:29:36 -0700
Received: from orsmsx151.amr.corp.intel.com (10.22.226.38) by
 ORSMSX109.amr.corp.intel.com (10.22.240.7) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Sun, 2 Jun 2019 00:29:36 -0700
Received: from orsmsx116.amr.corp.intel.com ([169.254.7.165]) by
 ORSMSX151.amr.corp.intel.com ([169.254.7.185]) with mapi id 14.03.0415.000;
 Sun, 2 Jun 2019 00:29:36 -0700
From:   "Xing, Cedric" <cedric.xing@intel.com>
To:     "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "Jarkko Sakkinen" <jarkko.sakkinen@linux.intel.com>
CC:     Andy Lutomirski <luto@kernel.org>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "Andy Shevchenko" <andriy.shevchenko@linux.intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>,
        "Roberts, William C" <william.c.roberts@intel.com>,
        "Tricca, Philip B" <philip.b.tricca@intel.com>
Subject: RE: [RFC PATCH 0/9] security: x86/sgx: SGX vs. LSM
Thread-Topic: [RFC PATCH 0/9] security: x86/sgx: SGX vs. LSM
Thread-Index: AQHVGAkeu//pWDttTk+JsIicrUDwLaaG/FIQ
Date:   Sun, 2 Jun 2019 07:29:35 +0000
Message-ID: <960B34DE67B9E140824F1DCDEC400C0F654EC5FD@ORSMSX116.amr.corp.intel.com>
References: <20190531233159.30992-1-sean.j.christopherson@intel.com>
In-Reply-To: <20190531233159.30992-1-sean.j.christopherson@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYjdhYTQ1OGQtNzlmZC00MzIzLTk0N2MtN2ZiNThhYmM5MWY3IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoicE5yRVZ6Vk55dHZGcHBTNmoyRE9Xd04rdWh5RU1qNlVUQ1pXaVd2TmVMbHRRZ0xMYjBSUXI2UEpqSjBBS1wvSjAifQ==
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

Hi Sean,

> From: Christopherson, Sean J
> Sent: Friday, May 31, 2019 4:32 PM
> 
> This series is the result of a rather absurd amount of discussion over how to get SGX to play
> nice with LSM policies, without having to resort to evil shenanigans or put undue burden on
> userspace.  The discussion definitely wandered into completely insane territory at times, but
> I think/hope we ended up with something reasonable.
> 
> The basic gist of the approach is to require userspace to declare what protections are
> maximally allowed for any given page, e.g. add a flags field for loading enclave pages that
> takes ALLOW_{READ,WRITE,EXEC}.  LSMs can then adjust the allowed protections, e.g. clear
> ALLOW_EXEC to prevent ever mapping the page with PROT_EXEC.  SGX enforces the allowed perms
> via a new mprotect() vm_ops hook, e.g. like regular mprotect() uses MAY_{READ,WRITE,EXEC}.
> 
> ALLOW_EXEC is used to deny hings like loading an enclave from a noexec file system or from a
> file without EXECUTE permissions, e.g. without the ALLOW_EXEC concept, on SGX2 hardware
> (regardless of kernel support) userspace could EADD from a noexec file using read-only
> permissions, and later use mprotect() and ENCLU[EMODPE] to gain execute permissions.
> 
> ALLOW_WRITE is used in conjuction with ALLOW_EXEC to enforce SELinux's EXECMOD (or EXECMEM).
> 
> This is very much an RFC series.  It's only compile tested, likely has obvious bugs, the
> SELinux patch could be completely harebrained, etc...
> My goal at this point is to get feedback at a macro level, e.g. is the core concept
> viable/acceptable, are there objection to hooking mprotect(), etc...
> 
> Andy and Cedric, hopefully this aligns with your general expectations based on our last
> discussion.

I couldn't understand the real intentions of ALLOW_* flags until I saw them in code. I have to say C is more expressive than English in that regard :)

Generally I agree with your direction but think ALLOW_* flags are completely internal to LSM because they can be both produced and consumed inside an LSM module. So spilling them into SGX driver and also user mode code makes the solution ugly and in some cases impractical because not every enclave host process has a priori knowledge on whether or not an enclave page would be EMODPE'd at runtime.

Theoretically speaking, what you really need is a per page flag (let's name it WRITTEN?) indicating whether a page has ever been written to (or more precisely, granted PROT_WRITE), which will be used to decide whether to grant PROT_EXEC when requested in future. Given the fact that all mprotect() goes through LSM and mmap() is limited to PROT_NONE, it's easy for LSM to capture that flag by itself instead of asking user mode code to provide it.

That said, here is the summary of what I think is a better approach.
* In hook security_file_alloc(), if @file is an enclave, allocate some data structure to store for every page, the WRITTEN flag as described above. WRITTEN is cleared initially for all pages.
  Open: Given a file of type struct file *, how to tell if it is an enclave (i.e. /dev/sgx/enclave)?
* In hook security_mmap_file(), if @file is an enclave, make sure @prot can only be PROT_NONE. This is to force all protection changes to go through security_file_mprotect().
* In the newly introduced hook security_enclave_load(), set WRITTEN for pages that are requested PROT_WRITE.
* In hook security_file_mprotect(), if @vma->vm_file is an enclave, look up and use WRITTEN flags for all pages within @vma, along with other global flags (e.g. PROCESS__EXECMEM/FILE__EXECMOD in the case of SELinux) to decide on allowing/rejecting @prot.
* In hook security_file_free(), if @file is an enclave, free storage allocated for WRITTEN flags. 

I'll try to make more detailed comments in my replies to individual patches sometime tomorrow.

> 
> Lastly, I added a patch to allow userspace to add multiple pages in a single ioctl().  It's
> obviously not directly related to the security stuff, but the idea tangentially came up during
> earlier discussions and it's something I think the UAPI should provide (it's a tiny change).
> Since I was modifying the UAPI anyways, I threw it in.
> 
> Sean Christopherson (9):
>   x86/sgx: Remove unused local variable in sgx_encl_release()
>   x86/sgx: Do not naturally align MAP_FIXED address
>   x86/sgx: Allow userspace to add multiple pages in single ioctl()
>   mm: Introduce vm_ops->mprotect()
>   x86/sgx: Restrict mapping without an enclave page to PROT_NONE
>   x86/sgx: Require userspace to provide allowed prots to ADD_PAGES
>   x86/sgx: Enforce noexec filesystem restriction for enclaves
>   LSM: x86/sgx: Introduce ->enclave_load() hook for Intel SGX
>   security/selinux: Add enclave_load() implementation
> 
>  arch/x86/include/uapi/asm/sgx.h        |  30 ++++--
>  arch/x86/kernel/cpu/sgx/driver/ioctl.c | 143 +++++++++++++++++--------
> arch/x86/kernel/cpu/sgx/driver/main.c  |  13 ++-
>  arch/x86/kernel/cpu/sgx/encl.c         |  31 +++++-
>  arch/x86/kernel/cpu/sgx/encl.h         |   4 +
>  include/linux/lsm_hooks.h              |  16 +++
>  include/linux/mm.h                     |   2 +
>  include/linux/security.h               |   2 +
>  mm/mprotect.c                          |  15 ++-
>  security/security.c                    |   8 ++
>  security/selinux/hooks.c               |  85 +++++++++++++++
>  11 files changed, 290 insertions(+), 59 deletions(-)
> 
> --
> 2.21.0

-Cedric
