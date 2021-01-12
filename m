Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCE03C432C3
	for <linux-sgx@archiver.kernel.org>; Tue, 12 Jan 2021 23:35:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF8412312A
	for <linux-sgx@archiver.kernel.org>; Tue, 12 Jan 2021 23:35:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388278AbhALXex (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 12 Jan 2021 18:34:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:44400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388275AbhALXew (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 12 Jan 2021 18:34:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02CEA23132;
        Tue, 12 Jan 2021 23:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610494452;
        bh=ii7AzTUaeH0Gj77nIwckceBvA1nFbnDT9a8OwaZZBZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aWWSiPJhDqn/SsRpGLOz5QLU+DN1wn4K0WB+tcXSojTy3dlpljUhxnpdcP1SF29UY
         50EG9eExTzQDuGKyy13PMMut4s0zSNIRd/cAsMxW3fvZwZuzItutzFVfAdTkT0Xemg
         fX30LXr6mWcVZbXB5kvird7s2XblbXPsrzfhZTlWoX8Bw9Nuv1L6NStCj2Mumy5HtH
         CVsNqN/FeAEubdczL381aESMsR7NM/oIpvZMpJopxcrbHI/MhIO/7aDgW2Mc7K1O9m
         at55iFShFOA/EZBYn32pw+/Z5vDCTN0m85O9XfA8IHdlTtaC/a1fPsawyhvCi/SGNW
         YhvI8Gxp0++kQ==
From:   jarkko@kernel.org
To:     linux-sgx@vger.kernel.org
Cc:     dave.hansen@intel.com, kai.huang@intel.com, haitao.huang@intel.com,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v2 2/2] x86/sgx: Wipe out EREMOVE from sgx_free_epc_page()
Date:   Wed, 13 Jan 2021 01:33:51 +0200
Message-Id: <20210112233351.68678-3-jarkko@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210112233351.68678-1-jarkko@kernel.org>
References: <20210112233351.68678-1-jarkko@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

From: "jarkko@kernel.org" <jarkko@kernel.org>

Encapsulate the snippet in sgx_free_epc_page() concerning EREMOVE to
sgx_reset_epc_page(), which is a static helper function for
sgx_encl_release(). It's the only function existing, which deals with
initialized pages.

Signed-off-by: jarkko@kernel.org <jarkko@kernel.org>
---
v2: Fixed a compilation error s/page/epc_page/ change not amended
    to the patches.
 arch/x86/kernel/cpu/sgx/encl.c | 15 ++++++++++++++-
 arch/x86/kernel/cpu/sgx/main.c | 10 ++++------
 2 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index fe7256db6e73..511f4bc70699 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -389,6 +389,16 @@ const struct vm_operations_struct sgx_vm_ops = {
 	.access = sgx_vma_access,
 };
 
+
+static void sgx_reset_epc_page(struct sgx_epc_page *epc_page)
+{
+	int ret;
+
+	ret = __eremove(sgx_get_epc_virt_addr(epc_page));
+	if (WARN_ONCE(ret, "EREMOVE returned %d (0x%x)", ret, ret))
+		return;
+}
+
 /**
  * sgx_encl_release - Destroy an enclave instance
  * @kref:	address of a kref inside &sgx_encl
@@ -412,6 +422,7 @@ void sgx_encl_release(struct kref *ref)
 			if (sgx_unmark_page_reclaimable(entry->epc_page))
 				continue;
 
+			sgx_reset_epc_page(entry->epc_page);
 			sgx_free_epc_page(entry->epc_page);
 			encl->secs_child_cnt--;
 			entry->epc_page = NULL;
@@ -423,6 +434,7 @@ void sgx_encl_release(struct kref *ref)
 	xa_destroy(&encl->page_array);
 
 	if (!encl->secs_child_cnt && encl->secs.epc_page) {
+		sgx_reset_epc_page(encl->secs.epc_page);
 		sgx_free_epc_page(encl->secs.epc_page);
 		encl->secs.epc_page = NULL;
 	}
@@ -431,7 +443,8 @@ void sgx_encl_release(struct kref *ref)
 		va_page = list_first_entry(&encl->va_pages, struct sgx_va_page,
 					   list);
 		list_del(&va_page->list);
-		sgx_free_epc_page(va_page->epc_page);
+		sgx_reset_epc_page(entry->epc_page);
+		sgx_free_epc_page(entry->epc_page);
 		kfree(va_page);
 	}
 
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index b2996cb63a8a..89d52fb56d4b 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -629,16 +629,14 @@ struct sgx_epc_page *sgx_alloc_epc_page(void *owner, bool reclaim)
  * sgx_free_epc_page() - Free an EPC page
  * @page:	an EPC page
  *
- * Call EREMOVE for an EPC page and insert it back to the list of free pages.
+ * Put the EPC page back to the list of free pages. It's the callers
+ * responsibility to make sure that the page is in uninitialized state In other
+ * words, do EREMOVE, EWB or whatever operation is necessary before calling
+ * this function.
  */
 void sgx_free_epc_page(struct sgx_epc_page *page)
 {
 	struct sgx_epc_section *section = &sgx_epc_sections[page->section];
-	int ret;
-
-	ret = __eremove(sgx_get_epc_virt_addr(page));
-	if (WARN_ONCE(ret, "EREMOVE returned %d (0x%x)", ret, ret))
-		return;
 
 	spin_lock(&section->lock);
 	list_add_tail(&page->list, &section->page_list);
-- 
2.29.2

