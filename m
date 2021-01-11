Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD4C7C433E0
	for <linux-sgx@archiver.kernel.org>; Mon, 11 Jan 2021 22:37:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9831D22CAF
	for <linux-sgx@archiver.kernel.org>; Mon, 11 Jan 2021 22:37:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387685AbhAKWhA (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 11 Jan 2021 17:37:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:57106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726725AbhAKWhA (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 11 Jan 2021 17:37:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F307022D0A;
        Mon, 11 Jan 2021 22:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610404579;
        bh=NXbtl2WtzdeIc2bt7rmikezjfLpPX23d6prIlV8Uhl8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oA0RRVPO0eGCicLfjquDbN02OdWYVY8mHu8OjcwGTB29QZst+qCGmxc+JW63/jtz+
         rkP/IdiUvooE2bTIWqlz23NNxMEwHh/E02fuBZzTK0cSiAHKUDKb2fNpXlZ2xZjTw3
         DfFGRF4KSIPBij8HP19EniYl0SCIg48KEpy9jJJeGzwIC+N2fonRb/ufIE4SwmlUax
         hAElPyaEZyiS+kgV2whBqsMz4i7AlK6Px3JqhPwTUe9k/CPkreoQ/8+Dve4WcUULWh
         15/vazaFbbSd5Obaa/dNNttw4aTFFtYm5PvHJd1ofnUhlwLj0Yfq6VxMwjSwj9om3/
         jvjcf9B4xprBw==
From:   jarkko@kernel.org
To:     linux-sgx@vger.kernel.org
Cc:     kai.huang@intel.com, dave.hansen@intel.com, haitao.huang@intel.com,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 1/2] x86/sgx: Remove a warn from sgx_free_epc_page()
Date:   Tue, 12 Jan 2021 00:36:09 +0200
Message-Id: <20210111223610.62261-2-jarkko@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210111223610.62261-1-jarkko@kernel.org>
References: <20210111223610.62261-1-jarkko@kernel.org>
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

