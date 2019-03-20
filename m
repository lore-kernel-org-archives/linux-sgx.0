Return-Path: <SRS0=REdw=RX=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3180C43381
	for <linux-sgx@archiver.kernel.org>; Wed, 20 Mar 2019 16:26:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A7472146E
	for <linux-sgx@archiver.kernel.org>; Wed, 20 Mar 2019 16:26:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbfCTQ01 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 20 Mar 2019 12:26:27 -0400
Received: from mga01.intel.com ([192.55.52.88]:41632 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726860AbfCTQ00 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 20 Mar 2019 12:26:26 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Mar 2019 09:26:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,249,1549958400"; 
   d="scan'208";a="135715965"
Received: from sorenthe-mobl1.ger.corp.intel.com (HELO localhost) ([10.249.254.203])
  by orsmga003.jf.intel.com with ESMTP; 20 Mar 2019 09:26:15 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     akpm@linux-foundation.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v19,RESEND 25/27] x86/sgx: SGX documentation
Date:   Wed, 20 Mar 2019 18:21:17 +0200
Message-Id: <20190320162119.4469-26-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190320162119.4469-1-jarkko.sakkinen@linux.intel.com>
References: <20190320162119.4469-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=a
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Documentation of the features of the Software Guard eXtensions (SGX),
the basic design choices for the core and driver functionality and
the UAPI.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 Documentation/index.rst     |   1 +
 Documentation/x86/index.rst |  10 ++
 Documentation/x86/sgx.rst   | 234 ++++++++++++++++++++++++++++++++++++
 3 files changed, 245 insertions(+)
 create mode 100644 Documentation/x86/index.rst
 create mode 100644 Documentation/x86/sgx.rst

diff --git a/Documentation/index.rst b/Documentation/index.rst
index 80a421cb935e..3511400dc092 100644
--- a/Documentation/index.rst
+++ b/Documentation/index.rst
@@ -102,6 +102,7 @@ implementation.
    :maxdepth: 2
 
    sh/index
+   x86/index
 
 Filesystem Documentation
 ------------------------
diff --git a/Documentation/x86/index.rst b/Documentation/x86/index.rst
new file mode 100644
index 000000000000..f137d7109052
--- /dev/null
+++ b/Documentation/x86/index.rst
@@ -0,0 +1,10 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+======================
+x86 Architecture Guide
+======================
+
+.. toctree::
+   :maxdepth: 2
+
+   sgx
diff --git a/Documentation/x86/sgx.rst b/Documentation/x86/sgx.rst
new file mode 100644
index 000000000000..72c3ea2e8889
--- /dev/null
+++ b/Documentation/x86/sgx.rst
@@ -0,0 +1,234 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+==================================
+Intel(R) Software Guard eXtensions
+==================================
+
+Introduction
+============
+
+Intel(R) SGX is a set of CPU instructions that can be used by applications to
+set aside private regions of code and data. The code outside the enclave is
+disallowed to access the memory inside the enclave by the CPU access control.
+In a way you can think that SGX provides an inverted sandbox. It protects the
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
+Enclaves execute in ring 3 in a special enclave submode using pages from the
+reserved memory range. A fixed logical address range for the enclave is reserved
+by ENCLS(ECREATE), a leaf instruction used to create enclaves. It is referred to
+in the documentation commonly as the *ELRANGE*.
+
+Every memory access to the ELRANGE is asserted by the CPU. If the CPU is not
+executing in the enclave mode inside the enclave, #GP is raised. On the other
+hand, enclave code can make memory accesses both inside and outside of the
+ELRANGE.
+
+An enclave can only execute code inside the ELRANGE. Instructions that may cause
+VMEXIT, IO instructions and instructions that require a privilege change are
+prohibited inside the enclave. Interrupts and exceptions always cause an enclave
+to exit and jump to an address outside the enclave given when the enclave is
+entered by using the leaf instruction ENCLS(EENTER).
+
+Protected memory
+----------------
+
+Enclave Page Cache (EPC)
+    Physical pages used with enclaves that are protected by the CPU from
+    unauthorized access.
+
+Enclave Page Cache Map (EPCM)
+    A database that describes the properties and state of the pages e.g. their
+    permissions or which enclave they belong to.
+
+Memory Encryption Engine (MEE) integrity tree
+    Autonomously updated integrity tree. The root of the tree located in on-die
+    SRAM.
+
+EPC data types
+--------------
+
+SGX Enclave Control Structure (SECS)
+    Describes the global properties of an enclave. Will not be mapped to the
+    ELRANGE.
+
+Regular (REG)
+    These pages contain code and data.
+
+Thread Control Structure (TCS)
+    The pages that define the entry points inside an enclave. An enclave can
+    only be entered through these entry points and each can host a single
+    hardware thread at a time.
+
+Version Array (VA)
+   The pages contain 64-bit version numbers for pages that have been swapped
+   outside the enclave. Each page has the capacity of 512 version numbers.
+
+Launch control
+--------------
+
+To launch an enclave, two structures must be provided for ENCLS(EINIT):
+
+1. **SIGSTRUCT:** signed measurement of the enclave binary.
+2. **EINITTOKEN:** a cryptographic token CMAC-signed with a AES256-key called
+   *launch key*, which is regenerated for each boot cycle.
+
+The CPU holds a SHA256 hash of a 3072-bit RSA public key inside
+IA32_SGXLEPUBKEYHASHn MSRs. Enclaves with a SIGSTRUCT that is signed with this
+key do not require a valid EINITTOKEN and can be authorized with special
+privileges. One of those privileges is ability to acquire the launch key with
+ENCLS(EGETKEY).
+
+**IA32_FEATURE_CONTROL[SGX_LE_WR]** is used by the BIOS configure whether
+IA32_SGXLEPUBKEYHASH MSRs are read-only or read-write before locking the feature
+control register and handing over control to the operating system.
+
+Enclave construction
+--------------------
+
+The construction is started by filling out the SECS that contains enclave
+address range, privileged attributes and measurement of TCS and REG pages (pages
+that will be mapped to the address range) among the other things. This structure
+is passed to the ENCLS(ECREATE) together with a physical address of a page in
+EPC that will hold the SECS.
+
+The pages are added with ENCLS(EADD) and measured with ENCLS(EEXTEND), i.e.
+SHA256 hash MRENCLAVE residing in the SECS is extended with the page data.
+
+After all of the pages have been added, the enclave is initialized with
+ENCLS(EINIT). It will check that the SIGSTRUCT is signed with the contained
+public key. If the given EINITTOKEN has the valid bit set, the CPU checks that
+the token is valid (CMAC'd with the launch key). If the token is not valid,
+the CPU will check whether the enclave is signed with a key matching to the
+IA32_SGXLEPUBKEYHASHn MSRs.
+
+Swapping pages
+--------------
+
+Enclave pages can be swapped out with the *ENCLS(EWB)* instruction to the
+unprotected memory. In addition to the EPC page, ENCLS(EWB) takes in a VA page
+and address for PCMD structure (Page Crypto MetaData) as input. The VA page will
+seal a version number for the page. PCMD is 128-byte structure that contains
+tracking information for the page, most importantly its MAC. With these
+structures the enclave is sealed and rollback protected while it resides in the
+unprotected memory.
+
+Before the page can be swapped out it must not have any active TLB references.
+The *ENCLS(EBLOCK)* instruction moves a page to the *blocked* state, which means
+that no new TLB entries can be created to it by the hardware threads.
+
+After this a shootdown sequence is started with the *ENCLS(ETRACK)* instruction,
+which sets an increased counter value to the entering hardware threads.
+ENCLS(EWB) will return *SGX_NOT_TRACKED* error while there are still threads
+with the earlier counter value because that means that there might be hardware
+threads inside the enclave with TLB entries to pages that are to be swapped.
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
+The current kernel implementation supports only writable MSRs. The launch is
+performed by setting the MSRs to the hash of the public key modulus of the
+enclave signer and a token with the valid bit set to zero.
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
+Exception handling
+------------------
+
+The PF_SGX bit is set if and only if the #PF is detected by the SGX Enclave Page
+Cache Map (EPCM). The EPCM is a hardware-managed table that enforces accesses to
+an enclave's EPC pages in addition to the software-managed kernel page tables,
+i.e. the effective permissions for an EPC page are a logical AND of the kernel's
+page tables and the corresponding EPCM entry.
+
+The EPCM is consulted only after an access walks the kernel's page tables, i.e.:
+
+1. the access was allowed by the kernel
+2. the kernel's tables have become less restrictive than the EPCM
+3. the kernel cannot fixup the cause of the fault
+
+Notably, (2) implies that either the kernel has botched the EPC mappings or the
+EPCM has been invalidated (see below).  Regardless of why the fault occurred,
+userspace needs to be alerted so that it can take appropriate action, e.g.
+restart the enclave. This is reinforced by (3) as the kernel doesn't really
+have any other reasonable option, i.e. signalling SIGSEGV is actually the least
+severe action possible.
+
+Although the primary purpose of the EPCM is to prevent a malicious or
+compromised kernel from attacking an enclave, e.g. by modifying the enclave's
+page tables, do not WARN on a #PF with PF_SGX set. The SGX architecture
+effectively allows the CPU to invalidate all EPCM entries at will and requires
+that software be prepared to handle an EPCM fault at any time.  The architecture
+defines this behavior because the EPCM is encrypted with an ephemeral key that
+isn't exposed to software.  As such, the EPCM entries cannot be preserved across
+transitions that result in a new key being used, e.g. CPU power down as part of
+an S3 transition or when a VM is live migrated to a new physical system.
+
+SGX UAPI
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
+* A Memory Encryption Engine Suitable for General Purpose Processors
+  <https://eprint.iacr.org/2016/204.pdf>
+* System Programming Manual: 39.1.4 Intel® SGX Launch Control Configuration
-- 
2.19.1

