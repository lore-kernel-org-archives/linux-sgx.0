Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F3A2C433FE
	for <linux-sgx@archiver.kernel.org>; Fri, 20 May 2022 10:41:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348236AbiETKlo (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 20 May 2022 06:41:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348270AbiETKlU (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 20 May 2022 06:41:20 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3F2815829
        for <linux-sgx@vger.kernel.org>; Fri, 20 May 2022 03:41:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653043278; x=1684579278;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=BEGZ3fQmZqUPI1ggNe8u4t/fGxRle1nwcPGCJ/MDG+k=;
  b=JFsV90i58Z+QWmqyI5MYens0JRiXhjfF1N/j1rD7ru0Qga6y9U3RveUT
   UjAlwkJmT7a81mLxz+3Vctbync8j1OG/Jh+e/SVUMCMpknuGynJOXuYz3
   5pUNVwDof5hvZP3s9of8LyPRa6I/qFLtDbCigNCvHzCx1HsZzqqEVMHX5
   /UtGxSiz/x7q38sWefKPweq4evMhctkuujBqGFam8fH2wIa5vWlbNAjhX
   KwJAPRj7yANOARytd+HNpaHAsAHYMUqY4xrmPxMbIj8aRrnJ4UDOOR5w8
   rzW3jNFW1cph0rFhxYTfJtcGVNpKLa4EWWr2kBk1siVl6N7OxfAAkHX/C
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10352"; a="271386989"
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="271386989"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2022 03:41:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="715471047"
Received: from cathy-vostro-3670.bj.intel.com ([10.238.156.128])
  by fmsmga001.fm.intel.com with ESMTP; 20 May 2022 03:41:15 -0700
From:   Cathy Zhang <cathy.zhang@intel.com>
To:     linux-sgx@vger.kernel.org, x86@kernel.org
Cc:     jarkko@kernel.org, reinette.chatre@intel.com,
        dave.hansen@intel.com, ashok.raj@intel.com, cathy.zhang@intel.com,
        chao.p.peng@linux.intel.com, yang.zhong@intel.com
Subject: [PATCH v5 7/9] x86/sgx: Implement ENCLS[EUPDATESVN]
Date:   Fri, 20 May 2022 18:39:02 +0800
Message-Id: <20220520103904.1216-8-cathy.zhang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220520103904.1216-1-cathy.zhang@intel.com>
References: <20220520103904.1216-1-cathy.zhang@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

The SGX attestation architecture assumes a compromise of all running
enclaves and cryptographic assets (like internal SGX encryption keys)
whenever a microcode update affects SGX. To mitigate the impact of
this presumed compromise, a new supervisor SGX instruction:
ENCLS[EUPDATESVN], is introduced to update SGX microcode version and
generate new cryptographic assets in runtime after SGX microcode
update.

EUPDATESVN requires that SGX memory to be marked as "unused" before
it will succeed. This ensures that no compromised enclave can survive
the process and provides an opportunity to generate new cryptographic
assets.

Signed-off-by: Cathy Zhang <cathy.zhang@intel.com>

---
Changes since v1:
 - Print message for each return code to notify userspace the
   ENCLS[EUPDATESVN] execution status.
---
 arch/x86/include/asm/sgx.h      | 33 +++++++++++----------
 arch/x86/kernel/cpu/sgx/encls.h |  6 ++++
 arch/x86/kernel/cpu/sgx/main.c  | 52 +++++++++++++++++++++++++++++++++
 3 files changed, 76 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
index 4a8ca7281229..74bcb6841a4b 100644
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
index 60321c5f5718..8455f385e817 100644
--- a/arch/x86/kernel/cpu/sgx/encls.h
+++ b/arch/x86/kernel/cpu/sgx/encls.h
@@ -208,4 +208,10 @@ static inline int __ewb(struct sgx_pageinfo *pginfo, void *addr,
 	return __encls_ret_3(EWB, pginfo, addr, va);
 }
 
+/* Update CPUSVN at runtime. */
+static inline int __eupdatesvn(void)
+{
+	return __encls_ret_1(EUPDATESVN, "");
+}
+
 #endif /* _X86_ENCLS_H */
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index fbfa449d90ed..43dd2b34e040 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -1351,3 +1351,55 @@ void sgx_zap_abort(void)
 	sgx_zap_abort_wait = true;
 	wake_up(&sgx_zap_waitq);
 }
+
+/**
+ * sgx_updatesvn() - Issue ENCLS[EUPDATESVN]
+ * If EPC is ready, this instruction will update CPUSVN to the currently
+ * loaded microcode update SVN and generate new cryptographic assets.
+ *
+ * Return:
+ * 0:				CPUSVN is update successfully.
+ * %SGX_LOCKFAIL:		An instruction concurrency rule was violated.
+ * %SGX_INSUFFICIENT_ENTROPY:	Insufficient entropy in RNG.
+ * %SGX_EPC_NOT_READY:		EPC is not ready for SVN update.
+ * %SGX_NO_UPDATE:		EUPDATESVN was successful, but CPUSVN was not
+ *				updated because current SVN was not newer than
+ *				CPUSVN.
+ */
+static int sgx_updatesvn(void)
+{
+	int ret;
+	int retry = 10;
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
+		pr_info("EUPDATESVN was successful!\n");
+		break;
+	case SGX_NO_UPDATE:
+		pr_info("EUPDATESVN was successful, but CPUSVN was not updated, "
+			"because current SVN was not newer than CPUSVN.\n");
+		break;
+	case SGX_EPC_NOT_READY:
+		pr_info("EPC is not ready for SVN update.");
+		break;
+	case SGX_INSUFFICIENT_ENTROPY:
+		pr_info("CPUSVN update is failed due to Insufficient entropy in RNG, "
+			"please try it later.\n");
+		break;
+	case SGX_EPC_PAGE_CONFLICT:
+		pr_info("CPUSVN update is failed due to concurrency violation, please "
+			"stop running any other ENCLS leaf and try it later.\n");
+		break;
+	default:
+		break;
+	}
+
+	return ret;
+}
-- 
2.17.1

