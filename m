Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2F4AC433EF
	for <linux-sgx@archiver.kernel.org>; Thu, 19 May 2022 03:11:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbiESDL0 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 18 May 2022 23:11:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233187AbiESDLH (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 18 May 2022 23:11:07 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FCFD19C2B
        for <linux-sgx@vger.kernel.org>; Wed, 18 May 2022 20:11:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652929867; x=1684465867;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=qATE11b7GpyHlmnxBnkw0BZ2d7j9s9mM9VG2qLKooUA=;
  b=Fu54qd7S2+so1RDwMAz0qj6oTG/NbMUEr+jz7DMr8yvFbhIt57TqBXTd
   +UJHkR/PjVuCb3VJhhwD9ozLNJUTYSNAN23dqJ0s3FDd6HHhJ75VijayF
   FjtcspiTf7+D6SAHuN0cOhOK+LyW3t9KGFnNVvmKypwmQoi1qeJCUxkMq
   86ZSkvM21c8onpu0MHtRAlb4Q5NJ/mAO4XDg1luFtBQSjrd06qXWYCl7g
   TwHI3pkxoOoHcTPgZaA858CtoFkmLyAUWJ3vQF/uO+FBKgcWbETIqaEgR
   /oCvstf7gSFLG739/glq3hhAZTegpRNzMtjevafKOS+X/f/rlpuPlCXln
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10351"; a="259563457"
X-IronPort-AV: E=Sophos;i="5.91,236,1647327600"; 
   d="scan'208";a="259563457"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2022 20:11:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,236,1647327600"; 
   d="scan'208";a="569928827"
Received: from zhiquan-linux-dev.bj.intel.com ([10.238.155.101])
  by orsmga007.jf.intel.com with ESMTP; 18 May 2022 20:11:03 -0700
From:   Zhiquan Li <zhiquan1.li@intel.com>
To:     linux-sgx@vger.kernel.org, tony.luck@intel.com
Cc:     jarkko@kernel.org, dave.hansen@linux.intel.com, seanjc@google.com,
        kai.huang@intel.com, fan.du@intel.com, zhiquan1.li@intel.com
Subject: [PATCH v2 3/4] x86/sgx: Fine grained SGX MCA behavior for virtualization
Date:   Thu, 19 May 2022 11:11:51 +0800
Message-Id: <20220519031151.245830-1-zhiquan1.li@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
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
---
Changes since V1:
- Add Acked-by tag from Kai Huang.
- Add Kai's excellent explanation for one virtual EPC be shared by two
  guests case.
---
 arch/x86/kernel/cpu/sgx/main.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 8e4bc6453d26..81801ab0009e 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -710,6 +710,8 @@ int arch_memory_failure(unsigned long pfn, int flags)
 	struct sgx_epc_page *page = sgx_paddr_to_page(pfn << PAGE_SHIFT);
 	struct sgx_epc_section *section;
 	struct sgx_numa_node *node;
+	struct sgx_vepc_page *owner;
+	int ret = 0;
 
 	/*
 	 * mm/memory-failure.c calls this routine for all errors
@@ -726,8 +728,22 @@ int arch_memory_failure(unsigned long pfn, int flags)
 	 * error. The signal may help the task understand why the
 	 * enclave is broken.
 	 */
-	if (flags & MF_ACTION_REQUIRED)
-		force_sig(SIGBUS);
+	if (flags & MF_ACTION_REQUIRED) {
+		/*
+		 * In case the error memory is accessed by VM guest, provide
+		 * extra info for hypervisor to make further decision but not
+		 * simply kill it.
+		 */
+		if (page->flags & SGX_EPC_PAGE_IS_VEPC) {
+			owner = (struct sgx_vepc_page *)page->owner;
+			ret = force_sig_mceerr(BUS_MCEERR_AR, (void __user *)owner->vaddr,
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

