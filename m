Return-Path: <SRS0=01IT=SZ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33ABBC10F03
	for <linux-sgx@archiver.kernel.org>; Tue, 23 Apr 2019 16:52:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D16EE2148D
	for <linux-sgx@archiver.kernel.org>; Tue, 23 Apr 2019 16:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1556038366;
	bh=K/j/S6HWJKnpvEdPMo4e5fIXoh0kJflOmbR1dhOqhps=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=r+1YnDW5gljdWh8dwfcEAjR+AT4LInjeC7IJN96Wtzp2e3Vo+SGu+XQSV/Pz+VIYb
	 gKJVVM5GBN8KbRy0eJzzR5Y4X/GC4CKABhrcYxXUxxoEpxknS5nC4F/9s8KALQeK1z
	 djrnCn+FpJIlVj1XlQDLy2OuNzRoNc4ZirLzXdtw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728807AbfDWQwp (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 23 Apr 2019 12:52:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:42876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728609AbfDWQwp (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 23 Apr 2019 12:52:45 -0400
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 922672148D
        for <linux-sgx@vger.kernel.org>; Tue, 23 Apr 2019 16:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556038363;
        bh=K/j/S6HWJKnpvEdPMo4e5fIXoh0kJflOmbR1dhOqhps=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=vEQzuMwQJWjWz8eb0cWt8reBmz5yuY4wkMmppFTMsEpRtwmxckO25lvKfbyQgrZ7n
         WQh03YahkuURZ6GjIl/a8UvHc0NrUT8CwwR2ME+iTyp8Zr6MH+Zn9xZeaYTN7dOOhM
         J82p9xeW659Gp0cVvdH+DsfjmznEc46gCeIx5W38=
Received: by mail-wr1-f46.google.com with SMTP id t17so21068166wrw.13
        for <linux-sgx@vger.kernel.org>; Tue, 23 Apr 2019 09:52:42 -0700 (PDT)
X-Gm-Message-State: APjAAAWuckdASfY3q04BfOWHZ0CtZ3xGSt4RwNEBWkun9ZmXRrHdVMcb
        3uiFbfP3DPXSOIDkGkUVwF0rofdxj6F5HN3EBd02lw==
X-Google-Smtp-Source: APXvYqxMfvM2TxOdS8uYNeuZw4umRaf3ug0AKzMsgg6ImADPMWqg1imvA+m3HlNYQi4ng6t9mcs5HxQ5e7M1tJ37fO8=
X-Received: by 2002:a5d:4587:: with SMTP id p7mr10700134wrq.77.1556038361080;
 Tue, 23 Apr 2019 09:52:41 -0700 (PDT)
MIME-Version: 1.0
References: <20190417103938.7762-1-jarkko.sakkinen@linux.intel.com> <20190423115611.GA5604@linux.intel.com>
In-Reply-To: <20190423115611.GA5604@linux.intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Tue, 23 Apr 2019 09:52:29 -0700
X-Gmail-Original-Message-ID: <CALCETrV9SOLNw0d2tXOW1Ntmwaqso2xA2YVOvr60btR9G7Wgxg@mail.gmail.com>
Message-ID: <CALCETrV9SOLNw0d2tXOW1Ntmwaqso2xA2YVOvr60btR9G7Wgxg@mail.gmail.com>
Subject: Re: [PATCH v20 00/28] Intel SGX1 support
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        linux-sgx@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        nhorman@redhat.com, npmccallum@redhat.com,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Svahn, Kai" <kai.svahn@intel.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        Andrew Lutomirski <luto@kernel.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Apr 23, 2019 at 4:56 AM Jarkko Sakkinen
<jarkko.sakkinen@linux.intel.com> wrote:
>
> On Wed, Apr 17, 2019 at 01:39:10PM +0300, Jarkko Sakkinen wrote:
> > Intel(R) SGX is a set of CPU instructions that can be used by applicati=
ons
> > to set aside private regions of code and data. The code outside the enc=
lave
> > is disallowed to access the memory inside the enclave by the CPU access
> > control.  In a way you can think that SGX provides inverted sandbox. It
> > protects the application from a malicious host.
> >
> > There is a new hardware unit in the processor called Memory Encryption
> > Engine (MEE) starting from the Skylake microacrhitecture. BIOS can defi=
ne
> > one or many MEE regions that can hold enclave data by configuring them =
with
> > PRMRR registers.
> >
> > The MEE automatically encrypts the data leaving the processor package t=
o
> > the MEE regions. The data is encrypted using a random key whose life-ti=
me
> > is exactly one power cycle.
> >
> > The current implementation requires that the firmware sets
> > IA32_SGXLEPUBKEYHASH* MSRs as writable so that ultimately the kernel ca=
n
> > decide what enclaves it wants run. The implementation does not create
> > any bottlenecks to support read-only MSRs later on.
> >
> > You can tell if your CPU supports SGX by looking into /proc/cpuinfo:
> >
> >       cat /proc/cpuinfo  | grep sgx
> >
> > v20:
> > * Fine-tune Kconfig messages and spacing and remove MMU_NOTIFIER
> >   dependency as MMU notifiers are no longer used in the driver.
> > * Use mm_users instead of mm_count as refcount for mm_struct as mm_coun=
t
> >   only protects from deleting mm_struct, not removing its contents.
> > * Sanitize EPC when the reclaimer thread starts by doing EREMOVE for al=
l
> >   of them. They could be in initialized state when the kernel starts
> >   because it might be spawned by kexec().
> > * Documentation overhaul.
> > * Use a device /dev/sgx/provision for delivering the provision token
> >   instead of securityfs.
> > * Create a reference to the enclave when already when opening
> >   /dev/sgx/enclave.  The file is then associated with this enclave only=
.
> >   mmap() can be done at free at any point and always get a reference to
> >   the enclave. To summarize the file now represents the enclave.
> >
> > v19:
> > * Took 3-4 months but in some sense this was more like a rewrite of mos=
t
> >   of the corners of the source code. If I've forgotten to deal with som=
e
> >   feedback, please don't shout me. Make a remark and I will fix it for
> >   the next version. Hopefully there won't be this big turnovers anymore=
.
> > * Validate SECS attributes properly against CPUID given attributes and
> >   against allowed attributes. SECS attributes are the ones that are
> >   enforced whereas SIGSTRUCT attributes tell what is required to run
> >   the enclave.
> > * Add KSS (Key Sharing Support) to the enclave attributes.
> > * Deny MAP_PRIVATE as an enclave is always a shared memory entity.
> > * Revert back to shmem backing storage so that it can be easily shared
> >   by multiple processes.
> > * Split the recognization of an ENCLS leaf failure by using three
> >   functions to detect it: encsl_faulted(), encls_returned_code() and
> >   sgx_failed(). encls_failed() is only caused by a spurious expections =
that
> >   should never happen. Thus, it is not defined as an inline function in
> >   order to easily insert a kprobe to it.
> > * Move low-level enclave management routines, page fault handler and pa=
ge
> >   reclaiming routines from driver to the core. These cannot be separate=
d
> >   from each other as they are heavily interdependent. The rationale is =
that
> >   the core does not call any code from the driver.
> > * Allow the driver to be compiled as a module now that it no code is us=
ing
> >   its routines and it only uses exported symbols. Now the driver is
> >   essentially just a thin ioctl layer.
> > * Reworked the driver to maintain a list of mm_struct's. The VMA callba=
cks
> >   add new entries to this list as the process is forked. Each entry has
> >   its own refcount because they have a different life-cycle as the encl=
ave
> >   does. In effect @tgid and @mm have been removed from struct sgx_encl
> >   and we allow forking by removing VM_DONTCOPY from vm flags.
> > * Generate a cpu mask in the reclaimer from the cpu mask's of all
> >   mm_struct's. This will kick out the hardware threads out of the encla=
ve
> >   from multiple processes. It is not a local variable because it would
> >   eat too much of the stack space but instead a field in struct
> >   sgx_encl.
> > * Allow forking i.e. remove VM_DONTCOPY. I did not change the API
> >   because the old API scaled to the workload that Andy described. The
> >   codebase is now mostly API independent i.e. changing the API is a
> >   small task. For me the proper trigger to chanage it is a as concrete
> >   as possible workload that cannot be fulfilled. I hope you understand
> >   my thinking here. I don't want to change anything w/o proper basis
> >   but I'm ready to change anything if there is a proper basis. I do
> >   not have any kind of attachment to any particular type of API.
> > * Add Sean's vDSO ENCLS(EENTER) patches and update selftest to use the
> >   new vDSO.
> >
> > v18:
> > * Update the ioctl-number.txt.
> > * Move the driver under arch/x86.
> > * Add SGX features (SGX, SGX1, SGX2) to the disabled-features.h.
> > * Rename the selftest as test_sgx (previously sgx-selftest).
> > * In order to enable process accounting, swap EPC pages and PCMD's to a=
 VMA
> >   instead of shmem.
> > * Allow only to initialize and run enclaves with a subset of
> >   {DEBUG, MODE64BIT} set.
> > * Add SGX_IOC_ENCLAVE_SET_ATTRIBUTE to allow an enclave to have privile=
ged
> >   attributes e.g. PROVISIONKEY.
> >
> > v17:
> > * Add a simple selftest.
> > * Fix a null pointer dereference to section->pages when its
> >   allocation fails.
> > * Add Sean's description of the exception handling to the documentation=
.
> >
> > v16:
> > * Fixed SOB's in the commits that were a bit corrupted in v15.
> > * Implemented exceptio handling properly to detect_sgx().
> > * Use GENMASK() to define SGX_CPUID_SUB_LEAF_TYPE_MASK.
> > * Updated the documentation to use rst definition lists.
> > * Added the missing Documentation/x86/index.rst, which has a link to
> >   intel_sgx.rst. Now the SGX and uapi documentation is properly generat=
ed
> >   with 'make htmldocs'.
> > * While enumerating EPC sections, if an undefined section is found, fai=
l
> >   the driver initialization instead of continuing the initialization.
> > * Issue a warning if there are more than %SGX_MAX_EPC_SECTIONS.
> > * Remove copyright notice from arch/x86/include/asm/sgx.h.
> > * Migrated from ioremap_cache() to memremap().
> >
> > v15:
> > * Split into more digestable size patches.
> > * Lots of small fixes and clean ups.
> > * Signal a "plain" SIGSEGV on an EPCM violation.
> >
> > v14:
> > * Change the comment about X86_FEATURE_SGX_LC from =E2=80=9CSGX launch
> >   configuration=E2=80=9D to =E2=80=9CSGX launch control=E2=80=9D.
> > * Move the SGX-related CPU feature flags as part of the Linux defined
> >   virtual leaf 8.
> > * Add SGX_ prefix to the constants defining the ENCLS leaf functions.
> > * Use GENMASK*() and BIT*() in sgx_arch.h instead of raw hex numbers.
> > * Refine the long description for CONFIG_INTEL_SGX_CORE.
> > * Do not use pr_*_ratelimited()  in the driver. The use of the rate lim=
ited
> >   versions is legacy cruft from the prototyping phase.
> > * Detect sleep with SGX_INVALID_EINIT_TOKEN instead of counting power
> >   cycles.
> > * Manually prefix with =E2=80=9Csgx:=E2=80=9D in the core SGX code inst=
ead of redefining
> >   pr_fmt.
> > * Report if IA32_SGXLEPUBKEYHASHx MSRs are not writable in the driver
> >   instead of core because it is a driver requirement.
> > * Change prompt to bool in the entry for CONFIG_INTEL_SGX_CORE because =
the
> >   default is =E2=80=98n=E2=80=99.
> > * Rename struct sgx_epc_bank as struct sgx_epc_section in order to matc=
h
> >   the SDM.
> > * Allocate struct sgx_epc_page instances one at a time.
> > * Use =E2=80=9C__iomem void *=E2=80=9D pointers for the mapped EPC memo=
ry consistently.
> > * Retry once on SGX_INVALID_TOKEN in sgx_einit() instead of counting po=
wer
> >   cycles.
> > * Call enclave swapping operations directly from the driver instead of
> >   calling them .indirectly through struct sgx_epc_page_ops because indi=
rect
> >   calls are not required yet as the patch set does not contain the KVM
> >   support.
> > * Added special signal SEGV_SGXERR to notify about SGX EPCM violation
> >   errors.
> >
> > v13:
> > * Always use SGX_CPUID constant instead of a hardcoded value.
> > * Simplified and documented the macros and functions for ENCLS leaves.
> > * Enable sgx_free_page() to free active enclave pages on demand
> >   in order to allow sgx_invalidate() to delete enclave pages.
> >   It no longer performs EREMOVE if a page is in the process of
> >   being reclaimed.
> > * Use PM notifier per enclave so that we don't have to traverse
> >   the global list of active EPC pages to find enclaves.
> > * Removed unused SGX_LE_ROLLBACK constant from uapi/asm/sgx.h
> > * Always use ioremap() to map EPC banks as we only support 64-bit kerne=
l.
> > * Invalidate IA32_SGXLEPUBKEYHASH cache used by sgx_einit() when going
> >   to sleep.
> >
> > v12:
> > * Split to more narrow scoped commits in order to ease the review proce=
ss and
> >   use co-developed-by tag for co-authors of commits instead of listing =
them in
> >   the source files.
> > * Removed cruft EXPORT_SYMBOL() declarations and converted to static va=
riables.
> > * Removed in-kernel LE i.e. this version of the SGX software stack only
> >   supports unlocked IA32_SGXLEPUBKEYHASHx MSRs.
> > * Refined documentation on launching enclaves, swapping and enclave
> >   construction.
> > * Refined sgx_arch.h to include alignment information for every struct =
that
> >   requires it and removed structs that are not needed without an LE.
> > * Got rid of SGX_CPUID.
> > * SGX detection now prints log messages about firmware configuration is=
sues.
> >
> > v11:
> > * Polished ENCLS wrappers with refined exception handling.
> > * ksgxswapd was not stopped (regression in v5) in
> >   sgx_page_cache_teardown(), which causes a leaked kthread after driver
> >   deinitialization.
> > * Shutdown sgx_le_proxy when going to suspend because its EPC pages wil=
l be
> >   invalidated when resuming, which will cause it not function properly
> >   anymore.
> > * Set EINITTOKEN.VALID to zero for a token that is passed when
> >   SGXLEPUBKEYHASH matches MRSIGNER as alloc_page() does not give a zero
> >   page.
> > * Fixed the check in sgx_edbgrd() for a TCS page. Allowed to read offse=
ts
> >   around the flags field, which causes a #GP. Only flags read is readab=
le.
> > * On read access memcpy() call inside sgx_vma_access() had src and dest
> >   parameters in wrong order.
> > * The build issue with CONFIG_KASAN is now fixed. Added undefined symbo=
ls
> >   to LE even if =E2=80=9CKASAN_SANITIZE :=3D false=E2=80=9D was set in =
the makefile.
> > * Fixed a regression in the #PF handler. If a page has
> >   SGX_ENCL_PAGE_RESERVED flag the #PF handler should unconditionally fa=
il.
> >   It did not, which caused weird races when trying to change other part=
s of
> >   swapping code.
> > * EPC management has been refactored to a flat LRU cache and moved to
> >   arch/x86. The swapper thread reads a cluster of EPC pages and swaps a=
ll
> >   of them. It can now swap from multiple enclaves in the same round.
> > * For the sake of consistency with SGX_IOC_ENCLAVE_ADD_PAGE, return -EI=
NVAL
> >   when an enclave is already initialized or dead instead of zero.
> >
> > v10:
> > * Cleaned up anon inode based IPC between the ring-0 and ring-3 parts
> >   of the driver.
> > * Unset the reserved flag from an enclave page if EDBGRD/WR fails
> >   (regression in v6).
> > * Close the anon inode when LE is stopped (regression in v9).
> > * Update the documentation with a more detailed description of SGX.
> >
> > v9:
> > * Replaced kernel-LE IPC based on pipes with an anonymous inode.
> >   The driver does not require anymore new exports.
> >
> > v8:
> > * Check that public key MSRs match the LE public key hash in the
> >   driver initialization when the MSRs are read-only.
> > * Fix the race in VA slot allocation by checking the fullness
> >   immediately after succeesful allocation.
> > * Fix the race in hash mrsigner calculation between the launch
> >   enclave and user enclaves by having a separate lock for hash
> >   calculation.
> >
> > v7:
> > * Fixed offset calculation in sgx_edbgr/wr(). Address was masked with P=
AGE_MASK
> >   when it should have been masked with ~PAGE_MASK.
> > * Fixed a memory leak in sgx_ioc_enclave_create().
> > * Simplified swapping code by using a pointer array for a cluster
> >   instead of a linked list.
> > * Squeezed struct sgx_encl_page to 32 bytes.
> > * Fixed deferencing of an RSA key on OpenSSL 1.1.0.
> > * Modified TC's CMAC to use kernel AES-NI. Restructured the code
> >   a bit in order to better align with kernel conventions.
> >
> > v6:
> > * Fixed semaphore underrun when accessing /dev/sgx from the launch encl=
ave.
> > * In sgx_encl_create() s/IS_ERR(secs)/IS_ERR(encl)/.
> > * Removed virtualization chapter from the documentation.
> > * Changed the default filename for the signing key as signing_key.pem.
> > * Reworked EPC management in a way that instead of a linked list of
> >   struct sgx_epc_page instances there is an array of integers that
> >   encodes address and bank of an EPC page (the same data as 'pa' field
> >   earlier). The locking has been moved to the EPC bank level instead
> >   of a global lock.
> > * Relaxed locking requirements for EPC management. EPC pages can be
> >   released back to the EPC bank concurrently.
> > * Cleaned up ptrace() code.
> > * Refined commit messages for new architectural constants.
> > * Sorted includes in every source file.
> > * Sorted local variable declarations according to the line length in
> >   every function.
> > * Style fixes based on Darren's comments to sgx_le.c.
> >
> > v5:
> > * Described IPC between the Launch Enclave and kernel in the commit mes=
sages.
> > * Fixed all relevant checkpatch.pl issues that I have forgot fix in ear=
lier
> >   versions except those that exist in the imported TinyCrypt code.
> > * Fixed spelling mistakes in the documentation.
> > * Forgot to check the return value of sgx_drv_subsys_init().
> > * Encapsulated properly page cache init and teardown.
> > * Collect epc pages to a temp list in sgx_add_epc_bank
> > * Removed SGX_ENCLAVE_INIT_ARCH constant.
> >
> > v4:
> > * Tied life-cycle of the sgx_le_proxy process to /dev/sgx.
> > * Removed __exit annotation from sgx_drv_subsys_exit().
> > * Fixed a leak of a backing page in sgx_process_add_page_req() in the
> >   case when vm_insert_pfn() fails.
> > * Removed unused symbol exports for sgx_page_cache.c.
> > * Updated sgx_alloc_page() to require encl parameter and documented the
> >   behavior (Sean Christopherson).
> > * Refactored a more lean API for sgx_encl_find() and documented the beh=
avior.
> > * Moved #PF handler to sgx_fault.c.
> > * Replaced subsys_system_register() with plain bus_register().
> > * Retry EINIT 2nd time only if MSRs are not locked.
> >
> > v3:
> > * Check that FEATURE_CONTROL_LOCKED and FEATURE_CONTROL_SGX_ENABLE are =
set.
> > * Return -ERESTARTSYS in __sgx_encl_add_page() when sgx_alloc_page() fa=
ils.
> > * Use unused bits in epc_page->pa to store the bank number.
> > * Removed #ifdef for WQ_NONREENTRANT.
> > * If mmu_notifier_register() fails with -EINTR, return -ERESTARTSYS.
> > * Added --remove-section=3D.got.plt to objcopy flags in order to preven=
t a
> >   dummy .got.plt, which will cause an inconsistent size for the LE.
> > * Documented sgx_encl_* functions.
> > * Added remark about AES implementation used inside the LE.
> > * Removed redundant sgx_sys_exit() from le/main.c.
> > * Fixed struct sgx_secinfo alignment from 128 to 64 bytes.
> > * Validate miscselect in sgx_encl_create().
> > * Fixed SSA frame size calculation to take the misc region into account=
.
> > * Implemented consistent exception handling to __encls() and __encls_re=
t().
> > * Implemented a proper device model in order to allow sysfs attributes
> >   and in-kernel API.
> > * Cleaned up various "find enclave" implementations to the unified
> >   sgx_encl_find().
> > * Validate that vm_pgoff is zero.
> > * Discard backing pages with shmem_truncate_range() after EADD.
> > * Added missing EEXTEND operations to LE signing and launch.
> > * Fixed SSA size for GPRS region from 168 to 184 bytes.
> > * Fixed the checks for TCS flags. Now DBGOPTIN is allowed.
> > * Check that TCS addresses are in ELRANGE and not just page aligned.
> > * Require kernel to be compiled with X64_64 and CPU_SUP_INTEL.
> > * Fixed an incorrect value for SGX_ATTR_DEBUG from 0x01 to 0x02.
> >
> > v2:
> > * get_rand_uint32() changed the value of the pointer instead of value
> >   where it is pointing at.
> > * Launch enclave incorrectly used sigstruct attributes-field instead of
> >   enclave attributes-field.
> > * Removed unused struct sgx_add_page_req from sgx_ioctl.c
> > * Removed unused sgx_has_sgx2.
> > * Updated arch/x86/include/asm/sgx.h so that it provides stub
> >   implementations when sgx in not enabled.
> > * Removed cruft rdmsr-calls from sgx_set_pubkeyhash_msrs().
> > * return -ENOMEM in sgx_alloc_page() when VA pages consume too much spa=
ce
> > * removed unused global sgx_nr_pids
> > * moved sgx_encl_release to sgx_encl.c
> > * return -ERESTARTSYS instead of -EINTR in sgx_encl_init()
> >
> > Jarkko Sakkinen (11):
> >   x86/sgx: Add ENCLS architectural error codes
> >   x86/sgx: Add SGX1 and SGX2 architectural data structures
> >   x86/sgx: Add wrappers for ENCLS leaf functions
> >   x86/sgx: Add functions to allocate and free EPC pages
> >   x86/sgx: Add the Linux SGX Enclave Driver
> >   x86/sgx: Add provisioning
> >   x86/sgx: Add swapping code to the core and SGX driver
> >   x86/sgx: ptrace() support for the SGX driver
> >   selftests/x86: Add a selftest for SGX
> >   x86/sgx: Update MAINTAINERS
> >   docs: x86/sgx: Document the enclave API
> >
> > Kai Huang (2):
> >   x86/cpufeatures: Add Intel-defined SGX feature bit
> >   x86/cpufeatures: Add Intel-defined SGX_LC feature bit
> >
> > Sean Christopherson (15):
> >   x86/cpufeatures: Add SGX sub-features (as Linux-defined bits)
> >   x86/msr: Add IA32_FEATURE_CONTROL.SGX_ENABLE definition
> >   x86/msr: Add SGX Launch Control MSR definitions
> >   x86/mm: x86/sgx: Add new 'PF_SGX' page fault error code bit
> >   x86/mm: x86/sgx: Signal SIGSEGV for userspace #PFs w/ PF_SGX
> >   x86/cpu/intel: Detect SGX support and update caps appropriately
> >   x86/sgx: Enumerate and track EPC sections
> >   x86/sgx: Add sgx_einit() for initializing enclaves
> >   x86/vdso: Add support for exception fixup in vDSO functions
> >   x86/fault: Add helper function to sanitize error code
> >   x86/fault: Attempt to fixup unhandled #PF in vDSO before signaling
> >   x86/traps: Attempt to fixup exceptions in vDSO before signaling
> >   x86/vdso: Add __vdso_sgx_enter_enclave() to wrap SGX enclave
> >     transitions
> >   docs: x86/sgx: Add Architecture documentation
> >   docs: x86/sgx: Document kernel internals
> >
> >  Documentation/index.rst                       |   1 +
> >  Documentation/ioctl/ioctl-number.txt          |   1 +
> >  Documentation/x86/index.rst                   |  10 +
> >  Documentation/x86/sgx/1.Architecture.rst      | 431 +++++++++
> >  Documentation/x86/sgx/2.Kernel-internals.rst  |  56 ++
> >  Documentation/x86/sgx/3.API.rst               |  27 +
> >  Documentation/x86/sgx/index.rst               |  18 +
> >  MAINTAINERS                                   |  12 +
> >  arch/x86/Kconfig                              |  27 +
> >  arch/x86/entry/vdso/Makefile                  |   6 +-
> >  arch/x86/entry/vdso/extable.c                 |  37 +
> >  arch/x86/entry/vdso/extable.h                 |  29 +
> >  arch/x86/entry/vdso/vdso-layout.lds.S         |   9 +-
> >  arch/x86/entry/vdso/vdso.lds.S                |   1 +
> >  arch/x86/entry/vdso/vdso2c.h                  |  58 +-
> >  arch/x86/entry/vdso/vsgx_enter_enclave.S      | 101 +++
> >  arch/x86/include/asm/cpufeatures.h            |  24 +-
> >  arch/x86/include/asm/disabled-features.h      |  14 +-
> >  arch/x86/include/asm/msr-index.h              |   8 +
> >  arch/x86/include/asm/traps.h                  |   1 +
> >  arch/x86/include/asm/vdso.h                   |   5 +
> >  arch/x86/include/uapi/asm/sgx.h               |  86 ++
> >  arch/x86/include/uapi/asm/sgx_errno.h         |  91 ++
> >  arch/x86/kernel/cpu/Makefile                  |   1 +
> >  arch/x86/kernel/cpu/intel.c                   |  39 +
> >  arch/x86/kernel/cpu/scattered.c               |   2 +
> >  arch/x86/kernel/cpu/sgx/Makefile              |   2 +
> >  arch/x86/kernel/cpu/sgx/arch.h                | 424 +++++++++
> >  arch/x86/kernel/cpu/sgx/driver/Makefile       |   3 +
> >  arch/x86/kernel/cpu/sgx/driver/driver.h       |  38 +
> >  arch/x86/kernel/cpu/sgx/driver/ioctl.c        | 850 ++++++++++++++++++
> >  arch/x86/kernel/cpu/sgx/driver/main.c         | 368 ++++++++
> >  arch/x86/kernel/cpu/sgx/encl.c                | 709 +++++++++++++++
> >  arch/x86/kernel/cpu/sgx/encl.h                | 136 +++
> >  arch/x86/kernel/cpu/sgx/encls.c               |  22 +
> >  arch/x86/kernel/cpu/sgx/encls.h               | 244 +++++
> >  arch/x86/kernel/cpu/sgx/main.c                | 360 ++++++++
> >  arch/x86/kernel/cpu/sgx/reclaim.c             | 482 ++++++++++
> >  arch/x86/kernel/cpu/sgx/sgx.h                 |  90 ++
> >  arch/x86/kernel/traps.c                       |  14 +
> >  arch/x86/mm/fault.c                           |  44 +-
> >  tools/arch/x86/include/asm/cpufeatures.h      |  21 +-
> >  tools/testing/selftests/x86/Makefile          |  10 +
> >  tools/testing/selftests/x86/sgx/Makefile      |  48 +
> >  tools/testing/selftests/x86/sgx/defines.h     |  39 +
> >  tools/testing/selftests/x86/sgx/encl.c        |  20 +
> >  tools/testing/selftests/x86/sgx/encl.lds      |  33 +
> >  .../selftests/x86/sgx/encl_bootstrap.S        |  94 ++
> >  tools/testing/selftests/x86/sgx/encl_piggy.S  |  18 +
> >  tools/testing/selftests/x86/sgx/encl_piggy.h  |  14 +
> >  tools/testing/selftests/x86/sgx/main.c        | 279 ++++++
> >  tools/testing/selftests/x86/sgx/sgx_call.S    |  15 +
> >  tools/testing/selftests/x86/sgx/sgxsign.c     | 508 +++++++++++
> >  .../testing/selftests/x86/sgx/signing_key.pem |  39 +
> >  54 files changed, 5987 insertions(+), 32 deletions(-)
> >  create mode 100644 Documentation/x86/index.rst
> >  create mode 100644 Documentation/x86/sgx/1.Architecture.rst
> >  create mode 100644 Documentation/x86/sgx/2.Kernel-internals.rst
> >  create mode 100644 Documentation/x86/sgx/3.API.rst
> >  create mode 100644 Documentation/x86/sgx/index.rst
> >  create mode 100644 arch/x86/entry/vdso/extable.c
> >  create mode 100644 arch/x86/entry/vdso/extable.h
> >  create mode 100644 arch/x86/entry/vdso/vsgx_enter_enclave.S
> >  create mode 100644 arch/x86/include/uapi/asm/sgx.h
> >  create mode 100644 arch/x86/include/uapi/asm/sgx_errno.h
> >  create mode 100644 arch/x86/kernel/cpu/sgx/Makefile
> >  create mode 100644 arch/x86/kernel/cpu/sgx/arch.h
> >  create mode 100644 arch/x86/kernel/cpu/sgx/driver/Makefile
> >  create mode 100644 arch/x86/kernel/cpu/sgx/driver/driver.h
> >  create mode 100644 arch/x86/kernel/cpu/sgx/driver/ioctl.c
> >  create mode 100644 arch/x86/kernel/cpu/sgx/driver/main.c
> >  create mode 100644 arch/x86/kernel/cpu/sgx/encl.c
> >  create mode 100644 arch/x86/kernel/cpu/sgx/encl.h
> >  create mode 100644 arch/x86/kernel/cpu/sgx/encls.c
> >  create mode 100644 arch/x86/kernel/cpu/sgx/encls.h
> >  create mode 100644 arch/x86/kernel/cpu/sgx/main.c
> >  create mode 100644 arch/x86/kernel/cpu/sgx/reclaim.c
> >  create mode 100644 arch/x86/kernel/cpu/sgx/sgx.h
> >  create mode 100644 tools/testing/selftests/x86/sgx/Makefile
> >  create mode 100644 tools/testing/selftests/x86/sgx/defines.h
> >  create mode 100644 tools/testing/selftests/x86/sgx/encl.c
> >  create mode 100644 tools/testing/selftests/x86/sgx/encl.lds
> >  create mode 100644 tools/testing/selftests/x86/sgx/encl_bootstrap.S
> >  create mode 100644 tools/testing/selftests/x86/sgx/encl_piggy.S
> >  create mode 100644 tools/testing/selftests/x86/sgx/encl_piggy.h
> >  create mode 100644 tools/testing/selftests/x86/sgx/main.c
> >  create mode 100644 tools/testing/selftests/x86/sgx/sgx_call.S
> >  create mode 100644 tools/testing/selftests/x86/sgx/sgxsign.c
> >  create mode 100644 tools/testing/selftests/x86/sgx/signing_key.pem
> >
> > --
> > 2.19.1
> >
>
> I'm on leave for this week and next week's Monday if you wonder why I'm
> so passive in the discussion. Looking at the things next week's Tue.
>
> Just a quick comment about Andy's proposal. Probably pretty DSO like
> ELF blob could work with an addition of a section called ".tcs" for
> entry points. They need to be recognized so that the loader can add
> them as TCS pages.

Hmm.

There's a decent argument for specifically supporting whatever format
Windows uses.  There's also an argument for allowing one or more
enclaves to be bundled in a regular ELF DSO.  FWIW, there's no
fundamental reason we can't support more than one type of enclave
format.
