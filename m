Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3C40C433DB
	for <linux-sgx@archiver.kernel.org>; Thu, 18 Mar 2021 21:52:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C1C664F38
	for <linux-sgx@archiver.kernel.org>; Thu, 18 Mar 2021 21:52:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbhCRVvz (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 18 Mar 2021 17:51:55 -0400
Received: from mga11.intel.com ([192.55.52.93]:63077 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230177AbhCRVvf (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 18 Mar 2021 17:51:35 -0400
IronPort-SDR: Xgh6PCtAW4FsT2qblHLTO1ELx3Qi9nKGpytzoL2epu2yh2DStRYTbY8OmlYVzHSkqaBaRXOzZ3
 Xrd5CBz/V+Hw==
X-IronPort-AV: E=McAfee;i="6000,8403,9927"; a="186423628"
X-IronPort-AV: E=Sophos;i="5.81,259,1610438400"; 
   d="scan'208";a="186423628"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2021 14:51:35 -0700
IronPort-SDR: HkWjNgs2L56YN6H5TehQTy8u8i1nWoURlU59FW4Vk37B71HGWd6Vr+auyCIDW3emB/SWpi3xIF
 H9T77LU/rIcQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,259,1610438400"; 
   d="scan'208";a="441070893"
Received: from viggo.jf.intel.com ([10.54.77.144])
  by FMSMGA003.fm.intel.com with ESMTP; 18 Mar 2021 14:51:35 -0700
From:   Dave Hansen <dave.hansen@intel.com>
To:     linux-kernel@vger.kernel.org
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        linux-sgx@vger.kernel.org
Subject: [PATCH] x86/sgx: fix uninitialized 'nid' variable
Date:   Thu, 18 Mar 2021 14:49:33 -0700
Message-Id: <20210318214933.29341-1-dave.hansen@intel.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <202103190514.xH7IrKMe-lkp@intel.com>
References: <202103190514.xH7IrKMe-lkp@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

The NUMA fallback in __sgx_alloc_epc_page() recently grew an
additional 'nid' variable to prevent extra trips through the
fallback loop in case where the thread is migrated around.

But, the new copy is not properly initialized.  Fix it.

This was found by some fancy clang that 0day runs.  My gcc
does not detect it.

Fixes: 5b8719504e3a ("x86/sgx: Add a basic NUMA allocation scheme to sgx_alloc_epc_page()")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: x86@kernel.org
Cc: linux-sgx@vger.kernel.org
---
 arch/x86/kernel/cpu/sgx/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 2a0031e4a4dc..1b4d8a0e0915 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -489,7 +489,7 @@ struct sgx_epc_page *__sgx_alloc_epc_page(void)
 {
 	struct sgx_epc_page *page;
 	int nid_of_current = numa_node_id();
-	int nid;
+	int nid = nid_of_current;
 
 	if (node_isset(nid_of_current, sgx_numa_mask)) {
 		page = __sgx_alloc_epc_page_from_node(nid_of_current);
-- 
2.19.1

