Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB2BAC1551D
	for <linux-sgx@archiver.kernel.org>; Thu,  4 Mar 2021 00:49:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A59C464F20
	for <linux-sgx@archiver.kernel.org>; Thu,  4 Mar 2021 00:49:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240209AbhCDAtU (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:49:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:42456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1447592AbhCCPE2 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 3 Mar 2021 10:04:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE1F764EDB;
        Wed,  3 Mar 2021 15:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614783827;
        bh=2/sTuEpFwd93bBqjR0EAjn1gZBYjn5jEVQYV6u7dFpA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PCW/5/jdJW6J1uDynL4hdlpdZ6QFqusywN2AfcLYm89+5uQyzo1J3JJH7s7K/XLkL
         sgUlmcuKM3USbHFNSplhnyntUhX9OlSPbqBoFaSt/KzMLuCfslGc/M6EMMBS2WY0I9
         uhR+Yn64UlyVFxnxRF1BqAQiF4IFpbiKBIUIz+V4WuZs1iemvODAm2JU3HjxNEfclv
         MLLELCYqMwfFmiDOkEnxGakz1+9D2TXquyvR+HASwwyvGYVLA6yhRGQVaC6Qify45z
         apYJt1JAQfCW4sBO0+gRfWFitJi0XqhQWIm3T25ln/QYrkZLRILCwkvX3iK+D2Bn5y
         rW4U28ryssPqg==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko@kernel.org>, stable@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Sean Christopherson <seanjc@google.com>,
        Serge Ayoun <serge.ayoun@intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/5] x86/sgx: Fix a resource leak in sgx_init()
Date:   Wed,  3 Mar 2021 17:03:19 +0200
Message-Id: <20210303150323.433207-2-jarkko@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210303150323.433207-1-jarkko@kernel.org>
References: <20210303150323.433207-1-jarkko@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

If sgx_page_cache_init() fails in the middle, a trivial return statement
causes unused memory and virtual address space reserved for the EPC
section, not freed. Fix this by using the same rollback, as when
sgx_page_reclaimer_init() fails.

Cc: stable@vger.kernel.org # 5.11
Fixes: e7e0545299d8 ("x86/sgx: Initialize metadata for Enclave Page Cache (EPC) sections")
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 arch/x86/kernel/cpu/sgx/main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 8df81a3ed945..52d070fb4c9a 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -708,8 +708,10 @@ static int __init sgx_init(void)
 	if (!cpu_feature_enabled(X86_FEATURE_SGX))
 		return -ENODEV;
 
-	if (!sgx_page_cache_init())
-		return -ENOMEM;
+	if (!sgx_page_cache_init()) {
+		ret = -ENOMEM;
+		goto err_page_cache;
+	}
 
 	if (!sgx_page_reclaimer_init()) {
 		ret = -ENOMEM;
-- 
2.30.1

