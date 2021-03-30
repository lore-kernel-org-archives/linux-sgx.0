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
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBE19C433E1
	for <linux-sgx@archiver.kernel.org>; Tue, 30 Mar 2021 21:19:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A959C619CF
	for <linux-sgx@archiver.kernel.org>; Tue, 30 Mar 2021 21:19:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232539AbhC3VSf (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 30 Mar 2021 17:18:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230125AbhC3VS0 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 30 Mar 2021 17:18:26 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57731C061574;
        Tue, 30 Mar 2021 14:18:26 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id g10so6818836plt.8;
        Tue, 30 Mar 2021 14:18:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=0hCCH2XK2WKc3/NMTfTJuxcj4iYhKKtGeh0w+rMsGRA=;
        b=dIAmtZX6QLMB6nyPGjJOJvsE0+5UFuoN2sjoVsv84n6468OtA/tdw2KijUZ/IuIgPm
         l8Qvshf7gdeQBaDvsrjK+D5EMpl7BcT18eByXcNhhrS7ADByI5DWF8fXTZBszvH0zz23
         mBZqV/W6MWQ7MnbzC5gCyTVwzYpab58DywaB+Ni4Y+Jp7bZWDFG8tvHVbmE3C5UH9+z+
         W0fL6h0VaQZXclsmYZvbg6T8e3MHup2uIeExe0yuKVFYC0WR88zTeFi6nXiDD6ef9lO7
         PsnX/R/skQww7x1yHN562BAOrCvNwaRq59MgZoRBhut9F87V5dhq4+w9ZPD3bWxI7ifv
         FbdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=0hCCH2XK2WKc3/NMTfTJuxcj4iYhKKtGeh0w+rMsGRA=;
        b=gufZkEaaWziGAjmdMPwLj1o1/L5ASjwd+s1j03qVrCA8rHMKq8FSV3pYNjbr15nibn
         q0om9LBGP/Dwpk5GiRXYTTR4N6I/GMJ0i4GqFEZXSTGCROZ/p3JZxdg4INDy1S8rgA+7
         wfHxpwY0Sd/uqZpHtRkCQwvwsRMYmKAvcpE7XbMmTlCjBwaQ/6Dh5YoNh1en9lbtLhix
         TraxdcHTarmFpuoJmXLN6WxgNqs7fbMXFhLMlg8kmegxAIb8xasMZ9C7Yanm2/IEkPGv
         3PIWOV/1r0douwwpbyvK+TVRSOvcbK9cMhI3DVYiDWxvFidCiPJWjoDaLUBu/qOxcsTW
         40LA==
X-Gm-Message-State: AOAM531WeMzawxeunG9MIMfGH1GHlu+813o3nOTyZNZCp4dYv6HE9VZi
        RDU0QqYupa78OwhiH/ebbykE3tQgyx0XVPzG
X-Google-Smtp-Source: ABdhPJwOetdP5TPzQGombkkWqjSdYSU7TMN0l0/R8PKVcYlRfiqQzkdzhuZrDqQYrOGFa/wLX/KP8g==
X-Received: by 2002:a17:902:e74e:b029:e5:bde4:2b80 with SMTP id p14-20020a170902e74eb02900e5bde42b80mr193920plf.44.1617139105273;
        Tue, 30 Mar 2021 14:18:25 -0700 (PDT)
Received: from localhost.localdomain ([2405:201:600d:a089:d1c0:d79d:e260:a650])
        by smtp.googlemail.com with ESMTPSA id e9sm120387pgk.69.2021.03.30.14.18.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Mar 2021 14:18:24 -0700 (PDT)
From:   Aditya Srivastava <yashsri421@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     yashsri421@gmail.com, lukas.bulwahn@gmail.com,
        rdunlap@infradead.org, jarkko@kernel.org,
        dave.hansen@linux.intel.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        linux-sgx@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-doc@vger.kernel.org
Subject: [PATCH] x86/sgx: fix incorrect kernel-doc comment syntax in files
Date:   Wed, 31 Mar 2021 02:48:13 +0530
Message-Id: <20210330211813.28030-1-yashsri421@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

The opening comment mark '/**' is used for highlighting the beginning of
kernel-doc comments.
There are certain files in arch/x86/kernel/cpu/sgx, which follow this
syntax, but the content inside does not comply with kernel-doc.
Such lines were probably not meant for kernel-doc parsing, but are parsed
due to the presence of kernel-doc like comment syntax(i.e, '/**'), which
causes unexpected warnings from kernel-doc.

E.g., presence of kernel-doc like comment in the header lines for
arch/x86/kernel/cpu/sgx/encl.h causes this warning:
"warning: expecting prototype for 2016(). Prototype was for _X86_ENCL_H() instead"

Similarly for arch/x86/kernel/cpu/sgx/arch.h too.

Provide a simple fix by replacing these occurrences with general comment
format, i.e. '/*', to prevent kernel-doc from parsing it.

Signed-off-by: Aditya Srivastava <yashsri421@gmail.com>
---
* Applies perfectly on next-20210326

 arch/x86/kernel/cpu/sgx/arch.h | 2 +-
 arch/x86/kernel/cpu/sgx/encl.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/arch.h b/arch/x86/kernel/cpu/sgx/arch.h
index 26315bea1cb4..70b84bbdaa1d 100644
--- a/arch/x86/kernel/cpu/sgx/arch.h
+++ b/arch/x86/kernel/cpu/sgx/arch.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/**
+/*
  * Copyright(c) 2016-20 Intel Corporation.
  *
  * Contains data structures defined by the SGX architecture.  Data structures
diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
index d8d30ccbef4c..76b9bc1c5c30 100644
--- a/arch/x86/kernel/cpu/sgx/encl.h
+++ b/arch/x86/kernel/cpu/sgx/encl.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/**
+/*
  * Copyright(c) 2016-20 Intel Corporation.
  *
  * Contains the software defined data structures for enclaves.
-- 
2.17.1

