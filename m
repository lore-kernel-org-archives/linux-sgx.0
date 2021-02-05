Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B61C2C433E6
	for <linux-sgx@archiver.kernel.org>; Fri,  5 Feb 2021 18:42:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84A6D64E51
	for <linux-sgx@archiver.kernel.org>; Fri,  5 Feb 2021 18:42:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233453AbhBERAK (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 5 Feb 2021 12:00:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:45878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233680AbhBEQrR (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 5 Feb 2021 11:47:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F96964E4D;
        Fri,  5 Feb 2021 18:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612549735;
        bh=cDXk9MQSqiJdERDqiVBVXUYsbbsTj7YvOt3iOUzRiq4=;
        h=From:To:Cc:Subject:Date:From;
        b=OaRJhFk82sN5offnYX7YrpEmbPCtHr2xl2SdCzM2qNbkulXvT+0muyk3zd2Cnte1s
         Srnsb49FXpRM4tMKEml9evlI3Animujfuj3iRd+3ot4WNguxastCBBn732fufX3hLW
         ebZ+lbTYUCh9tgZqQihQ8NbPDR4+BECa9be82PCLKQUfBedYFNH+FQa9aQAkR5xFNg
         nJjGVvuSv3n7365ANRew3X5pH1zY6PpKr7zpCDZdkal9BaXVH3rQC8cQh2GT1gh3Eh
         v1ApHpZwrAY2z2am/+lhTyqNKLvx4O0OWU+OWiBgMmNUiqEMY0rBaSvbnvoVgL/89d
         v0h18toDwaPOw==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-sgx@vger.kernel.org
Cc:     dave.hansen@intel.com, Jarkko Sakkinen <jarkko@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] MAINTAINERS: Add Dave Hansen as reviewer for INTEL SGX
Date:   Fri,  5 Feb 2021 20:28:39 +0200
Message-Id: <20210205182840.2260-1-jarkko@kernel.org>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Add Dave as reviewer for INTEL SGX patches.

Cc: Borislav Petkov <bp@alien8.de>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 5b66de2097d6..41b78e20bd1f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9227,6 +9227,7 @@ F:	include/linux/tboot.h
 
 INTEL SGX
 M:	Jarkko Sakkinen <jarkko@kernel.org>
+R:	Dave Hansen <dave.hansen@linux.intel.com>
 L:	linux-sgx@vger.kernel.org
 S:	Supported
 Q:	https://patchwork.kernel.org/project/intel-sgx/list/
-- 
2.30.0

