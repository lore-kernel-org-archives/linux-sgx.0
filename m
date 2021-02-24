Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4915EC433DB
	for <linux-sgx@archiver.kernel.org>; Wed, 24 Feb 2021 22:22:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09AD264EDD
	for <linux-sgx@archiver.kernel.org>; Wed, 24 Feb 2021 22:22:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234135AbhBXWWD (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 24 Feb 2021 17:22:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:55632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234995AbhBXWWB (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 24 Feb 2021 17:22:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF0FD64E05;
        Wed, 24 Feb 2021 22:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614205280;
        bh=eBEC0aRUSArhSbDsumkTdQILn/1IBDhdA1Xuq33RPx8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q1GrG6korTuZoBc2gAxHW8sT/N9g7pXeGRIHUdAqPVhfsXi5DRLCdw1JHatPraTTY
         f5cx6MSySLi90tXx/X3AIrNYZmWQVnjTI44BIgzj4QsRO8Ab2eLfhSspVu9kC4r2oj
         /NUOIBPTmPuLHOt/OJKVkZOmahRZBClHdbGwGhKrzy19iNk7Nil5y2xwDPLpi8HdnN
         PXxI5xs0KMMJkPXFZ3csFTi8iIgixM5fKpSZrXqhIpaKew6vRH++UD/kr10budFizG
         IgAE+Y3fhl6+/ICxim/gBQqG8alPW/c4xHnmGIc6DcHHJ9ervDTjM81bJVpe7tLmMD
         eYbHCOwyKt1Jg==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-sgx@vger.kernel.org
Cc:     haitao.huang@intel.com, dan.j.williams@intel.com,
        dave.hansen@linux.intel.com, bp@alien8.de, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 1/3] x86/sgx: Move struct sgx_va_page creation to sgx_alloc_va_page()
Date:   Thu, 25 Feb 2021 00:20:47 +0200
Message-Id: <20210224222049.240754-2-jarkko@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210224222049.240754-1-jarkko@kernel.org>
References: <20210224222049.240754-1-jarkko@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

The VA page creation is illogically split in-between sgx_encl_grow() and
sgx_alloc_va_page(). Move it fully to sgx_alloc_va_page().

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 arch/x86/kernel/cpu/sgx/encl.c  | 36 +++++++++++++++++++++++----------
 arch/x86/kernel/cpu/sgx/encl.h  |  2 +-
 arch/x86/kernel/cpu/sgx/ioctl.c | 20 ++++--------------
 3 files changed, 30 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 7449ef33f081..42eb879c167a 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -671,26 +671,40 @@ int sgx_encl_test_and_clear_young(struct mm_struct *mm,
  * Allocate a free EPC page and convert it to a Version Array (VA) page.
  *
  * Return:
- *   a VA page,
- *   -errno otherwise
+ * - A VA page:		On success.
+ * - ERR_PTR(-errno):	Otherwise.
  */
-struct sgx_epc_page *sgx_alloc_va_page(void)
+struct sgx_va_page *sgx_alloc_va_page(void)
 {
-	struct sgx_epc_page *epc_page;
+	struct sgx_va_page *va_page;
 	int ret;
 
-	epc_page = sgx_alloc_epc_page(NULL, true);
-	if (IS_ERR(epc_page))
-		return ERR_CAST(epc_page);
+	va_page = kzalloc(sizeof(*va_page), GFP_KERNEL);
+	if (!va_page)
+		return ERR_PTR(-ENOMEM);
 
-	ret = __epa(sgx_get_epc_virt_addr(epc_page));
+	va_page->epc_page = sgx_alloc_epc_page(NULL, true);
+	if (IS_ERR(va_page->epc_page)) {
+		ret = PTR_ERR(va_page->epc_page);
+		goto err_va_page;
+	}
+
+	ret = __epa(sgx_get_epc_virt_addr(va_page->epc_page));
 	if (ret) {
 		WARN_ONCE(1, "EPA returned %d (0x%x)", ret, ret);
-		sgx_free_epc_page(epc_page);
-		return ERR_PTR(-EFAULT);
+		ret = -EFAULT;
+		goto err_epc_page;
 	}
 
-	return epc_page;
+	return va_page;
+
+err_epc_page:
+	sgx_free_epc_page(va_page->epc_page);
+
+err_va_page:
+	kfree(va_page);
+
+	return ERR_PTR(ret);
 }
 
 /**
diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
index d8d30ccbef4c..315e87fcc142 100644
--- a/arch/x86/kernel/cpu/sgx/encl.h
+++ b/arch/x86/kernel/cpu/sgx/encl.h
@@ -111,7 +111,7 @@ void sgx_encl_put_backing(struct sgx_backing *backing, bool do_write);
 int sgx_encl_test_and_clear_young(struct mm_struct *mm,
 				  struct sgx_encl_page *page);
 
-struct sgx_epc_page *sgx_alloc_va_page(void);
+struct sgx_va_page *sgx_alloc_va_page(void);
 unsigned int sgx_alloc_va_slot(struct sgx_va_page *va_page);
 void sgx_free_va_slot(struct sgx_va_page *va_page, unsigned int offset);
 bool sgx_va_page_full(struct sgx_va_page *va_page);
diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 90a5caf76939..db6e2c6ad42d 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -19,26 +19,14 @@
 static struct sgx_va_page *sgx_encl_grow(struct sgx_encl *encl)
 {
 	struct sgx_va_page *va_page = NULL;
-	void *err;
 
-	BUILD_BUG_ON(SGX_VA_SLOT_COUNT !=
-		(SGX_ENCL_PAGE_VA_OFFSET_MASK >> 3) + 1);
+	BUILD_BUG_ON(SGX_VA_SLOT_COUNT != (SGX_ENCL_PAGE_VA_OFFSET_MASK >> 3) + 1);
 
-	if (!(encl->page_cnt % SGX_VA_SLOT_COUNT)) {
-		va_page = kzalloc(sizeof(*va_page), GFP_KERNEL);
-		if (!va_page)
-			return ERR_PTR(-ENOMEM);
+	if (!(encl->page_cnt % SGX_VA_SLOT_COUNT))
+		va_page = sgx_alloc_va_page();
 
-		va_page->epc_page = sgx_alloc_va_page();
-		if (IS_ERR(va_page->epc_page)) {
-			err = ERR_CAST(va_page->epc_page);
-			kfree(va_page);
-			return err;
-		}
-
-		WARN_ON_ONCE(encl->page_cnt % SGX_VA_SLOT_COUNT);
-	}
 	encl->page_cnt++;
+
 	return va_page;
 }
 
-- 
2.30.1

