Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CF01C43219
	for <linux-sgx@archiver.kernel.org>; Fri,  1 Oct 2021 16:47:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8D7661AD0
	for <linux-sgx@archiver.kernel.org>; Fri,  1 Oct 2021 16:47:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354807AbhJAQtR (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 1 Oct 2021 12:49:17 -0400
Received: from mga11.intel.com ([192.55.52.93]:19803 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355232AbhJAQtR (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 1 Oct 2021 12:49:17 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10124"; a="222290389"
X-IronPort-AV: E=Sophos;i="5.85,339,1624345200"; 
   d="scan'208";a="222290389"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2021 09:47:32 -0700
X-IronPort-AV: E=Sophos;i="5.85,339,1624345200"; 
   d="scan'208";a="540357504"
Received: from agluck-desk2.sc.intel.com ([10.3.52.146])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2021 09:47:32 -0700
From:   Tony Luck <tony.luck@intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@intel.com>
Cc:     Cathy Zhang <cathy.zhang@intel.com>, linux-sgx@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>
Subject: [PATCH v8 5/7] x86/sgx: Hook arch_memory_failure() into mainline code
Date:   Fri,  1 Oct 2021 09:47:22 -0700
Message-Id: <20211001164724.220532-6-tony.luck@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211001164724.220532-1-tony.luck@intel.com>
References: <20210927213452.212470-1-tony.luck@intel.com>
 <20211001164724.220532-1-tony.luck@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Add a call inside memory_failure() to call the arch specific code
to check if the address is an SGX EPC page and handle it.

Note the SGX EPC pages do not have a "struct page" entry, so the hook
goes in at the same point as the device mapping hook.

Pull the call to acquire the mutex earlier so the SGX errors are also
protected.

Make set_mce_nospec() skip SGX pages when trying to adjust
the 1:1 map.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/include/asm/processor.h  |  8 ++++++++
 arch/x86/include/asm/set_memory.h |  4 ++++
 include/linux/mm.h                | 14 ++++++++++++++
 mm/memory-failure.c               | 19 +++++++++++++------
 4 files changed, 39 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 9ad2acaaae9b..4865f2860a4f 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -853,4 +853,12 @@ enum mds_mitigations {
 	MDS_MITIGATION_VMWERV,
 };
 
+#ifdef CONFIG_X86_SGX
+int arch_memory_failure(unsigned long pfn, int flags);
+#define arch_memory_failure arch_memory_failure
+
+bool arch_is_platform_page(u64 paddr);
+#define arch_is_platform_page arch_is_platform_page
+#endif
+
 #endif /* _ASM_X86_PROCESSOR_H */
diff --git a/arch/x86/include/asm/set_memory.h b/arch/x86/include/asm/set_memory.h
index 43fa081a1adb..ce8dd215f5b3 100644
--- a/arch/x86/include/asm/set_memory.h
+++ b/arch/x86/include/asm/set_memory.h
@@ -2,6 +2,7 @@
 #ifndef _ASM_X86_SET_MEMORY_H
 #define _ASM_X86_SET_MEMORY_H
 
+#include <linux/mm.h>
 #include <asm/page.h>
 #include <asm-generic/set_memory.h>
 
@@ -98,6 +99,9 @@ static inline int set_mce_nospec(unsigned long pfn, bool unmap)
 	unsigned long decoy_addr;
 	int rc;
 
+	/* SGX pages are not in the 1:1 map */
+	if (arch_is_platform_page(pfn << PAGE_SHIFT))
+		return 0;
 	/*
 	 * We would like to just call:
 	 *      set_memory_XX((unsigned long)pfn_to_kaddr(pfn), 1);
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 73a52aba448f..62b199ed5ec6 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3284,5 +3284,19 @@ static inline int seal_check_future_write(int seals, struct vm_area_struct *vma)
 	return 0;
 }
 
+#ifndef arch_memory_failure
+static inline int arch_memory_failure(unsigned long pfn, int flags)
+{
+	return -ENXIO;
+}
+#endif
+
+#ifndef arch_is_platform_page
+static inline bool arch_is_platform_page(u64 paddr)
+{
+	return false;
+}
+#endif
+
 #endif /* __KERNEL__ */
 #endif /* _LINUX_MM_H */
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 3e6449f2102a..b1cbf9845c19 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1632,21 +1632,28 @@ int memory_failure(unsigned long pfn, int flags)
 	if (!sysctl_memory_failure_recovery)
 		panic("Memory failure on page %lx", pfn);
 
+	mutex_lock(&mf_mutex);
+
 	p = pfn_to_online_page(pfn);
 	if (!p) {
+		res = arch_memory_failure(pfn, flags);
+		if (res == 0)
+			goto unlock_mutex;
+
 		if (pfn_valid(pfn)) {
 			pgmap = get_dev_pagemap(pfn, NULL);
-			if (pgmap)
-				return memory_failure_dev_pagemap(pfn, flags,
-								  pgmap);
+			if (pgmap) {
+				res = memory_failure_dev_pagemap(pfn, flags,
+								 pgmap);
+				goto unlock_mutex;
+			}
 		}
 		pr_err("Memory failure: %#lx: memory outside kernel control\n",
 			pfn);
-		return -ENXIO;
+		res = -ENXIO;
+		goto unlock_mutex;
 	}
 
-	mutex_lock(&mf_mutex);
-
 try_again:
 	if (PageHuge(p)) {
 		res = memory_failure_hugetlb(pfn, flags);
-- 
2.31.1

