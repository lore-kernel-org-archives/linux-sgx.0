Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771DC2E173B;
	Tue, 15 Jul 2025 12:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752583311; cv=none; b=lFIHAWb4vDsd6uyQdDIuxu87tlKuvMeYo74OpDIrik7bumUOSHDRbkY2OPEyJz9uMQ3AcxOCMgalJtoAKW+s1emE9YeVW5PsnWSCfECDpTy0WjKBD6fmp9Opj/33DjsvoJ5J1rk3Mg5SIjmWX9WQOhZausmd/vtiQrGqyfQkHks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752583311; c=relaxed/simple;
	bh=50l1WrZjc94LvangMr63Bs8tspnYXTz20qT2I6OQfG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QrnPdWppqKc2YmigYo0Pvujkfv00XPLOAaRw93Ny4MWqAlcl9fx6p6KeyRksn3OijDZsmD0uBz9ADTWbqWqpPhjTxGIZV/jFpjnrnnscwwNskjxNIh2plYS+CYKk8Df900MA635uGAVnhJIDa+v0Rvqli/CpvpWHYNZkZBE3haE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KJRWYgdH; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KJRWYgdH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752583309; x=1784119309;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=50l1WrZjc94LvangMr63Bs8tspnYXTz20qT2I6OQfG0=;
  b=KJRWYgdHyLDg02l3CbSImb1QxoWAtwLnO52ouenfiE9Fv2BWvO0VswqI
   OEp0pfdiwHUgxxg/LRWIV5FAQeZelAlQ8L5YrEnIMYn3PfDin1pYnDvTJ
   Tgg4bNkHpSHHeQ2bi/9PVws0vGckTQSaQXzDM7d/sL6hJbAuWRiBGgVSF
   mAsPEL0tEchKRwIlxCUrF1kIRJBNDNvCmusdzcszOHeGrqaVg/CQ5yUOg
   qLweWmLuexahtl007WDdjYvBis55miiyXJ1OtKiqR5Jm+7hHRXxTPZO4y
   4EcVkW4fmhNgpf1ujP8z652THu4L/9nOKo2FVeSnjCWRyiC/OpwUWf1zH
   A==;
X-CSE-ConnectionGUID: DU6JzREMQeeQUoLiWHbmcA==
X-CSE-MsgGUID: N7IMyf5FSIitNH8GO3Ft9w==
X-IronPort-AV: E=McAfee;i="6800,10657,11493"; a="65498231"
X-IronPort-AV: E=Sophos;i="6.16,313,1744095600"; 
   d="scan'208";a="65498231"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2025 05:41:49 -0700
X-CSE-ConnectionGUID: Voaqqp7dS76YeSd3yWtKsQ==
X-CSE-MsgGUID: zBt1ojT9RsagUl66IBDXTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,313,1744095600"; 
   d="scan'208";a="157018433"
Received: from jkrzyszt-mobl2.ger.corp.intel.com (HELO eresheto-mobl3.ger.corp.intel.com) ([10.245.245.22])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2025 05:41:43 -0700
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
	bondarn@google.com,
	scott.raynor@intel.com,
	Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH v8 4/5] x86/sgx: Implement ENCLS[EUPDATESVN]
Date: Tue, 15 Jul 2025 15:40:21 +0300
Message-ID: <20250715124109.1711717-5-elena.reshetova@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250715124109.1711717-1-elena.reshetova@intel.com>
References: <20250715124109.1711717-1-elena.reshetova@intel.com>
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
 arch/x86/kernel/cpu/sgx/main.c  | 61 +++++++++++++++++++++++++++++++++
 2 files changed, 66 insertions(+)

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
index 0e75090f93c9..c97bba16e4fd 100644
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
@@ -920,6 +921,66 @@ EXPORT_SYMBOL_GPL(sgx_set_attribute);
 /* Counter to count the active SGX users */
 static int sgx_usage_count;
 
+/**
+ * sgx_update_svn() - Attempt to call ENCLS[EUPDATESVN].
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
+static int __maybe_unused sgx_update_svn(void)
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
+	 * SVN successfully updated.
+	 * Let users know when the update was successful.
+	 */
+	if (!ret)
+		pr_info("SVN updated successfully\n");
+
+	if (!ret || ret == SGX_NO_UPDATE)
+		return 0;
+
+	/*
+	 * SVN update failed due to lack of entropy in DRNG.
+	 * Indicate to userspace that it should retry.
+	 */
+	if (ret == SGX_INSUFFICIENT_ENTROPY)
+		return -EAGAIN;
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
 	sgx_usage_count++;
-- 
2.45.2

