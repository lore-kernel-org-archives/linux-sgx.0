Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF180C433F5
	for <linux-sgx@archiver.kernel.org>; Tue, 16 Nov 2021 16:21:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CFCA761BFE
	for <linux-sgx@archiver.kernel.org>; Tue, 16 Nov 2021 16:21:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230374AbhKPQYU (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 16 Nov 2021 11:24:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:41998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230232AbhKPQYT (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 16 Nov 2021 11:24:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E3AC61452;
        Tue, 16 Nov 2021 16:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637079682;
        bh=ywIASA+kCwdP8ALqLLEnfdf/kPnlO3UamUlO4O1gU+A=;
        h=From:To:Cc:Subject:Date:From;
        b=qfD8iQrLERqwBCh/MzbhGIKM3xc9ARwi2e2hxBHwZd8rdfPJLsfh0RxUD5o3kdkdQ
         v9rNA9dOAX4H2u4uA7qpPK+8VHgCPE4gxJTLZWG8MpJ2Nf+/sTg7rdLfFjDCfHpSqP
         /d52kCtLDxf6MosXKoyHTB1iOMkoNfSoDHBssfQkTS7QaR/HJHUNjRFbsmaBpK1GWN
         uEIeJfQoxvfYW3sG1ESwT8FJ+CbJ90RSdNRrUAAHXKgKHZ5eTZJsGtKlp3g82nxuoQ
         7ueqdg2Yx5WYKPtU1V1ekbfwTmX53o3o0nYX2gD+d1HE8TGbWYGX0FE61t48QgKQ7p
         CHp+IhqZWOPRA==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Cc:     reinette.chatre@intel.com, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v13 1/2] x86/sgx: Rename fallback labels in sgx_init()
Date:   Tue, 16 Nov 2021 18:21:15 +0200
Message-Id: <20211116162116.93081-1-jarkko@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

It's hard to add new content to this function because it is time
consuming to match fallback and its cause. Rename labels in a way
that the name of error label refers to the site where failure
happened. This way it is easier to keep on track what is going
on.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
v5:
* A new patch.
---
 arch/x86/kernel/cpu/sgx/main.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 231c494dfd40..b8e1703eecae 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -914,12 +914,12 @@ static int __init sgx_init(void)
 
 	if (!sgx_page_reclaimer_init()) {
 		ret = -ENOMEM;
-		goto err_page_cache;
+		goto err_reclaimer;
 	}
 
 	ret = misc_register(&sgx_dev_provision);
 	if (ret)
-		goto err_kthread;
+		goto err_provision;
 
 	/*
 	 * Always try to initialize the native *and* KVM drivers.
@@ -932,17 +932,17 @@ static int __init sgx_init(void)
 	ret = sgx_drv_init();
 
 	if (sgx_vepc_init() && ret)
-		goto err_provision;
+		goto err_driver;
 
 	return 0;
 
-err_provision:
+err_driver:
 	misc_deregister(&sgx_dev_provision);
 
-err_kthread:
+err_provision:
 	kthread_stop(ksgxd_tsk);
 
-err_page_cache:
+err_reclaimer:
 	for (i = 0; i < sgx_nr_epc_sections; i++) {
 		vfree(sgx_epc_sections[i].pages);
 		memunmap(sgx_epc_sections[i].virt_addr);
-- 
2.32.0

