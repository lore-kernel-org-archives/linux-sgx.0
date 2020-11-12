Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C252CC388F7
	for <linux-sgx@archiver.kernel.org>; Thu, 12 Nov 2020 22:02:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5719E22241
	for <linux-sgx@archiver.kernel.org>; Thu, 12 Nov 2020 22:02:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="h/jf5fsw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727464AbgKLWCG (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 12 Nov 2020 17:02:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:48900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727438AbgKLWCE (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 12 Nov 2020 17:02:04 -0500
Received: from suppilovahvero.lan (83-245-197-237.elisa-laajakaista.fi [83.245.197.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B63C2224B;
        Thu, 12 Nov 2020 22:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605218522;
        bh=yXcEhTOBEGu2iTxbA0uKGs9ZublDFPYF4sxjBIhNJvY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h/jf5fswVxHYvstcBmUexp3dgBbW5ZkBKK2q2IuAU6abTN1CDJNXV8NQIbCCu+9sc
         elwk1LsgSRueQDNp/AiwWQjrR87qfVGwX/dXn9uoeP9Te+ZEGSopd3lA1O+p9V2cPx
         9WUyAm9O80VXi7Um/py/W6hKk64ZnG60HbQxXrcs=
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     x86@kernel.org, linux-sgx@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, bp@alien8.de, cedric.xing@intel.com,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, dave.hansen@intel.com, haitao.huang@intel.com,
        kai.huang@intel.com, kai.svahn@intel.com, kmoy@google.com,
        ludloff@google.com, luto@kernel.org, nhorman@redhat.com,
        npmccallum@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        sean.j.christopherson@intel.com, tglx@linutronix.de,
        yaozhangx@google.com, mikko.ylinen@intel.com
Subject: [PATCH v41 02/24] x86/sgx: Add wrappers for ENCLS functions
Date:   Fri, 13 Nov 2020 00:01:13 +0200
Message-Id: <20201112220135.165028-3-jarkko@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201112220135.165028-1-jarkko@kernel.org>
References: <20201112220135.165028-1-jarkko@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

ENCLS is the userspace instruction which wraps virtually all
unprivileged SGX functionality for managing enclaves.  It is essentially
the ioctl() of instructions with each function implementing different
SGX-related functionality.

Add macros to wrap the ENCLS functionality. There are two main groups,
one for functions which do not return error codes and a “ret_” set for
those that do.

ENCLS functions are documented in Intel SDM section 36.6.

Acked-by: Jethro Beekman <jethro@fortanix.com> # v40
# Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
# Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 arch/x86/kernel/cpu/sgx/encls.h | 231 ++++++++++++++++++++++++++++++++
 1 file changed, 231 insertions(+)
 create mode 100644 arch/x86/kernel/cpu/sgx/encls.h

diff --git a/arch/x86/kernel/cpu/sgx/encls.h b/arch/x86/kernel/cpu/sgx/encls.h
new file mode 100644
index 000000000000..443188fe7e70
--- /dev/null
+++ b/arch/x86/kernel/cpu/sgx/encls.h
@@ -0,0 +1,231 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _X86_ENCLS_H
+#define _X86_ENCLS_H
+
+#include <linux/bitops.h>
+#include <linux/err.h>
+#include <linux/io.h>
+#include <linux/rwsem.h>
+#include <linux/types.h>
+#include <asm/asm.h>
+#include <asm/traps.h>
+#include "sgx.h"
+
+enum sgx_encls_function {
+	ECREATE	= 0x00,
+	EADD	= 0x01,
+	EINIT	= 0x02,
+	EREMOVE	= 0x03,
+	EDGBRD	= 0x04,
+	EDGBWR	= 0x05,
+	EEXTEND	= 0x06,
+	ELDU	= 0x08,
+	EBLOCK	= 0x09,
+	EPA	= 0x0A,
+	EWB	= 0x0B,
+	ETRACK	= 0x0C,
+};
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
+/* Retrieve the encoded trapnr from the specified return code. */
+#define ENCLS_TRAPNR(r) ((r) & ~ENCLS_FAULT_FLAG)
+
+/* Issue a WARN() about an ENCLS function. */
+#define ENCLS_WARN(r, name) {						  \
+	do {								  \
+		int _r = (r);						  \
+		WARN_ONCE(_r, "%s returned %d (0x%x)\n", (name), _r, _r); \
+	} while (0);							  \
+}
+
+/**
+ * encls_failed() - Check if an ENCLS function failed
+ * @ret:	the return value of an ENCLS function call
+ *
+ * Check if an ENCLS function failed. This happens when the function causes a
+ * fault that is not caused by an EPCM conflict or when the function returns a
+ * non-zero value.
+ */
+static inline bool encls_failed(int ret)
+{
+	if (ret & ENCLS_FAULT_FLAG)
+		return ENCLS_TRAPNR(ret) != X86_TRAP_PF;
+
+	return !!ret;
+}
+
+/**
+ * __encls_ret_N - encode an ENCLS function that returns an error code in EAX
+ * @rax:	function number
+ * @inputs:	asm inputs for the function
+ *
+ * Emit assembly for an ENCLS function that returns an error code, e.g. EREMOVE.
+ * And because SGX isn't complex enough as it is, function that return an error
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
+ * __encls_N - encode an ENCLS function that doesn't return an error code
+ * @rax:	function number
+ * @rbx_out:	optional output variable
+ * @inputs:	asm inputs for the function
+ *
+ * Emit assembly for an ENCLS function that does not return an error code, e.g.
+ * ECREATE.  Leaves without error codes either succeed or fault.  @rbx_out is an
+ * optional parameter for use by EDGBRD, which returns the requested value in
+ * RBX.
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
+	return __encls_2(ECREATE, pginfo, secs);
+}
+
+static inline int __eextend(void *secs, void *addr)
+{
+	return __encls_2(EEXTEND, secs, addr);
+}
+
+static inline int __eadd(struct sgx_pageinfo *pginfo, void *addr)
+{
+	return __encls_2(EADD, pginfo, addr);
+}
+
+static inline int __einit(void *sigstruct, void *token, void *secs)
+{
+	return __encls_ret_3(EINIT, sigstruct, secs, token);
+}
+
+static inline int __eremove(void *addr)
+{
+	return __encls_ret_1(EREMOVE, addr);
+}
+
+static inline int __edbgwr(void *addr, unsigned long *data)
+{
+	return __encls_2(EDGBWR, *data, addr);
+}
+
+static inline int __edbgrd(void *addr, unsigned long *data)
+{
+	return __encls_1_1(EDGBRD, *data, addr);
+}
+
+static inline int __etrack(void *addr)
+{
+	return __encls_ret_1(ETRACK, addr);
+}
+
+static inline int __eldu(struct sgx_pageinfo *pginfo, void *addr,
+			 void *va)
+{
+	return __encls_ret_3(ELDU, pginfo, addr, va);
+}
+
+static inline int __eblock(void *addr)
+{
+	return __encls_ret_1(EBLOCK, addr);
+}
+
+static inline int __epa(void *addr)
+{
+	unsigned long rbx = SGX_PAGE_TYPE_VA;
+
+	return __encls_2(EPA, rbx, addr);
+}
+
+static inline int __ewb(struct sgx_pageinfo *pginfo, void *addr,
+			void *va)
+{
+	return __encls_ret_3(EWB, pginfo, addr, va);
+}
+
+#endif /* _X86_ENCLS_H */
-- 
2.27.0

