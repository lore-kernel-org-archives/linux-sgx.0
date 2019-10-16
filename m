Return-Path: <SRS0=tCn0=YJ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E72F7FA372D
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Oct 2019 18:37:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C320021A4C
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Oct 2019 18:37:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbfJPShu (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 16 Oct 2019 14:37:50 -0400
Received: from mga07.intel.com ([134.134.136.100]:22394 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394289AbfJPSht (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 16 Oct 2019 14:37:49 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Oct 2019 11:37:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,304,1566889200"; 
   d="scan'208";a="397258423"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga006.fm.intel.com with ESMTP; 16 Oct 2019 11:37:47 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v23 v3 04/12] x86/sgx: Drop mmap_sem before EEXTENDing an enclave page
Date:   Wed, 16 Oct 2019 11:37:37 -0700
Message-Id: <20191016183745.8226-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191016183745.8226-1-sean.j.christopherson@intel.com>
References: <20191016183745.8226-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Drop mmap_sem, which needs to be held for read across EADD, prior to
doing EEXTEND on the newly added page to avoid holding mmap_sem for an
extended duration.  EEXTEND doesn't access user pages and holding
encl->lock without mmap_sem is perfectly ok, while EEXTEND is a _slow_
operation, to the point where it operates on 256-byte chunks
instead of 4k pages to maintain a reasonable latency for a single
instruction.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/ioctl.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 4169ff3c81d8..7be3fdc846d7 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -409,11 +409,15 @@ static int sgx_encl_add_page(struct sgx_encl *encl,
 	 */
 	ret = radix_tree_insert(&encl->page_tree, PFN_DOWN(encl_page->desc),
 				encl_page);
-	if (ret)
+	if (ret) {
+		up_read(&current->mm->mmap_sem);
 		goto err_out_unlock;
+	}
 
 	ret = __sgx_encl_add_page(encl, encl_page, epc_page, secinfo,
 				  addp->src);
+	up_read(&current->mm->mmap_sem);
+
 	if (ret)
 		goto err_out;
 
@@ -433,7 +437,6 @@ static int sgx_encl_add_page(struct sgx_encl *encl,
 		sgx_mark_page_reclaimable(encl_page->epc_page);
 
 	mutex_unlock(&encl->lock);
-	up_read(&current->mm->mmap_sem);
 	return ret;
 
 err_out:
@@ -443,7 +446,6 @@ static int sgx_encl_add_page(struct sgx_encl *encl,
 err_out_unlock:
 	sgx_encl_shrink(encl, va_page);
 	mutex_unlock(&encl->lock);
-	up_read(&current->mm->mmap_sem);
 
 err_out_free:
 	sgx_free_page(epc_page);
-- 
2.22.0

