Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57CD1C433EF
	for <linux-sgx@archiver.kernel.org>; Thu, 28 Apr 2022 20:11:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236956AbiD1UOy (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 28 Apr 2022 16:14:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231637AbiD1UOx (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 28 Apr 2022 16:14:53 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F82ABAB80
        for <linux-sgx@vger.kernel.org>; Thu, 28 Apr 2022 13:11:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651176695; x=1682712695;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7r8lX++img5Z6cdFhREpobiVE/JBh+N7O293Rb5WiWU=;
  b=I0X/9bgpuWvRm+m1tnpB8HVGP3EtcDifFubyTY3WmIGw21Fd3ZnWNtIH
   gbh/5RZ9wV9fa9SmFZ1/sJEBjGFMZ3M2PTb0BIkHXPl5Kw1Tfwy+zNCSA
   5YWqHNEkXSdjufjdFLCc4Ikkr0QxhlUxZHCRA5qiJnc4tuii9YwXdOym4
   pJhaFybfsXsqjPGoJ5Xj36GZHEIMwGv70fMxYtEOf+znykmqMgcDpjtIn
   fH+77AbfWUj1J8GelhMosMREjJOz3C+yWQbuhungwRFmy8fZfvXyvBkmD
   eEC/w/6ehkk5hwuzIqZxKGEGWhnPEUX/DG13YRZAWk2VJGvh6ZwQskCqj
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="246324256"
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="246324256"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 13:11:34 -0700
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="514458613"
Received: from rchatre-ws.ostc.intel.com ([10.54.69.144])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 13:11:32 -0700
From:   Reinette Chatre <reinette.chatre@intel.com>
To:     dave.hansen@linux.intel.com, jarkko@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     haitao.huang@intel.com
Subject: [RFC PATCH 4/4] x86/sgx: Do not allocate backing pages when loading from backing store
Date:   Thu, 28 Apr 2022 13:11:27 -0700
Message-Id: <117862f7eb5bfef54d3b28f53746e6cf9e05508e.1651171455.git.reinette.chatre@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1651171455.git.reinette.chatre@intel.com>
References: <cover.1651171455.git.reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Preface:
This is intended as a debugging aid forming part of the investigation
into ENCLS[ELDU] returning #GP. This is not intended for inclusion.

Changelog:
The shmem backing store is used to (a) store encrypted enclave pages
when they are reclaimed from the enclave, and (b) load encrypted
enclave pages back into the enclave when they are accessed.

The same interface, sgx_encl_get_backing_page(), is used whether
a new backing page is needed to store an enclave page being
reclaimed or whether an existing backing page is loaded to reload
an enclave page to the EPC. This is because of this flow:
sgx_encl_get_backing_page()
        shmem_read_mapping_page_gfp()
                shmem_getpage_gfp(..., ..., ..., SGP_CACHE, ...)

With this interface used the backing pages are retrieved with the
SGP_CACHE flag that will automatically allocate a backing page if
it is not present.

In an effort to diagnose #GP ENCLS[ELDU] the interface is split
to ensure that when a backing page is expected to exist it is just
loaded (lookup), not allocated.

Replace sgx_encl_get_backing() with sgx_encl_lookup_backing() and
sgx_encl_alloc_backing() to distinguish whether a backing page needs
to be allocated or is expected to exist. sgx_encl_alloc_backing()
is used by the reclaimer during the ENCLS[EWB] flow and
sgx_encl_lookup_backing() is used in the ENCLS[ELDU] flow.

An IDA is used to keep track of PCMD page allocation to ensure these
pages are allocated once.

This patch revealed that there are scenarios where the backing store
does not contain a page expected to exist - sgx_encl_lookup_backing()
fails with -ENOENT. This would explain ENCLS[ELDU] returning #GP
since previously such a missing page would be allocated and thus
trigger a MAC verification failure.

Specifically, with the debugging included enabled an oversubscribe
stress test encounters the error:
sgx: sgx_encl_get_backing_page:847 fail 1 backing page with -2

The reason why the backing page is not present is not understood.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 arch/x86/kernel/cpu/sgx/encl.c  | 83 ++++++++++++++++++++++++++++-----
 arch/x86/kernel/cpu/sgx/encl.h  |  8 +++-
 arch/x86/kernel/cpu/sgx/ioctl.c |  1 +
 arch/x86/kernel/cpu/sgx/main.c  |  6 +--
 4 files changed, 82 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index e03f124ce772..22ed886dc825 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -60,7 +60,7 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
 
 	page_pcmd_off = sgx_encl_get_backing_page_pcmd_offset(encl, page_index);
 
-	ret = sgx_encl_get_backing(encl, page_index, &b);
+	ret = sgx_encl_lookup_backing(encl, page_index, &b);
 	if (ret)
 		return ret;
 
@@ -102,8 +102,10 @@ static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
 
 	sgx_encl_truncate_backing_page(encl, page_index);
 
-	if (pcmd_page_empty)
+	if (pcmd_page_empty) {
+		ida_free(&encl->pcmd_in_backing, PFN_DOWN(page_pcmd_off));
 		sgx_encl_truncate_backing_page(encl, PFN_DOWN(page_pcmd_off));
+	}
 
 	return ret;
 }
@@ -617,6 +619,7 @@ void sgx_encl_release(struct kref *ref)
 
 	if (encl->backing)
 		fput(encl->backing);
+	ida_destroy(&encl->pcmd_in_backing);
 
 	cleanup_srcu_struct(&encl->srcu);
 
@@ -807,17 +810,39 @@ const cpumask_t *sgx_encl_cpumask(struct sgx_encl *encl)
 }
 
 static struct page *sgx_encl_get_backing_page(struct sgx_encl *encl,
-					      pgoff_t index)
+					      pgoff_t index, enum sgp_type sgp)
 {
 	struct inode *inode = encl->backing->f_path.dentry->d_inode;
-	struct address_space *mapping = inode->i_mapping;
-	gfp_t gfpmask = mapping_gfp_mask(mapping);
+	struct page *page = NULL;
+	int ret;
+
+	ret = shmem_getpage(inode, index, &page, sgp);
+	if (ret) {
+		pr_debug("%s:%d fail %d backing page with %d\n",
+			 __func__, __LINE__, sgp, ret);
+		return ERR_PTR(ret);
+	}
+
+	if (!page) {
+		pr_debug("%s:%d fail %d backing page with NULL page\n",
+			 __func__, __LINE__, sgp);
+		return ERR_PTR(-EFAULT);
+	}
 
-	return shmem_read_mapping_page_gfp(mapping, index, gfpmask);
+	if (PageHWPoison(page)) {
+		pr_debug("%s:%d fail %d backing page with poison page\n",
+			 __func__, __LINE__, sgp);
+		unlock_page(page);
+		put_page(page);
+		return ERR_PTR(-EIO);
+	}
+
+	unlock_page(page);
+	return page;
 }
 
 /**
- * sgx_encl_get_backing() - Pin the backing storage
+ * sgx_encl_alloc_backing() - Pin the backing storage
  * @encl:	an enclave pointer
  * @page_index:	enclave page index
  * @backing:	data for accessing backing storage for the page
@@ -829,18 +854,54 @@ static struct page *sgx_encl_get_backing_page(struct sgx_encl *encl,
  *   0 on success,
  *   -errno otherwise.
  */
-int sgx_encl_get_backing(struct sgx_encl *encl, unsigned long page_index,
-			 struct sgx_backing *backing)
+int sgx_encl_alloc_backing(struct sgx_encl *encl, unsigned long page_index,
+			   struct sgx_backing *backing)
+{
+	pgoff_t page_pcmd_off = sgx_encl_get_backing_page_pcmd_offset(encl, page_index);
+	pgoff_t pcmd_index = PFN_DOWN(page_pcmd_off);
+	struct page *contents;
+	struct page *pcmd;
+	int ret;
+
+	contents = sgx_encl_get_backing_page(encl, page_index, SGP_CACHE);
+	if (IS_ERR(contents))
+		return PTR_ERR(contents);
+
+	ret = ida_alloc_range(&encl->pcmd_in_backing, pcmd_index,
+			      pcmd_index, GFP_KERNEL);
+	if (ret == -ENOSPC) {
+		/* pcmd_index backing page already created, just look it up */
+		pcmd = sgx_encl_get_backing_page(encl, pcmd_index, SGP_NOALLOC);
+	} else if (ret >= 0) {
+		pcmd = sgx_encl_get_backing_page(encl, pcmd_index, SGP_CACHE);
+	} else {
+		pcmd = ERR_PTR(ret);
+	}
+	if (IS_ERR(pcmd)) {
+		put_page(contents);
+		return PTR_ERR(pcmd);
+	}
+
+	backing->page_index = page_index;
+	backing->contents = contents;
+	backing->pcmd = pcmd;
+	backing->pcmd_offset = page_pcmd_off & (PAGE_SIZE - 1);
+
+	return 0;
+}
+
+int sgx_encl_lookup_backing(struct sgx_encl *encl, unsigned long page_index,
+			    struct sgx_backing *backing)
 {
 	pgoff_t page_pcmd_off = sgx_encl_get_backing_page_pcmd_offset(encl, page_index);
 	struct page *contents;
 	struct page *pcmd;
 
-	contents = sgx_encl_get_backing_page(encl, page_index);
+	contents = sgx_encl_get_backing_page(encl, page_index, SGP_NOALLOC);
 	if (IS_ERR(contents))
 		return PTR_ERR(contents);
 
-	pcmd = sgx_encl_get_backing_page(encl, PFN_DOWN(page_pcmd_off));
+	pcmd = sgx_encl_get_backing_page(encl, PFN_DOWN(page_pcmd_off), SGP_NOALLOC);
 	if (IS_ERR(pcmd)) {
 		put_page(contents);
 		return PTR_ERR(pcmd);
diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
index 66adb8faec45..2a8d3bd3338f 100644
--- a/arch/x86/kernel/cpu/sgx/encl.h
+++ b/arch/x86/kernel/cpu/sgx/encl.h
@@ -8,6 +8,7 @@
 #define _X86_ENCL_H
 
 #include <linux/cpumask.h>
+#include <linux/idr.h>
 #include <linux/kref.h>
 #include <linux/list.h>
 #include <linux/mm_types.h>
@@ -62,6 +63,7 @@ struct sgx_encl {
 
 	cpumask_t cpumask;
 	struct file *backing;
+	struct ida pcmd_in_backing;
 	struct kref refcount;
 	struct list_head va_pages;
 	unsigned long mm_list_version;
@@ -107,8 +109,10 @@ int sgx_encl_may_map(struct sgx_encl *encl, unsigned long start,
 void sgx_encl_release(struct kref *ref);
 int sgx_encl_mm_add(struct sgx_encl *encl, struct mm_struct *mm);
 const cpumask_t *sgx_encl_cpumask(struct sgx_encl *encl);
-int sgx_encl_get_backing(struct sgx_encl *encl, unsigned long page_index,
-			 struct sgx_backing *backing);
+int sgx_encl_alloc_backing(struct sgx_encl *encl, unsigned long page_index,
+			   struct sgx_backing *backing);
+int sgx_encl_lookup_backing(struct sgx_encl *encl, unsigned long page_index,
+			    struct sgx_backing *backing);
 void sgx_encl_put_backing(struct sgx_backing *backing, bool do_write);
 int sgx_encl_test_and_clear_young(struct mm_struct *mm,
 				  struct sgx_encl_page *page);
diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 1c2f40b72551..94d3817b40ff 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -82,6 +82,7 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
 	}
 
 	encl->backing = backing;
+	ida_init(&encl->pcmd_in_backing);
 
 	secs_epc = sgx_alloc_epc_page(&encl->secs, true);
 	if (IS_ERR(secs_epc)) {
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index ae79b8d6f645..148ec695b1b3 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -255,8 +255,8 @@ static void sgx_reclaimer_write(struct sgx_epc_page *epc_page,
 	sgx_encl_put_backing(backing, true);
 
 	if (!encl->secs_child_cnt && test_bit(SGX_ENCL_INITIALIZED, &encl->flags)) {
-		ret = sgx_encl_get_backing(encl, PFN_DOWN(encl->size),
-					   &secs_backing);
+		ret = sgx_encl_alloc_backing(encl, PFN_DOWN(encl->size),
+					     &secs_backing);
 		if (ret)
 			goto out;
 
@@ -326,7 +326,7 @@ static void sgx_reclaim_pages(void)
 		page_index = PFN_DOWN(encl_page->desc - encl_page->encl->base);
 
 		mutex_lock(&encl_page->encl->lock);
-		ret = sgx_encl_get_backing(encl_page->encl, page_index, &backing[i]);
+		ret = sgx_encl_alloc_backing(encl_page->encl, page_index, &backing[i]);
 		if (ret) {
 			mutex_unlock(&encl_page->encl->lock);
 			goto skip;
-- 
2.25.1

