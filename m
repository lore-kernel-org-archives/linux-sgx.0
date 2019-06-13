Return-Path: <SRS0=rpH8=UM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58E40C31E49
	for <linux-sgx@archiver.kernel.org>; Thu, 13 Jun 2019 16:30:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 320AC2173C
	for <linux-sgx@archiver.kernel.org>; Thu, 13 Jun 2019 16:30:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727472AbfFMQak (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 13 Jun 2019 12:30:40 -0400
Received: from mga12.intel.com ([192.55.52.136]:55087 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392369AbfFMQaZ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 13 Jun 2019 12:30:25 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Jun 2019 09:30:25 -0700
X-ExtLoop1: 1
Received: from gengelha-mobl.ger.corp.intel.com (HELO localhost) ([10.249.32.179])
  by orsmga004.jf.intel.com with ESMTP; 13 Jun 2019 09:30:22 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     luto@kernel.org, cedric.xing@intel.com,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH RFC] x86/sgx: Do not increase encl->refcount for VMAs
Date:   Thu, 13 Jun 2019 19:30:08 +0300
Message-Id: <20190613163008.4060-2-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190613163008.4060-1-jarkko.sakkinen@linux.intel.com>
References: <20190613163008.4060-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Since the device file stays open up until all VMAs have been closed
we do not need to increase encl->refcount for VMAs. sgx_open() will
increase it once and sgx_release() will decrease at a point where
the device file is not mapped. anymore.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
Based on the commentary from Andy and Cedric.
 arch/x86/kernel/cpu/sgx/driver/main.c | 2 --
 arch/x86/kernel/cpu/sgx/encl.c        | 3 ---
 2 files changed, 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/driver/main.c b/arch/x86/kernel/cpu/sgx/driver/main.c
index 87735ce8b5ba..0c831ee5e2de 100644
--- a/arch/x86/kernel/cpu/sgx/driver/main.c
+++ b/arch/x86/kernel/cpu/sgx/driver/main.c
@@ -68,8 +68,6 @@ static int sgx_mmap(struct file *file, struct vm_area_struct *vma)
 	vma->vm_flags |= VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP | VM_IO;
 	vma->vm_private_data = encl;
 
-	kref_get(&encl->refcount);
-
 	return 0;
 }
 
diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 6b190eccd02e..9566eb72d417 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -208,7 +208,6 @@ static void sgx_vma_open(struct vm_area_struct *vma)
 			goto error;
 	}
 
-	kref_get(&encl->refcount);
 	return;
 
 error:
@@ -230,8 +229,6 @@ static void sgx_vma_close(struct vm_area_struct *vma)
 		/* Release kref for the VMA. */
 		kref_put(&encl_mm->refcount, sgx_encl_mm_release);
 	}
-
-	kref_put(&encl->refcount, sgx_encl_release);
 }
 
 static unsigned int sgx_vma_fault(struct vm_fault *vmf)
-- 
2.20.1

