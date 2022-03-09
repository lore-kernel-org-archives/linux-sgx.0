Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 085BFC433FE
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Mar 2022 10:40:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbiCIKlf (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 9 Mar 2022 05:41:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbiCIKld (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 9 Mar 2022 05:41:33 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A14A64F45A
        for <linux-sgx@vger.kernel.org>; Wed,  9 Mar 2022 02:40:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646822435; x=1678358435;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=cYjTG4/dt2avR696AzrMtSJmfq0TlzXqfyhf31IRGww=;
  b=ADF4T8vEFlJg7ZqQMTHztW2BTn0v1ojZ6zgtbVC5//kKGyPZfwP/p9az
   j/JmZCJ9KUIW8y2iD/Nm/Y+gAVyRVadRvMD/lY51i6dJ+wgTsTtaVcem9
   qwdff+4Ab3IaCJZ8j31X2PnCz1XxkM3+9tae5lYvduQ2sizKlOe/F8OLz
   Ai5aqRN9GBzjoF40DQCS64ZfoMF1hKPLF24s6UQhZ+MHAv03jiEEHfz3p
   zb90l7ZBB97ycJ4LvSToNkk8YRhekq673YHyid0DE3Ixq3qC+EMj6Tb05
   Q6g4NrBVSkpCO+KPSb05mky2AQbN/RyUbaN1jAV68psFN5g7MnIlhUdRT
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10280"; a="341373588"
X-IronPort-AV: E=Sophos;i="5.90,167,1643702400"; 
   d="scan'208";a="341373588"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 02:40:35 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,167,1643702400"; 
   d="scan'208";a="547582933"
Received: from cathy-vostro-3670.bj.intel.com ([10.238.156.128])
  by fmsmga007.fm.intel.com with ESMTP; 09 Mar 2022 02:40:34 -0800
From:   Cathy Zhang <cathy.zhang@intel.com>
To:     linux-sgx@vger.kernel.org, x86@kernel.org
Cc:     dave.hansen@intel.com, cathy.zhang@intel.com
Subject: [RFC PATCH 08/11] x86/sgx: Implement ENCLS[EUPDATESVN]
Date:   Wed,  9 Mar 2022 18:40:47 +0800
Message-Id: <20220309104050.18207-9-cathy.zhang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220309104050.18207-1-cathy.zhang@intel.com>
References: <20220309104050.18207-1-cathy.zhang@intel.com>
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
 arch/x86/include/asm/sgx.h      | 33 ++++++++++++++++++---------------
 arch/x86/kernel/cpu/sgx/encls.h |  6 ++++++
 arch/x86/kernel/cpu/sgx/main.c  | 31 +++++++++++++++++++++++++++++++
 3 files changed, 55 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
index 6aa36c1be426..d5942d0848ec 100644
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
index 3f1797ec2445..b0aa110e7560 100644
--- a/arch/x86/kernel/cpu/sgx/encls.h
+++ b/arch/x86/kernel/cpu/sgx/encls.h
@@ -243,4 +243,10 @@ static inline int __eaug(struct sgx_pageinfo *pginfo, void *addr)
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
index a4fa5ae1ee60..7a464c8ac959 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -1328,3 +1328,34 @@ void sgx_zap_abort(void)
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
+	pr_info("EUPDATESVN complete with ret %d\n", ret);
+
+	return ret;
+}
-- 
2.17.1

