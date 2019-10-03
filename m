Return-Path: <SRS0=vH/k=X4=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8DE0C32792
	for <linux-sgx@archiver.kernel.org>; Thu,  3 Oct 2019 17:04:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99B8F20673
	for <linux-sgx@archiver.kernel.org>; Thu,  3 Oct 2019 17:04:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392477AbfJCREe (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 3 Oct 2019 13:04:34 -0400
Received: from mga06.intel.com ([134.134.136.31]:24847 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730828AbfJCREa (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 3 Oct 2019 13:04:30 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Oct 2019 10:04:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,253,1566889200"; 
   d="scan'208";a="216880341"
Received: from jvalevi1-mobl1.ger.corp.intel.com (HELO localhost) ([10.251.93.117])
  by fmsmga004.fm.intel.com with ESMTP; 03 Oct 2019 10:04:27 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v2] x86/sgx: Migrate to mmu_notifier_put()
Date:   Thu,  3 Oct 2019 20:04:23 +0300
Message-Id: <20191003170423.6221-1-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Use mmu_notifier_put() to synchronize sgx_encl_mm deletion.

Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
v2:
* Was not thinking clearly that we also use it for lockless
  operation on the mm list. Just migrating to mmu_notifier_put().
  Please ignore the previous patch!
 arch/x86/kernel/cpu/sgx/encl.c | 26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index d145360380d5..8cc9ea353bee 100644
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
@@ -161,19 +153,21 @@ static void sgx_mmu_notifier_release(struct mmu_notifier *mn,
 
 	if (tmp == encl_mm) {
 		synchronize_srcu(&encl_mm->encl->srcu);
-
-		/*
-		 * Delay freeing encl_mm until after mmu_notifier synchronizes
-		 * its SRCU to ensure encl_mm cannot be dereferenced.
-		 */
-		mmu_notifier_unregister_no_release(mn, mm);
-		mmu_notifier_call_srcu(&encl_mm->rcu,
-				       &sgx_encl_mm_release_deferred);
+		mmu_notifier_put(mn);
 	}
 }
 
+static void sgx_mmu_notifier_free(struct mmu_notifier *mn)
+{
+	struct sgx_encl_mm *encl_mm =
+		container_of(mn, struct sgx_encl_mm, mmu_notifier);
+
+	kfree(encl_mm);
+}
+
 static const struct mmu_notifier_ops sgx_mmu_notifier_ops = {
 	.release		= sgx_mmu_notifier_release,
+	.free_notifier		= sgx_mmu_notifier_free,
 };
 
 static struct sgx_encl_mm *sgx_encl_find_mm(struct sgx_encl *encl,
-- 
2.20.1

