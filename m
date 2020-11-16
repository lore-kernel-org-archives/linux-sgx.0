Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 884DEC63697
	for <linux-sgx@archiver.kernel.org>; Mon, 16 Nov 2020 22:28:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44B5022447
	for <linux-sgx@archiver.kernel.org>; Mon, 16 Nov 2020 22:28:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729789AbgKPW22 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 16 Nov 2020 17:28:28 -0500
Received: from mga06.intel.com ([134.134.136.31]:41513 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729773AbgKPW21 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 16 Nov 2020 17:28:27 -0500
IronPort-SDR: bQgWbstVARarHN/UDe6Cj30reA/hx4xvsWgmR5iewh3vu0d1l7lg0UmdiBI6FtzZJG9d24DD2w
 TAngxDuM5k1g==
X-IronPort-AV: E=McAfee;i="6000,8403,9807"; a="232442040"
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="232442040"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2020 14:28:25 -0800
IronPort-SDR: dupbUSpfBTNA3gN+qTaexNJ2w3A5eFA7K+ngLED7952B5CjB+LHq94LjzxvEOt2njZ1Jxn98es
 8U1Ojcs+eHpg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,483,1596524400"; 
   d="scan'208";a="533581638"
Received: from viggo.jf.intel.com ([10.54.77.144])
  by fmsmga005.fm.intel.com with ESMTP; 16 Nov 2020 14:28:24 -0800
From:   Dave Hansen <dave.hansen@intel.com>
To:     jarkko@kernel.org
Cc:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, bp@alien8.de, cedric.xing@intel.com,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, dave.hansen@intel.com, haitao.huang@intel.com,
        jethro@fortanix.com, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, linux-kernel@vger.kernel.org,
        linux-sgx@vger.kernel.org, ludloff@google.com, luto@kernel.org,
        mikko.ylinen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        puiterwijk@redhat.com, rientjes@google.com,
        sean.j.christopherson@intel.com, serge.ayoun@intel.com,
        tglx@linutronix.de, x86@kernel.org, yaozhangx@google.com,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH] x86/sgx: clarify 'laundry_list' locking
Date:   Mon, 16 Nov 2020 14:25:31 -0800
Message-Id: <20201116222531.4834-1-dave.hansen@intel.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20201112220135.165028-6-jarkko@kernel.org>
References: <20201112220135.165028-6-jarkko@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

From: Dave Hansen <dave.hansen@linux.intel.com>

Short Version:

The SGX section->laundry_list structure is effectively thread-local,
but declared next to some shared structures.  Its semantics are clear
as mud.  Fix that.  No functional changes.  Compile tested only.

Long Version:

The SGX hardware keeps per-page metadata.  This can provide things like
permissions, integrity and replay protection.  It also prevents things
like having an enclave page mapped multiple times or shared between
enclaves.

But, that presents a problem for kexec()'d kernels (or any other kernel
that does not run immediately after a hardware reset).  This is because
the last kernel may have been rude and forgotten to reset pages, which
would trigger the the "shared page" sanity check.

To fix this, the SGX code "launders" the pages by running the EREMOVE
instruction on all pages at boot.  This is slow and can take a long
time, so it is performed off in the SGX-specific ksgxd instead of being
synchronous at boot.  The init code hands the list of pages to launder
in a per-SGX-section list: ->laundry_list.  The only code to touch this
list is the init code and ksgxd.  This means that no locking is
necessary for ->laundry_list.

However, a lock is required for section->page_list, which is accessed
while creating enclaves and by ksgxd.  This lock (section->lock is
acquired by ksgxd while also processing ->laundry_list.  It is easy
to confuse the purpose of the locking as being for ->laundry_list
and ->page_list.

Rename ->laundry_list to ->init_laundry_list to make it clear that
this is not normally used at runtime.  Also add some comments
clarifying the locking, and reorganize 'sgx_epc_section' to put 'lock'
near the things it protects.

Note: init_laundry_list is 128 bytes of wasted space at runtime.  It
could theoretically be dynamically allocated and then freed after the
laundering process.  But, I suspect it would take nearly 128 bytes
of extra instructions to do that.

Cc: Jethro Beekman <jethro@fortanix.com>
Cc: Serge Ayoun <serge.ayoun@intel.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
---

 b/arch/x86/kernel/cpu/sgx/main.c |   14 ++++++++------
 b/arch/x86/kernel/cpu/sgx/sgx.h  |   15 ++++++++++++---
 2 files changed, 20 insertions(+), 9 deletions(-)

diff -puN arch/x86/kernel/cpu/sgx/main.c~sgx-laundry-comments arch/x86/kernel/cpu/sgx/main.c
--- a/arch/x86/kernel/cpu/sgx/main.c~sgx-laundry-comments	2020-11-16 13:55:42.624972349 -0800
+++ b/arch/x86/kernel/cpu/sgx/main.c	2020-11-16 13:58:10.652971980 -0800
@@ -36,13 +36,15 @@ static void sgx_sanitize_section(struct
 	LIST_HEAD(dirty);
 	int ret;
 
-	while (!list_empty(&section->laundry_list)) {
+	/* init_laundry_list is thread-local, no need for a lock: */
+	while (!list_empty(&section->init_laundry_list)) {
 		if (kthread_should_stop())
 			return;
 
+		/* needed for access to ->page_list: */
 		spin_lock(&section->lock);
 
-		page = list_first_entry(&section->laundry_list,
+		page = list_first_entry(&section->init_laundry_list,
 					struct sgx_epc_page, list);
 
 		ret = __eremove(sgx_get_epc_virt_addr(page));
@@ -56,7 +58,7 @@ static void sgx_sanitize_section(struct
 		cond_resched();
 	}
 
-	list_splice(&dirty, &section->laundry_list);
+	list_splice(&dirty, &section->init_laundry_list);
 }
 
 static bool sgx_reclaimer_age(struct sgx_epc_page *epc_page)
@@ -418,7 +420,7 @@ static int ksgxswapd(void *p)
 		sgx_sanitize_section(&sgx_epc_sections[i]);
 
 		/* Should never happen. */
-		if (!list_empty(&sgx_epc_sections[i].laundry_list))
+		if (!list_empty(&sgx_epc_sections[i].init_laundry_list))
 			WARN(1, "EPC section %d has unsanitized pages.\n", i);
 	}
 
@@ -632,13 +634,13 @@ static bool __init sgx_setup_epc_section
 	section->phys_addr = phys_addr;
 	spin_lock_init(&section->lock);
 	INIT_LIST_HEAD(&section->page_list);
-	INIT_LIST_HEAD(&section->laundry_list);
+	INIT_LIST_HEAD(&section->init_laundry_list);
 
 	for (i = 0; i < nr_pages; i++) {
 		section->pages[i].section = index;
 		section->pages[i].flags = 0;
 		section->pages[i].owner = NULL;
-		list_add_tail(&section->pages[i].list, &section->laundry_list);
+		list_add_tail(&section->pages[i].list, &section->init_laundry_list);
 	}
 
 	section->free_cnt = nr_pages;
diff -puN arch/x86/kernel/cpu/sgx/sgx.h~sgx-laundry-comments arch/x86/kernel/cpu/sgx/sgx.h
--- a/arch/x86/kernel/cpu/sgx/sgx.h~sgx-laundry-comments	2020-11-16 13:55:42.627972349 -0800
+++ b/arch/x86/kernel/cpu/sgx/sgx.h	2020-11-16 13:55:42.631972349 -0800
@@ -34,15 +34,24 @@ struct sgx_epc_page {
  * physical memory e.g. for memory areas of the each node. This structure is
  * used to store EPC pages for one EPC section and virtual memory area where
  * the pages have been mapped.
+ *
+ * 'lock' must be held before accessing 'page_list' or 'free_cnt'.
  */
 struct sgx_epc_section {
 	unsigned long phys_addr;
 	void *virt_addr;
-	struct list_head page_list;
-	struct list_head laundry_list;
 	struct sgx_epc_page *pages;
-	unsigned long free_cnt;
+
 	spinlock_t lock;
+	struct list_head page_list;
+	unsigned long free_cnt;
+
+	/*
+	 * Pages which need EREMOVE run on them before they can be
+	 * used.  Only safe to be accessed in ksgxd and init code.
+	 * Not protected by locks.
+	 */
+	struct list_head init_laundry_list;
 };
 
 extern struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
_
