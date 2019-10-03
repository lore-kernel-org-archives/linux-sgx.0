Return-Path: <SRS0=vH/k=X4=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 270CEC10F14
	for <linux-sgx@archiver.kernel.org>; Thu,  3 Oct 2019 16:55:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07F302054F
	for <linux-sgx@archiver.kernel.org>; Thu,  3 Oct 2019 16:55:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388297AbfJCQzV (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 3 Oct 2019 12:55:21 -0400
Received: from mga11.intel.com ([192.55.52.93]:9452 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405787AbfJCQzQ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 3 Oct 2019 12:55:16 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Oct 2019 09:55:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,253,1566889200"; 
   d="scan'208";a="198579685"
Received: from jvalevi1-mobl1.ger.corp.intel.com (HELO localhost) ([10.251.93.117])
  by FMSMGA003.fm.intel.com with ESMTP; 03 Oct 2019 09:55:14 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH] x86/sgx: Migrate to mmu_notifier_put()
Date:   Thu,  3 Oct 2019 19:55:11 +0300
Message-Id: <20191003165511.3563-1-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Use mmu_notifier_put() to synchronize sgx_encl_mm usage, which means
that we can drop our own RCU.

Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/kernel/cpu/sgx/encl.c | 30 ++++++++++--------------------
 arch/x86/kernel/cpu/sgx/encl.h |  1 -
 2 files changed, 10 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index d145360380d5..25b210f57295 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -131,14 +131,6 @@ static struct sgx_encl_page *sgx_encl_load_page(struct sgx_encl *encl,
 	return entry;
 }
 
-static void sgx_encl_mm_release_deferred(struct rcu_head *rcu)
-{
-	struct sgx_encl_mm *encl_mm =
-		container_of(rcu, struct sgx_encl_mm, rcu);
-
-	kfree(encl_mm);
-}
-
 static void sgx_mmu_notifier_release(struct mmu_notifier *mn,
 				     struct mm_struct *mm)
 {
@@ -159,21 +151,21 @@ static void sgx_mmu_notifier_release(struct mmu_notifier *mn,
 	}
 	spin_unlock(&encl_mm->encl->mm_lock);
 
-	if (tmp == encl_mm) {
-		synchronize_srcu(&encl_mm->encl->srcu);
+	if (tmp == encl_mm)
+		mmu_notifier_put(mn);
+}
+
+static void sgx_mmu_notifier_free(struct mmu_notifier *mn)
+{
+	struct sgx_encl_mm *encl_mm =
+		container_of(mn, struct sgx_encl_mm, mmu_notifier);
 
-		/*
-		 * Delay freeing encl_mm until after mmu_notifier synchronizes
-		 * its SRCU to ensure encl_mm cannot be dereferenced.
-		 */
-		mmu_notifier_unregister_no_release(mn, mm);
-		mmu_notifier_call_srcu(&encl_mm->rcu,
-				       &sgx_encl_mm_release_deferred);
-	}
+	kfree(encl_mm);
 }
 
 static const struct mmu_notifier_ops sgx_mmu_notifier_ops = {
 	.release		= sgx_mmu_notifier_release,
+	.free_notifier		= sgx_mmu_notifier_free,
 };
 
 static struct sgx_encl_mm *sgx_encl_find_mm(struct sgx_encl *encl,
@@ -231,8 +223,6 @@ int sgx_encl_mm_add(struct sgx_encl *encl, struct mm_struct *mm)
 	list_add_rcu(&encl_mm->list, &encl->mm_list);
 	spin_unlock(&encl->mm_lock);
 
-	synchronize_srcu(&encl->srcu);
-
 	return 0;
 }
 
diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
index 71454f059b99..b8ecffe27c93 100644
--- a/arch/x86/kernel/cpu/sgx/encl.h
+++ b/arch/x86/kernel/cpu/sgx/encl.h
@@ -63,7 +63,6 @@ struct sgx_encl_mm {
 	struct mm_struct *mm;
 	struct list_head list;
 	struct mmu_notifier mmu_notifier;
-	struct rcu_head rcu;
 };
 
 struct sgx_encl {
-- 
2.20.1

