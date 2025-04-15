Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C470292911;
	Tue, 15 Apr 2025 11:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744717979; cv=none; b=h5n5DVfORpCFpa4zax2IpGRzYE5M+XgtO4K6rzEdXh1bAWNnNrBSO6wIlUmowjBadOZ/Fdof2I2DZX1fGTx3LTDSSr73HQWsPWMTq3LBwC+KEYmsa/138Ij2e+iaV4iZp6gMe9Zzqc/svtYlkQ/sAqws4CeWkZ2tztj3U0gHIF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744717979; c=relaxed/simple;
	bh=vJqrNyF2WzLTIckMUxvQxoO3APERPiaclcqQBCmM+HQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r6RRgQ+Uayx/KqzhagZKbd5QG187Sn0IT/LWsUpMBllaUGQt6UYSdM/bFGHB2sgkN+YuKCHXl8/NQ8JDORFPYSaAxZUA1M/bu2nKqkcmJ9OIVFoUYD/Svb7Nhm13YbZL1tSB94XL/n6tsfxzZXMBSxTlW7EQwh8XAhHt7h4gXn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aVkgvTPC; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aVkgvTPC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744717978; x=1776253978;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vJqrNyF2WzLTIckMUxvQxoO3APERPiaclcqQBCmM+HQ=;
  b=aVkgvTPCaMuOq8H7xfjUYwHQTy2QDt2rVFGTzOFawF2Mj4MyvA3lyebJ
   ThJUU4JCmgDuVfv6MfmXIPLn2Nm6ml46fBBdEofZrfXZhqpENa+pPytvD
   mIfiuzi5We1qISjgeYpuVyUl4ft0/1XhSTe/n9lwHsiSiG9OUyhCjnUkn
   9FF5U/zylKcMUic5BP/o2mlTJUeSSZG4ZF5p/ZG6mdhKwoiNPDRG0+Wv+
   0BTNB0EMYAOl0PKgl2piYq/KC6wtbm3Gr1+1OxPNYUaZcg/93FzD8U0jF
   sFtKZULOgCc3vKQslVDT/kyyzUkL0ORChpSjxn8T4nxvOiLxT4xBahM94
   g==;
X-CSE-ConnectionGUID: 8d+l9xudRSiXy7NIHPcAkw==
X-CSE-MsgGUID: 7xaTst4zQCmNalxbTTt1UA==
X-IronPort-AV: E=McAfee;i="6700,10204,11403"; a="46235134"
X-IronPort-AV: E=Sophos;i="6.15,213,1739865600"; 
   d="scan'208";a="46235134"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2025 04:52:43 -0700
X-CSE-ConnectionGUID: eJKl4/d2SDyqiVaqcNZDIg==
X-CSE-MsgGUID: 9HfFFuWqTSGN2oOCZ7tJMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,213,1739865600"; 
   d="scan'208";a="130997587"
Received: from bergbenj-mobl1.ger.corp.intel.com (HELO eresheto-mobl3.ger.corp.intel.com) ([10.245.246.46])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2025 04:52:37 -0700
From: Elena Reshetova <elena.reshetova@intel.com>
To: dave.hansen@intel.com
Cc: jarkko@kernel.org,
	linux-sgx@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	asit.k.mallick@intel.com,
	vincent.r.scarlata@intel.com,
	chongc@google.com,
	erdemaktas@google.com,
	vannapurve@google.com,
	dionnaglaze@google.com,
	bondarn@google.com,
	scott.raynor@intel.com,
	Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH v3 2/2] x86/sgx: Implement EUPDATESVN and opportunistically call it during first EPC page alloc
Date: Tue, 15 Apr 2025 14:51:22 +0300
Message-ID: <20250415115213.291449-3-elena.reshetova@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250415115213.291449-1-elena.reshetova@intel.com>
References: <20250415115213.291449-1-elena.reshetova@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

SGX architecture introduced a new instruction called EUPDATESVN
to Ice Lake. It allows updating security SVN version, given that EPC
is completely empty. The latter is required for security reasons
in order to reason that enclave security posture is as secure as the
security SVN version of the TCB that created it.

Additionally it is important to ensure that while ENCLS[EUPDATESVN]
runs, no concurrent page creation happens in EPC, because it might
result in #GP delivered to the creator. Legacy SW might not be prepared
to handle such unexpected #GPs and therefore this patch introduces
a locking mechanism to ensure no concurrent EPC allocations can happen.

It is also ensured that ENCLS[EUPDATESVN] is not called when running
in a VM since it does not have a meaning in this context (microcode
updates application is limited to the host OS) and will create
unnecessary load.

This patch is based on previous submision by Cathy Zhang
https://lore.kernel.org/all/20220520103904.1216-1-cathy.zhang@intel.com/

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
---
 arch/x86/include/asm/sgx.h      | 41 +++++++++++------
 arch/x86/kernel/cpu/sgx/encls.h |  6 +++
 arch/x86/kernel/cpu/sgx/main.c  | 82 ++++++++++++++++++++++++++++++++-
 arch/x86/kernel/cpu/sgx/sgx.h   |  1 +
 4 files changed, 114 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
index 6a0069761508..5caf5c31ebc6 100644
--- a/arch/x86/include/asm/sgx.h
+++ b/arch/x86/include/asm/sgx.h
@@ -26,23 +26,26 @@
 #define SGX_CPUID_EPC_SECTION	0x1
 /* The bitmask for the EPC section type. */
 #define SGX_CPUID_EPC_MASK	GENMASK(3, 0)
+/* EUPDATESVN presence indication */
+#define SGX_CPUID_EUPDATESVN	BIT(10)
 
 enum sgx_encls_function {
-	ECREATE	= 0x00,
-	EADD	= 0x01,
-	EINIT	= 0x02,
-	EREMOVE	= 0x03,
-	EDGBRD	= 0x04,
-	EDGBWR	= 0x05,
-	EEXTEND	= 0x06,
-	ELDU	= 0x08,
-	EBLOCK	= 0x09,
-	EPA	= 0x0A,
-	EWB	= 0x0B,
-	ETRACK	= 0x0C,
-	EAUG	= 0x0D,
-	EMODPR	= 0x0E,
-	EMODT	= 0x0F,
+	ECREATE		= 0x00,
+	EADD		= 0x01,
+	EINIT		= 0x02,
+	EREMOVE		= 0x03,
+	EDGBRD		= 0x04,
+	EDGBWR		= 0x05,
+	EEXTEND		= 0x06,
+	ELDU		= 0x08,
+	EBLOCK		= 0x09,
+	EPA		= 0x0A,
+	EWB		= 0x0B,
+	ETRACK		= 0x0C,
+	EAUG		= 0x0D,
+	EMODPR		= 0x0E,
+	EMODT		= 0x0F,
+	EUPDATESVN	= 0x18,
 };
 
 /**
@@ -73,6 +76,11 @@ enum sgx_encls_function {
  *				public key does not match IA32_SGXLEPUBKEYHASH.
  * %SGX_PAGE_NOT_MODIFIABLE:	The EPC page cannot be modified because it
  *				is in the PENDING or MODIFIED state.
+ * %SGX_INSUFFICIENT_ENTROPY:	Insufficient entropy in RNG.
+ * %SGX_EPC_NOT_READY:		EPC is not ready for SVN update.
+ * %SGX_NO_UPDATE:		EUPDATESVN was successful, but CPUSVN was not
+ *				updated because current SVN was not newer than
+ *				CPUSVN.
  * %SGX_UNMASKED_EVENT:		An unmasked event, e.g. INTR, was received
  */
 enum sgx_return_code {
@@ -81,6 +89,9 @@ enum sgx_return_code {
 	SGX_CHILD_PRESENT		= 13,
 	SGX_INVALID_EINITTOKEN		= 16,
 	SGX_PAGE_NOT_MODIFIABLE		= 20,
+	SGX_INSUFFICIENT_ENTROPY	= 29,
+	SGX_EPC_NOT_READY		= 30,
+	SGX_NO_UPDATE			= 31,
 	SGX_UNMASKED_EVENT		= 128,
 };
 
diff --git a/arch/x86/kernel/cpu/sgx/encls.h b/arch/x86/kernel/cpu/sgx/encls.h
index 99004b02e2ed..3d83c76dc91f 100644
--- a/arch/x86/kernel/cpu/sgx/encls.h
+++ b/arch/x86/kernel/cpu/sgx/encls.h
@@ -233,4 +233,10 @@ static inline int __eaug(struct sgx_pageinfo *pginfo, void *addr)
 	return __encls_2(EAUG, pginfo, addr);
 }
 
+/* Update CPUSVN at runtime. */
+static inline int __eupdatesvn(void)
+{
+	return __encls_ret_1(EUPDATESVN, "");
+}
+
 #endif /* _X86_ENCLS_H */
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index b61d3bad0446..c21f4f6226b0 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -32,6 +32,11 @@ static DEFINE_XARRAY(sgx_epc_address_space);
 static LIST_HEAD(sgx_active_page_list);
 static DEFINE_SPINLOCK(sgx_reclaimer_lock);
 
+/* This lock is held to prevent new EPC pages from being created
+ * during the execution of ENCLS[EUPDATESVN].
+ */
+static DEFINE_SPINLOCK(sgx_epc_eupdatesvn_lock);
+
 static atomic_long_t sgx_nr_used_pages = ATOMIC_LONG_INIT(0);
 static unsigned long sgx_nr_total_pages;
 
@@ -444,6 +449,7 @@ static struct sgx_epc_page *__sgx_alloc_epc_page_from_node(int nid)
 {
 	struct sgx_numa_node *node = &sgx_numa_nodes[nid];
 	struct sgx_epc_page *page = NULL;
+	bool ret;
 
 	spin_lock(&node->lock);
 
@@ -452,12 +458,33 @@ static struct sgx_epc_page *__sgx_alloc_epc_page_from_node(int nid)
 		return NULL;
 	}
 
+	if (!atomic_long_inc_not_zero(&sgx_nr_used_pages)) {
+		spin_lock(&sgx_epc_eupdatesvn_lock);
+		/*
+		 * Only call sgx_updatesvn() once the first enclave's
+		 * page is allocated from EPC
+		 */
+		if (atomic_long_read(&sgx_nr_used_pages) == 0) {
+			ret = sgx_updatesvn();
+			if (!ret) {
+				/*
+				 * sgx_updatesvn() returned unknown error, smth
+				 * must be broken, do not allocate a page from EPC
+				 */
+				spin_unlock(&sgx_epc_eupdatesvn_lock);
+				spin_unlock(&node->lock);
+				return NULL;
+			}
+		}
+		atomic_long_inc(&sgx_nr_used_pages);
+		spin_unlock(&sgx_epc_eupdatesvn_lock);
+	}
+
 	page = list_first_entry(&node->free_page_list, struct sgx_epc_page, list);
 	list_del_init(&page->list);
 	page->flags = 0;
 
 	spin_unlock(&node->lock);
-	atomic_long_inc(&sgx_nr_used_pages);
 
 	return page;
 }
@@ -970,3 +997,56 @@ static int __init sgx_init(void)
 }
 
 device_initcall(sgx_init);
+
+/**
+ * sgx_updatesvn() - Issue ENCLS[EUPDATESVN]
+ * If EPC is ready, this instruction will update CPUSVN to the currently
+ * loaded microcode update SVN and generate new cryptographic assets.
+ *
+ * Return:
+ * True: success or EUPDATESVN can be safely retried next time
+ * False: Unexpected error occurred
+ */
+bool sgx_updatesvn(void)
+{
+	int retry = 10;
+	int ret;
+
+	lockdep_assert_held(&sgx_epc_eupdatesvn_lock);
+
+	if (!(cpuid_eax(SGX_CPUID) & SGX_CPUID_EUPDATESVN))
+		return true;
+
+	/*
+	 * Do not execute ENCLS[EUPDATESVN] if running in a VM since
+	 * microcode updates are only meaningful to be applied on the host.
+	 */
+	if (boot_cpu_has(X86_FEATURE_HYPERVISOR))
+		return true;
+
+	do {
+		ret = __eupdatesvn();
+		if (ret != SGX_INSUFFICIENT_ENTROPY)
+			break;
+
+	} while (--retry);
+
+	switch (ret) {
+	case 0:
+		pr_info("EUPDATESVN: success\n");
+		break;
+	case SGX_EPC_NOT_READY:
+	case SGX_INSUFFICIENT_ENTROPY:
+	case SGX_EPC_PAGE_CONFLICT:
+		ENCLS_WARN(ret, "EUPDATESVN");
+		break;
+	case SGX_NO_UPDATE:
+		break;
+	default:
+		ENCLS_WARN(ret, "EUPDATESVN");
+		return false;
+	}
+
+	return true;
+
+}
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index d2dad21259a8..d7d631c973d0 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -103,5 +103,6 @@ static inline int __init sgx_vepc_init(void)
 #endif
 
 void sgx_update_lepubkeyhash(u64 *lepubkeyhash);
+bool sgx_updatesvn(void);
 
 #endif /* _X86_SGX_H */
-- 
2.45.2

