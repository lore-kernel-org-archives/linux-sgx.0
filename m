Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75A37C433EF
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Mar 2022 10:40:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbiCIKld (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 9 Mar 2022 05:41:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230492AbiCIKlc (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 9 Mar 2022 05:41:32 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0501F4F45A
        for <linux-sgx@vger.kernel.org>; Wed,  9 Mar 2022 02:40:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646822433; x=1678358433;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=1FPC1+faoHuUKJzI0PehoPzEV0/G34kXYwPqzFyYCuU=;
  b=EGxKM6gX0FJSdZx9uKN4Lr+NxbG4DR34uEedI2oKwc0plcFoYrDQdQYA
   M2+oE/iJiOGYJTC87M8Z5wu88AN0/GTgv2JkWpdMaaYBb3XCWY547SScr
   LgXyT7spajx/TNZqVUAuLBYR5mW6fGK4cAYEGwhF9gYAYGdHG8u8qkA2x
   jTZGFDit8T/GK40DEhRdCbPXAFHGtuHf+jyR0dxiN5uKFZ7f/efyYaaww
   eUOK4Pb4rwwebaBPQtu+bbo49B7hAZAnxaasfYPGqOHu48rUVoP/OsrGq
   df72IsZYBRw8v50a1ND53cdukih701Dk4ZguguQNEOuNFOs5nvj+6zc+L
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10280"; a="341373583"
X-IronPort-AV: E=Sophos;i="5.90,167,1643702400"; 
   d="scan'208";a="341373583"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 02:40:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,167,1643702400"; 
   d="scan'208";a="547582926"
Received: from cathy-vostro-3670.bj.intel.com ([10.238.156.128])
  by fmsmga007.fm.intel.com with ESMTP; 09 Mar 2022 02:40:32 -0800
From:   Cathy Zhang <cathy.zhang@intel.com>
To:     linux-sgx@vger.kernel.org, x86@kernel.org
Cc:     dave.hansen@intel.com, cathy.zhang@intel.com
Subject: [RFC PATCH 07/11] x86/sgx: Define error codes for ENCLS[EUPDATESVN]
Date:   Wed,  9 Mar 2022 18:40:46 +0800
Message-Id: <20220309104050.18207-8-cathy.zhang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220309104050.18207-1-cathy.zhang@intel.com>
References: <20220309104050.18207-1-cathy.zhang@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Add error codes for ENCLS[EUPDATESVN], then SGX CPUSVN update
process can know the execution state of EUPDATESVN and notify
userspace.

Signed-off-by: Cathy Zhang <cathy.zhang@intel.com>
---
 arch/x86/include/asm/sgx.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
index eae20fa52b93..6aa36c1be426 100644
--- a/arch/x86/include/asm/sgx.h
+++ b/arch/x86/include/asm/sgx.h
@@ -73,6 +73,11 @@ enum sgx_encls_function {
  *				public key does not match IA32_SGXLEPUBKEYHASH.
  * %SGX_PAGE_NOT_MODIFIABLE:	The EPC page cannot be modified because it
  *				is in the PENDING or MODIFIED state.
+ * %SGX_INSUFFICIENT_ENTROPY:	Insufficient entropy in RNG.
+ * %SGX_EPC_NOT_READY:		EPC is not ready for SVN update.
+ * %SGX_NO_UPDATE:		EUPDATESVN was successful, but CPUSVN was not
+ *				updated because current SVN was not newer than
+ *				CPUSVN.
  * %SGX_UNMASKED_EVENT:		An unmasked event, e.g. INTR, was received
  */
 enum sgx_return_code {
@@ -81,6 +86,9 @@ enum sgx_return_code {
 	SGX_CHILD_PRESENT		= 13,
 	SGX_INVALID_EINITTOKEN		= 16,
 	SGX_PAGE_NOT_MODIFIABLE		= 20,
+	SGX_INSUFFICIENT_ENTROPY	= 29,
+	SGX_EPC_NOT_READY		= 30,
+	SGX_NO_UPDATE			= 31,
 	SGX_UNMASKED_EVENT		= 128,
 };
 
-- 
2.17.1

