Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CC47C433FE
	for <linux-sgx@archiver.kernel.org>; Thu,  3 Dec 2020 18:36:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06B87207B6
	for <linux-sgx@archiver.kernel.org>; Thu,  3 Dec 2020 18:36:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgLCSgX (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 3 Dec 2020 13:36:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:57632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726222AbgLCSgX (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 3 Dec 2020 13:36:23 -0500
From:   Jarkko Sakkinen <jarkko@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     x86@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] x86/sgx: Return -EINVAL on a zero length buffer in sgx_ioc_enclave_add_pages()
Date:   Thu,  3 Dec 2020 20:35:27 +0200
Message-Id: <20201203183527.139317-1-jarkko@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

The length documented as

 * @length:     length of the data (multiple of the page size)

Fail with -EINVAL, when user gives a zero length buffer. Right now
'ret' is returned as uninitialized.

Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Link: https://lore.kernel.org/linux-sgx/X8ehQssnslm194ld@mwanda/
Fixes: c6d26d370767 ("x86/sgx: Add SGX_IOC_ENCLAVE_ADD_PAGES")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 arch/x86/kernel/cpu/sgx/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index c206aee80a04..90a5caf76939 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -428,7 +428,7 @@ static long sgx_ioc_enclave_add_pages(struct sgx_encl *encl, void __user *arg)
 	    !IS_ALIGNED(add_arg.src, PAGE_SIZE))
 		return -EINVAL;
 
-	if (add_arg.length & (PAGE_SIZE - 1))
+	if (!add_arg.length || add_arg.length & (PAGE_SIZE - 1))
 		return -EINVAL;
 
 	if (add_arg.offset + add_arg.length - PAGE_SIZE >= encl->size)
-- 
2.27.0

