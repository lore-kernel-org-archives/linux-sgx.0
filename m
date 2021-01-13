Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B2A2C43333
	for <linux-sgx@archiver.kernel.org>; Thu, 14 Jan 2021 02:02:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4565023447
	for <linux-sgx@archiver.kernel.org>; Thu, 14 Jan 2021 02:02:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729454AbhAMXYt (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 13 Jan 2021 18:24:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729468AbhAMXX7 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 13 Jan 2021 18:23:59 -0500
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DB3DC0617A2
        for <linux-sgx@vger.kernel.org>; Wed, 13 Jan 2021 15:23:17 -0800 (PST)
Received: by mail-qk1-x74a.google.com with SMTP id b206so2822540qkc.14
        for <linux-sgx@vger.kernel.org>; Wed, 13 Jan 2021 15:23:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=+JBIHMuyJa70cpP25bahuDTCZUqK7yPMk6L/NTONdrc=;
        b=WK7/YZmWauXQBMvF3DEQhqmFUulJLNOqcpKOk4tfHxfaUVhbULIVMKaAl9L2Yml4x3
         auriP5WCr26oHIUVUlkKy4//us9oh/dNC5ZaKJY/0HD5H3v24W2g7NaCluqEW+gSHUa0
         L2K8sK6CIjU1oSeS1JKQQwXXF6XCpjJyvZBBunCY4Gmq0yRRXXhqKwpn40KnJxzb8Sub
         K/Ev4FO7TzM+vJy8dcGvQJd0yeDFbog9oB9LIB4JP4o5jggD++I7ocwWpS/8remUNTh8
         9C8gaFssGUhZpKYBh6lpRtGh28QsNvHbo8YZ1fmfW641uQTpd7K5+EcC7apNuzY78DBW
         AVJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=+JBIHMuyJa70cpP25bahuDTCZUqK7yPMk6L/NTONdrc=;
        b=jhk6e83V1I2sjB3G2nhVpZvbcQZ8ApwmFd/hnIbntkTTenRcAF+4ZOTaREIgkZYIKY
         Ms46seisEnBg7t8CH1Q3g6CU0C6p4yarfA+iKW/r6u78fKg+l2xOTgcJLIlpkpQNbL2n
         6rT3+dY9t73rUA6zo3Ng+qCEZiKGK5r2IhS/2rEn1CpS/p+fIcTUYM3Lp4iJTFtMsCJ4
         /RR79HZGey0b+pMItvZcT4wZeLstdYLnypsfOEmhXNWVQHwFEfAmGb2FL1mQbedbO0V/
         PcZ/Jpm3oE5XhcE0v2pho3frW6m6/vlbRjqcnVTzO2EJyeG9We4qkVQXlp4hI4+ZnMU7
         2/Bg==
X-Gm-Message-State: AOAM532uCaBvRb0Aa3TRbpHkHMR0AEQOhB/KERZH3zxjh5Le3+XW11HK
        FiXfhquZPXIIMMcLtbom2jo1DnO8ykY6Ii5z6MU=
X-Google-Smtp-Source: ABdhPJyIkaD32QDGg8k13TV80+wcKGD1DkjvoNfE7I+Pa86q1qu2viSbSzgxNX9rEUQfxZK/TNEnVW2mq+oe3JW2J7g=
Sender: "samitolvanen via sendgmr" 
        <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a05:6902:6cc:: with SMTP id
 m12mr6127100ybt.56.1610580196048; Wed, 13 Jan 2021 15:23:16 -0800 (PST)
Date:   Wed, 13 Jan 2021 15:23:11 -0800
Message-Id: <20210113232311.277302-1-samitolvanen@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH] x86/sgx: fix the return type of sgx_init
From:   Sami Tolvanen <samitolvanen@google.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Sean Christopherson <seanjc@google.com>
Cc:     Kees Cook <keescook@chromium.org>, x86@kernel.org,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

device_initcall() expects a function of type initcall_t, which returns
an integer. Change the signature of sgx_init() to match.

Fixes: e7e0545299d8c ("x86/sgx: Initialize metadata for Enclave Page Cache (EPC) sections")
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 arch/x86/kernel/cpu/sgx/main.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index c519fc5f6948..8df81a3ed945 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -700,25 +700,27 @@ static bool __init sgx_page_cache_init(void)
 	return true;
 }
 
-static void __init sgx_init(void)
+static int __init sgx_init(void)
 {
 	int ret;
 	int i;
 
 	if (!cpu_feature_enabled(X86_FEATURE_SGX))
-		return;
+		return -ENODEV;
 
 	if (!sgx_page_cache_init())
-		return;
+		return -ENOMEM;
 
-	if (!sgx_page_reclaimer_init())
+	if (!sgx_page_reclaimer_init()) {
+		ret = -ENOMEM;
 		goto err_page_cache;
+	}
 
 	ret = sgx_drv_init();
 	if (ret)
 		goto err_kthread;
 
-	return;
+	return 0;
 
 err_kthread:
 	kthread_stop(ksgxd_tsk);
@@ -728,6 +730,8 @@ static void __init sgx_init(void)
 		vfree(sgx_epc_sections[i].pages);
 		memunmap(sgx_epc_sections[i].virt_addr);
 	}
+
+	return ret;
 }
 
 device_initcall(sgx_init);

base-commit: 65f0d2414b7079556fbbcc070b3d1c9f9587606d
-- 
2.30.0.284.gd98b1dd5eaa7-goog

