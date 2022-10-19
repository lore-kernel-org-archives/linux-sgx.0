Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96D2BC4332F
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Oct 2022 03:30:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbiJSDaE (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 18 Oct 2022 23:30:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbiJSDaC (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 18 Oct 2022 23:30:02 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77D9F33E2B;
        Tue, 18 Oct 2022 20:29:58 -0700 (PDT)
Received: from dggpemm500023.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Msbks5XpWzJn4F;
        Wed, 19 Oct 2022 11:27:17 +0800 (CST)
Received: from dggpemm500001.china.huawei.com (7.185.36.107) by
 dggpemm500023.china.huawei.com (7.185.36.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 19 Oct 2022 11:29:56 +0800
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 dggpemm500001.china.huawei.com (7.185.36.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 19 Oct 2022 11:29:56 +0800
From:   Kefeng Wang <wangkefeng.wang@huawei.com>
To:     <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC:     Dinh Nguyen <dinguyen@kernel.org>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        <linux-sgx@vger.kernel.org>, <amd-gfx@lists.freedesktop.org>,
        <linux-mm@kvack.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH 1/5] nios2: remove unused INIT_MMAP
Date:   Wed, 19 Oct 2022 11:49:41 +0800
Message-ID: <20221019034945.93081-2-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20221019034945.93081-1-wangkefeng.wang@huawei.com>
References: <20221019034945.93081-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500001.china.huawei.com (7.185.36.107)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

It seems that INIT_MMAP is gone in 2.4.10, not sure,
anyways, it is useless now, kill it.

Cc: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 arch/nios2/include/asm/processor.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/nios2/include/asm/processor.h b/arch/nios2/include/asm/processor.h
index 8916d93d5c2d..eb44130364a9 100644
--- a/arch/nios2/include/asm/processor.h
+++ b/arch/nios2/include/asm/processor.h
@@ -50,9 +50,6 @@ struct thread_struct {
 	unsigned long kpsr;
 };
 
-#define INIT_MMAP \
-	{ &init_mm, (0), (0), __pgprot(0x0), VM_READ | VM_WRITE | VM_EXEC }
-
 # define INIT_THREAD {			\
 	.kregs	= NULL,			\
 	.ksp	= 0,			\
-- 
2.35.3

