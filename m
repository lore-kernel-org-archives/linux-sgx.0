Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B69EC433E6
	for <linux-sgx@archiver.kernel.org>; Wed, 20 Jan 2021 03:57:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E88AA2311C
	for <linux-sgx@archiver.kernel.org>; Wed, 20 Jan 2021 03:57:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730680AbhATD47 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 19 Jan 2021 22:56:59 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:50748 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729930AbhATDyX (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 19 Jan 2021 22:54:23 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R241e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0UMI0fKq_1611114808;
Received: from localhost(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0UMI0fKq_1611114808)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 20 Jan 2021 11:53:28 +0800
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia Zhang <zhang.jia@linux.alibaba.com>
Cc:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Subject: [PATCH v2] x86/sgx: Remove redundant if conditions in sgx_encl_create
Date:   Wed, 20 Jan 2021 11:53:28 +0800
Message-Id: <20210120035328.19868-1-tianjia.zhang@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.3.ge56e4f7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

In this scenario, there is no case where va_page is NULL, and
the error has been checked. The if condition statement here is
redundant, so remove the condition detection.

Reported-by: Jia Zhang <zhang.jia@linux.alibaba.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
---
 arch/x86/kernel/cpu/sgx/ioctl.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 1c6ecf9fbeff..efad2fb61c76 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -66,9 +66,12 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
 	va_page = sgx_encl_grow(encl);
 	if (IS_ERR(va_page))
 		return PTR_ERR(va_page);
-	else if (va_page)
-		list_add(&va_page->list, &encl->va_pages);
-	/* else the tail page of the VA page list had free slots. */
+
+	if (WARN_ONCE(!va_page,
+		      "the tail page of the VA page list had free slots\n"))
+		return -EIO;
+
+	list_add(&va_page->list, &encl->va_pages);
 
 	/* The extra page goes to SECS. */
 	encl_size = secs->size + PAGE_SIZE;
-- 
2.19.1.3.ge56e4f7

