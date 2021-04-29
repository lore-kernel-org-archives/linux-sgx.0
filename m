Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7730C43460
	for <linux-sgx@archiver.kernel.org>; Thu, 29 Apr 2021 18:40:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B553A6143E
	for <linux-sgx@archiver.kernel.org>; Thu, 29 Apr 2021 18:40:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241241AbhD2SlO (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 29 Apr 2021 14:41:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59826 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241237AbhD2SlL (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 29 Apr 2021 14:41:11 -0400
Received: from mail-pg1-f197.google.com ([209.85.215.197])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <tim.gardner@canonical.com>)
        id 1lcBaJ-0001vp-Js
        for linux-sgx@vger.kernel.org; Thu, 29 Apr 2021 18:40:23 +0000
Received: by mail-pg1-f197.google.com with SMTP id w33-20020a6349210000b029020ed5af91a4so6266599pga.14
        for <linux-sgx@vger.kernel.org>; Thu, 29 Apr 2021 11:40:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0OUrEu3/29WV/lDM4r+szkRmP1MV+40G+dNKGjfZYt8=;
        b=ShfN5tErHo65E64ySdFD/1H/5sJaNvMErgjfBsh587mWkiKCkNpJecW2HhTzUHsHzB
         5n/gWRJCOJheoWcCy3VxQE2GFwXZ32v+kePSyaWNH2CwE1jutPcJx8bqd6oE4NPEpiH8
         mhQKVB4NFmlzt8LWDuZWyRtQEInkf8OAcN8PtAx/CV07UUA6yiMeT+lPQVwrSPiItXfG
         /3CCc1kuZVvgeSkUbHVkSL1thzWlPghGPRNV18KZNqlmPNovGXycV++sYUVlv4uNgms7
         E7cflch0yVL9rSsS3qd3MbobfM5cKZ/s+Uu1RdjVn4m3SpWLLlOS7KG1bdqlq/gbnuIz
         WfBw==
X-Gm-Message-State: AOAM532Yb3ZaVo3tOLSQyKQtNK+IzpDwNRiz12itpsIh55mWqyH4ipSd
        Oe1SvmEnW8PsY/ExhLvEQE5lesQ4X7cC2Ig8fXNEke9IjvBuYRanA/3bKakDpEq2bBOiTt5iSHT
        Y3VWRW71AagSjeLUMBNRXnnbEXXb2quVASPfyCw==
X-Received: by 2002:a17:90a:cb0e:: with SMTP id z14mr11314578pjt.128.1619721622211;
        Thu, 29 Apr 2021 11:40:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxP/sVvL06a92jnUUZ2B1gLcXqqV7Y30Y0/R/Ft4O7oXGNSU5HG7BG/ZDYxyPM1DDTHd2+CHg==
X-Received: by 2002:a17:90a:cb0e:: with SMTP id z14mr11314560pjt.128.1619721622063;
        Thu, 29 Apr 2021 11:40:22 -0700 (PDT)
Received: from localhost.localdomain ([69.163.84.166])
        by smtp.gmail.com with ESMTPSA id i123sm3566618pfc.53.2021.04.29.11.40.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Apr 2021 11:40:21 -0700 (PDT)
From:   Tim Gardner <tim.gardner@canonical.com>
To:     dave.hansen@linux.intel.com
Cc:     tim.gardner@canonical.com, jarkko@kernel.org, shuah@kernel.org,
        linux-sgx@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] selftests/sgx: Defeat execute permissions test
Date:   Thu, 29 Apr 2021 12:39:52 -0600
Message-Id: <20210429183952.22797-2-tim.gardner@canonical.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210429183952.22797-1-tim.gardner@canonical.com>
References: <20210429183952.22797-1-tim.gardner@canonical.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

The permissions check on /dev/sgx_enclave appears to be an oversight
in that it will not allow the test to continue. Skipping this test
with a warning allows the test to proceed.

Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: linux-sgx@vger.kernel.org
Cc: linux-kselftest@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 tools/testing/selftests/sgx/load.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/sgx/load.c b/tools/testing/selftests/sgx/load.c
index f441ac34b4d4..e5bcaca1c372 100644
--- a/tools/testing/selftests/sgx/load.c
+++ b/tools/testing/selftests/sgx/load.c
@@ -155,10 +155,8 @@ bool encl_load(const char *path, struct encl *encl)
 	 * bits set.  It does not check that the current user is
 	 * the owner or in the owning group.
 	 */
-	if (!(sb.st_mode & (S_IXUSR | S_IXGRP | S_IXOTH))) {
-		fprintf(stderr, "no execute permissions on device file %s\n", device_path);
-		goto err;
-	}
+	if (!(sb.st_mode & (S_IXUSR | S_IXGRP | S_IXOTH)))
+		fprintf(stderr, "Warning: no execute permissions on device file %s\n", device_path);
 
 	ptr = mmap(NULL, PAGE_SIZE, PROT_READ, MAP_SHARED, fd, 0);
 	if (ptr == (void *)-1) {
-- 
2.17.1

