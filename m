Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1446C4338F
	for <linux-sgx@archiver.kernel.org>; Wed, 11 Aug 2021 03:02:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D873460EE7
	for <linux-sgx@archiver.kernel.org>; Wed, 11 Aug 2021 03:02:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232102AbhHKDDC (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 10 Aug 2021 23:03:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:41596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231967AbhHKDDB (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 10 Aug 2021 23:03:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 537D760462;
        Wed, 11 Aug 2021 03:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628650958;
        bh=LVEvsCUnhkiBvovzKLcl7idNN3Nj5VRggMyAEysn2w4=;
        h=From:To:Cc:Subject:Date:From;
        b=alBGW0y1DL8L+ffz+YpIivtU7Da14LWtT26vscB0O8/5JM2VWIBsZ4unRsn9P6MQ5
         ePbklliswl++8La6QzKfiEjRXaVWHEcmJ1fAoiS1cuy6yu+WQJw96r2cVvPsKln2TF
         uTmnWOMUSIej6d0q1SjQ8ZUfYeu4g97nZEG3wJa1HSIJoiWzgOSZJRPbQqfVQj0fT7
         RwhjxOrnrlTmjk3DCV39ppkQOFeAeJBwrZf4jWiXaU3UGiz/5954jY5Dnj8MnGEukG
         1X6eGJXUmYBaVdxoVg8cmPzUaFvqeeGUQY6m7gM1VBYo8/ox3YMqUZj7SxLw5zMdwQ
         PDvUMkC/8xevA==
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
Subject: [PATCH RFC v2] x86/sgx: Add a read-only sysctl attribute kernel.sgx.total_mem
Date:   Wed, 11 Aug 2021 06:02:21 +0300
Message-Id: <20210811030221.852092-1-jarkko@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

The amount of EPC on the system is determined by the BIOS and it varies
wildly between systems.  It can be dozens of MB on desktops, or many GB
on servers. Introduce a read-only sysctl attribute kernel.sgx_total_mem,
which provides the amount of EPC memory available in the system.

The primary use case for this attribute are stress tests.

Just like normal memory, SGX memory can be overcommitted.  SGX has its
own reclaim mechanism which kicks in when physical SGX memory (Enclave
Page Cache / EPC) is exhausted.  That reclaim mechanism is relatively
rarely exercised and needs selftests to poke at it.

To run in a reasonable amount of time, the selftest needs to know how
much EPC there is in the system.

Using a sysctl attribute makes most sense, given that its meaning is
shared with the SGX driver and KVM. It must be available even when the
driver is disabled.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---

v2:
* Removed Dave's ack.
* Rewrote Documentation/x86/sgx.rst. It was not properly updated in the
  previous iteration.

 Documentation/x86/sgx.rst      | 10 +++++++++
 arch/x86/kernel/cpu/sgx/main.c | 40 ++++++++++++++++++++++++++++++++--
 2 files changed, 48 insertions(+), 2 deletions(-)

diff --git a/Documentation/x86/sgx.rst b/Documentation/x86/sgx.rst
index dd0ac96ff9ef..f29402aa824a 100644
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
+``sgx_total_mem``
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

