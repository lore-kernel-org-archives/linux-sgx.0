Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 732AEC433DB
	for <linux-sgx@archiver.kernel.org>; Fri, 29 Jan 2021 00:16:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3684B64E02
	for <linux-sgx@archiver.kernel.org>; Fri, 29 Jan 2021 00:16:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbhA2APn (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 28 Jan 2021 19:15:43 -0500
Received: from mga03.intel.com ([134.134.136.65]:39369 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229866AbhA2APf (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 28 Jan 2021 19:15:35 -0500
IronPort-SDR: ++vgn3wMrvtcf5RDhxRmVE36GKCbxfDTrS0I73Pk2whwGE9ZELTVYuAe83PNFe8VLFw5ewDIU2
 zjPWNgPUNbQw==
X-IronPort-AV: E=McAfee;i="6000,8403,9878"; a="180415504"
X-IronPort-AV: E=Sophos;i="5.79,384,1602572400"; 
   d="scan'208";a="180415504"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2021 16:15:02 -0800
IronPort-SDR: Fz142BK1BE2AIwrgc5l/F23HbilLEOABGwS6srxjHJWtE6knO29kFVQznmN0ri/rLTrhKAXXdJ
 uf3aidVq/yvw==
X-IronPort-AV: E=Sophos;i="5.79,384,1602572400"; 
   d="scan'208";a="354376609"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2021 16:15:01 -0800
From:   ira.weiny@intel.com
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     Ira Weiny <ira.weiny@intel.com>, linux-kernel@vger.kernel.org,
        linux-sgx@vger.kernel.org
Subject: [PATCH] x86: Remove unnecessary kmap() from sgx_ioc_enclave_init()
Date:   Thu, 28 Jan 2021 16:14:59 -0800
Message-Id: <20210129001459.1538805-1-ira.weiny@intel.com>
X-Mailer: git-send-email 2.28.0.rc0.12.gb6a658bd00c9
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

From: Ira Weiny <ira.weiny@intel.com>

There is no reason to alloc a page and kmap it to store this temporary
data from the user.  This is especially true when we are trying to
remove kmap usages.  Also placing the token pointer 1/2 way into the
page is fragile.

Replace this allocation with two kzalloc()'s which also removes the need
for the memset().

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 arch/x86/kernel/cpu/sgx/ioctl.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 90a5caf76939..9c9019760585 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -604,7 +604,6 @@ static long sgx_ioc_enclave_init(struct sgx_encl *encl, void __user *arg)
 {
 	struct sgx_sigstruct *sigstruct;
 	struct sgx_enclave_init init_arg;
-	struct page *initp_page;
 	void *token;
 	int ret;
 
@@ -615,13 +614,15 @@ static long sgx_ioc_enclave_init(struct sgx_encl *encl, void __user *arg)
 	if (copy_from_user(&init_arg, arg, sizeof(init_arg)))
 		return -EFAULT;
 
-	initp_page = alloc_page(GFP_KERNEL);
-	if (!initp_page)
+	sigstruct = kzalloc(sizeof(*sigstruct), GFP_KERNEL);
+	if (!sigstruct)
 		return -ENOMEM;
 
-	sigstruct = kmap(initp_page);
-	token = (void *)((unsigned long)sigstruct + PAGE_SIZE / 2);
-	memset(token, 0, SGX_LAUNCH_TOKEN_SIZE);
+	token = kzalloc(SGX_LAUNCH_TOKEN_SIZE, GFP_KERNEL);
+	if (!token) {
+		ret = -ENOMEM;
+		goto free_sigstruct;
+	}
 
 	if (copy_from_user(sigstruct, (void __user *)init_arg.sigstruct,
 			   sizeof(*sigstruct))) {
@@ -645,8 +646,9 @@ static long sgx_ioc_enclave_init(struct sgx_encl *encl, void __user *arg)
 	ret = sgx_encl_init(encl, sigstruct, token);
 
 out:
-	kunmap(initp_page);
-	__free_page(initp_page);
+	kfree(token);
+free_sigstruct:
+	kfree(sigstruct);
 	return ret;
 }
 
-- 
2.28.0.rc0.12.gb6a658bd00c9

