Return-Path: <SRS0=RnOm=7L=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C789C433E1
	for <linux-sgx@archiver.kernel.org>; Fri, 29 May 2020 17:54:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FE51206E2
	for <linux-sgx@archiver.kernel.org>; Fri, 29 May 2020 17:54:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727980AbgE2RyM (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 29 May 2020 13:54:12 -0400
Received: from mga14.intel.com ([192.55.52.115]:51589 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725913AbgE2RyM (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 29 May 2020 13:54:12 -0400
IronPort-SDR: vL8sbvTnh6QvtIZuLoVWC0MIJ+ojnNFyvFyVy419s1+VwhMOEcu1zV/ihLKWsmTmgrBgNAZ54j
 byao1fgVa94w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2020 10:54:09 -0700
IronPort-SDR: u/pkWo/VrVW2mU3Zq63orkOZpFVlXjWdAmepysK+reDka1DicOvwWb0Q8fYhSeJSduwKLvOQwZ
 e1YgzRO4gIug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,449,1583222400"; 
   d="scan'208";a="271292323"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.152])
  by orsmga006.jf.intel.com with ESMTP; 29 May 2020 10:54:08 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v31 2/6] x86/sgx: Remove unnecessary globals after merging reclaim.c into main.c
Date:   Fri, 29 May 2020 10:54:03 -0700
Message-Id: <20200529175407.2109-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200529175407.2109-1-sean.j.christopherson@intel.com>
References: <20200529175407.2109-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Make all variables that are only used in main.c static, rearranging code
as needed.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/main.c | 16 ++++++----------
 arch/x86/kernel/cpu/sgx/sgx.h  |  3 ---
 2 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 5043d3700960b..ef7061bfa2a07 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -14,9 +14,12 @@
 #include "encls.h"
 
 static struct task_struct *ksgxswapd_tsk;
-DECLARE_WAIT_QUEUE_HEAD(ksgxswapd_waitq);
-LIST_HEAD(sgx_active_page_list);
-DEFINE_SPINLOCK(sgx_active_page_list_lock);
+static DECLARE_WAIT_QUEUE_HEAD(ksgxswapd_waitq);
+static LIST_HEAD(sgx_active_page_list);
+static DEFINE_SPINLOCK(sgx_active_page_list_lock);
+
+struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
+static int sgx_nr_epc_sections;
 
 static void sgx_sanitize_section(struct sgx_epc_section *section)
 {
@@ -45,10 +48,6 @@ static void sgx_sanitize_section(struct sgx_epc_section *section)
 	}
 }
 
-extern struct task_struct *ksgxswapd_tsk;
-extern struct wait_queue_head(ksgxswapd_waitq);
-extern spinlock_t sgx_active_page_list_lock;
-
 static unsigned long sgx_nr_free_pages(void)
 {
 	unsigned long cnt = 0;
@@ -491,9 +490,6 @@ void sgx_reclaim_pages(void)
 	}
 }
 
-struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
-int sgx_nr_epc_sections;
-
 static struct sgx_epc_page *__sgx_alloc_epc_page_from_section(struct sgx_epc_section *section)
 {
 	struct sgx_epc_page *page;
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index 923028d568540..5b9dbcef981b0 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -41,14 +41,11 @@ struct sgx_epc_section {
 #define SGX_NR_LOW_PAGES		32
 #define SGX_NR_HIGH_PAGES		64
 
-extern struct list_head sgx_active_page_list;
-
 void sgx_mark_page_reclaimable(struct sgx_epc_page *page);
 int sgx_unmark_page_reclaimable(struct sgx_epc_page *page);
 void sgx_reclaim_pages(void);
 
 extern struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
-extern int sgx_nr_epc_sections;
 
 static inline struct sgx_epc_section *sgx_get_epc_section(
 		struct sgx_epc_page *page)
-- 
2.26.0

