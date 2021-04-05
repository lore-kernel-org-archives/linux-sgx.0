Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 735D9C433ED
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Apr 2021 23:27:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22D85613E1
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Apr 2021 23:27:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235557AbhDEX1H (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 5 Apr 2021 19:27:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:54166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232988AbhDEX1G (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 5 Apr 2021 19:27:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5BA0613D4;
        Mon,  5 Apr 2021 23:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617665219;
        bh=DVhvbkayKQRZoHCJPwVZHRfMdZrxAA8cxJGn4nwa/Jg=;
        h=From:To:Cc:Subject:Date:From;
        b=QpwbXQmePDuOFJddLo6vDkzrq2UTSayFH3JhJCtZS84vOr+JtF6R6vUL1gfB1VpOB
         X3pp11Ug23r7ZlilfMD2Bw0NdWVXCsTu/TZfHgI307K52VXdxMATQ7lerYiWURHD9d
         tXGzC3KFyTotbP8+NWVSVCnIJtocHiqkZVbQVA0L8NLLSQkkSA2CtTkTh0Xt/c/6zm
         kY4SpT6BmZOxpowBbZaEGx0AkWsc2r8rC4zJSfi1VQrrbOKqwssGXQneeKP3KLV6m1
         gvkraNJwDM5ZiEOj+rNq2zZ5qP6j7N8mea3N6DIqQHr/bzvILGv9yDxbYhazQiw38+
         n9shKWejfZ8Nw==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] x86/sgx: Do not update sgx_nr_free_pages in sgx_setup_epc_section()
Date:   Tue,  6 Apr 2021 02:26:52 +0300
Message-Id: <20210405232653.33680-1-jarkko@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Now that the sanitization process will make pages available by calling
sgx_free_epc_page(), sgx_setup_epc_section() should not touch to
sgx_nr_free_pages. This will result sgx_nr_free_pages to contain 2x the
number of actual free pages. Simply, remove the statement.

Fixes: 51ab30eb2ad4 ("x86/sgx: Replace section->init_laundry_list with sgx_dirty_page_list")
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 arch/x86/kernel/cpu/sgx/main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 13a7599ce7d4..7df7048cb1c9 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -657,7 +657,6 @@ static bool __init sgx_setup_epc_section(u64 phys_addr, u64 size,
 		list_add_tail(&section->pages[i].list, &sgx_dirty_page_list);
 	}
 
-	sgx_nr_free_pages += nr_pages;
 	return true;
 }
 
-- 
2.31.1

