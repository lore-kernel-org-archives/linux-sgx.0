Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8571C43217
	for <linux-sgx@archiver.kernel.org>; Mon, 27 Sep 2021 21:35:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9C3E611ED
	for <linux-sgx@archiver.kernel.org>; Mon, 27 Sep 2021 21:35:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236723AbhI0Vgl (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 27 Sep 2021 17:36:41 -0400
Received: from mga07.intel.com ([134.134.136.100]:2372 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237080AbhI0Vgk (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 27 Sep 2021 17:36:40 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10120"; a="288227513"
X-IronPort-AV: E=Sophos;i="5.85,327,1624345200"; 
   d="scan'208";a="288227513"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2021 14:35:01 -0700
X-IronPort-AV: E=Sophos;i="5.85,327,1624345200"; 
   d="scan'208";a="561547589"
Received: from agluck-desk2.sc.intel.com ([10.3.52.146])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2021 14:35:01 -0700
From:   Tony Luck <tony.luck@intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@intel.com>
Cc:     Cathy Zhang <cathy.zhang@intel.com>, linux-sgx@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>
Subject: [PATCH v7 4/7] x86/sgx: Add SGX infrastructure to recover from poison
Date:   Mon, 27 Sep 2021 14:34:49 -0700
Message-Id: <20210927213452.212470-5-tony.luck@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210927213452.212470-1-tony.luck@intel.com>
References: <20210922182123.200105-1-tony.luck@intel.com>
 <20210927213452.212470-1-tony.luck@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Provide a recovery function sgx_memory_failure(). If the poison was
consumed synchronously then send a SIGBUS. Note that the virtual
address of the access is not included with the SIGBUS as is the case
for poison outside of SGX enclaves. This doesn't matter as addresses
of code/data inside an enclave is of little to no use to code executing
outside the (now dead) enclave.

Poison found in a free page results in the page being moved from the
free list to the poison page list.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/sgx/main.c | 77 ++++++++++++++++++++++++++++++++++
 1 file changed, 77 insertions(+)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index b558c9a80af4..9931fabb29eb 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -683,6 +683,83 @@ bool arch_is_platform_page(u64 paddr)
 }
 EXPORT_SYMBOL_GPL(arch_is_platform_page);
 
+static struct sgx_epc_page *sgx_paddr_to_page(u64 paddr)
+{
+	struct sgx_epc_section *section;
+
+	section = xa_load(&sgx_epc_address_space, paddr);
+	if (!section)
+		return NULL;
+
+	return &section->pages[PFN_DOWN(paddr - section->phys_addr)];
+}
+
+/*
+ * Called in process context to handle a hardware reported
+ * error in an SGX EPC page.
+ * If the MF_ACTION_REQUIRED bit is set in flags, then the
+ * context is the task that consumed the poison data. Otherwise
+ * this is called from a kernel thread unrelated to the page.
+ */
+int arch_memory_failure(unsigned long pfn, int flags)
+{
+	struct sgx_epc_page *page = sgx_paddr_to_page(pfn << PAGE_SHIFT);
+	struct sgx_epc_section *section;
+	struct sgx_numa_node *node;
+
+	/*
+	 * mm/memory-failure.c calls this routine for all errors
+	 * where there isn't a "struct page" for the address. But that
+	 * includes other address ranges besides SGX.
+	 */
+	if (!page)
+		return -ENXIO;
+
+	/*
+	 * If poison was consumed synchronously. Send a SIGBUS to
+	 * the task. Hardware has already exited the SGX enclave and
+	 * will not allow re-entry to an enclave that has a memory
+	 * error. The signal may help the task understand why the
+	 * enclave is broken.
+	 */
+	if (flags & MF_ACTION_REQUIRED)
+		force_sig(SIGBUS);
+
+	section = &sgx_epc_sections[page->section];
+	node = section->node;
+
+	spin_lock(&node->lock);
+
+	/* Already poisoned? Nothing more to do */
+	if (page->poison)
+		goto out;
+
+	page->poison = 1;
+
+	/*
+	 * If flags is zero, then the page is on a free list.
+	 * Move it to the poison page list.
+	 */
+	if (!page->flags) {
+		list_del(&page->list);
+		list_add(&page->list, &sgx_poison_page_list);
+		goto out;
+	}
+
+	/*
+	 * TBD: Add additional plumbing to enable pre-emptive
+	 * action for asynchronous poison notification. Until
+	 * then just hope that the poison:
+	 * a) is not accessed - sgx_free_epc_page() will deal with it
+	 *    when the user gives it back
+	 * b) results in a recoverable machine check rather than
+	 *    a fatal one
+	 */
+out:
+	spin_unlock(&node->lock);
+	return 0;
+}
+
 /**
  * A section metric is concatenated in a way that @low bits 12-31 define the
  * bits 12-31 of the metric and @high bits 0-19 define the bits 32-51 of the
-- 
2.31.1

