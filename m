Return-Path: <SRS0=bY9v=NN=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2772C32789
	for <linux-sgx@archiver.kernel.org>; Fri,  2 Nov 2018 23:13:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8668B20657
	for <linux-sgx@archiver.kernel.org>; Fri,  2 Nov 2018 23:13:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8668B20657
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbeKCIWv (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 3 Nov 2018 04:22:51 -0400
Received: from mga07.intel.com ([134.134.136.100]:26547 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726705AbeKCIWv (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 3 Nov 2018 04:22:51 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Nov 2018 16:13:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.54,457,1534834800"; 
   d="scan'208";a="88208946"
Received: from btyborox-mobl.ger.corp.intel.com (HELO localhost) ([10.249.254.138])
  by orsmga006.jf.intel.com with ESMTP; 02 Nov 2018 16:13:26 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     x86@kernel.org, platform-driver-x86@vger.kernel.org,
        linux-sgx@vger.kernel.org
Cc:     dave.hansen@intel.com, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        mark.shanahan@intel.com, andriy.shevchenko@linux.intel.com,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@alien8.de>,
        Borislav Petkov <bp@suse.de>,
        "David S. Miller" <davem@davemloft.net>,
        David Wang <davidwang@zhaoxin.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>,
        Jia Zhang <qianyue.zj@alibaba-inc.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Levin, Alexander (Sasha Levin)" <alexander.levin@verizon.com>,
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        linux-kernel@vger.kernel.org (open list),
        Matt Turner <mattst88@gmail.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH v15 00/23] Intel SGX1
Date:   Sat,  3 Nov 2018 01:10:59 +0200
Message-Id: <20181102231320.29164-1-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org
Message-ID: <20181102231059.IyFTH5C4-KqelTZXUI22OlneA6Jl8q6qkeUVMdiRCtk@z>

Intel(R) SGX is a set of CPU instructions that can be used by applications
to set aside private regions of code and data. The code outside the enclave
is disallowed to access the memory inside the enclave by the CPU access
control.  In a way you can think that SGX provides inverted sandbox. It
protects the application from a malicious host.

There is a new hardware unit in the processor called Memory Encryption
Engine (MEE) starting from the Skylake microacrhitecture. BIOS can define
one or many MEE regions that can hold enclave data by configuring them with
PRMRR registers.

The MEE automatically encrypts the data leaving the processor package to
the MEE regions. The data is encrypted using a random key whose life-time
is exactly one power cycle.

The current implementation requires that the firmware sets
IA32_SGXLEPUBKEYHASH* MSRs as writable so that ultimately the kernel can
decide what enclaves it wants run. The implementation does not create
any bottlenecks to support read-only MSRs later on.

You can tell if your CPU supports SGX by looking into /proc/cpuinfo:

	cat /proc/cpuinfo  | grep sgx

v15:
* Split into more digestable size patches.
* Lots of small fixes and clean ups.
* Signal a "plain" SIGSEGV on an EPCM violation.

v14:
* Change the comment about X86_FEATURE_SGX_LC from “SGX launch
  configuration” to “SGX launch control”.
* Move the SGX-related CPU feature flags as part of the Linux defined
  virtual leaf 8.
* Add SGX_ prefix to the constants defining the ENCLS leaf functions.
* Use GENMASK*() and BIT*() in sgx_arch.h instead of raw hex numbers.
* Refine the long description for CONFIG_INTEL_SGX_CORE.
* Do not use pr_*_ratelimited()  in the driver. The use of the rate limited
  versions is legacy cruft from the prototyping phase.
* Detect sleep with SGX_INVALID_EINIT_TOKEN instead of counting power
  cycles.
* Manually prefix with “sgx:” in the core SGX code instead of redefining
  pr_fmt.
* Report if IA32_SGXLEPUBKEYHASHx MSRs are not writable in the driver
  instead of core because it is a driver requirement.
* Change prompt to bool in the entry for CONFIG_INTEL_SGX_CORE because the
  default is ‘n’.
* Rename struct sgx_epc_bank as struct sgx_epc_section in order to match
  the SDM.
* Allocate struct sgx_epc_page instances one at a time.
* Use “__iomem void *” pointers for the mapped EPC memory consistently.
* Retry once on SGX_INVALID_TOKEN in sgx_einit() instead of counting power
  cycles.
* Call enclave swapping operations directly from the driver instead of
  calling them .indirectly through struct sgx_epc_page_ops because indirect
  calls are not required yet as the patch set does not contain the KVM
  support.
* Added special signal SEGV_SGXERR to notify about SGX EPCM violation
  errors.

v13:
* Always use SGX_CPUID constant instead of a hardcoded value.
* Simplified and documented the macros and functions for ENCLS leaves.
* Enable sgx_free_page() to free active enclave pages on demand
  in order to allow sgx_invalidate() to delete enclave pages.
  It no longer performs EREMOVE if a page is in the process of
  being reclaimed.
* Use PM notifier per enclave so that we don't have to traverse
  the global list of active EPC pages to find enclaves.
* Removed unused SGX_LE_ROLLBACK constant from uapi/asm/sgx.h
* Always use ioremap() to map EPC banks as we only support 64-bit kernel.
* Invalidate IA32_SGXLEPUBKEYHASH cache used by sgx_einit() when going
  to sleep.

v12:
* Split to more narrow scoped commits in order to ease the review process and
  use co-developed-by tag for co-authors of commits instead of listing them in
  the source files.
* Removed cruft EXPORT_SYMBOL() declarations and converted to static variables.
* Removed in-kernel LE i.e. this version of the SGX software stack only
  supports unlocked IA32_SGXLEPUBKEYHASHx MSRs.
* Refined documentation on launching enclaves, swapping and enclave
  construction.
* Refined sgx_arch.h to include alignment information for every struct that
  requires it and removed structs that are not needed without an LE.
* Got rid of SGX_CPUID.
* SGX detection now prints log messages about firmware configuration issues.

v11:
* Polished ENCLS wrappers with refined exception handling.
* ksgxswapd was not stopped (regression in v5) in
  sgx_page_cache_teardown(), which causes a leaked kthread after driver
  deinitialization.
* Shutdown sgx_le_proxy when going to suspend because its EPC pages will be
  invalidated when resuming, which will cause it not function properly
  anymore.
* Set EINITTOKEN.VALID to zero for a token that is passed when
  SGXLEPUBKEYHASH matches MRSIGNER as alloc_page() does not give a zero
  page.
* Fixed the check in sgx_edbgrd() for a TCS page. Allowed to read offsets
  around the flags field, which causes a #GP. Only flags read is readable.
* On read access memcpy() call inside sgx_vma_access() had src and dest
  parameters in wrong order.
* The build issue with CONFIG_KASAN is now fixed. Added undefined symbols
  to LE even if “KASAN_SANITIZE := false” was set in the makefile. 
* Fixed a regression in the #PF handler. If a page has
  SGX_ENCL_PAGE_RESERVED flag the #PF handler should unconditionally fail.
  It did not, which caused weird races when trying to change other parts of
  swapping code.
* EPC management has been refactored to a flat LRU cache and moved to
  arch/x86. The swapper thread reads a cluster of EPC pages and swaps all
  of them. It can now swap from multiple enclaves in the same round.
* For the sake of consistency with SGX_IOC_ENCLAVE_ADD_PAGE, return -EINVAL
  when an enclave is already initialized or dead instead of zero.

v10:
* Cleaned up anon inode based IPC between the ring-0 and ring-3 parts
  of the driver.
* Unset the reserved flag from an enclave page if EDBGRD/WR fails
  (regression in v6).
* Close the anon inode when LE is stopped (regression in v9).
* Update the documentation with a more detailed description of SGX.

v9:
* Replaced kernel-LE IPC based on pipes with an anonymous inode.
  The driver does not require anymore new exports.

v8:
* Check that public key MSRs match the LE public key hash in the
  driver initialization when the MSRs are read-only.
* Fix the race in VA slot allocation by checking the fullness
  immediately after succeesful allocation.
* Fix the race in hash mrsigner calculation between the launch
  enclave and user enclaves by having a separate lock for hash
  calculation.

v7:
* Fixed offset calculation in sgx_edbgr/wr(). Address was masked with PAGE_MASK
  when it should have been masked with ~PAGE_MASK.
* Fixed a memory leak in sgx_ioc_enclave_create().
* Simplified swapping code by using a pointer array for a cluster
  instead of a linked list.
* Squeezed struct sgx_encl_page to 32 bytes.
* Fixed deferencing of an RSA key on OpenSSL 1.1.0.
* Modified TC's CMAC to use kernel AES-NI. Restructured the code
  a bit in order to better align with kernel conventions.

v6:
* Fixed semaphore underrun when accessing /dev/sgx from the launch enclave.
* In sgx_encl_create() s/IS_ERR(secs)/IS_ERR(encl)/.
* Removed virtualization chapter from the documentation.
* Changed the default filename for the signing key as signing_key.pem.
* Reworked EPC management in a way that instead of a linked list of
  struct sgx_epc_page instances there is an array of integers that
  encodes address and bank of an EPC page (the same data as 'pa' field
  earlier). The locking has been moved to the EPC bank level instead
  of a global lock.
* Relaxed locking requirements for EPC management. EPC pages can be
  released back to the EPC bank concurrently.
* Cleaned up ptrace() code.
* Refined commit messages for new architectural constants.
* Sorted includes in every source file.
* Sorted local variable declarations according to the line length in
  every function.
* Style fixes based on Darren's comments to sgx_le.c.

v5:
* Described IPC between the Launch Enclave and kernel in the commit messages.
* Fixed all relevant checkpatch.pl issues that I have forgot fix in earlier
  versions except those that exist in the imported TinyCrypt code.
* Fixed spelling mistakes in the documentation.
* Forgot to check the return value of sgx_drv_subsys_init().
* Encapsulated properly page cache init and teardown.
* Collect epc pages to a temp list in sgx_add_epc_bank
* Removed SGX_ENCLAVE_INIT_ARCH constant.

v4:
* Tied life-cycle of the sgx_le_proxy process to /dev/sgx.
* Removed __exit annotation from sgx_drv_subsys_exit().
* Fixed a leak of a backing page in sgx_process_add_page_req() in the
  case when vm_insert_pfn() fails.
* Removed unused symbol exports for sgx_page_cache.c.
* Updated sgx_alloc_page() to require encl parameter and documented the
  behavior (Sean Christopherson).
* Refactored a more lean API for sgx_encl_find() and documented the behavior.
* Moved #PF handler to sgx_fault.c.
* Replaced subsys_system_register() with plain bus_register().
* Retry EINIT 2nd time only if MSRs are not locked.

v3:
* Check that FEATURE_CONTROL_LOCKED and FEATURE_CONTROL_SGX_ENABLE are set.
* Return -ERESTARTSYS in __sgx_encl_add_page() when sgx_alloc_page() fails.
* Use unused bits in epc_page->pa to store the bank number.
* Removed #ifdef for WQ_NONREENTRANT.
* If mmu_notifier_register() fails with -EINTR, return -ERESTARTSYS.
* Added --remove-section=.got.plt to objcopy flags in order to prevent a
  dummy .got.plt, which will cause an inconsistent size for the LE.
* Documented sgx_encl_* functions.
* Added remark about AES implementation used inside the LE.
* Removed redundant sgx_sys_exit() from le/main.c.
* Fixed struct sgx_secinfo alignment from 128 to 64 bytes.
* Validate miscselect in sgx_encl_create().
* Fixed SSA frame size calculation to take the misc region into account.
* Implemented consistent exception handling to __encls() and __encls_ret().
* Implemented a proper device model in order to allow sysfs attributes
  and in-kernel API.
* Cleaned up various "find enclave" implementations to the unified
  sgx_encl_find().
* Validate that vm_pgoff is zero.
* Discard backing pages with shmem_truncate_range() after EADD.
* Added missing EEXTEND operations to LE signing and launch.
* Fixed SSA size for GPRS region from 168 to 184 bytes.
* Fixed the checks for TCS flags. Now DBGOPTIN is allowed.
* Check that TCS addresses are in ELRANGE and not just page aligned.
* Require kernel to be compiled with X64_64 and CPU_SUP_INTEL.
* Fixed an incorrect value for SGX_ATTR_DEBUG from 0x01 to 0x02.

v2:
* get_rand_uint32() changed the value of the pointer instead of value
  where it is pointing at.
* Launch enclave incorrectly used sigstruct attributes-field instead of
  enclave attributes-field.
* Removed unused struct sgx_add_page_req from sgx_ioctl.c
* Removed unused sgx_has_sgx2.
* Updated arch/x86/include/asm/sgx.h so that it provides stub
  implementations when sgx in not enabled.
* Removed cruft rdmsr-calls from sgx_set_pubkeyhash_msrs().
* return -ENOMEM in sgx_alloc_page() when VA pages consume too much space
* removed unused global sgx_nr_pids
* moved sgx_encl_release to sgx_encl.c
* return -ERESTARTSYS instead of -EINTR in sgx_encl_init()

Jarkko Sakkinen (12):
  x86/sgx: Update MAINTAINERS
  x86/sgx: Define SGX1 and SGX2 ENCLS leafs
  x86/sgx: Add ENCLS architectural error codes
  x86/sgx: Add SGX1 and SGX2 architectural data structures
  x86/sgx: Add definitions for SGX's CPUID leaf and variable sub-leafs
  x86/sgx: Add wrappers for ENCLS leaf functions
  x86/sgx: Add functions to allocate and free EPC pages
  platform/x86: Intel SGX driver
  platform/x86: sgx: Add swapping functionality to the Intel SGX driver
  x86/sgx: Add a simple swapper for the EPC memory manager
  platform/x86: ptrace() support for the SGX driver
  x86/sgx: Driver documentation

Kai Huang (2):
  x86/cpufeatures: Add Intel-defined SGX feature bit
  x86/cpufeatures: Add Intel-defined SGX_LC feature bit

Sean Christopherson (9):
  x86/cpufeatures: Add SGX sub-features (as Linux-defined bits)
  x86/msr: Add IA32_FEATURE_CONTROL.SGX_ENABLE definition
  x86/cpu/intel: Detect SGX support and update caps appropriately
  x86/mm: x86/sgx: Add new 'PF_SGX' page fault error code bit
  x86/mm: x86/sgx: Signal SIGSEGV for userspace #PFs w/ PF_SGX
  x86/msr: Add SGX Launch Control MSR definitions
  x86/cpu/intel: Clear SGX_LC capability if not enabled in
    FEATURE_CONTROL
  x86/sgx: Enumerate and track EPC sections
  x86/sgx: Add sgx_einit() for initializing enclaves

 Documentation/index.rst                       |   1 +
 Documentation/x86/intel_sgx.rst               | 185 ++++
 MAINTAINERS                                   |   7 +
 arch/x86/Kconfig                              |  18 +
 arch/x86/include/asm/cpufeatures.h            |  23 +-
 arch/x86/include/asm/msr-index.h              |   8 +
 arch/x86/include/asm/sgx.h                    | 326 ++++++
 arch/x86/include/asm/sgx_arch.h               | 400 +++++++
 arch/x86/include/asm/traps.h                  |   1 +
 arch/x86/include/uapi/asm/sgx.h               |  59 ++
 arch/x86/include/uapi/asm/sgx_errno.h         |  91 ++
 arch/x86/kernel/cpu/Makefile                  |   1 +
 arch/x86/kernel/cpu/intel.c                   |  29 +
 arch/x86/kernel/cpu/intel_sgx.c               | 479 +++++++++
 arch/x86/kernel/cpu/scattered.c               |   2 +
 arch/x86/mm/fault.c                           |  13 +
 drivers/platform/x86/Kconfig                  |   2 +
 drivers/platform/x86/Makefile                 |   1 +
 drivers/platform/x86/intel_sgx/Kconfig        |  20 +
 drivers/platform/x86/intel_sgx/Makefile       |  14 +
 drivers/platform/x86/intel_sgx/sgx.h          | 212 ++++
 drivers/platform/x86/intel_sgx/sgx_encl.c     | 977 ++++++++++++++++++
 .../platform/x86/intel_sgx/sgx_encl_page.c    | 178 ++++
 drivers/platform/x86/intel_sgx/sgx_fault.c    | 109 ++
 drivers/platform/x86/intel_sgx/sgx_ioctl.c    | 234 +++++
 drivers/platform/x86/intel_sgx/sgx_main.c     | 267 +++++
 drivers/platform/x86/intel_sgx/sgx_util.c     | 156 +++
 drivers/platform/x86/intel_sgx/sgx_vma.c      | 167 +++
 tools/arch/x86/include/asm/cpufeatures.h      |  21 +-
 29 files changed, 3989 insertions(+), 12 deletions(-)
 create mode 100644 Documentation/x86/intel_sgx.rst
 create mode 100644 arch/x86/include/asm/sgx.h
 create mode 100644 arch/x86/include/asm/sgx_arch.h
 create mode 100644 arch/x86/include/uapi/asm/sgx.h
 create mode 100644 arch/x86/include/uapi/asm/sgx_errno.h
 create mode 100644 arch/x86/kernel/cpu/intel_sgx.c
 create mode 100644 drivers/platform/x86/intel_sgx/Kconfig
 create mode 100644 drivers/platform/x86/intel_sgx/Makefile
 create mode 100644 drivers/platform/x86/intel_sgx/sgx.h
 create mode 100644 drivers/platform/x86/intel_sgx/sgx_encl.c
 create mode 100644 drivers/platform/x86/intel_sgx/sgx_encl_page.c
 create mode 100644 drivers/platform/x86/intel_sgx/sgx_fault.c
 create mode 100644 drivers/platform/x86/intel_sgx/sgx_ioctl.c
 create mode 100644 drivers/platform/x86/intel_sgx/sgx_main.c
 create mode 100644 drivers/platform/x86/intel_sgx/sgx_util.c
 create mode 100644 drivers/platform/x86/intel_sgx/sgx_vma.c

-- 
2.19.1

