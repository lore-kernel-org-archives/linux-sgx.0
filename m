Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5278BC433ED
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Apr 2021 23:27:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1B439613E0
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Apr 2021 23:27:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239143AbhDEX1J (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 5 Apr 2021 19:27:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:54212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238911AbhDEX1I (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 5 Apr 2021 19:27:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4465B613D7;
        Mon,  5 Apr 2021 23:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617665221;
        bh=Y886IjyRX5aP5hJlazZkcZYOJ7hRgAHc76XKZogWyYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S2sJDiGViqNvl2AJ9NLgbY/wq3AYq5j/nFPhd5FTR8AVL+VZAgfJLdURYVeLtuSY8
         fVt/ZZEoDPAVAQlUWUBYLmXeeYc4tHCCzmWiUv/63Irgs9ztvPt2mf8IfqUMLomV86
         rCsBeeuEUvDk4MhxtEgjIG+flFe0KfiHV1asGwzGAeRrfe9sDO87zAXEt4Tao7WwvH
         /tjp11v36JOg6PCv7PxJLb+/rGi6kEy2E4O/FgokSCA/Lgz4PP/1oE1TItvZSDhBTW
         iu7CoAEBYoeUd4lnzSoAc0CPyiRVjA0cUo2YayAb6iOPNzN6bnJmZmgCkNKR1j1a+O
         RZk6ShD/ha98g==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] x86/sgx: Add sgx_nr_{all, free}_pages to the debugfs
Date:   Tue,  6 Apr 2021 02:26:53 +0300
Message-Id: <20210405232653.33680-2-jarkko@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405232653.33680-1-jarkko@kernel.org>
References: <20210405232653.33680-1-jarkko@kernel.org>
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

v2:
* Use debugfs_create_ulong():
  https://lore.kernel.org/linux-sgx/57c18e08-3e36-b5b3-aaba-9a21b75a1613@intel.com/

 arch/x86/kernel/cpu/sgx/main.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 7df7048cb1c9..07bad864c531 100644
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
 
@@ -750,6 +756,11 @@ static int __init sgx_init(void)
 	if (ret)
 		goto err_kthread;
 
+#ifdef CONFIG_DEBUG_FS
+	debugfs_create_ulong("sgx_nr_all_pages", 0400, arch_debugfs_dir, NULL, &sgx_nr_all_pages);
+	debugfs_create_ulong("sgx_nr_free_pages", 0400, arch_debugfs_dir, NULL, &sgx_nr_free_pages);
+#endif /* CONFIG_DEBUG_FS */
+
 	return 0;
 
 err_kthread:
-- 
2.31.1

