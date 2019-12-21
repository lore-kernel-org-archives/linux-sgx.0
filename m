Return-Path: <SRS0=9G3N=2L=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFDB0C2D0D4
	for <linux-sgx@archiver.kernel.org>; Sat, 21 Dec 2019 00:32:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0DCE2072B
	for <linux-sgx@archiver.kernel.org>; Sat, 21 Dec 2019 00:32:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbfLUAcA (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 20 Dec 2019 19:32:00 -0500
Received: from mga07.intel.com ([134.134.136.100]:9724 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726462AbfLUAcA (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 20 Dec 2019 19:32:00 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Dec 2019 16:31:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,337,1571727600"; 
   d="scan'208";a="267658128"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by FMSMGA003.fm.intel.com with ESMTP; 20 Dec 2019 16:31:57 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v25 4/4] x86/sgx: Pre-calculate VA slot virtual address in sgx_encl_ewb()
Date:   Fri, 20 Dec 2019 16:31:56 -0800
Message-Id: <20191221003156.27236-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191221003156.27236-1-sean.j.christopherson@intel.com>
References: <20191221003156.27236-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Now that sgx_epc_addr() is purely a calculation, calculate the VA slot
in sgx_encl_ewb() and pass it to __sgx_encl_ewb() to reduce line lengths
and avoid re-calculating the address on every EWB attempt.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/reclaim.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/reclaim.c b/arch/x86/kernel/cpu/sgx/reclaim.c
index 030b1c24da07..a33f1c45477a 100644
--- a/arch/x86/kernel/cpu/sgx/reclaim.c
+++ b/arch/x86/kernel/cpu/sgx/reclaim.c
@@ -223,8 +223,7 @@ static void sgx_reclaimer_block(struct sgx_epc_page *epc_page)
 	mutex_unlock(&encl->lock);
 }
 
-static int __sgx_encl_ewb(struct sgx_epc_page *epc_page,
-			  struct sgx_va_page *va_page, unsigned int va_offset,
+static int __sgx_encl_ewb(struct sgx_epc_page *epc_page, void *va_slot,
 			  struct sgx_backing *backing)
 {
 	struct sgx_pageinfo pginfo;
@@ -237,8 +236,7 @@ static int __sgx_encl_ewb(struct sgx_epc_page *epc_page,
 	pginfo.metadata = (unsigned long)kmap_atomic(backing->pcmd) +
 			  backing->pcmd_offset;
 
-	ret = __ewb(&pginfo, sgx_epc_addr(epc_page),
-		    sgx_epc_addr(va_page->epc_page) + va_offset);
+	ret = __ewb(&pginfo, sgx_epc_addr(epc_page), va_slot);
 
 	kunmap_atomic((void *)(unsigned long)(pginfo.metadata -
 					      backing->pcmd_offset));
@@ -282,6 +280,7 @@ static void sgx_encl_ewb(struct sgx_epc_page *epc_page,
 	struct sgx_encl *encl = encl_page->encl;
 	struct sgx_va_page *va_page;
 	unsigned int va_offset;
+	void *va_slot;
 	int ret;
 
 	encl_page->desc &= ~SGX_ENCL_PAGE_RECLAIMED;
@@ -289,10 +288,11 @@ static void sgx_encl_ewb(struct sgx_epc_page *epc_page,
 	va_page = list_first_entry(&encl->va_pages, struct sgx_va_page,
 				   list);
 	va_offset = sgx_alloc_va_slot(va_page);
+	va_slot = sgx_epc_addr(va_page->epc_page) + va_offset;
 	if (sgx_va_page_full(va_page))
 		list_move_tail(&va_page->list, &encl->va_pages);
 
-	ret = __sgx_encl_ewb(epc_page, va_page, va_offset, backing);
+	ret = __sgx_encl_ewb(epc_page, va_slot, backing);
 	if (ret == SGX_NOT_TRACKED) {
 		ret = __etrack(sgx_epc_addr(encl->secs.epc_page));
 		if (ret) {
@@ -300,7 +300,7 @@ static void sgx_encl_ewb(struct sgx_epc_page *epc_page,
 				ENCLS_WARN(ret, "ETRACK");
 		}
 
-		ret = __sgx_encl_ewb(epc_page, va_page, va_offset, backing);
+		ret = __sgx_encl_ewb(epc_page, va_slot, backing);
 		if (ret == SGX_NOT_TRACKED) {
 			/*
 			 * Slow path, send IPIs to kick cpus out of the
@@ -311,8 +311,7 @@ static void sgx_encl_ewb(struct sgx_epc_page *epc_page,
 			 */
 			on_each_cpu_mask(sgx_encl_ewb_cpumask(encl),
 					 sgx_ipi_cb, NULL, 1);
-			ret = __sgx_encl_ewb(epc_page, va_page, va_offset,
-					     backing);
+			ret = __sgx_encl_ewb(epc_page, va_slot, backing);
 		}
 	}
 
-- 
2.24.1

