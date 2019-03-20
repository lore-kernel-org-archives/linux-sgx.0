Return-Path: <SRS0=REdw=RX=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 974C9C43381
	for <linux-sgx@archiver.kernel.org>; Wed, 20 Mar 2019 16:25:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50DC32146E
	for <linux-sgx@archiver.kernel.org>; Wed, 20 Mar 2019 16:25:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727202AbfCTQZJ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 20 Mar 2019 12:25:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:31869 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726860AbfCTQZI (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 20 Mar 2019 12:25:08 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Mar 2019 09:25:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,249,1549958400"; 
   d="scan'208";a="135715572"
Received: from sorenthe-mobl1.ger.corp.intel.com (HELO localhost) ([10.249.254.203])
  by orsmga003.jf.intel.com with ESMTP; 20 Mar 2019 09:24:50 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     akpm@linux-foundation.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v19,RESEND 18/27] x86/sgx: Add swapping code to the core and SGX driver
Date:   Wed, 20 Mar 2019 18:21:10 +0200
Message-Id: <20190320162119.4469-19-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190320162119.4469-1-jarkko.sakkinen@linux.intel.com>
References: <20190320162119.4469-1-jarkko.sakkinen@linux.intel.com>
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

Wire up the EPC manager's reclaim flow to the SGX driver's swapping
functionality.  In the long term there will be multiple users of the
EPC manager, e.g. SGX driver and KVM, thus the interface between the
EPC manager and the driver is fairly genericized and decoupled.  But
to avoid adding unusued infrastructure, do not add any indirection
between the EPC manager and the SGX driver.  This has the unfortunate
and odd side effect of preventing the SGX driver from being compiled
as a loadable module.  However, this should be a temporary situation
that is remedied when a second user of EPC is added, i.e. KVM.

The swapper thread ksgxswapd reclaims pages on the event when the number
of free EPC pages goes below %SGX_NR_LOW_PAGES up until it reaches
%SGX_NR_HIGH_PAGES.

Pages are reclaimed in LRU fashion from a global list. The consumers
take care of calling EBLOCK (block page from new accesses), ETRACK
(restart counting the entering hardware threads) and EWB (write page to
the regular memory) because executing these operations usually (if not
always) requires to do some subsystem-internal locking operations.

Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Co-developed-by: Serge Ayoun <serge.ayoun@intel.com>
Signed-off-by: Serge Ayoun <serge.ayoun@intel.com>
Co-developed-by: Shay Katz-zamir <shay.katz-zamir@intel.com>
Signed-off-by: Shay Katz-zamir <shay.katz-zamir@intel.com>
---
 arch/x86/Kconfig                       |   3 +
 arch/x86/kernel/cpu/sgx/Makefile       |   1 +
 arch/x86/kernel/cpu/sgx/driver/ioctl.c |  59 +++-
 arch/x86/kernel/cpu/sgx/encl.c         | 267 +++++++++++++++-
 arch/x86/kernel/cpu/sgx/encl.h         |  38 +++
 arch/x86/kernel/cpu/sgx/main.c         |  96 +++++-
 arch/x86/kernel/cpu/sgx/reclaim.c      | 410 +++++++++++++++++++++++++
 arch/x86/kernel/cpu/sgx/sgx.h          |  34 +-
 8 files changed, 887 insertions(+), 21 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/sgx/reclaim.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 34257b5659cc..424bd58fd299 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1953,6 +1953,9 @@ config INTEL_SGX_DRIVER
 	specifying the public key hash for the launch enclave are writable so
 	that Linux has the full control to run enclaves.
 
+	If the driver is enabled, the page reclaimer in the core will be
+	enabled. It reclaims pages in LRU fashion from enclaves.
+
 	For details, see Documentation/x86/intel_sgx.rst
 
 config EFI
diff --git a/arch/x86/kernel/cpu/sgx/Makefile b/arch/x86/kernel/cpu/sgx/Makefile
index 48174e5fc181..d261693aa11d 100644
--- a/arch/x86/kernel/cpu/sgx/Makefile
+++ b/arch/x86/kernel/cpu/sgx/Makefile
@@ -1,4 +1,5 @@
 obj-y += encl.o
 obj-y += encls.o
 obj-y += main.o
+obj-y += reclaim.o
 obj-$(CONFIG_INTEL_SGX_DRIVER) += driver/
diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
index 5d85bd3f7876..23ef9ae08a65 100644
--- a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
@@ -46,6 +46,51 @@ static int sgx_encl_get(unsigned long addr, struct sgx_encl **encl)
 	return ret;
 }
 
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
 static bool sgx_process_add_page_req(struct sgx_add_page_req *req,
 				     struct sgx_epc_page *epc_page)
 {
@@ -104,6 +149,7 @@ static bool sgx_process_add_page_req(struct sgx_add_page_req *req,
 	encl_page->encl = encl;
 	encl_page->epc_page = epc_page;
 	encl->secs_child_cnt++;
+	sgx_mark_page_reclaimable(encl_page->epc_page);
 
 	return true;
 }
@@ -134,7 +180,7 @@ static void sgx_add_page_worker(struct work_struct *work)
 		if (skip_rest)
 			goto next;
 
-		epc_page = sgx_alloc_page();
+		epc_page = sgx_alloc_page(req->encl_page, true);
 
 		mutex_lock(&encl->lock);
 
@@ -247,6 +293,7 @@ static struct sgx_encl *sgx_encl_alloc(struct sgx_secs *secs)
 	encl->allowed_attributes = SGX_ATTR_ALLOWED_MASK;
 	kref_init(&encl->refcount);
 	INIT_LIST_HEAD(&encl->add_page_reqs);
+	INIT_LIST_HEAD(&encl->va_pages);
 	INIT_RADIX_TREE(&encl->page_tree, GFP_KERNEL);
 	mutex_init(&encl->lock);
 	INIT_WORK(&encl->work, sgx_add_page_worker);
@@ -310,7 +357,7 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
 	struct sgx_epc_page *secs_epc;
 	long ret;
 
-	secs_epc = sgx_alloc_page();
+	secs_epc = sgx_alloc_page(&encl->secs, true);
 	if (IS_ERR(secs_epc)) {
 		ret = PTR_ERR(secs_epc);
 		return ret;
@@ -319,6 +366,10 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
 	encl->secs.encl = encl;
 	encl->secs.epc_page = secs_epc;
 
+	ret = sgx_encl_grow(encl);
+	if (ret)
+		return ret;
+
 	pginfo.addr = 0;
 	pginfo.contents = (unsigned long)secs;
 	pginfo.metadata = (unsigned long)&secinfo;
@@ -531,6 +582,10 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long addr,
 			return ret;
 	}
 
+	ret = sgx_encl_grow(encl);
+	if (ret)
+		return ret;
+
 	mutex_lock(&encl->lock);
 
 	if (encl->flags & (SGX_ENCL_INITIALIZED | SGX_ENCL_DEAD)) {
diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index bd8bcd748976..1b8874699dd3 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -7,11 +7,91 @@
 #include <linux/sched/mm.h>
 #include "arch.h"
 #include "encl.h"
+#include "encls.h"
 #include "sgx.h"
 
+static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
+			   struct sgx_epc_page *epc_page)
+{
+	unsigned long addr = SGX_ENCL_PAGE_ADDR(encl_page);
+	unsigned long va_offset = SGX_ENCL_PAGE_VA_OFFSET(encl_page);
+	struct sgx_encl *encl = encl_page->encl;
+	pgoff_t page_index = sgx_encl_get_index(encl, encl_page);
+	pgoff_t pcmd_index = sgx_pcmd_index(encl, page_index);
+	unsigned long pcmd_offset = sgx_pcmd_offset(page_index);
+	struct sgx_pageinfo pginfo;
+	struct page *backing;
+	struct page *pcmd;
+	int ret;
+
+	backing = sgx_encl_get_backing_page(encl, page_index);
+	if (IS_ERR(backing)) {
+		ret = PTR_ERR(backing);
+		goto err_backing;
+	}
+
+	pcmd = sgx_encl_get_backing_page(encl, pcmd_index);
+	if (IS_ERR(pcmd)) {
+		ret = PTR_ERR(pcmd);
+		goto err_pcmd;
+	}
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
+		if (encls_failed(ret) || encls_returned_code(ret))
+			ENCLS_WARN(ret, "ELDU");
+
+		ret = -EFAULT;
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
+	return ret;
+}
+
+static struct sgx_epc_page *sgx_encl_eldu(struct sgx_encl_page *encl_page)
+{
+	unsigned long va_offset = SGX_ENCL_PAGE_VA_OFFSET(encl_page);
+	struct sgx_encl *encl = encl_page->encl;
+	struct sgx_epc_page *epc_page;
+	int ret;
+
+	epc_page = sgx_alloc_page(encl_page, false);
+	if (IS_ERR(epc_page))
+		return epc_page;
+
+	ret = __sgx_encl_eldu(encl_page, epc_page);
+	if (ret) {
+		sgx_free_page(epc_page);
+		return ERR_PTR(ret);
+	}
+
+	sgx_free_va_slot(encl_page->va_page, va_offset);
+	list_move(&encl_page->va_page->list, &encl->va_pages);
+	encl_page->desc &= ~SGX_ENCL_PAGE_VA_OFFSET_MASK;
+	encl_page->epc_page = epc_page;
+
+	return epc_page;
+}
+
 static struct sgx_encl_page *sgx_encl_load_page(struct sgx_encl *encl,
 						unsigned long addr)
 {
+	struct sgx_epc_page *epc_page;
 	struct sgx_encl_page *entry;
 
 	/* If process was forked, VMA is still there but vm_private_data is set
@@ -29,10 +109,27 @@ static struct sgx_encl_page *sgx_encl_load_page(struct sgx_encl *encl,
 		return ERR_PTR(-EFAULT);
 
 	/* Page is already resident in the EPC. */
-	if (entry->epc_page)
+	if (entry->epc_page) {
+		if (entry->desc & SGX_ENCL_PAGE_RECLAIMED)
+			return ERR_PTR(-EBUSY);
+
 		return entry;
+	}
+
+	if (!(encl->secs.epc_page)) {
+		epc_page = sgx_encl_eldu(&encl->secs);
+		if (IS_ERR(epc_page))
+			return ERR_CAST(epc_page);
+	}
+
+	epc_page = entry->epc_page ? entry->epc_page : sgx_encl_eldu(entry);
+	if (IS_ERR(epc_page))
+		return ERR_CAST(epc_page);
 
-	return ERR_PTR(-EFAULT);
+	encl->secs_child_cnt++;
+	sgx_mark_page_reclaimable(entry->epc_page);
+
+	return entry;
 }
 
 static struct sgx_encl_mm *sgx_encl_get_mm(struct sgx_encl *encl,
@@ -152,6 +249,8 @@ static unsigned int sgx_vma_fault(struct vm_fault *vmf)
 		goto out;
 	}
 
+	sgx_encl_test_and_clear_young(vma->vm_mm, entry);
+
 out:
 	mutex_unlock(&encl->lock);
 	return ret;
@@ -203,6 +302,7 @@ EXPORT_SYMBOL_GPL(sgx_encl_find);
  */
 void sgx_encl_destroy(struct sgx_encl *encl)
 {
+	struct sgx_va_page *va_page;
 	struct sgx_encl_page *entry;
 	struct radix_tree_iter iter;
 	void **slot;
@@ -227,6 +327,15 @@ void sgx_encl_destroy(struct sgx_encl *encl)
 		sgx_free_page(encl->secs.epc_page);
 		encl->secs.epc_page = NULL;
 	}
+
+
+	while (!list_empty(&encl->va_pages)) {
+		va_page = list_first_entry(&encl->va_pages, struct sgx_va_page,
+					   list);
+		list_del(&va_page->list);
+		sgx_free_page(va_page->epc_page);
+		kfree(va_page);
+	}
 }
 EXPORT_SYMBOL_GPL(sgx_encl_destroy);
 
@@ -356,3 +465,157 @@ void sgx_encl_release_mm(struct kref *ref)
 
 	kfree(mm);
 }
+
+static int sgx_encl_test_and_clear_young_cb(pte_t *ptep, pgtable_t token,
+					    unsigned long addr, void *data)
+{
+	pte_t pte;
+	int ret;
+
+	ret = pte_young(*ptep);
+	if (ret) {
+		pte = pte_mkold(*ptep);
+		set_pte_at((struct mm_struct *)data, addr, ptep, pte);
+	}
+
+	return ret;
+}
+
+/**
+ * sgx_encl_test_and_clear_young() - Test and reset the accessed bit
+ * @mm:		mm_struct that is checked
+ * @page:	enclave page to be tested for recent access
+ *
+ * Checks the Access (A) bit from the PTE corresponding to the enclave page and
+ * clears it.
+ *
+ * Return: 1 if the page has been recently accessed and 0 if not.
+ */
+int sgx_encl_test_and_clear_young(struct mm_struct *mm,
+				  struct sgx_encl_page *page)
+{
+	unsigned long addr = SGX_ENCL_PAGE_ADDR(page);
+	struct sgx_encl *encl = page->encl;
+	struct vm_area_struct *vma;
+	int ret;
+
+	ret = sgx_encl_find(mm, addr, &vma);
+	if (ret)
+		return 0;
+
+	if (encl != vma->vm_private_data)
+		return 0;
+
+	ret = apply_to_page_range(vma->vm_mm, addr, PAGE_SIZE,
+				  sgx_encl_test_and_clear_young_cb, vma->vm_mm);
+	if (ret < 0)
+		return 0;
+
+	return ret;
+}
+
+/**
+ * sgx_encl_reserve_page() - Reserve an enclave page
+ * @encl:	an enclave
+ * @addr:	a page address
+ *
+ * Load an enclave page and lock the enclave so that the page can be used by
+ * EDBG* and EMOD*.
+ *
+ * Return:
+ *   an enclave page on success
+ *   -EFAULT	if the load fails
+ */
+struct sgx_encl_page *sgx_encl_reserve_page(struct sgx_encl *encl,
+					    unsigned long addr)
+{
+	struct sgx_encl_page *entry;
+
+	for ( ; ; ) {
+		mutex_lock(&encl->lock);
+
+		entry = sgx_encl_load_page(encl, addr);
+		if (PTR_ERR(entry) != -EBUSY)
+			break;
+
+		mutex_unlock(&encl->lock);
+	}
+
+	if (IS_ERR(entry))
+		mutex_unlock(&encl->lock);
+
+	return entry;
+}
+EXPORT_SYMBOL(sgx_encl_reserve_page);
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
+	epc_page = sgx_alloc_page(NULL, true);
+	if (IS_ERR(epc_page))
+		return ERR_CAST(epc_page);
+
+	ret = __epa(sgx_epc_addr(epc_page));
+	if (ret) {
+		WARN_ONCE(1, "sgx: EPA returned %d (0x%x)", ret, ret);
+		sgx_free_page(epc_page);
+		return ERR_PTR(-EFAULT);
+	}
+
+	return epc_page;
+}
+EXPORT_SYMBOL_GPL(sgx_alloc_va_page);
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
diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
index 374ad3396684..41c55e565e92 100644
--- a/arch/x86/kernel/cpu/sgx/encl.h
+++ b/arch/x86/kernel/cpu/sgx/encl.h
@@ -10,6 +10,10 @@
 /**
  * enum sgx_encl_page_desc - defines bits for an enclave page's descriptor
  * %SGX_ENCL_PAGE_TCS:			The page is a TCS page.
+ * %SGX_ENCL_PAGE_RECLAIMED:		The page is in the process of being
+ *					reclaimed.
+ * %SGX_ENCL_PAGE_VA_OFFSET_MASK:	Holds the offset in the Version Array
+ *					(VA) page for a swapped page.
  * %SGX_ENCL_PAGE_ADDR_MASK:		Holds the virtual address of the page.
  *
  * The page address for SECS is zero and is used by the subsystem to recognize
@@ -18,6 +22,8 @@
 enum sgx_encl_page_desc {
 	SGX_ENCL_PAGE_TCS		= BIT(0),
 	/* Bits 11:3 are available when the page is not swapped. */
+	SGX_ENCL_PAGE_RECLAIMED		= BIT(3),
+	SGX_ENCL_PAGE_VA_OFFSET_MASK	= GENMASK_ULL(11, 3),
 	SGX_ENCL_PAGE_ADDR_MASK		= PAGE_MASK,
 };
 
@@ -29,6 +35,7 @@ enum sgx_encl_page_desc {
 struct sgx_encl_page {
 	unsigned long desc;
 	struct sgx_epc_page *epc_page;
+	struct sgx_va_page *va_page;
 	struct sgx_encl *encl;
 };
 
@@ -60,15 +67,37 @@ struct sgx_encl {
 	unsigned long base;
 	unsigned long size;
 	unsigned long ssaframesize;
+	struct list_head va_pages;
 	struct radix_tree_root page_tree;
 	struct list_head add_page_reqs;
 	struct work_struct work;
 	struct sgx_encl_page secs;
 	struct notifier_block pm_notifier;
+	cpumask_t cpumask;
+};
+
+#define SGX_VA_SLOT_COUNT 512
+
+struct sgx_va_page {
+	struct sgx_epc_page *epc_page;
+	DECLARE_BITMAP(slots, SGX_VA_SLOT_COUNT);
+	struct list_head list;
 };
 
 extern const struct vm_operations_struct sgx_vm_ops;
 
+static inline pgoff_t sgx_pcmd_index(struct sgx_encl *encl,
+				     pgoff_t page_index)
+{
+	return PFN_DOWN(encl->size) + 1 + (page_index >> 5);
+}
+
+static inline unsigned long sgx_pcmd_offset(pgoff_t page_index)
+{
+	return (page_index & (PAGE_SIZE / sizeof(struct sgx_pcmd) - 1)) *
+	       sizeof(struct sgx_pcmd);
+}
+
 enum sgx_encl_mm_iter {
 	SGX_ENCL_MM_ITER_DONE		= 0,
 	SGX_ENCL_MM_ITER_NEXT		= 1,
@@ -84,5 +113,14 @@ struct page *sgx_encl_get_backing_page(struct sgx_encl *encl, pgoff_t index);
 struct sgx_encl_mm *sgx_encl_next_mm(struct sgx_encl *encl,
 				     struct sgx_encl_mm *mm, int *iter);
 void sgx_encl_release_mm(struct kref *ref);
+int sgx_encl_test_and_clear_young(struct mm_struct *mm,
+				  struct sgx_encl_page *page);
+struct sgx_encl_page *sgx_encl_reserve_page(struct sgx_encl *encl,
+					    unsigned long addr);
+
+struct sgx_epc_page *sgx_alloc_va_page(void);
+unsigned int sgx_alloc_va_slot(struct sgx_va_page *va_page);
+void sgx_free_va_slot(struct sgx_va_page *va_page, unsigned int offset);
+bool sgx_va_page_full(struct sgx_va_page *va_page);
 
 #endif /* _X86_ENCL_H */
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index d88dc3d1d4a7..a9485a73c58c 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -17,13 +17,13 @@ EXPORT_SYMBOL_GPL(sgx_epc_sections);
 bool sgx_enabled;
 EXPORT_SYMBOL_GPL(sgx_enabled);
 
-static int sgx_nr_epc_sections;
+int sgx_nr_epc_sections;
 
 /* A per-cpu cache for the last known values of IA32_SGXLEPUBKEYHASHx MSRs. */
 static DEFINE_PER_CPU(u64 [4], sgx_lepubkeyhash_cache);
 
-static void sgx_section_put_page(struct sgx_epc_section *section,
-				 struct sgx_epc_page *page)
+void sgx_section_put_page(struct sgx_epc_section *section,
+			  struct sgx_epc_page *page)
 {
 	list_add_tail(&page->list, &section->page_list);
 	section->free_cnt++;
@@ -44,16 +44,7 @@ static struct sgx_epc_page *sgx_section_get_page(
 	return page;
 }
 
-/**
- * sgx_alloc_page - Allocate an EPC page
- *
- * Try to grab a page from the free EPC page list.
- *
- * Return:
- *   a pointer to a &struct sgx_epc_page instance,
- *   -errno on error
- */
-struct sgx_epc_page *sgx_alloc_page(void)
+static struct sgx_epc_page *sgx_try_alloc_page(void *owner)
 {
 	struct sgx_epc_section *section;
 	struct sgx_epc_page *page;
@@ -65,11 +56,58 @@ struct sgx_epc_page *sgx_alloc_page(void)
 		page = sgx_section_get_page(section);
 		spin_unlock(&section->lock);
 
-		if (page)
+		if (page) {
+			page->owner = owner;
 			return page;
+		}
+	}
+
+	return NULL;
+}
+
+/**
+ * sgx_alloc_page - Allocate an EPC page
+ * @owner:	the owner of the EPC page
+ * @reclaim:	reclaim pages if necessary
+ *
+ * Try to grab a page from the free EPC page list. If there is a free page
+ * available, it is returned to the caller. The @reclaim parameter hints
+ * the EPC memory manager to swap pages when required.
+ *
+ * Return:
+ *   a pointer to a &struct sgx_epc_page instance,
+ *   -errno on error
+ */
+struct sgx_epc_page *sgx_alloc_page(void *owner, bool reclaim)
+{
+	struct sgx_epc_page *entry;
+
+	for ( ; ; ) {
+		entry = sgx_try_alloc_page(owner);
+		if (entry)
+			break;
+
+		if (list_empty(&sgx_active_page_list))
+			return ERR_PTR(-ENOMEM);
+
+		if (!reclaim) {
+			entry = ERR_PTR(-EBUSY);
+			break;
+		}
+
+		if (signal_pending(current)) {
+			entry = ERR_PTR(-ERESTARTSYS);
+			break;
+		}
+
+		sgx_reclaim_pages();
+		schedule();
 	}
 
-	return ERR_PTR(-ENOMEM);
+	if (sgx_calc_free_cnt() < SGX_NR_LOW_PAGES)
+		wake_up(&ksgxswapd_waitq);
+
+	return entry;
 }
 EXPORT_SYMBOL_GPL(sgx_alloc_page);
 
@@ -77,10 +115,12 @@ EXPORT_SYMBOL_GPL(sgx_alloc_page);
  * __sgx_free_page - Free an EPC page
  * @page:	pointer a previously allocated EPC page
  *
- * EREMOVE an EPC page and insert it back to the list of free pages.
+ * EREMOVE an EPC page and insert it back to the list of free pages.  If the
+ * page is reclaimable, delete it from the active page list.
  *
  * Return:
  *   0 on success
+ *   -EBUSY if the page cannot be removed from the active list
  *   SGX error code if EREMOVE fails
  */
 int __sgx_free_page(struct sgx_epc_page *page)
@@ -88,6 +128,23 @@ int __sgx_free_page(struct sgx_epc_page *page)
 	struct sgx_epc_section *section = sgx_epc_section(page);
 	int ret;
 
+	/*
+	 * Remove the page from the active list if necessary.  If the page
+	 * is actively being reclaimed, i.e. RECLAIMABLE is set but the
+	 * page isn't on the active list, return -EBUSY as we can't free
+	 * the page at this time since it is "owned" by the reclaimer.
+	 */
+	spin_lock(&sgx_active_page_list_lock);
+	if (page->desc & SGX_EPC_PAGE_RECLAIMABLE) {
+		if (list_empty(&page->list)) {
+			spin_unlock(&sgx_active_page_list_lock);
+			return -EBUSY;
+		}
+		list_del(&page->list);
+		page->desc &= ~SGX_EPC_PAGE_RECLAIMABLE;
+	}
+	spin_unlock(&sgx_active_page_list_lock);
+
 	ret = __eremove(sgx_epc_addr(page));
 	if (ret)
 		return ret;
@@ -113,6 +170,7 @@ void sgx_free_page(struct sgx_epc_page *page)
 	int ret;
 
 	ret = __sgx_free_page(page);
+	WARN(ret < 0, "sgx: cannot free page, reclaim in-progress");
 	WARN(ret > 0, "sgx: EREMOVE returned %d (0x%x)", ret, ret);
 }
 EXPORT_SYMBOL_GPL(sgx_free_page);
@@ -285,6 +343,12 @@ static __init int sgx_init(void)
 	if (ret)
 		return ret;
 
+	ret = sgx_page_reclaimer_init();
+	if (ret) {
+		sgx_page_cache_teardown();
+		return ret;
+	}
+
 	sgx_enabled = true;
 	return 0;
 }
diff --git a/arch/x86/kernel/cpu/sgx/reclaim.c b/arch/x86/kernel/cpu/sgx/reclaim.c
new file mode 100644
index 000000000000..ba67576f6515
--- /dev/null
+++ b/arch/x86/kernel/cpu/sgx/reclaim.c
@@ -0,0 +1,410 @@
+// SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
+// Copyright(c) 2016-19 Intel Corporation.
+
+#include <linux/freezer.h>
+#include <linux/highmem.h>
+#include <linux/kthread.h>
+#include <linux/pagemap.h>
+#include <linux/ratelimit.h>
+#include <linux/slab.h>
+#include <linux/sched/mm.h>
+#include <linux/sched/signal.h>
+#include "driver/driver.h"
+#include "sgx.h"
+
+LIST_HEAD(sgx_active_page_list);
+DEFINE_SPINLOCK(sgx_active_page_list_lock);
+DECLARE_WAIT_QUEUE_HEAD(ksgxswapd_waitq);
+
+static struct task_struct *ksgxswapd_tsk;
+
+/**
+ * sgx_mark_page_reclaimable() - Mark a page as reclaimable
+ * @page:	EPC page
+ *
+ * Mark a page as reclaimable and add it to the active page list. Pages
+ * are automatically removed from the active list when freed.
+ */
+void sgx_mark_page_reclaimable(struct sgx_epc_page *page)
+{
+	spin_lock(&sgx_active_page_list_lock);
+	page->desc |= SGX_EPC_PAGE_RECLAIMABLE;
+	list_add_tail(&page->list, &sgx_active_page_list);
+	spin_unlock(&sgx_active_page_list_lock);
+}
+EXPORT_SYMBOL_GPL(sgx_mark_page_reclaimable);
+
+bool sgx_reclaimer_get(struct sgx_epc_page *epc_page)
+{
+	struct sgx_encl_page *encl_page = epc_page->owner;
+	struct sgx_encl *encl = encl_page->encl;
+
+	return kref_get_unless_zero(&encl->refcount) != 0;
+}
+
+void sgx_reclaimer_put(struct sgx_epc_page *epc_page)
+{
+	struct sgx_encl_page *encl_page = epc_page->owner;
+	struct sgx_encl *encl = encl_page->encl;
+
+	kref_put(&encl->refcount, sgx_encl_release);
+}
+
+static bool sgx_reclaimer_evict(struct sgx_epc_page *epc_page)
+{
+	struct sgx_encl_page *page = epc_page->owner;
+	struct sgx_encl *encl = page->encl;
+	struct sgx_encl_mm *next_mm = NULL;
+	struct sgx_encl_mm *prev_mm = NULL;
+	bool ret = true;
+	int iter;
+
+	while (true) {
+		next_mm = sgx_encl_next_mm(encl, prev_mm, &iter);
+		if (prev_mm) {
+			mmdrop(prev_mm->mm);
+			kref_put(&prev_mm->refcount, sgx_encl_release_mm);
+		}
+		prev_mm = next_mm;
+
+		if (iter == SGX_ENCL_MM_ITER_DONE)
+			break;
+
+		if (iter == SGX_ENCL_MM_ITER_RESTART)
+			continue;
+
+		down_read(&next_mm->mm->mmap_sem);
+		mutex_lock(&encl->lock);
+
+		if (encl->flags & SGX_ENCL_DEAD) {
+			page->desc |= SGX_ENCL_PAGE_RECLAIMED;
+			ret = true;
+			goto out_stop;
+		}
+
+		ret = !sgx_encl_test_and_clear_young(next_mm->mm, page);
+		if (!ret)
+			goto out_stop;
+
+		mutex_unlock(&encl->lock);
+		up_read(&next_mm->mm->mmap_sem);
+	}
+
+	page->desc |= SGX_ENCL_PAGE_RECLAIMED;
+	return true;
+out_stop:
+	mutex_unlock(&encl->lock);
+	up_read(&next_mm->mm->mmap_sem);
+	mmdrop(next_mm->mm);
+	kref_put(&next_mm->refcount, sgx_encl_release_mm);
+	return ret;
+}
+
+static void sgx_reclaimer_block(struct sgx_epc_page *epc_page)
+{
+	struct sgx_encl_page *page = epc_page->owner;
+	unsigned long addr = SGX_ENCL_PAGE_ADDR(page);
+	struct sgx_encl *encl = page->encl;
+	struct sgx_encl_mm *next_mm = NULL;
+	struct sgx_encl_mm *prev_mm = NULL;
+	struct vm_area_struct *vma;
+	int iter;
+	int ret;
+
+	while (true) {
+		next_mm = sgx_encl_next_mm(encl, prev_mm, &iter);
+		if (prev_mm) {
+			mmdrop(prev_mm->mm);
+			kref_put(&prev_mm->refcount, sgx_encl_release_mm);
+		}
+		prev_mm = next_mm;
+
+		if (iter == SGX_ENCL_MM_ITER_DONE)
+			break;
+
+		if (iter == SGX_ENCL_MM_ITER_RESTART)
+			continue;
+
+		down_read(&next_mm->mm->mmap_sem);
+		mutex_lock(&encl->lock);
+
+		ret = sgx_encl_find(next_mm->mm, addr, &vma);
+		if (!ret && encl == vma->vm_private_data)
+			zap_vma_ptes(vma, addr, PAGE_SIZE);
+
+		mutex_unlock(&encl->lock);
+		up_read(&next_mm->mm->mmap_sem);
+	}
+
+	mutex_lock(&encl->lock);
+
+	if (!(encl->flags & SGX_ENCL_DEAD)) {
+		ret = __eblock(sgx_epc_addr(epc_page));
+		if (encls_failed(ret))
+			ENCLS_WARN(ret, "EBLOCK");
+	}
+
+	mutex_unlock(&encl->lock);
+}
+
+static int __sgx_encl_ewb(struct sgx_encl *encl, struct sgx_epc_page *epc_page,
+			  struct sgx_va_page *va_page, unsigned int va_offset)
+{
+	struct sgx_encl_page *encl_page = epc_page->owner;
+	pgoff_t page_index = sgx_encl_get_index(encl, encl_page);
+	pgoff_t pcmd_index = sgx_pcmd_index(encl, page_index);
+	unsigned long pcmd_offset = sgx_pcmd_offset(page_index);
+	struct sgx_pageinfo pginfo;
+	struct page *backing;
+	struct page *pcmd;
+	int ret;
+
+	backing = sgx_encl_get_backing_page(encl, page_index);
+	if (IS_ERR(backing)) {
+		ret = PTR_ERR(backing);
+		goto err_backing;
+	}
+
+	pcmd = sgx_encl_get_backing_page(encl, pcmd_index);
+	if (IS_ERR(pcmd)) {
+		ret = PTR_ERR(pcmd);
+		goto err_pcmd;
+	}
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
+static void sgx_ipi_cb(void *info)
+{
+}
+
+static void sgx_encl_ewb(struct sgx_epc_page *epc_page, bool do_free)
+{
+	struct sgx_encl_page *encl_page = epc_page->owner;
+	struct sgx_encl *encl = encl_page->encl;
+	struct sgx_encl_mm *next_mm = NULL;
+	struct sgx_encl_mm *prev_mm = NULL;
+	struct sgx_va_page *va_page;
+	unsigned int va_offset;
+	int iter;
+	int ret;
+
+	cpumask_clear(&encl->cpumask);
+
+	while (true) {
+		next_mm = sgx_encl_next_mm(encl, prev_mm, &iter);
+		if (prev_mm) {
+			mmdrop(prev_mm->mm);
+			kref_put(&prev_mm->refcount, sgx_encl_release_mm);
+		}
+		prev_mm = next_mm;
+
+		if (iter == SGX_ENCL_MM_ITER_DONE)
+			break;
+
+		if (iter == SGX_ENCL_MM_ITER_RESTART)
+			continue;
+
+		cpumask_or(&encl->cpumask, &encl->cpumask,
+			   mm_cpumask(next_mm->mm));
+	}
+
+	encl_page->desc &= ~SGX_ENCL_PAGE_RECLAIMED;
+
+	if (!(encl->flags & SGX_ENCL_DEAD)) {
+		va_page = list_first_entry(&encl->va_pages, struct sgx_va_page,
+					   list);
+		va_offset = sgx_alloc_va_slot(va_page);
+		if (sgx_va_page_full(va_page))
+			list_move_tail(&va_page->list, &encl->va_pages);
+
+		ret = __sgx_encl_ewb(encl, epc_page, va_page, va_offset);
+		if (ret == SGX_NOT_TRACKED) {
+			ret = __etrack(sgx_epc_addr(encl->secs.epc_page));
+			if (ret) {
+				if (encls_failed(ret) ||
+				    encls_returned_code(ret))
+					ENCLS_WARN(ret, "ETRACK");
+			}
+
+			ret = __sgx_encl_ewb(encl, epc_page, va_page,
+					     va_offset);
+			if (ret == SGX_NOT_TRACKED) {
+				/* slow path, IPI needed */
+				on_each_cpu_mask(&encl->cpumask, sgx_ipi_cb,
+						 NULL, 1);
+				ret = __sgx_encl_ewb(encl, epc_page, va_page,
+						     va_offset);
+			}
+		}
+
+		if (ret)
+			if (encls_failed(ret) || encls_returned_code(ret))
+				ENCLS_WARN(ret, "EWB");
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
+
+	encl_page->epc_page = NULL;
+}
+
+static void sgx_reclaimer_write(struct sgx_epc_page *epc_page)
+{
+	struct sgx_encl_page *encl_page = epc_page->owner;
+	struct sgx_encl *encl = encl_page->encl;
+
+	mutex_lock(&encl->lock);
+
+	sgx_encl_ewb(epc_page, false);
+	encl->secs_child_cnt--;
+	if (!encl->secs_child_cnt &&
+	    (encl->flags & (SGX_ENCL_DEAD | SGX_ENCL_INITIALIZED))) {
+		sgx_encl_ewb(encl->secs.epc_page, true);
+	}
+
+	mutex_unlock(&encl->lock);
+}
+
+/**
+ * sgx_reclaim_pages() - Reclaim EPC pages from the consumers
+ * Takes a fixed chunk of pages from the global list of consumed EPC pages and
+ * tries to swap them. Only the pages that are either being freed by the
+ * consumer or actively used are skipped.
+ */
+void sgx_reclaim_pages(void)
+{
+	struct sgx_epc_page *chunk[SGX_NR_TO_SCAN + 1];
+	struct sgx_epc_page *epc_page;
+	struct sgx_epc_section *section;
+	int i, j;
+
+	spin_lock(&sgx_active_page_list_lock);
+	for (i = 0, j = 0; i < SGX_NR_TO_SCAN; i++) {
+		if (list_empty(&sgx_active_page_list))
+			break;
+
+		epc_page = list_first_entry(&sgx_active_page_list,
+					    struct sgx_epc_page, list);
+		list_del_init(&epc_page->list);
+
+		if (sgx_reclaimer_get(epc_page))
+			chunk[j++] = epc_page;
+		else
+			/* The owner is freeing the page. No need to add the
+			 * page back to the list of reclaimable pages.
+			 */
+			epc_page->desc &= ~SGX_EPC_PAGE_RECLAIMABLE;
+	}
+	spin_unlock(&sgx_active_page_list_lock);
+
+	for (i = 0; i < j; i++) {
+		epc_page = chunk[i];
+		if (sgx_reclaimer_evict(epc_page))
+			continue;
+
+		sgx_reclaimer_put(epc_page);
+
+		spin_lock(&sgx_active_page_list_lock);
+		list_add_tail(&epc_page->list, &sgx_active_page_list);
+		spin_unlock(&sgx_active_page_list_lock);
+
+		chunk[i] = NULL;
+	}
+
+	for (i = 0; i < j; i++) {
+		epc_page = chunk[i];
+		if (epc_page)
+			sgx_reclaimer_block(epc_page);
+	}
+
+	for (i = 0; i < j; i++) {
+		epc_page = chunk[i];
+		if (epc_page) {
+			sgx_reclaimer_write(epc_page);
+			sgx_reclaimer_put(epc_page);
+			epc_page->desc &= ~SGX_EPC_PAGE_RECLAIMABLE;
+
+			section = sgx_epc_section(epc_page);
+			spin_lock(&section->lock);
+			sgx_section_put_page(section, epc_page);
+			spin_unlock(&section->lock);
+		}
+	}
+}
+
+unsigned long sgx_calc_free_cnt(void)
+{
+	struct sgx_epc_section *section;
+	unsigned long free_cnt = 0;
+	int i;
+
+	for (i = 0; i < sgx_nr_epc_sections; i++) {
+		section = &sgx_epc_sections[i];
+		free_cnt += section->free_cnt;
+	}
+
+	return free_cnt;
+}
+
+static inline bool sgx_should_reclaim(void)
+{
+	return sgx_calc_free_cnt() < SGX_NR_HIGH_PAGES &&
+	       !list_empty(&sgx_active_page_list);
+}
+
+static int ksgxswapd(void *p)
+{
+	set_freezable();
+
+	while (!kthread_should_stop()) {
+		if (try_to_freeze())
+			continue;
+
+		wait_event_freezable(ksgxswapd_waitq, kthread_should_stop() ||
+						      sgx_should_reclaim());
+
+		if (sgx_should_reclaim())
+			sgx_reclaim_pages();
+
+		cond_resched();
+	}
+
+	return 0;
+}
+
+int sgx_page_reclaimer_init(void)
+{
+	struct task_struct *tsk;
+
+	tsk = kthread_run(ksgxswapd, NULL, "ksgxswapd");
+	if (IS_ERR(tsk))
+		return PTR_ERR(tsk);
+
+	ksgxswapd_tsk = tsk;
+
+	return 0;
+}
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index 2337b63ba487..ed587627ca81 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -12,6 +12,7 @@
 
 struct sgx_epc_page {
 	unsigned long desc;
+	struct sgx_encl_page *owner;
 	struct list_head list;
 };
 
@@ -42,9 +43,14 @@ extern bool sgx_enabled;
  *				physical memory. The existing and near-future
  *				hardware defines at most eight sections, hence
  *				three bits to hold a section.
+ * %SGX_EPC_PAGE_RECLAIMABLE:	The page has been been marked as reclaimable.
+ *				Pages need to be colored this way because a page
+ *				can be out of the active page list in the
+ *				process of being swapped out.
  */
 enum sgx_epc_page_desc {
 	SGX_EPC_SECTION_MASK			= GENMASK_ULL(3, 0),
+	SGX_EPC_PAGE_RECLAIMABLE		= BIT(4),
 	/* bits 12-63 are reserved for the physical page address of the page */
 };
 
@@ -60,10 +66,36 @@ static inline void *sgx_epc_addr(struct sgx_epc_page *page)
 	return section->va + (page->desc & PAGE_MASK) - section->pa;
 }
 
-struct sgx_epc_page *sgx_alloc_page(void);
+void sgx_section_put_page(struct sgx_epc_section *section,
+			  struct sgx_epc_page *page);
+struct sgx_epc_page *sgx_alloc_page(void *owner, bool reclaim);
 int __sgx_free_page(struct sgx_epc_page *page);
 void sgx_free_page(struct sgx_epc_page *page);
 int sgx_einit(struct sgx_sigstruct *sigstruct, struct sgx_einittoken *token,
 	      struct sgx_epc_page *secs, u64 *lepubkeyhash);
 
+/**
+ * enum sgx_swap_constants - the constants used by the swapping code
+ * %SGX_NR_TO_SCAN:	the number of pages to scan in a single round
+ * %SGX_NR_LOW_PAGES:	the low watermark for ksgxswapd when it starts to swap
+ *			pages.
+ * %SGX_NR_HIGH_PAGES:	the high watermark for ksgxswapd what it stops swapping
+ *			pages.
+ */
+enum sgx_swap_constants {
+	SGX_NR_TO_SCAN		= 16,
+	SGX_NR_LOW_PAGES	= 32,
+	SGX_NR_HIGH_PAGES	= 64,
+};
+
+extern int sgx_nr_epc_sections;
+extern struct list_head sgx_active_page_list;
+extern spinlock_t sgx_active_page_list_lock;
+extern struct wait_queue_head(ksgxswapd_waitq);
+
+void sgx_mark_page_reclaimable(struct sgx_epc_page *page);
+unsigned long sgx_calc_free_cnt(void);
+void sgx_reclaim_pages(void);
+int sgx_page_reclaimer_init(void);
+
 #endif /* _X86_SGX_H */
-- 
2.19.1

