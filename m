Return-Path: <SRS0=inPB=VJ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C6ABC742BB
	for <linux-sgx@archiver.kernel.org>; Fri, 12 Jul 2019 12:56:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3911120863
	for <linux-sgx@archiver.kernel.org>; Fri, 12 Jul 2019 12:56:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727182AbfGLM4p (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 12 Jul 2019 08:56:45 -0400
Received: from mga04.intel.com ([192.55.52.120]:17217 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727052AbfGLM4p (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 12 Jul 2019 08:56:45 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Jul 2019 05:56:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,482,1557212400"; 
   d="scan'208";a="157129889"
Received: from jroll-mobl.ger.corp.intel.com (HELO localhost) ([10.249.35.79])
  by orsmga007.jf.intel.com with ESMTP; 12 Jul 2019 05:56:43 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     sean.j.christopherson@intel.com,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH] x86/sgx: Use a loop to release mm_struct's in sgx_release()
Date:   Fri, 12 Jul 2019 15:56:40 +0300
Message-Id: <20190712125640.18650-1-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Instead of an awkward goto-construct use a loop-construct to delete
entries from the list of mm_struct's.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
Still problems with my test env so only compilation test at this point.
 arch/x86/kernel/cpu/sgx/driver/main.c | 39 +++++++++++++--------------
 1 file changed, 18 insertions(+), 21 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/driver/main.c b/arch/x86/kernel/cpu/sgx/driver/main.c
index 27cf271b25f6..bb7f1932529f 100644
--- a/arch/x86/kernel/cpu/sgx/driver/main.c
+++ b/arch/x86/kernel/cpu/sgx/driver/main.c
@@ -55,30 +55,27 @@ static int sgx_release(struct inode *inode, struct file *file)
 	struct sgx_encl *encl = file->private_data;
 	struct sgx_encl_mm *encl_mm;
 
-	/*
-	 * Objects can't be *moved* off an RCU protected list (deletion is ok),
-	 * nor can the object be freed until after synchronize_srcu().
-	 */
-restart:
-	spin_lock(&encl->mm_lock);
-	if (list_empty(&encl->mm_list)) {
-		encl_mm = NULL;
-	} else {
-		encl_mm = list_first_entry(&encl->mm_list, struct sgx_encl_mm,
-					   list);
-		list_del_rcu(&encl_mm->list);
-	}
-	spin_unlock(&encl->mm_lock);
+	for ( ; ; )  {
+		spin_lock(&encl->mm_lock);
+
+		if (list_empty(&encl->mm_list)) {
+			encl_mm = NULL;
+		} else {
+			encl_mm = list_first_entry(&encl->mm_list,
+						   struct sgx_encl_mm, list);
+			list_del_rcu(&encl_mm->list);
+		}
 
-	if (encl_mm) {
-		synchronize_srcu(&encl->srcu);
+		spin_unlock(&encl->mm_lock);
 
-		mmu_notifier_unregister(&encl_mm->mmu_notifier, encl_mm->mm);
+		/* The list is empty, ready to go. */
+		if (!encl_mm)
+			break;
 
+		synchronize_srcu(&encl->srcu);
+		mmu_notifier_unregister(&encl_mm->mmu_notifier, encl_mm->mm);
 		kfree(encl_mm);
-
-		goto restart;
-	}
+	};
 
 	mutex_lock(&encl->lock);
 	encl->flags |= SGX_ENCL_DEAD;
@@ -86,8 +83,8 @@ static int sgx_release(struct inode *inode, struct file *file)
 
 	if (encl->work.func)
 		flush_work(&encl->work);
-	kref_put(&encl->refcount, sgx_encl_release);
 
+	kref_put(&encl->refcount, sgx_encl_release);
 	return 0;
 }
 
-- 
2.20.1

