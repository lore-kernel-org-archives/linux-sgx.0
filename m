Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E644C433F5
	for <linux-sgx@archiver.kernel.org>; Tue, 10 May 2022 03:16:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235267AbiEJDUi (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 9 May 2022 23:20:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235257AbiEJDUf (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 9 May 2022 23:20:35 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 903DF18B32
        for <linux-sgx@vger.kernel.org>; Mon,  9 May 2022 20:16:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652152599; x=1683688599;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=vOByD50p83RxYVZANLAfmQHpElgLVmhpxScClDgO0yE=;
  b=Lc9huXA5PmVnTU9yAxx8zHASgza7eKTWTqORryyXX+Tc0ZYyfwR2Aora
   aE3DdnI23m8F+sipQifrxygOPx8qTUtON2FFGTEuPSWxxSa4JUWPtl8X1
   SFFljva1v56CBndOFimU8IQrFNat2WO51AmY2xFFyMMO4BgOjNIRbBPTg
   GQHX8JZASZ3yjLo3xItQoEkuW9rvWu8MMh9QjAng7XD/L3B0t8lNRJTOT
   /UheK6QBT6aaY1/7P+oOjx9EPLTpJ6fUeR2vjY6jpmHbvGX58tTy8+WQh
   u3+YLuN4aCKq1h0BVvuQaNjgwNcPDLUswGT1G2j/S6lO2mboM7OEoxo+V
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10342"; a="249144606"
X-IronPort-AV: E=Sophos;i="5.91,213,1647327600"; 
   d="scan'208";a="249144606"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 May 2022 20:16:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,213,1647327600"; 
   d="scan'208";a="710818569"
Received: from zhiquan-linux-dev.bj.intel.com ([10.238.155.101])
  by fmsmga001.fm.intel.com with ESMTP; 09 May 2022 20:16:37 -0700
From:   Zhiquan Li <zhiquan1.li@intel.com>
To:     linux-sgx@vger.kernel.org, tony.luck@intel.com
Cc:     jarkko@kernel.org, dave.hansen@linux.intel.com, seanjc@google.com,
        fan.du@intel.com, zhiquan1.li@intel.com
Subject: [PATCH 1/4] x86/sgx: Move struct sgx_vepc definition to sgx.h
Date:   Tue, 10 May 2022 11:17:25 +0800
Message-Id: <20220510031725.3181361-1-zhiquan1.li@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Move struct sgx_vepc definition to sgx.h so that it can be used outside
of virt.c.

Signed-off-by: Zhiquan Li <zhiquan1.li@intel.com>
---
 arch/x86/kernel/cpu/sgx/sgx.h  | 5 +++++
 arch/x86/kernel/cpu/sgx/virt.c | 5 -----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index 0f17def9fe6f..83ff8c3e81cf 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -101,4 +101,9 @@ static inline int __init sgx_vepc_init(void)
 
 void sgx_update_lepubkeyhash(u64 *lepubkeyhash);
 
+struct sgx_vepc {
+	struct xarray page_array;
+	struct mutex lock;
+};
+
 #endif /* _X86_SGX_H */
diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/virt.c
index 6a77a14eee38..c9c8638b5dc4 100644
--- a/arch/x86/kernel/cpu/sgx/virt.c
+++ b/arch/x86/kernel/cpu/sgx/virt.c
@@ -18,11 +18,6 @@
 #include "encls.h"
 #include "sgx.h"
 
-struct sgx_vepc {
-	struct xarray page_array;
-	struct mutex lock;
-};
-
 /*
  * Temporary SECS pages that cannot be EREMOVE'd due to having child in other
  * virtual EPC instances, and the lock to protect it.
-- 
2.25.1

