Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A055C4167B
	for <linux-sgx@archiver.kernel.org>; Mon, 18 Oct 2021 14:03:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 20418603E9
	for <linux-sgx@archiver.kernel.org>; Mon, 18 Oct 2021 14:03:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233312AbhJROFO (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 18 Oct 2021 10:05:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:41674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235091AbhJRODz (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 18 Oct 2021 10:03:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5ACF610A5;
        Mon, 18 Oct 2021 13:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634565471;
        bh=Sj2JeA6Z7O7U3x7PZ1EfSDbg6wAxqRr7oWhqV2f2SRk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LGL4zaSaLAffZAeY/IyLYWcusKmL4arM3p+SZMkNmCzQaTPpNDJGQ0+uuUi6TQwnq
         tLG5ZZlc6DEillXZ7Fntkag3zbDIVPHFvJOyE11nywPktYrTZURmlR//zFP0+fLwe8
         FH5HUNpRMkPWMPKHPUMpZ7yJQdZ6CP9LoJMiJx+Al2zdoEisxMuV9CYDbdvI5K3D5S
         mAoA9mKjhA1ChYMA30axWNObo0U5dRL8VHb80Mni4wanGnmPaSW/hfW2jRLpLd7KOy
         /+LG5jVYlnbBGJCRhrtPwY2oGInkGOgkXOzzGTTeVdam6BR2aj838zo1/7yL1zuQhq
         tjr/xu3zQCCtw==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Cc:     reinette.chatre@intel.com, tony.luck@intel.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org
Subject: [PATCH v8 2/2] x86/sgx: Add an attribute for the amount of SGX memory in a NUMA node
Date:   Mon, 18 Oct 2021 16:57:44 +0300
Message-Id: <20211018135744.45527-2-jarkko@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211018135744.45527-1-jarkko@kernel.org>
References: <20211018135744.45527-1-jarkko@kernel.org>
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
 Documentation/ABI/stable/sysfs-devices-node |  7 ++
 arch/x86/kernel/cpu/sgx/main.c              | 85 +++++++++++++++++++++
 arch/x86/kernel/cpu/sgx/sgx.h               |  2 +
 3 files changed, 94 insertions(+)

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
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index a6e313f1a82d..dc1d46c51323 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -714,9 +714,11 @@ static bool __init sgx_page_cache_init(void)
 			spin_lock_init(&sgx_numa_nodes[nid].lock);
 			INIT_LIST_HEAD(&sgx_numa_nodes[nid].free_page_list);
 			node_set(nid, sgx_numa_mask);
+			sgx_numa_nodes[nid].size = 0;
 		}
 
 		sgx_epc_sections[i].node =  &sgx_numa_nodes[nid];
+		sgx_numa_nodes[nid].size += size;
 
 		sgx_nr_epc_sections++;
 	}
@@ -790,6 +792,81 @@ int sgx_set_attribute(unsigned long *allowed_attributes,
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
+static const struct attribute_group sgx_node_attr_group = {
+	.name = "sgx",
+	.attrs = sgx_node_attrs,
+};
+
+static void sgx_numa_exit(void)
+{
+	struct device *dev;
+	int nid;
+
+	for (nid = 0; nid < num_possible_nodes(); nid++) {
+		dev = &node_devices[nid]->dev;
+		if (dev)
+			sysfs_remove_group(&dev->kobj, &sgx_node_attr_group);
+	}
+}
+
+static bool sgx_numa_init(void)
+{
+	struct sgx_numa_node *node;
+	struct device *dev;
+	int nid;
+	int ret;
+
+	for (nid = 0; nid < num_possible_nodes(); nid++) {
+		if (!sgx_numa_nodes[nid].size)
+			continue;
+
+		node = &sgx_numa_nodes[nid];
+		dev = &node_devices[nid]->dev;
+
+		ret = sysfs_create_group(&dev->kobj, &sgx_node_attr_group);
+		if (ret) {
+			sgx_numa_exit();
+			return false;
+		}
+
+		node->dev = dev;
+	}
+
+	return true;
+}
+#else
+static inline void sgx_numa_exit(void)
+{
+}
+
+static inline bool sgx_numa_init(void)
+{
+	return true;
+}
+#endif /* CONFIG_NUMA */
+
 static int __init sgx_init(void)
 {
 	int ret;
@@ -806,6 +883,11 @@ static int __init sgx_init(void)
 		goto err_reclaimer;
 	}
 
+	if (!sgx_numa_init()) {
+		ret = -ENOMEM;
+		goto err_numa_nodes;
+	}
+
 	ret = misc_register(&sgx_dev_provision);
 	if (ret)
 		goto err_provision;
@@ -829,6 +911,9 @@ static int __init sgx_init(void)
 	misc_deregister(&sgx_dev_provision);
 
 err_provision:
+	sgx_numa_exit();
+
+err_numa_nodes:
 	kthread_stop(ksgxd_tsk);
 
 err_reclaimer:
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
 
-- 
2.30.2

