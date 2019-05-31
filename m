Return-Path: <SRS0=g3U3=T7=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 886DFC04AB6
	for <linux-sgx@archiver.kernel.org>; Fri, 31 May 2019 23:33:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A9C8259B8
	for <linux-sgx@archiver.kernel.org>; Fri, 31 May 2019 23:33:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbfEaXcd (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 31 May 2019 19:32:33 -0400
Received: from mga07.intel.com ([134.134.136.100]:59345 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726735AbfEaXcc (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 31 May 2019 19:32:32 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 May 2019 16:32:30 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.36])
  by orsmga008.jf.intel.com with ESMTP; 31 May 2019 16:32:30 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Cedric Xing <cedric.xing@intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>, selinux@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        linux-sgx@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, nhorman@redhat.com,
        npmccallum@redhat.com, Serge Ayoun <serge.ayoun@intel.com>,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Haitao Huang <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Kai Svahn <kai.svahn@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        Kai Huang <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>,
        William Roberts <william.c.roberts@intel.com>,
        Philip Tricca <philip.b.tricca@intel.com>
Subject: [RFC PATCH 0/9] security: x86/sgx: SGX vs. LSM
Date:   Fri, 31 May 2019 16:31:50 -0700
Message-Id: <20190531233159.30992-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

This series is the result of a rather absurd amount of discussion over
how to get SGX to play nice with LSM policies, without having to resort
to evil shenanigans or put undue burden on userspace.  The discussion
definitely wandered into completely insane territory at times, but I
think/hope we ended up with something reasonable.

The basic gist of the approach is to require userspace to declare what
protections are maximally allowed for any given page, e.g. add a flags
field for loading enclave pages that takes ALLOW_{READ,WRITE,EXEC}.  LSMs
can then adjust the allowed protections, e.g. clear ALLOW_EXEC to prevent
ever mapping the page with PROT_EXEC.  SGX enforces the allowed perms
via a new mprotect() vm_ops hook, e.g. like regular mprotect() uses
MAY_{READ,WRITE,EXEC}.

ALLOW_EXEC is used to deny hings like loading an enclave from a noexec
file system or from a file without EXECUTE permissions, e.g. without
the ALLOW_EXEC concept, on SGX2 hardware (regardless of kernel support)
userspace could EADD from a noexec file using read-only permissions,
and later use mprotect() and ENCLU[EMODPE] to gain execute permissions.

ALLOW_WRITE is used in conjuction with ALLOW_EXEC to enforce SELinux's
EXECMOD (or EXECMEM).

This is very much an RFC series.  It's only compile tested, likely has
obvious bugs, the SELinux patch could be completely harebrained, etc...
My goal at this point is to get feedback at a macro level, e.g. is the
core concept viable/acceptable, are there objection to hooking
mprotect(), etc...

Andy and Cedric, hopefully this aligns with your general expectations
based on our last discussion.

Lastly, I added a patch to allow userspace to add multiple pages in a
single ioctl().  It's obviously not directly related to the security
stuff, but the idea tangentially came up during earlier discussions and
it's something I think the UAPI should provide (it's a tiny change).
Since I was modifying the UAPI anyways, I threw it in.

Sean Christopherson (9):
  x86/sgx: Remove unused local variable in sgx_encl_release()
  x86/sgx: Do not naturally align MAP_FIXED address
  x86/sgx: Allow userspace to add multiple pages in single ioctl()
  mm: Introduce vm_ops->mprotect()
  x86/sgx: Restrict mapping without an enclave page to PROT_NONE
  x86/sgx: Require userspace to provide allowed prots to ADD_PAGES
  x86/sgx: Enforce noexec filesystem restriction for enclaves
  LSM: x86/sgx: Introduce ->enclave_load() hook for Intel SGX
  security/selinux: Add enclave_load() implementation

 arch/x86/include/uapi/asm/sgx.h        |  30 ++++--
 arch/x86/kernel/cpu/sgx/driver/ioctl.c | 143 +++++++++++++++++--------
 arch/x86/kernel/cpu/sgx/driver/main.c  |  13 ++-
 arch/x86/kernel/cpu/sgx/encl.c         |  31 +++++-
 arch/x86/kernel/cpu/sgx/encl.h         |   4 +
 include/linux/lsm_hooks.h              |  16 +++
 include/linux/mm.h                     |   2 +
 include/linux/security.h               |   2 +
 mm/mprotect.c                          |  15 ++-
 security/security.c                    |   8 ++
 security/selinux/hooks.c               |  85 +++++++++++++++
 11 files changed, 290 insertions(+), 59 deletions(-)

-- 
2.21.0

