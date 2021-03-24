Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52CF1C433E0
	for <linux-sgx@archiver.kernel.org>; Wed, 24 Mar 2021 18:23:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2611461A26
	for <linux-sgx@archiver.kernel.org>; Wed, 24 Mar 2021 18:23:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbhCXSXI (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 24 Mar 2021 14:23:08 -0400
Received: from mga18.intel.com ([134.134.136.126]:18139 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237494AbhCXSWu (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 24 Mar 2021 14:22:50 -0400
IronPort-SDR: 0qB9NNC4zoSv4Rhb/u4FlOrDM005zy2w9wCC2RGwsNJqcyYHly2C1PSZnWWDarNH+DGAGdFnot
 5CYlrkio+5MA==
X-IronPort-AV: E=McAfee;i="6000,8403,9933"; a="178317414"
X-IronPort-AV: E=Sophos;i="5.81,275,1610438400"; 
   d="scan'208";a="178317414"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2021 11:22:49 -0700
IronPort-SDR: bPLVKBIfX2/fZ67H6twLVC/PqUgyY/DB2F/TjiylyJ29z2f1ThOXUR6F1ClcFH6RKrMDaWJR+n
 5xcRcViKFEjg==
X-IronPort-AV: E=Sophos;i="5.81,275,1610438400"; 
   d="scan'208";a="415604529"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2021 11:22:49 -0700
From:   ira.weiny@intel.com
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org
Cc:     Ira Weiny <ira.weiny@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] x86/sgx: Remove unnecessary kmap() from sgx_ioc_enclave_init()
Date:   Wed, 24 Mar 2021 11:22:46 -0700
Message-Id: <20210324182246.2484875-1-ira.weiny@intel.com>
X-Mailer: git-send-email 2.28.0.rc0.12.gb6a658bd00c9
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

From: Ira Weiny <ira.weiny@intel.com>

kmap is inefficient and is being replaced by kmap_local_page(), if
possible.

That said, there is no readily apparent reason why initp_page needs to
be allocated and kmap'ed() except that 'sigstruct' needs to be page
aligned and 'token' 512 byte aligned.

Rather than change this kmap() to kmap_local_page() use kmalloc()
instead because kmalloc() can gives this alignment when allocating
PAGE_SIZE bytes.

Remove the alloc_page()/kmap() and replace with kmalloc(PAGE_SIZE, ...)
to get a page aligned kernel address.

In addition add a comment to document the alignment requirements so that
others don't attempt to 'fix' this again.

Cc: Sean Christopherson <seanjc@google.com>
Cc: Jethro Beekman <jethro@fortanix.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
Changes from v5[5]:
	From Boris
		Clean up commit msg and comment

Changes from v4[4]:
        Add Ack and Reviews
        Send to the correct maintainers

Changes from v3[3]:
	Remove BUILD_BUG_ONs

Changes from v2[2]:
        When allocating a power of 2 size kmalloc() now guarantees the
        alignment of the respective size.  So go back to using kmalloc() but
        with a PAGE_SIZE allocation to get the alignment.  This also follows
        the pattern in sgx_ioc_enclave_create()

Changes from v1[1]:
	Use page_address() instead of kcmalloc() to ensure sigstruct is
	page aligned
	Use BUILD_BUG_ON to ensure token and sigstruct don't collide.

[1] https://lore.kernel.org/lkml/20210129001459.1538805-1-ira.weiny@intel.com/
[2] https://lore.kernel.org/lkml/20210202013725.3514671-1-ira.weiny@intel.com/
[3] https://lore.kernel.org/lkml/20210205050850.GC5033@iweiny-DESK2.sc.intel.com/#t
[4] https://lore.kernel.org/lkml/YCBY02iEKLVyj7Ix@kernel.org/
[5] https://lore.kernel.org/lkml/20210306002058.303796-1-ira.weiny@intel.com/
---
 arch/x86/kernel/cpu/sgx/ioctl.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 90a5caf76939..2e10367ea66c 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -604,7 +604,6 @@ static long sgx_ioc_enclave_init(struct sgx_encl *encl, void __user *arg)
 {
 	struct sgx_sigstruct *sigstruct;
 	struct sgx_enclave_init init_arg;
-	struct page *initp_page;
 	void *token;
 	int ret;
 
@@ -615,11 +614,15 @@ static long sgx_ioc_enclave_init(struct sgx_encl *encl, void __user *arg)
 	if (copy_from_user(&init_arg, arg, sizeof(init_arg)))
 		return -EFAULT;
 
-	initp_page = alloc_page(GFP_KERNEL);
-	if (!initp_page)
+	/*
+	 * 'sigstruct' must be on a page boundary and 'token' on a 512 byte
+	 * boundary.  kmalloc() will give this alignment when allocating
+	 * PAGE_SIZE bytes.
+	 */
+	sigstruct = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!sigstruct)
 		return -ENOMEM;
 
-	sigstruct = kmap(initp_page);
 	token = (void *)((unsigned long)sigstruct + PAGE_SIZE / 2);
 	memset(token, 0, SGX_LAUNCH_TOKEN_SIZE);
 
@@ -645,8 +648,7 @@ static long sgx_ioc_enclave_init(struct sgx_encl *encl, void __user *arg)
 	ret = sgx_encl_init(encl, sigstruct, token);
 
 out:
-	kunmap(initp_page);
-	__free_page(initp_page);
+	kfree(sigstruct);
 	return ret;
 }
 
-- 
2.28.0.rc0.12.gb6a658bd00c9

