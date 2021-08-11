Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DBC1C4338F
	for <linux-sgx@archiver.kernel.org>; Wed, 11 Aug 2021 03:21:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7DB4960EDF
	for <linux-sgx@archiver.kernel.org>; Wed, 11 Aug 2021 03:21:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232616AbhHKDWB (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 10 Aug 2021 23:22:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:49932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232498AbhHKDWB (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 10 Aug 2021 23:22:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F340360C40;
        Wed, 11 Aug 2021 03:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628652098;
        bh=FziP7e2670iPjg8hna/JeFwBLNVYppJ3PZ01fQLOw/U=;
        h=From:To:Cc:Subject:Date:From;
        b=nIvAui6v/LPO29iiGB3hzfZLYxQVJVopHjOUa+eKxSGH4jeLbBR/+qak7yUl5+TyL
         Ui/7U4fQJyfasqyNddyevqkKnSOtvFdA0KClebP1cgA4nouMXIgSGp5zStGCum5cEP
         Gwsvdg9K9sYGxj4gGOQbWbQXr91H1ayjDsbwBWnZJAsjkJGJVQAHJpGqvHqu0g6cFc
         XaKQDNKtTpY3tw2KQJi7xd/Dd+gvLXWTGMfoRKDXuFRQz3r81r9+DR9ls7KO73fqAL
         Y3LLDH16tbLi6slsmord8Wm+3tcUj7PZQXQVy53GwW1WQhgGPopq7Vw+AEoymG0uZU
         fn8LKtITULIzQ==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-sgx@vger.kernel.org
Cc:     Reinette Chatre <reinette.chatre@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Jonathan Corbet <corbet@lwn.net>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [PATCH RFC v3] x86/sgx: Add /proc/sys/kernel/sgx/total_mem
Date:   Wed, 11 Aug 2021 06:21:33 +0300
Message-Id: <20210811032133.853680-1-jarkko@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

The amount of EPC on the system is determined by the BIOS and it varies
wildly between systems.  It can be dozens of MB on desktops, or many GB on
servers.

Just like normal memory, SGX memory can be overcommitted.  SGX has its own
reclaim mechanism which kicks in when physical SGX memory (Enclave Page
Cache / EPC) is exhausted.  SGX memory can also be sliced into a number
pieces when utilizing /dev/sgx_vepc to allocate SGX memory regions for the
VM's.

For all these needs and purposes, it is often useful to know what is the
physical limit for SGX memory.

Add /proc/sys/kernel/sgx/total_mem read-only sysctl attribute for to report
the total available SGX memory to help with configuring SGX applications
based on the system capabilities. Since having this makes sense both for
KVM and the driver, it makes most sense to have it as a global sysfs
attribute.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---

v3:
* ``sgx_total_mem`` -> ``total_mem``
* Rewrote the commit message.

v2:
* Removed Dave's ack.
* Rewrote Documentation/x86/sgx.rst. It was not properly updated in the
  previous iteration.

 Documentation/x86/sgx.rst      | 10 +++++++++
 arch/x86/kernel/cpu/sgx/main.c | 40 ++++++++++++++++++++++++++++++++--
 2 files changed, 48 insertions(+), 2 deletions(-)

diff --git a/Documentation/x86/sgx.rst b/Documentation/x86/sgx.rst
index dd0ac96ff9ef..32d579c90d82 100644
--- a/Documentation/x86/sgx.rst
+++ b/Documentation/x86/sgx.rst
@@ -250,3 +250,13 @@ user wants to deploy SGX applications both on the host and in guests
 on the same machine, the user should reserve enough EPC (by taking out
 total virtual EPC size of all SGX VMs from the physical EPC size) for
 host SGX applications so they can run with acceptable performance.
+
+Sysctls
+=======
+
+The following sysctl files can be found in the ``/proc/sys/kernel/sgx/`` directory:
+
+``total_mem``
+	The total amount of SGX protected memory in bytes available in the system
+	available for use. In other words, it describes the size of the Enclave
+	Page Cache (EPC).
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 63d3de02bbcc..c857253a2e5d 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -28,7 +28,10 @@ static DECLARE_WAIT_QUEUE_HEAD(ksgxd_waitq);
 static LIST_HEAD(sgx_active_page_list);
 static DEFINE_SPINLOCK(sgx_reclaimer_lock);
 
-/* The free page list lock protected variables prepend the lock. */
+/* Total EPC memory available in bytes. */
+static unsigned long sgx_total_mem;
+
+/* The number of free EPC pages in all nodes. */
 static unsigned long sgx_nr_free_pages;
 
 /* Nodes with one or more EPC sections. */
@@ -656,6 +659,8 @@ static bool __init sgx_setup_epc_section(u64 phys_addr, u64 size,
 		list_add_tail(&section->pages[i].list, &sgx_dirty_page_list);
 	}
 
+	sgx_total_mem += nr_pages * PAGE_SIZE;
+
 	return true;
 }
 
@@ -790,8 +795,30 @@ int sgx_set_attribute(unsigned long *allowed_attributes,
 }
 EXPORT_SYMBOL_GPL(sgx_set_attribute);
 
+static struct ctl_path sgx_sysctl_path[] = {
+	{ .procname = "kernel", },
+	{ .procname = "sgx", },
+	{ }
+};
+
+static unsigned long sgx_total_mem_max = ~0UL;
+
+static struct ctl_table sgx_sysctl_table[] = {
+	{
+		.procname       = "total_mem",
+		.data           = &sgx_total_mem,
+		.maxlen         = sizeof(unsigned long),
+		.mode           = 0444,
+		.proc_handler   = proc_doulongvec_minmax,
+		.extra1		= SYSCTL_ZERO, /* min */
+		.extra2		= &sgx_total_mem_max, /* max */
+	},
+	{ }
+};
+
 static int __init sgx_init(void)
 {
+	struct ctl_table_header *sysctl_table_header;
 	int ret;
 	int i;
 
@@ -810,6 +837,12 @@ static int __init sgx_init(void)
 	if (ret)
 		goto err_kthread;
 
+	sysctl_table_header = register_sysctl_paths(sgx_sysctl_path, sgx_sysctl_table);
+	if (!sysctl_table_header) {
+		pr_err("sysctl registration failed.\n");
+		goto err_provision;
+	}
+
 	/*
 	 * Always try to initialize the native *and* KVM drivers.
 	 * The KVM driver is less picky than the native one and
@@ -821,10 +854,13 @@ static int __init sgx_init(void)
 	ret = sgx_drv_init();
 
 	if (sgx_vepc_init() && ret)
-		goto err_provision;
+		goto err_sysctl;
 
 	return 0;
 
+err_sysctl:
+	unregister_sysctl_table(sysctl_table_header);
+
 err_provision:
 	misc_deregister(&sgx_dev_provision);
 
-- 
2.32.0

