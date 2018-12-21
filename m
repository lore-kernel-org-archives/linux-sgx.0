Return-Path: <SRS0=Vmdy=O6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30B7EC43387
	for <linux-sgx@archiver.kernel.org>; Fri, 21 Dec 2018 23:14:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F3C872190A
	for <linux-sgx@archiver.kernel.org>; Fri, 21 Dec 2018 23:14:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392207AbeLUXOJ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 21 Dec 2018 18:14:09 -0500
Received: from mga02.intel.com ([134.134.136.20]:34346 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390789AbeLUXOJ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 21 Dec 2018 18:14:09 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Dec 2018 15:14:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,383,1539673200"; 
   d="scan'208";a="120338475"
Received: from ncanderx-mobl.ger.corp.intel.com (HELO localhost) ([10.249.254.238])
  by FMSMGA003.fm.intel.com with ESMTP; 21 Dec 2018 15:14:00 -0800
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     x86@kernel.org, linux-sgx@vger.kernel.org
Cc:     akpm@linux-foundation.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v18 13/25] x86/sgx: Add wrappers for ENCLS leaf functions
Date:   Sat, 22 Dec 2018 01:11:42 +0200
Message-Id: <20181221231154.6120-14-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181221231154.6120-1-jarkko.sakkinen@linux.intel.com>
References: <20181221231154.6120-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

ENCLS is an umbrella instruction for a variety of cpl0 SGX functions.
The ENCLS function that is executed is specified in EAX, with each
function potentially having more leaf-specific operands beyond EAX.
ENCLS introduces its own (positive value) error codes that (some)
leafs use to return failure information in EAX.  Leafs that return
an error code also modify RFLAGS.  And finally, ENCLS generates
ENCLS-specific non-fatal #GPs and #PFs, i.e. a bug-free kernel may
encounter faults on ENCLS that must be handled gracefully.

Because of the complexity involved in encoding ENCLS and handling its
assortment of failure paths, executing any given leaf is not a simple
matter of emitting ENCLS.

To enable adding support for ENCLS leafs with minimal fuss, add a
two-layer macro system along with an encoding scheme to allow wrappers
to return trap numbers along ENCLS-specific error codes.  The bottom
layer of the macro system splits between the leafs that return an
error code and those that do not.  The second layer generates the
correct input/output annotations based on the number of operands for
each leaf function.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/sgx.h | 252 +++++++++++++++++++++++++++++++++++++
 1 file changed, 252 insertions(+)
 create mode 100644 arch/x86/include/asm/sgx.h

diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
new file mode 100644
index 000000000000..3d5ba1d23dfb
--- /dev/null
+++ b/arch/x86/include/asm/sgx.h
@@ -0,0 +1,252 @@
+/* SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause) */
+#ifndef _ASM_X86_SGX_H
+#define _ASM_X86_SGX_H
+
+#include <asm/asm.h>
+#include <asm/sgx_arch.h>
+
+/**
+ * ENCLS_FAULT_FLAG - flag signifying an ENCLS return code is a trapnr
+ *
+ * ENCLS has its own (positive value) error codes and also generates
+ * ENCLS specific #GP and #PF faults.  And the ENCLS values get munged
+ * with system error codes as everything percolates back up the stack.
+ * Unfortunately (for us), we need to precisely identify each unique
+ * error code, e.g. the action taken if EWB fails varies based on the
+ * type of fault and on the exact SGX error code, i.e. we can't simply
+ * convert all faults to -EFAULT.
+ *
+ * To make all three error types coexist, we set bit 30 to identify an
+ * ENCLS fault.  Bit 31 (technically bits N:31) is used to differentiate
+ * between positive (faults and SGX error codes) and negative (system
+ * error codes) values.
+ */
+#define ENCLS_FAULT_FLAG 0x40000000
+
+/**
+ * Check for a fault by looking for a postive value with the fault
+ * flag set.  The postive value check is needed to filter out system
+ * error codes since negative values will have all higher order bits
+ * set, including ENCLS_FAULT_FLAG.
+ */
+#define IS_ENCLS_FAULT(r) ((int)(r) > 0 && ((r) & ENCLS_FAULT_FLAG))
+
+/**
+ * Retrieve the encoded trapnr from the specified return code.
+ */
+#define ENCLS_TRAPNR(r) ((r) & ~ENCLS_FAULT_FLAG)
+
+/**
+ * encls_to_err - translate an ENCLS fault or SGX code into a system error code
+ * @ret:	positive value return code
+ *
+ * Translate a postive return code, e.g. from ENCLS, into a system error
+ * code.  Primarily used by functions that cannot return a non-negative
+ * error code, e.g. kernel callbacks.
+ *
+ * Return:
+ *	0 on success,
+ *	-errno on failure
+ */
+static inline int encls_to_err(int ret)
+{
+	if (IS_ENCLS_FAULT(ret))
+		return -EFAULT;
+
+	switch (ret) {
+	case SGX_UNMASKED_EVENT:
+		return -EINTR;
+	case SGX_INVALID_SIG_STRUCT:
+	case SGX_INVALID_ATTRIBUTE:
+	case SGX_INVALID_MEASUREMENT:
+	case SGX_INVALID_EINITTOKEN:
+	case SGX_INVALID_CPUSVN:
+	case SGX_INVALID_ISVSVN:
+	case SGX_INVALID_KEYNAME:
+		return -EINVAL;
+	case SGX_ENCLAVE_ACT:
+	case SGX_CHILD_PRESENT:
+	case SGX_ENTRYEPOCH_LOCKED:
+	case SGX_PREV_TRK_INCMPL:
+	case SGX_PAGE_NOT_MODIFIABLE:
+	case SGX_PAGE_NOT_DEBUGGABLE:
+		return -EBUSY;
+	default:
+		return -EIO;
+	};
+}
+
+/**
+ * __encls_ret_N - encode an ENCLS leaf that returns an error code in EAX
+ * @rax:	leaf number
+ * @inputs:	asm inputs for the leaf
+ *
+ * Emit assembly for an ENCLS leaf that returns an error code, e.g. EREMOVE.
+ * And because SGX isn't complex enough as it is, leafs that return an error
+ * code also modify flags.
+ *
+ * Return:
+ *	0 on success,
+ *	SGX error code on failure
+ */
+#define __encls_ret_N(rax, inputs...)				\
+	({							\
+	int ret;						\
+	asm volatile(						\
+	"1: .byte 0x0f, 0x01, 0xcf;\n\t"			\
+	"2:\n"							\
+	".section .fixup,\"ax\"\n"				\
+	"3: orl $"__stringify(ENCLS_FAULT_FLAG)",%%eax\n"	\
+	"   jmp 2b\n"						\
+	".previous\n"						\
+	_ASM_EXTABLE_FAULT(1b, 3b)				\
+	: "=a"(ret)						\
+	: "a"(rax), inputs					\
+	: "memory", "cc");					\
+	ret;							\
+	})
+
+#define __encls_ret_1(rax, rcx)		\
+	({				\
+	__encls_ret_N(rax, "c"(rcx));	\
+	})
+
+#define __encls_ret_2(rax, rbx, rcx)		\
+	({					\
+	__encls_ret_N(rax, "b"(rbx), "c"(rcx));	\
+	})
+
+#define __encls_ret_3(rax, rbx, rcx, rdx)			\
+	({							\
+	__encls_ret_N(rax, "b"(rbx), "c"(rcx), "d"(rdx));	\
+	})
+
+/**
+ * __encls_N - encode an ENCLS leaf that doesn't return an error code
+ * @rax:	leaf number
+ * @rbx_out:	optional output variable
+ * @inputs:	asm inputs for the leaf
+ *
+ * Emit assembly for an ENCLS leaf that does not return an error code,
+ * e.g. ECREATE.  Leaves without error codes either succeed or fault.
+ * @rbx_out is an optional parameter for use by EDGBRD, which returns
+ * the the requested value in RBX.
+ *
+ * Return:
+ *   0 on success,
+ *   trapnr with ENCLS_FAULT_FLAG set on fault
+ */
+#define __encls_N(rax, rbx_out, inputs...)			\
+	({							\
+	int ret;						\
+	asm volatile(						\
+	"1: .byte 0x0f, 0x01, 0xcf;\n\t"			\
+	"   xor %%eax,%%eax;\n"					\
+	"2:\n"							\
+	".section .fixup,\"ax\"\n"				\
+	"3: orl $"__stringify(ENCLS_FAULT_FLAG)",%%eax\n"	\
+	"   jmp 2b\n"						\
+	".previous\n"						\
+	_ASM_EXTABLE_FAULT(1b, 3b)				\
+	: "=a"(ret), "=b"(rbx_out)				\
+	: "a"(rax), inputs					\
+	: "memory");						\
+	ret;							\
+	})
+
+#define __encls_2(rax, rbx, rcx)				\
+	({							\
+	unsigned long ign_rbx_out;				\
+	__encls_N(rax, ign_rbx_out, "b"(rbx), "c"(rcx));	\
+	})
+
+#define __encls_1_1(rax, data, rcx)			\
+	({						\
+	unsigned long rbx_out;				\
+	int ret = __encls_N(rax, rbx_out, "c"(rcx));	\
+	if (!ret)					\
+		data = rbx_out;				\
+	ret;						\
+	})
+
+static inline int __ecreate(struct sgx_pageinfo *pginfo, void *secs)
+{
+	return __encls_2(SGX_ECREATE, pginfo, secs);
+}
+
+static inline int __eextend(void *secs, void *addr)
+{
+	return __encls_2(SGX_EEXTEND, secs, addr);
+}
+
+static inline int __eadd(struct sgx_pageinfo *pginfo, void *addr)
+{
+	return __encls_2(SGX_EADD, pginfo, addr);
+}
+
+static inline int __einit(void *sigstruct, struct sgx_einittoken *einittoken,
+			  void *secs)
+{
+	return __encls_ret_3(SGX_EINIT, sigstruct, secs, einittoken);
+}
+
+static inline int __eremove(void *addr)
+{
+	return __encls_ret_1(SGX_EREMOVE, addr);
+}
+
+static inline int __edbgwr(void *addr, unsigned long *data)
+{
+	return __encls_2(SGX_EDGBWR, *data, addr);
+}
+
+static inline int __edbgrd(void *addr, unsigned long *data)
+{
+	return __encls_1_1(SGX_EDGBRD, *data, addr);
+}
+
+static inline int __etrack(void *addr)
+{
+	return __encls_ret_1(SGX_ETRACK, addr);
+}
+
+static inline int __eldu(struct sgx_pageinfo *pginfo, void *addr,
+			 void *va)
+{
+	return __encls_ret_3(SGX_ELDU, pginfo, addr, va);
+}
+
+static inline int __eblock(void *addr)
+{
+	return __encls_ret_1(SGX_EBLOCK, addr);
+}
+
+static inline int __epa(void *addr)
+{
+	unsigned long rbx = SGX_PAGE_TYPE_VA;
+
+	return __encls_2(SGX_EPA, rbx, addr);
+}
+
+static inline int __ewb(struct sgx_pageinfo *pginfo, void *addr,
+			void *va)
+{
+	return __encls_ret_3(SGX_EWB, pginfo, addr, va);
+}
+
+static inline int __eaug(struct sgx_pageinfo *pginfo, void *addr)
+{
+	return __encls_2(SGX_EAUG, pginfo, addr);
+}
+
+static inline int __emodpr(struct sgx_secinfo *secinfo, void *addr)
+{
+	return __encls_ret_2(SGX_EMODPR, secinfo, addr);
+}
+
+static inline int __emodt(struct sgx_secinfo *secinfo, void *addr)
+{
+	return __encls_ret_2(SGX_EMODT, secinfo, addr);
+}
+
+#endif /* _ASM_X86_SGX_H */
-- 
2.19.1

