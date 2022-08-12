Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D2BBC00140
	for <linux-sgx@archiver.kernel.org>; Fri, 12 Aug 2022 19:12:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230445AbiHLTM2 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 12 Aug 2022 15:12:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238027AbiHLTM1 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 12 Aug 2022 15:12:27 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09028A6C1C
        for <linux-sgx@vger.kernel.org>; Fri, 12 Aug 2022 12:12:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660331546; x=1691867546;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=OUEyeLsprdzQf4sd66IKrOyPbdFG0HzmZA1XYypTmBE=;
  b=M5TUW2MbiF+xeSbV2ZlyshN2xrVXZ7lrx5BvgZxduMEKVHbqmSpyzxY1
   T9DMo3W29IVZ/GHUiwiE2XqkEtJQlPcm4ay5GlWMEUuw6vhYrGNLcKBGE
   9IX+5bwhFvl1WPCw+Y1CbVDUIF7fzwGJBO/R3WRwVoUVPnyLwLtJ50Fi6
   AgLys7Mkpz2OG6d77+Nsd1rczDWZ13Gc7TgEUz00JD9hhbbG+wDIZmMLb
   kRuF3m1zbyt9jvf4aOvpxbJmGr5E/3/tGAm3WLu03iVahuHwMYXllB58B
   esfSjLPNJFh5IZ7Az50w+GvLAf8WvVEI1VMy1n9QikwUUjdDANCNaFj3Z
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10437"; a="274725924"
X-IronPort-AV: E=Sophos;i="5.93,233,1654585200"; 
   d="scan'208";a="274725924"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2022 12:12:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,233,1654585200"; 
   d="scan'208";a="609350944"
Received: from b4969161e530.jf.intel.com ([10.165.56.46])
  by fmsmga007.fm.intel.com with ESMTP; 12 Aug 2022 12:12:25 -0700
From:   Haitao Huang <haitao.huang@linux.intel.com>
To:     linux-sgx@vger.kernel.org, jarkko@kernel.org,
        reinette.chatre@intel.com, dave.hansen@linux.intel.com,
        vijay.dhanraj@intel.com
Subject: [PATCH] x86/sgx: handle VA page allocation failure for EAUG on PF.
Date:   Fri, 12 Aug 2022 12:12:24 -0700
Message-Id: <20220812191224.15561-1-haitao.huang@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Return VM_FAULT_NOPAGE to allow the swapping thread to catch up.

link: https://lore.kernel.org/all/20220804201456.33418-1-vijay.dhanraj@intel.com/

Signed-off-by: Haitao Huang <haitao.huang@linux.intel.com>
---
 arch/x86/kernel/cpu/sgx/encl.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 24c1bb8eb196..1f88f80c4477 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -344,8 +344,11 @@ static vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
 	}
 
 	va_page = sgx_encl_grow(encl, false);
-	if (IS_ERR(va_page))
-		goto err_out_epc;
+	if (IS_ERR(va_page)) {
+        if (PTR_ERR(va_page) == -EBUSY)
+            vmret =  VM_FAULT_NOPAGE;
+        goto err_out_epc;
+    }
 
 	if (va_page)
 		list_add(&va_page->list, &encl->va_pages);
-- 
2.25.1

