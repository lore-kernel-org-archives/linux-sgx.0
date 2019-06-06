Return-Path: <SRS0=qw+Y=UF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8405C28CC5
	for <linux-sgx@archiver.kernel.org>; Thu,  6 Jun 2019 02:11:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A85FC2089E
	for <linux-sgx@archiver.kernel.org>; Thu,  6 Jun 2019 02:11:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726608AbfFFCLu (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 5 Jun 2019 22:11:50 -0400
Received: from mga17.intel.com ([192.55.52.151]:61631 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726541AbfFFCLu (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 5 Jun 2019 22:11:50 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Jun 2019 19:11:49 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.36])
  by orsmga004.jf.intel.com with ESMTP; 05 Jun 2019 19:11:49 -0700
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
Subject: [RFC PATCH v2 0/5] security: x86/sgx: SGX vs. LSM
Date:   Wed,  5 Jun 2019 19:11:40 -0700
Message-Id: <20190606021145.12604-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

This series is the result of a rather absurd amount of discussion over
how to get SGX to play nice with LSM policies, without having to resort
to evil shenanigans or put undue burden on userspace.  Discussions are
still ongoing, e.g. folks are exploring alternatives to changing the
proposed SGX UAPI, but I wanted to get this updated version of the code
posted to show a fairly minimal implemenation(from a kernel perspective),
e.g. the diff stats aren't too scary, especially considering 50% of the
added lines are comments.

This series is a delta to Jarkko's ongoing SGX series and applies on
Jarkko's current master at https://github.com/jsakkine-intel/linux-sgx.git:

  dfc89a83b5bc ("docs: x86/sgx: Document the enclave API")

The basic gist of the approach is to track an enclave's page protections
separately from any vmas that map the page, and separate from the hardware
enforced protections.  The SGX UAPI is modified to require userspace to
explicitly define the protections for each enclave page, i.e. the ioctl
to add pages to an enclave is extended to take PROT_{READ,WRITE,EXEC}
flags.

An enclave page's protections are the maximal protections that userspace
can use to map the page, e.g. mprotect() and mmap() are rejected if the
protections for the vma would be more permissible than those of the
associated enclave page.

Tracking protections for an enclave page (in additional to vmas) allows
SGX to invoke LSM upcalls while the enclave is being built.  This is
critical to enabling LSMs to implement policies for enclave pages that
are functionally equivalent to existing policies for normal pages.

v1: https://lkml.kernel.org/r/20190531233159.30992-1-sean.j.christopherson@intel.com

v2:
  - Dropped the patch(es) to extend the SGX UAPI to allow adding multiple
    enclave pages in a single syscall [Jarkko].

  - Reject ioctl() immediately on LSM denial [Stephen].

  - Rework SELinux code to avoid checking EXEMEM multiple times [Stephen].

  - Adding missing equivalents to existing selinux_file_protect() checks
    [Stephen].

  - Hold mmap_sem across copy_to_user() to prevent a TOCTOU race when
    checking the source vma [Stephen].

  - Stubify security_enclave_load() if !CONFIG_SECURITY [Stephen].

  - Make flags a 32-bit field [Andy].

  - Don't validate the SECINFO protection flags against the enclave
    page's protection flags [Andy].

  - Rename mprotect() hook to may_mprotect() [Andy].

  - Test 'vma->vm_flags & VM_MAYEXEC' instead of manually checking for
    a noexec path [Jarkko].

  - Drop the SGX defined flags (use PROT_*) [Jarkko].

  - Improve comments and changelogs [Jarkko].

Sean Christopherson (5):
  mm: Introduce vm_ops->may_mprotect()
  x86/sgx: Require userspace to define enclave pages' protection bits
  x86/sgx: Enforce noexec filesystem restriction for enclaves
  LSM: x86/sgx: Introduce ->enclave_load() hook for Intel SGX
  security/selinux: Add enclave_load() implementation

 arch/x86/include/uapi/asm/sgx.h        |  2 +
 arch/x86/kernel/cpu/sgx/driver/ioctl.c | 57 ++++++++++++++++++---
 arch/x86/kernel/cpu/sgx/driver/main.c  |  5 ++
 arch/x86/kernel/cpu/sgx/encl.c         | 53 ++++++++++++++++++++
 arch/x86/kernel/cpu/sgx/encl.h         |  4 ++
 include/linux/lsm_hooks.h              | 13 +++++
 include/linux/mm.h                     |  2 +
 include/linux/security.h               | 12 +++++
 mm/mprotect.c                          | 15 ++++--
 security/security.c                    |  7 +++
 security/selinux/hooks.c               | 69 ++++++++++++++++++++++++++
 11 files changed, 228 insertions(+), 11 deletions(-)

-- 
2.21.0

