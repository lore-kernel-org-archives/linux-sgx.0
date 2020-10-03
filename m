Return-Path: <SRS0=MzOG=DK=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A501DC47420
	for <linux-sgx@archiver.kernel.org>; Sat,  3 Oct 2020 04:52:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68BFD23447
	for <linux-sgx@archiver.kernel.org>; Sat,  3 Oct 2020 04:52:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725896AbgJCEwA (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 3 Oct 2020 00:52:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:53602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725979AbgJCEv7 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 3 Oct 2020 00:51:59 -0400
Received: from localhost (83-245-197-237.elisa-laajakaista.fi [83.245.197.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B333D2226A;
        Sat,  3 Oct 2020 04:51:57 +0000 (UTC)
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     x86@kernel.org, linux-sgx@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-doc@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, bp@alien8.de, cedric.xing@intel.com,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, dave.hansen@intel.com, haitao.huang@intel.com,
        kai.huang@intel.com, kai.svahn@intel.com, kmoy@google.com,
        ludloff@google.com, luto@kernel.org, nhorman@redhat.com,
        npmccallum@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        tglx@linutronix.de, yaozhangx@google.com, mikko.ylinen@intel.com
Subject: [PATCH v39 23/24] docs: x86/sgx: Document SGX micro architecture and kernel internals
Date:   Sat,  3 Oct 2020 07:50:58 +0300
Message-Id: <20201003045059.665934-24-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201003045059.665934-1-jarkko.sakkinen@linux.intel.com>
References: <20201003045059.665934-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Document the Intel SGX kernel architecture. The fine-grained micro
architecture details can be looked up from Intel SDM Volume 3D.

Cc: linux-doc@vger.kernel.org
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 Documentation/x86/index.rst |   1 +
 Documentation/x86/sgx.rst   | 284 ++++++++++++++++++++++++++++++++++++
 2 files changed, 285 insertions(+)
 create mode 100644 Documentation/x86/sgx.rst

diff --git a/Documentation/x86/index.rst b/Documentation/x86/index.rst
index 740ee7f87898..b9db893c8aee 100644
--- a/Documentation/x86/index.rst
+++ b/Documentation/x86/index.rst
@@ -32,3 +32,4 @@ x86-specific Documentation
    i386/index
    x86_64/index
    sva
+   sgx
diff --git a/Documentation/x86/sgx.rst b/Documentation/x86/sgx.rst
new file mode 100644
index 000000000000..7b742c331247
--- /dev/null
+++ b/Documentation/x86/sgx.rst
@@ -0,0 +1,284 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===============================
+Software Guard eXtensions (SGX)
+===============================
+
+Architecture
+============
+
+*Software Guard eXtensions (SGX)* is a set of instructions that enable ring-3
+applications to set aside private regions of code and data. These regions are
+called enclaves. An enclave can be entered at a fixed set of entry points. Only
+a CPU running inside the enclave can access its code and data.
+
+The support can be determined by
+
+	``grep sgx /proc/cpuinfo``
+
+Enclave Page Cache
+==================
+
+SGX utilizes an *Enclave Page Cache (EPC)* to store pages that are associated
+with an enclave. It is contained in a BIOS-reserved region of physical memory.
+Unlike pages used for regular memory, pages can only be accessed outside the
+enclave for different purposes with the instructions **ENCLS**, **ENCLV** and
+**ENCLU**.
+
+Direct memory accesses at an enclave can be only done by a CPU executing inside
+the enclave. An enclave can be entered with **ENCLU[EENTER]** to a fixed set of
+entry points. However, a CPU executing inside the enclave can do outside memory
+accesses.
+
+Page Types
+----------
+
+**SGX Enclave Control Structure (SECS)**
+   Enclave's address range, attributes and other global data are defined
+   by this structure.
+
+**Regular (REG)**
+   Regular EPC pages contain the code and data of an enclave.
+
+**Thread Control Structure (TCS)**
+   Thread Control Structure pages define the entry points to an enclave and
+   track the execution state of an enclave thread.
+
+**Version Array (VA)**
+   Version Array pages contain 512 slots, each of which can contain a version
+   number for a page evicted from the EPC.
+
+Enclave Page Cache Map
+----------------------
+
+The processor tracks EPC pages via the *Enclave Page Cache Map (EPCM)*.  EPCM
+contains an entry for each EPC page, which describes the owning enclave, access
+rights and page type among the other things.
+
+The permissions from EPCM are consulted if and only if walking the kernel page
+tables succeeds. The total permissions are thus a conjunction between page table
+and EPCM permissions.
+
+For all intents and purposes, the SGX architecture allows the processor to
+invalidate all EPCM entries at will, i.e. requires that software be prepared to
+handle an EPCM fault at any time. The contents of EPC are encrypted with an
+ephemeral key, which is lost on power transitions.
+
+EPC management
+==============
+
+EPC pages do not have ``struct page`` instances. They are IO memory from kernel
+perspective. The consequence is that they are always mapped as shared memory.
+Kernel defines ``/dev/sgx/enclave`` that can be mapped as ``MAP_SHARED`` to
+define the address range for an enclave.
+
+EPC Over-subscription
+=====================
+
+When the amount of free EPC pages goes below a low watermark the swapping thread
+starts reclaiming pages. The pages that do not have the **A** bit set are
+selected as victim pages.
+
+Launch Control
+==============
+
+SGX provides a launch control mechanism. After all enclave pages have been
+copied, kernel executes **ENCLS[EINIT]**, which initializes the enclave. Only
+after this the CPU can execute inside the enclave.
+
+This leaf function takes an RSA-3072 signature of the enclave measurement and an
+optional cryptographic token. Linux does not take advantage of launch tokens.
+The leaf instruction checks that the measurement is correct and signature is
+signed with the key hashed to the four +**IA32_SGXLEPUBKEYHASH{0, 1, 2, 3}**
+MSRs representing the SHA256 of a public key.
+
+Those MSRs can be configured by the BIOS to be either readable or writable.
+Linux supports only writable configuration in order to give full control to the
+kernel on launch control policy. Readable configuration requires the use of
+previously mentioned launch tokens.
+
+The launch is performed by setting the MSRs to the hash of the enclave signer's
+public key. The alternative would be to have *a launch enclave* that would be
+signed with the key set into MSRs, which would then generate launch tokens for
+other enclaves. This would only make sense with read-only MSRs, and thus the
+option has been discarded.
+
+Attestation
+===========
+
+Local Attestation
+-----------------
+
+In local attestation, an enclave creates a **REPORT** data structure with
+**ENCLS[EREPORT]**, which describes the origin of an enclave. In particular, it
+contains a AES-CMAC of the enclave contents signed with a report key unique to
+each processor. All enclaves have access to this key.
+
+This mechanism can also be used in addition as a communication channel as the
+**REPORT** data structure includes a 64-byte field for variable information.
+
+Remote Attestation
+------------------
+
+Provisioning Certification Enclave (PCE), the root of trust for other enclaves,
+generates a signing key from a fused key called Provisioning Certification Key.
+PCE can then use this key to certify an attestation key of a Quoting Enclave
+(QE), e.g. we get the chain of trust down to the hardware if the Intel signed
+PCE is used.
+
+To use the needed keys, ATTRIBUTE.PROVISIONKEY is required but should be only
+allowed for those who actually need it so that only the trusted parties can
+certify QE's.
+
+A device file called /dev/sgx/provision exists to provide file descriptors that
+act as privilege tokens for building provisioning enclaves. These can be
+associated with enclaves with the ioctl SGX_IOC_ENCLAVE_SET_ATTRIBUTE.
+
+Encryption engines
+==================
+
+In order to conceal the enclave data while it is out of the CPU package,
+memory controller has to be extended with an encryption engine. MC can then
+route incoming requests coming from CPU cores running in enclave mode to the
+encryption engine.
+
+In CPUs prior to Icelake, Memory Encryption Engine (MEE) is used to
+encrypt pages leaving the CPU caches. MEE uses a n-ary Merkle tree with root in
+SRAM to maintain integrity of the encrypted data. This provides integrity and
+anti-replay protection but does not scale to large memory sizes because the time
+required to update the Merkle tree grows logarithmically in relation to the
+memory size.
+
+CPUs starting from Icelake use Total Memory Encryption (TME) in the place of
+MEE. SGX using TME does not have an integrity Merkle tree, which means losing HW
+protections from integrity and replay-attacks, but includes additional changes
+to prevent cipher text from being return and SW memory aliases from being
+created. DMA remains blocked by the PRMRR to the EPC memory even systems that
+use TME (SDM section 41.10).
+
+Backing storage
+===============
+
+Backing storage is shared and not accounted. It is implemented as a private
+shmem file. Providing a backing storage in some form from user space is not
+possible - accounting would go to invalid state as reclaimed pages would get
+accounted to the processes of which behalf the kernel happened to be acting on.
+
+Enclave Life Cycle
+==================
+
+Enclaves must be built before they can be executed (entered). The first step in
+building an enclave is opening the `/dev/sgx/enclave` device. Then, the enclave
+is built with ioctl's documented in `arch/x86/include/uapi/asm/sgx.h`.
+
+Since enclave memory is protected from direct access, special privileged
+instructions (name them here) are used to copy data into enclave pages and
+establish enclave page permissions within ioctl(SGX_whatever) calls.
+
+`mmap()` permissions are capped by the enclave permissions. A direct
+consequence of this is that all the pages for an address range must be added
+before `mmap()` can be applied. Effectively an enclave page with minimum
+permissions in the address range sets the permission cap for the mapping
+operation.
+
+SGX vDSO
+========
+
+The basic concept and implementation is very similar to the kernel's exception
+fixup mechanism.  The key differences are that the kernel handler is hardcoded
+and the fixup entry addresses are relative to the overall table as opposed to
+individual entries.
+
+Hardcoding the kernel handler avoids the need to figure out how to get userspace
+code to point at a kernel function.  Given that the expected usage is to
+propagate information to userspace, dumping all fault information into registers
+is likely the desired behavior for the vast majority of yet-to-be-created
+functions.  Use registers DI, SI and DX to communicate fault information, which
+follows Linux's ABI for register consumption and hopefully avoids conflict with
+hardware features that might leverage the fixup capabilities, e.g.  register
+usage for SGX instructions was at least partially designed with calling
+conventions in mind.
+
+Making fixup addresses relative to the overall table allows the table to be
+stripped from the final vDSO image (it's a kernel construct) without
+complicating the offset logic, e.g. entry-relative addressing would also need to
+account for the table's location relative to the image.
+
+Regarding stripping the table, modify vdso2c to extract the table from the raw,
+a.k.a. unstripped, data and dump it as a standalone byte array in the resulting
+.c file.  The original base of the table, its length and a pointer to the byte
+array are captured in struct vdso_image.  Alternatively, the table could be
+dumped directly into the struct, but because the number of entries can vary per
+image, that would require either hardcoding a max sized table into the struct
+definition or defining the table as a flexible length array.  The flexible
+length array approach has zero benefits, e.g. the base/size are still needed,
+and prevents reusing the extraction code, while hardcoding the max size adds
+ongoing maintenance just to avoid exporting the explicit size.
+
+The immediate use case is for Intel Software Guard Extensions (SGX).  SGX
+introduces a new CPL3-only "enclave" mode that runs as a sort of black box
+shared object that is hosted by an untrusted "normal" CPl3 process.
+
+Entering an enclave can only be done through SGX-specific instructions, EENTER
+and ERESUME, and is a non-trivial process.  Because of the complexity of
+transitioning to/from an enclave, the vast majority of enclaves are expected to
+utilize a library to handle the actual transitions.  This is roughly analogous
+to how e.g. libc implementations are used by most applications.
+
+Another crucial characteristic of SGX enclaves is that they can generate
+exceptions as part of their normal (at least as "normal" as SGX can be)
+operation that need to be handled *in* the enclave and/or are unique to SGX.
+
+And because they are essentially fancy shared objects, a process can host any
+number of enclaves, each of which can execute multiple threads simultaneously.
+
+Putting everything together, userspace enclaves will utilize a library that must
+be prepared to handle any and (almost) all exceptions any time at least one
+thread may be executing in an enclave.  Leveraging signals to handle the enclave
+exceptions is unpleasant, to put it mildly, e.g.  the SGX library must
+constantly (un)register its signal handler based on whether or not at least one
+thread is executing in an enclave, and filter and forward exceptions that aren't
+related to its enclaves.  This becomes particularly nasty when using multiple
+levels of libraries that register signal handlers, e.g. running an enclave via
+cgo inside of the Go runtime.
+
+Enabling exception fixup in vDSO allows the kernel to provide a vDSO function
+that wraps the low-level transitions to/from the enclave, i.e.  the EENTER and
+ERESUME instructions.  The vDSO function can intercept exceptions that would
+otherwise generate a signal and return the fault information directly to its
+caller, thus avoiding the need to juggle signal handlers.
+
+Note that unlike the kernel's _ASM_EXTABLE_HANDLE implementation, the 'C'
+version of _ASM_VDSO_EXTABLE_HANDLE doesn't use a pre-compiled assembly macro.
+Duplicating four lines of code is simpler than adding the necessary
+infrastructure to generate pre-compiled assembly and the intended benefit of
+massaging GCC's inlining algorithm is unlikely to realized in the vDSO any time
+soon, if ever.
+
+Usage Models
+============
+
+Shared Library
+--------------
+
+Sensitive data and the code that acts on it is partitioned from the application
+into a separate library. The library is then linked as a DSO which can be loaded
+into an enclave. The application can then make individual function calls into
+the enclave through special SGX instructions. A run-time within the enclave is
+configured to marshal function parameters into and out of the enclave and to
+call the correct library function.
+
+Application Container
+---------------------
+
+An application may be loaded into a container enclave which is specially
+configured with a library OS and run-time which permits the application to run.
+The enclave run-time and library OS work together to execute the application
+when a thread enters the enclave.
+
+References
+==========
+
+"Supporting Third Party Attestation for Intel® SGX with Intel® Data Center
+Attestation Primitives"
+   https://software.intel.com/sites/default/files/managed/f1/b8/intel-sgx-support-for-third-party-attestation.pdf
-- 
2.25.1

