Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C8CFC433EF
	for <linux-sgx@archiver.kernel.org>; Tue, 14 Sep 2021 03:04:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FC236113E
	for <linux-sgx@archiver.kernel.org>; Tue, 14 Sep 2021 03:04:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237794AbhINDFn (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 13 Sep 2021 23:05:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:34826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237777AbhINDFm (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 13 Sep 2021 23:05:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A5A860E90;
        Tue, 14 Sep 2021 03:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631588666;
        bh=tvGbOK7BmFanrorO0G0ald91N5wddxG6jSLUfrbRPOU=;
        h=From:To:Cc:Subject:Date:From;
        b=hYgniXNWJeK+l+Y8FFqX9LNonTGg7VssKSzpNf6DSMTM5CKYYAzK3GsswVA0SLsuk
         yHMiBsZkt95K4XxJ54lA3zD9JP5F/7eFsCzmCV4jkhbSnbW0n5NThP5RXR8YAx8c2u
         5qtZNJ3Rul6FAt5NMMj2ALuhfc+1JRZ0NGJ7XlaCYQ2lLSCdUiTD7WSs+m4Ox29SAF
         ANhQhNfi7kHqxhPlBXViUYm3nxaROqeQZuDbRn/6QEpfRyGBk1XZRxRU25eVCmZpe2
         llOEJJGzVsw5EdeI6AK/eYTsf2qHv3tPSoa4l15fJt3rCsNKxJtvl+Iqvjk8BvOouU
         5ZS9f8ZsEfN2A==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Cc:     linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 1/2] x86/sgx: Rename fallback labels in sgx_init()
Date:   Tue, 14 Sep 2021 06:04:21 +0300
Message-Id: <20210914030422.377601-1-jarkko@kernel.org>
X-Mailer: git-send-email 2.25.1
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
v5: A new patch.
---
 arch/x86/kernel/cpu/sgx/main.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 63d3de02bbcc..a6e313f1a82d 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -803,12 +803,12 @@ static int __init sgx_init(void)
 
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
@@ -821,17 +821,17 @@ static int __init sgx_init(void)
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
2.25.1

