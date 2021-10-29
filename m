Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAA5DC433EF
	for <linux-sgx@archiver.kernel.org>; Fri, 29 Oct 2021 12:19:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D08C461175
	for <linux-sgx@archiver.kernel.org>; Fri, 29 Oct 2021 12:19:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231530AbhJ2MVo (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 29 Oct 2021 08:21:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:40476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231504AbhJ2MVi (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 29 Oct 2021 08:21:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6D2D61177;
        Fri, 29 Oct 2021 12:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635509947;
        bh=9Yd0Xbp5WGgVpi8fnDAMNdT+MwTu+rc4xjEJjz8SEYU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=daG1Hgx19IaEhdcCcx96zIvFY/GbIWIQCJThBFGNlY44fCA+V/bH+peDJLuKY6wat
         aWStrztHTwYJBGl1jMYLCJtEEIzLnzVuwZG3AsLL+rsti9aOLKOe4fqVtFH6ee+4s3
         q83f/JShhBKbaFjvL/WR8TBJm0+HQiTAUl35EOcwRuPaihbBiOWOLBKtNkdMzuWQUs
         3j1TeeRp8phK+7ftY8iR8fKsZN/DxPMHhE68527NqrrQyOCh2OHG6KOniX4t19xQJT
         1OJsqm63d5kRH8Dv3pXedyAn/drHu3tvwksmtLlPbSqxlBdjTN/bz4EbTp0E4jd4LZ
         9FVA4T5QurnOA==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     reinette.chatre@intel.com, tony.luck@intel.com,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org
Subject: [PATCH v9 2/2] x86/sgx: Add an attribute for the amount of SGX memory in a NUMA node
Date:   Fri, 29 Oct 2021 15:18:57 +0300
Message-Id: <20211029121857.477885-2-jarkko@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211029121857.477885-1-jarkko@kernel.org>
References: <20211029121857.477885-1-jarkko@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

The amount of SGX memory on the system is determined by the BIOS and it
varies wildly between systems.  It can be from dozens of MB's on desktops
or VM's, up to many GB's on servers.  Just like for regular memory, it is
sometimes useful to know the amount of usable SGX memory in the system.

Add an attribute for the amount of SGX memory in bytes to each NUMA
node. The path is /sys/devices/system/node/node[0-9]*/sgx/size.
Calculate these values by summing up EPC section sizes for each node
during the driver initalization.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
v9:
* Fix racy initialization of sysfs attributes:
  https://lore.kernel.org/linux-sgx/YXOsx8SvFJV5R7lU@kroah.com/

v8:
* Fix a bug in sgx_numa_init(): node->dev should be only set after
  sysfe_create_group().  Otherwise, sysfs_remove_group() will issue a
  warning in sgx_numa_exit(), when sgx_create_group() is unsuccessful,
  because the group does not exist.

v7:
* Shorten memory_size to size. The prefix makes the name only longer
  but does not clarify things more than "size" would.
* Use device_attribute instead of kobj_attribute.
* Use named attribute group instead of creating raw kobject just for
  the "sgx" subdirectory.

v6:
* Initialize node->size to zero in sgx_setup_epc_section(), when the
  node is first accessed.

v5
* A new patch based on the discussion on
  https://lore.kernel.org/linux-sgx/3a7cab4115b4f902f3509ad8652e616b91703e1d.camel@kernel.org/T/#t
---
 Documentation/ABI/stable/sysfs-devices-node |  7 +++++
 arch/x86/include/asm/sgx.h                  |  2 ++
 arch/x86/kernel/cpu/sgx/main.c              | 31 +++++++++++++++++++++
 arch/x86/kernel/cpu/sgx/sgx.h               |  2 ++
 drivers/base/node.c                         | 16 ++++++++++-
 5 files changed, 57 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/stable/sysfs-devices-node b/Documentation/ABI/stable/sysfs-devices-node
index 484fc04bcc25..12dc2149e8e0 100644
--- a/Documentation/ABI/stable/sysfs-devices-node
+++ b/Documentation/ABI/stable/sysfs-devices-node
@@ -176,3 +176,10 @@ Contact:	Keith Busch <keith.busch@intel.com>
 Description:
 		The cache write policy: 0 for write-back, 1 for write-through,
 		other or unknown.
+
+What:		/sys/devices/system/node/nodeX/sgx/size
+Date:		October 2021
+Contact:	Jarkko Sakkinen <jarkko@kernel.org>
+Description:
+		Total available physical SGX memory, also known as Enclave Page
+		Cache (EPC), in bytes.
diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
index 05f3e21f01a7..43d1ccae6c62 100644
--- a/arch/x86/include/asm/sgx.h
+++ b/arch/x86/include/asm/sgx.h
@@ -365,6 +365,8 @@ struct sgx_sigstruct {
  * comment!
  */
 
+extern const struct attribute_group sgx_node_group;
+
 #ifdef CONFIG_X86_SGX_KVM
 int sgx_virt_ecreate(struct sgx_pageinfo *pageinfo, void __user *secs,
 		     int *trapnr);
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index a6e313f1a82d..86d6d309ff29 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -714,9 +714,12 @@ static bool __init sgx_page_cache_init(void)
 			spin_lock_init(&sgx_numa_nodes[nid].lock);
 			INIT_LIST_HEAD(&sgx_numa_nodes[nid].free_page_list);
 			node_set(nid, sgx_numa_mask);
+			sgx_numa_nodes[nid].size = 0;
 		}
 
 		sgx_epc_sections[i].node =  &sgx_numa_nodes[nid];
+		sgx_numa_nodes[nid].dev = &node_devices[nid]->dev;
+		sgx_numa_nodes[nid].size += size;
 
 		sgx_nr_epc_sections++;
 	}
@@ -790,6 +793,34 @@ int sgx_set_attribute(unsigned long *allowed_attributes,
 }
 EXPORT_SYMBOL_GPL(sgx_set_attribute);
 
+#ifdef CONFIG_NUMA
+static ssize_t size_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	unsigned long size = 0;
+	int nid;
+
+	for (nid = 0; nid < num_possible_nodes(); nid++) {
+		if (dev == sgx_numa_nodes[nid].dev) {
+			size = sgx_numa_nodes[nid].size;
+			break;
+		}
+	}
+
+	return sysfs_emit(buf, "%lu\n", size);
+}
+DEVICE_ATTR_RO(size);
+
+static struct attribute *sgx_node_attrs[] = {
+	&dev_attr_size.attr,
+	NULL,
+};
+
+const struct attribute_group sgx_node_group = {
+	.name = "sgx",
+	.attrs = sgx_node_attrs,
+};
+#endif /* CONFIG_NUMA */
+
 static int __init sgx_init(void)
 {
 	int ret;
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index 4628acec0009..1de8c627a286 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -39,6 +39,8 @@ struct sgx_epc_page {
  */
 struct sgx_numa_node {
 	struct list_head free_page_list;
+	struct device *dev;
+	unsigned long size;
 	spinlock_t lock;
 };
 
diff --git a/drivers/base/node.c b/drivers/base/node.c
index 4a4ae868ad9f..3f85131171f0 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -20,6 +20,9 @@
 #include <linux/pm_runtime.h>
 #include <linux/swap.h>
 #include <linux/slab.h>
+#ifdef CONFIG_X86_SGX
+#include <asm/sgx.h>
+#endif
 
 static struct bus_type node_subsys = {
 	.name = "node",
@@ -565,7 +568,18 @@ static struct attribute *node_dev_attrs[] = {
 	&dev_attr_vmstat.attr,
 	NULL
 };
-ATTRIBUTE_GROUPS(node_dev);
+
+static const struct attribute_group node_dev_group = {
+	.attrs = node_dev_attrs,
+};
+
+static const struct attribute_group *node_dev_groups[] = {
+	&node_dev_group,
+#ifdef CONFIG_X86_SGX
+	&sgx_node_group,
+#endif /* CONFIG_X86_SGX */
+	NULL,
+};
 
 #ifdef CONFIG_HUGETLBFS
 /*
-- 
2.32.0

