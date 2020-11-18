Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C7EFC5519F
	for <linux-sgx@archiver.kernel.org>; Wed, 18 Nov 2020 21:39:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93B42246CA
	for <linux-sgx@archiver.kernel.org>; Wed, 18 Nov 2020 21:39:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sp4QPKyp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726163AbgKRVjl (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 18 Nov 2020 16:39:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:37234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726110AbgKRVjl (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 18 Nov 2020 16:39:41 -0500
Received: from suppilovahvero.lan (83-245-197-237.elisa-laajakaista.fi [83.245.197.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12F2A20715;
        Wed, 18 Nov 2020 21:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605735580;
        bh=umegQYErp2st+VH/zI7Qly+1wRwpRZskx/7MtcSTiX0=;
        h=From:To:Cc:Subject:Date:From;
        b=Sp4QPKypmYQedNinpqN92jnWttyBpBm3ARBLlSEv/ZofSOb3QJWgS6RzVCkKcX58a
         cFmPFAT3ZyIt7TrwfJs6yj6L2OpOrD64hWzzYrR4XG0FHaG8uTz0TvCKVTqEkZWsyA
         1xzAG1M8zLvTMLmCoMEVMEP0hxUAbi3Iy9akyXyo=
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     x86@kernel.org
Cc:     linux-sgx@vger.kernel.org, Jarkko Sakkinen <jarkko@kernel.org>,
        Haitao Huang <haitao.huang@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH,RESEND] x86/sgx: Return -ERESTARTSYS in sgx_ioc_enclave_add_pages()
Date:   Wed, 18 Nov 2020 23:39:32 +0200
Message-Id: <20201118213932.63341-1-jarkko@kernel.org>
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

