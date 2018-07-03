From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: <x86@kernel.org>, <platform-driver-x86@vger.kernel.org>
CC: <dave.hansen@intel.com>, <sean.j.christopherson@intel.com>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, <linux-sgx@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H.
 Peter Anvin" <hpa@zytor.com>, Jarkko Sakkinen
	<jarkko.sakkinen@linux.intel.com>, "open list:X86 ARCHITECTURE (32-BIT AND
 64-BIT)" <linux-kernel@vger.kernel.org>
Subject: [PATCH v12 10/13] x86/sgx: sgx_einit()
Date: Tue, 3 Jul 2018 21:19:55 +0300
Message-ID: <20180703182118.15024-11-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <20180703182118.15024-1-jarkko.sakkinen@linux.intel.com>
References: <20180703182118.15024-1-jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain
Return-Path: jarkko.sakkinen@intel.com
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

From: Sean Christopherson <sean.j.christopherson@intel.com>

Implements function to perform ENCLS(EINIT) leaf function that initializes
an enclave, which can be used by a driver for running enclaves and VMMs.

Writing the LE hash MSRs is extraordinarily expensive, e.g. 3-4x slower
than normal MSRs, so we use a per-cpu cache to track the last known value
of the MSRs to avoid unnecessarily writing the MSRs with the current value.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/sgx.h      |  2 ++
 arch/x86/kernel/cpu/intel_sgx.c | 46 +++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+)

diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
index 4f5f32b37b5d..bc09b4576d68 100644
--- a/arch/x86/include/asm/sgx.h
+++ b/arch/x86/include/asm/sgx.h
@@ -215,6 +215,8 @@ void *sgx_get_page(struct sgx_epc_page *ptr);
 void sgx_put_page(void *epc_page_ptr);
 struct page *sgx_get_backing(struct file *file, pgoff_t index);
 void sgx_put_backing(struct page *backing_page, bool write);
+int sgx_einit(struct sgx_sigstruct *sigstruct, struct sgx_einittoken *token,
+	      struct sgx_epc_page *secs_page, u64 le_pubkey_hash[4]);
 
 #define SGX_FN(name, params...)		\
 {					\
diff --git a/arch/x86/kernel/cpu/intel_sgx.c b/arch/x86/kernel/cpu/intel_sgx.c
index b52bab8eff99..53dd91cb7a49 100644
--- a/arch/x86/kernel/cpu/intel_sgx.c
+++ b/arch/x86/kernel/cpu/intel_sgx.c
@@ -31,6 +31,12 @@ static int sgx_nr_epc_banks;
 static struct task_struct *ksgxswapd_tsk;
 static DECLARE_WAIT_QUEUE_HEAD(ksgxswapd_waitq);
 
+/*
+ * A cache for last known values of IA32_SGXLEPUBKEYHASHx MSRs. Cache entries
+ * are initialized when they are first used by sgx_einit().
+ */
+static DEFINE_PER_CPU(u64 [4], sgx_le_pubkey_hash_cache);
+
 static void sgx_swap_cluster(void)
 {
 	struct sgx_epc_page *cluster[SGX_NR_TO_SCAN + 1];
@@ -255,6 +261,46 @@ void sgx_put_backing(struct page *backing_page, bool write)
 }
 EXPORT_SYMBOL(sgx_put_backing);
 
+/**
+ * sgx_einit - EINIT an enclave with the appropriate LE pubkey hash
+ * @sigstruct:		a pointer to the enclave's sigstruct
+ * @token:		a pointer to the enclave's EINIT token
+ * @secs_page:		a pointer to the enclave's SECS EPC page
+ * @le_pubkey_hash:	the desired LE pubkey hash for EINIT
+ */
+int sgx_einit(struct sgx_sigstruct *sigstruct, struct sgx_einittoken *token,
+	      struct sgx_epc_page *secs_page, u64 le_pubkey_hash[4])
+{
+	u64 __percpu *cache;
+	void *secs;
+	int i, ret;
+
+	secs = sgx_get_page(secs_page);
+
+	if (!sgx_lc_enabled) {
+		ret = __einit(sigstruct, token, secs);
+		goto out;
+	}
+
+	cache = per_cpu(sgx_le_pubkey_hash_cache, smp_processor_id());
+
+	preempt_disable();
+	for (i = 0; i < 4; i++) {
+		if (le_pubkey_hash[i] == cache[i])
+			continue;
+
+		wrmsrl(MSR_IA32_SGXLEPUBKEYHASH0 + i, le_pubkey_hash[i]);
+		cache[i] = le_pubkey_hash[i];
+	}
+	ret = __einit(sigstruct, token, secs);
+	preempt_enable();
+
+out:
+	sgx_put_page(secs);
+	return ret;
+}
+EXPORT_SYMBOL(sgx_einit);
+
 static __init int sgx_init_epc_bank(unsigned long addr, unsigned long size,
 				    unsigned long index,
 				    struct sgx_epc_bank *bank)
-- 
2.17.1
