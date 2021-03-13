Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 595B6C433E6
	for <linux-sgx@archiver.kernel.org>; Sat, 13 Mar 2021 16:02:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 163AE64F21
	for <linux-sgx@archiver.kernel.org>; Sat, 13 Mar 2021 16:02:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233570AbhCMQCD (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 13 Mar 2021 11:02:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:48066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233868AbhCMQBu (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 13 Mar 2021 11:01:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B59264F1E;
        Sat, 13 Mar 2021 16:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615651310;
        bh=HuaFV7Aup5s4tI28aR1o2B7ZXch9cKa+janu7Y/uWDY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=en7Bcj1pJwbSqsmCJ3hY0FkQ2tA65N1v8h+pQqIOAMKD9CMHRLbQSmwYKoQrJ1jUN
         31Y+f9I9Y0cML9AR0oOayF1C6ZViKrjIdm+3Rr3lN8qLuC02UoZ8/J1B1M5aDpMkyn
         Q3jfqUq9u8GoMPpesYwT3B++ReS2f2dgmKLb1+ZUhLwde+ItegYIxTvYK+u22Q0sHv
         7oit2HVyPrJDRFw+4UBGXObbAOcqIbub511CUYCOPYG64MNnWw6WR6Z+nT7PRYEd0L
         4qPKSFbwvENY9uuFOCtH8Y7ccPLRJQTN+cF/17NyiH2yChUOpoIRQo+hoamUx/YAqn
         y32Rv0nQ7DFfg==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 1/3] x86/sgx: Use sgx_free_epc_page() in sgx_reclaim_pages()
Date:   Sat, 13 Mar 2021 18:01:17 +0200
Message-Id: <20210313160119.1318533-2-jarkko@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210313160119.1318533-1-jarkko@kernel.org>
References: <20210313160119.1318533-1-jarkko@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Replace the ad-hoc code with a sgx_free_epc_page(), in order to make sure
that all the relevant checks and book keeping is done, while freeing a
borrowed EPC page, and remove redundant code. EREMOVE inside
sgx_free_epc_page() does not change the semantics, as EREMOVE to an
uninitialize pages is a nop.

Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---

v4:
* Rewrote the commit message.

 arch/x86/kernel/cpu/sgx/main.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 8df81a3ed945..65004fb8a91f 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -305,7 +305,6 @@ static void sgx_reclaim_pages(void)
 {
 	struct sgx_epc_page *chunk[SGX_NR_TO_SCAN];
 	struct sgx_backing backing[SGX_NR_TO_SCAN];
-	struct sgx_epc_section *section;
 	struct sgx_encl_page *encl_page;
 	struct sgx_epc_page *epc_page;
 	pgoff_t page_index;
@@ -378,11 +377,7 @@ static void sgx_reclaim_pages(void)
 		kref_put(&encl_page->encl->refcount, sgx_encl_release);
 		epc_page->flags &= ~SGX_EPC_PAGE_RECLAIMER_TRACKED;
 
-		section = &sgx_epc_sections[epc_page->section];
-		spin_lock(&section->lock);
-		list_add_tail(&epc_page->list, &section->page_list);
-		section->free_cnt++;
-		spin_unlock(&section->lock);
+		sgx_free_epc_page(epc_page);
 	}
 }
 
-- 
2.30.2

