Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22E66C433EF
	for <linux-sgx@archiver.kernel.org>; Tue, 14 Sep 2021 03:04:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 092F861157
	for <linux-sgx@archiver.kernel.org>; Tue, 14 Sep 2021 03:04:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238319AbhINDFq (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 13 Sep 2021 23:05:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:34924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237777AbhINDFp (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 13 Sep 2021 23:05:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 589576112E;
        Tue, 14 Sep 2021 03:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631588668;
        bh=0F5jSnD62cR5VFmZSZmBT7r8grfZA8jifIrD3awKk/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ru5otmVH8ogKC4M+hKS6NIiLdDgchqUlLtD6Vwp1xKPrtmM15MYFMajLGlQggFwbm
         JaCGNnVNDe3DOjE6XeDtKMdU4LlNPGumuJUmVEgC63svYHswYY4cCBJngcs8e8pES2
         HEUWqjsuG/k0M4gAo2hQz+BHojU5isKOBD/1bgf64+l/89is3Uj/S6eaWAlQczM3Gz
         zof7S9fOq6SAp26VH8Twz7kKaWgPx3fFJDJjck3MM1cAESB+POFwvKKd5UKltzzoXk
         U4h4bbRLhyeABHm7FMb3VE5976lxKgehA1eHREM7vq8/sMVTORVWP2IMxKMRGD+lS8
         BNRteIeLovq4Q==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH v5 2/2] x86/sgx: Add an attribute for the amount of SGX memory in a NUMA node
Date:   Tue, 14 Sep 2021 06:04:22 +0300
Message-Id: <20210914030422.377601-2-jarkko@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210914030422.377601-1-jarkko@kernel.org>
References: <20210914030422.377601-1-jarkko@kernel.org>
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
node. The path is /sys/devices/system/node/node[0-9]*/sgx/memory_size.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>

---
v5: A new patch based on the discussion at
    https://lore.kernel.org/linux-sgx/3a7cab4115b4f902f3509ad8652e616b91703e1d.camel@kernel.org/T/#t
---
 Documentation/x86/sgx.rst      | 14 ++++++
 arch/x86/kernel/cpu/sgx/main.c | 90 ++++++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/sgx/sgx.h  |  2 +
 3 files changed, 106 insertions(+)

diff --git a/Documentation/x86/sgx.rst b/Documentation/x86/sgx.rst
index dd0ac96ff9ef..f9d9cfa6dbf9 100644
--- a/Documentation/x86/sgx.rst
+++ b/Documentation/x86/sgx.rst
@@ -250,3 +250,17 @@ user wants to deploy SGX applications both on the host and in guests
 on the same machine, the user should reserve enough EPC (by taking out
 total virtual EPC size of all SGX VMs from the physical EPC size) for
 host SGX applications so they can run with acceptable performance.
+
+Per NUMA node SGX attributes
+============================
+
+NUMA nodes devices expose SGX specific attributes in the following path:
+
+	/sys/devices/system/node/node[0-9]*/sgx/
+
+Attributes
+----------
+
+memory_size
+                Total available physical SGX memory, also known as Enclave
+                Page Cache (EPC), in bytes.
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index a6e313f1a82d..c43b5a0120c1 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -717,6 +717,7 @@ static bool __init sgx_page_cache_init(void)
 		}
 
 		sgx_epc_sections[i].node =  &sgx_numa_nodes[nid];
+		sgx_numa_nodes[nid].size += size;
 
 		sgx_nr_epc_sections++;
 	}
@@ -790,6 +791,87 @@ int sgx_set_attribute(unsigned long *allowed_attributes,
 }
 EXPORT_SYMBOL_GPL(sgx_set_attribute);
 
+#ifdef CONFIG_NUMA
+static void sgx_numa_exit(void)
+{
+	int nid;
+
+	for (nid = 0; nid < num_possible_nodes(); nid++) {
+		if (!sgx_numa_nodes[nid].kobj)
+			continue;
+
+		kobject_put(sgx_numa_nodes[nid].kobj);
+	}
+}
+
+#define SGX_NODE_ATTR_RO(_name) \
+	static struct kobj_attribute _name##_attr = __ATTR_RO(_name)
+
+static ssize_t memory_size_show(struct kobject *kobj, struct kobj_attribute *attr, char *buf)
+{
+	unsigned long size = 0;
+	int nid;
+
+	for (nid = 0; nid < num_possible_nodes(); nid++) {
+		if (kobj == sgx_numa_nodes[nid].kobj) {
+			size = sgx_numa_nodes[nid].size;
+			break;
+		}
+	}
+
+	return sysfs_emit(buf, "%lu\n", size);
+}
+SGX_NODE_ATTR_RO(memory_size);
+
+static struct attribute *sgx_node_attrs[] = {
+	&memory_size_attr.attr,
+	NULL,
+};
+
+static const struct attribute_group sgx_node_attr_group = {
+	.attrs = sgx_node_attrs,
+};
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
+		node->kobj = kobject_create_and_add("sgx", &dev->kobj);
+		if (!node->kobj) {
+			sgx_numa_exit();
+			return false;
+		}
+
+		ret = sysfs_create_group(node->kobj, &sgx_node_attr_group);
+		if (ret) {
+			sgx_numa_exit();
+			return false;
+		}
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
@@ -806,6 +888,11 @@ static int __init sgx_init(void)
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
@@ -829,6 +916,9 @@ static int __init sgx_init(void)
 	misc_deregister(&sgx_dev_provision);
 
 err_provision:
+	sgx_numa_exit();
+
+err_numa_nodes:
 	kthread_stop(ksgxd_tsk);
 
 err_reclaimer:
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index 4628acec0009..c2c5e7c66d21 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -39,6 +39,8 @@ struct sgx_epc_page {
  */
 struct sgx_numa_node {
 	struct list_head free_page_list;
+	struct kobject *kobj;
+	unsigned long size;
 	spinlock_t lock;
 };
 
-- 
2.25.1

