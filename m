Return-Path: <SRS0=JCck=WT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04AF9C3A5A2
	for <linux-sgx@archiver.kernel.org>; Fri, 23 Aug 2019 13:57:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7E1922CEC
	for <linux-sgx@archiver.kernel.org>; Fri, 23 Aug 2019 13:57:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732609AbfHWN5z (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 23 Aug 2019 09:57:55 -0400
Received: from mga12.intel.com ([192.55.52.136]:5073 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730899AbfHWN5z (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 23 Aug 2019 09:57:55 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Aug 2019 06:57:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,421,1559545200"; 
   d="scan'208";a="196487777"
Received: from unknown (HELO localhost) ([10.252.39.229])
  by fmsmga001.fm.intel.com with ESMTP; 23 Aug 2019 06:57:53 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v2] x86/sgx: Replace @is_secs_child with @pt in sgx_encl_ewb()
Date:   Fri, 23 Aug 2019 16:57:50 +0300
Message-Id: <20190823135750.6640-1-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Sean complained about boolean parameters so I though that maybe it would
be good to rework the EWB flow in a way that it operates by a page type and
here is the result. The contract is and will be that as long as you give
the correct page type, you will get what you want. That is why I set
REG and TCS appropriately even though they are treated the same way
at this point of time.

Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
v2: Use SGX_SECINFO_* instead SGX_PAGE_TYPE_*
 arch/x86/kernel/cpu/sgx/reclaim.c | 43 +++++++++++++++++++------------
 1 file changed, 27 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/reclaim.c b/arch/x86/kernel/cpu/sgx/reclaim.c
index 00f596c64a2d..3f10a8ff00b7 100644
--- a/arch/x86/kernel/cpu/sgx/reclaim.c
+++ b/arch/x86/kernel/cpu/sgx/reclaim.c
@@ -221,7 +221,7 @@ static void sgx_reclaimer_block(struct sgx_epc_page *epc_page)
 
 static int __sgx_encl_ewb(struct sgx_encl *encl, struct sgx_epc_page *epc_page,
 			  struct sgx_va_page *va_page, unsigned int va_offset,
-			  bool is_secs_child)
+			  unsigned int pt)
 {
 	struct sgx_encl_page *encl_page = epc_page->owner;
 	struct sgx_pageinfo pginfo;
@@ -232,10 +232,14 @@ static int __sgx_encl_ewb(struct sgx_encl *encl, struct sgx_epc_page *epc_page,
 	struct page *pcmd;
 	int ret;
 
-	if (is_secs_child)
-		page_index = SGX_ENCL_PAGE_INDEX(encl_page);
-	else
+	if (pt != SGX_SECINFO_SECS && pt != SGX_SECINFO_TCS &&
+	    pt != SGX_SECINFO_REG)
+		return -EINVAL;
+
+	if (pt == SGX_SECINFO_SECS)
 		page_index = PFN_DOWN(encl->size);
+	else
+		page_index = SGX_ENCL_PAGE_INDEX(encl_page);
 
 	pcmd_index = sgx_pcmd_index(encl, page_index);
 	pcmd_offset = sgx_pcmd_offset(page_index);
@@ -300,7 +304,7 @@ static const cpumask_t *sgx_encl_ewb_cpumask(struct sgx_encl *encl)
 	return cpumask;
 }
 
-static void sgx_encl_ewb(struct sgx_epc_page *epc_page, bool is_secs_child)
+static void sgx_encl_ewb(struct sgx_epc_page *epc_page, unsigned int pt)
 {
 	struct sgx_encl_page *encl_page = epc_page->owner;
 	struct sgx_encl *encl = encl_page->encl;
@@ -317,8 +321,7 @@ static void sgx_encl_ewb(struct sgx_epc_page *epc_page, bool is_secs_child)
 		if (sgx_va_page_full(va_page))
 			list_move_tail(&va_page->list, &encl->va_pages);
 
-		ret = __sgx_encl_ewb(encl, epc_page, va_page, va_offset,
-				     is_secs_child);
+		ret = __sgx_encl_ewb(encl, epc_page, va_page, va_offset, pt);
 		if (ret == SGX_NOT_TRACKED) {
 			ret = __etrack(sgx_epc_addr(encl->secs.epc_page));
 			if (ret) {
@@ -327,8 +330,8 @@ static void sgx_encl_ewb(struct sgx_epc_page *epc_page, bool is_secs_child)
 					ENCLS_WARN(ret, "ETRACK");
 			}
 
-			ret = __sgx_encl_ewb(encl, epc_page, va_page,
-					     va_offset, is_secs_child);
+			ret = __sgx_encl_ewb(encl, epc_page, va_page, va_offset,
+					     pt);
 			if (ret == SGX_NOT_TRACKED) {
 				/*
 				 * Slow path, send IPIs to kick cpus out of the
@@ -340,7 +343,7 @@ static void sgx_encl_ewb(struct sgx_epc_page *epc_page, bool is_secs_child)
 				on_each_cpu_mask(sgx_encl_ewb_cpumask(encl),
 						 sgx_ipi_cb, NULL, 1);
 				ret = __sgx_encl_ewb(encl, epc_page, va_page,
-						     va_offset, is_secs_child);
+						     va_offset, pt);
 			}
 		}
 
@@ -350,12 +353,13 @@ static void sgx_encl_ewb(struct sgx_epc_page *epc_page, bool is_secs_child)
 
 		encl_page->desc |= va_offset;
 		encl_page->va_page = va_page;
-	} else if (is_secs_child) {
+	} else if (pt != SGX_SECINFO_SECS) {
 		ret = __eremove(sgx_epc_addr(epc_page));
 		WARN(ret, "EREMOVE returned %d\n", ret);
 	}
 
-	if (!is_secs_child)
+	/* The reclaimer is not aware of SECS pages. */
+	if (pt == SGX_SECINFO_SECS)
 		sgx_free_page(epc_page);
 
 	encl_page->epc_page = NULL;
@@ -365,15 +369,22 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page)
 {
 	struct sgx_encl_page *encl_page = epc_page->owner;
 	struct sgx_encl *encl = encl_page->encl;
+	unsigned int pt;
+
+	if (encl_page->desc & SGX_ENCL_PAGE_TCS)
+		pt = SGX_SECINFO_TCS;
+	else
+		pt = SGX_SECINFO_REG;
 
 	mutex_lock(&encl->lock);
 
-	sgx_encl_ewb(epc_page, true);
+	sgx_encl_ewb(epc_page, pt);
+
 	encl->secs_child_cnt--;
+
 	if (!encl->secs_child_cnt &&
-	    (encl->flags & (SGX_ENCL_DEAD | SGX_ENCL_INITIALIZED))) {
-		sgx_encl_ewb(encl->secs.epc_page, false);
-	}
+	    (encl->flags & (SGX_ENCL_DEAD | SGX_ENCL_INITIALIZED)))
+		sgx_encl_ewb(encl->secs.epc_page, SGX_SECINFO_SECS);
 
 	mutex_unlock(&encl->lock);
 }
-- 
2.20.1

