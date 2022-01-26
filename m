Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36892C63682
	for <linux-sgx@archiver.kernel.org>; Wed, 26 Jan 2022 19:17:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbiAZTRW (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 26 Jan 2022 14:17:22 -0500
Received: from mga01.intel.com ([192.55.52.88]:3417 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244389AbiAZTRV (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 26 Jan 2022 14:17:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643224641; x=1674760641;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KSnwaDYZyQGYWdbZxR+AMvdXJIirkztcqwViFoi5OsU=;
  b=I4tEffET5ZcBaaadJD1Bgl6ggtgNH1gfbF3LtrZCqrZpOT6JcQMWQNbu
   80T93QyMyWIMbdkVpkCTudNEULMTtaVhuISqPVJq5XJo4mCW87gauOYei
   T5vb1gHxzQQm+2pVQIwjR1U6am0D5m7VqG0mU7SRNRXD+EXq7cZzuyI4c
   QzUIZQ+idUOZLoECx5WDEC/yTg1AowyBwxlMhcnM0CnMy+tifSKr1LQmw
   nh7CS43ucH+GIU4VDZh+iDkHda67CBQv1hrM7de4u7zFg3cnOwp4v1re3
   uvPiz6w55XOD0vq6JYEccOrftvaKofhJ2qeNhdyM1/9SIhw+rW1ZkRDDN
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10238"; a="271082418"
X-IronPort-AV: E=Sophos;i="5.88,318,1635231600"; 
   d="scan'208";a="271082418"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 11:17:20 -0800
X-IronPort-AV: E=Sophos;i="5.88,318,1635231600"; 
   d="scan'208";a="479992546"
Received: from kcaccard-mobl.amr.corp.intel.com (HELO kcaccard-mobl1.jf.intel.com) ([10.212.3.61])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2022 11:17:20 -0800
From:   Kristen Carlson Accardi <kristen@linux.intel.com>
To:     linux-sgx@vger.kernel.org, dave.hansen@intel.com
Cc:     haitao.huang@linux.intel.com, jarkko@kernel.org
Subject: [PATCH 1/2] x86/sgx: fixup for available backing pages calculation
Date:   Wed, 26 Jan 2022 11:17:10 -0800
Message-Id: <20220126191711.4917-2-kristen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220126191711.4917-1-kristen@linux.intel.com>
References: <20220126191711.4917-1-kristen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Remove improper parentheses from calculation for available
backing bytes. Wtihout this fix, the result will be incorrect
due to rounding.

Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 arch/x86/kernel/cpu/sgx/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 990f341bbd30..c4030fb608c6 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -881,7 +881,7 @@ static bool __init sgx_page_cache_init(void)
 		return false;
 	}
 
-	available_backing_bytes = total_epc_bytes * (sgx_overcommit_percent / 100);
+	available_backing_bytes = total_epc_bytes * sgx_overcommit_percent / 100;
 	atomic_long_set(&sgx_nr_available_backing_pages, available_backing_bytes >> PAGE_SHIFT);
 
 	return true;
-- 
2.20.1

