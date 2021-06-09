Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85930C47095
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Jun 2021 03:49:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 605386124C
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Jun 2021 03:49:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236565AbhFIDux (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 8 Jun 2021 23:50:53 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:3805 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232663AbhFIDux (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 8 Jun 2021 23:50:53 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4G0Cdf0kBrzWsLX;
        Wed,  9 Jun 2021 11:44:06 +0800 (CST)
Received: from dggemi758-chm.china.huawei.com (10.1.198.144) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 9 Jun 2021 11:48:57 +0800
Received: from huawei.com (10.175.101.6) by dggemi758-chm.china.huawei.com
 (10.1.198.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Wed, 9 Jun
 2021 11:48:56 +0800
From:   ChenXiaoSong <chenxiaosong2@huawei.com>
To:     <jarkko@kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <bp@alien8.de>, <x86@kernel.org>
CC:     <linux-sgx@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <yukuai3@huawei.com>, <yi.zhang@huawei.com>,
        <chenxiaosong2@huawei.com>
Subject: [PATCH -next] x86/sgx: fix doc warning
Date:   Wed, 9 Jun 2021 11:55:10 +0800
Message-ID: <20210609035510.2083694-1-chenxiaosong2@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggemi758-chm.china.huawei.com (10.1.198.144)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Fix gcc W=1 warning:

arch/x86/kernel/cpu/sgx/encl.c:392: warning: Function parameter or member 'ref' not described in 'sgx_encl_release'

Signed-off-by: ChenXiaoSong <chenxiaosong2@huawei.com>
---
 arch/x86/kernel/cpu/sgx/encl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 3be203297988..001808e3901c 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -383,7 +383,7 @@ const struct vm_operations_struct sgx_vm_ops = {
 
 /**
  * sgx_encl_release - Destroy an enclave instance
- * @kref:	address of a kref inside &sgx_encl
+ * @ref:	address of a kref inside &sgx_encl
  *
  * Used together with kref_put(). Frees all the resources associated with the
  * enclave and the instance itself.
-- 
2.25.4

