Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A44CC433EF
	for <linux-sgx@archiver.kernel.org>; Mon, 27 Sep 2021 21:35:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 40214611ED
	for <linux-sgx@archiver.kernel.org>; Mon, 27 Sep 2021 21:35:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237157AbhI0Vgm (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 27 Sep 2021 17:36:42 -0400
Received: from mga07.intel.com ([134.134.136.100]:2375 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237050AbhI0Vgl (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 27 Sep 2021 17:36:41 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10120"; a="288227516"
X-IronPort-AV: E=Sophos;i="5.85,327,1624345200"; 
   d="scan'208";a="288227516"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2021 14:35:01 -0700
X-IronPort-AV: E=Sophos;i="5.85,327,1624345200"; 
   d="scan'208";a="561547603"
Received: from agluck-desk2.sc.intel.com ([10.3.52.146])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2021 14:35:01 -0700
From:   Tony Luck <tony.luck@intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@intel.com>
Cc:     Cathy Zhang <cathy.zhang@intel.com>, linux-sgx@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>
Subject: [PATCH v7 7/7] x86/sgx: Add check for SGX pages to ghes_do_memory_failure()
Date:   Mon, 27 Sep 2021 14:34:52 -0700
Message-Id: <20210927213452.212470-8-tony.luck@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210927213452.212470-1-tony.luck@intel.com>
References: <20210922182123.200105-1-tony.luck@intel.com>
 <20210927213452.212470-1-tony.luck@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

SGX EPC pages do not have a "struct page" associated with them so the
pfn_valid() sanity check fails and results in a warning message to
the console.

Add an additional check to skip the warning if the address of the error
is in an SGX EPC page.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 drivers/acpi/apei/ghes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
index 0c8330ed1ffd..0c5c9acc6254 100644
--- a/drivers/acpi/apei/ghes.c
+++ b/drivers/acpi/apei/ghes.c
@@ -449,7 +449,7 @@ static bool ghes_do_memory_failure(u64 physical_addr, int flags)
 		return false;
 
 	pfn = PHYS_PFN(physical_addr);
-	if (!pfn_valid(pfn)) {
+	if (!pfn_valid(pfn) && !arch_is_platform_page(physical_addr)) {
 		pr_warn_ratelimited(FW_WARN GHES_PFX
 		"Invalid address in generic error data: %#llx\n",
 		physical_addr);
-- 
2.31.1

