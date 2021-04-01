Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1CA7C433ED
	for <linux-sgx@archiver.kernel.org>; Thu,  1 Apr 2021 05:22:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C70D46108F
	for <linux-sgx@archiver.kernel.org>; Thu,  1 Apr 2021 05:22:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233050AbhDAFVj (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 1 Apr 2021 01:21:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:34114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229539AbhDAFVV (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 1 Apr 2021 01:21:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5AC1610CA;
        Thu,  1 Apr 2021 05:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617254481;
        bh=aZlTgvdgxi7mu7zwFr8/ricqUERPZgBJ83RR4dcDMMo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xgdty5ybBFFIskzjePyzAdOSumnh9s6IgtWYOvVdqKlrqE40MPwRnAfVNxiMcVSni
         fAYDVezsPBM7d9y6PnsC7N4hXuF4caG8VNOVwnaG2PBmy1duAyWbBEspIe+vLTHirx
         aVsxC2N3AnoPTQQKtYV1s7KMBA3Yw0+PPYTVmDEs6c8W1m+fQLuAJAbVNf+OR2ONow
         sM0QIGXGMbZLn1qFbvLLrxtQmqI44aD8DELLyzEjOgoJhlqv4k+4H1ejRq2oXigZ8i
         SsurknolYnxmJoaCDDx6NWlqFl2JoIKCt0bChxfxHne1Cin/+zufT6cUiNM8L4oYLY
         vdHT0+iWifFIQ==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] x86/sgx: Add sgx_nr_{all, free}_pages to the debugfs
Date:   Thu,  1 Apr 2021 08:21:14 +0300
Message-Id: <20210401052114.697432-2-jarkko@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210401052114.697432-1-jarkko@kernel.org>
References: <20210401052114.697432-1-jarkko@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Add two debugs attributes:

* /sys/kernel/debug/x86/sgx_nr_all_pages
* /sys/kernel/debug/x86/sgx_nr_free_pages

These provide useful statistics for testing purposes.

E.g. on a NUC7CJYH2, when no enclaves are running, and EPC set to 32 MB:

$ sudo cat /sys/kernel/debug/x86/sgx_nr_all_pages
5632

$ sudo cat /sys/kernel/debug/x86/sgx_nr_free_pages
5632

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 arch/x86/kernel/cpu/sgx/main.c | 53 +++++++++++++++++++++++++++++++++-
 1 file changed, 52 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 7df7048cb1c9..190c96735c9f 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /*  Copyright(c) 2016-20 Intel Corporation. */
 
+#include <linux/debugfs.h>
 #include <linux/freezer.h>
 #include <linux/highmem.h>
 #include <linux/kthread.h>
@@ -25,7 +26,10 @@ static DECLARE_WAIT_QUEUE_HEAD(ksgxd_waitq);
 static LIST_HEAD(sgx_active_page_list);
 static DEFINE_SPINLOCK(sgx_reclaimer_lock);
 
-/* The free page list lock protected variables prepend the lock. */
+/* The number of EPC pages in total in all nodes. */
+static unsigned long sgx_nr_all_pages;
+
+/* The number of free EPC pages in all nodes. */
 static unsigned long sgx_nr_free_pages;
 
 /* Nodes with one or more EPC sections. */
@@ -657,6 +661,8 @@ static bool __init sgx_setup_epc_section(u64 phys_addr, u64 size,
 		list_add_tail(&section->pages[i].list, &sgx_dirty_page_list);
 	}
 
+	sgx_nr_all_pages += nr_pages;
+
 	return true;
 }
 
@@ -730,6 +736,44 @@ static bool __init sgx_page_cache_init(void)
 	return true;
 }
 
+#ifdef CONFIG_DEBUG_FS
+static ssize_t sgx_nr_all_pages_read(struct file *file, char __user *user_buf,
+				     size_t count, loff_t *pos)
+{
+	char kernel_buf[32];
+	int len;
+
+	len = snprintf(kernel_buf, sizeof(kernel_buf), "%lu\n", sgx_nr_all_pages);
+	if (len < 0)
+		return len;
+
+	return simple_read_from_buffer(user_buf, count, pos, kernel_buf, len);
+}
+
+static const struct file_operations sgx_nr_all_pages_fops = {
+	.read = sgx_nr_all_pages_read,
+	.llseek = default_llseek,
+};
+
+static ssize_t sgx_nr_free_pages_read(struct file *file, char __user *user_buf,
+				     size_t count, loff_t *pos)
+{
+	char kernel_buf[32];
+	int len;
+
+	len = snprintf(kernel_buf, sizeof(kernel_buf), "%lu\n", sgx_nr_free_pages);
+	if (len < 0)
+		return len;
+
+	return simple_read_from_buffer(user_buf, count, pos, kernel_buf, len);
+}
+
+static const struct file_operations sgx_nr_free_pages_fops = {
+	.read = sgx_nr_free_pages_read,
+	.llseek = default_llseek,
+};
+#endif /* CONFIG_DEBUG_FS */
+
 static int __init sgx_init(void)
 {
 	int ret;
@@ -750,6 +794,13 @@ static int __init sgx_init(void)
 	if (ret)
 		goto err_kthread;
 
+#ifdef CONFIG_DEBUG_FS
+	debugfs_create_file("sgx_nr_all_pages", 0400, arch_debugfs_dir, NULL,
+			    &sgx_nr_all_pages_fops);
+	debugfs_create_file("sgx_nr_free_pages", 0400, arch_debugfs_dir, NULL,
+			    &sgx_nr_free_pages_fops);
+#endif /* CONFIG_DEBUG_FS */
+
 	return 0;
 
 err_kthread:
-- 
2.31.1

