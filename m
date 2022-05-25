Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3EE5C433FE
	for <linux-sgx@archiver.kernel.org>; Wed, 25 May 2022 10:07:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239941AbiEYKHO (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 25 May 2022 06:07:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240227AbiEYKHA (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 25 May 2022 06:07:00 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5743A7C15B
        for <linux-sgx@vger.kernel.org>; Wed, 25 May 2022 03:06:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653473219; x=1685009219;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+5SQ3SLkUcDLs98NxFNb5oqOB7AOCJUfqNsqKOnNVu0=;
  b=h7ouZLPUPyhyVboaAuvUO6d5CUIvOmzmB0purDL1l9G+ee5CyGkRa4a5
   T1LY6t7njZmdzmcqP7ubeTCdiL93jYWgvxug1v3lWywFC/ATqe4jB9KTY
   UpeNp41U64UE9bIrp0+mDivTDcZcjgfcVoFFs7ErFbmGn74kvgjcEiCda
   17t1mKclnc/mxGbveoI79QeVyVhA4+HFSm61e45YMrsElQDHBvXqPXD/e
   BPgHZUjvhJnzoGGF2clJ1E84fqJOcEwTuyKV23CS/N5VMHCxRRK7Ox2ye
   fxKKxo1zPYT8iY8LHwHR5XartAJ3JcM5bkeNSK2Na+QJX8xpZwwwQAe9Y
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10357"; a="336826568"
X-IronPort-AV: E=Sophos;i="5.91,250,1647327600"; 
   d="scan'208";a="336826568"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2022 03:06:48 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,250,1647327600"; 
   d="scan'208";a="717573064"
Received: from zhiquan-linux-dev.bj.intel.com ([10.238.155.101])
  by fmsmga001.fm.intel.com with ESMTP; 25 May 2022 03:06:46 -0700
From:   Zhiquan Li <zhiquan1.li@intel.com>
To:     linux-sgx@vger.kernel.org, tony.luck@intel.com
Cc:     jarkko@kernel.org, dave.hansen@linux.intel.com, seanjc@google.com,
        kai.huang@intel.com, fan.du@intel.com, zhiquan1.li@intel.com
Subject: [PATCH v3 2/3] x86/sgx: Fine grained SGX MCA behavior for virtualization
Date:   Wed, 25 May 2022 18:07:30 +0800
Message-Id: <20220525100730.760815-1-zhiquan1.li@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

When VM guest access a SGX EPC page with memory failure, current
behavior will kill the guest, expected only kill the SGX application
inside it.

To fix it we send SIGBUS with code BUS_MCEERR_AR and some extra
information for hypervisor to inject #MC information to guest, which is
helpful in SGX case.

The rest of things are guest side. Currently the hypervisor like Qemu
already has mature facility to convert HVA to GPA and inject #MC to
the guest OS.

Unlike host enclaves, virtual EPC instance cannot be shared by multiple
VMs.  It is because how enclaves are created is totally up to the guest.
Sharing virtual EPC instance will be very likely to unexpectedly break
enclaves in all VMs.

SGX virtual EPC driver doesn't explicitly prevent virtual EPC instance
being shared by multiple VMs via fork().  However KVM doesn't support
running a VM across multiple mm structures, and the de facto userspace
hypervisor (Qemu) doesn't use fork() to create a new VM, so in practice
this should not happen.

Signed-off-by: Zhiquan Li <zhiquan1.li@intel.com>
Acked-by: Kai Huang <kai.huang@intel.com>
Link: https://lore.kernel.org/linux-sgx/443cb425-009c-2784-56f4-5e707122de76@intel.com/T/#m1d1f4098f4fad78034e8706a60e4d79c119db407
---
Changes since V2:
- Retrieve virtual address from "owner" field of struct sgx_epc_page,
  instead of struct sgx_vepc_page.
- Replace EPC page flag SGX_EPC_PAGE_IS_VEPC with
  SGX_EPC_PAGE_KVM_GUEST as they are duplicated.

Changes since V1:
- Add Acked-by from Kai Huang.
- Add Kai’s excellent explanation regarding to why we no need to
  consider that one virtual EPC be shared by two guests.
---
 arch/x86/kernel/cpu/sgx/main.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index ab4ec54bbdd9..faca7f73b06d 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -715,6 +715,8 @@ int arch_memory_failure(unsigned long pfn, int flags)
 	struct sgx_epc_page *page = sgx_paddr_to_page(pfn << PAGE_SHIFT);
 	struct sgx_epc_section *section;
 	struct sgx_numa_node *node;
+	int ret = 0;
+	unsigned long vaddr;
 
 	/*
 	 * mm/memory-failure.c calls this routine for all errors
@@ -731,8 +733,26 @@ int arch_memory_failure(unsigned long pfn, int flags)
 	 * error. The signal may help the task understand why the
 	 * enclave is broken.
 	 */
-	if (flags & MF_ACTION_REQUIRED)
-		force_sig(SIGBUS);
+	if (flags & MF_ACTION_REQUIRED) {
+		/*
+		 * Provide extra info to the task so that it can make further
+		 * decision but not simply kill it. This is quite useful for
+		 * virtualization case.
+		 */
+		if (page->flags & SGX_EPC_PAGE_KVM_GUEST) {
+			/*
+			 * The "owner" field is repurposed as the virtual address
+			 * of virtual EPC page.
+			 */
+			vaddr = (unsigned long)page->owner & PAGE_MASK;
+			ret = force_sig_mceerr(BUS_MCEERR_AR, (void __user *)vaddr,
+					PAGE_SHIFT);
+			if (ret < 0)
+				pr_err("Memory failure: Error sending signal to %s:%d: %d\n",
+					current->comm, current->pid, ret);
+		} else
+			force_sig(SIGBUS);
+	}
 
 	section = &sgx_epc_sections[page->section];
 	node = section->node;
-- 
2.25.1

