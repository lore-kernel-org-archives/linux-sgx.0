Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB20D70814;
	Thu, 22 May 2025 09:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747905802; cv=none; b=g21ZrUpWRUCSwGw9HaW1fcW8+H+vL5+pjNg/g/k3YspW+uFmDNjTCWUvJbXsmSnfD+NEclpIkMwi7XuBqMf5eNGIUB8QAd719GvDtoMOZuxGs8bzmHZ3wGjKpJneWCP0KrPmA38lgw6FDsvKLNuKcYO6Cii1GgubGG3bmoI4gYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747905802; c=relaxed/simple;
	bh=m4Dn+28HzpJ42BC0PlzyDJxQgYt1OoMrQ+6Ros5CU/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rus8FouQvgGXSBLyharA4spLhrpySDJf2uuqFK8o2faBzd03QJ79abYbDiHz1HVLzYb/ukRrYmNnCFe3HBd5s8hPxuTDFGjN/tUaJgqdYu6KAvX7tTNpAUslWLuDguA8LzjLCJch7amsxIm5ED6LxU88aV2MU5RC7qhY8jcjA7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aOyt0MRw; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aOyt0MRw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747905801; x=1779441801;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=m4Dn+28HzpJ42BC0PlzyDJxQgYt1OoMrQ+6Ros5CU/M=;
  b=aOyt0MRwSr0DooiyauLNyxZiX15x1PDSPsMHoznXvA+ksGoIRZdOEged
   TUHesfixPR8xuc3PRhsc1tLUBrwQfDKtCdMK2iBuSAntDYMRhxAQPaXxU
   6YPc0hyrzaMnmnMkU8T7u/5tkdm9DRBgDNjcdmbc83+ROfsMv1cgb/Kod
   spx/D2y+RHOgkZXlmVN9ZF9RR/rxo89XqRHyjK4QaZ3MgLi7sX//5B9cT
   DtvDhxwO5n5L5YUYgb1nMyZqVjjZ++QXRdhqLp/R568e9V5n/TRSMsn6H
   e9YWlU3ssBwUSIsTUwqiIVPPwpDxV4Lj5Wzs8fHC8VnhTuH364N5UkexQ
   A==;
X-CSE-ConnectionGUID: yaFOxnMbS8OmaUupWjucbA==
X-CSE-MsgGUID: BdAW2ywSSCuQyGlSRUrGFw==
X-IronPort-AV: E=McAfee;i="6700,10204,11440"; a="72445679"
X-IronPort-AV: E=Sophos;i="6.15,305,1739865600"; 
   d="scan'208";a="72445679"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2025 02:23:21 -0700
X-CSE-ConnectionGUID: lG+J6I/kSGS1GYL5gTZ2IQ==
X-CSE-MsgGUID: fVcU2KcPSoSMUCEqQZJ1dQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,305,1739865600"; 
   d="scan'208";a="145662020"
Received: from oandoniu-mobl3.ger.corp.intel.com (HELO eresheto-mobl3.ger.corp.intel.com) ([10.245.245.170])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2025 02:23:14 -0700
From: Elena Reshetova <elena.reshetova@intel.com>
To: dave.hansen@intel.com
Cc: jarkko@kernel.org,
	seanjc@google.com,
	kai.huang@intel.com,
	mingo@kernel.org,
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
Subject: [PATCH v6 4/5] x86/sgx: Implement ENCLS[EUPDATESVN]
Date: Thu, 22 May 2025 12:21:37 +0300
Message-ID: <20250522092237.7895-5-elena.reshetova@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250522092237.7895-1-elena.reshetova@intel.com>
References: <20250522092237.7895-1-elena.reshetova@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All running enclaves and cryptographic assets (such as internal SGX
encryption keys) are assumed to be compromised whenever an SGX-related
microcode update occurs. To mitigate this assumed compromise the new
supervisor SGX instruction ENCLS[EUPDATESVN] can generate fresh
cryptographic assets.

Before executing EUPDATESVN, all SGX memory must be marked as unused.
This requirement ensures that no potentially compromised enclave
survives the update and allows the system to safely regenerate
cryptographic assets.

Add the method to perform ENCLS[EUPDATESVN].

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
---
 arch/x86/kernel/cpu/sgx/encls.h |  5 +++
 arch/x86/kernel/cpu/sgx/main.c  | 67 +++++++++++++++++++++++++++++++++
 2 files changed, 72 insertions(+)

diff --git a/arch/x86/kernel/cpu/sgx/encls.h b/arch/x86/kernel/cpu/sgx/encls.h
index 99004b02e2ed..d9160c89a93d 100644
--- a/arch/x86/kernel/cpu/sgx/encls.h
+++ b/arch/x86/kernel/cpu/sgx/encls.h
@@ -233,4 +233,9 @@ static inline int __eaug(struct sgx_pageinfo *pginfo, void *addr)
 	return __encls_2(EAUG, pginfo, addr);
 }
 
+/* Attempt to update CPUSVN at runtime. */
+static inline int __eupdatesvn(void)
+{
+	return __encls_ret_1(EUPDATESVN, "");
+}
 #endif /* _X86_ENCLS_H */
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index a018b01b8736..109d40c89fe8 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -16,6 +16,7 @@
 #include <linux/vmalloc.h>
 #include <asm/msr.h>
 #include <asm/sgx.h>
+#include <asm/archrandom.h>
 #include "driver.h"
 #include "encl.h"
 #include "encls.h"
@@ -920,6 +921,72 @@ EXPORT_SYMBOL_GPL(sgx_set_attribute);
 /* Counter to count the active SGX users */
 static atomic64_t sgx_usage_count;
 
+/**
+ * sgx_updatesvn() - Attempt to call ENCLS[EUPDATESVN].
+ * This instruction attempts to update CPUSVN to the
+ * currently loaded microcode update SVN and generate new
+ * cryptographic assets. Must be called when EPC is empty.
+ * Most of the time, there will be no update and that's OK.
+ * If the failure is due to SGX_INSUFFICIENT_ENTROPY, the
+ * operation can be safely retried. In other failure cases,
+ * the retry should not be attempted.
+ *
+ * Return:
+ * 0: Success or not supported
+ * -EAGAIN: Can be safely retried, failure is due to lack of
+ *  entropy in RNG.
+ * -EIO: Unexpected error, retries are not advisable.
+ */
+static int sgx_update_svn(void)
+{
+	int ret;
+
+	/*
+	 * If EUPDATESVN is not available, it is ok to
+	 * silently skip it to comply with legacy behavior.
+	 */
+	if (!cpu_feature_enabled(X86_FEATURE_SGX_EUPDATESVN))
+		return 0;
+
+	for (int i = 0; i < RDRAND_RETRY_LOOPS; i++) {
+		ret = __eupdatesvn();
+
+		/* Stop on success or unexpected errors: */
+		if (ret != SGX_INSUFFICIENT_ENTROPY)
+			break;
+	}
+
+	/*
+	 * SVN was already up-to-date. This is the most
+	 * common case.
+	 */
+	if (ret == SGX_NO_UPDATE)
+		return 0;
+
+	/*
+	 * SVN update failed due to lack of entropy in DRNG.
+	 * Indicate to userspace that it should retry.
+	 */
+	if (ret == SGX_INSUFFICIENT_ENTROPY)
+		return -EAGAIN;
+
+	if (!ret) {
+		/*
+		 * SVN successfully updated.
+		 * Let users know when the update was successful.
+		 */
+		pr_info("SVN updated successfully\n");
+		return 0;
+	}
+
+	/*
+	 * EUPDATESVN was called when EPC is empty, all other error
+	 * codes are unexpected.
+	 */
+	ENCLS_WARN(ret, "EUPDATESVN");
+	return -EIO;
+}
+
 int sgx_inc_usage_count(void)
 {
 	atomic64_inc(&sgx_usage_count);
-- 
2.45.2

