Return-Path: <SRS0=Vmdy=O6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 962A5C43387
	for <linux-sgx@archiver.kernel.org>; Fri, 21 Dec 2018 23:13:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5892E2190A
	for <linux-sgx@archiver.kernel.org>; Fri, 21 Dec 2018 23:13:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392205AbeLUXNt (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 21 Dec 2018 18:13:49 -0500
Received: from mga01.intel.com ([192.55.52.88]:11636 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390789AbeLUXNt (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 21 Dec 2018 18:13:49 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Dec 2018 15:13:48 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,383,1539673200"; 
   d="scan'208";a="120338398"
Received: from ncanderx-mobl.ger.corp.intel.com (HELO localhost) ([10.249.254.238])
  by FMSMGA003.fm.intel.com with ESMTP; 21 Dec 2018 15:13:40 -0800
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     x86@kernel.org, linux-sgx@vger.kernel.org
Cc:     akpm@linux-foundation.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v18 11/25] x86/sgx: Add SGX1 and SGX2 architectural data structures
Date:   Sat, 22 Dec 2018 01:11:40 +0200
Message-Id: <20181221231154.6120-12-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181221231154.6120-1-jarkko.sakkinen@linux.intel.com>
References: <20181221231154.6120-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Define the data structures used by various ENCLS functions needed for
Linux to support all SGX1 and SGX2 ENCLS leaf functions.  This is not
an exhaustive representation of all SGX data structures as several are
only consumed by ENCLU (userspace), e.g. REPORT and KEYREQUEST, while
others are only consumed by future features, e.g. RDINFO.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/sgx_arch.h | 329 ++++++++++++++++++++++++++++++++
 1 file changed, 329 insertions(+)

diff --git a/arch/x86/include/asm/sgx_arch.h b/arch/x86/include/asm/sgx_arch.h
index 6cd572fa95fa..d4c57154e6e6 100644
--- a/arch/x86/include/asm/sgx_arch.h
+++ b/arch/x86/include/asm/sgx_arch.h
@@ -8,6 +8,7 @@
 #ifndef _ASM_X86_SGX_ARCH_H
 #define _ASM_X86_SGX_ARCH_H
 
+#include <linux/types.h>
 #include <uapi/asm/sgx_errno.h>
 
 /**
@@ -53,4 +54,332 @@ enum sgx_encls_leaves {
 	SGX_EMODT	= 0x0F,
 };
 
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
+	SGX_MISC_EXINFO		= BIT(0),
+	SGX_MISC_RESERVED_MASK	= GENMASK_ULL(63, 1)
+};
+
+#define SGX_SSA_GPRS_SIZE		182
+#define SGX_SSA_MISC_EXINFO_SIZE	16
+
+/**
+ * enum sgx_attributes - the attributes field in &struct sgx_secs
+ * %SGX_ATTR_INIT:		Enclave can be entered (is initialized).
+ * %SGX_ATTR_DEBUG:		Allow ENCLS(EDBGRD) and ENCLS(EDBGWR).
+ * %SGX_ATTR_MODE64BIT:		Tell that this a 64-bit enclave.
+ * %SGX_ATTR_PROVISIONKEY:      Allow to use provisioning keys for remote
+ *				attestation.
+ * %SGX_ATTR_EINITTOKENKEY:	Allow to use token signing key that is used to
+ *				sign cryptographic tokens that can be passed to
+ *				EINIT as an authorization to run an enclave.
+ */
+enum sgx_attribute {
+	SGX_ATTR_INIT		= BIT(0),
+	SGX_ATTR_DEBUG		= BIT(1),
+	SGX_ATTR_MODE64BIT	= BIT(2),
+	SGX_ATTR_PROVISIONKEY	= BIT(4),
+	SGX_ATTR_EINITTOKENKEY	= BIT(5),
+	SGX_ATTR_RESERVED_MASK  = BIT_ULL(3) | GENMASK_ULL(63, 6)
+};
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
+	SGX_TCS_RESERVED_MASK	= GENMASK_ULL(63, 1)
+};
+
+#define SGX_TCS_RESERVED_SIZE 4024
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
+	u8  reserved[SGX_TCS_RESERVED_SIZE];
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
+/**
+ * enum sgx_page_type - bits in the SECINFO flags defining the page type
+ * %SGX_PAGE_TYPE_SECS:	a SECS page
+ * %SGX_PAGE_TYPE_TCS:	a TCS page
+ * %SGX_PAGE_TYPE_REG:	a regular page
+ * %SGX_PAGE_TYPE_VA:	a VA page
+ * %SGX_PAGE_TYPE_TRIM:	a page in trimmed state
+ */
+enum sgx_page_type {
+	SGX_PAGE_TYPE_SECS	= 0,
+	SGX_PAGE_TYPE_TCS	= 1,
+	SGX_PAGE_TYPE_REG	= 2,
+	SGX_PAGE_TYPE_VA	= 3,
+	SGX_PAGE_TYPE_TRIM	= 4,
+	SGX_PAGE_TYPE_MASK	= GENMASK(7, 0)
+};
+
+/**
+ * enum sgx_secinfo_flags - the flags field in &struct sgx_secinfo
+ * %SGX_SECINFO_R:	allow read
+ * %SGX_SECINFO_W:	allow write
+ * %SGX_SECINFO_X:	allow execution
+ * %SGX_SECINFO_SECS:	a SECS page
+ * %SGX_SECINFO_TCS:	a TCS page
+ * %SGX_SECINFO_REG:	a regular page
+ * %SGX_SECINFO_VA:	a VA page
+ * %SGX_SECINFO_TRIM:	a page in trimmed state
+ */
+enum sgx_secinfo_flags {
+	SGX_SECINFO_R			= BIT(0),
+	SGX_SECINFO_W			= BIT(1),
+	SGX_SECINFO_X			= BIT(2),
+	SGX_SECINFO_PERMISSION_MASK	= GENMASK_ULL(2, 0),
+	SGX_SECINFO_SECS		= (SGX_PAGE_TYPE_SECS << 8),
+	SGX_SECINFO_TCS			= (SGX_PAGE_TYPE_TCS << 8),
+	SGX_SECINFO_REG			= (SGX_PAGE_TYPE_REG << 8),
+	SGX_SECINFO_VA			= (SGX_PAGE_TYPE_VA << 8),
+	SGX_SECINFO_TRIM		= (SGX_PAGE_TYPE_TRIM << 8),
+	SGX_SECINFO_PAGE_TYPE_MASK	= (SGX_PAGE_TYPE_MASK << 8),
+	SGX_SECINFO_RESERVED_MASK	= ~(SGX_SECINFO_PERMISSION_MASK |
+					    SGX_SECINFO_PAGE_TYPE_MASK)
+};
+
+#define SGX_SECINFO_RESERVED_SIZE 56
+
+/**
+ * struct sgx_secinfo - describes attributes of an EPC page
+ * @flags:	permissions and type
+ *
+ * Used together with ENCLS leaves that add or modify an EPC page to an
+ * enclave to define page permissions and type.
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
 #endif /* _ASM_X86_SGX_ARCH_H */
-- 
2.19.1

