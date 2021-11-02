Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62D31C433F5
	for <linux-sgx@archiver.kernel.org>; Tue,  2 Nov 2021 16:48:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49FD660F58
	for <linux-sgx@archiver.kernel.org>; Tue,  2 Nov 2021 16:48:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234808AbhKBQvQ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 2 Nov 2021 12:51:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:52372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234288AbhKBQvF (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 2 Nov 2021 12:51:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E4E3060F58;
        Tue,  2 Nov 2021 16:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635871710;
        bh=5NirgIboHjwCYS9oZ1rodpoavYeUmvsCLbmKzanxcUc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nfRgat30lKOeQsIrMCzzQRWCuSrn92wGnXmdggkj+vI8OWVYYtAJAWwlsmsUaMocy
         CPslO93B/bBsZRFf9PYXxBtNPcIj0GOpwt+AynDXAAsRtNLcH1VafYeiMjuox4yQDK
         8eOCLCKK+X5WJ/ETSuv3rvcvmv3njkYddEsilM93urpD++9ESsSa/zqJQKbmKaTjdF
         GP81NdU2HAoPcUxLdNBTOG+cNLXSpjvkfWpsgJeWwhZqk3X9zXQvi3cURF9yO3H2QO
         cbrJgP7jzx9ZMLgsz46vA6eppwq9EWr4BGO4Dr6LJ/oVukWiVKI5kKivm7mFwu6udF
         aOMpCxTxddUiA==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     reinette.chatre@intel.com, tony.luck@intel.com,
        nathaniel@profian.com, linux-kernel@vger.kernel.org,
        linux-sgx@vger.kernel.org
Subject: [PATCH v10 2/2] x86/sgx: Add an attribute for the amount of SGX memory in a NUMA node
Date:   Tue,  2 Nov 2021 18:48:19 +0200
Message-Id: <20211102164820.593385-2-jarkko@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211102164820.593385-1-jarkko@kernel.org>
References: <20211102164820.593385-1-jarkko@kernel.org>
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
v10:
* Change DEVICE_ATTR_RO() to static (Greg K-H)
* Change the attribute name as sgx_total_bytes, and attribute group
  name as "x86" (Dave).
* Add a new config flag HAVE_ARCH_NODE_DEV_GROUP to identify, whether
  an arch exports arch specific attribute group for NUMA nodes.

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
 arch/Kconfig                                |  4 +++
 arch/x86/Kconfig                            |  1 +
 arch/x86/kernel/cpu/sgx/main.c              | 31 +++++++++++++++++++++
 arch/x86/kernel/cpu/sgx/sgx.h               |  2 ++
 drivers/base/node.c                         | 13 ++++++++-
 include/linux/numa.h                        |  4 +++
 7 files changed, 61 insertions(+), 1 deletion(-)

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
diff --git a/arch/Kconfig b/arch/Kconfig
index 98db63496bab..ca5d75b5a427 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -1285,6 +1285,10 @@ config ARCH_HAS_ELFCORE_COMPAT
 config ARCH_HAS_PARANOID_L1D_FLUSH
 	bool
 
+# Select, if arch has a named attribute group bound to NUMA device nodes.
+config HAVE_ARCH_NODE_DEV_GROUP
+	bool
+
 source "kernel/gcov/Kconfig"
 
 source "scripts/gcc-plugins/Kconfig"
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 421fa9e38c60..8503c3bdf63f 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -266,6 +266,7 @@ config X86
 	select HAVE_ARCH_KCSAN			if X86_64
 	select X86_FEATURE_NAMES		if PROC_FS
 	select PROC_PID_ARCH_STATUS		if PROC_FS
+	select HAVE_ARCH_NODE_DEV_GROUP		if X86_SGX
 	imply IMA_SECURE_AND_OR_TRUSTED_BOOT    if EFI
 
 config INSTRUCTION_DECODER
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index a6e313f1a82d..02ebb233c511 100644
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
+static ssize_t sgx_total_bytes_show(struct device *dev, struct device_attribute *attr, char *buf)
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
+static DEVICE_ATTR_RO(sgx_total_bytes);
+
+static struct attribute *arch_node_dev_attrs[] = {
+	&dev_attr_sgx_total_bytes.attr,
+	NULL,
+};
+
+const struct attribute_group arch_node_dev_group = {
+	.name = "x86",
+	.attrs = arch_node_dev_attrs,
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
index 4a4ae868ad9f..8da977895b9a 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -565,7 +565,18 @@ static struct attribute *node_dev_attrs[] = {
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
+#ifdef CONFIG_HAVE_ARCH_NODE_DEV_GROUP
+	&arch_node_dev_group,
+#endif
+	NULL,
+};
 
 #ifdef CONFIG_HUGETLBFS
 /*
diff --git a/include/linux/numa.h b/include/linux/numa.h
index cb44cfe2b725..59df211d051f 100644
--- a/include/linux/numa.h
+++ b/include/linux/numa.h
@@ -58,4 +58,8 @@ static inline int phys_to_target_node(u64 start)
 }
 #endif
 
+#ifdef CONFIG_HAVE_ARCH_NODE_DEV_GROUP
+extern const struct attribute_group arch_node_dev_group;
+#endif
+
 #endif /* _LINUX_NUMA_H */
-- 
2.32.0

