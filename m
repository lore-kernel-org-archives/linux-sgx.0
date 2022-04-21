Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89117C433EF
	for <linux-sgx@archiver.kernel.org>; Thu, 21 Apr 2022 11:05:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352661AbiDULIf (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 21 Apr 2022 07:08:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388932AbiDULIE (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 21 Apr 2022 07:08:04 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7459518E0F
        for <linux-sgx@vger.kernel.org>; Thu, 21 Apr 2022 04:05:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650539107; x=1682075107;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=+3y6DxvsctMxXZh/+jol0SmDk7ld6S7QJDcag3c4+r0=;
  b=VWeDgCxkOmk/rBd2IyUHgTpUDTZJNG4o1rU6ix2LPGi6fLNyeTTG9VgI
   ZSmtPBMe9ty1HoTdKoknn4F/PWssNPc2B4eTaWpzd2oXqu42XwxAehsmc
   qoo2DBhuvbAmeJK88ijAq0n1x90I2Xcwt1t7M1wVcB1vZJB5auqFdo5hO
   Dlrq5JpDDHefOgQ41/vdQ4M7PW96+Tdw7uTLhvcIzKYGO52RNslpBypft
   sof2hiNLSnd1sIignIdHzwtiQlE9jAsgbBI1gb0uNWGfw2Af198SJwdWx
   HxYmhd9GMBVQyLp/A+QJ6uzHvj4F4KKIngEvViCIWRacWtDEy8hnw0nvL
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10323"; a="244893431"
X-IronPort-AV: E=Sophos;i="5.90,278,1643702400"; 
   d="scan'208";a="244893431"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 04:04:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,278,1643702400"; 
   d="scan'208";a="703039184"
Received: from cathy-vostro-3670.bj.intel.com ([10.238.156.128])
  by fmsmga001.fm.intel.com with ESMTP; 21 Apr 2022 04:04:33 -0700
From:   Cathy Zhang <cathy.zhang@intel.com>
To:     linux-sgx@vger.kernel.org, x86@kernel.org
Cc:     jarkko@kernel.org, reinette.chatre@intel.com,
        dave.hansen@intel.com, ashok.raj@intel.com, cathy.zhang@intel.com,
        chao.p.peng@intel.com, yang.zhong@intel.com
Subject: [PATCH v4 6/9] x86/sgx: Define error codes for ENCLS[EUPDATESVN]
Date:   Thu, 21 Apr 2022 19:03:23 +0800
Message-Id: <20220421110326.856-7-cathy.zhang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220421110326.856-1-cathy.zhang@intel.com>
References: <20220421110326.856-1-cathy.zhang@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Add error codes for ENCLS[EUPDATESVN], then SGX CPUSVN update
process can know the execution state of EUPDATESVN and notify
userspace.

Signed-off-by: Cathy Zhang <cathy.zhang@intel.com>
---
 arch/x86/include/asm/sgx.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
index 03ec7e32659c..4a8ca7281229 100644
--- a/arch/x86/include/asm/sgx.h
+++ b/arch/x86/include/asm/sgx.h
@@ -65,17 +65,27 @@ enum sgx_encls_function {
 
 /**
  * enum sgx_return_code - The return code type for ENCLS, ENCLU and ENCLV
+ * %SGX_EPC_PAGE_CONFLICT	Page is being written by other ENCLS function.
  * %SGX_NOT_TRACKED:		Previous ETRACK's shootdown sequence has not
  *				been completed yet.
  * %SGX_CHILD_PRESENT		SECS has child pages present in the EPC.
  * %SGX_INVALID_EINITTOKEN:	EINITTOKEN is invalid and enclave signer's
  *				public key does not match IA32_SGXLEPUBKEYHASH.
+ * %SGX_INSUFFICIENT_ENTROPY:	Insufficient entropy in RNG.
+ * %SGX_EPC_NOT_READY:		EPC is not ready for SVN update.
+ * %SGX_NO_UPDATE:		EUPDATESVN was successful, but CPUSVN was not
+ *				updated because current SVN was not newer than
+ *				CPUSVN.
  * %SGX_UNMASKED_EVENT:		An unmasked event, e.g. INTR, was received
  */
 enum sgx_return_code {
+	SGX_EPC_PAGE_CONFLICT		= 7,
 	SGX_NOT_TRACKED			= 11,
 	SGX_CHILD_PRESENT		= 13,
 	SGX_INVALID_EINITTOKEN		= 16,
+	SGX_INSUFFICIENT_ENTROPY	= 29,
+	SGX_EPC_NOT_READY		= 30,
+	SGX_NO_UPDATE			= 31,
 	SGX_UNMASKED_EVENT		= 128,
 };
 
-- 
2.17.1

