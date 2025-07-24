Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926CE272816;
	Thu, 24 Jul 2025 08:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753344239; cv=none; b=JDR6ersupMxDvEvj4s1IxopNdYR8g/psm7sEwZxmbQ5e0JUarib7u93bruKT8bH33VRwzYM0nEqq2UoErxzuqIpNS0B1IqMNl6P9Ob8nVVDgAgvjfEXuy32X8qwxE1lJBviIP3Q9ekrXiUuuaFPIx/z1OpC+as+XV7h56HqMnaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753344239; c=relaxed/simple;
	bh=5IAldkgSZm7p/aHbwXA4PqHVmVEu3v0XDt3bNysrur0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YgapHBdXguxTR3RdQZPj90/2PORxOZaNR2FpyhcFtorak7T1lUKro1ApGUwAKdxKLyJZQjIHpcfdzN+e+2XNMC1+721F8Pf/x5Wi4400DmpM/gTG/fJLrgrNFCr0UUDeqlcazFFNiUBD1U/1EAXo0ryLeGzn6pnZslfcFHmw80U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HggmGK9x; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HggmGK9x"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753344238; x=1784880238;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5IAldkgSZm7p/aHbwXA4PqHVmVEu3v0XDt3bNysrur0=;
  b=HggmGK9xWdnwAtWoR6x/3XPTpVhMosIvmMjM+7QMfF5wnhEp/Y5paM5o
   stcSLE8tdxPgL/H+biGwC5WBuqq5zTNdEAjnLZnN1e6pUwSHfFvCG1T2F
   VkkVfGA7yrGZH3nvACThrA0TkvXmTN8ns+TAyMk9U35bb9rgozgv4cAOu
   O+QsA0z00gUt3+em+kUDCq1yyiqJrc274v/ooSFeEbcQZM0L6w4TIeTNK
   U2R83emHFJ4cSeaIsy3mp6gwg2VJ7khipElLxWYhgBTH6hli9JkNPfPgh
   B8gZU+7+qVNhGXmb1Ptas2Iq2KUQpgX1ejaNDoWBU3OSYQSPaiak++rtH
   Q==;
X-CSE-ConnectionGUID: KdBFfixpT02tbl2d4spJQg==
X-CSE-MsgGUID: 0ZW09WleRCKHgKcxMfKzKg==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="66991989"
X-IronPort-AV: E=Sophos;i="6.16,336,1744095600"; 
   d="scan'208";a="66991989"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 01:03:58 -0700
X-CSE-ConnectionGUID: 6P+5RBlRRUykWsX46QtnxQ==
X-CSE-MsgGUID: beGOXuFmSPCzLNtVeLiDGw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,336,1744095600"; 
   d="scan'208";a="160342101"
Received: from savramon-mobl1 (HELO eresheto-mobl3.ger.corp.intel.com) ([10.245.244.60])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 01:03:52 -0700
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
Subject: [PATCH v9 5/6] x86/sgx: Implement ENCLS[EUPDATESVN]
Date: Thu, 24 Jul 2025 11:02:14 +0300
Message-ID: <20250724080313.605676-6-elena.reshetova@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250724080313.605676-1-elena.reshetova@intel.com>
References: <20250724080313.605676-1-elena.reshetova@intel.com>
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
index ccb81a649d1b..206bf41d8325 100644
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
 static int __maybe_unused sgx_usage_count;
 
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
 	return 0;
-- 
2.45.2

