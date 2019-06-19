Return-Path: <SRS0=/aec=US=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6A91C31E49
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Jun 2019 12:21:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A96CB2084A
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Jun 2019 12:21:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727244AbfFSMVy (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 19 Jun 2019 08:21:54 -0400
Received: from mga01.intel.com ([192.55.52.88]:19557 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727134AbfFSMVy (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 19 Jun 2019 08:21:54 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Jun 2019 05:21:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,392,1557212400"; 
   d="scan'208";a="358597345"
Received: from stephanf-mobl2.ger.corp.intel.com (HELO localhost) ([10.252.34.117])
  by fmsmga006.fm.intel.com with ESMTP; 19 Jun 2019 05:21:50 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     sean.j.christopherson@intel.com
Cc:     linux-sgx@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH] x86/sgx: rip off the refcount from sgx_encl_add_page flow
Date:   Wed, 19 Jun 2019 15:21:43 +0300
Message-Id: <20190619122143.12028-1-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

With the file bound approach we can flush the work queue when the file
is closed.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/kernel/cpu/sgx/driver/ioctl.c | 3 +--
 arch/x86/kernel/cpu/sgx/driver/main.c  | 1 +
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
index d17c60dca114..f56d3c712dc4 100644
--- a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
@@ -172,7 +172,7 @@ static void sgx_add_page_worker(struct work_struct *work)
 
 next:
 		kfree(req);
-	} while (!kref_put(&encl->refcount, sgx_encl_release) && !is_empty);
+	} while (!is_empty);
 }
 
 static u32 sgx_calc_ssaframesize(u32 miscselect, u64 xfrm)
@@ -520,7 +520,6 @@ static int __sgx_encl_add_page(struct sgx_encl *encl,
 	req->encl_page = encl_page;
 	req->mrmask = mrmask;
 	empty = list_empty(&encl->add_page_reqs);
-	kref_get(&encl->refcount);
 	list_add_tail(&req->list, &encl->add_page_reqs);
 	if (empty)
 		queue_work(sgx_encl_wq, &encl->work);
diff --git a/arch/x86/kernel/cpu/sgx/driver/main.c b/arch/x86/kernel/cpu/sgx/driver/main.c
index 0c831ee5e2de..9ea082372682 100644
--- a/arch/x86/kernel/cpu/sgx/driver/main.c
+++ b/arch/x86/kernel/cpu/sgx/driver/main.c
@@ -47,6 +47,7 @@ static int sgx_release(struct inode *inode, struct file *file)
 {
 	struct sgx_encl *encl = file->private_data;
 
+	flush_work(&encl->work);
 	kref_put(&encl->refcount, sgx_encl_release);
 
 	return 0;
-- 
2.20.1

