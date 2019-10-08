Return-Path: <SRS0=MdAf=YB=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F9B4C10F14
	for <linux-sgx@archiver.kernel.org>; Tue,  8 Oct 2019 04:12:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F83120684
	for <linux-sgx@archiver.kernel.org>; Tue,  8 Oct 2019 04:12:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729897AbfJHEM2 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 8 Oct 2019 00:12:28 -0400
Received: from mga03.intel.com ([134.134.136.65]:1148 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725858AbfJHEM2 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 8 Oct 2019 00:12:28 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Oct 2019 21:12:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,269,1566889200"; 
   d="scan'208";a="197581667"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga006.jf.intel.com with ESMTP; 07 Oct 2019 21:12:27 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH 2/2] x86/sgx: Revert moving sgx_init() call to sgx_detect()
Date:   Mon,  7 Oct 2019 21:12:26 -0700
Message-Id: <20191008041226.2974-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191008041226.2974-1-sean.j.christopherson@intel.com>
References: <20191008041226.2974-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Calling sgx_init() from sgx_detect() causes panic during early boot
because sgx_init() is intended to be run only on the boot CPU, whereas
init_intel() and thus sgx_detect() is run on every CPU, including
hotplugged CPUs.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/sgx.h        |  7 -------
 arch/x86/kernel/cpu/intel.c       |  5 -----
 arch/x86/kernel/cpu/sgx/main.c    | 16 +++++++++-------
 arch/x86/kernel/cpu/sgx/reclaim.c |  2 +-
 arch/x86/kernel/cpu/sgx/sgx.h     |  2 +-
 5 files changed, 11 insertions(+), 21 deletions(-)
 delete mode 100644 arch/x86/include/asm/sgx.h

diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
deleted file mode 100644
index a450b1550768..000000000000
--- a/arch/x86/include/asm/sgx.h
+++ /dev/null
@@ -1,7 +0,0 @@
-/* SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause) */
-#ifndef _X86_ASM_SGX_H
-#define _X86_ASM_SGX_H
-
-void sgx_init(void);
-
-#endif /* _X86_ASM_SGX_H */
diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 5b6786710295..89a71367716c 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -31,10 +31,6 @@
 #include <asm/apic.h>
 #endif
 
-#ifdef CONFIG_INTEL_SGX
-#include <asm/sgx.h>
-#endif
-
 /*
  * Just in case our CPU detection goes bad, or you have a weird system,
  * allow a way to override the automatic disabling of MPX.
@@ -653,7 +649,6 @@ static void __maybe_unused detect_sgx(struct cpuinfo_x86 *c)
 		goto err_msrs_rdonly;
 	}
 
-	sgx_init();
 	return;
 
 err_unsupported:
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 5638270c6edf..426f8b21f04c 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -158,7 +158,7 @@ void sgx_free_page(struct sgx_epc_page *page)
 	WARN(ret > 0, "sgx: EREMOVE returned %d (0x%x)", ret, ret);
 }
 
-static void sgx_free_epc_section(struct sgx_epc_section *section)
+static void __init sgx_free_epc_section(struct sgx_epc_section *section)
 {
 	struct sgx_epc_page *page;
 
@@ -179,8 +179,9 @@ static void sgx_free_epc_section(struct sgx_epc_section *section)
 	memunmap(section->va);
 }
 
-static bool sgx_alloc_epc_section(u64 addr, u64 size, unsigned long index,
-				  struct sgx_epc_section *section)
+static bool __init sgx_alloc_epc_section(u64 addr, u64 size,
+					 unsigned long index,
+					 struct sgx_epc_section *section)
 {
 	unsigned long nr_pages = size >> PAGE_SHIFT;
 	struct sgx_epc_page *page;
@@ -212,7 +213,7 @@ static bool sgx_alloc_epc_section(u64 addr, u64 size, unsigned long index,
 	return false;
 }
 
-static void sgx_page_cache_teardown(void)
+static void __init sgx_page_cache_teardown(void)
 {
 	int i;
 
@@ -225,13 +226,13 @@ static void sgx_page_cache_teardown(void)
  * bits 12-31 of the metric and @high bits 0-19 define the bits 32-51 of the
  * metric.
  */
-static inline u64 sgx_calc_section_metric(u64 low, u64 high)
+static inline u64 __init sgx_calc_section_metric(u64 low, u64 high)
 {
 	return (low & GENMASK_ULL(31, 12)) +
 	       ((high & GENMASK_ULL(19, 0)) << 32);
 }
 
-static bool sgx_page_cache_init(void)
+static bool __init sgx_page_cache_init(void)
 {
 	u32 eax, ebx, ecx, edx, type;
 	u64 pa, size;
@@ -278,7 +279,7 @@ static bool sgx_page_cache_init(void)
 	return true;
 }
 
-void sgx_init(void)
+static void __init sgx_init(void)
 {
 	int ret;
 
@@ -303,3 +304,4 @@ void sgx_init(void)
 err_page_cache:
 	sgx_page_cache_teardown();
 }
+arch_initcall(sgx_init);
diff --git a/arch/x86/kernel/cpu/sgx/reclaim.c b/arch/x86/kernel/cpu/sgx/reclaim.c
index cc3c12972e8c..391fbc3e7e98 100644
--- a/arch/x86/kernel/cpu/sgx/reclaim.c
+++ b/arch/x86/kernel/cpu/sgx/reclaim.c
@@ -97,7 +97,7 @@ static int ksgxswapd(void *p)
 	return 0;
 }
 
-bool sgx_page_reclaimer_init(void)
+bool __init sgx_page_reclaimer_init(void)
 {
 	struct task_struct *tsk;
 
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index c1bc78921af1..882ef8ba4aa9 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -76,7 +76,7 @@ extern struct wait_queue_head(ksgxswapd_waitq);
 extern struct list_head sgx_active_page_list;
 extern spinlock_t sgx_active_page_list_lock;
 
-bool sgx_page_reclaimer_init(void);
+bool __init sgx_page_reclaimer_init(void);
 void sgx_mark_page_reclaimable(struct sgx_epc_page *page);
 void sgx_reclaim_pages(void);
 
-- 
2.22.0

