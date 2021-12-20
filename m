Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78042C433F5
	for <linux-sgx@archiver.kernel.org>; Mon, 20 Dec 2021 17:47:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240259AbhLTRro (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 20 Dec 2021 12:47:44 -0500
Received: from mga17.intel.com ([192.55.52.151]:9236 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232037AbhLTRrn (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 20 Dec 2021 12:47:43 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10203"; a="220909222"
X-IronPort-AV: E=Sophos;i="5.88,221,1635231600"; 
   d="scan'208";a="220909222"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2021 09:46:54 -0800
X-IronPort-AV: E=Sophos;i="5.88,221,1635231600"; 
   d="scan'208";a="586393013"
Received: from kcaccard-mobl.amr.corp.intel.com (HELO kcaccard-mobl1.jf.intel.com) ([10.212.42.105])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2021 09:46:53 -0800
From:   Kristen Carlson Accardi <kristen@linux.intel.com>
To:     linux-sgx@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 1/2] x86/sgx: Add accounting for tracking overcommit
Date:   Mon, 20 Dec 2021 09:46:39 -0800
Message-Id: <20211220174640.7542-2-kristen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20211220174640.7542-1-kristen@linux.intel.com>
References: <20211220174640.7542-1-kristen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

When the system runs out of enclave memory, SGX can reclaim EPC pages
by swapping to normal RAM. This normal RAM is allocated via a
per-enclave shared memory area. The shared memory area is not mapped
into the enclave or the task mapping it, which makes its memory use
opaque (including to the OOM killer). Having lots of hard to find
memory around is problematic, especially when there is no limit.

Introduce a module parameter and a global counter that can be used to limit
the number of pages that enclaves are able to consume for backing storage.
This parameter is a percentage value that is used in conjunction with the
number of EPC pages in the system to set a cap on the amount of backing
RAM that can be consumed.

The default for this value is 100, which limits the total number of
shared memory pages that may be consumed by all enclaves as backing pages
to the number of EPC pages on the system.

For example, on an SGX system that has 128MB of EPC, this default would
cap the amount of normal RAM that SGX consumes for its shared memory
areas at 128MB.

If sgx.overcommit_percent is set to a negative value (such as -1),
SGX will not place any limits on the amount of overcommit that might
be requested, and SGX will behave as it has previously without the
overcommit_percent limit.

SGX may not be built as a module, but the module parameter interface
is used in order to provide a convenient interface.

The SGX overcommit_percent works differently than the core VM overcommit
limit. Enclaves request backing pages one page at a time, and the number
of in use backing pages that are allowed is a global resource that is
limited for all enclaves.

Introduce a pair of functions which can be used by callers when requesting
backing RAM pages. These functions are responsible for accounting the
page charges. A request may return an error if the request will cause the
counter to exceed the backing page cap.

Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
---
 .../admin-guide/kernel-parameters.txt         |  7 ++
 Documentation/x86/sgx.rst                     | 16 ++++-
 arch/x86/kernel/cpu/sgx/Makefile              |  6 +-
 arch/x86/kernel/cpu/sgx/main.c                | 64 +++++++++++++++++++
 arch/x86/kernel/cpu/sgx/sgx.h                 |  2 +
 5 files changed, 93 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 9725c546a0d4..9d23c05a833b 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -5165,6 +5165,13 @@
 
 	serialnumber	[BUGS=X86-32]
 
+	sgx.overcommit_percent=	[X86-64,SGX]
+			Limits the amount of normal RAM used for backing
+			storage that may be allocate, expressed as a
+			percentage of the total number of EPC pages in the
+			system.
+			See Documentation/x86/sgx.rst for more information.
+
 	shapers=	[NET]
 			Maximal number of shapers.
 
diff --git a/Documentation/x86/sgx.rst b/Documentation/x86/sgx.rst
index 265568a9292c..4f9a1c68be94 100644
--- a/Documentation/x86/sgx.rst
+++ b/Documentation/x86/sgx.rst
@@ -147,7 +147,21 @@ Page reclaimer
 
 Similar to the core kswapd, ksgxd, is responsible for managing the
 overcommitment of enclave memory.  If the system runs out of enclave memory,
-*ksgxd* “swaps” enclave memory to normal memory.
+*ksgxd* “swaps” enclave memory to normal RAM. This normal RAM is allocated
+via per enclave shared memory. The shared memory area is not mapped into the
+enclave or the task mapping it, which makes its memory use opaque - including
+to the system out of memory killer (OOM). This can be problematic when there
+are no limits in place on the amount an enclave can allocate.
+
+At boot time, the module parameter "sgx.overcommit_percent" can be used to
+place a limit on the number of shared memory backing pages that may be
+allocated, expressed as a percentage of the total number of EPC pages in the
+system.  A value of 100 is the default, and represents a limit equal to the
+number of EPC pages in the system. To disable the limit, set
+sgx.overcommit_percent to -1. The number of backing pages available to
+enclaves is a global resource. If the system exceeds the number of allowed
+backing pages in use, the reclaimer will be unable to swap EPC pages to
+shared memory.
 
 Launch Control
 ==============
diff --git a/arch/x86/kernel/cpu/sgx/Makefile b/arch/x86/kernel/cpu/sgx/Makefile
index 9c1656779b2a..72f9192a43fe 100644
--- a/arch/x86/kernel/cpu/sgx/Makefile
+++ b/arch/x86/kernel/cpu/sgx/Makefile
@@ -1,6 +1,10 @@
-obj-y += \
+# This allows sgx to have module namespace
+obj-y += sgx.o
+
+sgx-y += \
 	driver.o \
 	encl.o \
 	ioctl.o \
 	main.o
+
 obj-$(CONFIG_X86_SGX_KVM)	+= virt.o
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 2857a49f2335..c58ce9d9fd56 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /*  Copyright(c) 2016-20 Intel Corporation. */
 
+#include <linux/moduleparam.h>
 #include <linux/file.h>
 #include <linux/freezer.h>
 #include <linux/highmem.h>
@@ -43,6 +44,54 @@ static struct sgx_numa_node *sgx_numa_nodes;
 
 static LIST_HEAD(sgx_dirty_page_list);
 
+/*
+ * Limits the amount of normal RAM that SGX can consume for EPC
+ * overcommit to the total EPC pages * sgx_overcommit_percent / 100
+ */
+static int sgx_overcommit_percent = 100;
+module_param_named(overcommit_percent, sgx_overcommit_percent, int, 0440);
+MODULE_PARM_DESC(overcommit_percent, "Percentage of overcommit of EPC pages.");
+
+/* The number of pages that can be allocated globally for backing storage. */
+static atomic_long_t sgx_nr_available_backing_pages;
+static bool sgx_disable_overcommit_tracking;
+
+/**
+ * sgx_charge_mem() - charge for a page used for backing storage
+ *
+ * Backing storage usage is capped by the sgx_nr_available_backing_pages.
+ * If the backing storage usage is over the overcommit limit,
+ * return an error.
+ *
+ * Return:
+ * 0:		The page requested does not exceed the limit
+ * -ENOMEM:	The page requested exceeds the overcommit limit
+ */
+int sgx_charge_mem(void)
+{
+	if (sgx_disable_overcommit_tracking)
+		return 0;
+
+	if (!atomic_long_add_unless(&sgx_nr_available_backing_pages, -1, 0))
+		return -ENOMEM;
+
+	return 0;
+}
+
+/**
+ * sgx_uncharge_mem() - uncharge a page previously used for backing storage
+ *
+ * When backing storage is no longer in use, increment the
+ * sgx_nr_available_backing_pages counter.
+ */
+void sgx_uncharge_mem(void)
+{
+	if (sgx_disable_overcommit_tracking)
+		return;
+
+	atomic_long_inc(&sgx_nr_available_backing_pages);
+}
+
 /*
  * Reset post-kexec EPC pages to the uninitialized state. The pages are removed
  * from the input list, and made available for the page allocator. SECS pages
@@ -786,6 +835,7 @@ static bool __init sgx_page_cache_init(void)
 	u64 pa, size;
 	int nid;
 	int i;
+	u64 total_epc_bytes = 0;
 
 	sgx_numa_nodes = kmalloc_array(num_possible_nodes(), sizeof(*sgx_numa_nodes), GFP_KERNEL);
 	if (!sgx_numa_nodes)
@@ -830,6 +880,7 @@ static bool __init sgx_page_cache_init(void)
 
 		sgx_epc_sections[i].node =  &sgx_numa_nodes[nid];
 		sgx_numa_nodes[nid].size += size;
+		total_epc_bytes += size;
 
 		sgx_nr_epc_sections++;
 	}
@@ -839,6 +890,19 @@ static bool __init sgx_page_cache_init(void)
 		return false;
 	}
 
+	if (sgx_overcommit_percent >= 0) {
+		u64 available_backing_bytes;
+
+		available_backing_bytes =
+			total_epc_bytes * (sgx_overcommit_percent / 100);
+
+		atomic_long_set(&sgx_nr_available_backing_pages,
+				available_backing_bytes >> PAGE_SHIFT);
+	} else {
+		pr_info("Disabling overcommit limit.\n");
+		sgx_disable_overcommit_tracking = true;
+	}
+
 	return true;
 }
 
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index 0f17def9fe6f..3507a9983fc1 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -89,6 +89,8 @@ void sgx_free_epc_page(struct sgx_epc_page *page);
 void sgx_mark_page_reclaimable(struct sgx_epc_page *page);
 int sgx_unmark_page_reclaimable(struct sgx_epc_page *page);
 struct sgx_epc_page *sgx_alloc_epc_page(void *owner, bool reclaim);
+int sgx_charge_mem(void);
+void sgx_uncharge_mem(void);
 
 #ifdef CONFIG_X86_SGX_KVM
 int __init sgx_vepc_init(void);
-- 
2.20.1

