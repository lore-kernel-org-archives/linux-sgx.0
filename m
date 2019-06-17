Return-Path: <SRS0=httf=UQ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA8BAC31E5B
	for <linux-sgx@archiver.kernel.org>; Mon, 17 Jun 2019 22:24:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C84232082C
	for <linux-sgx@archiver.kernel.org>; Mon, 17 Jun 2019 22:24:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728101AbfFQWYs (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 17 Jun 2019 18:24:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:43046 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726593AbfFQWYs (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 17 Jun 2019 18:24:48 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jun 2019 15:24:47 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.36])
  by orsmga005.jf.intel.com with ESMTP; 17 Jun 2019 15:24:47 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>,
        Stephen Smalley <sds@tycho.nsa.gov>
Subject: [RFC PATCH v3 00/12] security: x86/sgx: SGX vs. LSM, round 3
Date:   Mon, 17 Jun 2019 15:24:26 -0700
Message-Id: <20190617222438.2080-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

My original plan was for my next RFC to be an implementation of Andy's
proposed "dynamic tracking" model.  I actually finished the tracking
portion, but was completely flummoxed by the auditing[1].  Since Cedric's
RFC is essentially a variation of the dynamic tracking model, it too has
the same auditing complexities.  End result, I ended back at the "make
userspace state its intentions" approach.

Except for patch 12 (see below), the SGX changes have been fully tested,
including updating the kernel's selftest as well as my own fork of (an old
version of) Intel's SDK to use the new UAPI.  The LSM changes have been
smoke tested, but I haven't actually configured AppArmor or SELinux to
verify the permissions work as intended.

Patches 1-3 are bug fixes that should go into v21 regardless of what we
end up doing for LSM support.  They're included here as the actual LSM
RFC patches are essentially untestable without them.

Patches 4-11 are the meat of the RFC.

Patch 12 is purely to show how we might implement SGX2 support.  It's not
intended to be included in v21.


This series is a delta to Jarkko's ongoing SGX series and applies on
Jarkko's current master at https://github.com/jsakkine-intel/linux-sgx.git:

  4cc5d411db1b ("docs: x86/sgx: Document the enclave API")

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


[1] https://lkml.kernel.org/r/20190614003759.GE18385@linux.intel.com

v1: https://lkml.kernel.org/r/20190531233159.30992-1-sean.j.christopherson@intel.com

v2: https://lkml.kernel.org/r/20190606021145.12604-1-sean.j.christopherson@intel.com

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

v3:
  - Clear VM_MAY* flags instead of using .may_mprotect() to enforce
    maximal enclave page protections.

  - Update the SGX selftest to work with the new API.

  - Rewrite SELinux code to use SGX specific permissions, with the goal
    of addressing Andy's feedback regarding what people will actually
    care about when it comes to SGX, e.g. add permissions for restricing
    unmeasured code and stop trying to infer permissions from the source
    of each enclave page.

  - Add a (very minimal) AppArmor patch.

  - Show line of sight to SGX2 support.

  - Rebased to Jarkko's latest code base.

Sean Christopherson (12):
  x86/sgx: Add mm to enclave at mmap()
  x86/sgx: Do not naturally align MAP_FIXED address
  selftests: x86/sgx: Mark the enclave loader as not needing an exec
    stack
  x86/sgx: Require userspace to define enclave pages' protection bits
  x86/sgx: Enforce noexec filesystem restriction for enclaves
  mm: Introduce vm_ops->may_mprotect()
  LSM: x86/sgx: Introduce ->enclave_map() hook for Intel SGX
  security/selinux: Require SGX_EXECMEM to map enclave page WX
  LSM: x86/sgx: Introduce ->enclave_load() hook for Intel SGX
  security/selinux: Add enclave_load() implementation
  security/apparmor: Add enclave_load() implementation
  LSM: x86/sgx: Show line of sight to LSM support SGX2's EAUG

 arch/x86/include/uapi/asm/sgx.h          |  5 +-
 arch/x86/kernel/cpu/sgx/driver/ioctl.c   | 69 +++++++++++------
 arch/x86/kernel/cpu/sgx/driver/main.c    | 94 +++++++++++++++++++++++-
 arch/x86/kernel/cpu/sgx/encl.c           | 81 ++++++++++++--------
 arch/x86/kernel/cpu/sgx/encl.h           |  7 +-
 include/linux/lsm_hooks.h                | 20 +++++
 include/linux/mm.h                       |  2 +
 include/linux/security.h                 | 18 +++++
 mm/mprotect.c                            | 15 +++-
 security/apparmor/include/audit.h        |  2 +
 security/apparmor/lsm.c                  | 14 ++++
 security/security.c                      | 12 +++
 security/selinux/hooks.c                 | 72 ++++++++++++++++++
 security/selinux/include/classmap.h      |  6 +-
 tools/testing/selftests/x86/sgx/Makefile |  2 +-
 tools/testing/selftests/x86/sgx/main.c   | 32 +++++++-
 16 files changed, 384 insertions(+), 67 deletions(-)

-- 
2.21.0

