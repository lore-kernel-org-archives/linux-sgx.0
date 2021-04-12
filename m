Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5277C43470
	for <linux-sgx@archiver.kernel.org>; Mon, 12 Apr 2021 15:50:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 980DC61355
	for <linux-sgx@archiver.kernel.org>; Mon, 12 Apr 2021 15:50:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240878AbhDLPuy (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 12 Apr 2021 11:50:54 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:16450 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243098AbhDLPux (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 12 Apr 2021 11:50:53 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FJtS250FvzwRvK;
        Mon, 12 Apr 2021 23:48:18 +0800 (CST)
Received: from localhost.localdomain (10.175.102.38) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.498.0; Mon, 12 Apr 2021 23:50:24 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     <weiyongjun1@huawei.com>, Jarkko Sakkinen <jarkko@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "Borislav Petkov" <bp@alien8.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        <x86@kernel.org>
CC:     <linux-sgx@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        Hulk Robot <hulkci@huawei.com>
Subject: [PATCH -next] x86/sgx: Make symbol 'sgx_vepc_vm_ops' static
Date:   Mon, 12 Apr 2021 16:00:23 +0000
Message-ID: <20210412160023.193850-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.102.38]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

The sparse tool complains as follows:

arch/x86/kernel/cpu/sgx/virt.c:95:35: warning:
 symbol 'sgx_vepc_vm_ops' was not declared. Should it be static?

This symbol is not used outside of virt.c, so this
commit marks it static.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 arch/x86/kernel/cpu/sgx/virt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/virt.c
index 7d221eac716a..6ad165a5c0cc 100644
--- a/arch/x86/kernel/cpu/sgx/virt.c
+++ b/arch/x86/kernel/cpu/sgx/virt.c
@@ -92,7 +92,7 @@ static vm_fault_t sgx_vepc_fault(struct vm_fault *vmf)
 	return VM_FAULT_SIGBUS;
 }
 
-const struct vm_operations_struct sgx_vepc_vm_ops = {
+static const struct vm_operations_struct sgx_vepc_vm_ops = {
 	.fault = sgx_vepc_fault,
 };
 

