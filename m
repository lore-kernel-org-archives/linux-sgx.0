Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3072C43332
	for <linux-sgx@archiver.kernel.org>; Tue, 12 Jan 2021 23:35:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 987CA2312F
	for <linux-sgx@archiver.kernel.org>; Tue, 12 Jan 2021 23:35:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388321AbhALXes (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 12 Jan 2021 18:34:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:44364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388278AbhALXer (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 12 Jan 2021 18:34:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4409A23130;
        Tue, 12 Jan 2021 23:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610494447;
        bh=NXbtl2WtzdeIc2bt7rmikezjfLpPX23d6prIlV8Uhl8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cdf+J04X0qg8VDDq0CBC5WdJfPF0Exd/r7yhP1A+SIzSDbaJDcijfi5UfsiBvfhOD
         6n8ERzgcgxdAeVx5jwk3gZ86dMk/iyAgvB25hwBE9WcHzHLFhyYfzX5MGeMW7CxnkR
         4rlJdUIZG3vWnkJCKTmOPomAUoSu8fzFRjpZBCXFBMF2J+l5g2FVsZjJ1t7LgXUaGv
         ct9m6uzJ4Gm6yhgYz9WuR/jSmL+FkQkVPErQaj6CDDZ9hEBzt81QYGbz7F386v9sh/
         o8/ibzygLPY2RVWnnoH5Ysn9jOlXR4jnjIzes5KMuuLO8+porv5Sk6+oBIUkynijcM
         uON47OkHxTypg==
From:   jarkko@kernel.org
To:     linux-sgx@vger.kernel.org
Cc:     dave.hansen@intel.com, kai.huang@intel.com, haitao.huang@intel.com,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v2 1/2] x86/sgx: Remove a warn from sgx_free_epc_page()
Date:   Wed, 13 Jan 2021 01:33:50 +0200
Message-Id: <20210112233351.68678-2-jarkko@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210112233351.68678-1-jarkko@kernel.org>
References: <20210112233351.68678-1-jarkko@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

From: "jarkko@kernel.org" <jarkko@kernel.org>

Remove SGX_EPC_PAGE_RECLAIMER_TRACKED check and warning. This cannot
happen, as enclave pages are freed only at the time when encl->refcount
triggers, i.e. when both VFS and the page reclaimer have given up on
their references.

Signed-off-by: jarkko@kernel.org <jarkko@kernel.org>
---
 arch/x86/kernel/cpu/sgx/main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 0da510763c47..b2996cb63a8a 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -636,8 +636,6 @@ void sgx_free_epc_page(struct sgx_epc_page *page)
 	struct sgx_epc_section *section = &sgx_epc_sections[page->section];
 	int ret;
 
-	WARN_ON_ONCE(page->flags & SGX_EPC_PAGE_RECLAIMER_TRACKED);
-
 	ret = __eremove(sgx_get_epc_virt_addr(page));
 	if (WARN_ONCE(ret, "EREMOVE returned %d (0x%x)", ret, ret))
 		return;
-- 
2.29.2

