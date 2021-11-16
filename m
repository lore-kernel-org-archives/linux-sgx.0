Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27A6FC433EF
	for <linux-sgx@archiver.kernel.org>; Tue, 16 Nov 2021 16:21:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11D2961BD3
	for <linux-sgx@archiver.kernel.org>; Tue, 16 Nov 2021 16:21:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231331AbhKPQYX (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 16 Nov 2021 11:24:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:42104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231324AbhKPQYX (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 16 Nov 2021 11:24:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A70F61BE2;
        Tue, 16 Nov 2021 16:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637079686;
        bh=dVeRd+rpu6BuxDclanJO71ukMtRRehqTwia8OT676z4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SEJoEoMIrJ5qjx2IfB565iw4NrOdsIOlqrqqX/iqz0yROQLRyYI/E1cluCmFKpS7M
         ilA0hjfhbLdF9VRuug/QyS0CARA6fzKAuHlqeghQPQuVdaL0vtbdolliB7lopkGehQ
         hMGSjjwsEcPp5SxYj8CjXK/i7HRZlHW3rSd1pC1e8zkCbjWcmzml07+tSq3XrRMAK1
         e8R4syORC5D7hLHC58OyUva3jOOg1B1FmGEp+TJgKwrAWZW6/BHc7PylSoIbhDQqJ5
         kooGSzBE0l915viMBoWj+ig7TuOMfJ+KdIQTBndqFFio6udleeMMOA8MixqWUWRV/f
         kT3nDyDolDz/A==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     reinette.chatre@intel.com, linux-kernel@vger.kernel.org,
        linux-sgx@vger.kernel.org
Subject: [PATCH v13 2/2] x86/sgx: Add an attribute for the amount of SGX memory in a NUMA node
Date:   Tue, 16 Nov 2021 18:21:16 +0200
Message-Id: <20211116162116.93081-2-jarkko@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211116162116.93081-1-jarkko@kernel.org>
References: <20211116162116.93081-1-jarkko@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

The amount of SGX memory on the system is determined by the BIOS and it
varies wildly between systems.  It can be from dozens of MB's on desktops
or VM's, up to many GB's on servers.  Just like for regular memory, it is
sometimes useful to know the amount of usable SGX memory in the system.

Introduce CONFIG_HAVE_ARCH_NODE_DEV_GROUP opt-in flag to expose an arch
specific attribute group, and add an attribute for the amount of SGX
memory in bytes to each NUMA node:

/sys/devices/system/node/nodeX/x86/sgx_total_bytes

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
v13:
* Rebased on top of tip/x86/sgx.

v12:
* Device ID is set to same as NUMA node ID. Use that to get the correct
  NUMA node ID in sgx_total_bytes_show().

v11:
* Fix documentation and the commit message.

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
 Documentation/ABI/stable/sysfs-devices-node |  6 ++++++
 arch/Kconfig                                |  4 ++++
 arch/x86/Kconfig                            |  1 +
 arch/x86/kernel/cpu/sgx/main.c              | 20 ++++++++++++++++++++
 arch/x86/kernel/cpu/sgx/sgx.h               |  1 +
 drivers/base/node.c                         |  3 +++
 include/linux/numa.h                        |  4 ++++
 7 files changed, 39 insertions(+)

diff --git a/Documentation/ABI/stable/sysfs-devices-node b/Documentation/ABI/stable/sysfs-devices-node
index 484fc04bcc25..8db67aa472f1 100644
--- a/Documentation/ABI/stable/sysfs-devices-node
+++ b/Documentation/ABI/stable/sysfs-devices-node
@@ -176,3 +176,9 @@ Contact:	Keith Busch <keith.busch@intel.com>
 Description:
 		The cache write policy: 0 for write-back, 1 for write-through,
 		other or unknown.
+
+What:		/sys/devices/system/node/nodeX/x86/sgx_total_bytes
+Date:		November 2021
+Contact:	Jarkko Sakkinen <jarkko@kernel.org>
+Description:
+		The total amount of SGX physical memory in bytes.
diff --git a/arch/Kconfig b/arch/Kconfig
index 26b8ed11639d..0a9dadb00b61 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -1302,6 +1302,10 @@ config ARCH_HAS_PARANOID_L1D_FLUSH
 config DYNAMIC_SIGFRAME
 	bool
 
+# Select, if arch has a named attribute group bound to NUMA device nodes.
+config HAVE_ARCH_NODE_DEV_GROUP
+	bool
+
 source "kernel/gcov/Kconfig"
 
 source "scripts/gcc-plugins/Kconfig"
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index b9281fab4e3e..f2b699d12eb8 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -269,6 +269,7 @@ config X86
 	select HAVE_ARCH_KCSAN			if X86_64
 	select X86_FEATURE_NAMES		if PROC_FS
 	select PROC_PID_ARCH_STATUS		if PROC_FS
+	select HAVE_ARCH_NODE_DEV_GROUP		if X86_SGX
 	imply IMA_SECURE_AND_OR_TRUSTED_BOOT    if EFI
 
 config INSTRUCTION_DECODER
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index b8e1703eecae..00af6f90d31a 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -825,9 +825,11 @@ static bool __init sgx_page_cache_init(void)
 			INIT_LIST_HEAD(&sgx_numa_nodes[nid].free_page_list);
 			INIT_LIST_HEAD(&sgx_numa_nodes[nid].sgx_poison_page_list);
 			node_set(nid, sgx_numa_mask);
+			sgx_numa_nodes[nid].size = 0;
 		}
 
 		sgx_epc_sections[i].node =  &sgx_numa_nodes[nid];
+		sgx_numa_nodes[nid].size += size;
 
 		sgx_nr_epc_sections++;
 	}
@@ -901,6 +903,24 @@ int sgx_set_attribute(unsigned long *allowed_attributes,
 }
 EXPORT_SYMBOL_GPL(sgx_set_attribute);
 
+#ifdef CONFIG_NUMA
+static ssize_t sgx_total_bytes_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%lu\n", sgx_numa_nodes[dev->id].size);
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
index 9ec3136c7800..0f17def9fe6f 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -44,6 +44,7 @@ struct sgx_epc_page {
 struct sgx_numa_node {
 	struct list_head free_page_list;
 	struct list_head sgx_poison_page_list;
+	unsigned long size;
 	spinlock_t lock;
 };
 
diff --git a/drivers/base/node.c b/drivers/base/node.c
index b5a4ba18f9f9..87acc47e8951 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -581,6 +581,9 @@ static const struct attribute_group node_dev_group = {
 
 static const struct attribute_group *node_dev_groups[] = {
 	&node_dev_group,
+#ifdef CONFIG_HAVE_ARCH_NODE_DEV_GROUP
+	&arch_node_dev_group,
+#endif
 	NULL
 };
 
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

