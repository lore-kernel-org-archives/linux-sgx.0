From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: <x86@kernel.org>, <platform-driver-x86@vger.kernel.org>,
	<linux-sgx@vger.kernel.org>
CC: <dave.hansen@intel.com>, <sean.j.christopherson@intel.com>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, <serge.ayoun@intel.com>,
	<shay.katz-zamir@intel.com>, <haitao.huang@intel.com>,
	<mark.shanahan@intel.com>, <andriy.shevchenko@linux.intel.com>, "Jarkko
 Sakkinen" <jarkko.sakkinen@linux.intel.com>, Thomas Gleixner
	<tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, "open list:X86
 ARCHITECTURE (32-BIT AND 64-BIT)" <linux-kernel@vger.kernel.org>
Subject: [PATCH v15 11/23] x86/sgx: Add definitions for SGX's CPUID leaf and variable sub-leafs
Date: Sat, 3 Nov 2018 01:11:10 +0200
Message-ID: <20181102231320.29164-12-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <20181102231320.29164-1-jarkko.sakkinen@linux.intel.com>
References: <20181102231320.29164-1-jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain
Return-Path: jarkko.sakkinen@intel.com
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

SGX defines its own CPUID leaf, 0x12, along with a variable number of
sub-leafs.  Sub-leafs 0 and 1 are always available if SGX is supported
and enumerate various SGX features, e.g. instruction sets and enclave
capabilities.  Sub-leafs 2+ are variable, both in their existence and
in what they enumerate.  Bits 3:0 of EAX report the sub-leaf type,
with the remaining bits in EAX, EBX, ECX and EDX being type-specific.
Currently, the only known sub-leaf type enumerates an EPC section.  An
EPC section is simply a range of EPC memory available to software.
The "list" of varaible SGX sub-leafs is NULL-terminated, i.e. software
is expected to query CPUID until an invalid sub-leaf is encountered.

Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/include/asm/sgx_arch.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/x86/include/asm/sgx_arch.h b/arch/x86/include/asm/sgx_arch.h
index d4c57154e6e6..29c37971e8b3 100644
--- a/arch/x86/include/asm/sgx_arch.h
+++ b/arch/x86/include/asm/sgx_arch.h
@@ -11,6 +11,21 @@
 #include <linux/types.h>
 #include <uapi/asm/sgx_errno.h>
 
+#define SGX_CPUID				0x12
+#define SGX_CPUID_FIRST_VARIABLE_SUB_LEAF	2
+
+/**
+ * enum sgx_sub_leaf_types - SGX CPUID variable sub-leaf types
+ * %SGX_CPUID_SUB_LEAF_INVALID:		Indicates this sub-leaf is invalid.
+ * %SGX_CPUID_SUB_LEAF_EPC_SECTION:	Sub-leaf enumerates an EPC section.
+ * %SGX_CPUID_SUB_LEAF_TYPE_MASK:	Mask for bits containing the type.
+ */
+enum sgx_sub_leaf_types {
+	SGX_CPUID_SUB_LEAF_INVALID	= 0x0,
+	SGX_CPUID_SUB_LEAF_EPC_SECTION	= 0x1,
+	SGX_CPUID_SUB_LEAF_TYPE_MASK	= 0xF,
+};
+
 /**
  * enum sgx_encls_leaves - ENCLS leaf functions
  * %SGX_ECREATE:	Create an enclave.
-- 
2.19.1
