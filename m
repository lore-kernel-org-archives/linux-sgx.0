Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05E38C433E0
	for <linux-sgx@archiver.kernel.org>; Wed, 10 Feb 2021 08:50:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A565B64E32
	for <linux-sgx@archiver.kernel.org>; Wed, 10 Feb 2021 08:50:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbhBJItg (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 10 Feb 2021 03:49:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbhBJIrK (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 10 Feb 2021 03:47:10 -0500
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F052BC061574;
        Wed, 10 Feb 2021 00:46:29 -0800 (PST)
Received: by mail-qt1-x82c.google.com with SMTP id c5so1003925qth.2;
        Wed, 10 Feb 2021 00:46:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VgaG2dI9kqSkYGbgZdc49/LgjJXB++uBiOB5fDAvWf8=;
        b=r0hcBEAz2Xk6gdl04upDFp29PmH5JGTsuDdEjKQaepwYaSrQQ/GOUODTTIiYThV6cP
         1+yb/ngV6UKRZ5iK/eto0DVEaBDgmi34ZlZFb9+/POyd79lDCz0DS+Y9ulfrSPTyhpaO
         4e7i2tLGtfgygJDxlVnAL66j906uOvmo+BbHSUKniGB2Ql3+2gYbaQB/bpLyFW/h5NwY
         dM4TKIJdMFIgiiqD0GAUuIcbTYq2kaOpcyQgnAGEF1aVc0DsKVrcxY/hwYef2BChPueT
         OfJlDi9w2S5orgVCRa6kjtL55GF55CXc13nxWfWWkj20JNukaVfTayZwneYHLfiH8O/G
         0BEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VgaG2dI9kqSkYGbgZdc49/LgjJXB++uBiOB5fDAvWf8=;
        b=J/5MH/LuRD/c1hR2PFzzKZPFWRhvHJ9l2z7uKya5BW7lzpTB52k3ghN5HqoSCwfkx7
         xjfTb0w7xOcO/sPChsmjuqWVHZyLVFBLHPK+ZP6/P6wdLpVY6zddYqU3JU7QG9NzPX9T
         16lV5fELCvKSZsFVMLALH2asB92yfU19L0GOzNeKNV8z1f03/iy50eMJrtE5xrBfsNIn
         FMSpmKt20WzskzKksqzf7l5cNM2s8XiBsMZppZxKmIQwADun+ZrXeKQ+e1HtH8IUAwpc
         eh6uuvg02FEQ5raX9KiG6Ks/HVnbH6kgwRaAAE15L3zSH5TAeSJ50mWO02x+RDqn0SMr
         PagA==
X-Gm-Message-State: AOAM530CmAyfmO9dqzazzHpdmJFPMegjyIzAWNA3WPW2D+dd7sRJU4+h
        af/Jpw+OJ3lcAgY+O/3St28=
X-Google-Smtp-Source: ABdhPJyeh6VQWTp+KJBN1kPUVTRKxwEwGT7BkRtR0OTSMty+bQOPWSH9aT8O0HEJ3v/9gx4xavffrg==
X-Received: by 2002:ac8:1242:: with SMTP id g2mr1738647qtj.356.1612946789235;
        Wed, 10 Feb 2021 00:46:29 -0800 (PST)
Received: from localhost.localdomain ([156.146.37.177])
        by smtp.gmail.com with ESMTPSA id e4sm846025qtp.48.2021.02.10.00.46.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 00:46:26 -0800 (PST)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     jarkko@kernel.org, luto@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] arch: x86: entry: vdso: Fix the spelling postive to positive in the file vsgx.S
Date:   Wed, 10 Feb 2021 14:16:10 +0530
Message-Id: <20210210084610.1213418-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org



s/postive/positive/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 arch/x86/entry/vdso/vsgx.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/entry/vdso/vsgx.S b/arch/x86/entry/vdso/vsgx.S
index 86a0e94f68df..99dafac992e2 100644
--- a/arch/x86/entry/vdso/vsgx.S
+++ b/arch/x86/entry/vdso/vsgx.S
@@ -137,7 +137,7 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)

 	/*
 	 * If the return from callback is zero or negative, return immediately,
-	 * else re-execute ENCLU with the postive return value interpreted as
+	 * else re-execute ENCLU with the positive return value interpreted as
 	 * the requested ENCLU function.
 	 */
 	cmp	$0, %eax
--
2.30.0

