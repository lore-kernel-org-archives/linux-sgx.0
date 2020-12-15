Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.2 required=3.0 tests=BAYES_00,FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2263C4361B
	for <linux-sgx@archiver.kernel.org>; Tue, 15 Dec 2020 05:34:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58B732229C
	for <linux-sgx@archiver.kernel.org>; Tue, 15 Dec 2020 05:34:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725775AbgLOFem (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 15 Dec 2020 00:34:42 -0500
Received: from out0-156.mail.aliyun.com ([140.205.0.156]:33685 "EHLO
        out0-156.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbgLOFem (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 15 Dec 2020 00:34:42 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047193;MF=sanqian.hcy@antgroup.com;NM=1;PH=DS;RN=26;SR=0;TI=SMTPD_---.J7GiJTp_1608010421;
Received: from sanqian-occlum-dev-ubuntu(mailfrom:sanqian.hcy@antgroup.com fp:SMTPD_---.J7GiJTp_1608010421)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 15 Dec 2020 13:33:46 +0800
Date:   Tue, 15 Dec 2020 13:43:22 +0800
From:   "=?UTF-8?B?SHVpLCBDaHVueWFuZw==?=" <sanqian.hcy@antgroup.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com, kai.huang@intel.com,
        kai.svahn@intel.com, kmoy@google.com, ludloff@google.com,
        luto@kernel.org, nhorman@redhat.com, npmccallum@redhat.com,
        puiterwijk@redhat.com, rientjes@google.com, tglx@linutronix.de,
        yaozhangx@google.com, mikko.ylinen@intel.com
Subject: Re: [PATCH v41 00/24] Intel SGX foundations
Message-ID: <20201215054313.GA522982@sanqian-occlum-dev-ubuntu>
References: <20201112220135.165028-1-jarkko@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201112220135.165028-1-jarkko@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Nov 13, 2020 at 12:01:11AM +0200, Jarkko Sakkinen wrote:
> Overview
> ========
> 
> Intel(R) SGX is new hardware functionality that can be used by
> applications to populate protected regions of user code and data called
> enclaves. Once activated, the new hardware protects enclave code and
> data from outside access and modification.
> 
> SGX implementations have existed on desktop processors for several
> years.  The upcoming 3rd Generation Intel Xeon Scalable Platform,
> code-named ???Ice Lake??? will also support SGX[1].
> 
> Use Cases
> =========
> 
> Enclaves provide a place to store secrets and process data with those
> secrets.  SGX has been used, for example, to decrypt video without
> exposing the decryption keys to nosy debuggers that might be used to
> subvert DRM.  Software has generally been rewritten specifically to run
> in enclaves, but there are also projects that try to run limited
> unmodified software in enclaves[2].
> 
> SGX hardware is available in public clouds today.  But, anyone wishing
> to use it must use a modified distribution or side-load SGX support[3].
> 
> Hardware Implementation
> =======================
> 
> New memory controller hardware encrypts data transparently before
> leaving the processor package.  The randomly-generated encryption key
> has a lifetime of exactly one power cycle.  This mitigates attacks
> originating outside the processor, like snooping DIMM traffic.
> 
> Important Kernel Touch Points
> =============================
> 
> Although statically carved out of normal DRAM, enclave memory can not be
> accessed or managed directly by the kernel and is marked by the firmware
> as ???Reserved???.  As a result, SGX support contains simple but analogous
> functionality to the core mm such as a page allocator and reclaim.
> 
> Entering and exiting enclaves is tricky business.  Enclaves are
> restricted from making system calls or taking interrupts directly.  The
> enclave will exit out to userspace before things like this can happen.
> A new vDSO exception mechanism is introduced to help smooth over some of
> the architectural rough edges and make the job of userspace easier.
> 
> This implementation is picky and will decline to work on hardware which
> is locked to Intel???s root of trust.
> 
> 1. https://newsroom.intel.com/news-releases/intel-xeon-scalable-platform-built-most-sensitive-workloads/
> 2. https://grapheneproject.io/
> 3. https://docs.microsoft.com/en-us/azure/confidential-computing/quick-create-portal
> 
> Other
> =====
> 
> Sean Christopherson is a major contributor to this series.  However, he
> has left Intel and his @intel.com address will soon be bouncing.  He
> does not have a email he wants us to substitute or put in .mailmap for
> now.  To avoid subjecting everyone to bounces, we have commented out his
> tag lines in the commit messages.
> 
> Originally the code was based on early prototyping work of Suresh S.
> 
> This patch set has been rebased on top of tip tree commit
> c3c30db1b191bb1640a08bbcc593c212affcab75.

Tested-by: Chunyang Hui <sanqian.hcy@antfin.com>

The Occlum project (https://occlum.io/) is a libOS built on top of Intel
SGX feature. We ran Occlum tests using v5.10 kernel with SGX patch v41 on
SGX hardware with the Flexible Launch Control (FLC) feature and didn't
find any problems. As Occlum core developers, we would like these patches
to be merged.

> v40 (2020-10-20):
> * Change copyright years to 2016-2020 in the all files added.
>   https://lore.kernel.org/linux-sgx/20201003143925.GB800720@kroah.com/
> * Remove dual licensing and use GPL 2.0 unconditionally.
>   https://lore.kernel.org/linux-sgx/20201003143925.GB800720@kroah.com/
> * Remove platform capabilities checks from sgx_validate_secs(), as they are
>   validated together with the SIGSTRUCT capabilities in
>   sgx_ioc_enclave_init().
>   https://lore.kernel.org/linux-sgx/20201005020819.124724-1-jarkko.sakkinen@linux.intel.com/
> * During the migration from radix_tree to xarray, the locks went missing
>   from sgx_encl_may_map(). Fix this by iterating with the enclave lock and
>   xarray lock held.
>   https://lore.kernel.org/linux-sgx/20201003195440.GD20115@casper.infradead.org/
> * Verify in the #PF handler that the faulted page has equal or higher build
>   time permissions than the VMA permissions (i.e. the subset of {VM_READ,
>   VM_WRITE, VM_EXECUTE} in vma->vm_flags). Trigger a bus error, if this not
>   the case. By doing this, mmap() and mprotect() can be allowed to map an
>   address range, which has unpopulated pages, because the required
>   invariant will be checked before new pages are inserted to the process
>   address space.
> * In the vDSO, do not save RBX before validating the reserved area of the
>   struct sgx_enclave_run.
>   https://lore.kernel.org/linux-sgx/20201006025703.GG15803@linux.intel.com/
> * Increase the reserved area to 256 bytes in struct sgx_enclave_run as
>   there needs to be some space for expansion given the evolution of
>   microarchitectures, the fact that there can be only one vDSO and possible
>   future extensions.
>   https://lore.kernel.org/linux-sgx/20201006213927.GA117517@linux.intel.com/
> * Change Copyright comments from '//' to '/* ... */'.
>   https://lore.kernel.org/linux-sgx/20201005084554.GA3403@infradead.org/
> * Fix the error fallback path in the SGX vDSO. RAX was not popped in the
>   error path.
>   https://lore.kernel.org/linux-sgx/20201017210204.GA64894@linux.intel.com/
> * Move mm list management, backing storage and refcounting code  to
>   ???x86/sgx: Add a page reclaimer???, as they are only needed by the page
>   reclaimer. Finally, change the patch position to be the very last after
>   the kselftest, so that the whole patch set can be tested easily with and
>   without the reclaimer.
> * Move sgx_xsave_size_tbl code from ???x86/sgx: Add SGX enclave driver??? to
>   ???x86/sgx: Add SGX_IOC_ENCLAVE_CREATE???. Comment the code and use
>   XFEATURE_YMM and XFEATURE_MAX as limits for the features.
> * Fix bug sgx_sanitize_section() that pages left dirty were not returned
>   back, which could lead to a memory leak. Rename unsanitized_page_list as
>   more intuitive and shorter laundry_list and document the function itself
>   and the call site.
> * Use vmalloc() to allocate an array of struct sgx_epc_page???s for struct
>   sgx_epc_section, in effect removing the need to store addresses inside
>   the page structures. This removes the artificial limit of 8 sections. The
>   section array is still statically allocated but now it is trivial to
>   increase its size later on.
> * Rest of the changes are documented in patch change logs as this is
>   preferred way for the x86 tree.
> 
> v39 (2020-10-03):
> * A new GIT tree location.
>   git://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-sgx.git
> * Return -ERESTARTSYS instead of -EINTR in SGX_IOC_ENCLAVE_ADD_PAGES.
>   https://lore.kernel.org/linux-sgx/20200917160322.GG8530@linux.intel.com/T/#u
> * Do not initialize 'encl_size' in sgx_encl_create before
>   sgx_validate_secs() is called.
>   https://lore.kernel.org/linux-sgx/20200921100356.GB5901@zn.tnic/
> * Revert 'count' back to struct sgx_enclave_add_pages, move the check of
>   -EIO to sgx_ioc_enclave_pages() instead of being buried in subfunctions.
>   https://lore.kernel.org/linux-sgx/20200921195822.GA58176@linux.intel.com/
> * Fix documentation for the 'encl' parameter in sgx_ioc_enclave_create(),
>   sgx_ioc_enclave_init() and sgx_ioc_enclave_provision().
>   https://lore.kernel.org/linux-sgx/20200921100356.GB5901@zn.tnic/
> * Refine sgx_ioc_enclave_create() kdoc to better describe the meaning and
>   purpose of SECS validation done by sgx_validate_secs().
>   https://lore.kernel.org/linux-sgx/20200921135107.GG5901@zn.tnic/
> * Improve documentation sgx_ioc_enclave_add_pages() on IO failures.
>   https://lore.kernel.org/linux-sgx/20200921194419.GA56547@linux.intel.com/
> * Fix a bug in __sgx_encl_add_page(). When get_user_pages() fails, we must
>   return -EFAULT instead of mistakenly returning the page count.
>   Reported by Haitao Huang.
> * Rewrite the commit message for vm_ops->mprotect() (courtesy of Dave Hansen)
>   https://lore.kernel.org/linux-sgx/32fc9df4-d4aa-6768-aa06-0035427b7535@intel.com/
> * Fix ptrace support coding style issues.
>   https://lore.kernel.org/linux-sgx/20200922154424.GL22660@zn.tnic/
> * Fix the documentation.
>   https://lore.kernel.org/linux-sgx/20200915112842.897265-24-jarkko.sakkinen@linux.intel.com/
> * Always write MSRs for the public key before EINIT.
>   https://lore.kernel.org/linux-sgx/20200921173514.GI5901@zn.tnic/
> * Categorically disabled enclaves from noexec partitions.
>   https://lore.kernel.org/linux-sgx/20200923135056.GD5160@linux.intel.com/
> * Properly document the EWB flow, i.e. why there is three trials for EWB.
>   https://lore.kernel.org/linux-sgx/20200922104538.GE22660@zn.tnic/
> * Add kdoc about batch processing to sgx_reclaim_pages().
>   https://lore.kernel.org/linux-sgx/20200922104538.GE22660@zn.tnic/
>   https://lore.kernel.org/linux-mm/20200929011438.GA31167@linux.intel.com/
> * Documentation fixes.
>   https://lore.kernel.org/linux-sgx/20200915112842.897265-1-jarkko.sakkinen@linux.intel.com/T/#me637011aba9f45698eba88ff195452c0491c07fe
> * SGX vDSO clean ups.
>   https://lore.kernel.org/linux-sgx/20200915112842.897265-1-jarkko.sakkinen@linux.intel.com/T/#ma2204bba8d8e8a09bf9164fc1bb5c55813997b4a
> * Add the commit message from "x86/vdso: Add support for exception fixup in vDSO functions" to Documentation/x86/sgx.rst
>   https://lore.kernel.org/linux-sgx/20200923220712.GU28545@zn.tnic/
> * Update correct attributes variable when allowing provisioning.
>   https://lore.kernel.org/linux-sgx/20201001220824.GA24069@linux.intel.com/T/#t
> * Remove sgx_exception and put its fields to sgx_exception.
>   https://lore.kernel.org/linux-sgx/20201002211212.620059-1-jarkko.sakkinen@linux.intel.com/T/#u
> * Remove 'exit_reason' and put EEXIT to 'self' field of sgx_enclave_run.
>   https://lore.kernel.org/linux-sgx/20201002211212.620059-1-jarkko.sakkinen@linux.intel.com/T/#u
> * Refine clarity of the field names in struct sgx_enclave_run and vsgx.S, and rewrite kdoc.
>   https://lore.kernel.org/linux-sgx/20201002211212.620059-1-jarkko.sakkinen@linux.intel.com/T/#u
> * Fix memory validation in vsgx.S. The reserved areas was not zero validated,
>   which causes unnecessary risk for memory corruption bugs. In effect, 'flags'
>   field can be  removed from struct sgx_enclave_run.
>   https://lore.kernel.org/linux-sgx/20201002211212.620059-1-jarkko.sakkinen@linux.intel.com/T/#u
> * Reduce the size of sgx_enclave_run from 256 bytes to 64 bytes, i.e. size of
>   a cache line. This leave 24 bytes of free space to waste in future.
>   https://lore.kernel.org/linux-sgx/20201002211212.620059-1-jarkko.sakkinen@linux.intel.com/T/#u
> * Verify atttributes, miscsselect and xfrm also in EINIT against SIGSTRUCT set
>   limits.
>   https://lore.kernel.org/linux-sgx/op.0rvxzr02wjvjmi@mqcpg7oapc828.gar.corp.intel.com/
> * Use plain lfence instead of retpoline in the vDSO because retpoline has
>   the potential to cause forward compatibility issues with the future
>   microarchitecture features. One such in already sight is CET-SS.
>   https://lore.kernel.org/linux-sgx/20200930163822.GA55565@linux.intel.com/T/#ma65748158e2b967dbc1d9ac3b214a1415066d61c
> 
> v38:
> * Fast iteration because I had email server issues with v37. Using
>   temporary SMTP for this (mail.kapsi.fi).
> * Return -EINTR when no data is processed, just like read().
>   https://patchwork.kernel.org/patch/11773941/
> * Remove cruft from SGX_IOC_ENCLAVE_ADD_PAGES and fix the return value.
>   https://lore.kernel.org/linux-sgx/20200915095450.GH3612@linux.intel.com/T/#mc643ef2ab477f5f7aa5d463d883d1308eb44d6f1
> 
> v37:
> * Remove MODULE_*().
>   https://lore.kernel.org/linux-sgx/20200825164412.GF12107@zn.tnic/
> * Fix mmap() type check.
>   https://lore.kernel.org/linux-sgx/20200827152051.GB22351@sjchrist-ice/
> * Fix ioctl-number.txt.
>   https://lore.kernel.org/linux-sgx/20200826145239.GC22390@zn.tnic/
> * Fix SPDX identifier in arch/x86/include/uapi/asm/sgx.h
>   https://lore.kernel.org/linux-sgx/20200826145239.GC22390@zn.tnic/
> * Consistently document "@encl: an enclave pointer".
>   https://lore.kernel.org/linux-sgx/20200826145239.GC22390@zn.tnic/
> * Renamed SGX_IOC_ENCLAVE_SET_ATTRIBUTE as SGX_IOC_ENCLAVE_PROVISION and
>   cleaned up associated code. Also fixed issues of code introduced too
>   early that were caused by the split. Now it should be more streamlined.
>   https://lore.kernel.org/linux-sgx/20200826145239.GC22390@zn.tnic/
> * Fixed signed integer shift overflow:
>   https://github.com/intel/linux-sgx-driver/pull/16/commits d27ca6071b2b28e2e789d265eda796dd9fc65a64
> * Fixed off-by-one error in a size calculation:
>   https://github.com/intel/SGXDataCenterAttestationPrimitives/commit/e44cc238becf584cc079aef40b557c6af9a03f38
> * Rework vDSO API with a context structure for IO data.
>   https://lore.kernel.org/linux-sgx/20200904104437.29555-1-sean.j.christopherson@intel.com/
> * Refined commentary about retry-loop with ENCLS[EINIT] based on Sean's response.
>   https://lore.kernel.org/linux-sgx/20200629152718.GA12312@linux.intel.com/
> * Return positive number from SGX_IOC_ENCLAVE_ADD_PAGES indicating the
>   number of pages processed and set a fixed 1MB limit for length. In addition,
>   on interrupt, return 0 and number of processed pages instead of -EINTR.
>   https://lore.kernel.org/linux-sgx/20200626153400.GE27151@zn.tnic/
> 
> v36:
> * Make a self-contained mprotect() handler.
> * Move from radix_tree to xarray, which is more modern and robust data
>   structure for managing large sparse arrays. Rename encl->page_tree as
>   encl->page_array.
> 
> v35:
> * Add missing SGX_ENCL_DEAD check to sgx_ioctl().
> 
> v34:
> * Remove SGX_ENCL_DEAD checks from ioctl.c, as the file is open while
>   executing an ioctl.
> * Split driver patch into base patch and one patch for each ioctl.
> * Move encl->flags check to the beginning of each ioctl. Return
>   consistently -EINVAL if they don't match the expected values. Before,
>   sometimes -EFAULT was returned instead of -EINVAL.
> * Rename vm_ops->may_mprotect as vm_ops->mprotect() and move the call
>   right before call to mprotect_fixup().
> 
> v33:
> * Rebased to v5.8-rc1. Given the core changes (mmap_lock and #DB
>   handling), it made sense to update the series.
> * Refined documentation about how remote attestation is done in SGX.
> 
> v32:
> * v31 contained not fully cleaned up main.c after merger of main.c and
>   reclaim.c. Fixed in this version.
> * Rebased to v5.7. Forgot to do this for v31.
> 
> v31:
> * Unset SGX_ENCL_IOCTL in the error path of checking encl->flags in order
>   to prevent leaving it set and thus block any further ioctl calls.
> * Added missing cleanup_srcu_struct() call to sgx_encl_release().
> * Take encl->lock in sgx_encl_add_page() in order to prevent races with
>   the page reclaimer.
> * Fix a use-after-free bug from the page reclaimer. Call kref_put() for
>   encl->refcount only after putting enclave page back to the active page
>   list because it could be the last ref to the enclave.
> * Filter any CPU disallowed values from sigstruct->vendor
>   SGX_IOC_ENCLAVE_INIT.
> * Use bits 0-7 of page descriptor for the EPC section index. This
>   should be enough for long term needs.
> * Refined naming for functions that allocate and free EPC pages to
>   be more sound and consistent.
> * Merge main.c and reclaim.c into one.
> 
> v30:
> Bunch of tags added. No actual code changes.
> 
> v29:
> * The selftest has been moved to selftests/sgx. Because SGX is an execution
>   environment of its own, it really isn't a great fit with more "standard"
>   x86 tests.
> 
>   The RSA key is now generated on fly and the whole signing process has
>   been made as part of the enclave loader instead of signing the enclave
>   during the compilation time.
> 
>   Finally, the enclave loader loads now the test enclave directly from its
>   ELF file, which means that ELF file does not need to be coverted as raw
>   binary during the build process.
> * Version the mm_list instead of using on synchronize_mm() when adding new
>   entries. We hold the write lock for the mm_struct, and dup_mm() can thus
>   deadlock with the page reclaimer, which could hold the lock for the old
>   mm_struct.
> * Disallow mmap(PROT_NONE) from /dev/sgx. Any mapping (e.g. anonymous) can
>   be used to reserve the address range. Now /dev/sgx supports only opaque
>   mappings to the (initialized) enclave data.
> * Make the vDSO callable directly from C by preserving RBX and taking leaf
>   from RCX.
> 
> v28:
> * Documented to Documentation/x86/sgx.rst how the kernel manages the
>   enclave ownership.
> * Removed non-LC flow from sgx_einit().
> * Removed struct sgx_einittoken since only the size of the corresponding
>   microarchitectural structure is used in the series ATM.
> 
> v27:
> * Disallow RIE processes to use enclaves as there could a permission
>   conflict between VMA and enclave permissions.
> * In the documentation, replace "grep /proc/cpuinfo" with
>   "grep sgx /proc/cpuinfo".
> 
> v26:
> * Fixed the commit author in "x86/sgx: Linux Enclave Driver", which was
>   changed in v25 by mistake.
> * Addressed a bunch of grammar mistakes in sgx.rst (thanks Randy once
>   again for such a detailed feedback).
> * Added back the MAINTAINERS update commit, which was mistakenly removed
>   in v25.
> * EREMOVE's for SECS cannot be done while sanitizing an EPC section. The
>   CPU does not allow to remove a SECS page before all of its children have
>   been removed, and a child page can be in some other section than the one
>   currently being processed. Thus, removed special SECS processing from
>   sgx_sanitize_page() and instead put sections through it twice. In the
>   2nd round the lists should only contain SECS pages.
> 
> v25:
> * Fix a double-free issue when SGX_IOC_ENCLAVE_ADD_PAGES
>   fails on executing ENCLS[EADD]. The rollback path executed
>   radix_tree_delete() on the same address twice when this happened.
> * Return -EINTR instead of -ERESTARTSYS in SGX_IOC_ENCLAVE_ADD_PAGES when
>   a signal is pending.
> * As requested by Borislav, move the CPUID 0x12 features to their own word
>   in cpufeatures.
> * Sean fixed a bug from sgx_reclaimer_write() where sgx_encl_put_backing()
>   was called with an uninitialized pointer when sgx_encl_get_backing()
>   fails.
> * Migrated /dev/sgx/* to misc. This is future-proof as struct miscdevice
>   has 'groups' for setting up sysfs attributes for the device.
> * Use device_initcall instead of subsys_initcall so that misc_class is
>   initialized before SGX is initialized.
> * Return -EACCES in SGX_IOC_ENCLAVE_INIT when caller tries to select
>   enclave attributes that we the kernel does not allow it to set instead
>   of -EINVAL.
> * Unless SGX public key MSRs are writable always deny the feature from
>   Linux. Previously this was only denied from driver. How VMs should be
>   supported is not really part of initial patch set, which makes this
>   an obvious choice.
> * Cleaned up and refined documentation to be more approachable.
> 
> v24:
> * Reclaim unmeasured and TCS pages (regression in v23).
> * Replace usages of GFP_HIGHUSER with GFP_KERNEL.
> * Return -EIO on when EADD or EEXTEND fails in %SGX_IOC_ENCLAVE_ADD_PAGES
>   and use the same rollback (destroy enclave). This can happen when host
>   suspends itself unknowingly to a VM running enclaves. From -EIO the user
>   space can deduce what happened.
> * Have a separate @count in struct sgx_enclave_add_pages to output number
>   of bytes processed instead of overwriting the input parameters for
>   clarity and more importantly that the API provides means for partial
>   processing (@count could be less than @length in success case).
> 
> v23:
> * Replace SGX_ENCLAVE_ADD_PAGE with SGX_ENCLAVE_ADD_PAGES. Replace @mrmask
>   with %SGX_PAGE_MEASURE flag.
> * Return -EIO instead of -ECANCELED when ptrace() fails to read a TCS page.
> * In the reclaimer, pin page before ENCLS[EBLOCK] because pinning can fail
>   (because of OOM) even in legit behaviour and after EBLOCK the reclaiming
>   flow can be only reverted by killing the whole enclave.
> * Fixed SGX_ATTR_RESERVED_MASK. Bit 7 was marked as reserved while in fact
>   it should have been bit 6 (Table 37-3 in the SDM).
> * Return -EPERM from SGX_IOC_ENCLAVE_INIT when ENCLS[EINIT] returns an SGX
>   error code.
> 
> v22:
> * Refined bunch commit messages and added associated SDM references as
>   many of them were too exhausting and some outdated.
> * Alignment checks have been removed from mmap() because it does not define
>   the ELRANGE. VMAs only act as windows to the enclave. The semantics
>   compare somewhat how mmap() works with regular files.
> * We now require user space addresses given to SGX_IOC_ENCLAVE_ADD_PAGE to be
>   page aligned so that we can pass the page directly to EADD and do not have
>   to do an extra copy. This was made effectively possible by removing the
>   worker thread for adding pages.
> * The selftest build files have been refined throughout of various glitches
>   and work properly in a cross compilation environment such as BuildRoot.
>   In addition, libcalls fail the build with an assertion in the linker
>   script, if they end up to the enclave binary.
> * CONFIG_INTEL_SGX_DRIVER has been removed because you cannot use SGX core
>   for anything without having the driver. This could change when KVM support
>   is added.
> * We require zero permissions in SECINFO for TCS pages because the CPU
>   overwrites SECINFO flags with zero permissions and measures the page
>   only after that. Allowing to pass TCS with non-zero permissions would
>   cause mismatching measurement between the one provided in SIGSTRUCT and
>   the one computed by the CPU.
> * Obviously lots of small fixes and clean ups (does make sense to
>   document them all).
> 
> v21:
> * Check on mmap() that the VMA does cover an area that does not have
>   enclave pages. Only mapping with PROT_NONE can do that to reserve
>   initial address space for an enclave.
> * Check om mmap() and mprotect() that the VMA permissions do not
>   surpass the enclave permissions.
> * Remove two refcounts from vma_close(): mm_list and encl->refcount.
>   Enclave refcount is only need for swapper/enclave sync and we can
>   remove mm_list refcount by destroying mm_struct when the process
>   is closed. By not having vm_close() the Linux MM can merge VMAs.
> * Do not naturally align MAP_FIXED address.
> * Numerous small fixes and clean ups.
> * Use SRCU for synchronizing the list of mm_struct's.
> * Move to stack based call convention in the vDSO.
> 
> v20:
> * Fine-tune Kconfig messages and spacing and remove MMU_NOTIFIER
>   dependency as MMU notifiers are no longer used in the driver.
> * Use mm_users instead of mm_count as refcount for mm_struct as mm_count
>   only protects from deleting mm_struct, not removing its contents.
> * Sanitize EPC when the reclaimer thread starts by doing EREMOVE for all
>   of them. They could be in initialized state when the kernel starts
>   because it might be spawned by kexec().
> * Documentation overhaul.
> * Use a device /dev/sgx/provision for delivering the provision token
>   instead of securityfs.
> * Create a reference to the enclave when already when opening
>   /dev/sgx/enclave.  The file is then associated with this enclave only.
>   mmap() can be done at free at any point and always get a reference to
>   the enclave. To summarize the file now represents the enclave.
> 
> v19:
> * Took 3-4 months but in some sense this was more like a rewrite of most
>   of the corners of the source code. If I've forgotten to deal with some
>   feedback, please don't shout me. Make a remark and I will fix it for
>   the next version. Hopefully there won't be this big turnovers anymore.
> * Validate SECS attributes properly against CPUID given attributes and
>   against allowed attributes. SECS attributes are the ones that are
>   enforced whereas SIGSTRUCT attributes tell what is required to run
>   the enclave.
> * Add KSS (Key Sharing Support) to the enclave attributes.
> * Deny MAP_PRIVATE as an enclave is always a shared memory entity.
> * Revert back to shmem backing storage so that it can be easily shared
>   by multiple processes.
> * Split the recognization of an ENCLS leaf failure by using three
>   functions to detect it: encsl_faulted(), encls_returned_code() and
>   sgx_failed(). encls_failed() is only caused by a spurious expections that
>   should never happen. Thus, it is not defined as an inline function in
>   order to easily insert a kprobe to it.
> * Move low-level enclave management routines, page fault handler and page
>   reclaiming routines from driver to the core. These cannot be separated
>   from each other as they are heavily interdependent. The rationale is that
>   the core does not call any code from the driver.
> * Allow the driver to be compiled as a module now that it no code is using
>   its routines and it only uses exported symbols. Now the driver is
>   essentially just a thin ioctl layer.
> * Reworked the driver to maintain a list of mm_struct's. The VMA callbacks
>   add new entries to this list as the process is forked. Each entry has
>   its own refcount because they have a different life-cycle as the enclave
>   does. In effect @tgid and @mm have been removed from struct sgx_encl
>   and we allow forking by removing VM_DONTCOPY from vm flags.
> * Generate a cpu mask in the reclaimer from the cpu mask's of all
>   mm_struct's. This will kick out the hardware threads out of the enclave
>   from multiple processes. It is not a local variable because it would
>   eat too much of the stack space but instead a field in struct
>   sgx_encl.
> * Allow forking i.e. remove VM_DONTCOPY. I did not change the API
>   because the old API scaled to the workload that Andy described. The
>   codebase is now mostly API independent i.e. changing the API is a
>   small task. For me the proper trigger to chanage it is a as concrete
>   as possible workload that cannot be fulfilled. I hope you understand
>   my thinking here. I don't want to change anything w/o proper basis
>   but I'm ready to change anything if there is a proper basis. I do
>   not have any kind of attachment to any particular type of API.
> * Add Sean's vDSO ENCLS(EENTER) patches and update selftest to use the
>   new vDSO.
> 
> v18:
> * Update the ioctl-number.txt.
> * Move the driver under arch/x86.
> * Add SGX features (SGX, SGX1, SGX2) to the disabled-features.h.
> * Rename the selftest as test_sgx (previously sgx-selftest).
> * In order to enable process accounting, swap EPC pages and PCMD's to a VMA
>   instead of shmem.
> * Allow only to initialize and run enclaves with a subset of
>   {DEBUG, MODE64BIT} set.
> * Add SGX_IOC_ENCLAVE_SET_ATTRIBUTE to allow an enclave to have privileged
>   attributes e.g. PROVISIONKEY.
> 
> v17:
> * Add a simple selftest.
> * Fix a null pointer dereference to section->pages when its
>   allocation fails.
> * Add Sean's description of the exception handling to the documentation.
> 
> v16:
> * Fixed SOB's in the commits that were a bit corrupted in v15.
> * Implemented exceptio handling properly to detect_sgx().
> * Use GENMASK() to define SGX_CPUID_SUB_LEAF_TYPE_MASK.
> * Updated the documentation to use rst definition lists.
> * Added the missing Documentation/x86/index.rst, which has a link to
>   intel_sgx.rst. Now the SGX and uapi documentation is properly generated
>   with 'make htmldocs'.
> * While enumerating EPC sections, if an undefined section is found, fail
>   the driver initialization instead of continuing the initialization.
> * Issue a warning if there are more than %SGX_MAX_EPC_SECTIONS.
> * Remove copyright notice from arch/x86/include/asm/sgx.h.
> * Migrated from ioremap_cache() to memremap().
> 
> v15:
> * Split into more digestable size patches.
> * Lots of small fixes and clean ups.
> * Signal a "plain" SIGSEGV on an EPCM violation.
> 
> v14:
> * Change the comment about X86_FEATURE_SGX_LC from ???SGX launch
>   configuration??? to ???SGX launch control???.
> * Move the SGX-related CPU feature flags as part of the Linux defined
>   virtual leaf 8.
> * Add SGX_ prefix to the constants defining the ENCLS leaf functions.
> * Use GENMASK*() and BIT*() in sgx_arch.h instead of raw hex numbers.
> * Refine the long description for CONFIG_INTEL_SGX_CORE.
> * Do not use pr_*_ratelimited()  in the driver. The use of the rate limited
>   versions is legacy cruft from the prototyping phase.
> * Detect sleep with SGX_INVALID_EINIT_TOKEN instead of counting power
>   cycles.
> * Manually prefix with ???sgx:??? in the core SGX code instead of redefining
>   pr_fmt.
> * Report if IA32_SGXLEPUBKEYHASHx MSRs are not writable in the driver
>   instead of core because it is a driver requirement.
> * Change prompt to bool in the entry for CONFIG_INTEL_SGX_CORE because the
>   default is ???n???.
> * Rename struct sgx_epc_bank as struct sgx_epc_section in order to match
>   the SDM.
> * Allocate struct sgx_epc_page instances one at a time.
> * Use ???__iomem void *??? pointers for the mapped EPC memory consistently.
> * Retry once on SGX_INVALID_TOKEN in sgx_einit() instead of counting power
>   cycles.
> * Call enclave swapping operations directly from the driver instead of
>   calling them .indirectly through struct sgx_epc_page_ops because indirect
>   calls are not required yet as the patch set does not contain the KVM
>   support.
> * Added special signal SEGV_SGXERR to notify about SGX EPCM violation
>   errors.
> 
> v13:
> * Always use SGX_CPUID constant instead of a hardcoded value.
> * Simplified and documented the macros and functions for ENCLS leaves.
> * Enable sgx_free_page() to free active enclave pages on demand
>   in order to allow sgx_invalidate() to delete enclave pages.
>   It no longer performs EREMOVE if a page is in the process of
>   being reclaimed.
> * Use PM notifier per enclave so that we don't have to traverse
>   the global list of active EPC pages to find enclaves.
> * Removed unused SGX_LE_ROLLBACK constant from uapi/asm/sgx.h
> * Always use ioremap() to map EPC banks as we only support 64-bit kernel.
> * Invalidate IA32_SGXLEPUBKEYHASH cache used by sgx_einit() when going
>   to sleep.
> 
> v12:
> * Split to more narrow scoped commits in order to ease the review process and
>   use co-developed-by tag for co-authors of commits instead of listing them in
>   the source files.
> * Removed cruft EXPORT_SYMBOL() declarations and converted to static variables.
> * Removed in-kernel LE i.e. this version of the SGX software stack only
>   supports unlocked IA32_SGXLEPUBKEYHASHx MSRs.
> * Refined documentation on launching enclaves, swapping and enclave
>   construction.
> * Refined sgx_arch.h to include alignment information for every struct that
>   requires it and removed structs that are not needed without an LE.
> * Got rid of SGX_CPUID.
> * SGX detection now prints log messages about firmware configuration issues.
> 
> v11:
> * Polished ENCLS wrappers with refined exception handling.
> * ksgxswapd was not stopped (regression in v5) in
>   sgx_page_cache_teardown(), which causes a leaked kthread after driver
>   deinitialization.
> * Shutdown sgx_le_proxy when going to suspend because its EPC pages will be
>   invalidated when resuming, which will cause it not function properly
>   anymore.
> * Set EINITTOKEN.VALID to zero for a token that is passed when
>   SGXLEPUBKEYHASH matches MRSIGNER as alloc_page() does not give a zero
>   page.
> * Fixed the check in sgx_edbgrd() for a TCS page. Allowed to read offsets
>   around the flags field, which causes a #GP. Only flags read is readable.
> * On read access memcpy() call inside sgx_vma_access() had src and dest
>   parameters in wrong order.
> * The build issue with CONFIG_KASAN is now fixed. Added undefined symbols
>   to LE even if ???KASAN_SANITIZE := false??? was set in the makefile.
> * Fixed a regression in the #PF handler. If a page has
>   SGX_ENCL_PAGE_RESERVED flag the #PF handler should unconditionally fail.
>   It did not, which caused weird races when trying to change other parts of
>   swapping code.
> * EPC management has been refactored to a flat LRU cache and moved to
>   arch/x86. The swapper thread reads a cluster of EPC pages and swaps all
>   of them. It can now swap from multiple enclaves in the same round.
> * For the sake of consistency with SGX_IOC_ENCLAVE_ADD_PAGE, return -EINVAL
>   when an enclave is already initialized or dead instead of zero.
> 
> v10:
> * Cleaned up anon inode based IPC between the ring-0 and ring-3 parts
>   of the driver.
> * Unset the reserved flag from an enclave page if EDBGRD/WR fails
>   (regression in v6).
> * Close the anon inode when LE is stopped (regression in v9).
> * Update the documentation with a more detailed description of SGX.
> 
> v9:
> * Replaced kernel-LE IPC based on pipes with an anonymous inode.
>   The driver does not require anymore new exports.
> 
> v8:
> * Check that public key MSRs match the LE public key hash in the
>   driver initialization when the MSRs are read-only.
> * Fix the race in VA slot allocation by checking the fullness
>   immediately after succeesful allocation.
> * Fix the race in hash mrsigner calculation between the launch
>   enclave and user enclaves by having a separate lock for hash
>   calculation.
> 
> v7:
> * Fixed offset calculation in sgx_edbgr/wr(). Address was masked with PAGE_MASK
>   when it should have been masked with ~PAGE_MASK.
> * Fixed a memory leak in sgx_ioc_enclave_create().
> * Simplified swapping code by using a pointer array for a cluster
>   instead of a linked list.
> * Squeezed struct sgx_encl_page to 32 bytes.
> * Fixed deferencing of an RSA key on OpenSSL 1.1.0.
> * Modified TC's CMAC to use kernel AES-NI. Restructured the code
>   a bit in order to better align with kernel conventions.
> 
> v6:
> * Fixed semaphore underrun when accessing /dev/sgx from the launch enclave.
> * In sgx_encl_create() s/IS_ERR(secs)/IS_ERR(encl)/.
> * Removed virtualization chapter from the documentation.
> * Changed the default filename for the signing key as signing_key.pem.
> * Reworked EPC management in a way that instead of a linked list of
>   struct sgx_epc_page instances there is an array of integers that
>   encodes address and bank of an EPC page (the same data as 'pa' field
>   earlier). The locking has been moved to the EPC bank level instead
>   of a global lock.
> * Relaxed locking requirements for EPC management. EPC pages can be
>   released back to the EPC bank concurrently.
> * Cleaned up ptrace() code.
> * Refined commit messages for new architectural constants.
> * Sorted includes in every source file.
> * Sorted local variable declarations according to the line length in
>   every function.
> * Style fixes based on Darren's comments to sgx_le.c.
> 
> v5:
> * Described IPC between the Launch Enclave and kernel in the commit messages.
> * Fixed all relevant checkpatch.pl issues that I have forgot fix in earlier
>   versions except those that exist in the imported TinyCrypt code.
> * Fixed spelling mistakes in the documentation.
> * Forgot to check the return value of sgx_drv_subsys_init().
> * Encapsulated properly page cache init and teardown.
> * Collect epc pages to a temp list in sgx_add_epc_bank
> * Removed SGX_ENCLAVE_INIT_ARCH constant.
> 
> v4:
> * Tied life-cycle of the sgx_le_proxy process to /dev/sgx.
> * Removed __exit annotation from sgx_drv_subsys_exit().
> * Fixed a leak of a backing page in sgx_process_add_page_req() in the
>   case when vm_insert_pfn() fails.
> * Removed unused symbol exports for sgx_page_cache.c.
> * Updated sgx_alloc_page() to require encl parameter and documented the
>   behavior (Sean Christopherson).
> * Refactored a more lean API for sgx_encl_find() and documented the behavior.
> * Moved #PF handler to sgx_fault.c.
> * Replaced subsys_system_register() with plain bus_register().
> * Retry EINIT 2nd time only if MSRs are not locked.
> 
> v3:
> * Check that FEATURE_CONTROL_LOCKED and FEATURE_CONTROL_SGX_ENABLE are set.
> * Return -ERESTARTSYS in __sgx_encl_add_page() when sgx_alloc_page() fails.
> * Use unused bits in epc_page->pa to store the bank number.
> * Removed #ifdef for WQ_NONREENTRANT.
> * If mmu_notifier_register() fails with -EINTR, return -ERESTARTSYS.
> * Added --remove-section=.got.plt to objcopy flags in order to prevent a
>   dummy .got.plt, which will cause an inconsistent size for the LE.
> * Documented sgx_encl_* functions.
> * Added remark about AES implementation used inside the LE.
> * Removed redundant sgx_sys_exit() from le/main.c.
> * Fixed struct sgx_secinfo alignment from 128 to 64 bytes.
> * Validate miscselect in sgx_encl_create().
> * Fixed SSA frame size calculation to take the misc region into account.
> * Implemented consistent exception handling to __encls() and __encls_ret().
> * Implemented a proper device model in order to allow sysfs attributes
>   and in-kernel API.
> * Cleaned up various "find enclave" implementations to the unified
>   sgx_encl_find().
> * Validate that vm_pgoff is zero.
> * Discard backing pages with shmem_truncate_range() after EADD.
> * Added missing EEXTEND operations to LE signing and launch.
> * Fixed SSA size for GPRS region from 168 to 184 bytes.
> * Fixed the checks for TCS flags. Now DBGOPTIN is allowed.
> * Check that TCS addresses are in ELRANGE and not just page aligned.
> * Require kernel to be compiled with X64_64 and CPU_SUP_INTEL.
> * Fixed an incorrect value for SGX_ATTR_DEBUG from 0x01 to 0x02.
> 
> v2:
> * get_rand_uint32() changed the value of the pointer instead of value
>   where it is pointing at.
> * Launch enclave incorrectly used sigstruct attributes-field instead of
>   enclave attributes-field.
> * Removed unused struct sgx_add_page_req from sgx_ioctl.c
> * Removed unused sgx_has_sgx2.
> * Updated arch/x86/include/asm/sgx.h so that it provides stub
>   implementations when sgx in not enabled.
> * Removed cruft rdmsr-calls from sgx_set_pubkeyhash_msrs().
> * return -ENOMEM in sgx_alloc_page() when VA pages consume too much space
> * removed unused global sgx_nr_pids
> * moved sgx_encl_release to sgx_encl.c
> * return -ERESTARTSYS instead of -EINTR in sgx_encl_init()
> 
> Jarkko Sakkinen (14):
>   x86/sgx: Add SGX architectural data structures
>   x86/sgx: Add wrappers for ENCLS functions
>   x86/cpu/intel: Add nosgx kernel parameter
>   x86/sgx: Add SGX page allocator functions
>   x86/sgx: Add SGX misc driver interface
>   x86/sgx: Add SGX_IOC_ENCLAVE_CREATE
>   x86/sgx: Add SGX_IOC_ENCLAVE_ADD_PAGES
>   x86/sgx: Add SGX_IOC_ENCLAVE_INIT
>   x86/sgx: Add SGX_IOC_ENCLAVE_PROVISION
>   selftests/x86: Add a selftest for SGX
>   x86/sgx: Add a page reclaimer
>   x86/sgx: Add ptrace() support for the SGX driver
>   docs: x86/sgx: Document SGX kernel architecture
>   x86/sgx: Update MAINTAINERS
> 
> Sean Christopherson (10):
>   x86/cpufeatures: x86/msr: Add Intel SGX hardware bits
>   x86/cpufeatures: x86/msr: Add Intel SGX Launch Control hardware bits
>   x86/sgx: Initialize metadata for Enclave Page Cache (EPC) sections
>   x86/mm: x86/sgx: Signal SIGSEGV with PF_SGX
>   x86/cpu/intel: Detect SGX support
>   mm: Add 'mprotect' hook to struct vm_operations_struct
>   x86/vdso: Add support for exception fixup in vDSO functions
>   x86/fault: Add helper function to sanitize error code
>   x86/traps: Attempt to fixup exceptions in vDSO before signaling
>   x86/vdso: Implement a vDSO for Intel SGX enclave call
> 
>  .../admin-guide/kernel-parameters.txt         |   2 +
>  .../userspace-api/ioctl/ioctl-number.rst      |   1 +
>  Documentation/x86/index.rst                   |   1 +
>  Documentation/x86/sgx.rst                     | 211 +++++
>  MAINTAINERS                                   |  13 +
>  arch/x86/Kconfig                              |  17 +
>  arch/x86/entry/vdso/Makefile                  |   8 +-
>  arch/x86/entry/vdso/extable.c                 |  46 ++
>  arch/x86/entry/vdso/extable.h                 |  28 +
>  arch/x86/entry/vdso/vdso-layout.lds.S         |   9 +-
>  arch/x86/entry/vdso/vdso.lds.S                |   1 +
>  arch/x86/entry/vdso/vdso2c.h                  |  50 +-
>  arch/x86/entry/vdso/vsgx.S                    | 151 ++++
>  arch/x86/include/asm/cpufeatures.h            |   2 +
>  arch/x86/include/asm/disabled-features.h      |   8 +-
>  arch/x86/include/asm/enclu.h                  |   9 +
>  arch/x86/include/asm/msr-index.h              |   8 +
>  arch/x86/include/asm/trap_pf.h                |   1 +
>  arch/x86/include/asm/vdso.h                   |   5 +
>  arch/x86/include/uapi/asm/sgx.h               | 168 ++++
>  arch/x86/kernel/cpu/Makefile                  |   1 +
>  arch/x86/kernel/cpu/feat_ctl.c                |  38 +-
>  arch/x86/kernel/cpu/sgx/Makefile              |   5 +
>  arch/x86/kernel/cpu/sgx/arch.h                | 338 ++++++++
>  arch/x86/kernel/cpu/sgx/driver.c              | 194 +++++
>  arch/x86/kernel/cpu/sgx/driver.h              |  29 +
>  arch/x86/kernel/cpu/sgx/encl.c                | 740 ++++++++++++++++++
>  arch/x86/kernel/cpu/sgx/encl.h                | 121 +++
>  arch/x86/kernel/cpu/sgx/encls.h               | 231 ++++++
>  arch/x86/kernel/cpu/sgx/ioctl.c               | 716 +++++++++++++++++
>  arch/x86/kernel/cpu/sgx/main.c                | 731 +++++++++++++++++
>  arch/x86/kernel/cpu/sgx/sgx.h                 |  77 ++
>  arch/x86/kernel/traps.c                       |  10 +
>  arch/x86/mm/fault.c                           |  45 +-
>  include/linux/mm.h                            |   7 +
>  mm/mprotect.c                                 |   7 +
>  tools/testing/selftests/Makefile              |   1 +
>  tools/testing/selftests/sgx/.gitignore        |   2 +
>  tools/testing/selftests/sgx/Makefile          |  53 ++
>  tools/testing/selftests/sgx/call.S            |  44 ++
>  tools/testing/selftests/sgx/defines.h         |  21 +
>  tools/testing/selftests/sgx/load.c            | 277 +++++++
>  tools/testing/selftests/sgx/main.c            | 246 ++++++
>  tools/testing/selftests/sgx/main.h            |  38 +
>  tools/testing/selftests/sgx/sigstruct.c       | 391 +++++++++
>  tools/testing/selftests/sgx/test_encl.c       |  20 +
>  tools/testing/selftests/sgx/test_encl.lds     |  40 +
>  .../selftests/sgx/test_encl_bootstrap.S       |  89 +++
>  48 files changed, 5232 insertions(+), 19 deletions(-)
>  create mode 100644 Documentation/x86/sgx.rst
>  create mode 100644 arch/x86/entry/vdso/extable.c
>  create mode 100644 arch/x86/entry/vdso/extable.h
>  create mode 100644 arch/x86/entry/vdso/vsgx.S
>  create mode 100644 arch/x86/include/asm/enclu.h
>  create mode 100644 arch/x86/include/uapi/asm/sgx.h
>  create mode 100644 arch/x86/kernel/cpu/sgx/Makefile
>  create mode 100644 arch/x86/kernel/cpu/sgx/arch.h
>  create mode 100644 arch/x86/kernel/cpu/sgx/driver.c
>  create mode 100644 arch/x86/kernel/cpu/sgx/driver.h
>  create mode 100644 arch/x86/kernel/cpu/sgx/encl.c
>  create mode 100644 arch/x86/kernel/cpu/sgx/encl.h
>  create mode 100644 arch/x86/kernel/cpu/sgx/encls.h
>  create mode 100644 arch/x86/kernel/cpu/sgx/ioctl.c
>  create mode 100644 arch/x86/kernel/cpu/sgx/main.c
>  create mode 100644 arch/x86/kernel/cpu/sgx/sgx.h
>  create mode 100644 tools/testing/selftests/sgx/.gitignore
>  create mode 100644 tools/testing/selftests/sgx/Makefile
>  create mode 100644 tools/testing/selftests/sgx/call.S
>  create mode 100644 tools/testing/selftests/sgx/defines.h
>  create mode 100644 tools/testing/selftests/sgx/load.c
>  create mode 100644 tools/testing/selftests/sgx/main.c
>  create mode 100644 tools/testing/selftests/sgx/main.h
>  create mode 100644 tools/testing/selftests/sgx/sigstruct.c
>  create mode 100644 tools/testing/selftests/sgx/test_encl.c
>  create mode 100644 tools/testing/selftests/sgx/test_encl.lds
>  create mode 100644 tools/testing/selftests/sgx/test_encl_bootstrap.S
> 
> -- 
> 2.27.0
> 
