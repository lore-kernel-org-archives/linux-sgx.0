Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A3FAC001B0
	for <linux-sgx@archiver.kernel.org>; Mon, 14 Aug 2023 04:38:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233131AbjHNEhq (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 14 Aug 2023 00:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233109AbjHNEhR (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 14 Aug 2023 00:37:17 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBE06FB
        for <linux-sgx@vger.kernel.org>; Sun, 13 Aug 2023 21:37:15 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-9923833737eso514279166b.3
        for <linux-sgx@vger.kernel.org>; Sun, 13 Aug 2023 21:37:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1691987834; x=1692592634;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=m5YMrf4HHzqanqIpl1wLQB2vcTCJ/+RxEFmotMvtvro=;
        b=GeD69R5C2qyeXCSoVm44xThlTJFTucMTrj3/AgXtyjLUHbQOnrRC9+4Zv6UkoE39Nk
         8ChUGo3FcKHD1cxquRc3TeaA6IXKgv0957gAYdS7FoRHthdyw/ehLFiLFYS6tSoAJSak
         5rsnIG+PhsOSsmEGDlElxL7BaFJc7Btp9jBroDzDjVpcV9489PTHd4rqiWns9WfOygdj
         /QZdNBzzkKE2TyQxNgYecqj+IyzwqJPHJEzALQPv+fFb5wT+lQgZh9qAkxy/SnQBetLI
         ITT/8ezgPEq90HIJleEAsbPAc+jLkQRULcDe1JqcptufKPYvrNFU9i239CbvL4jCtIN3
         cGmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691987834; x=1692592634;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m5YMrf4HHzqanqIpl1wLQB2vcTCJ/+RxEFmotMvtvro=;
        b=iLbx7/204xIUYkZsWd0fop5GxfWcN0+6aWuZ5fsmu+Qn3pwqeE5VuDvsiQXsR9ez94
         ZLSYw0QL5ZFZaDI6J4QFtyW9/aQbtuA4g/pW+AyUsbkcDNEvdxTmnU8rt/koLNDc2WP8
         qO4rUWR25c2QuYN2MMgMsFRlNH0PnMkQqXONjiynypHhySfS/3lkxiLEPALnBXAQWgqH
         7pmun82gxo+kXwCHWu6kz+9oX/2ExkRqo6go4OEatDTHDaH3KLHMg13qQbd7kOE3QVrT
         D/wU8MeNnir4dej8SBPPN5FpLpuHVrAJgsXE2UB8QJsxuPXulSp3ljk7zRrSAE42Ujad
         i7Dg==
X-Gm-Message-State: AOJu0YzeaZmtf8UPwYZeJa2kEiVAwqxOPypn/cDt5VycNuXz8HwA36cd
        K16I9NxPlAvQaHI8A5lsfQ4tcFUzzoYHKYnkjc0=
X-Google-Smtp-Source: AGHT+IGcwL+S+oEi8IuQQDpzC+Or1kJi3wT3P76D881eELwJxVYaM/MTa3EmOmyo+E1sRSoa3546dQ==
X-Received: by 2002:a17:907:2717:b0:99b:f392:10b2 with SMTP id w23-20020a170907271700b0099bf39210b2mr7120318ejk.39.1691987834298;
        Sun, 13 Aug 2023 21:37:14 -0700 (PDT)
Received: from lb02065.fkb.profitbricks.net ([2001:9e8:1404:a00:2211:87e2:ac41:54ad])
        by smtp.gmail.com with ESMTPSA id kf8-20020a17090776c800b00992b2c5598csm5223766ejc.128.2023.08.13.21.37.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Aug 2023 21:37:13 -0700 (PDT)
From:   Jack Wang <jinpu.wang@ionos.com>
To:     jarkko@kernel.org
Cc:     linux-sgx@vger.kernel.org,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Yu Zhang <yu.zhang@ionos.com>
Subject: [PATCH] x86/sgx: Avoid softlockup from sgx_vepc_release
Date:   Mon, 14 Aug 2023 06:37:14 +0200
Message-Id: <20230814043714.107971-1-jinpu.wang@ionos.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

We hit softlocup with following call trace:
 kernel: [ 2041.288210] Call Trace:
kernel: [ 2041.288213]  <IRQ>
kernel: [ 2041.288216]  ? watchdog_timer_fn+0x1b4/0x210
kernel: [ 2041.288222]  ? lockup_detector_update_enable+0x50/0x50
kernel: [ 2041.288225]  ? __hrtimer_run_queues+0x127/0x280
kernel: [ 2041.288230]  ? hrtimer_interrupt+0xfc/0x210
kernel: [ 2041.288233]  ? __sysvec_apic_timer_interrupt+0x59/0xd0
kernel: [ 2041.288237]  ? sysvec_apic_timer_interrupt+0x6d/0x90
kernel: [ 2041.288242]  </IRQ>
kernel: [ 2041.288242]  <TASK>
kernel: [ 2041.288244]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20
kernel: [ 2041.288250]  xa_erase+0x21/0xb0
kernel: [ 2041.288256]  ? sgx_free_epc_page+0x20/0x50
kernel: [ 2041.288260]  sgx_vepc_release+0x75/0x220
kernel: [ 2041.288263]  __fput+0x89/0x250
kernel: [ 2041.288269]  task_work_run+0x59/0x90
kernel: [ 2041.288275]  do_exit+0x337/0x9a0

Similar like 8795359e35bc ("x86/sgx: Silence softlockup detection when releasing large enclaves")
The test system has 64GB of enclave memory, and all assigned to a single
VM. Release vepc take longer time and triggers the softlockup warning.

Add a cond_resched() to give other tasks a chance to run and placate
the softlockup detector.

Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Haitao Huang <haitao.huang@linux.intel.com>
Reported-by: Yu Zhang <yu.zhang@ionos.com>

Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
---
 arch/x86/kernel/cpu/sgx/virt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/virt.c
index c3e37eaec8ec..01d2795792cc 100644
--- a/arch/x86/kernel/cpu/sgx/virt.c
+++ b/arch/x86/kernel/cpu/sgx/virt.c
@@ -204,6 +204,7 @@ static int sgx_vepc_release(struct inode *inode, struct file *file)
 			continue;
 
 		xa_erase(&vepc->page_array, index);
+		cond_resched();
 	}
 
 	/*
@@ -222,6 +223,7 @@ static int sgx_vepc_release(struct inode *inode, struct file *file)
 			list_add_tail(&epc_page->list, &secs_pages);
 
 		xa_erase(&vepc->page_array, index);
+		cond_resched();
 	}
 
 	/*
-- 
2.34.1

