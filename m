Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 797C1C433DB
	for <linux-sgx@archiver.kernel.org>; Tue,  2 Feb 2021 01:38:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C26B64E46
	for <linux-sgx@archiver.kernel.org>; Tue,  2 Feb 2021 01:38:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbhBBBiM (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 1 Feb 2021 20:38:12 -0500
Received: from mga03.intel.com ([134.134.136.65]:54238 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229736AbhBBBiL (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 1 Feb 2021 20:38:11 -0500
IronPort-SDR: xMZZFBLez2cvh8haHyVLmGBESlVJcIDr/zvcPXYHOzse0wC4zKafiTTXFhOmd4w24osF/DJ70L
 pzsz0n7oafhw==
X-IronPort-AV: E=McAfee;i="6000,8403,9882"; a="180857770"
X-IronPort-AV: E=Sophos;i="5.79,393,1602572400"; 
   d="scan'208";a="180857770"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2021 17:37:30 -0800
IronPort-SDR: IZZPI5C6/xyLi+cjoyhhNGucBzp+wVrvOAQmrc5cO3HgKDMd/fyboe7QOaYPZYHKJmMU6ElpYM
 3i6pwpUHbLvQ==
X-IronPort-AV: E=Sophos;i="5.79,393,1602572400"; 
   d="scan'208";a="507065127"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2021 17:37:30 -0800
From:   ira.weiny@intel.com
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Ira Weiny <ira.weiny@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Jethro Beekman <jethro@fortanix.com>,
        linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org
Subject: [PATCH] x86: Remove unnecessary kmap() from sgx_ioc_enclave_init()
Date:   Mon,  1 Feb 2021 17:37:25 -0800
Message-Id: <20210202013725.3514671-1-ira.weiny@intel.com>
X-Mailer: git-send-email 2.28.0.rc0.12.gb6a658bd00c9
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

From: Ira Weiny <ira.weiny@intel.com>

kmap is inefficient and we are trying to reduce the usage in the kernel.
There is no readily apparent reason why the initp_page page needs to be
allocated and kmap'ed() but sigstruct needs to be page aligned and token
512 byte aligned.

In this case page_address() can be used instead of kmap_local_page() as
a much more efficient way to use the address because the page is
allocated GFP_KERNEL.

Remove the kmap and replace with page_address() to get a kernel address
for the alloc'ed page.

In addition add a comment regarding the alignment requirements as well
as 2 BUILD_BUG_ON's to ensure future changes to sigstruct and token do
not go unnoticed and cause a bug.

Cc: Sean Christopherson <seanjc@google.com>,
Cc: Jethro Beekman <jethro@fortanix.com>,
Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
Changes from v1[1]:
	Use page_address() instead of kcmalloc() to ensure sigstruct is
	page aligned
	Use BUILD_BUG_ON to ensure token and sigstruct don't collide.

[1] https://lore.kernel.org/lkml/20210129001459.1538805-1-ira.weiny@intel.com/
---
 arch/x86/kernel/cpu/sgx/ioctl.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 90a5caf76939..678b02d67c3c 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -615,11 +615,18 @@ static long sgx_ioc_enclave_init(struct sgx_encl *encl, void __user *arg)
 	if (copy_from_user(&init_arg, arg, sizeof(init_arg)))
 		return -EFAULT;
 
+	/*
+	 * sigstruct must be on a page boundry and token on a 512 byte boundry
+	 * so use alloc_page/page_address instead of a kmalloc().
+	 */
 	initp_page = alloc_page(GFP_KERNEL);
 	if (!initp_page)
 		return -ENOMEM;
 
-	sigstruct = kmap(initp_page);
+	sigstruct = page_address(initp_page);
+
+	BUILD_BUG_ON(sizeof(*sigstruct) > (PAGE_SIZE/2));
+	BUILD_BUG_ON(SGX_LAUNCH_TOKEN_SIZE > (PAGE_SIZE/2));
 	token = (void *)((unsigned long)sigstruct + PAGE_SIZE / 2);
 	memset(token, 0, SGX_LAUNCH_TOKEN_SIZE);
 
@@ -645,7 +652,6 @@ static long sgx_ioc_enclave_init(struct sgx_encl *encl, void __user *arg)
 	ret = sgx_encl_init(encl, sigstruct, token);
 
 out:
-	kunmap(initp_page);
 	__free_page(initp_page);
 	return ret;
 }
-- 
2.28.0.rc0.12.gb6a658bd00c9

