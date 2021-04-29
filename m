Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30163C433ED
	for <linux-sgx@archiver.kernel.org>; Thu, 29 Apr 2021 18:40:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0824A61408
	for <linux-sgx@archiver.kernel.org>; Thu, 29 Apr 2021 18:40:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241193AbhD2Skz (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 29 Apr 2021 14:40:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59814 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241197AbhD2Sky (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 29 Apr 2021 14:40:54 -0400
Received: from mail-pj1-f70.google.com ([209.85.216.70])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <tim.gardner@canonical.com>)
        id 1lcBa2-0001uS-0y
        for linux-sgx@vger.kernel.org; Thu, 29 Apr 2021 18:40:06 +0000
Received: by mail-pj1-f70.google.com with SMTP id p11-20020a17090ad30bb029014dcd9154e1so3979695pju.0
        for <linux-sgx@vger.kernel.org>; Thu, 29 Apr 2021 11:40:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=6ISdJhxPA0Q81HhhbPQowkOtokNi1L68q+uJq16mjrQ=;
        b=OgCVrT+iTFeRLb8YKBmFEcmIeXY5LwL8cpvceXmmqv4A2R5teBtJE7Dhtr46wHPC9g
         1QiEx3Ygo7R39Vp7LxIe1OvhytObi5yni1x5xQbD6yLWCXOpCN6VV1sj30i6ZEWnLRl2
         YaVaD2bszFQPfbd44/B+pPVA0Z8Efirn/j870JreZiYpDKRFdVVya0xZx/TYFmOZpKFT
         3ulMloPZHAjlFmSKz0opuMB1yKSTS86z8sGL9Mcd2NvkuC1InxMUfA84UeyDdJaAf7Ij
         U5ms5qiXs8gEaPBftp53KrEH6e5b/yvR5V92j0LpNM+U5h2RmiF1RRH5spGBWloDU2Aa
         zd8Q==
X-Gm-Message-State: AOAM531TX74FfmhgRmVQupgprwEy8bD54EXxXYFEGohCWedW4IG7FoCQ
        /E3kv+GDCF4xpXhSwyZhpQexGQTzKSl7u350OWCS+Xkviu2mEnDoXEz1W6tQkeJRHr3Vuf68pXQ
        /9sF63L80Ny7QzuwxoyVCVc31ot2ZcoimutQbXg==
X-Received: by 2002:a17:90a:c7d4:: with SMTP id gf20mr1275746pjb.106.1619721604720;
        Thu, 29 Apr 2021 11:40:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJznlTU0FLh/a/y3qttY/aCK6bTZoKBFq19ZesrnJ0eRu0rUGJ1crYWi4jCsj69yn9y3SLiV2w==
X-Received: by 2002:a17:90a:c7d4:: with SMTP id gf20mr1275724pjb.106.1619721604511;
        Thu, 29 Apr 2021 11:40:04 -0700 (PDT)
Received: from localhost.localdomain ([69.163.84.166])
        by smtp.gmail.com with ESMTPSA id i123sm3566618pfc.53.2021.04.29.11.40.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Apr 2021 11:40:03 -0700 (PDT)
From:   Tim Gardner <tim.gardner@canonical.com>
To:     dave.hansen@linux.intel.com
Cc:     tim.gardner@canonical.com, jarkko@kernel.org, shuah@kernel.org,
        linux-sgx@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Subject: [PATCH 0/1] SGX self test fails
Date:   Thu, 29 Apr 2021 12:39:51 -0600
Message-Id: <20210429183952.22797-1-tim.gardner@canonical.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

I'm just starting my learning curve on SGX, so I don't know if I've missed
some setup for the SGX device entries. After looking at arch/x86/kernel/cpu/sgx/driver.c
I see that there is no mode value for either sgx_dev_enclave or sgx_dev_provision.

With this patch I can get the SGX self test to complete:

sudo ./test_sgx
Warning: no execute permissions on device file /dev/sgx_enclave
0x0000000000000000 0x0000000000002000 0x03
0x0000000000002000 0x0000000000001000 0x05
0x0000000000003000 0x0000000000003000 0x03
SUCCESS

Is the warning even necessary ?

Tim


