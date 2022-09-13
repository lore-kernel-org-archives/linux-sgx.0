Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D5B1C6FA82
	for <linux-sgx@archiver.kernel.org>; Tue, 13 Sep 2022 15:48:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234283AbiIMPsM (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 13 Sep 2022 11:48:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233932AbiIMPru (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 13 Sep 2022 11:47:50 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9195140B0
        for <linux-sgx@vger.kernel.org>; Tue, 13 Sep 2022 07:50:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663080606; x=1694616606;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xLQdIvKw+TfBFBdoRWK3YaiXubG6M0lN32q87y0yY6M=;
  b=GeC8SQ1Be5MBagAKSIKTZJ8QFMTXGcCP1ZHKLLLI2JKwLFKHv+za3rWN
   eRHOyZTb7OpxMJguxYAo37RrYQUJvzt3PGnvNNVxuC19NgWPZQn+WdCoo
   Y8QODUjYwQSbgSIVrHMXE9dtVcSIBaqA3VYK7nOjpEjxVGeGoH/1mveE7
   AXbowXCZmIKyqGn6ULdvPP3mNXVVJ/rLBHbhmgm+BxJ+HOTy37mmmBNT8
   5DN4wZCdswq2xNIRmDyi0SvIxc9WV8XR+tn0VFwV7gnGQErUIYRQmajzd
   XX50taD5TL5EGgB7Bvc12f7VH8myP73asCFE+p7HdJGabDDKLZobEFNaZ
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10469"; a="285176164"
X-IronPort-AV: E=Sophos;i="5.93,313,1654585200"; 
   d="scan'208";a="285176164"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2022 07:48:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,313,1654585200"; 
   d="scan'208";a="649680665"
Received: from zhiquan-linux-dev.bj.intel.com ([10.238.155.101])
  by orsmga001.jf.intel.com with ESMTP; 13 Sep 2022 07:48:06 -0700
From:   Zhiquan Li <zhiquan1.li@intel.com>
To:     linux-sgx@vger.kernel.org, tony.luck@intel.com, jarkko@kernel.org,
        dave.hansen@linux.intel.com, tglx@linutronix.de, bp@alien8.de
Cc:     seanjc@google.com, kai.huang@intel.com, fan.du@intel.com,
        cathy.zhang@intel.com, zhiquan1.li@intel.com
Subject: [PATCH v8 3/3] x86/sgx: Fine grained SGX MCA behavior for virtualization
Date:   Tue, 13 Sep 2022 22:53:30 +0800
Message-Id: <20220913145330.2998212-4-zhiquan1.li@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220913145330.2998212-1-zhiquan1.li@intel.com>
References: <20220913145330.2998212-1-zhiquan1.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Today, if a guest accesses an SGX EPC page with memory failure,
the kernel behavior will kill the entire guest.  This blast
radius is too large.  It would be idea to kill only the SGX
application inside the guest.

To fix this, send a SIGBUS to host userspace (like QEMU) which can
follow up by injecting a #MC to the guest.

SGX virtual EPC driver doesn't explicitly prevent virtual EPC instance
being shared by multiple VMs via fork().  However KVM doesn't support
running a VM across multiple mm structures, and the de facto userspace
hypervisor (Qemu) doesn't use fork() to create a new VM, so in practice
this should not happen.

Signed-off-by: Zhiquan Li <zhiquan1.li@intel.com>
Acked-by: Kai Huang <kai.huang@intel.com>
Link: https://lore.kernel.org/linux-sgx/443cb425-009c-2784-56f4-5e707122de76@intel.com/T/#m1d1f4098f4fad78034e8706a60e4d79c119db407
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Acked-by: Jarkko Sakkinen <jarkko@kernel.org>

---
Changes since V7:
- Add Acked-by from Jarkko.

Changes since V6:
- Fix build warning due to type changes.

Changes since V5:
- Use the 'vepc_vaddr' field instead of casting the 'owner' field.
- Clean up the commit message suggested by Dave.
  Link: https://lore.kernel.org/linux-sgx/Yrf27fugD7lkyaek@kernel.org/T/#m2ff4778948cdc9ee65f09672f1d02f8dc467247b
- Add Reviewed-by from Jarkko.

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
- Add Kai's excellent explanation regarding to why we no need to
  consider that one virtual EPC be shared by two guests.
---
 arch/x86/kernel/cpu/sgx/main.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index b319bedcaf1e..160c8dbee0ab 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -679,6 +679,8 @@ int arch_memory_failure(unsigned long pfn, int flags)
 	struct sgx_epc_page *page = sgx_paddr_to_page(pfn << PAGE_SHIFT);
 	struct sgx_epc_section *section;
 	struct sgx_numa_node *node;
+	void __user *vaddr;
+	int ret;
 
 	/*
 	 * mm/memory-failure.c calls this routine for all errors
@@ -695,8 +697,26 @@ int arch_memory_failure(unsigned long pfn, int flags)
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
+			 * The 'encl_owner' field is repurposed, when allocating EPC
+			 * page it was assigned to the virtual address of virtual EPC
+			 * page.
+			 */
+			vaddr = (void *)((unsigned long)page->vepc_vaddr & PAGE_MASK);
+			ret = force_sig_mceerr(BUS_MCEERR_AR, vaddr, PAGE_SHIFT);
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

