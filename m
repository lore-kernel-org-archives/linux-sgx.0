Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5210266EE7;
	Mon, 19 May 2025 07:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747639610; cv=none; b=upcFAKyAG4Md9l1EGrHUep8a7dPL8t63uWyGUoBxtXYEo+igi3jg+FIlkFpy16XLF01o/nfiI6EWIKAj2OOo9HBhEnmEE8+m1zvsCPaWkYhFQCrDT7Oc3DhNfIZX1inuGxOsuJVJkC8kYFKDLGK+5kkwTt0elYMch3UzmadXJO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747639610; c=relaxed/simple;
	bh=lzED5Ih60Wzv8GiZR2dSAkbu3wPek9HsYk24jN+A3jM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SEKDMlHxm0PnbcN7qjRVXUskiFmXgZ/+K9tTksVJNQk1k7qLtKEIqscgPOBZ2HIPgeyqeig3WPsJA6CgMqMVXWAaDZy1v81/BfCbf962ahv6VE4q48yHfOW/jIkNIuyYYQW0x8cl3by5iMbh1jDBTUyXN8Gi6lMIyVdWxYnLEmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jFZE0b0r; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jFZE0b0r"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747639609; x=1779175609;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lzED5Ih60Wzv8GiZR2dSAkbu3wPek9HsYk24jN+A3jM=;
  b=jFZE0b0rIDkbnWBEW4s+lrpZIUxoWfeFs1ly4LkyTeFkY87pLJmUnYC9
   SpP5FjCl/8YMe49cCvjSGr6vLTXHCPXYUS8XWmDd1DWfshlqR/o0KAqou
   jJUu1nGW9l2kSAoIwBe/aDe0U62Bd8St2GuIRn2ydmdiBG9JtY3NIx9IS
   y9u3TOf98Dc9zgag14opUZQG934cUxJZ5r4k2oBO+CnpklrHOo6TuK1Hs
   zH1b4KnPNVV820lcPRKzFZWWZatU7x1k5C+gps9k7gyB4BA6qY7dt5xi/
   NVW3RnGsmQ++zG8XzeLvk3/9ElmzyXK/ee3xnakqW2aqyTA+ZpFgbxWlg
   g==;
X-CSE-ConnectionGUID: eeoJcKBeSIKwajLMUbL2Mw==
X-CSE-MsgGUID: MjrPFFLKTDapfEHRTX9JvA==
X-IronPort-AV: E=McAfee;i="6700,10204,11437"; a="49591609"
X-IronPort-AV: E=Sophos;i="6.15,300,1739865600"; 
   d="scan'208";a="49591609"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 00:26:49 -0700
X-CSE-ConnectionGUID: R+qjLuctS8SqleSUK3v+MQ==
X-CSE-MsgGUID: 7tWlja2SQy+4W+64HkCiyQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,300,1739865600"; 
   d="scan'208";a="139029787"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO eresheto-mobl3.ger.corp.intel.com) ([10.245.244.195])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 00:26:43 -0700
From: Elena Reshetova <elena.reshetova@intel.com>
To: dave.hansen@intel.com
Cc: jarkko@kernel.org,
	seanjc@google.com,
	kai.huang@intel.com,
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
Subject: [PATCH v5 4/5] x86/sgx: Implement ENCLS[EUPDATESVN]
Date: Mon, 19 May 2025 10:24:30 +0300
Message-ID: <20250519072603.328429-5-elena.reshetova@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250519072603.328429-1-elena.reshetova@intel.com>
References: <20250519072603.328429-1-elena.reshetova@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The SGX attestation architecture assumes a compromise
of all running enclaves and cryptographic assets
(like internal SGX encryption keys) whenever a microcode
update affects SGX. To mitigate the impact of this presumed
compromise, a new supervisor SGX instruction: ENCLS[EUPDATESVN],
is introduced to update SGX microcode version and generate
new cryptographic assets in runtime after SGX microcode update.

EUPDATESVN requires that SGX memory to be marked as "unused"
before it will succeed. This ensures that no compromised enclave
can survive the process and provides an opportunity to generate
new cryptographic assets.

Add the method to perform ENCLS[EUPDATESVN].

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
---
 arch/x86/kernel/cpu/sgx/encls.h |  5 +++
 arch/x86/kernel/cpu/sgx/main.c  | 57 +++++++++++++++++++++++++++++++++
 2 files changed, 62 insertions(+)

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
index 80d565e6f2ad..fd71e2ddca59 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -15,6 +15,7 @@
 #include <linux/sysfs.h>
 #include <linux/vmalloc.h>
 #include <asm/sgx.h>
+#include <asm/archrandom.h>
 #include "driver.h"
 #include "encl.h"
 #include "encls.h"
@@ -917,6 +918,62 @@ EXPORT_SYMBOL_GPL(sgx_set_attribute);
 /* Counter to count the active SGX users */
 static atomic64_t sgx_usage_count;
 
+/**
+ * sgx_updatesvn() - Attempt to call ENCLS[EUPDATESVN]
+ * If EPC is empty, this instruction attempts to update CPUSVN to the
+ * currently loaded microcode update SVN and generate new
+ * cryptographic assets.sgx_updatesvn() Most of the time, there will
+ * be no update and that's OK.
+ *
+ * Return:
+ * 0: Success, not supported or run out of entropy
+ */
+static int sgx_update_svn(void)
+{
+	int ret;
+
+	/*
+	 * If EUPDATESVN is not available, it is ok to
+	 * silently skip it to comply with legacy behavior.
+	 */
+	if (!X86_FEATURE_SGX_EUPDATESVN)
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
+	 * SVN either was up-to-date or SVN update failed due
+	 * to lack of entropy. In both cases, we want to return
+	 * 0 in order not to break sgx_(vepc_)open. We dont expect
+	 * SGX_INSUFFICIENT_ENTROPY error unless underlying RDSEED
+	 * is under heavy pressure.
+	 */
+	if ((ret == SGX_NO_UPDATE) || (ret == SGX_INSUFFICIENT_ENTROPY))
+		return 0;
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
+	return ret;
+}
+
 int sgx_inc_usage_count(void)
 {
 	atomic64_inc(&sgx_usage_count);
-- 
2.45.2

