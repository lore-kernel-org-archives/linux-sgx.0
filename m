Return-Path: <SRS0=iuVh=YD=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44744ECE596
	for <linux-sgx@archiver.kernel.org>; Thu, 10 Oct 2019 21:43:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1316E21835
	for <linux-sgx@archiver.kernel.org>; Thu, 10 Oct 2019 21:43:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727459AbfJJVnE (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 10 Oct 2019 17:43:04 -0400
Received: from mga18.intel.com ([134.134.136.126]:32755 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726983AbfJJVnE (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 10 Oct 2019 17:43:04 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Oct 2019 14:43:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,281,1566889200"; 
   d="scan'208";a="194145480"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga007.fm.intel.com with ESMTP; 10 Oct 2019 14:43:03 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v23 2/9] x86/sgx: Do not EWB SECS if the enclave is dead
Date:   Thu, 10 Oct 2019 14:42:54 -0700
Message-Id: <20191010214301.25669-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191010214301.25669-1-sean.j.christopherson@intel.com>
References: <20191010214301.25669-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Don't EWB if the enclave is dead when opportunistically zapping the SECS
during reclaim as VA pages are freed by sgx_encl_destroy(), i.e.
sgx_encl_ewb() will consume a bad encl->va_pages if the enclave has been
destroyed.

Add a comment in sgx_encl_destroy() to explicit call out that it's ok to
free VA pages.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/encl.c    |  6 +++++-
 arch/x86/kernel/cpu/sgx/reclaim.c | 19 +++++++++++--------
 2 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index b4d7b2f9609f..ea21d3737a32 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -484,7 +484,11 @@ void sgx_encl_destroy(struct sgx_encl *encl)
 		encl->secs.epc_page = NULL;
 	}
 
-
+	/*
+	 * The reclaimer is responsible for checking SGX_ENCL_DEAD before doing
+	 * EWB, thus it's safe to free VA pages even if the reclaimer holds a
+	 * reference to the enclave.
+	 */
 	while (!list_empty(&encl->va_pages)) {
 		va_page = list_first_entry(&encl->va_pages, struct sgx_va_page,
 					   list);
diff --git a/arch/x86/kernel/cpu/sgx/reclaim.c b/arch/x86/kernel/cpu/sgx/reclaim.c
index 391fbc3e7e98..8143c9a20894 100644
--- a/arch/x86/kernel/cpu/sgx/reclaim.c
+++ b/arch/x86/kernel/cpu/sgx/reclaim.c
@@ -321,16 +321,19 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
 	encl_page->epc_page = NULL;
 	encl->secs_child_cnt--;
 
-	if (!encl->secs_child_cnt &&
-	    (atomic_read(&encl->flags) &
-	     (SGX_ENCL_DEAD | SGX_ENCL_INITIALIZED))) {
-		ret = sgx_encl_get_backing(encl, PFN_DOWN(encl->size),
-					   &secs_backing);
-		if (!ret) {
-			sgx_encl_ewb(encl->secs.epc_page, &secs_backing);
+	if (!encl->secs_child_cnt) {
+		if (atomic_read(&encl->flags) & SGX_ENCL_DEAD) {
 			sgx_free_page(encl->secs.epc_page);
-
 			encl->secs.epc_page = NULL;
+		} else if (atomic_read(&encl->flags) & SGX_ENCL_INITIALIZED) {
+			ret = sgx_encl_get_backing(encl, PFN_DOWN(encl->size),
+						   &secs_backing);
+			if (!ret) {
+				sgx_encl_ewb(encl->secs.epc_page, &secs_backing);
+
+				sgx_free_page(encl->secs.epc_page);
+				encl->secs.epc_page = NULL;
+			}
 
 			sgx_encl_put_backing(&secs_backing, true);
 		}
-- 
2.22.0

