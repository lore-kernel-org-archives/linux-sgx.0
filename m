Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21424C433B4
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Apr 2021 09:29:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E066E6113C
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Apr 2021 09:29:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbhDHJ3n (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 8 Apr 2021 05:29:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:42850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229686AbhDHJ3l (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 8 Apr 2021 05:29:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 828626101E;
        Thu,  8 Apr 2021 09:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617874171;
        bh=QnxEqpW50PQ17aznH+Xkw11Dlv/rHZN3RGa0lO7B0hQ=;
        h=From:To:Cc:Subject:Date:From;
        b=IvEY1SrPGTt15khTP/tMsGBVWPp4SghAvALc8iGjxZt1tFe4d9HuhROkUSfT4AFpl
         bcmq4R0IqlbsYu4ow3U2bH6BIdLHCUADGU6GqRYOT5tKr1ndULEwDGRX0ZBkU19uZO
         3eZ/Rb7NonkRucccI1X96qKaX4iTSPQbmBmNPnl7fOaJZcm+hb2jL6zQYNWspaWTbO
         Whfrpmy3tohHc0dylVGxHKM3CFL00Zs94Ik+Ozm8+6VpuDYWIM0tYsOhk6NE+A89Q0
         Z2Rpp4zaqmY7O0Z+vH30ubulHUmQsPuo2JX73rI9mur6DMNbxbBgdll0xlKA3SQR3n
         nC87+uYfFnhkA==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] x86/sgx: Do not update sgx_nr_free_pages in sgx_setup_epc_section()
Date:   Thu,  8 Apr 2021 12:29:24 +0300
Message-Id: <20210408092924.7032-1-jarkko@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

NUMA patches introduced this change to __sgx_sanitize_pages():

-		if (!ret)
-			list_move(&page->list, &section->page_list);
-		else
+		if (!ret) {
+			/*
+			 * page is now sanitized.  Make it available via the SGX
+			 * page allocator:
+			 */
+			list_del(&page->list);
+			sgx_free_epc_page(page);
+		} else {
+			/* The page is not yet clean - move to the dirty list. */
 			list_move_tail(&page->list, &dirty);
-
-		spin_unlock(&section->lock);
+		}

This was done for the reason that it is best to keep the logic to assign
available-for-use EPC pages to the correct NUMA lists in a single location.

The problem is that the sgx_nr_free_pages is also incremented by
sgx_free_epc_pages(), and thus it ends up having double the number of pages
available.

The count was even before NUMA patches kind of out-of-sync, i.e. free pages
count was incremented before putting them to the free list, but it didn't
matter that much, because sanitization is fairly fast and it only prevented
ksgxd to trigger small time after the system had powered on.

Fixes: 51ab30eb2ad4 ("x86/sgx: Replace section->init_laundry_list with sgx_dirty_page_list")
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
v2:
* Wrote more verbose and detailed description what is going on.
* Split out from the patches. This is urgent - the attributes can wait.
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

