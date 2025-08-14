Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A619926E6FA;
	Thu, 14 Aug 2025 07:37:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755157044; cv=none; b=kPGYmCYUbDuQSnoE4C05NBQJAoyX5MLnYW/MXB1B5UIVMvkSe6+C66bc3w0k8twCAhemcyjg8nAeE+gLyQzwSfOZ5+TXpiwbG9PZgTXE43FE1QDYMKqGZLV47JZPhhTaPYKIIgs/8tTJ8n4SQiCBh5rogoDnNUGfxhpvHxEWZv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755157044; c=relaxed/simple;
	bh=Q0UikNNKWhU9lwVX6LG35CRzooO0wDgnF6BjTRSFFuw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bk/0ZLfXGP6mdjxlJFbjVAUUkxmQ2fE4FDnOyr6hNGo4YVimLGFgJIxyFg28CenLkWSeCXRDzlE+mBfejJbL5owNNArkDk9HquqzhbhEGPr4o6K9Czsmkbw9hi8UeIXTGos+UMmB0ZdaowNIRlAcwUhoFRYDzA6lI/L1MteVDd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JdfgBXzk; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JdfgBXzk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755157042; x=1786693042;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Q0UikNNKWhU9lwVX6LG35CRzooO0wDgnF6BjTRSFFuw=;
  b=JdfgBXzkAYtA/IINJdZWUDc1we2iDAaGh+rV7hdiOjVdEX4hJWrgqXS0
   ob/l/ojhh/zjbpRFmZt2sL9xb2q/CbuiVqIeN6lJBJVkqou3ScP3KqSQs
   MU4yumA+wwRKqDb9EADW6TVpGezyumI7yD/DPRK5iTI2WqiyTy1yzgh++
   SmykTLOXuSVNXL+fDfZAGcfIdIhZqXkusKmjZXuoNuobxYV3yY/w3/xGE
   4/bi0FUn3ODOGeoLdH6leA8OaOPjI4h4BqgXt+Fb/AFnNOP142KLo8qb/
   FEW6KJII9jrzYg/v7pg2fdMtbAaeeWU1CWoBxh/MBI0rVa8lLRsWdGnP/
   g==;
X-CSE-ConnectionGUID: ulq7aNNDRHCAcpIos/2XKQ==
X-CSE-MsgGUID: nG1zJldpTP6M+YyV1BVXqg==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="82899385"
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="82899385"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 00:37:22 -0700
X-CSE-ConnectionGUID: +XO+oGZrT06LLAN3wIuYYQ==
X-CSE-MsgGUID: fyHuI/ocSau5WGKZbYUk9g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="171927395"
Received: from foboril-desk.ger.corp.intel.com (HELO eresheto-mobl3.ger.corp.intel.com) ([10.245.244.138])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 00:37:18 -0700
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
Subject: [PATCH v14 4/5] x86/sgx: Implement ENCLS[EUPDATESVN]
Date: Thu, 14 Aug 2025 10:34:24 +0300
Message-ID: <20250814073640.1507050-5-elena.reshetova@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250814073640.1507050-1-elena.reshetova@intel.com>
References: <20250814073640.1507050-1-elena.reshetova@intel.com>
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

Before executing EUPDATESVN, all SGX memory must be marked as unused. This
requirement ensures that no potentially compromised enclave survives the
update and allows the system to safely regenerate cryptographic assets.

Add the method to perform ENCLS[EUPDATESVN]. However, until the follow up
patch that wires calling sgx_update_svn() from sgx_inc_usage_count(), this
code is not reachable.

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
---
 arch/x86/include/asm/sgx.h      | 31 +++++++-------
 arch/x86/kernel/cpu/sgx/encls.h |  5 +++
 arch/x86/kernel/cpu/sgx/main.c  | 75 +++++++++++++++++++++++++++++++++
 3 files changed, 96 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
index 73348cf4fd78..c2c4c0d22ca4 100644
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
index 3a5cbd1c170e..69ab28641e20 100644
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
@@ -917,6 +918,80 @@ int sgx_set_attribute(unsigned long *allowed_attributes,
 }
 EXPORT_SYMBOL_GPL(sgx_set_attribute);
 
+/* Counter to count the active SGX users */
+static int sgx_usage_count;
+
+/**
+ * sgx_update_svn() - Attempt to call ENCLS[EUPDATESVN].
+ *
+ * This instruction attempts to update CPUSVN to the
+ * currently loaded microcode update SVN and generate new
+ * cryptographic assets.
+ *
+ * Return:
+ * * %0:		- Success or not supported
+ * * %-EAGAIN:		- Can be safely retried, failure is due to lack of
+ * *			entropy in RNG
+ * * %-EIO:		- Unexpected error, retries are not advisable
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
+	WARN(sgx_usage_count, "Elevated usage count when calling EUPDATESVN\n");
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
+	case 0:
+		/*
+		 * SVN successfully updated.
+		 * Let users know when the update was successful.
+		 */
+		pr_info("SVN updated successfully\n");
+		return 0;
+	case SGX_NO_UPDATE:
+		/*
+		 * SVN update failed since the current SVN is
+		 * not newer than CPUSVN. This is the most
+		 * common case and indicates no harm.
+		 */
+		return 0;
+	case SGX_INSUFFICIENT_ENTROPY:
+		/*
+		 * SVN update failed due to lack of entropy in DRNG.
+		 * Indicate to userspace that it should retry.
+		 */
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

