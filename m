Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09B53C433E0
	for <linux-sgx@archiver.kernel.org>; Fri,  5 Feb 2021 20:06:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D009E64DDB
	for <linux-sgx@archiver.kernel.org>; Fri,  5 Feb 2021 20:06:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232803AbhBESUA (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 5 Feb 2021 13:20:00 -0500
Received: from mga12.intel.com ([192.55.52.136]:12920 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233194AbhBEPTg (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 5 Feb 2021 10:19:36 -0500
IronPort-SDR: E+6cNZntzTkqJqklPGZI7URf2unAPQ6UksTpqxu720fxC3ikFWMq+DE/iB+2RWw+LtrPgJ12NC
 RVSI8RyDFDxg==
X-IronPort-AV: E=McAfee;i="6000,8403,9885"; a="160617116"
X-IronPort-AV: E=Sophos;i="5.81,155,1610438400"; 
   d="scan'208";a="160617116"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2021 09:00:33 -0800
IronPort-SDR: dXzCx5U6Xk5bWVQGNxHAMg0SBqC2Q+19yJAtpsRfaY8QeMHf/bUivHNyXfrjA85IhS172+SbLC
 urA3jfCsB2Qg==
X-IronPort-AV: E=Sophos;i="5.81,155,1610438400"; 
   d="scan'208";a="373464871"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2021 09:00:33 -0800
From:   ira.weiny@intel.com
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Ira Weiny <ira.weiny@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Jethro Beekman <jethro@fortanix.com>,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org
Subject: [PATCH v4] x86: Remove unnecessary kmap() from sgx_ioc_enclave_init()
Date:   Fri,  5 Feb 2021 09:00:30 -0800
Message-Id: <20210205170030.856723-1-ira.weiny@intel.com>
X-Mailer: git-send-email 2.28.0.rc0.12.gb6a658bd00c9
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

From: Ira Weiny <ira.weiny@intel.com>

kmap is inefficient and we are trying to reduce the usage in the kernel.
There is no readily apparent reason why initp_page needs to be allocated
and kmap'ed() but sigstruct needs to be page aligned and token
512 byte aligned.

kmalloc() can give us this alignment but we need to allocate PAGE_SIZE
bytes to do so.  Rather than change this kmap() to kmap_local_page() use
kmalloc() instead.

Remove the alloc_page()/kmap() and replace with kmalloc(PAGE_SIZE, ...)
to get a page aligned kernel address to use.

In addition add a comment to document the alignment requirements so that
others like myself don't attempt to 'fix' this again.

Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Jethro Beekman <jethro@fortanix.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
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
---
 arch/x86/kernel/cpu/sgx/ioctl.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 90a5caf76939..38e540de5e2a 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -604,7 +604,6 @@ static long sgx_ioc_enclave_init(struct sgx_encl *encl, void __user *arg)
 {
 	struct sgx_sigstruct *sigstruct;
 	struct sgx_enclave_init init_arg;
-	struct page *initp_page;
 	void *token;
 	int ret;
 
@@ -615,11 +614,14 @@ static long sgx_ioc_enclave_init(struct sgx_encl *encl, void __user *arg)
 	if (copy_from_user(&init_arg, arg, sizeof(init_arg)))
 		return -EFAULT;
 
-	initp_page = alloc_page(GFP_KERNEL);
-	if (!initp_page)
+	/*
+	 * sigstruct must be on a page boundry and token on a 512 byte boundry
+	 * kmalloc() gives us this alignment when allocating PAGE_SIZE bytes
+	 */
+	sigstruct = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!sigstruct)
 		return -ENOMEM;
 
-	sigstruct = kmap(initp_page);
 	token = (void *)((unsigned long)sigstruct + PAGE_SIZE / 2);
 	memset(token, 0, SGX_LAUNCH_TOKEN_SIZE);
 
@@ -645,8 +647,7 @@ static long sgx_ioc_enclave_init(struct sgx_encl *encl, void __user *arg)
 	ret = sgx_encl_init(encl, sigstruct, token);
 
 out:
-	kunmap(initp_page);
-	__free_page(initp_page);
+	kfree(sigstruct);
 	return ret;
 }
 
-- 
2.28.0.rc0.12.gb6a658bd00c9

