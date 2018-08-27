From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: <x86@kernel.org>, <platform-driver-x86@vger.kernel.org>
CC: <dave.hansen@intel.com>, <sean.j.christopherson@intel.com>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, <linux-sgx@vger.kernel.org>,
	Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Thomas Gleixner
	<tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin"
	<hpa@zytor.com>, Serge Ayoun <serge.ayoun@intel.com>, Suresh Siddha
	<suresh.b.siddha@intel.com>, "open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)" <linux-kernel@vger.kernel.org>
Subject: [PATCH v13 08/13] x86/sgx: Add wrappers for ENCLS leaf functions
Date: Mon, 27 Aug 2018 21:53:29 +0300
Message-ID: <20180827185507.17087-9-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <20180827185507.17087-1-jarkko.sakkinen@linux.intel.com>
References: <20180827185507.17087-1-jarkko.sakkinen@linux.intel.com>
Sender: <linux-kernel-owner@vger.kernel.org>
Content-Type: text/plain
Return-Path: linux-kernel-owner@vger.kernel.org
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

Add wrappers for Intel(R) SGX ENCLS opcode leaf functions except
ENCLS(EINIT). ENCLS invokes privileged functions for managing (creation,
initialization and swapping) and debugging enclaves.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/sgx.h | 261 +++++++++++++++++++++++++++++++++++++
 1 file changed, 261 insertions(+)

diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
index 17b7b3aa66bf..f8e419378f30 100644
--- a/arch/x86/include/asm/sgx.h
+++ b/arch/x86/include/asm/sgx.h
@@ -69,4 +69,265 @@ static inline void *sgx_epc_addr(struct sgx_epc_page *page)
 	return (void *)(bank->va + (page->desc & PAGE_MASK) - bank->pa);
 }
 
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
+#define ENCLS_FAULT_FLAG 0x40000000UL
+#define ENCLS_FAULT_FLAG_ASM "$0x40000000"
+
+/**
+ * IS_ENCLS_FAULT - check if a return code indicates an ENCLS fault
+ *
+ * Check for a fault by looking for a postive value with the fault
+ * flag set.  The postive value check is needed to filter out system
+ * error codes since negative values will have all higher order bits
+ * set, including ENCLS_FAULT_FLAG.
+ */
+#define IS_ENCLS_FAULT(r) ((int)(r) > 0 && ((r) & ENCLS_FAULT_FLAG))
+
+/**
+ * ENCLS_TRAPNR - retrieve the trapnr exactly as passed via _ASM_EXTABLE_FAULT
+ *
+ * Retrieve the encoded trapnr from the specified return code, keeping
+ * any error code bits that were included in trapnr when it was supplied
+ * to the _ASM_EXTABLE_FAULT handler.
+ */
+#define ENCLS_TRAPNR(r) ((r) & ~ENCLS_FAULT_FLAG)
+
+/**
+ * ENCLS_FAULT_VECTOR - retrieve the fault vector from a return code
+ *
+ * Retrieve the encoded fault vector, e.g. #GP or #PF, from the specified
+ * return code, dropping any potential error code bits in trapnr.
+ */
+#define ENCLS_FAULT_VECTOR(r) (ENCLS_TRAPNR(r) & 0x1f)
+
+/**
+ * encls_to_err - translate an ENCLS fault or SGX code into a system error code
+ * @ret:	positive value return code
+ *
+ * Returns:
+ *	-EFAULT for faults
+ *	-EINTR for unmasked events
+ *	-EINVAL for SGX_INVALID_* error codes
+ *	-EBUSY for non-fatal resource contention errors
+ *	-EIO for all other errors
+ *
+ * Translate a postive return code, e.g. from ENCLS, into a system error
+ * code.  Primarily used by functions that cannot return a non-negative
+ * error code, e.g. kernel callbacks.
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
+ * Returns:
+ *	0 on success
+ *	SGX error code on failure
+ *	trapnr with ENCLS_FAULT_FLAG set on fault
+ *
+ * Emit assembly for an ENCLS leaf that returns an error code, e.g. EREMOVE.
+ * And because SGX isn't complex enough as it is, leafs that return an error
+ * code also modify flags.
+ */
+#define __encls_ret_N(rax, inputs...)			\
+	({						\
+	int ret;					\
+	asm volatile(					\
+	"1: .byte 0x0f, 0x01, 0xcf;\n\t"		\
+	"2:\n"						\
+	".section .fixup,\"ax\"\n"			\
+	"3: orl "ENCLS_FAULT_FLAG_ASM",%%eax\n"		\
+	"   jmp 2b\n"					\
+	".previous\n"					\
+	_ASM_EXTABLE_FAULT(1b, 3b)			\
+	: "=a"(ret)					\
+	: "a"(rax), inputs				\
+	: "memory", "cc");				\
+	ret;						\
+	})
+
+#define __encls_ret_1(rax, rcx)				\
+	({						\
+	__encls_ret_N(rax, "c"(rcx));			\
+	})
+
+#define __encls_ret_2(rax, rbx, rcx)			\
+	({						\
+	__encls_ret_N(rax, "b"(rbx), "c"(rcx));		\
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
+ * Returns:
+ *	0 on success
+ *	trapnr with ENCLS_FAULT_FLAG set on fault
+ *
+ * Emit assembly for an ENCLS leaf that does not return an error code,
+ * e.g. ECREATE.  Leaves without error codes either succeed or fault.
+ * @rbx_out is an optional parameter for use by EDGBRD, which returns
+ * the the requested value in RBX.
+ */
+#define __encls_N(rax, rbx_out, inputs...)		\
+	({						\
+	int ret;					\
+	asm volatile(					\
+	"1: .byte 0x0f, 0x01, 0xcf;\n\t"		\
+	"   xor %%eax,%%eax;\n"				\
+	"2:\n"						\
+	".section .fixup,\"ax\"\n"			\
+	"3: orl "ENCLS_FAULT_FLAG_ASM",%%eax\n"		\
+	"   jmp 2b\n"					\
+	".previous\n"					\
+	_ASM_EXTABLE_FAULT(1b, 3b)			\
+	: "=a"(ret), "=b"(rbx_out)			\
+	: "a"(rax), inputs				\
+	: "memory");					\
+	ret;						\
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
+static inline int __eextend(void *secs, void *epc)
+{
+	return __encls_2(EEXTEND, secs, epc);
+}
+
+static inline int __eadd(struct sgx_pageinfo *pginfo, void *epc)
+{
+	return __encls_2(EADD, pginfo, epc);
+}
+
+static inline int __einit(void *sigstruct, struct sgx_einittoken *einittoken,
+			  void *secs)
+{
+	return __encls_ret_3(EINIT, sigstruct, secs, einittoken);
+}
+
+static inline int __eremove(void *epc)
+{
+	return __encls_ret_1(EREMOVE, epc);
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
+static inline int __etrack(void *epc)
+{
+	return __encls_ret_1(ETRACK, epc);
+}
+
+static inline int __eldu(struct sgx_pageinfo *pginfo, void *epc, void *va)
+{
+	return __encls_ret_3(ELDU, pginfo, epc, va);
+}
+
+static inline int __eblock(void *epc)
+{
+	return __encls_ret_1(EBLOCK, epc);
+}
+
+static inline int __epa(void *epc)
+{
+	unsigned long rbx = SGX_PAGE_TYPE_VA;
+
+	return __encls_2(EPA, rbx, epc);
+}
+
+static inline int __ewb(struct sgx_pageinfo *pginfo, void *epc, void *va)
+{
+	return __encls_ret_3(EWB, pginfo, epc, va);
+}
+
+static inline int __eaug(struct sgx_pageinfo *pginfo, void *epc)
+{
+	return __encls_2(EAUG, pginfo, epc);
+}
+
+static inline int __emodpr(struct sgx_secinfo *secinfo, void *epc)
+{
+	return __encls_ret_2(EMODPR, secinfo, epc);
+}
+
+static inline int __emodt(struct sgx_secinfo *secinfo, void *epc)
+{
+	return __encls_ret_2(EMODT, secinfo, epc);
+}
+
 #endif /* _ASM_X86_SGX_H */
-- 
2.17.1
