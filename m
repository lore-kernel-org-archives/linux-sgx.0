From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: <x86@kernel.org>, <platform-driver-x86@vger.kernel.org>
CC: <dave.hansen@intel.com>, <sean.j.christopherson@intel.com>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, <serge.ayoun@intel.com>,
	<shay.katz-zamir@intel.com>, <linux-sgx@vger.kernel.org>,
	<andriy.shevchenko@linux.intel.com>, Jarkko Sakkinen
	<jarkko.sakkinen@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo
 Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin"
	<hpa@zytor.com>, Suresh Siddha <suresh.b.siddha@intel.com>, "open list:X86
 ARCHITECTURE (32-BIT AND 64-BIT)" <linux-kernel@vger.kernel.org>
Subject: [PATCH v14 14/19] x86/sgx: Add sgx_einit() for initializing enclaves
Date: Tue, 25 Sep 2018 16:06:51 +0300
Message-ID: <20180925130845.9962-15-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <20180925130845.9962-1-jarkko.sakkinen@linux.intel.com>
References: <20180925130845.9962-1-jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain
Return-Path: jarkko.sakkinen@intel.com
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

From: Sean Christopherson <sean.j.christopherson@intel.com>

Add a function to perform ENCLS(EINIT), which initializes an enclave,
which can be used by a driver for running enclaves and VMMs.

Writing the LE hash MSRs is extraordinarily expensive, e.g. 3-4x slower
than normal MSRs, so we use a per-cpu cache to track the last known value
of the MSRs to avoid unnecessarily writing the MSRs with the current value.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Co-developed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/include/asm/sgx.h      |  2 ++
 arch/x86/kernel/cpu/intel_sgx.c | 53 +++++++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+)

diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
index 6ea5a6dbd36d..d5c535db094c 100644
--- a/arch/x86/include/asm/sgx.h
+++ b/arch/x86/include/asm/sgx.h
@@ -313,5 +313,7 @@ static inline int __emodt(struct sgx_secinfo *secinfo, void __iomem *addr)
 struct sgx_epc_page *sgx_alloc_page(void *owner, bool reclaim);
 int __sgx_free_page(struct sgx_epc_page *page);
 void sgx_free_page(struct sgx_epc_page *page);
+int sgx_einit(struct sgx_sigstruct *sigstruct, struct sgx_einittoken *token,
+	      struct sgx_epc_page *secs, u64 *lepubkeyhash);
 
 #endif /* _ASM_X86_SGX_H */
diff --git a/arch/x86/kernel/cpu/intel_sgx.c b/arch/x86/kernel/cpu/intel_sgx.c
index ef30d6730859..e36572f320c7 100644
--- a/arch/x86/kernel/cpu/intel_sgx.c
+++ b/arch/x86/kernel/cpu/intel_sgx.c
@@ -19,6 +19,11 @@ EXPORT_SYMBOL_GPL(sgx_epc_sections);
 
 static int sgx_nr_epc_sections;
 
+/* The cache for the last known values of IA32_SGXLEPUBKEYHASHx MSRs for each
+ * CPU. The entries are initialized when they are first used by sgx_einit().
+ */
+static DEFINE_PER_CPU(u64 [4], sgx_lepubkeyhash_cache);
+
 /**
  * sgx_alloc_page - Allocate an EPC page
  * @owner:	the owner of the EPC page
@@ -104,6 +109,54 @@ void sgx_free_page(struct sgx_epc_page *page)
 }
 EXPORT_SYMBOL_GPL(sgx_free_page);
 
+static void sgx_update_lepubkeyhash_msrs(u64 *lepubkeyhash, bool enforce)
+{
+	u64 *cache;
+	int i;
+
+	cache = per_cpu(sgx_lepubkeyhash_cache, smp_processor_id());
+	for (i = 0; i < 4; i++) {
+		if (enforce || (lepubkeyhash[i] != cache[i])) {
+			wrmsrl(MSR_IA32_SGXLEPUBKEYHASH0 + i, lepubkeyhash[i]);
+			cache[i] = lepubkeyhash[i];
+		}
+	}
+}
+
+/**
+ * sgx_einit - initialize an enclave
+ * @sigstruct:		a pointer a SIGSTRUCT
+ * @token:		a pointer an EINITTOKEN (optional)
+ * @secs:		a pointer a SECS
+ * @lepubkeyhash:	the desired value for IA32_SGXLEPUBKEYHASHx MSRs
+ *
+ * Try to perform EINIT operation. If the MSRs are writable, they are updated
+ * according to @lepubkeyhash.
+ *
+ * Return:
+ *   0 on success,
+ *   -errno or SGX error on failure
+ */
+int sgx_einit(struct sgx_sigstruct *sigstruct, struct sgx_einittoken *token,
+	      struct sgx_epc_page *secs, u64 *lepubkeyhash)
+{
+	int ret;
+
+	if (!sgx_lc_enabled)
+		return __einit(sigstruct, token, sgx_epc_addr(secs));
+
+	preempt_disable();
+	sgx_update_lepubkeyhash_msrs(lepubkeyhash, false);
+	ret = __einit(sigstruct, token, sgx_epc_addr(secs));
+	/* A legit case because MSRs are reset after waking up. */
+	if (ret == SGX_INVALID_EINITTOKEN) {
+		sgx_update_lepubkeyhash_msrs(lepubkeyhash, true);
+		ret = __einit(sigstruct, token, sgx_epc_addr(secs));
+	}
+	preempt_enable();
+	return ret;
+}
+EXPORT_SYMBOL(sgx_einit);
 
 static __init void sgx_free_epc_section(struct sgx_epc_section *section)
 {
-- 
2.17.1
