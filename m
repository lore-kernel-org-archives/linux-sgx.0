Return-Path: <SRS0=NgZr=W6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81C8FC3A5A2
	for <linux-sgx@archiver.kernel.org>; Tue,  3 Sep 2019 18:16:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6396722CF8
	for <linux-sgx@archiver.kernel.org>; Tue,  3 Sep 2019 18:16:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727667AbfICSQx (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 3 Sep 2019 14:16:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:60464 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726973AbfICSQw (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 3 Sep 2019 14:16:52 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Sep 2019 11:16:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,464,1559545200"; 
   d="scan'208";a="184848680"
Received: from ppuente-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.53.94])
  by orsmga003.jf.intel.com with ESMTP; 03 Sep 2019 11:16:49 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH] x86/sgx: Clean up internal includes
Date:   Tue,  3 Sep 2019 21:16:35 +0300
Message-Id: <20190903181635.3937-1-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Include arch.h from sgx.h and include sgx.h from other headers. Do not
include sgx.h from .c files. This makes a sane include order. Any new
header should only need to include sgx.h. The .c files must include the
modules they use.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/kernel/cpu/sgx/driver.c  | 2 ++
 arch/x86/kernel/cpu/sgx/driver.h  | 3 ---
 arch/x86/kernel/cpu/sgx/encl.c    | 2 --
 arch/x86/kernel/cpu/sgx/encl.h    | 1 +
 arch/x86/kernel/cpu/sgx/encls.h   | 2 +-
 arch/x86/kernel/cpu/sgx/ioctl.c   | 2 ++
 arch/x86/kernel/cpu/sgx/main.c    | 3 +--
 arch/x86/kernel/cpu/sgx/reclaim.c | 3 ++-
 arch/x86/kernel/cpu/sgx/sgx.h     | 1 +
 9 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx/driver.c
index a1da479ffd3a..1ceeb742c1da 100644
--- a/arch/x86/kernel/cpu/sgx/driver.c
+++ b/arch/x86/kernel/cpu/sgx/driver.c
@@ -9,6 +9,8 @@
 #include <linux/suspend.h>
 #include <asm/traps.h>
 #include "driver.h"
+#include "encl.h"
+#include "encls.h"
 
 MODULE_DESCRIPTION("Intel SGX Enclave Driver");
 MODULE_AUTHOR("Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>");
diff --git a/arch/x86/kernel/cpu/sgx/driver.h b/arch/x86/kernel/cpu/sgx/driver.h
index 1e35933cf8a4..2f13886522a8 100644
--- a/arch/x86/kernel/cpu/sgx/driver.h
+++ b/arch/x86/kernel/cpu/sgx/driver.h
@@ -10,9 +10,6 @@
 #include <linux/sched.h>
 #include <linux/workqueue.h>
 #include <uapi/asm/sgx.h>
-#include "arch.h"
-#include "encl.h"
-#include "encls.h"
 #include "sgx.h"
 
 #define SGX_DRV_NR_DEVICES	2
diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 9bf49e30a568..1c1fbc95be33 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -7,10 +7,8 @@
 #include <linux/shmem_fs.h>
 #include <linux/suspend.h>
 #include <linux/sched/mm.h>
-#include "arch.h"
 #include "encl.h"
 #include "encls.h"
-#include "sgx.h"
 
 static int __sgx_encl_eldu(struct sgx_encl_page *encl_page,
 			   struct sgx_epc_page *epc_page,
diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
index c7608964d69e..95e5713a50ad 100644
--- a/arch/x86/kernel/cpu/sgx/encl.h
+++ b/arch/x86/kernel/cpu/sgx/encl.h
@@ -15,6 +15,7 @@
 #include <linux/radix-tree.h>
 #include <linux/srcu.h>
 #include <linux/workqueue.h>
+#include "sgx.h"
 
 /**
  * enum sgx_encl_page_desc - defines bits for an enclave page's descriptor
diff --git a/arch/x86/kernel/cpu/sgx/encls.h b/arch/x86/kernel/cpu/sgx/encls.h
index aea3b9d09936..6631afbf2f64 100644
--- a/arch/x86/kernel/cpu/sgx/encls.h
+++ b/arch/x86/kernel/cpu/sgx/encls.h
@@ -8,7 +8,7 @@
 #include <linux/rwsem.h>
 #include <linux/types.h>
 #include <asm/asm.h>
-#include "arch.h"
+#include "sgx.h"
 
 /**
  * ENCLS_FAULT_FLAG - flag signifying an ENCLS return code is a trapnr
diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index e2205a433b87..e57dda38513b 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -13,6 +13,8 @@
 #include <linux/slab.h>
 #include <linux/suspend.h>
 #include "driver.h"
+#include "encl.h"
+#include "encls.h"
 
 static struct sgx_va_page *sgx_encl_grow(struct sgx_encl *encl)
 {
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index e4f751651a65..c58ab5f28669 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -9,9 +9,8 @@
 #include <linux/sched/signal.h>
 #include <linux/slab.h>
 #include "driver.h"
-#include "arch.h"
+#include "encl.h"
 #include "encls.h"
-#include "sgx.h"
 
 struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
 int sgx_nr_epc_sections;
diff --git a/arch/x86/kernel/cpu/sgx/reclaim.c b/arch/x86/kernel/cpu/sgx/reclaim.c
index bd8ac11a4278..d82ce1eaa60e 100644
--- a/arch/x86/kernel/cpu/sgx/reclaim.c
+++ b/arch/x86/kernel/cpu/sgx/reclaim.c
@@ -10,7 +10,8 @@
 #include <linux/sched/mm.h>
 #include <linux/sched/signal.h>
 #include "driver.h"
-#include "sgx.h"
+#include "encl.h"
+#include "encls.h"
 
 struct task_struct *ksgxswapd_tsk;
 DECLARE_WAIT_QUEUE_HEAD(ksgxswapd_waitq);
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index f0ff7bd3d18e..bc6a644af2b5 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -9,6 +9,7 @@
 #include <linux/types.h>
 #include <asm/asm.h>
 #include <uapi/asm/sgx_errno.h>
+#include "arch.h"
 
 struct sgx_epc_page {
 	unsigned long desc;
-- 
2.20.1

