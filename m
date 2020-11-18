Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F5DDC6379D
	for <linux-sgx@archiver.kernel.org>; Wed, 18 Nov 2020 20:38:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFB00246D0
	for <linux-sgx@archiver.kernel.org>; Wed, 18 Nov 2020 20:38:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="WcxFdKdi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725710AbgKRUig (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 18 Nov 2020 15:38:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:51170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727272AbgKRUie (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 18 Nov 2020 15:38:34 -0500
Received: from suppilovahvero.lan (83-245-197-237.elisa-laajakaista.fi [83.245.197.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E260C246C7;
        Wed, 18 Nov 2020 20:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605731914;
        bh=umegQYErp2st+VH/zI7Qly+1wRwpRZskx/7MtcSTiX0=;
        h=From:To:Cc:Subject:Date:From;
        b=WcxFdKdi+m5L6IY1TK948aiwmkAOpVun357NuMR1klEdcvAFQa0xgMjbK3eKpbzKg
         C/fTq+8Z8Zi5xOiSupyjkd4bzXXDuULxpRCCtTNg482wc9W3cqYm1r/HcbVB5X7Ko6
         5YThP3do3BvzeK8vqTJLPMIqWHt5JroZa/zbMYTk=
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-x86@vger.kernel.org
Cc:     linux-sgx@vger.kernel.org, Jarkko Sakkinen <jarkko@kernel.org>,
        Haitao Huang <haitao.huang@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH] x86/sgx: Return -ERESTARTSYS in sgx_ioc_enclave_add_pages()
Date:   Wed, 18 Nov 2020 22:38:20 +0200
Message-Id: <20201118203820.61469-1-jarkko@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Return -ERESTARTSYS instead of -EINTR in sgx_ioc_enclave_add_pages()
when interrupted before any pages have been processed. At this point
ioctl can be obviously safely restarted.

Reported-by: Haitao Huang <haitao.huang@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Borislav Petkov <bp@suse.de>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 arch/x86/kernel/cpu/sgx/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 6d37117ac8a0..30aefc93a31d 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -444,7 +444,7 @@ static long sgx_ioc_enclave_add_pages(struct sgx_encl *encl, void __user *arg)
 	for (c = 0 ; c < add_arg.length; c += PAGE_SIZE) {
 		if (signal_pending(current)) {
 			if (!c)
-				ret = -EINTR;
+				ret = -ERESTARTSYS;
 
 			break;
 		}
-- 
2.27.0

