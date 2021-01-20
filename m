Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42802C433DB
	for <linux-sgx@archiver.kernel.org>; Wed, 20 Jan 2021 04:00:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EF94323121
	for <linux-sgx@archiver.kernel.org>; Wed, 20 Jan 2021 04:00:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbhATD7q (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 19 Jan 2021 22:59:46 -0500
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:54481 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729321AbhATDxz (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 19 Jan 2021 22:53:55 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R811e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0UMIdG0V_1611114789;
Received: from localhost(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0UMIdG0V_1611114789)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 20 Jan 2021 11:53:10 +0800
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia Zhang <zhang.jia@linux.alibaba.com>
Cc:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Subject: [PATCH v2] x86/sgx: Allows ioctl PROVISION to execute before CREATE
Date:   Wed, 20 Jan 2021 11:53:09 +0800
Message-Id: <20210120035309.19545-1-tianjia.zhang@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.3.ge56e4f7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

In function sgx_encl_create(), the logic of directly assigning
value to attributes_mask determines that the call to
SGX_IOC_ENCLAVE_PROVISION must be after the command of
SGX_IOC_ENCLAVE_CREATE. If move this assignment statement to
function sgx_open(), the PROVISION command can be executed
earlier and more flexibly.

Reported-by: Jia Zhang <zhang.jia@linux.alibaba.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
---
 arch/x86/kernel/cpu/sgx/driver.c | 3 +++
 arch/x86/kernel/cpu/sgx/ioctl.c  | 1 -
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx/driver.c
index f2eac41bb4ff..8766580194ae 100644
--- a/arch/x86/kernel/cpu/sgx/driver.c
+++ b/arch/x86/kernel/cpu/sgx/driver.c
@@ -36,6 +36,9 @@ static int sgx_open(struct inode *inode, struct file *file)
 		return ret;
 	}
 
+	encl->attributes_mask = SGX_ATTR_DEBUG | SGX_ATTR_MODE64BIT |
+				SGX_ATTR_KSS;
+
 	file->private_data = encl;
 
 	return 0;
diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 90a5caf76939..1c6ecf9fbeff 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -109,7 +109,6 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
 	encl->base = secs->base;
 	encl->size = secs->size;
 	encl->attributes = secs->attributes;
-	encl->attributes_mask = SGX_ATTR_DEBUG | SGX_ATTR_MODE64BIT | SGX_ATTR_KSS;
 
 	/* Set only after completion, as encl->lock has not been taken. */
 	set_bit(SGX_ENCL_CREATED, &encl->flags);
-- 
2.19.1.3.ge56e4f7

