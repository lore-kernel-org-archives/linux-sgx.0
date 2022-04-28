Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42793C4332F
	for <linux-sgx@archiver.kernel.org>; Thu, 28 Apr 2022 20:11:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236958AbiD1UO4 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 28 Apr 2022 16:14:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236978AbiD1UOz (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 28 Apr 2022 16:14:55 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89284BAB80
        for <linux-sgx@vger.kernel.org>; Thu, 28 Apr 2022 13:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651176700; x=1682712700;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=AbSUaBWdZnzGniwZJlFChUAkrxFwT9ZUrv5NlzFn2gI=;
  b=kDgJXoenA6oF7SluQmZ8OPX59eeJIPPKQm7N/xL0pfb52SDhuXeBHQMg
   MqrYnrxoq0kEJj1QbyFRXtGnrYkx6oPHpOGpYcc42Bp1qoudB6gBdvDur
   tWn7UiMMfTPpxlz+1LsKGKbr86lKl5w1Pgg7e1v4ozoyDzJQocHnhlMjf
   po/TuhMD4VOUtgpcJV8ATwFBqDVbfV6c2QARMCQi/2g1ME9sZdX5Fdv7i
   cI+MbQfjDJXg4rsi3L+LamvYOn8VQxaHQ92BWDEhMK0DgnmHHViKESSm3
   dceo1h6u/U51fj+k1OgohDp7JYtKRsMly4xjaQcgkl3divUTDJSCMDPed
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="246324260"
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="246324260"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 13:11:34 -0700
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="514458606"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 13:11:32 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     dave.hansen@linux.intel.com, jarkko@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     haitao.huang@intel.com
Subject: [RFC PATCH 2/4] x86/sgx: Set dirty bit after modifying page contents
Date:   Thu, 28 Apr 2022 13:11:25 -0700
Message-Id: <b0596095e09ee4a14a3802c5ce91372a0dc21220.1651171455.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1651171455.git.reinette.chatre@intel.com>
References: <cover.1651171455.git.reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Recent commit 08999b2489b4 ("x86/sgx: Free backing memory
after faulting the enclave page") expanded __sgx_encl_eldu()
to clear an enclave page's PCMD (Paging Crypto MetaData)
from the PCMD page in the backing store after the enclave
page is restored to the enclave.

Since the PCMD page in the backing store is modified the page
should be set as dirty when releasing the reference to
ensure the modified data is retained.

Fixes: 08999b2489b4 ("x86/sgx: Free backing memory after faulting the enclave page")
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 arch/x86/kernel/cpu/sgx/encl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index e5d2661800ac..e03f124ce772 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -98,7 +98,7 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
 	kunmap_atomic(pcmd_page);
 	kunmap_atomic((void *)(unsigned long)pginfo.contents);
 
-	sgx_encl_put_backing(&b, false);
+	sgx_encl_put_backing(&b, true);
 
 	sgx_encl_truncate_backing_page(encl, page_index);
 
-- 
2.25.1

