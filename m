Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67A84C433E9
	for <linux-sgx@archiver.kernel.org>; Thu, 14 Jan 2021 01:57:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17B082343E
	for <linux-sgx@archiver.kernel.org>; Thu, 14 Jan 2021 01:57:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727285AbhANB4V (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 13 Jan 2021 20:56:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:54434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729557AbhAMXpH (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 13 Jan 2021 18:45:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B583123432;
        Wed, 13 Jan 2021 23:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610580955;
        bh=AeWHDtHm3Z2jSlOkzJ4b46rfdRgUvjaaMP1PgpOClqo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zi7QqehrUjX7U06+jwuIaiT5NikjgT7w2qqq+tOWxDc//rR/FPg+GvqjERXLLYe1S
         AIj4FscMZHPORty0PkuXn7f0L/55HJkwmlORscEbjFsTtU9+QjU7ky/MqFX+q9e7Ek
         v0/w3S/umrhuBGmCUB/sVXTOHMNmm7fH1/x6uDseBN3G40BieJf1lTKX5/jNPGcVlJ
         iraskq5qqLLwus1J4FnjpqljCTq19ICI/jFas6gGMDpBOdSBVRtALTRKUOmi+RAF+b
         eRzGY0miNIFp9Rkl/jS+2QoKvr1RYnkAiTiScDlwh1OwF2LKtgbt1nySwGnHKcv7xL
         PhRQ7U7FpmLEg==
From:   jarkko@kernel.org
To:     linux-sgx@vger.kernel.org
Cc:     dave.hansen@intel.com, kai.huang@intel.com, haitao.huang@intel.com,
        seanjc@google.com, "jarkko@kernel.org" <jarkko@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v4 1/2] x86/sgx: Remove a warn from sgx_free_epc_page()
Date:   Thu, 14 Jan 2021 01:35:40 +0200
Message-Id: <20210113233541.17669-2-jarkko@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210113233541.17669-1-jarkko@kernel.org>
References: <20210113233541.17669-1-jarkko@kernel.org>
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
index c519fc5f6948..ebbd3b97b3d0 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -605,8 +605,6 @@ void sgx_free_epc_page(struct sgx_epc_page *page)
 	struct sgx_epc_section *section = &sgx_epc_sections[page->section];
 	int ret;
 
-	WARN_ON_ONCE(page->flags & SGX_EPC_PAGE_RECLAIMER_TRACKED);
-
 	ret = __eremove(sgx_get_epc_virt_addr(page));
 	if (WARN_ONCE(ret, "EREMOVE returned %d (0x%x)", ret, ret))
 		return;
-- 
2.29.2

