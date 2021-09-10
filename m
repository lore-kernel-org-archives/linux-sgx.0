Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FC7CC433F5
	for <linux-sgx@archiver.kernel.org>; Fri, 10 Sep 2021 00:45:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78FA06115A
	for <linux-sgx@archiver.kernel.org>; Fri, 10 Sep 2021 00:45:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232103AbhIJAqi (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 9 Sep 2021 20:46:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:44506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232453AbhIJAS5 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 9 Sep 2021 20:18:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E0356115A;
        Fri, 10 Sep 2021 00:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233056;
        bh=N7VryCQb/YIXbsKUrHSlN8c3f2IOZpt0Z9Ky/nPZQZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hwYt2LTBXN4RVzqX8Cxi2NYUBY9sFoXXSwBO75Sw16lHlsUh1jM6Dr3yGc9QP7yIm
         JoDlpmM6oszNZ7JRKilf0wVlSfRnGTVV5iWaQeBvTlhuM32k41qcf2xuDdIWwSj3Ug
         qmr8FyO9I9m+d30mM/37GYVoVJ4WHkwgZDaWcPL/9Ryee2e14Vv4CB4uyw3IwYvFQb
         HszYgVHtDoiYBE6ZiBZsVQ5Av2ibl/+aQK1jaP9IptJ5UhiSq5RrmVzAXwDSHzvf+g
         xhxVhHNNJg7TjKrT5YAW3lszY/dWC+paPK6SkZWNVK1LpTGE3QV+D/ssR2A4mhMa6r
         x8L+bmKmWCjOg==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/3] x86/sgx: Report SGX memory in /proc/meminfo
Date:   Fri, 10 Sep 2021 03:17:25 +0300
Message-Id: <20210910001726.811497-2-jarkko@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210910001726.811497-1-jarkko@kernel.org>
References: <20210910001726.811497-1-jarkko@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

The amount of SGX memory on the system is determined by the BIOS and it
varies wildly between systems.  It can be from dozens of MB's on desktops
or VM's, up to many GB's on servers.  Just like for regular memory, it is
sometimes useful to know the amount of usable SGX memory in the system.

Add SGX_MemTotal field to /proc/meminfo, which shows the total amount of
usable SGX memory in the system.  E.g. with 32 MB reserved for SGX from
BIOS, the printout would be:

SGX_MemTotal:      22528 kB

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
v4:
* Calculate sgx_mem_total by adding up the sizes of the NUMA node
  EPC's, only once all of them have been set up correctly.
* Move documentation to a separate patch, as it clearly is a
  separate issue.
v2:
* Move ifdef fix for sgx_set_attribute() to a separate patch.
---
 arch/x86/include/asm/sgx.h     |  2 ++
 arch/x86/kernel/cpu/sgx/main.c | 10 ++++++++--
 arch/x86/mm/pat/set_memory.c   |  5 +++++
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
index 05f3e21f01a7..65124b05c145 100644
--- a/arch/x86/include/asm/sgx.h
+++ b/arch/x86/include/asm/sgx.h
@@ -365,6 +365,8 @@ struct sgx_sigstruct {
  * comment!
  */
 
+extern unsigned long sgx_mem_total;
+
 #ifdef CONFIG_X86_SGX_KVM
 int sgx_virt_ecreate(struct sgx_pageinfo *pageinfo, void __user *secs,
 		     int *trapnr);
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 4c6da5f4a9d4..d8f5769e4004 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -28,7 +28,10 @@ static DECLARE_WAIT_QUEUE_HEAD(ksgxd_waitq);
 static LIST_HEAD(sgx_active_page_list);
 static DEFINE_SPINLOCK(sgx_reclaimer_lock);
 
-/* The free page list lock protected variables prepend the lock. */
+/* Total size of the Enclave Page Cache (EPC) in the system. */
+unsigned long sgx_mem_total;
+
+/* The number of free EPC pages in all nodes. */
 static unsigned long sgx_nr_free_pages;
 
 /* Nodes with one or more EPC sections. */
@@ -727,6 +730,9 @@ static bool __init sgx_page_cache_init(void)
 		return false;
 	}
 
+	for (i = 0; i < num_possible_nodes(); i++)
+		sgx_mem_total += sgx_numa_nodes[nid].size;
+
 	return true;
 }
 
@@ -799,7 +805,7 @@ ssize_t arch_node_read_meminfo(struct device *dev,
 
 	len += sysfs_emit_at(buf, len,
 			     "Node %d SGX_MemTotal:   %8lu kB\n",
-			     dev->id, node->size);
+			     dev->id, node->size / 1024);
 
 	return len;
 }
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index ad8a5c586a35..b55ea89df801 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -29,6 +29,7 @@
 #include <asm/proto.h>
 #include <asm/memtype.h>
 #include <asm/set_memory.h>
+#include <asm/sgx.h>
 
 #include "../mm_internal.h"
 
@@ -116,6 +117,10 @@ void arch_report_meminfo(struct seq_file *m)
 	if (direct_gbpages)
 		seq_printf(m, "DirectMap1G:    %8lu kB\n",
 			direct_pages_count[PG_LEVEL_1G] << 20);
+
+#if defined(CONFIG_X86_SGX) || defined(CONFIG_X86_SGX_KVM)
+	seq_printf(m, "SGX_MemTotal:   %8lu kB\n", sgx_mem_total / 1024);
+#endif
 }
 #else
 static inline void split_page_count(int level) { }
-- 
2.25.1

