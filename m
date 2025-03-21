Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 688A522A4D8;
	Fri, 21 Mar 2025 12:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742560828; cv=none; b=ZVAXvSikw4HeSKIuPtKNYqeI+Ejyz0Rne7GgqJSlNj8VNxiY3TX2MB78EaFBCYm2UEDBChgt0T5GyLmoiTtS3h8rmWTfN+/jw9bJga+jq2aTntgFzGByyClqnBs5bBUynRsAaMAK0OX92M/dK/a5JeFwteVJqGeMZdiSzSlY4IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742560828; c=relaxed/simple;
	bh=qVkCx9Q/hxNNJcyqpxOD7H8MnEgWj+eoaHhhFqRCp8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R8JWNTwwtVp6FReOk7dB2s9go0drSMpBStiXRY4sDyk7bjRHp1jRNKyS8F1tftVkx+K3be4tSojM7YLRXB5fSX0XPnlwbsbfVEhOqCvDZeryT7Z/gcjW+O/hS+B7ghVclXj/z47ctZ1d6rQzhDm+9tQ3TbldyU27zE3xl/bWVuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iXJIsfaB; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iXJIsfaB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742560826; x=1774096826;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qVkCx9Q/hxNNJcyqpxOD7H8MnEgWj+eoaHhhFqRCp8c=;
  b=iXJIsfaBcv2g4ZsXj0hIma6BmcPvcBbdsSca7noOaoQ7MKbCVJar9vl0
   cLAgSQ2LUIVPlSBFN1wBS9RGA6UGLGSLe+kdhv5/mKBuPfXz+wMqazEOK
   1Lt++OrxdrTVsMsJssrN8Ykn0P3EvJA3QF+tkbWYyVlGiwzRVZRVAG5hI
   FU//ozuGbbmijiSoGrMckiNP8K1sdVCTQQtVagu0wg28tdEXJ2F3FppjJ
   H2zM+qHMs9c03iLm1oS5KGIcAHefiHVkvMmkXIYZ6skRoJxTY2V8MgRI/
   dk5o+lXVUQ70HdP75959AA6j1rd3p3kLt5a7RWRyUD5RBQHsv8T2Szexc
   Q==;
X-CSE-ConnectionGUID: 9cEGK1k+SLK2bK9//6i4Sw==
X-CSE-MsgGUID: hikzge1fSnGUOy0zn1DMXg==
X-IronPort-AV: E=McAfee;i="6700,10204,11380"; a="54493393"
X-IronPort-AV: E=Sophos;i="6.14,264,1736841600"; 
   d="scan'208";a="54493393"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2025 05:40:26 -0700
X-CSE-ConnectionGUID: Idk7BbUbTx23qlSXeR/cgA==
X-CSE-MsgGUID: WTfntceBRdWE7g1xuK9Egw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,264,1736841600"; 
   d="scan'208";a="154400005"
Received: from mwiniars-desk2.ger.corp.intel.com (HELO eresheto-mobl3.ger.corp.intel.com) ([10.245.246.189])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2025 05:40:20 -0700
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
	Elena Reshetova <elena.reshetova@intel.com>,
	Cathy Zhang <cathy.zhang@intel.com>
Subject: [PATCH 4/4] x86/sgx: Implement ENCLS[EUPDATESVN] and opportunistically call it during first EPC page alloc
Date: Fri, 21 Mar 2025 14:34:43 +0200
Message-ID: <20250321123938.802763-5-elena.reshetova@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250321123938.802763-1-elena.reshetova@intel.com>
References: <20250321123938.802763-1-elena.reshetova@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

SGX architecture introduced  a new instruction called EUPDATESVN [1]
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

The implementation of ENCLS[EUPDATESVN] is based on previous submision in [2]

[1] https://cdrdv2.intel.com/v1/dl/getContent/648682?explicitVersion=true
[2] https://lore.kernel.org/all/20220520103904.1216-1-cathy.zhang@intel.com/T/#medb89e6a916337b4f9e68c736a295ba0ae99ac90

Co-developed-by: Cathy Zhang <cathy.zhang@intel.com>
Signed-off-by: Cathy Zhang <cathy.zhang@intel.com>
Co-developed-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
---
 arch/x86/include/asm/sgx.h      | 33 +++++++++--------
 arch/x86/kernel/cpu/sgx/encls.h |  6 +++
 arch/x86/kernel/cpu/sgx/main.c  | 65 ++++++++++++++++++++++++++++++++-
 arch/x86/kernel/cpu/sgx/sgx.h   |  2 +
 4 files changed, 90 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
index 8ba39bbf4e91..5caf5c31ebc6 100644
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
index b61d3bad0446..698921229094 100644
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
 
@@ -457,7 +462,17 @@ static struct sgx_epc_page *__sgx_alloc_epc_page_from_node(int nid)
 	page->flags = 0;
 
 	spin_unlock(&node->lock);
-	atomic_long_inc(&sgx_nr_used_pages);
+
+	if (!atomic_long_inc_not_zero(&sgx_nr_used_pages)) {
+		spin_lock(&sgx_epc_eupdatesvn_lock);
+		/* Only call sgx_updatesvn() once the first enclave's
+		 * page is allocated from EPC
+		 */
+		if (atomic_long_read(&sgx_nr_used_pages) == 0)
+			sgx_updatesvn();
+		atomic_long_inc(&sgx_nr_used_pages);
+		spin_unlock(&sgx_epc_eupdatesvn_lock);
+	}
 
 	return page;
 }
@@ -970,3 +985,51 @@ static int __init sgx_init(void)
 }
 
 device_initcall(sgx_init);
+
+/**
+ * sgx_updatesvn() - Issue ENCLS[EUPDATESVN]
+ * If EPC is ready, this instruction will update CPUSVN to the currently
+ * loaded microcode update SVN and generate new cryptographic assets.
+ */
+void sgx_updatesvn(void)
+{
+	int ret;
+	int retry = 10;
+
+	lockdep_assert_held(&sgx_epc_eupdatesvn_lock);
+
+	/* Do not execute EUPDATESVN if instruction is unavalible or running in a VM */
+	if (!(cpuid_eax(SGX_CPUID) & SGX_CPUID_EUPDATESVN) ||
+		    boot_cpu_has(X86_FEATURE_HYPERVISOR))
+		return;
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
+		pr_debug("EUPDATESVN was successful!\n");
+		break;
+	case SGX_NO_UPDATE:
+		pr_debug("EUPDATESVN was successful, but CPUSVN was not updated, "
+			"because current SVN was not newer than CPUSVN.\n");
+		break;
+	case SGX_EPC_NOT_READY:
+		pr_debug("EPC is not ready for SVN update.");
+		break;
+	case SGX_INSUFFICIENT_ENTROPY:
+		pr_debug("CPUSVN update is failed due to Insufficient entropy in RNG, "
+			"please try it later.\n");
+		break;
+	case SGX_EPC_PAGE_CONFLICT:
+		pr_debug("CPUSVN update is failed due to concurrency violation, please "
+			"stop running any other ENCLS leaf and try it later.\n");
+		break;
+	default:
+		break;
+	}
+}
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index d2dad21259a8..92c9e226f1b5 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -104,4 +104,6 @@ static inline int __init sgx_vepc_init(void)
 
 void sgx_update_lepubkeyhash(u64 *lepubkeyhash);
 
+void sgx_updatesvn(void);
+
 #endif /* _X86_SGX_H */
-- 
2.45.2

