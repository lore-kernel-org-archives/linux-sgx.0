Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB086C43381
	for <linux-sgx@archiver.kernel.org>; Wed, 24 Feb 2021 22:22:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 80DF264F1A
	for <linux-sgx@archiver.kernel.org>; Wed, 24 Feb 2021 22:22:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235269AbhBXWWR (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 24 Feb 2021 17:22:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:55760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234662AbhBXWWG (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 24 Feb 2021 17:22:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80F5E64F0B;
        Wed, 24 Feb 2021 22:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614205285;
        bh=o98Mlt2gWstc9DXeEDyoN5gsnD4yEL83MR6I373jI8k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sZW+WVojrUj00veGp7holiDQ+Mzvnyh6yQbQ7TkENlsSns3tKcWYokk4Ps52A1u4p
         k+bQI0B7F6PM8Hr7AI89wjQr3QbH8M59an6UpUN51Gl3gsrm3TTQjIwL2QgjXcBhbU
         i8huYWoH1ZovPtVaCuK7pWLrBYBmQBtFso/Ll2j3oH7ZiSpc8AjBgI54sstYZiOvXB
         tGhLmSqDuKHVsAgDwAEwK6R70VLB2hT826QI1YyFqqsIzJ/mzJ1cMnroDsIAHCSlBl
         8qeZ7Lbdgx0WobXx1niMyXiWPfxjkI3NHVS0OOqRRui15kQTObsuWBgrib0/8JqNG5
         A9nHstR3HrFDQ==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-sgx@vger.kernel.org
Cc:     haitao.huang@intel.com, dan.j.williams@intel.com,
        dave.hansen@linux.intel.com, bp@alien8.de, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 3/3] x86/sgx: Use sgx_va for the enclave's version array
Date:   Thu, 25 Feb 2021 00:20:49 +0200
Message-Id: <20210224222049.240754-4-jarkko@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210224222049.240754-1-jarkko@kernel.org>
References: <20210224222049.240754-1-jarkko@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Use the xarray based sgx_va to maintain VA slots for an enclave. This
effectively removes the need for any complex dynamic behaviour as the
slots are assigned only in during the enclave construction.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 arch/x86/kernel/cpu/sgx/driver.c |  3 +-
 arch/x86/kernel/cpu/sgx/encl.c   | 60 ++---------------------------
 arch/x86/kernel/cpu/sgx/encl.h   | 12 ++----
 arch/x86/kernel/cpu/sgx/ioctl.c  | 65 ++++++++++++--------------------
 arch/x86/kernel/cpu/sgx/main.c   | 18 ++-------
 5 files changed, 37 insertions(+), 121 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx/driver.c
index 8ce6d8371cfb..3fa52d962456 100644
--- a/arch/x86/kernel/cpu/sgx/driver.c
+++ b/arch/x86/kernel/cpu/sgx/driver.c
@@ -26,9 +26,10 @@ static int sgx_open(struct inode *inode, struct file *file)
 	kref_init(&encl->refcount);
 	xa_init(&encl->page_array);
 	mutex_init(&encl->lock);
-	INIT_LIST_HEAD(&encl->va_pages);
 	INIT_LIST_HEAD(&encl->mm_list);
 	spin_lock_init(&encl->mm_lock);
+	ida_init(&encl->va_index);
+	sgx_va_init(&encl->va);
 
 	ret = init_srcu_struct(&encl->srcu);
 	if (ret) {
diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index c8ce3779eaa7..6aef00814afc 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -20,7 +20,7 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
 			   struct sgx_epc_page *epc_page,
 			   struct sgx_epc_page *secs_page)
 {
-	unsigned long va_offset = encl_page->desc & SGX_ENCL_PAGE_VA_OFFSET_MASK;
+	unsigned long va_offset = 8 * (encl_page->va_index & (SGX_VA_SLOT_COUNT - 1));
 	struct sgx_encl *encl = encl_page->encl;
 	struct sgx_pageinfo pginfo;
 	struct sgx_backing b;
@@ -67,8 +67,6 @@ static struct sgx_epc_page *sgx_encl_eldu(struct sgx_encl_page *encl_page,
 					  struct sgx_epc_page *secs_page)
 {
 
-	unsigned long va_offset = encl_page->desc & SGX_ENCL_PAGE_VA_OFFSET_MASK;
-	struct sgx_encl *encl = encl_page->encl;
 	struct sgx_epc_page *epc_page;
 	int ret;
 
@@ -82,9 +80,6 @@ static struct sgx_epc_page *sgx_encl_eldu(struct sgx_encl_page *encl_page,
 		return ERR_PTR(ret);
 	}
 
-	sgx_free_va_slot(encl_page->va_page, va_offset);
-	list_move(&encl_page->va_page->list, &encl->va_pages);
-	encl_page->desc &= ~SGX_ENCL_PAGE_VA_OFFSET_MASK;
 	encl_page->epc_page = epc_page;
 
 	return epc_page;
@@ -391,7 +386,6 @@ const struct vm_operations_struct sgx_vm_ops = {
 void sgx_encl_release(struct kref *ref)
 {
 	struct sgx_encl *encl = container_of(ref, struct sgx_encl, refcount);
-	struct sgx_va_page *va_page;
 	struct sgx_encl_page *entry;
 	unsigned long index;
 
@@ -419,13 +413,8 @@ void sgx_encl_release(struct kref *ref)
 		encl->secs.epc_page = NULL;
 	}
 
-	while (!list_empty(&encl->va_pages)) {
-		va_page = list_first_entry(&encl->va_pages, struct sgx_va_page,
-					   list);
-		list_del(&va_page->list);
-		sgx_free_epc_page(va_page->epc_page);
-		kfree(va_page);
-	}
+	sgx_va_destroy(&encl->va);
+	ida_destroy(&encl->va_index);
 
 	if (encl->backing)
 		fput(encl->backing);
@@ -707,49 +696,6 @@ struct sgx_va_page *sgx_alloc_va_page(void)
 	return ERR_PTR(ret);
 }
 
-/**
- * sgx_alloc_va_slot - allocate a VA slot
- * @va_page:	a &struct sgx_va_page instance
- *
- * Allocates a slot from a &struct sgx_va_page instance.
- *
- * Return: offset of the slot inside the VA page
- */
-unsigned int sgx_alloc_va_slot(struct sgx_va_page *va_page)
-{
-	int slot = find_first_zero_bit(va_page->slots, SGX_VA_SLOT_COUNT);
-
-	if (slot < SGX_VA_SLOT_COUNT)
-		set_bit(slot, va_page->slots);
-
-	return slot << 3;
-}
-
-/**
- * sgx_free_va_slot - free a VA slot
- * @va_page:	a &struct sgx_va_page instance
- * @offset:	offset of the slot inside the VA page
- *
- * Frees a slot from a &struct sgx_va_page instance.
- */
-void sgx_free_va_slot(struct sgx_va_page *va_page, unsigned int offset)
-{
-	clear_bit(offset >> 3, va_page->slots);
-}
-
-/**
- * sgx_va_page_full - is the VA page full?
- * @va_page:	a &struct sgx_va_page instance
- *
- * Return: true if all slots have been taken
- */
-bool sgx_va_page_full(struct sgx_va_page *va_page)
-{
-	int slot = find_first_zero_bit(va_page->slots, SGX_VA_SLOT_COUNT);
-
-	return slot == SGX_VA_SLOT_COUNT;
-}
-
 /**
  * sgx_va_init() - Initialize a version array (VA)
  * @va:		A version array.
diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
index 806cf3ff7391..a1d6280029f0 100644
--- a/arch/x86/kernel/cpu/sgx/encl.h
+++ b/arch/x86/kernel/cpu/sgx/encl.h
@@ -8,6 +8,7 @@
 #define _X86_ENCL_H
 
 #include <linux/cpumask.h>
+#include <linux/idr.h>
 #include <linux/kref.h>
 #include <linux/list.h>
 #include <linux/mm_types.h>
@@ -24,7 +25,6 @@
 struct sgx_va_page {
 	struct sgx_epc_page *epc_page;
 	DECLARE_BITMAP(slots, SGX_VA_SLOT_COUNT);
-	struct list_head list;
 };
 
 struct sgx_va {
@@ -32,9 +32,6 @@ struct sgx_va {
 	struct mutex lock;
 };
 
-/* 'desc' bits holding the offset in the VA (version array) page. */
-#define SGX_ENCL_PAGE_VA_OFFSET_MASK	GENMASK_ULL(11, 3)
-
 /* 'desc' bit marking that the page is being reclaimed. */
 #define SGX_ENCL_PAGE_BEING_RECLAIMED	BIT(3)
 
@@ -44,6 +41,7 @@ struct sgx_encl_page {
 	struct sgx_epc_page *epc_page;
 	struct sgx_encl *encl;
 	struct sgx_va_page *va_page;
+	int va_index;
 };
 
 enum sgx_encl_flags {
@@ -75,7 +73,8 @@ struct sgx_encl {
 	cpumask_t cpumask;
 	struct file *backing;
 	struct kref refcount;
-	struct list_head va_pages;
+	struct ida va_index;
+	struct sgx_va va;
 	unsigned long mm_list_version;
 	struct list_head mm_list;
 	spinlock_t mm_lock;
@@ -117,9 +116,6 @@ int sgx_encl_test_and_clear_young(struct mm_struct *mm,
 				  struct sgx_encl_page *page);
 
 struct sgx_va_page *sgx_alloc_va_page(void);
-unsigned int sgx_alloc_va_slot(struct sgx_va_page *va_page);
-void sgx_free_va_slot(struct sgx_va_page *va_page, unsigned int offset);
-bool sgx_va_page_full(struct sgx_va_page *va_page);
 
 void sgx_va_init(struct sgx_va *va);
 void sgx_va_destroy(struct sgx_va *va);
diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index db6e2c6ad42d..4a5393b25edd 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -16,47 +16,38 @@
 #include "encl.h"
 #include "encls.h"
 
-static struct sgx_va_page *sgx_encl_grow(struct sgx_encl *encl)
+static int sgx_encl_alloc_va_slot(struct sgx_encl *encl, struct sgx_encl_page *encl_page)
 {
-	struct sgx_va_page *va_page = NULL;
-
-	BUILD_BUG_ON(SGX_VA_SLOT_COUNT != (SGX_ENCL_PAGE_VA_OFFSET_MASK >> 3) + 1);
-
-	if (!(encl->page_cnt % SGX_VA_SLOT_COUNT))
-		va_page = sgx_alloc_va_page();
+	struct sgx_va_page *va_page;
+	int ret;
 
-	encl->page_cnt++;
+	ret = ida_alloc(&encl->va_index, GFP_KERNEL);
+	if (ret < 0)
+		return ret;
 
-	return va_page;
-}
+	va_page = sgx_va_get(&encl->va, ret);
+	if (IS_ERR(va_page)) {
+		ida_free(&encl->va_index, ret);
+		return PTR_ERR(va_page);
+	}
 
-static void sgx_encl_shrink(struct sgx_encl *encl, struct sgx_va_page *va_page)
-{
-	encl->page_cnt--;
+	encl_page->va_page = va_page;
+	encl_page->va_index = ret;
 
-	if (va_page) {
-		sgx_free_epc_page(va_page->epc_page);
-		list_del(&va_page->list);
-		kfree(va_page);
-	}
+	return 0;
 }
 
 static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
 {
 	struct sgx_epc_page *secs_epc;
-	struct sgx_va_page *va_page;
 	struct sgx_pageinfo pginfo;
 	struct sgx_secinfo secinfo;
 	unsigned long encl_size;
 	struct file *backing;
 	long ret;
 
-	va_page = sgx_encl_grow(encl);
-	if (IS_ERR(va_page))
-		return PTR_ERR(va_page);
-	else if (va_page)
-		list_add(&va_page->list, &encl->va_pages);
-	/* else the tail page of the VA page list had free slots. */
+	/* Get a VA slot for swapping the SECS. */
+	ret = sgx_encl_alloc_va_slot(encl, &encl->secs);
 
 	/* The extra page goes to SECS. */
 	encl_size = secs->size + PAGE_SIZE;
@@ -65,7 +56,7 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
 				   VM_NORESERVE);
 	if (IS_ERR(backing)) {
 		ret = PTR_ERR(backing);
-		goto err_out_shrink;
+		goto err_out_va;
 	}
 
 	encl->backing = backing;
@@ -112,8 +103,9 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
 	fput(encl->backing);
 	encl->backing = NULL;
 
-err_out_shrink:
-	sgx_encl_shrink(encl, va_page);
+err_out_va:
+	sgx_va_put(&encl->va, encl->secs.va_index);
+	ida_free(&encl->va_index, encl->secs.va_index);
 
 	return ret;
 }
@@ -280,7 +272,6 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long src,
 {
 	struct sgx_encl_page *encl_page;
 	struct sgx_epc_page *epc_page;
-	struct sgx_va_page *va_page;
 	int ret;
 
 	encl_page = sgx_encl_page_alloc(encl, offset, secinfo->flags);
@@ -293,22 +284,13 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long src,
 		return PTR_ERR(epc_page);
 	}
 
-	va_page = sgx_encl_grow(encl);
-	if (IS_ERR(va_page)) {
-		ret = PTR_ERR(va_page);
+	ret = sgx_encl_alloc_va_slot(encl, encl_page);
+	if (ret)
 		goto err_out_free;
-	}
 
 	mmap_read_lock(current->mm);
 	mutex_lock(&encl->lock);
 
-	/*
-	 * Adding to encl->va_pages must be done under encl->lock.  Ditto for
-	 * deleting (via sgx_encl_shrink()) in the error path.
-	 */
-	if (va_page)
-		list_add(&va_page->list, &encl->va_pages);
-
 	/*
 	 * Insert prior to EADD in case of OOM.  EADD modifies MRENCLAVE, i.e.
 	 * can't be gracefully unwound, while failure on EADD/EXTEND is limited
@@ -348,7 +330,8 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long src,
 	xa_erase(&encl->page_array, PFN_DOWN(encl_page->desc));
 
 err_out_unlock:
-	sgx_encl_shrink(encl, va_page);
+	sgx_va_put(&encl->va, encl_page->va_index);
+	ida_free(&encl->va_index, encl_page->va_index);
 	mutex_unlock(&encl->lock);
 	mmap_read_unlock(current->mm);
 
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 26dfe6aecd72..5b2e5767419c 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -215,12 +215,9 @@ static void sgx_encl_ewb(struct sgx_epc_page *epc_page,
 
 	encl_page->desc &= ~SGX_ENCL_PAGE_BEING_RECLAIMED;
 
-	va_page = list_first_entry(&encl->va_pages, struct sgx_va_page,
-				   list);
-	va_offset = sgx_alloc_va_slot(va_page);
+	va_page = encl_page->va_page;
+	va_offset = 8 * (encl_page->va_index & (SGX_VA_SLOT_COUNT - 1));
 	va_slot = sgx_get_epc_virt_addr(va_page->epc_page) + va_offset;
-	if (sgx_va_page_full(va_page))
-		list_move_tail(&va_page->list, &encl->va_pages);
 
 	ret = __sgx_encl_ewb(epc_page, va_slot, backing);
 	if (ret == SGX_NOT_TRACKED) {
@@ -245,15 +242,8 @@ static void sgx_encl_ewb(struct sgx_epc_page *epc_page,
 		}
 	}
 
-	if (ret) {
-		if (encls_failed(ret))
-			ENCLS_WARN(ret, "EWB");
-
-		sgx_free_va_slot(va_page, va_offset);
-	} else {
-		encl_page->desc |= va_offset;
-		encl_page->va_page = va_page;
-	}
+	if (ret && encls_failed(ret))
+		ENCLS_WARN(ret, "EWB");
 }
 
 static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
-- 
2.30.1

