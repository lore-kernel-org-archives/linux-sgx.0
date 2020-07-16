Return-Path: <SRS0=YHr7=A3=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BF7AC433E2
	for <linux-sgx@archiver.kernel.org>; Thu, 16 Jul 2020 13:58:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1135720787
	for <linux-sgx@archiver.kernel.org>; Thu, 16 Jul 2020 13:58:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728579AbgGPN6X (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 16 Jul 2020 09:58:23 -0400
Received: from mga14.intel.com ([192.55.52.115]:11188 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726537AbgGPN6W (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 16 Jul 2020 09:58:22 -0400
IronPort-SDR: Ek0ZVQ5S56D7Aw1uHJtekYzj/teGUs8hijhjkty3nddjdi6KlGPHLuYbY7XpUQVly9qZdtnPim
 yxo4yTBd+lHA==
X-IronPort-AV: E=McAfee;i="6000,8403,9683"; a="148533775"
X-IronPort-AV: E=Sophos;i="5.75,359,1589266800"; 
   d="scan'208";a="148533775"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2020 06:53:19 -0700
IronPort-SDR: 3yMFdTObAT23Wi5cUHYY9eWGvPwDFkhw71TU2sKDvM/mvslMVB4dUWS3hbml3AkNTXDtD6aCcM
 p+3xu1LNpSAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,359,1589266800"; 
   d="scan'208";a="326531872"
Received: from mpuputti-mobl.ger.corp.intel.com (HELO localhost) ([10.252.32.212])
  by orsmga007.jf.intel.com with ESMTP; 16 Jul 2020 06:53:06 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     x86@kernel.org, linux-sgx@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, bp@alien8.de, cedric.xing@intel.com,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, sean.j.christopherson@intel.com,
        tglx@linutronix.de, yaozhangx@google.com
Subject: [PATCH v36 00/24] Intel SGX foundations
Date:   Thu, 16 Jul 2020 16:52:39 +0300
Message-Id: <20200716135303.276442-1-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Intel(R) SGX is a set of CPU instructions that can be used by applications
to set aside private regions of code and data. The code outside the enclave
is disallowed to access the memory inside the enclave by the CPU access
control.

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

v36:
* Make a self-contained mprotect() handler.
* Move from radix_tree to xarray, which is more modern and robust data
  structure for managing large sparse arrays. Rename encl->page_tree as
  encl->page_array.

v35:
* Add missing SGX_ENCL_DEAD check to sgx_ioctl().

v34:
* Remove SGX_ENCL_DEAD checks from ioctl.c, as the file is open while
  executing an ioctl.
* Split driver patch into base patch and one patch for each ioctl.
* Move encl->flags check to the beginning of each ioctl. Return
  consistently -EINVAL if they don't match the expected values. Before,
  sometimes -EFAULT was returned instead of -EINVAL.
* Rename vm_ops->may_mprotect as vm_ops->mprotect() and move the call
  right before call to mprotect_fixup().

v33:
* Rebased to v5.8-rc1. Given the core changes (mmap_lock and #DB
  handling), it made sense to update the series.
* Refined documentation about how remote attestation is done in SGX.

v32:
* v31 contained not fully cleaned up main.c after merger of main.c and
  reclaim.c. Fixed in this version.
* Rebased to v5.7. Forgot to do this for v31.

v31:
* Unset SGX_ENCL_IOCTL in the error path of checking encl->flags in order
  to prevent leaving it set and thus block any further ioctl calls.
* Added missing cleanup_srcu_struct() call to sgx_encl_release().
* Take encl->lock in sgx_encl_add_page() in order to prevent races with
  the page reclaimer.
* Fix a use-after-free bug from the page reclaimer. Call kref_put() for
  encl->refcount only after putting enclave page back to the active page
  list because it could be the last ref to the enclave.
* Filter any CPU disallowed values from sigstruct->vendor
  SGX_IOC_ENCLAVE_INIT.
* Use bits 0-7 of page descriptor for the EPC section index. This
  should be enough for long term needs.
* Refined naming for functions that allocate and free EPC pages to
  be more sound and consistent.
* Merge main.c and reclaim.c into one.

v30:
Bunch of tags added. No actual code changes.

v29:
* The selftest has been moved to selftests/sgx. Because SGX is an execution
  environment of its own, it really isn't a great fit with more "standard"
  x86 tests.

  The RSA key is now generated on fly and the whole signing process has
  been made as part of the enclave loader instead of signing the enclave
  during the compilation time.

  Finally, the enclave loader loads now the test enclave directly from its
  ELF file, which means that ELF file does not need to be coverted as raw
  binary during the build process.
* Version the mm_list instead of using on synchronize_mm() when adding new
  entries. We hold the write lock for the mm_struct, and dup_mm() can thus
  deadlock with the page reclaimer, which could hold the lock for the old
  mm_struct.
* Disallow mmap(PROT_NONE) from /dev/sgx. Any mapping (e.g. anonymous) can
  be used to reserve the address range. Now /dev/sgx supports only opaque
  mappings to the (initialized) enclave data.
* Make the vDSO callable directly from C by preserving RBX and taking leaf
  from RCX.

v28:
* Documented to Documentation/x86/sgx.rst how the kernel manages the
  enclave ownership.
* Removed non-LC flow from sgx_einit().
* Removed struct sgx_einittoken since only the size of the corresponding
  microarchitectural structure is used in the series ATM.

v27:
* Disallow RIE processes to use enclaves as there could a permission
  conflict between VMA and enclave permissions.
* In the documentation, replace "grep /proc/cpuinfo" with
  "grep sgx /proc/cpuinfo".

v26:
* Fixed the commit author in "x86/sgx: Linux Enclave Driver", which was
  changed in v25 by mistake.
* Addressed a bunch of grammar mistakes in sgx.rst (thanks Randy once
  again for such a detailed feedback).
* Added back the MAINTAINERS update commit, which was mistakenly removed
  in v25.
* EREMOVE's for SECS cannot be done while sanitizing an EPC section. The
  CPU does not allow to remove a SECS page before all of its children have
  been removed, and a child page can be in some other section than the one
  currently being processed. Thus, removed special SECS processing from
  sgx_sanitize_page() and instead put sections through it twice. In the
  2nd round the lists should only contain SECS pages.

v25:
* Fix a double-free issue when SGX_IOC_ENCLAVE_ADD_PAGES
  fails on executing ENCLS[EADD]. The rollback path executed
  radix_tree_delete() on the same address twice when this happened.
* Return -EINTR instead of -ERESTARTSYS in SGX_IOC_ENCLAVE_ADD_PAGES when
  a signal is pending.
* As requested by Borislav, move the CPUID 0x12 features to their own word
  in cpufeatures.
* Sean fixed a bug from sgx_reclaimer_write() where sgx_encl_put_backing()
  was called with an uninitialized pointer when sgx_encl_get_backing()
  fails.
* Migrated /dev/sgx/* to misc. This is future-proof as struct miscdevice
  has 'groups' for setting up sysfs attributes for the device.
* Use device_initcall instead of subsys_initcall so that misc_class is
  initialized before SGX is initialized.
* Return -EACCES in SGX_IOC_ENCLAVE_INIT when caller tries to select
  enclave attributes that we the kernel does not allow it to set instead
  of -EINVAL.
* Unless SGX public key MSRs are writable always deny the feature from
  Linux. Previously this was only denied from driver. How VMs should be
  supported is not really part of initial patch set, which makes this
  an obvious choice.
* Cleaned up and refined documentation to be more approachable.

v24:
* Reclaim unmeasured and TCS pages (regression in v23).
* Replace usages of GFP_HIGHUSER with GFP_KERNEL.
* Return -EIO on when EADD or EEXTEND fails in %SGX_IOC_ENCLAVE_ADD_PAGES
  and use the same rollback (destroy enclave). This can happen when host
  suspends itself unknowingly to a VM running enclaves. From -EIO the user
  space can deduce what happened.
* Have a separate @count in struct sgx_enclave_add_pages to output number
  of bytes processed instead of overwriting the input parameters for
  clarity and more importantly that the API provides means for partial
  processing (@count could be less than @length in success case).

v23:
* Replace SGX_ENCLAVE_ADD_PAGE with SGX_ENCLAVE_ADD_PAGES. Replace @mrmask
  with %SGX_PAGE_MEASURE flag.
* Return -EIO instead of -ECANCELED when ptrace() fails to read a TCS page.
* In the reclaimer, pin page before ENCLS[EBLOCK] because pinning can fail
  (because of OOM) even in legit behaviour and after EBLOCK the reclaiming
  flow can be only reverted by killing the whole enclave.
* Fixed SGX_ATTR_RESERVED_MASK. Bit 7 was marked as reserved while in fact
  it should have been bit 6 (Table 37-3 in the SDM).
* Return -EPERM from SGX_IOC_ENCLAVE_INIT when ENCLS[EINIT] returns an SGX
  error code.

v22:
* Refined bunch commit messages and added associated SDM references as
  many of them were too exhausting and some outdated.
* Alignment checks have been removed from mmap() because it does not define
  the ELRANGE. VMAs only act as windows to the enclave. The semantics
  compare somewhat how mmap() works with regular files.
* We now require user space addresses given to SGX_IOC_ENCLAVE_ADD_PAGE to be
  page aligned so that we can pass the page directly to EADD and do not have
  to do an extra copy. This was made effectively possible by removing the
  worker thread for adding pages.
* The selftest build files have been refined throughout of various glitches
  and work properly in a cross compilation environment such as BuildRoot.
  In addition, libcalls fail the build with an assertion in the linker
  script, if they end up to the enclave binary.
* CONFIG_INTEL_SGX_DRIVER has been removed because you cannot use SGX core
  for anything without having the driver. This could change when KVM support
  is added.
* We require zero permissions in SECINFO for TCS pages because the CPU
  overwrites SECINFO flags with zero permissions and measures the page
  only after that. Allowing to pass TCS with non-zero permissions would
  cause mismatching measurement between the one provided in SIGSTRUCT and
  the one computed by the CPU.
* Obviously lots of small fixes and clean ups (does make sense to
  document them all).

v21:
* Check on mmap() that the VMA does cover an area that does not have
  enclave pages. Only mapping with PROT_NONE can do that to reserve
  initial address space for an enclave.
* Check om mmap() and mprotect() that the VMA permissions do not
  surpass the enclave permissions.
* Remove two refcounts from vma_close(): mm_list and encl->refcount.
  Enclave refcount is only need for swapper/enclave sync and we can
  remove mm_list refcount by destroying mm_struct when the process
  is closed. By not having vm_close() the Linux MM can merge VMAs.
* Do not naturally align MAP_FIXED address.
* Numerous small fixes and clean ups.
* Use SRCU for synchronizing the list of mm_struct's.
* Move to stack based call convention in the vDSO.

v20:
* Fine-tune Kconfig messages and spacing and remove MMU_NOTIFIER
  dependency as MMU notifiers are no longer used in the driver.
* Use mm_users instead of mm_count as refcount for mm_struct as mm_count
  only protects from deleting mm_struct, not removing its contents.
* Sanitize EPC when the reclaimer thread starts by doing EREMOVE for all
  of them. They could be in initialized state when the kernel starts
  because it might be spawned by kexec().
* Documentation overhaul.
* Use a device /dev/sgx/provision for delivering the provision token
  instead of securityfs.
* Create a reference to the enclave when already when opening
  /dev/sgx/enclave.  The file is then associated with this enclave only.
  mmap() can be done at free at any point and always get a reference to
  the enclave. To summarize the file now represents the enclave.

v19:
* Took 3-4 months but in some sense this was more like a rewrite of most
  of the corners of the source code. If I've forgotten to deal with some
  feedback, please don't shout me. Make a remark and I will fix it for
  the next version. Hopefully there won't be this big turnovers anymore.
* Validate SECS attributes properly against CPUID given attributes and
  against allowed attributes. SECS attributes are the ones that are
  enforced whereas SIGSTRUCT attributes tell what is required to run
  the enclave.
* Add KSS (Key Sharing Support) to the enclave attributes.
* Deny MAP_PRIVATE as an enclave is always a shared memory entity.
* Revert back to shmem backing storage so that it can be easily shared
  by multiple processes.
* Split the recognization of an ENCLS leaf failure by using three
  functions to detect it: encsl_faulted(), encls_returned_code() and
  sgx_failed(). encls_failed() is only caused by a spurious expections that
  should never happen. Thus, it is not defined as an inline function in
  order to easily insert a kprobe to it.
* Move low-level enclave management routines, page fault handler and page
  reclaiming routines from driver to the core. These cannot be separated
  from each other as they are heavily interdependent. The rationale is that
  the core does not call any code from the driver.
* Allow the driver to be compiled as a module now that it no code is using
  its routines and it only uses exported symbols. Now the driver is
  essentially just a thin ioctl layer.
* Reworked the driver to maintain a list of mm_struct's. The VMA callbacks
  add new entries to this list as the process is forked. Each entry has
  its own refcount because they have a different life-cycle as the enclave
  does. In effect @tgid and @mm have been removed from struct sgx_encl
  and we allow forking by removing VM_DONTCOPY from vm flags.
* Generate a cpu mask in the reclaimer from the cpu mask's of all
  mm_struct's. This will kick out the hardware threads out of the enclave
  from multiple processes. It is not a local variable because it would
  eat too much of the stack space but instead a field in struct
  sgx_encl.
* Allow forking i.e. remove VM_DONTCOPY. I did not change the API
  because the old API scaled to the workload that Andy described. The
  codebase is now mostly API independent i.e. changing the API is a
  small task. For me the proper trigger to chanage it is a as concrete
  as possible workload that cannot be fulfilled. I hope you understand
  my thinking here. I don't want to change anything w/o proper basis
  but I'm ready to change anything if there is a proper basis. I do
  not have any kind of attachment to any particular type of API.
* Add Sean's vDSO ENCLS(EENTER) patches and update selftest to use the
  new vDSO.

v18:
* Update the ioctl-number.txt.
* Move the driver under arch/x86.
* Add SGX features (SGX, SGX1, SGX2) to the disabled-features.h.
* Rename the selftest as test_sgx (previously sgx-selftest).
* In order to enable process accounting, swap EPC pages and PCMD's to a VMA
  instead of shmem.
* Allow only to initialize and run enclaves with a subset of
  {DEBUG, MODE64BIT} set.
* Add SGX_IOC_ENCLAVE_SET_ATTRIBUTE to allow an enclave to have privileged
  attributes e.g. PROVISIONKEY.

v17:
* Add a simple selftest.
* Fix a null pointer dereference to section->pages when its
  allocation fails.
* Add Sean's description of the exception handling to the documentation.

v16:
* Fixed SOB's in the commits that were a bit corrupted in v15.
* Implemented exceptio handling properly to detect_sgx().
* Use GENMASK() to define SGX_CPUID_SUB_LEAF_TYPE_MASK.
* Updated the documentation to use rst definition lists.
* Added the missing Documentation/x86/index.rst, which has a link to
  intel_sgx.rst. Now the SGX and uapi documentation is properly generated
  with 'make htmldocs'.
* While enumerating EPC sections, if an undefined section is found, fail
  the driver initialization instead of continuing the initialization.
* Issue a warning if there are more than %SGX_MAX_EPC_SECTIONS.
* Remove copyright notice from arch/x86/include/asm/sgx.h.
* Migrated from ioremap_cache() to memremap().

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

Jarkko Sakkinen (14):
  x86/sgx: Add SGX microarchitectural data structures
  x86/sgx: Add wrappers for ENCLS leaf functions
  x86/cpu/intel: Add nosgx kernel parameter
  x86/sgx: Add __sgx_alloc_epc_page() and sgx_free_epc_page()
  x86/sgx: Add SGX enclave driver
  x86/sgx: Add SGX_IOC_ENCLAVE_CREATE
  x86/sgx: Add SGX_IOC_ENCLAVE_ADD_PAGES
  x86/sgx: Add SGX_IOC_ENCLAVE_INIT
  x86/sgx: Allow a limited use of ATTRIBUTE.PROVISIONKEY for attestation
  x86/sgx: Add a page reclaimer
  x86/sgx: ptrace() support for the SGX driver
  selftests/x86: Add a selftest for SGX
  docs: x86/sgx: Document SGX micro architecture and kernel internals
  x86/sgx: Update MAINTAINERS

Sean Christopherson (10):
  x86/cpufeatures: x86/msr: Add Intel SGX hardware bits
  x86/cpufeatures: x86/msr: Add Intel SGX Launch Control hardware bits
  x86/mm: x86/sgx: Signal SIGSEGV with PF_SGX
  x86/cpu/intel: Detect SGX support
  x86/sgx: Initialize metadata for Enclave Page Cache (EPC) sections
  mm: Add vm_ops->mprotect()
  x86/vdso: Add support for exception fixup in vDSO functions
  x86/fault: Add helper function to sanitize error code
  x86/traps: Attempt to fixup exceptions in vDSO before signaling
  x86/vdso: Implement a vDSO for Intel SGX enclave call

 .../admin-guide/kernel-parameters.txt         |   2 +
 .../userspace-api/ioctl/ioctl-number.rst      |   1 +
 Documentation/x86/index.rst                   |   1 +
 Documentation/x86/sgx.rst                     | 198 +++++
 MAINTAINERS                                   |  11 +
 arch/x86/Kconfig                              |  17 +
 arch/x86/entry/vdso/Makefile                  |   8 +-
 arch/x86/entry/vdso/extable.c                 |  46 +
 arch/x86/entry/vdso/extable.h                 |  29 +
 arch/x86/entry/vdso/vdso-layout.lds.S         |   9 +-
 arch/x86/entry/vdso/vdso.lds.S                |   1 +
 arch/x86/entry/vdso/vdso2c.h                  |  50 +-
 arch/x86/entry/vdso/vsgx_enter_enclave.S      | 131 +++
 arch/x86/include/asm/cpufeature.h             |   5 +-
 arch/x86/include/asm/cpufeatures.h            |   8 +-
 arch/x86/include/asm/disabled-features.h      |  18 +-
 arch/x86/include/asm/enclu.h                  |   8 +
 arch/x86/include/asm/msr-index.h              |   8 +
 arch/x86/include/asm/required-features.h      |   2 +-
 arch/x86/include/asm/traps.h                  |  14 +-
 arch/x86/include/asm/vdso.h                   |   5 +
 arch/x86/include/uapi/asm/sgx.h               | 175 ++++
 arch/x86/kernel/cpu/Makefile                  |   1 +
 arch/x86/kernel/cpu/common.c                  |   4 +
 arch/x86/kernel/cpu/feat_ctl.c                |  41 +-
 arch/x86/kernel/cpu/sgx/Makefile              |   5 +
 arch/x86/kernel/cpu/sgx/arch.h                | 343 ++++++++
 arch/x86/kernel/cpu/sgx/driver.c              | 208 +++++
 arch/x86/kernel/cpu/sgx/driver.h              |  32 +
 arch/x86/kernel/cpu/sgx/encl.c                | 756 ++++++++++++++++
 arch/x86/kernel/cpu/sgx/encl.h                | 128 +++
 arch/x86/kernel/cpu/sgx/encls.h               | 238 +++++
 arch/x86/kernel/cpu/sgx/ioctl.c               | 819 ++++++++++++++++++
 arch/x86/kernel/cpu/sgx/main.c                | 753 ++++++++++++++++
 arch/x86/kernel/cpu/sgx/sgx.h                 |  64 ++
 arch/x86/kernel/traps.c                       |  19 +-
 arch/x86/mm/fault.c                           |  45 +-
 include/linux/mm.h                            |   3 +
 mm/mprotect.c                                 |   5 +-
 tools/testing/selftests/Makefile              |   1 +
 tools/testing/selftests/sgx/.gitignore        |   2 +
 tools/testing/selftests/sgx/Makefile          |  53 ++
 tools/testing/selftests/sgx/call.S            |  54 ++
 tools/testing/selftests/sgx/defines.h         |  21 +
 tools/testing/selftests/sgx/load.c            | 282 ++++++
 tools/testing/selftests/sgx/main.c            | 199 +++++
 tools/testing/selftests/sgx/main.h            |  38 +
 tools/testing/selftests/sgx/sigstruct.c       | 395 +++++++++
 tools/testing/selftests/sgx/test_encl.c       |  20 +
 tools/testing/selftests/sgx/test_encl.lds     |  40 +
 .../selftests/sgx/test_encl_bootstrap.S       |  89 ++
 51 files changed, 5375 insertions(+), 30 deletions(-)
 create mode 100644 Documentation/x86/sgx.rst
 create mode 100644 arch/x86/entry/vdso/extable.c
 create mode 100644 arch/x86/entry/vdso/extable.h
 create mode 100644 arch/x86/entry/vdso/vsgx_enter_enclave.S
 create mode 100644 arch/x86/include/asm/enclu.h
 create mode 100644 arch/x86/include/uapi/asm/sgx.h
 create mode 100644 arch/x86/kernel/cpu/sgx/Makefile
 create mode 100644 arch/x86/kernel/cpu/sgx/arch.h
 create mode 100644 arch/x86/kernel/cpu/sgx/driver.c
 create mode 100644 arch/x86/kernel/cpu/sgx/driver.h
 create mode 100644 arch/x86/kernel/cpu/sgx/encl.c
 create mode 100644 arch/x86/kernel/cpu/sgx/encl.h
 create mode 100644 arch/x86/kernel/cpu/sgx/encls.h
 create mode 100644 arch/x86/kernel/cpu/sgx/ioctl.c
 create mode 100644 arch/x86/kernel/cpu/sgx/main.c
 create mode 100644 arch/x86/kernel/cpu/sgx/sgx.h
 create mode 100644 tools/testing/selftests/sgx/.gitignore
 create mode 100644 tools/testing/selftests/sgx/Makefile
 create mode 100644 tools/testing/selftests/sgx/call.S
 create mode 100644 tools/testing/selftests/sgx/defines.h
 create mode 100644 tools/testing/selftests/sgx/load.c
 create mode 100644 tools/testing/selftests/sgx/main.c
 create mode 100644 tools/testing/selftests/sgx/main.h
 create mode 100644 tools/testing/selftests/sgx/sigstruct.c
 create mode 100644 tools/testing/selftests/sgx/test_encl.c
 create mode 100644 tools/testing/selftests/sgx/test_encl.lds
 create mode 100644 tools/testing/selftests/sgx/test_encl_bootstrap.S

-- 
2.25.1

