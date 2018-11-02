Return-Path: <SRS0=bY9v=NN=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CCEDC65C22
	for <linux-sgx@archiver.kernel.org>; Fri,  2 Nov 2018 23:19:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CBC7E20657
	for <linux-sgx@archiver.kernel.org>; Fri,  2 Nov 2018 23:19:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CBC7E20657
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728386AbeKCI3B (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 3 Nov 2018 04:29:01 -0400
Received: from mga06.intel.com ([134.134.136.31]:32066 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726705AbeKCI3B (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 3 Nov 2018 04:29:01 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Nov 2018 16:19:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.54,457,1534834800"; 
   d="scan'208";a="270988522"
Received: from btyborox-mobl.ger.corp.intel.com (HELO localhost) ([10.249.254.138])
  by orsmga005.jf.intel.com with ESMTP; 02 Nov 2018 16:19:42 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     x86@kernel.org, platform-driver-x86@vger.kernel.org,
        linux-sgx@vger.kernel.org
Cc:     dave.hansen@intel.com, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        mark.shanahan@intel.com, andriy.shevchenko@linux.intel.com,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v15 23/23] x86/sgx: Driver documentation
Date:   Sat,  3 Nov 2018 01:11:22 +0200
Message-Id: <20181102231320.29164-24-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181102231320.29164-1-jarkko.sakkinen@linux.intel.com>
References: <20181102231320.29164-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org
Message-ID: <20181102231122.fLVm02ozfhkSj1UQ6GrB4URaI6WAjCARp16FsuI9Wq8@z>

Documentation of the features of the Software Guard eXtensions used
by the Linux kernel and basic design choices for the core and driver
and functionality.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 Documentation/index.rst         |   1 +
 Documentation/x86/intel_sgx.rst | 185 ++++++++++++++++++++++++++++++++
 2 files changed, 186 insertions(+)
 create mode 100644 Documentation/x86/intel_sgx.rst

diff --git a/Documentation/index.rst b/Documentation/index.rst
index 5db7e87c7cb1..1cdc139adb40 100644
--- a/Documentation/index.rst
+++ b/Documentation/index.rst
@@ -104,6 +104,7 @@ implementation.
    :maxdepth: 2
 
    sh/index
+   x86/index
 
 Filesystem Documentation
 ------------------------
diff --git a/Documentation/x86/intel_sgx.rst b/Documentation/x86/intel_sgx.rst
new file mode 100644
index 000000000000..f6b7979c41f2
--- /dev/null
+++ b/Documentation/x86/intel_sgx.rst
@@ -0,0 +1,185 @@
+===================
+Intel(R) SGX driver
+===================
+
+Introduction
+============
+
+Intel(R) SGX is a set of CPU instructions that can be used by applications to
+set aside private regions of code and data. The code outside the enclave is
+disallowed to access the memory inside the enclave by the CPU access control.
+In a way you can think that SGX provides inverted sandbox. It protects the
+application from a malicious host.
+
+You can tell if your CPU supports SGX by looking into ``/proc/cpuinfo``:
+
+	``cat /proc/cpuinfo  | grep sgx``
+
+Overview of SGX
+===============
+
+SGX has a set of data structures to maintain information about the enclaves and
+their security properties. BIOS reserves a fixed size region of physical memory
+for these structures by setting Processor Reserved Memory Range Registers
+(PRMRR).
+
+This memory range is protected from outside access by the CPU and all the data
+coming in and out of the CPU package is encrypted by a key that is generated for
+each boot cycle.
+
+Enclaves execute in ring-3 in a special enclave submode using pages from the
+reserved memory range. A fixed logical address range for the enclave is reserved
+by ENCLS(ECREATE), a leaf instruction used to create enclaves. It is referred in
+the documentation commonly as the ELRANGE.
+
+Every memory access to the ELRANGE is asserted by the CPU. If the CPU is not
+executing in the enclave mode inside the enclave, #GP is raised. On the other
+hand enclave code can make memory accesses both inside and outside of the
+ELRANGE.
+
+Enclave can only execute code inside the ELRANGE. Instructions that may cause
+VMEXIT, IO instructions and instructions that require a privilege change are
+prohibited inside the enclave. Interrupts and exceptions always cause enclave
+to exit and jump to an address outside the enclave given when the enclave is
+entered by using the leaf instruction ENCLS(EENTER).
+
+Data types
+----------
+
+The protected memory range contains the following data:
+
+* **Enclave Page Cache (EPC):** protected pages
+* **Enclave Page Cache Map (EPCM):** a database that describes the state of the
+  pages and link them to an enclave.
+
+EPC has a number of different types of pages:
+
+* **SGX Enclave Control Structure (SECS)**: describes the global
+  properties of an enclave.
+* **Regular (REG):** code and data pages in the ELRANGE.
+* **Thread Control Structure (TCS):** pages that define entry points inside an
+  enclave. The enclave can only be entered through these entry points and each
+  can host a single hardware thread at a time.
+* **Version Array (VA)**: 64-bit version numbers for pages that have been
+  swapped outside the enclave. Each page contains 512 version numbers.
+
+Launch control
+--------------
+
+To launch an enclave, two structures must be provided for ENCLS(EINIT):
+
+1. **SIGSTRUCT:** signed measurement of the enclave binary.
+2. **EINITTOKEN:** a cryptographic token CMAC-signed with a AES256-key called
+   *launch key*, which is re-generated for each boot cycle.
+
+The CPU holds a SHA256 hash of a 3072-bit RSA public key inside
+IA32_SGXLEPUBKEYHASHn MSRs. Enclaves with a SIGSTRUCT that is signed with this
+key do not require a valid EINITTOKEN and can be authorized with special
+privileges. One of those privileges is ability to acquire the launch key with
+ENCLS(EGETKEY).
+
+**IA32_FEATURE_CONTROL[17]** is used by the BIOS configure whether
+IA32_SGXLEPUBKEYHASH MSRs are read-only or read-write before locking the
+feature control register and handing over control to the operating system.
+
+Enclave construction
+--------------------
+
+The construction is started by filling out the SECS that contains enclave
+address range, privileged attributes and measurement of TCS and REG pages (pages
+that will be mapped to the address range) among the other things. This structure
+is passed out to the ENCLS(ECREATE) together with a physical address of a page
+in EPC that will hold the SECS.
+
+The pages are added with ENCLS(EADD) and measured with ENCLS(EEXTEND) i.e.
+SHA256 hash MRENCLAVE residing in the SECS is extended with the page data.
+
+After all of the pages have been added, the enclave is initialized with
+ENCLS(EINIT). ENCLS(INIT) checks that the SIGSTRUCT is signed with the contained
+public key. If the given EINITTOKEN has the valid bit set, the CPU checks that
+the token is valid (CMAC'd with the launch key). If the token is not valid,
+the CPU will check whether the enclave is signed with a key matching to the
+IA32_SGXLEPUBKEYHASHn MSRs.
+
+Swapping pages
+--------------
+
+Enclave pages can be swapped out with ENCLS(EWB) to the unprotected memory. In
+addition to the EPC page, ENCLS(EWB) takes in a VA page and address for PCMD
+structure (Page Crypto MetaData) as input. The VA page will seal a version
+number for the page. PCMD is 128 byte structure that contains tracking
+information for the page, most importantly its MAC. With these structures the
+enclave is sealed and rollback protected while it resides in the unprotected
+memory.
+
+Before the page can be swapped out it must not have any active TLB references.
+ENCLS(EBLOCK) instruction moves a page to the *blocked* state, which means
+that no new TLB entries can be created to it by the hardware threads.
+
+After this a shootdown sequence is started with ENCLS(ETRACK), which sets an
+increased counter value to the entering hardware threads. ENCLS(EWB) will
+return SGX_NOT_TRACKED error while there are still threads with the earlier
+couner value because that means that there might be hardware thread inside
+the enclave with TLB entries to pages that are to be swapped.
+
+Kernel internals
+================
+
+Requirements
+------------
+
+Because SGX has an ever evolving and expanding feature set, it's possible for
+a BIOS or VMM to configure a system in such a way that not all CPUs are equal,
+e.g. where Launch Control is only enabled on a subset of CPUs.  Linux does
+*not* support such a heterogeneous system configuration, nor does it even
+attempt to play nice in the face of a misconfigured system.  With the exception
+of Launch Control's hash MSRs, which can vary per CPU, Linux assumes that all
+CPUs have a configuration that is identical to the boot CPU.
+
+
+Roles and responsibilities
+--------------------------
+
+SGX introduces system resources, e.g. EPC memory, that must be accessible to
+multiple entities, e.g. the native kernel driver (to expose SGX to userspace)
+and KVM (to expose SGX to VMs), ideally without introducing any dependencies
+between each SGX entity.  To that end, the kernel owns and manages the shared
+system resources, i.e. the EPC and Launch Control MSRs, and defines functions
+that provide appropriate access to the shared resources.  SGX support for
+user space and VMs is left to the SGX platform driver and KVM respectively.
+
+Launching enclaves
+------------------
+
+The current kernel implementation supports only unlocked MSRs i.e.
+FEATURE_CONTROL_SGX_LE_WR must be set. The launch is performed by setting the
+MSRs to the hash of the public key modulus of the enclave signer, which is one
+f the fields in the SIGSTRUCT.
+
+EPC management
+--------------
+
+Due to the unique requirements for swapping EPC pages, and because EPC pages
+(currently) do not have associated page structures, management of the EPC is
+not handled by the standard Linux swapper.  SGX directly handles swapping
+of EPC pages, including a kthread to initiate reclaim and a rudimentary LRU
+mechanism. The consumers of EPC pages, e.g. the SGX driver, are required to
+implement function callbacks that can be invoked by the kernel to age,
+swap, and/or forcefully reclaim a target EPC page.  In effect, the kernel
+controls what happens and when, while the consumers (driver, KVM, etc..) do
+the actual work.
+
+SGX uapi
+========
+
+.. kernel-doc:: drivers/platform/x86/intel_sgx/sgx_ioctl.c
+   :functions: sgx_ioc_enclave_create
+               sgx_ioc_enclave_add_page
+               sgx_ioc_enclave_init
+
+.. kernel-doc:: arch/x86/include/uapi/asm/sgx.h
+
+References
+==========
+
+* System Programming Manual: 39.1.4 Intel® SGX Launch Control Configuration
-- 
2.19.1

