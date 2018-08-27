From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: <x86@kernel.org>, <platform-driver-x86@vger.kernel.org>
CC: <dave.hansen@intel.com>, <sean.j.christopherson@intel.com>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, <linux-sgx@vger.kernel.org>,
	Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Thomas Gleixner
	<tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin"
	<hpa@zytor.com>, "open list:X86 ARCHITECTURE (32-BIT AND        64-BIT)"
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v13 04/13] x86/sgx: Architectural structures
Date: Mon, 27 Aug 2018 21:53:25 +0300
Message-ID: <20180827185507.17087-5-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <20180827185507.17087-1-jarkko.sakkinen@linux.intel.com>
References: <20180827185507.17087-1-jarkko.sakkinen@linux.intel.com>
Sender: <platform-driver-x86-owner@vger.kernel.org>
Content-Type: text/plain
Return-Path: platform-driver-x86-owner@vger.kernel.org
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

Add arch/x86/include/asm/sgx_arch.h, which contains definitions for the
architectural data structures used by the CPU to implement the SGX.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/include/asm/sgx_arch.h       | 379 ++++++++++++++++++++++++++
 arch/x86/include/uapi/asm/sgx_errno.h |  91 +++++++
 2 files changed, 470 insertions(+)
 create mode 100644 arch/x86/include/asm/sgx_arch.h
 create mode 100644 arch/x86/include/uapi/asm/sgx_errno.h

diff --git a/arch/x86/include/asm/sgx_arch.h b/arch/x86/include/asm/sgx_arch.h
new file mode 100644
index 000000000000..395123d7c13f
--- /dev/null
+++ b/arch/x86/include/asm/sgx_arch.h
@@ -0,0 +1,379 @@
+// SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
+// Copyright(c) 2016-17 Intel Corporation.
+//
+// Contains the architectural data structures used by the CPU to implement SGX.
+// The data structures defined to be used by the Linux software stack should not
+// be placed here.
+
+#ifndef _ASM_X86_SGX_ARCH_H
+#define _ASM_X86_SGX_ARCH_H
+
+#include <linux/types.h>
+#include <uapi/asm/sgx_errno.h>
+
+#define SGX_CPUID 0x12
+
+/**
+ * enum sgx_encls_leaves - ENCLS leaf functions
+ * %ECREATE:	Create an enclave.
+ * %EADD:	Add a page to an enclave.
+ * %EINIT:	Launch an enclave.
+ * %EREMOVE:	Remove a page from an enclave.
+ * %EDBGRD:	Read a word from an enclve (peek).
+ * %EDBGWR:	Write a word to an enclave (poke).
+ * %EEXTEND:	Measure 256 bytes of an added enclave page.
+ * %ELDB:	Load a swapped page in blocked state.
+ * %ELDU:	Load a swapped page in unblocked state.
+ * %EBLOCK:	Change page state to blocked i.e. entering hardware threads
+ *		cannot access it and create new TLB entries.
+ * %EPA:	Create a Version Array (VA) page used to store isvsvn number
+ *		for a swapped EPC page.
+ * %EWB:	Swap an enclave page to the regular memory. Checks that all
+ *		threads have exited that were in the previous shoot-down
+ *		sequence.
+ * %ETRACK:	Start a new shoot down sequence. Used to together with EBLOCK
+ *		to make sure that a page is safe to swap.
+ */
+enum sgx_encls_leaves {
+	ECREATE	= 0x0,
+	EADD	= 0x1,
+	EINIT	= 0x2,
+	EREMOVE	= 0x3,
+	EDGBRD	= 0x4,
+	EDGBWR	= 0x5,
+	EEXTEND	= 0x6,
+	ELDB	= 0x7,
+	ELDU	= 0x8,
+	EBLOCK	= 0x9,
+	EPA	= 0xA,
+	EWB	= 0xB,
+	ETRACK	= 0xC,
+	EAUG	= 0xD,
+	EMODPR	= 0xE,
+	EMODT	= 0xF,
+};
+
+#define SGX_MODULUS_SIZE 384
+
+/**
+ * enum sgx_miscselect - additional information to an SSA frame
+ * %SGX_MISC_EXINFO:	Report #PF or #GP to the SSA frame.
+ *
+ * Save State Area (SSA) is a stack inside the enclave used to store processor
+ * state when an exception or interrupt occurs. This enum defines additional
+ * information stored to an SSA frame.
+ */
+enum sgx_miscselect {
+	SGX_MISC_EXINFO		= 0x01,
+};
+
+#define SGX_MISC_RESERVED_MASK 0xFFFFFFFFFFFFFFFEULL
+
+#define SGX_SSA_GPRS_SIZE		182
+#define SGX_SSA_MISC_EXINFO_SIZE	16
+
+/**
+ * enum sgx_attributes - attributes that define enclave privileges.
+ * %SGX_ATTR_DEBUG:		Allow ENCLS(EDBGRD) and ENCLS(EDBGWR).
+ * %SGX_ATTR_MODE64BIT:		Tell that this a 64-bit enclave.
+ * %SGX_ATTR_PROVISIONKEY:      Allow to use provisioning keys used in the
+ *				remote attestation.
+ * %SGX_EINITTOKENKEY:		Allow to use token signing key used to allow to
+ *				run enclaves.
+ */
+enum sgx_attribute {
+	SGX_ATTR_DEBUG		= 0x02,
+	SGX_ATTR_MODE64BIT	= 0x04,
+	SGX_ATTR_PROVISIONKEY	= 0x10,
+	SGX_ATTR_EINITTOKENKEY	= 0x20,
+};
+
+#define SGX_ATTR_RESERVED_MASK 0xFFFFFFFFFFFFFFC9ULL
+
+#define SGX_SECS_RESERVED1_SIZE 24
+#define SGX_SECS_RESERVED2_SIZE 32
+#define SGX_SECS_RESERVED3_SIZE 96
+#define SGX_SECS_RESERVED4_SIZE 3836
+
+/**
+ * struct sgx_secs - SGX Enclave Control Structure (SECS)
+ * @size:		size of the address space
+ * @base:		base address of the  address space
+ * @ssa_frame_size:	size of an SSA frame
+ * @miscselect:		additional information stored to an SSA frame
+ * @attributes:		attributes for enclave
+ * @xfrm:		XSave-Feature Request Mask (subset of XCR0)
+ * @mrenclave:		SHA256-hash of the enclave contents
+ * @mrsigner:		SHA256-hash of the public key used to sign the SIGSTRUCT
+ * @isvprodid:		a user-defined value that is used in key derivation
+ * @isvsvn:		a user-defined value that is used in key derivation
+ *
+ * SGX Enclave Control Structure (SECS) is a special enclave page that is not
+ * visible in the address space. In fact, this structure defines the address
+ * range and other global attributes for the enclave and it is the first EPC
+ * page created for any enclave. It is moved from a temporary buffer to an EPC
+ * by the means of ENCLS(ECREATE) leaf.
+ */
+struct sgx_secs {
+	u64 size;
+	u64 base;
+	u32 ssa_frame_size;
+	u32 miscselect;
+	u8  reserved1[SGX_SECS_RESERVED1_SIZE];
+	u64 attributes;
+	u64 xfrm;
+	u32 mrenclave[8];
+	u8  reserved2[SGX_SECS_RESERVED2_SIZE];
+	u32 mrsigner[8];
+	u8  reserved3[SGX_SECS_RESERVED3_SIZE];
+	u16 isvprodid;
+	u16 isvsvn;
+	u8  reserved4[SGX_SECS_RESERVED4_SIZE];
+} __packed;
+
+/**
+ * enum sgx_tcs_flags - execution flags for TCS
+ * %SGX_TCS_DBGOPTIN:	If enabled allows single-stepping and breakpoints
+ *			inside an enclave. It is cleared by EADD but can
+ *			be set later with EDBGWR.
+ */
+enum sgx_tcs_flags {
+	SGX_TCS_DBGOPTIN	= 0x01,
+};
+
+#define SGX_TCS_RESERVED_MASK 0xFFFFFFFFFFFFFFFEULL
+#define SGX_TCS_RESERVED_SIZE 503
+
+/**
+ * struct sgx_tcs - Thread Control Structure (TCS)
+ * @state:		used to mark an entered TCS
+ * @flags:		execution flags (cleared by EADD)
+ * @ssa_offset:		SSA stack offset relative to the enclave base
+ * @ssa_index:		the current SSA frame index (cleard by EADD)
+ * @nr_ssa_frames:	the number of frame in the SSA stack
+ * @entry_offset:	entry point offset relative to the enclave base
+ * @exit_addr:		address outside the enclave to exit on an exception or
+ *			interrupt
+ * @fs_offset:		offset relative to the enclave base to become FS
+ *			segment inside the enclave
+ * @gs_offset:		offset relative to the enclave base to become GS
+ *			segment inside the enclave
+ * @fs_limit:		size to become a new FS-limit (only 32-bit enclaves)
+ * @gs_limit:		size to become a new GS-limit (only 32-bit enclaves)
+ *
+ * Thread Control Structure (TCS) is an enclave page visible in its address
+ * space that defines an entry point inside the enclave. A thread enters inside
+ * an enclave by supplying address of TCS to ENCLU(EENTER). A TCS can be entered
+ * by only one thread at a time.
+ */
+struct sgx_tcs {
+	u64 state;
+	u64 flags;
+	u64 ssa_offset;
+	u32 ssa_index;
+	u32 nr_ssa_frames;
+	u64 entry_offset;
+	u64 exit_addr;
+	u64 fs_offset;
+	u64 gs_offset;
+	u32 fs_limit;
+	u32 gs_limit;
+	u64 reserved[SGX_TCS_RESERVED_SIZE];
+} __packed;
+
+/**
+ * struct sgx_pageinfo - an enclave page descriptor
+ * @addr:	address of the enclave page
+ * @contents:	pointer to the page contents
+ * @metadata:	pointer either to a SECINFO or PCMD instance
+ * @secs:	address of the SECS page
+ */
+struct sgx_pageinfo {
+	u64 addr;
+	u64 contents;
+	u64 metadata;
+	u64 secs;
+} __packed __aligned(32);
+
+
+#define SGX_SECINFO_PERMISSION_MASK	0x0000000000000007ULL
+#define SGX_SECINFO_PAGE_TYPE_MASK	0x000000000000FF00ULL
+#define SGX_SECINFO_RESERVED_MASK	0xFFFFFFFFFFFF00F8ULL
+
+/**
+ * enum sgx_page_type - bits in the SECINFO flags defining the page type
+ * %SGX_PAGE_TYPE_SECS:	a SECS page
+ * %SGX_PAGE_TYPE_TCS:	a TCS page
+ * %SGX_PAGE_TYPE_REG:	a regular page
+ * %SGX_PAGE_TYPE_VA:	a VA page
+ * %SGX_PAGE_TYPE_TRIM:	a page in trimmed state
+ */
+enum sgx_page_type {
+	SGX_PAGE_TYPE_SECS	= 0x00,
+	SGX_PAGE_TYPE_TCS	= 0x01,
+	SGX_PAGE_TYPE_REG	= 0x02,
+	SGX_PAGE_TYPE_VA	= 0x03,
+	SGX_PAGE_TYPE_TRIM	= 0x04,
+};
+
+/**
+ * enum sgx_secinfo_flags - SECINFO flags
+ * %SGX_SECINFO_R:	read permission
+ * %SGX_SECINFO_W:	write permission
+ * %SGX_SECINFO_X:	exec permission
+ * %SGX_SECINFO_SECS:	a SECS page
+ * %SGX_SECINFO_TCS:	a TCS page
+ * %SGX_SECINFO_REG:	a regular page
+ * %SGX_SECINFO_VA:	a VA page
+ * %SGX_SECINFO_TRIM:	a page in trimmed state
+ */
+enum sgx_secinfo_flags {
+	SGX_SECINFO_R		= 0x01,
+	SGX_SECINFO_W		= 0x02,
+	SGX_SECINFO_X		= 0x04,
+	SGX_SECINFO_SECS	= (SGX_PAGE_TYPE_SECS << 8),
+	SGX_SECINFO_TCS		= (SGX_PAGE_TYPE_TCS << 8),
+	SGX_SECINFO_REG		= (SGX_PAGE_TYPE_REG << 8),
+	SGX_SECINFO_VA          = (SGX_PAGE_TYPE_VA << 8),
+	SGX_SECINFO_TRIM	= (SGX_PAGE_TYPE_TRIM << 8),
+};
+
+#define SGX_SECINFO_RESERVED_SIZE 56
+
+/**
+ * struct sgx_secinfo - describes the class of an enclave page
+ * @flags:	permissions and type
+ */
+struct sgx_secinfo {
+	u64 flags;
+	u8  reserved[SGX_SECINFO_RESERVED_SIZE];
+} __packed __aligned(64);
+
+#define SGX_PCMD_RESERVED_SIZE 40
+
+/**
+ * struct sgx_pcmd - Paging Crypto Metadata (PCMD)
+ * @enclave_id:	enclave identifier
+ * @mac:	MAC over PCMD, page contents and isvsvn
+ *
+ * PCMD is stored for every swapped page to the regular memory. When ELDU loads
+ * the page back it recalculates the MAC by using a isvsvn number stored in a
+ * VA page. Together these two structures bring integrity and rollback
+ * protection.
+ */
+struct sgx_pcmd {
+	struct sgx_secinfo secinfo;
+	u64 enclave_id;
+	u8  reserved[SGX_PCMD_RESERVED_SIZE];
+	u8  mac[16];
+} __packed __aligned(128);
+
+#define SGX_SIGSTRUCT_RESERVED1_SIZE 84
+#define SGX_SIGSTRUCT_RESERVED2_SIZE 20
+#define SGX_SIGSTRUCT_RESERVED3_SIZE 32
+#define SGX_SIGSTRUCT_RESERVED4_SIZE 12
+
+/**
+ * struct sgx_sigstruct - an enclave signature
+ * @header1:		a constant byte string
+ * @vendor:		must be either 0x0000 or 0x8086
+ * @date:		YYYYMMDD in BCD
+ * @header2:		a costant byte string
+ * @application:	an application defined value
+ * @modulus:		the modulus of the public key
+ * @exponent:		the exponent of the public key
+ * @signature:		the signature calculated over the fields except modulus,
+ *			exponent, signature, reserved4, q1 and q2
+ * @miscselect:		additional information stored to an SSA frame
+ * @misc_mask:		required miscselect in SECS
+ * @attributes:		attributes for enclave
+ * @xfrm:		XSave-Feature Request Mask (subset of XCR0)
+ * @attributes_mask:	required attributes in SECS
+ * @xfrm_mask:		required XFRM in SECS
+ * @mrenclave:		SHA256-hash of the enclave contents
+ * @isvprodid:		a user-defined value that is used in key derivation
+ * @isvsvn:		a user-defined value that is used in key derivation
+ * @q1:			a value used in RSA signature verification
+ * @q2:			a value used in RSA signature verification
+ */
+struct sgx_sigstruct {
+	u64 header1[2];
+	u32 vendor;
+	u32 date;
+	u64 header2[2];
+	u32 application;
+	u8  reserved1[SGX_SIGSTRUCT_RESERVED1_SIZE];
+	u8  modulus[SGX_MODULUS_SIZE];
+	u32 exponent;
+	u8  signature[SGX_MODULUS_SIZE];
+	u32 miscselect;
+	u32 misc_mask;
+	u8  reserved2[SGX_SIGSTRUCT_RESERVED2_SIZE];
+	u64 attributes;
+	u64 xfrm;
+	u64 attributes_mask;
+	u64 xfrm_mask;
+	u8  mrenclave[32];
+	u8  reserved3[SGX_SIGSTRUCT_RESERVED3_SIZE];
+	u16 isvprodid;
+	u16 isvsvn;
+	u8  reserved4[SGX_SIGSTRUCT_RESERVED4_SIZE];
+	u8  q1[SGX_MODULUS_SIZE];
+	u8  q2[SGX_MODULUS_SIZE];
+} __packed __aligned(4096);
+
+#define SGX_EINITTOKEN_RESERVED1_SIZE 11
+#define SGX_EINITTOKEN_RESERVED2_SIZE 32
+#define SGX_EINITTOKEN_RESERVED3_SIZE 32
+#define SGX_EINITTOKEN_RESERVED4_SIZE 24
+
+/**
+ * struct sgx_einittoken - a token permitting to launch an enclave
+ * @valid:			one if valid and zero if invalid
+ * @attributes:			attributes for enclave
+ * @xfrm:			XSave-Feature Request Mask (subset of XCR0)
+ * @mrenclave:			SHA256-hash of the enclave contents
+ * @mrsigner:			SHA256-hash of the public key used to sign the
+ *				SIGSTRUCT
+ * @le_cpusvn:			a value that reflects the SGX implementation
+ *				running in in the CPU
+ * @le_isvprodid:		a user-defined value that is used in key
+ *				derivation
+ * @le_isvsvn:			a user-defined value that is used in key
+ *				derivation
+ * @le_keyed_miscselect:	LE's miscselect masked with the token keys
+ *				miscselect
+ * @le_keyed_attributes:	LE's attributes masked with the token keys
+ *				attributes
+ * @le_keyed_xfrm:		LE's XFRM masked with the token keys xfrm
+ * @salt:			random salt for wear-out protection
+ * @mac:			CMAC over the preceding fields
+ *
+ * An enclave with EINITTOKENKEY attribute can access a key with the same name
+ * by using ENCLS(EGETKEY) and use this to sign cryptographic tokens that can
+ * be passed to ENCLS(EINIT) to permit the launch of other enclaves. This is
+ * the only viable way to launch enclaves if IA32_SGXLEPUBKEYHASHn MSRs are
+ * locked assuming that there is a Launch Enclave (LE) available that can be
+ * used for generating these tokens.
+ */
+struct sgx_einittoken {
+	u32 valid;
+	u32 reserved1[SGX_EINITTOKEN_RESERVED1_SIZE];
+	u64 attributes;
+	u64 xfrm;
+	u8  mrenclave[32];
+	u8  reserved2[SGX_EINITTOKEN_RESERVED2_SIZE];
+	u8  mrsigner[32];
+	u8  reserved3[SGX_EINITTOKEN_RESERVED3_SIZE];
+	u8  le_cpusvn[16];
+	u16 le_isvprodid;
+	u16 le_isvsvn;
+	u8  reserved4[SGX_EINITTOKEN_RESERVED4_SIZE];
+	u32 le_keyed_miscselect;
+	u64 le_keyed_attributes;
+	u64 le_keyed_xfrm;
+	u8  salt[32];
+	u8  mac[16];
+} __packed __aligned(512);
+
+#endif /* _ASM_X86_SGX_ARCH_H */
diff --git a/arch/x86/include/uapi/asm/sgx_errno.h b/arch/x86/include/uapi/asm/sgx_errno.h
new file mode 100644
index 000000000000..48b87aed58d7
--- /dev/null
+++ b/arch/x86/include/uapi/asm/sgx_errno.h
@@ -0,0 +1,91 @@
+/* SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause */
+/*
+ * Copyright(c) 2018 Intel Corporation.
+ *
+ * Contains the architecturally defined error codes that are returned by SGX
+ * instructions, e.g. ENCLS, and may be propagated to userspace via errno.
+ */
+
+#ifndef _UAPI_ASM_X86_SGX_ERRNO_H
+#define _UAPI_ASM_X86_SGX_ERRNO_H
+
+/**
+ * enum sgx_encls_leaves - return codes for ENCLS, ENCLU and ENCLV
+ * %SGX_SUCCESS:		No error.
+ * %SGX_INVALID_SIG_STRUCT:	SIGSTRUCT contains an invalid value.
+ * %SGX_INVALID_ATTRIBUTE:	Enclave is not attempting to access a resource
+ *				for which it is not authorized.
+ * %SGX_BLKSTATE:		EPC page is already blocked.
+ * %SGX_INVALID_MEASUREMENT:	SIGSTRUCT or EINITTOKEN contains an incorrect
+ *				measurement.
+ * %SGX_NOTBLOCKABLE:		EPC page type is not one which can be blocked.
+ * %SGX_PG_INVLD:		EPC page is invalid (and cannot be blocked).
+ * %SGX_EPC_PAGE_CONFLICT:	EPC page in use by another SGX instruction.
+ * %SGX_INVALID_SIGNATURE:	Enclave's signature does not validate with
+ *				public key enclosed in SIGSTRUCT.
+ * %SGX_MAC_COMPARE_FAIL:	MAC check failed when reloading EPC page.
+ * %SGX_PAGE_NOT_BLOCKED:	EPC page is not marked as blocked.
+ * %SGX_NOT_TRACKED:		ETRACK has not been completed on the EPC page.
+ * %SGX_VA_SLOT_OCCUPIED:	Version array slot contains a valid entry.
+ * %SGX_CHILD_PRESENT:		Enclave has child pages present in the EPC.
+ * %SGX_ENCLAVE_ACT:		Logical processors are currently executing
+ *				inside the enclave.
+ * %SGX_ENTRYEPOCH_LOCKED:	SECS locked for EPOCH update, i.e. an ETRACK is
+ *				currently executing on the SECS.
+ * %SGX_INVALID_EINITTOKEN:	EINITTOKEN is invalid and enclave signer's
+ *				public key does not match IA32_SGXLEPUBKEYHASH.
+ * %SGX_PREV_TRK_INCMPL:	All processors did not complete the previous
+ *				tracking sequence.
+ * %SGX_PG_IS_SECS:		Target EPC page is an SECS and cannot be
+ *				blocked.
+ * %SGX_PAGE_ATTRIBUTES_MISMATCH:	Attributes of the EPC page do not match
+ *					the expected values.
+ * %SGX_PAGE_NOT_MODIFIABLE:	EPC page cannot be modified because it is in
+ *				the PENDING or MODIFIED state.
+ * %SGX_PAGE_NOT_DEBUGGABLE:	EPC page cannot be modified because it is in
+ *				the PENDING or MODIFIED state.
+ * %SGX_INVALID_COUNTER:	{In,De}crementing a counter would cause it to
+ *				{over,under}flow.
+ * %SGX_PG_NONEPC:		Target page is not an EPC page.
+ * %SGX_TRACK_NOT_REQUIRED:	Target page type does not require tracking.
+ * %SGX_INVALID_CPUSVN:		Security version number reported by CPU is less
+ *				than what is required by the enclave.
+ * %SGX_INVALID_ISVSVN:		Security version number of enclave is less than
+ *				what is required by the KEYREQUEST struct.
+ * %SGX_UNMASKED_EVENT:		An unmasked event, e.g. INTR, was received
+ *				while the instruction was executing.
+ * %SGX_INVALID_KEYNAME:	Requested key is not supported by hardware.
+ */
+enum sgx_return_codes {
+	SGX_SUCCESS			= 0,
+	SGX_INVALID_SIG_STRUCT		= 1,
+	SGX_INVALID_ATTRIBUTE		= 2,
+	SGX_BLKSTATE			= 3,
+	SGX_INVALID_MEASUREMENT		= 4,
+	SGX_NOTBLOCKABLE		= 5,
+	SGX_PG_INVLD			= 6,
+	SGX_EPC_PAGE_CONFLICT		= 7,
+	SGX_INVALID_SIGNATURE		= 8,
+	SGX_MAC_COMPARE_FAIL		= 9,
+	SGX_PAGE_NOT_BLOCKED		= 10,
+	SGX_NOT_TRACKED			= 11,
+	SGX_VA_SLOT_OCCUPIED		= 12,
+	SGX_CHILD_PRESENT		= 13,
+	SGX_ENCLAVE_ACT			= 14,
+	SGX_ENTRYEPOCH_LOCKED		= 15,
+	SGX_INVALID_EINITTOKEN		= 16,
+	SGX_PREV_TRK_INCMPL		= 17,
+	SGX_PG_IS_SECS			= 18,
+	SGX_PAGE_ATTRIBUTES_MISMATCH	= 19,
+	SGX_PAGE_NOT_MODIFIABLE		= 20,
+	SGX_PAGE_NOT_DEBUGGABLE		= 21,
+	SGX_INVALID_COUNTER		= 25,
+	SGX_PG_NONEPC			= 26,
+	SGX_TRACK_NOT_REQUIRED		= 27,
+	SGX_INVALID_CPUSVN		= 32,
+	SGX_INVALID_ISVSVN		= 64,
+	SGX_UNMASKED_EVENT		= 128,
+	SGX_INVALID_KEYNAME		= 256,
+};
+
+#endif /* _UAPI_ASM_X86_SGX_ERRNO_H */
-- 
2.17.1
