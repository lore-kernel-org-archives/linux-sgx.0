Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A221223DCB;
	Wed,  6 Aug 2025 08:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754468072; cv=none; b=Gh55PXmUhHkmTtm2FDKc8Plk3XFhc80gDmXtVd/USnjJ8YgXA6WIEWTkNiiWTQRHE2NHATt+iyrKC5fpfjjenORVIf0JQvf09nZjY1WueExxbWj4Cia0sogwSHEclgcQwcHRM0pJzTleNOuZgZFV6uAzcaVG6BxEN9I6Wz/dcgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754468072; c=relaxed/simple;
	bh=fcqlzyuS/YzqYrSmE4OP/INq3SU1BAdodt9l/bO7U3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sci81OD7o4pRxO9mmaPCGUr190oehDHvROKqetpThNNiMqIej351+2JjoXI5doyi3Vq0dTbEe84jNLtwcLgPr7NTfoWxWf1/Ouae8W63R9mkLeh+PrUt15TTu+MEOwGidULBxPCqdAjLxjUTUgxhi0lycFq4KPP/Z8On9Kcu8hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lQVM80pL; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lQVM80pL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754468070; x=1786004070;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fcqlzyuS/YzqYrSmE4OP/INq3SU1BAdodt9l/bO7U3E=;
  b=lQVM80pLzwXhLo8X+ZBLKPYDtvGYBKqUFlbJW3V5u4HiKhU6oqGnRmVn
   zo1duVEM7nVn1mAT4Dpm6wv+rj69LaimV3Lls0MEhKIbJWYh+t46llVWY
   aCCvEb3FLfFEeLIgscg5y0z54Ox4qUrNAzz7SuMIYEFwxkqKAado/leTN
   GWXqc01j0XvWWhb5nz7g2TWUi3IkO9aB3b+vxF5gii6e3XDZveIguFhvm
   /CFatL3nA9h+JhlUeyNvueqvmjBNzWjOGMBPTflVmZMtwU10YmO/QEJnn
   qKCzu+bPlNlojPQ0fRO3yQieMdZRsUwiqzay5l0IyCDV41VowYkHTqwQ/
   g==;
X-CSE-ConnectionGUID: HONEu1rSTl6YPsnVmgiFKg==
X-CSE-MsgGUID: 05+xIxhGS0a3OqUJzt6oYw==
X-IronPort-AV: E=McAfee;i="6800,10657,11513"; a="56853679"
X-IronPort-AV: E=Sophos;i="6.17,268,1747724400"; 
   d="scan'208";a="56853679"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2025 01:14:30 -0700
X-CSE-ConnectionGUID: DqyY1v7wQbeQRAm/Nz1g0Q==
X-CSE-MsgGUID: KN1iY1X8SjC+8m8Z9bVh+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,268,1747724400"; 
   d="scan'208";a="169168529"
Received: from sschumil-mobl2.ger.corp.intel.com (HELO eresheto-mobl3.ger.corp.intel.com) ([10.245.244.125])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2025 01:14:23 -0700
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
Subject: [PATCH v11 4/5] x86/sgx: Implement ENCLS[EUPDATESVN]
Date: Wed,  6 Aug 2025 11:11:55 +0300
Message-ID: <20250806081344.404004-5-elena.reshetova@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250806081344.404004-1-elena.reshetova@intel.com>
References: <20250806081344.404004-1-elena.reshetova@intel.com>
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

Add the method to perform ENCLS[EUPDATESVN]. However, until the
follow up patch that wires calling sgx_update_svn() from
sgx_inc_usage_count(), this code is not reachable.

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
---
 arch/x86/include/asm/sgx.h      | 31 +++++++-------
 arch/x86/kernel/cpu/sgx/encls.h |  5 +++
 arch/x86/kernel/cpu/sgx/main.c  | 73 +++++++++++++++++++++++++++++++++
 3 files changed, 94 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
index 2da5b3b117a1..0e13678f9cbd 100644
--- a/arch/x86/include/asm/sgx.h
+++ b/arch/x86/include/asm/sgx.h
@@ -28,21 +28,22 @@
 #define SGX_CPUID_EPC_MASK	GENMASK(3, 0)
 
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
index 3a5cbd1c170e..d8c42524b590 100644
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
@@ -917,6 +918,78 @@ int sgx_set_attribute(unsigned long *allowed_attributes,
 }
 EXPORT_SYMBOL_GPL(sgx_set_attribute);
 
+/* Counter to count the active SGX users */
+static int sgx_usage_count;
+
+/**
+ * sgx_update_svn() - Attempt to call ENCLS[EUPDATESVN].
+ * This instruction attempts to update CPUSVN to the
+ * currently loaded microcode update SVN and generate new
+ * cryptographic assets.
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
+	/*
+	 * EPC is guaranteed to be empty when there are no users.
+	 * Ensure we are on our first user before proceeding further.
+	 */
+	WARN(sgx_usage_count != 1, "Elevated usage count when calling EUPDATESVN\n");
+
+	for (int i = 0; i < RDRAND_RETRY_LOOPS; i++) {
+		ret = __eupdatesvn();
+
+		/* Stop on success or unexpected errors: */
+		if (ret != SGX_INSUFFICIENT_ENTROPY)
+			break;
+	}
+
+	switch (ret) {
+	/*
+	 * SVN successfully updated.
+	 * Let users know when the update was successful.
+	 */
+	case 0:
+		pr_info("SVN updated successfully\n");
+		return 0;
+	/*
+	 * SVN update failed since the current SVN is
+	 * not newer than CPUSVN. This is the most
+	 * common case and indicates no harm.
+	 */
+	case SGX_NO_UPDATE:
+		return 0;
+	/*
+	 * SVN update failed due to lack of entropy in DRNG.
+	 * Indicate to userspace that it should retry.
+	 */
+	case SGX_INSUFFICIENT_ENTROPY:
+		return -EAGAIN;
+	default:
+		break;
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
 	return 0;
-- 
2.45.2

