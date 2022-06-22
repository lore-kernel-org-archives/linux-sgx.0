Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 637D9C433EF
	for <linux-sgx@archiver.kernel.org>; Wed, 22 Jun 2022 09:37:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238701AbiFVJhC (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 22 Jun 2022 05:37:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235328AbiFVJhC (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 22 Jun 2022 05:37:02 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 937BC3526C
        for <linux-sgx@vger.kernel.org>; Wed, 22 Jun 2022 02:37:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655890621; x=1687426621;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=y9C9ZFYorJ9n6WzhRgeGq+dOf1V5wlOyDpU0Ni3qz+E=;
  b=WFIjY9XG8WeOgzNBzBip7K5h/l37WghMX2N3L8vAIJ5UDR+n8gXjh/1L
   IchIn5CKSE8Hm9RxInTZGNZVOLx8qhikjI8JbTidk7m2j4q9NLpXNkFZ2
   iggpnmhQiAPMlpV7i2RtJMfq4mefo3WPUgb1k5/1ZHwbcIUFjrDFxw6IU
   KFeykKVLuyjgSGER2BM/bF7BjxAc+hO6E+G/uo21s6P589LEQfVfHnUj3
   3HNl5w9TF2ncjVpE6uPj83r8azfGDnne/V4TXW2UGlKZ84hfYWXi679jh
   973md21MJgUKeo+Q3NTzkssM1d5ZPlI3GMPjNQwU7bhGJSBTIbY9ohvQL
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10385"; a="281100613"
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="281100613"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 02:37:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="677448860"
Received: from zhiquan-linux-dev.bj.intel.com ([10.238.155.101])
  by FMSMGA003.fm.intel.com with ESMTP; 22 Jun 2022 02:36:58 -0700
From:   Zhiquan Li <zhiquan1.li@intel.com>
To:     linux-sgx@vger.kernel.org, tony.luck@intel.com, jarkko@kernel.org,
        dave.hansen@linux.intel.com
Cc:     seanjc@google.com, kai.huang@intel.com, fan.du@intel.com,
        cathy.zhang@intel.com, zhiquan1.li@intel.com
Subject: [PATCH v5 2/3] x86/sgx: Fine grained SGX MCA behavior for virtualization
Date:   Wed, 22 Jun 2022 17:37:04 +0800
Message-Id: <20220622093705.2891642-3-zhiquan1.li@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220622093705.2891642-1-zhiquan1.li@intel.com>
References: <20220622093705.2891642-1-zhiquan1.li@intel.com>
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
Changes since V4:
- Switch the order of the two variables so all of variables are in
  reverse Christmas style.
- Do not initialize "ret" because it will be overridden by the return
  value of force_sig_mceerr() unconditionally.

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
index ab4ec54bbdd9..4507c2302348 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -715,6 +715,8 @@ int arch_memory_failure(unsigned long pfn, int flags)
 	struct sgx_epc_page *page = sgx_paddr_to_page(pfn << PAGE_SHIFT);
 	struct sgx_epc_section *section;
 	struct sgx_numa_node *node;
+	unsigned long vaddr;
+	int ret;
 
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

