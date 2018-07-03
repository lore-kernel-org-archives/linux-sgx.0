From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: <x86@kernel.org>, <platform-driver-x86@vger.kernel.org>
CC: <dave.hansen@intel.com>, <sean.j.christopherson@intel.com>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, <linux-sgx@vger.kernel.org>,
	Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, Thomas Gleixner
	<tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin"
	<hpa@zytor.com>, "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)"
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v12 08/13] x86/sgx: wrappers for ENCLS opcode leaf functions
Date: Tue, 3 Jul 2018 21:19:53 +0300
Message-ID: <20180703182118.15024-9-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <20180703182118.15024-1-jarkko.sakkinen@linux.intel.com>
References: <20180703182118.15024-1-jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain
Return-Path: jarkko.sakkinen@intel.com
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

This commit adds wrappers for Intel(R) SGX ENCLS opcode leaf functions
except for ENCLS(EINIT). The ENCLS instruction invokes the privileged
functions for managing (creation, initialization and swapping) and
debugging enclaves.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/sgx.h      | 176 ++++++++++++++++++++++++++++++++
 arch/x86/include/asm/sgx_arch.h |  19 ++++
 2 files changed, 195 insertions(+)

diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
index 77b2294fcfb0..a42c8ed10f7d 100644
--- a/arch/x86/include/asm/sgx.h
+++ b/arch/x86/include/asm/sgx.h
@@ -11,6 +11,157 @@
 #include <linux/rwsem.h>
 #include <linux/types.h>
 
+#define IS_ENCLS_FAULT(r) ((r) & 0xffff0000)
+#define ENCLS_FAULT_VECTOR(r) ((r) >> 16)
+
+#define ENCLS_TO_ERR(r) (IS_ENCLS_FAULT(r) ? -EFAULT :		\
+			(r) == SGX_UNMASKED_EVENT ? -EINTR :	\
+			(r) == SGX_MAC_COMPARE_FAIL ? -EIO :	\
+			(r) == SGX_ENTRYEPOCH_LOCKED ? -EBUSY : -EPERM)
+
+#define __encls_ret_N(rax, inputs...)			\
+	({						\
+	int ret;					\
+	asm volatile(					\
+	"1: .byte 0x0f, 0x01, 0xcf;\n\t"		\
+	"2:\n"						\
+	".section .fixup,\"ax\"\n"			\
+	"3: shll $16,%%eax\n"				\
+	"   jmp 2b\n"					\
+	".previous\n"					\
+	_ASM_EXTABLE_FAULT(1b, 3b)			\
+	: "=a"(ret)					\
+	: "a"(rax), inputs				\
+	: "memory");					\
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
+#define __encls_N(rax, rbx_out, inputs...)		\
+	({						\
+	int ret;					\
+	asm volatile(					\
+	"1: .byte 0x0f, 0x01, 0xcf;\n\t"		\
+	"   xor %%eax,%%eax;\n"				\
+	"2:\n"						\
+	".section .fixup,\"ax\"\n"			\
+	"3: shll $16,%%eax\n"				\
+	"   jmp 2b\n"					\
+	".previous\n"					\
+	_ASM_EXTABLE_FAULT(1b, 3b)				\
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
+static inline int __edbgwr(unsigned long addr, unsigned long *data)
+{
+	return __encls_2(EDGBWR, *data, addr);
+}
+
+static inline int __edbgrd(unsigned long addr, unsigned long *data)
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
 #define SGX_MAX_EPC_BANKS 8
 
 #define SGX_EPC_BANK(epc_page) \
@@ -39,4 +190,29 @@ extern bool sgx_lc_enabled;
 void *sgx_get_page(struct sgx_epc_page *ptr);
 void sgx_put_page(void *epc_page_ptr);
 
+#define SGX_FN(name, params...)		\
+{					\
+	void *epc;			\
+	int ret;			\
+	epc = sgx_get_page(epc_page);	\
+	ret = __##name(params);		\
+	sgx_put_page(epc);		\
+	return ret;			\
+}
+
+#define BUILD_SGX_FN(fn, name)				\
+static inline int fn(struct sgx_epc_page *epc_page)	\
+	SGX_FN(name, epc)
+BUILD_SGX_FN(sgx_eremove, eremove)
+BUILD_SGX_FN(sgx_eblock, eblock)
+BUILD_SGX_FN(sgx_etrack, etrack)
+BUILD_SGX_FN(sgx_epa, epa)
+
+static inline int sgx_emodpr(struct sgx_secinfo *secinfo,
+			     struct sgx_epc_page *epc_page)
+	SGX_FN(emodpr, secinfo, epc)
+static inline int sgx_emodt(struct sgx_secinfo *secinfo,
+			    struct sgx_epc_page *epc_page)
+	SGX_FN(emodt, secinfo, epc)
+
 #endif /* _ASM_X86_SGX_H */
diff --git a/arch/x86/include/asm/sgx_arch.h b/arch/x86/include/asm/sgx_arch.h
index 41a37eaa3f51..85e6eb4c11a5 100644
--- a/arch/x86/include/asm/sgx_arch.h
+++ b/arch/x86/include/asm/sgx_arch.h
@@ -14,6 +14,25 @@ enum sgx_cpuid {
 	SGX_CPUID_EPC_BANKS	= 2,
 };
 
+enum sgx_encls_leafs {
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
 #define SGX_SSA_GPRS_SIZE		182
 #define SGX_SSA_MISC_EXINFO_SIZE	16
 
-- 
2.17.1
