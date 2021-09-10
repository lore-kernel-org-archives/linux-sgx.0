Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 968F1C4321E
	for <linux-sgx@archiver.kernel.org>; Fri, 10 Sep 2021 00:45:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F4B560C40
	for <linux-sgx@archiver.kernel.org>; Fri, 10 Sep 2021 00:45:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232602AbhIJAqh (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 9 Sep 2021 20:46:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:44128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232419AbhIJAS4 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 9 Sep 2021 20:18:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB0C061212;
        Fri, 10 Sep 2021 00:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233053;
        bh=13Wxtx8dhv8/yMBbWj3kGQZLEmPK0oZNdwQ81jc+SQo=;
        h=From:To:Cc:Subject:Date:From;
        b=a5M8Ddkj5MOBLjDKwxdegK3JgQoFqGCC6bcDzj+ArBSZyCOiUG7OixmBTp/bHyuwM
         M1GRbbPfJ/9u+RO9NtcV5Kog9wA4Wxzo3oE/qgONRen+57GFVUzsI+iqVVebxxcJom
         aURPDfbR/rPf9vSJ4AKHUVk8ItiwBVBSJDxMofm5bpae/+NtFHH57TNEefv/OmdN9p
         EOzyvhFX3pYVawUomexNVYhrSJfO6lwtPF9SGAr74gyCTSjKXNWncL5gGBvJrCFali
         93Akv+ry588Bf1y0r9PunGu/qkaWoU4Tv/JFZl1jmEPqRpebl386RzIyulNzB8N/Dj
         deNiSF1o1gXCg==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/3] x86/sgx: Report SGX memory in /sys/devices/system/node/node*/meminfo
Date:   Fri, 10 Sep 2021 03:17:24 +0300
Message-Id: <20210910001726.811497-1-jarkko@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

The amount of SGX memory on the system is determined by the BIOS and it
varies wildly between systems.  It can be from dozens of MB's on desktops
or VM's, up to many GB's on servers.  Just like for regular memory, it is
sometimes useful to know the amount of usable SGX memory in the system.

Add SGX_MemTotal field to /sys/devices/system/node/node*/meminfo,
showing the total SGX memory in each NUMA node. The total memory for
each NUMA node is calculated by adding the sizes of contained EPC
sections together.

Introduce arch_node_read_meminfo(), which can optionally be rewritten by
the arch code, and rewrite it for x86 so it prints SGX_MemTotal.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
v4:
* A new patch.
 arch/x86/kernel/cpu/sgx/main.c | 14 ++++++++++++++
 arch/x86/kernel/cpu/sgx/sgx.h  |  6 ++++++
 drivers/base/node.c            | 10 +++++++++-
 3 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 63d3de02bbcc..4c6da5f4a9d4 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -717,6 +717,7 @@ static bool __init sgx_page_cache_init(void)
 		}
 
 		sgx_epc_sections[i].node =  &sgx_numa_nodes[nid];
+		sgx_numa_nodes[nid].size += size;
 
 		sgx_nr_epc_sections++;
 	}
@@ -790,6 +791,19 @@ int sgx_set_attribute(unsigned long *allowed_attributes,
 }
 EXPORT_SYMBOL_GPL(sgx_set_attribute);
 
+ssize_t arch_node_read_meminfo(struct device *dev,
+			       struct device_attribute *attr,
+			       char *buf, int len)
+{
+	struct sgx_numa_node *node = &sgx_numa_nodes[dev->id];
+
+	len += sysfs_emit_at(buf, len,
+			     "Node %d SGX_MemTotal:   %8lu kB\n",
+			     dev->id, node->size);
+
+	return len;
+}
+
 static int __init sgx_init(void)
 {
 	int ret;
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index 4628acec0009..74713b98a859 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -39,6 +39,7 @@ struct sgx_epc_page {
  */
 struct sgx_numa_node {
 	struct list_head free_page_list;
+	unsigned long size;
 	spinlock_t lock;
 };
 
@@ -95,4 +96,9 @@ static inline int __init sgx_vepc_init(void)
 
 void sgx_update_lepubkeyhash(u64 *lepubkeyhash);
 
+extern ssize_t arch_node_read_meminfo(struct device *dev,
+				      struct device_attribute *attr,
+				      char *buf, int len);
+
+
 #endif /* _X86_SGX_H */
diff --git a/drivers/base/node.c b/drivers/base/node.c
index 4a4ae868ad9f..91eaa2e2ce33 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -361,6 +361,13 @@ static void node_init_caches(unsigned int nid) { }
 static void node_remove_caches(struct node *node) { }
 #endif
 
+ssize_t __weak arch_node_read_meminfo(struct device *dev,
+				      struct device_attribute *attr,
+				      char *buf, int len)
+{
+	return len;
+}
+
 #define K(x) ((x) << (PAGE_SHIFT - 10))
 static ssize_t node_read_meminfo(struct device *dev,
 			struct device_attribute *attr, char *buf)
@@ -473,7 +480,8 @@ static ssize_t node_read_meminfo(struct device *dev,
 #endif
 			    );
 	len += hugetlb_report_node_meminfo(buf, len, nid);
-	return len;
+
+	return arch_node_read_meminfo(dev, attr, buf, len);
 }
 
 #undef K
-- 
2.25.1

