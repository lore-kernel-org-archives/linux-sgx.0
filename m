Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51103C07E96
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Jul 2021 18:14:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 297EA61629
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Jul 2021 18:14:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbhGHSRS (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 8 Jul 2021 14:17:18 -0400
Received: from mga01.intel.com ([192.55.52.88]:2094 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229469AbhGHSRR (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 8 Jul 2021 14:17:17 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10039"; a="231327147"
X-IronPort-AV: E=Sophos;i="5.84,224,1620716400"; 
   d="scan'208";a="231327147"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2021 11:14:35 -0700
X-IronPort-AV: E=Sophos;i="5.84,224,1620716400"; 
   d="scan'208";a="482637380"
Received: from agluck-desk2.sc.intel.com ([10.3.52.146])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2021 11:14:35 -0700
From:   Tony Luck <tony.luck@intel.com>
To:     tony.luck@intel.com
Cc:     Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] x86/sgx: Add basic infrastructure to recover from errors in SGX memory
Date:   Thu,  8 Jul 2021 11:14:21 -0700
Message-Id: <20210708181423.1312359-3-tony.luck@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210708181423.1312359-1-tony.luck@intel.com>
References: <20210708181423.1312359-1-tony.luck@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

X86 machine check architecture reports a physical address when there is
a memory error.

Add an end_phys_addr field to the sgx_epc_section structure and a new
function sgx_paddr_to_page() that searches all such structures to see
if a physical address is part of an SGX EPC page.

The ACPI EINJ module has a sanity check that the injection address is
valid. Add and export a function sgx_is_epc_page() so that it can be
changed to allow injection to SGX EPC pages.

Provide a recovery function sgx_memory_failure(). If the poison was
consumed synchronously inside the enclave send a SIGBUS just the
same as for poison consumption outside of an enclave.

For asynchronously reported errors the easiest cases are when the page
is currently free. Just drop the page from the free list so that it will
never be allocated.

An SGX_PAGE_TYPE_REG page can just be unmapped from the enclave. If the
enclave doesn't ever touch that page again all is well. If it does touch
the page it will die. Possible future enhancement here to mark the
unmapped PTE so that it will cause a SIGBUS.

SGX_PAGE_TYPE_KVM pages may be recoverable depending on how they are
being used by guests. To fix that properly requires injecting the machine
check into the guest. For now just kill it.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/sgx/main.c | 126 +++++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/sgx/sgx.h  |   3 +-
 arch/x86/kernel/cpu/sgx/virt.c |   9 +++
 3 files changed, 137 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 643df87b3e01..4a354f89373e 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -664,6 +664,7 @@ static bool __init sgx_setup_epc_section(u64 phys_addr, u64 size,
 	}
 
 	section->phys_addr = phys_addr;
+	section->end_phys_addr = phys_addr + size - 1;
 
 	for (i = 0; i < nr_pages; i++) {
 		section->pages[i].section = index;
@@ -676,6 +677,131 @@ static bool __init sgx_setup_epc_section(u64 phys_addr, u64 size,
 	return true;
 }
 
+static struct sgx_epc_page *sgx_paddr_to_page(u64 paddr)
+{
+	struct sgx_epc_section *section;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(sgx_epc_sections); i++) {
+		section = &sgx_epc_sections[i];
+
+		if (paddr < section->phys_addr || paddr > section->end_phys_addr)
+			continue;
+
+		return &section->pages[PFN_DOWN(paddr - section->phys_addr)];
+	}
+
+	return NULL;
+}
+
+bool sgx_is_epc_page(u64 paddr)
+{
+	return !!sgx_paddr_to_page(paddr);
+}
+EXPORT_SYMBOL_GPL(sgx_is_epc_page);
+
+void __attribute__((weak)) sgx_memory_failure_vepc(struct sgx_epc_page *epc_page)
+{
+}
+
+/*
+ * This can be called in three ways:
+ * a) When an enclave has just consumed poison. In this case
+ *    calling process context is the owner of the enclave.
+ * b) For some asychronous poison notification (e.g. patrol
+ *    scrubber or speculative execution saw the poison.)
+ *    In this case calling context is a kernel thread.
+ * c) Someone asked to take a page offline using the
+ *    /sys/devices/system/memory/{hard,soft}_offline_page.
+ *    In this case caller is the process writing these files.
+ */
+int sgx_memory_failure(unsigned long pfn, int flags)
+{
+	struct sgx_epc_page *epc_page = sgx_paddr_to_page(pfn << PAGE_SHIFT);
+	struct sgx_epc_section *section;
+	struct sgx_encl_page *encl_page;
+	struct sgx_numa_node *node;
+	unsigned long addr;
+	u16 page_flags;
+
+	if (!epc_page)
+		return -ENXIO;
+
+	spin_lock(&sgx_reclaimer_lock);
+
+	page_flags = epc_page->flags;
+	epc_page->flags |= SGX_EPC_PAGE_POISON;
+
+	/*
+	 * Poison was synchronously consumed by an enclave in the current
+	 * task. Send a SIGBUS here. Hardware should prevent this enclave
+	 * from being re-entered, so no concern that the poisoned page
+	 * will be touched a second time. The poisoned EPC page will be
+	 * dropped as pages are freed during task exit.
+	 */
+	if (flags & MF_ACTION_REQUIRED) {
+		if (epc_page->type == SGX_PAGE_TYPE_REG) {
+			encl_page = epc_page->owner;
+			addr = encl_page->desc & PAGE_MASK;
+			force_sig_mceerr(BUS_MCEERR_AR, (void *)addr, PAGE_SHIFT);
+		} else {
+			force_sig(SIGBUS);
+		}
+		goto unlock;
+	}
+
+	section = &sgx_epc_sections[epc_page->section];
+	node = section->node;
+
+	if (page_flags & SGX_EPC_PAGE_POISON)
+		goto unlock;
+
+	if (page_flags & SGX_EPC_PAGE_DIRTY) {
+		list_del(&epc_page->list);
+	} else if (page_flags & SGX_EPC_PAGE_FREE) {
+		spin_lock(&node->lock);
+		epc_page->owner = NULL;
+		list_del(&epc_page->list);
+		sgx_nr_free_pages--;
+		spin_unlock(&node->lock);
+		goto unlock;
+	}
+
+	switch (epc_page->type) {
+	case SGX_PAGE_TYPE_REG:
+		encl_page = epc_page->owner;
+		/* Unmap the page, unless it was already in progress to be freed */
+		if (kref_get_unless_zero(&encl_page->encl->refcount) != 0) {
+			spin_unlock(&sgx_reclaimer_lock);
+			sgx_reclaimer_block(epc_page);
+			kref_put(&encl_page->encl->refcount, sgx_encl_release);
+			goto done;
+		}
+		break;
+
+	case SGX_PAGE_TYPE_KVM:
+		spin_unlock(&sgx_reclaimer_lock);
+		sgx_memory_failure_vepc(epc_page);
+		break;
+
+	default:
+		/*
+		 * I don't expect SECS, TCS, VA pages would result
+		 * in recoverable machine checks. If it turns out
+		 * that they do, then add cases for recovery for
+		 * each of them.
+		 */
+		panic("Poisoned active SGX page type %d\n", epc_page->type);
+		break;
+	}
+	goto done;
+
+unlock:
+	spin_unlock(&sgx_reclaimer_lock);
+done:
+	return 0;
+}
+
 /**
  * A section metric is concatenated in a way that @low bits 12-31 define the
  * bits 12-31 of the metric and @high bits 0-19 define the bits 32-51 of the
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index e43d3c27eb96..7701f5f88b61 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -39,7 +39,7 @@ struct sgx_epc_page {
 	unsigned int section;
 	u16 flags;
 	u16 type;
-	struct sgx_encl_page *owner;
+	void *owner;
 	struct list_head list;
 };
 
@@ -60,6 +60,7 @@ struct sgx_numa_node {
  */
 struct sgx_epc_section {
 	unsigned long phys_addr;
+	unsigned long end_phys_addr;
 	void *virt_addr;
 	struct sgx_epc_page *pages;
 	struct sgx_numa_node *node;
diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/virt.c
index 044dd92ebd63..08918166394f 100644
--- a/arch/x86/kernel/cpu/sgx/virt.c
+++ b/arch/x86/kernel/cpu/sgx/virt.c
@@ -21,6 +21,7 @@
 struct sgx_vepc {
 	struct xarray page_array;
 	struct mutex lock;
+	struct task_struct *task;
 };
 
 /*
@@ -218,6 +219,13 @@ static int sgx_vepc_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
+void sgx_memory_failure_vepc(struct sgx_epc_page *epc_page)
+{
+	struct sgx_vepc *vepc = epc_page->owner;
+
+	send_sig(SIGBUS, vepc->task, false);
+}
+
 static int sgx_vepc_open(struct inode *inode, struct file *file)
 {
 	struct sgx_vepc *vepc;
@@ -227,6 +235,7 @@ static int sgx_vepc_open(struct inode *inode, struct file *file)
 		return -ENOMEM;
 	mutex_init(&vepc->lock);
 	xa_init(&vepc->page_array);
+	vepc->task = current;
 
 	file->private_data = vepc;
 
-- 
2.29.2

