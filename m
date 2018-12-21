Return-Path: <SRS0=Vmdy=O6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60289C43387
	for <linux-sgx@archiver.kernel.org>; Fri, 21 Dec 2018 23:15:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 190E92190A
	for <linux-sgx@archiver.kernel.org>; Fri, 21 Dec 2018 23:15:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730467AbeLUXPO (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 21 Dec 2018 18:15:14 -0500
Received: from mga06.intel.com ([134.134.136.31]:16600 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730803AbeLUXPO (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 21 Dec 2018 18:15:14 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Dec 2018 15:15:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,383,1539673200"; 
   d="scan'208";a="120338666"
Received: from ncanderx-mobl.ger.corp.intel.com (HELO localhost) ([10.249.254.238])
  by FMSMGA003.fm.intel.com with ESMTP; 21 Dec 2018 15:15:04 -0800
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     x86@kernel.org, linux-sgx@vger.kernel.org
Cc:     akpm@linux-foundation.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v18 20/25] x86/sgx: Add swapping code to the SGX driver
Date:   Sat, 22 Dec 2018 01:11:49 +0200
Message-Id: <20181221231154.6120-21-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181221231154.6120-1-jarkko.sakkinen@linux.intel.com>
References: <20181221231154.6120-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Because the kernel is untrusted, swapping pages in/out of the Enclave
Page Cache (EPC) has specialized requirements:

* The kernel cannot directly access EPC memory, i.e. cannot copy data
  to/from the EPC.
* To evict a page from the EPC, the kernel must "prove" to hardware that
  are no valid TLB entries for said page since a stale TLB entry would
  allow an attacker to bypass SGX access controls.
* When loading a page back into the EPC, hardware must be able to verify
  the integrity and freshness of the data.
* When loading an enclave page, e.g. regular pages and Thread Control
  Structures (TCS), hardware must be able to associate the page with a
  Secure Enclave Control Structure (SECS).

To satisfy the above requirements, the CPU provides dedicated ENCLS
functions to support paging data in/out of the EPC:

* EBLOCK:   Mark a page as blocked in the EPC Map (EPCM).  Attempting
            to access a blocked page that misses the TLB will fault.
* ETRACK:   Activate blocking tracking.  Hardware verifies that all
            translations for pages marked as "blocked" have been flushed
	    from the TLB.
* EPA:      Add version array page to the EPC.  As the name suggests, a
            VA page is an 512-entry array of version numbers that are
	    used to uniquely identify pages evicted from the EPC.
* EWB:      Write back a page from EPC to memory, e.g. RAM.  Software
            must supply a VA slot, memory to hold the a Paging Crypto
	    Metadata (PCMD) of the page and obviously backing for the
	    evicted page.
* ELD{B,U}: Load a page in {un}blocked state from memory to EPC.  The
            driver only uses the ELDU variant as there is no use case
	    for loading a page as "blocked" in a bare metal environment.

To top things off, all of the above ENCLS functions are subject to
strict concurrency rules, e.g. many operations will #GP fault if two
or more operations attempt to access common pages/structures.

To put it succinctly, paging in/out of the EPC requires coordinating
with the SGX driver where all of an enclave's tracking resides.  But,
simply shoving all reclaim logic into the driver is not desirable as
doing so has unwanted long term implications:

* Oversubscribing EPC to KVM guests, i.e. virtualizing SGX in KVM and
  swapping a guest's EPC pages (without the guest's cooperation) needs
  the same high level flows for reclaim but has painfully different
  semantics in the details.
* Accounting EPC, i.e. adding an EPC cgroup controller, is desirable
  as EPC is effectively a specialized memory type and even more scarce
  than system memory.  Providing a single touchpoint for EPC accounting
  regardless of end consumer greatly simplifies the EPC controller.
* Allowing the userspace-facing driver to be built as a loaded module
  is desirable, e.g. for debug, testing and development.  The cgroup
  infrastructure does not support dependencies on loadable modules.
* Separating EPC swapping from the driver once it has been tightly
  coupled to the driver is non-trivial (speaking from experience).

So, although the SGX driver is currently the sole consumer of EPC,
encapsulate EPC swapping in the driver to minimize the dependencies
between the core SGX code and driver, and do so in a way that can be
extended to an abstracted interface with minimal effort.

To that end, add functions to swap EPC pages to the driver.  The user
of these functions will be the core SGX subsystem, which will be enabled
in a future patch.

* sgx_encl_page_{get,put}() - Attempt to pin/unpin (the owner of) an EPC
  page so that it can be operated on by a reclaimer.
* sgx_encl_page_reclaim()   - Mark a page as being reclaimed. The
  page is considered reclaimable if it hasn't been accessed recently and
  it isn't reserved by the driver for other use.
* sgx_encl_page_block()     - EBLOCK an EPC page
* sgx_encl_page_write()     - Evict an EPC page to the regular memory via
  EWB.  Activates ETRACK (via sgx_encl_track()) if necessary.

Since we also need to be able to fault pages back into the EPC, add a
page fault handler to allocate an EPC page and ELDU a previously evicted
page.

Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Co-developed-by: Serge Ayoun <serge.ayoun@intel.com>
Signed-off-by: Serge Ayoun <serge.ayoun@intel.com>
Co-developed-by: Shay Katz-zamir <shay.katz-zamir@intel.com>
Signed-off-by: Shay Katz-zamir <shay.katz-zamir@intel.com>
---
 arch/x86/kernel/cpu/sgx/driver/Makefile    |   1 +
 arch/x86/kernel/cpu/sgx/driver/driver.h    |  23 +++
 arch/x86/kernel/cpu/sgx/driver/encl.c      | 138 +++++++++++++--
 arch/x86/kernel/cpu/sgx/driver/encl_page.c | 191 +++++++++++++++++++++
 arch/x86/kernel/cpu/sgx/driver/fault.c     | 170 ++++++++++++++++++
 arch/x86/kernel/cpu/sgx/driver/va.c        |  75 ++++++++
 arch/x86/kernel/cpu/sgx/driver/vma.c       |  15 ++
 7 files changed, 603 insertions(+), 10 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/sgx/driver/encl_page.c
 create mode 100644 arch/x86/kernel/cpu/sgx/driver/fault.c
 create mode 100644 arch/x86/kernel/cpu/sgx/driver/va.c

diff --git a/arch/x86/kernel/cpu/sgx/driver/Makefile b/arch/x86/kernel/cpu/sgx/driver/Makefile
index 0325de93d605..96c905649bec 100644
--- a/arch/x86/kernel/cpu/sgx/driver/Makefile
+++ b/arch/x86/kernel/cpu/sgx/driver/Makefile
@@ -1,2 +1,3 @@
 obj-$(CONFIG_INTEL_SGX) += sgx.o
 sgx-$(CONFIG_INTEL_SGX) += encl.o fs.o ioctl.o main.o pte.o vma.o
+sgx-$(CONFIG_INTEL_SGX) += encl_page.o fault.o va.o
diff --git a/arch/x86/kernel/cpu/sgx/driver/driver.h b/arch/x86/kernel/cpu/sgx/driver/driver.h
index e3487a077b6c..f8e52d1c8ccc 100644
--- a/arch/x86/kernel/cpu/sgx/driver/driver.h
+++ b/arch/x86/kernel/cpu/sgx/driver/driver.h
@@ -38,10 +38,23 @@
 #define SGX_EINIT_SLEEP_TIME	20
 #define SGX_VA_SLOT_COUNT	512
 
+#define SGX_VA_SLOT_COUNT 512
+
+struct sgx_va_page {
+	struct sgx_epc_page *epc_page;
+	DECLARE_BITMAP(slots, SGX_VA_SLOT_COUNT);
+	struct list_head list;
+};
+
 /**
  * enum sgx_encl_page_desc - defines bits for an enclave page's descriptor
  * %SGX_ENCL_PAGE_TCS:			The page is a TCS page.
  * %SGX_ENCL_PAGE_LOADED:		The page is not swapped.
+ * %SGX_ENCL_PAGE_RESERVED:		The page cannot be reclaimed.
+ * %SGX_ENCL_PAGE_RECLAIMED:		The page is in the process of being
+ *					reclaimed.
+ * %SGX_ENCL_PAGE_VA_OFFSET_MASK:	Holds the offset in the Version Array
+ *					(VA) page for a swapped page.
  * %SGX_ENCL_PAGE_ADDR_MASK:		Holds the virtual address of the page.
  *
  * The page address for SECS is zero and is used by the subsystem to recognize
@@ -51,6 +64,9 @@ enum sgx_encl_page_desc {
 	SGX_ENCL_PAGE_TCS		= BIT(0),
 	SGX_ENCL_PAGE_LOADED		= BIT(1),
 	/* Bits 11:3 are available when the page is not swapped. */
+	SGX_ENCL_PAGE_RESERVED		= BIT(3),
+	SGX_ENCL_PAGE_RECLAIMED		= BIT(4),
+	SGX_ENCL_PAGE_VA_OFFSET_MASK	= GENMASK_ULL(11, 3),
 	SGX_ENCL_PAGE_ADDR_MASK		= PAGE_MASK,
 };
 
@@ -89,6 +105,7 @@ struct sgx_encl {
 	unsigned long base;
 	unsigned long size;
 	unsigned long ssaframesize;
+	struct list_head va_pages;
 	struct radix_tree_root page_tree;
 	struct list_head add_page_reqs;
 	struct work_struct work;
@@ -152,6 +169,8 @@ int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct *sigstruct,
 		  struct sgx_einittoken *einittoken);
 void sgx_encl_block(struct sgx_encl_page *encl_page);
 void sgx_encl_track(struct sgx_encl *encl);
+int sgx_encl_load_page(struct sgx_encl_page *encl_page,
+		       struct sgx_epc_page *epc_page);
 void sgx_encl_release(struct kref *ref);
 pgoff_t sgx_encl_get_index(struct sgx_encl *encl, struct sgx_encl_page *page);
 
@@ -166,6 +185,10 @@ struct sgx_encl_page *sgx_fault_page(struct vm_area_struct *vma,
 
 int sgx_test_and_clear_young(struct sgx_encl_page *page);
 void sgx_flush_cpus(struct sgx_encl *encl);
+struct sgx_epc_page *sgx_alloc_va_page(void);
+unsigned int sgx_alloc_va_slot(struct sgx_va_page *va_page);
+void sgx_free_va_slot(struct sgx_va_page *va_page, unsigned int offset);
+bool sgx_va_page_full(struct sgx_va_page *va_page);
 
 extern const struct file_operations sgx_fs_provision_fops;
 
diff --git a/arch/x86/kernel/cpu/sgx/driver/encl.c b/arch/x86/kernel/cpu/sgx/driver/encl.c
index 0ea85c77d437..4ae7674e9c8c 100644
--- a/arch/x86/kernel/cpu/sgx/driver/encl.c
+++ b/arch/x86/kernel/cpu/sgx/driver/encl.c
@@ -53,6 +53,19 @@ int sgx_encl_find(struct mm_struct *mm, unsigned long addr,
 	return encl ? 0 : -ENOENT;
 }
 
+static void sgx_free_va_pages(struct sgx_encl *encl)
+{
+	struct sgx_va_page *va_page;
+
+	while (!list_empty(&encl->va_pages)) {
+		va_page = list_first_entry(&encl->va_pages, struct sgx_va_page,
+					   list);
+		list_del(&va_page->list);
+		sgx_free_page(va_page->epc_page);
+		kfree(va_page);
+	}
+}
+
 /**
  * sgx_invalidate - kill an enclave
  * @encl:	an &sgx_encl instance
@@ -87,7 +100,12 @@ void sgx_invalidate(struct sgx_encl *encl, bool flush_cpus)
 
 	radix_tree_for_each_slot(slot, &encl->page_tree, &iter, 0) {
 		entry = *slot;
-		if (entry->desc & SGX_ENCL_PAGE_LOADED) {
+		/*
+		 * If the page has RECLAIMED set, the reclaimer effectively
+		 * owns the page, i.e. we need to let the reclaimer free it.
+		 */
+		if ((entry->desc & SGX_ENCL_PAGE_LOADED) &&
+		    !(entry->desc & SGX_ENCL_PAGE_RECLAIMED)) {
 			if (!__sgx_free_page(entry->epc_page)) {
 				encl->secs_child_cnt--;
 				entry->desc &= ~SGX_ENCL_PAGE_LOADED;
@@ -100,6 +118,7 @@ void sgx_invalidate(struct sgx_encl *encl, bool flush_cpus)
 		encl->secs.desc &= ~SGX_ENCL_PAGE_LOADED;
 		sgx_free_page(encl->secs.epc_page);
 	}
+	sgx_free_va_pages(encl);
 }
 
 static bool sgx_process_add_page_req(struct sgx_add_page_req *req,
@@ -299,6 +318,51 @@ static const struct mmu_notifier_ops sgx_mmu_notifier_ops = {
 	.release	= sgx_mmu_notifier_release,
 };
 
+static int sgx_encl_grow(struct sgx_encl *encl)
+{
+	struct sgx_va_page *va_page;
+	int ret;
+
+	BUILD_BUG_ON(SGX_VA_SLOT_COUNT !=
+		(SGX_ENCL_PAGE_VA_OFFSET_MASK >> 3) + 1);
+
+	mutex_lock(&encl->lock);
+	if (encl->flags & SGX_ENCL_DEAD) {
+		mutex_unlock(&encl->lock);
+		return -EFAULT;
+	}
+
+	if (!(encl->page_cnt % SGX_VA_SLOT_COUNT)) {
+		mutex_unlock(&encl->lock);
+
+		va_page = kzalloc(sizeof(*va_page), GFP_KERNEL);
+		if (!va_page)
+			return -ENOMEM;
+		va_page->epc_page = sgx_alloc_va_page();
+		if (IS_ERR(va_page->epc_page)) {
+			ret = PTR_ERR(va_page->epc_page);
+			kfree(va_page);
+			return ret;
+		}
+
+		mutex_lock(&encl->lock);
+		if (encl->flags & SGX_ENCL_DEAD) {
+			sgx_free_page(va_page->epc_page);
+			kfree(va_page);
+			mutex_unlock(&encl->lock);
+			return -EFAULT;
+		} else if (encl->page_cnt % SGX_VA_SLOT_COUNT) {
+			sgx_free_page(va_page->epc_page);
+			kfree(va_page);
+		} else {
+			list_add(&va_page->list, &encl->va_pages);
+		}
+	}
+	encl->page_cnt++;
+	mutex_unlock(&encl->lock);
+	return 0;
+}
+
 /**
  * sgx_encl_alloc - allocate memory for an enclave and set attributes
  *
@@ -314,6 +378,7 @@ static const struct mmu_notifier_ops sgx_mmu_notifier_ops = {
  */
 struct sgx_encl *sgx_encl_alloc(struct sgx_secs *secs)
 {
+	unsigned long backing_size = secs->size + PAGE_SIZE;
 	unsigned long ssaframesize;
 	struct sgx_encl *encl;
 	unsigned long backing;
@@ -323,23 +388,24 @@ struct sgx_encl *sgx_encl_alloc(struct sgx_secs *secs)
 	if (sgx_validate_secs(secs, ssaframesize))
 		return ERR_PTR(-EINVAL);
 
-	backing = vm_mmap(NULL, 0, secs->size + PAGE_SIZE,
+	backing = vm_mmap(NULL, 0, backing_size + (backing_size >> 5),
 			  PROT_READ | PROT_WRITE, MAP_PRIVATE, 0);
 	if (IS_ERR((void *)backing)) {
 		ret = PTR_ERR((void *)backing);
-		goto out_err;
+		goto err_backing;
 	}
 
 	encl = kzalloc(sizeof(*encl), GFP_KERNEL);
 	if (!encl) {
 		ret = -ENOMEM;
-		goto out_backing;
+		goto err_alloc;
 	}
 
 	encl->attributes = SGX_ATTR_MODE64BIT | SGX_ATTR_DEBUG;
 	encl->xfrm = secs->xfrm;
 	kref_init(&encl->refcount);
 	INIT_LIST_HEAD(&encl->add_page_reqs);
+	INIT_LIST_HEAD(&encl->va_pages);
 	INIT_RADIX_TREE(&encl->page_tree, GFP_KERNEL);
 	mutex_init(&encl->lock);
 	INIT_WORK(&encl->work, sgx_add_page_worker);
@@ -351,10 +417,10 @@ struct sgx_encl *sgx_encl_alloc(struct sgx_secs *secs)
 
 	return encl;
 
-out_backing:
-	vm_munmap((unsigned long)backing, secs->size + PAGE_SIZE);
+err_alloc:
+	vm_munmap((unsigned long)backing, backing_size + (backing_size >> 5));
 
-out_err:
+err_backing:
 	return ERR_PTR(ret);
 }
 
@@ -406,6 +472,10 @@ int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
 	encl->secs.desc |= SGX_ENCL_PAGE_LOADED;
 	encl->tgid = get_pid(task_tgid(current));
 
+	ret = sgx_encl_grow(encl);
+	if (ret)
+		return ret;
+
 	pginfo.addr = 0;
 	pginfo.contents = (unsigned long)secs;
 	pginfo.metadata = (unsigned long)&secinfo;
@@ -626,6 +696,10 @@ int sgx_encl_add_page(struct sgx_encl *encl, unsigned long addr, void *data,
 			return ret;
 	}
 
+	ret = sgx_encl_grow(encl);
+	if (ret)
+		return ret;
+
 	down_read(&current->mm->mmap_sem);
 	mutex_lock(&encl->lock);
 
@@ -753,15 +827,59 @@ int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct *sigstruct,
 	return ret;
 }
 
+/**
+ * sgx_encl_block - block an enclave page
+ * @encl_page:	an enclave page
+ *
+ * Changes the state of the associated EPC page to blocked.
+ */
+void sgx_encl_block(struct sgx_encl_page *encl_page)
+{
+	unsigned long addr = SGX_ENCL_PAGE_ADDR(encl_page);
+	struct sgx_encl *encl = encl_page->encl;
+	struct vm_area_struct *vma;
+	int ret;
+
+	if (encl->flags & SGX_ENCL_DEAD)
+		return;
+
+	ret = sgx_encl_find(encl->mm, addr, &vma);
+	if (!ret && encl == vma->vm_private_data)
+		zap_vma_ptes(vma, addr, PAGE_SIZE);
+
+	ret = __eblock(sgx_epc_addr(encl_page->epc_page));
+	SGX_INVD(ret, encl, "EBLOCK returned %d (0x%x)", ret, ret);
+}
+
+/**
+ * sgx_encl_track - start tracking pages in the blocked state
+ * @encl:	an enclave
+ *
+ * Start blocking accesses for pages in the blocked state for threads that enter
+ * inside the enclave by executing the ETRACK leaf instruction. This starts a
+ * shootdown sequence for threads that entered before ETRACK.
+ *
+ * The caller must take care (with an IPI when necessary) to make sure that the
+ * previous shootdown sequence was completed before calling this function.  If
+ * this is not the case, the callee prints a critical error to the klog and
+ * kills the enclave.
+ */
+void sgx_encl_track(struct sgx_encl *encl)
+{
+	int ret = __etrack(sgx_epc_addr(encl->secs.epc_page));
+
+	SGX_INVD(ret, encl, "ETRACK returned %d (0x%x)", ret, ret);
+}
+
 static void sgx_encl_release_worker(struct work_struct *work)
 {
 	struct sgx_encl *encl = container_of(work, struct sgx_encl, work);
 	unsigned long backing_size = encl->size + PAGE_SIZE;
 
-	if (encl->flags & SGX_ENCL_MM_RELEASED) {
+	if (!(encl->flags & SGX_ENCL_MM_RELEASED)) {
 		down_write(&encl->mm->mmap_sem);
-		do_munmap(encl->mm, (unsigned long)encl->backing, backing_size,
-			  NULL);
+		do_munmap(encl->mm, (unsigned long)encl->backing, backing_size +
+			  (backing_size >> 5), NULL);
 		up_write(&encl->mm->mmap_sem);
 	}
 
diff --git a/arch/x86/kernel/cpu/sgx/driver/encl_page.c b/arch/x86/kernel/cpu/sgx/driver/encl_page.c
new file mode 100644
index 000000000000..1bd27444a1f9
--- /dev/null
+++ b/arch/x86/kernel/cpu/sgx/driver/encl_page.c
@@ -0,0 +1,191 @@
+// SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
+// Copyright(c) 2016-18 Intel Corporation.
+
+#include <linux/device.h>
+#include <linux/freezer.h>
+#include <linux/highmem.h>
+#include <linux/kthread.h>
+#include <linux/ratelimit.h>
+#include <linux/sched/signal.h>
+#include <linux/slab.h>
+#include "driver.h"
+
+static inline struct sgx_encl_page *to_encl_page(struct sgx_epc_page *epc_page)
+{
+	WARN_ON_ONCE(1);
+	return NULL;
+}
+
+bool sgx_encl_page_get(struct sgx_epc_page *epc_page)
+{
+	struct sgx_encl_page *encl_page = to_encl_page(epc_page);
+	struct sgx_encl *encl = encl_page->encl;
+
+	return kref_get_unless_zero(&encl->refcount) != 0;
+}
+
+void sgx_encl_page_put(struct sgx_epc_page *epc_page)
+{
+	struct sgx_encl_page *encl_page = to_encl_page(epc_page);
+	struct sgx_encl *encl = encl_page->encl;
+
+	kref_put(&encl->refcount, sgx_encl_release);
+}
+
+bool sgx_encl_page_reclaim(struct sgx_epc_page *epc_page)
+{
+	struct sgx_encl_page *encl_page = to_encl_page(epc_page);
+	struct sgx_encl *encl = encl_page->encl;
+	bool ret;
+
+	down_read(&encl->mm->mmap_sem);
+	mutex_lock(&encl->lock);
+
+	if (encl->flags & SGX_ENCL_DEAD)
+		ret = true;
+	else if (encl_page->desc & SGX_ENCL_PAGE_RESERVED)
+		ret = false;
+	else
+		ret = !sgx_test_and_clear_young(encl_page);
+	if (ret)
+		encl_page->desc |= SGX_ENCL_PAGE_RECLAIMED;
+
+	mutex_unlock(&encl->lock);
+	up_read(&encl->mm->mmap_sem);
+
+	return ret;
+}
+
+void sgx_encl_page_block(struct sgx_epc_page *epc_page)
+{
+	struct sgx_encl_page *encl_page = to_encl_page(epc_page);
+	struct sgx_encl *encl = encl_page->encl;
+
+	down_read(&encl->mm->mmap_sem);
+	mutex_lock(&encl->lock);
+	sgx_encl_block(encl_page);
+	mutex_unlock(&encl->lock);
+	up_read(&encl->mm->mmap_sem);
+}
+
+static int sgx_ewb(struct sgx_encl *encl, struct sgx_epc_page *epc_page,
+		   struct sgx_va_page *va_page, unsigned int va_offset)
+{
+	struct sgx_encl_page *encl_page = to_encl_page(epc_page);
+	pgoff_t page_index = sgx_encl_get_index(encl, encl_page);
+	unsigned long pcmd_offset =
+		(page_index & (PAGE_SIZE / sizeof(struct sgx_pcmd) - 1)) *
+		sizeof(struct sgx_pcmd);
+	unsigned long page_addr = encl->backing + page_index * PAGE_SIZE;
+	unsigned long pcmd_addr = encl->backing + encl->size + PAGE_SIZE +
+				  ((page_index * PAGE_SIZE) >> 5);
+	struct sgx_pageinfo pginfo;
+	struct page *backing;
+	struct page *pcmd;
+	int ret;
+
+	ret = get_user_pages_remote(NULL, encl->mm, page_addr, 1, FOLL_WRITE,
+				    &backing, NULL, NULL);
+	if (ret < 0)
+		goto err_backing;
+
+	ret = get_user_pages_remote(NULL, encl->mm, pcmd_addr, 1, FOLL_WRITE,
+				    &pcmd, NULL, NULL);
+	if (ret < 0)
+		goto err_pcmd;
+
+	pginfo.addr = 0;
+	pginfo.contents = (unsigned long)kmap_atomic(backing);
+	pginfo.metadata = (unsigned long)kmap_atomic(pcmd) + pcmd_offset;
+	pginfo.secs = 0;
+	ret = __ewb(&pginfo, sgx_epc_addr(epc_page),
+		    sgx_epc_addr(va_page->epc_page) + va_offset);
+	kunmap_atomic((void *)(unsigned long)(pginfo.metadata - pcmd_offset));
+	kunmap_atomic((void *)(unsigned long)pginfo.contents);
+
+	set_page_dirty(pcmd);
+	put_page(pcmd);
+	set_page_dirty(backing);
+
+err_pcmd:
+	put_page(backing);
+
+err_backing:
+	return ret;
+}
+
+/**
+ * sgx_write_page - write a page to the regular memory
+ *
+ * Writes an EPC page to the shmem file associated with the enclave. Flushes
+ * CPUs and retries if there are hardware threads that can potentially have TLB
+ * entries to the page (indicated by SGX_NOT_TRACKED). Clears the reserved flag
+ * after the page is swapped.
+ *
+ * @epc_page:	an EPC page
+ */
+static void sgx_write_page(struct sgx_epc_page *epc_page, bool do_free)
+{
+	struct sgx_encl_page *encl_page = to_encl_page(epc_page);
+	struct sgx_encl *encl = encl_page->encl;
+	struct sgx_va_page *va_page;
+	unsigned int va_offset;
+	int ret;
+
+	encl_page->desc &= ~(SGX_ENCL_PAGE_LOADED | SGX_ENCL_PAGE_RECLAIMED);
+
+	if (!(encl->flags & SGX_ENCL_DEAD)) {
+		va_page = list_first_entry(&encl->va_pages, struct sgx_va_page,
+					   list);
+		va_offset = sgx_alloc_va_slot(va_page);
+		if (sgx_va_page_full(va_page))
+			list_move_tail(&va_page->list, &encl->va_pages);
+
+		ret = sgx_ewb(encl, epc_page, va_page, va_offset);
+		if (ret == SGX_NOT_TRACKED) {
+			sgx_encl_track(encl);
+			ret = sgx_ewb(encl, epc_page, va_page, va_offset);
+			if (ret == SGX_NOT_TRACKED) {
+				/* slow path, IPI needed */
+				sgx_flush_cpus(encl);
+				ret = sgx_ewb(encl, epc_page, va_page,
+					      va_offset);
+			}
+		}
+
+		/* Invalidate silently as the backing VMA has been kicked out.
+		 */
+		if (ret < 0)
+			sgx_invalidate(encl, true);
+		else
+			SGX_INVD(ret, encl, "EWB returned %d (0x%x)",
+				 ret, ret);
+
+		encl_page->desc |= va_offset;
+		encl_page->va_page = va_page;
+	} else if (!do_free) {
+		ret = __eremove(sgx_epc_addr(epc_page));
+		WARN(ret, "EREMOVE returned %d\n", ret);
+	}
+
+	if (do_free)
+		sgx_free_page(epc_page);
+}
+
+void sgx_encl_page_write(struct sgx_epc_page *epc_page)
+{
+	struct sgx_encl_page *encl_page = to_encl_page(epc_page);
+	struct sgx_encl *encl = encl_page->encl;
+
+	down_read(&encl->mm->mmap_sem);
+	mutex_lock(&encl->lock);
+
+	sgx_write_page(epc_page, false);
+	encl->secs_child_cnt--;
+	if (!encl->secs_child_cnt &&
+	    (encl->flags & (SGX_ENCL_DEAD | SGX_ENCL_INITIALIZED)))
+		sgx_write_page(encl->secs.epc_page, true);
+
+	mutex_unlock(&encl->lock);
+	up_read(&encl->mm->mmap_sem);
+}
diff --git a/arch/x86/kernel/cpu/sgx/driver/fault.c b/arch/x86/kernel/cpu/sgx/driver/fault.c
new file mode 100644
index 000000000000..b30c4b837f0f
--- /dev/null
+++ b/arch/x86/kernel/cpu/sgx/driver/fault.c
@@ -0,0 +1,170 @@
+// SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
+// Copyright(c) 2016-18 Intel Corporation.
+
+#include <linux/highmem.h>
+#include <linux/sched/mm.h>
+#include "driver.h"
+
+static int sgx_eldu(struct sgx_encl_page *encl_page,
+		    struct sgx_epc_page *epc_page)
+{
+	unsigned long addr = SGX_ENCL_PAGE_ADDR(encl_page);
+	unsigned long va_offset = SGX_ENCL_PAGE_VA_OFFSET(encl_page);
+	struct sgx_encl *encl = encl_page->encl;
+	pgoff_t page_index = sgx_encl_get_index(encl, encl_page);
+	unsigned long pcmd_offset =
+		(page_index & (PAGE_SIZE / sizeof(struct sgx_pcmd) - 1)) *
+		sizeof(struct sgx_pcmd);
+	unsigned long page_addr = encl->backing + page_index * PAGE_SIZE;
+	unsigned long pcmd_addr = encl->backing + encl->size + PAGE_SIZE +
+				  ((page_index * PAGE_SIZE) >> 5);
+	struct sgx_pageinfo pginfo;
+	struct page *backing;
+	struct page *pcmd;
+	int ret;
+
+	ret = get_user_pages_remote(NULL, encl->mm, page_addr, 1, 0, &backing,
+				    NULL, NULL);
+	if (ret < 0)
+		goto err_backing;
+
+	ret = get_user_pages_remote(NULL, encl->mm, pcmd_addr, 1, 0, &pcmd,
+				    NULL, NULL);
+	if (ret < 0)
+		goto err_pcmd;
+
+	pginfo.addr = addr;
+	pginfo.contents = (unsigned long)kmap_atomic(backing);
+	pginfo.metadata = (unsigned long)kmap_atomic(pcmd) + pcmd_offset;
+	pginfo.secs = addr ? (unsigned long)sgx_epc_addr(encl->secs.epc_page) :
+		      0;
+
+	ret = __eldu(&pginfo, sgx_epc_addr(epc_page),
+		     sgx_epc_addr(encl_page->va_page->epc_page) + va_offset);
+	if (ret) {
+		SGX_INVD(ret, encl, "ELDU returned %d (0x%x)", ret, ret);
+		ret = encls_to_err(ret);
+	}
+
+	kunmap_atomic((void *)(unsigned long)(pginfo.metadata - pcmd_offset));
+	kunmap_atomic((void *)(unsigned long)pginfo.contents);
+
+	put_page(pcmd);
+
+err_pcmd:
+	put_page(backing);
+
+err_backing:
+	/* Invalidate silently as the backing VMA has been kicked out. */
+	if (ret < 0) {
+		sgx_invalidate(encl, true);
+		return 0;
+	}
+
+	return ret;
+}
+
+static struct sgx_epc_page *sgx_load_page(struct sgx_encl_page *encl_page)
+{
+	unsigned long va_offset = SGX_ENCL_PAGE_VA_OFFSET(encl_page);
+	struct sgx_encl *encl = encl_page->encl;
+	struct sgx_epc_page *epc_page;
+	int ret;
+
+	epc_page = sgx_alloc_page();
+	if (IS_ERR(epc_page))
+		return epc_page;
+
+	ret = sgx_eldu(encl_page, epc_page);
+	if (ret) {
+		sgx_free_page(epc_page);
+		return ERR_PTR(ret);
+	}
+
+	sgx_free_va_slot(encl_page->va_page, va_offset);
+	list_move(&encl_page->va_page->list, &encl->va_pages);
+	encl_page->desc &= ~SGX_ENCL_PAGE_VA_OFFSET_MASK;
+	encl_page->epc_page = epc_page;
+	encl_page->desc |= SGX_ENCL_PAGE_LOADED;
+
+	return epc_page;
+}
+
+static struct sgx_encl_page *sgx_try_fault_page(struct vm_area_struct *vma,
+						unsigned long addr,
+						bool do_reserve)
+{
+	struct sgx_encl *encl = vma->vm_private_data;
+	struct sgx_epc_page *epc_page;
+	struct sgx_encl_page *entry;
+	int rc = 0;
+
+	if ((encl->flags & SGX_ENCL_DEAD) ||
+	    !(encl->flags & SGX_ENCL_INITIALIZED))
+		return ERR_PTR(-EFAULT);
+
+	entry = radix_tree_lookup(&encl->page_tree, addr >> PAGE_SHIFT);
+	if (!entry)
+		return ERR_PTR(-EFAULT);
+
+	/* Page is already resident in the EPC. */
+	if (entry->desc & SGX_ENCL_PAGE_LOADED) {
+		if (entry->desc & SGX_ENCL_PAGE_RESERVED) {
+			sgx_dbg(encl, "EPC page 0x%p is already reserved\n",
+				(void *)SGX_ENCL_PAGE_ADDR(entry));
+			return ERR_PTR(-EBUSY);
+		}
+		if (entry->desc & SGX_ENCL_PAGE_RECLAIMED) {
+			sgx_dbg(encl, "EPC page 0x%p is being reclaimed\n",
+				(void *)SGX_ENCL_PAGE_ADDR(entry));
+			return ERR_PTR(-EBUSY);
+		}
+		if (do_reserve)
+			entry->desc |= SGX_ENCL_PAGE_RESERVED;
+		return entry;
+	}
+
+	if (!(encl->secs.desc & SGX_ENCL_PAGE_LOADED)) {
+		epc_page = sgx_load_page(&encl->secs);
+		if (IS_ERR(epc_page))
+			return ERR_CAST(epc_page);
+	}
+	epc_page = sgx_load_page(entry);
+	if (IS_ERR(epc_page))
+		return ERR_CAST(epc_page);
+
+	encl->secs_child_cnt++;
+	sgx_test_and_clear_young(entry);
+	if (do_reserve)
+		entry->desc |= SGX_ENCL_PAGE_RESERVED;
+
+	rc = vmf_insert_pfn(vma, addr, PFN_DOWN(entry->epc_page->desc));
+	if (rc != VM_FAULT_NOPAGE) {
+		sgx_invalidate(encl, true);
+		return ERR_PTR(-EFAULT);
+	}
+
+	return entry;
+}
+
+struct sgx_encl_page *sgx_fault_page(struct vm_area_struct *vma,
+				     unsigned long addr, bool do_reserve)
+{
+	struct sgx_encl *encl = vma->vm_private_data;
+	struct sgx_encl_page *entry;
+
+	/* If process was forked, VMA is still there but vm_private_data is set
+	 * to NULL.
+	 */
+	if (!encl)
+		return ERR_PTR(-EFAULT);
+	do {
+		mutex_lock(&encl->lock);
+		entry = sgx_try_fault_page(vma, addr, do_reserve);
+		mutex_unlock(&encl->lock);
+		if (!do_reserve)
+			break;
+	} while (PTR_ERR(entry) == -EBUSY);
+
+	return entry;
+}
diff --git a/arch/x86/kernel/cpu/sgx/driver/va.c b/arch/x86/kernel/cpu/sgx/driver/va.c
new file mode 100644
index 000000000000..f57aacefb6eb
--- /dev/null
+++ b/arch/x86/kernel/cpu/sgx/driver/va.c
@@ -0,0 +1,75 @@
+// SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
+// Copyright(c) 2016-18 Intel Corporation.
+
+#include "driver.h"
+
+/**
+ * sgx_alloc_page - allocate a VA page
+ *
+ * Allocates an &sgx_epc_page instance and converts it to a VA page.
+ *
+ * Return:
+ *   a &struct sgx_va_page instance,
+ *   -errno otherwise
+ */
+struct sgx_epc_page *sgx_alloc_va_page(void)
+{
+	struct sgx_epc_page *epc_page;
+	int ret;
+
+	epc_page = sgx_alloc_page();
+	if (IS_ERR(epc_page))
+		return ERR_CAST(epc_page);
+
+	ret = __epa(sgx_epc_addr(epc_page));
+	if (ret) {
+		WARN_ONCE(1, "sgx: EPA returned %d (0x%x)", ret, ret);
+		sgx_free_page(epc_page);
+		return ERR_PTR(encls_to_err(ret));
+	}
+
+	return epc_page;
+}
+
+/**
+ * sgx_alloc_va_slot - allocate a VA slot
+ * @va_page:	a &struct sgx_va_page instance
+ *
+ * Allocates a slot from a &struct sgx_va_page instance.
+ *
+ * Return: offset of the slot inside the VA page
+ */
+unsigned int sgx_alloc_va_slot(struct sgx_va_page *va_page)
+{
+	int slot = find_first_zero_bit(va_page->slots, SGX_VA_SLOT_COUNT);
+
+	if (slot < SGX_VA_SLOT_COUNT)
+		set_bit(slot, va_page->slots);
+
+	return slot << 3;
+}
+
+/**
+ * sgx_free_va_slot - free a VA slot
+ * @va_page:	a &struct sgx_va_page instance
+ * @offset:	offset of the slot inside the VA page
+ *
+ * Frees a slot from a &struct sgx_va_page instance.
+ */
+void sgx_free_va_slot(struct sgx_va_page *va_page, unsigned int offset)
+{
+	clear_bit(offset >> 3, va_page->slots);
+}
+
+/**
+ * sgx_va_page_full - is the VA page full?
+ * @va_page:	a &struct sgx_va_page instance
+ *
+ * Return: true if all slots have been taken
+ */
+bool sgx_va_page_full(struct sgx_va_page *va_page)
+{
+	int slot = find_first_zero_bit(va_page->slots, SGX_VA_SLOT_COUNT);
+
+	return slot == SGX_VA_SLOT_COUNT;
+}
diff --git a/arch/x86/kernel/cpu/sgx/driver/vma.c b/arch/x86/kernel/cpu/sgx/driver/vma.c
index e62e45e68c90..da7b4080a4a6 100644
--- a/arch/x86/kernel/cpu/sgx/driver/vma.c
+++ b/arch/x86/kernel/cpu/sgx/driver/vma.c
@@ -37,7 +37,22 @@ static void sgx_vma_close(struct vm_area_struct *vma)
 	kref_put(&encl->refcount, sgx_encl_release);
 }
 
+static int sgx_vma_fault(struct vm_fault *vmf)
+{
+	unsigned long addr = (unsigned long)vmf->address;
+	struct vm_area_struct *vma = vmf->vma;
+	struct sgx_encl_page *entry;
+
+	entry = sgx_fault_page(vma, addr, 0);
+
+	if (!IS_ERR(entry) || PTR_ERR(entry) == -EBUSY)
+		return VM_FAULT_NOPAGE;
+	else
+		return VM_FAULT_SIGBUS;
+}
+
 const struct vm_operations_struct sgx_vm_ops = {
 	.close = sgx_vma_close,
 	.open = sgx_vma_open,
+	.fault = sgx_vma_fault,
 };
-- 
2.19.1

