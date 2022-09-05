Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5462DECAAD3
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Sep 2022 23:54:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232630AbiIEXyo (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 5 Sep 2022 19:54:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232355AbiIEXyh (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 5 Sep 2022 19:54:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9B592BDD;
        Mon,  5 Sep 2022 16:54:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2716EB8076C;
        Mon,  5 Sep 2022 23:54:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79235C433D7;
        Mon,  5 Sep 2022 23:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662422070;
        bh=oHvBd1ffjg/s99ZfllkCt1FwNVqrZNIyO0l4IQri3jg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p80gw7rQuiV6cd187I7r7hGa76cgPTs1uokk/W+dlXSP+2oLyl+DZ7YnfiZ81PmLn
         laoROTnP/I6oBqwsJszakMj6pZPhUe5u9XB1WMsrbB/bN+sGppqs3m2YuVOtSZV8Ja
         T7yHcM2s245THucsIg4hzW9sOGpbPlsnsSUoKVT5gnwQ0xezUqbOQtMiepAt/yLois
         q1FlItvmEJplUNaEerZO4ljGeHrk8MtKib7GZX0yC7AQGSfWY7K+iWLorvFY4j2by0
         KawqedoQfopcfxKqQBPD+XHkqSE8SqJyEt8aruYwXQxhFot/G1HpOXcy548FEwIGgD
         NbM9FRuQJr++g==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-sgx@vger.kernel.org
Cc:     Haitao Huang <haitao.huang@linux.intel.com>,
        Vijay Dhanraj <vijay.dhanraj@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)),
        "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT))
Subject: [PATCH v2 2/2] x86/sgx: Handle VA page allocation failure for EAUG on PF.
Date:   Tue,  6 Sep 2022 02:54:15 +0300
Message-Id: <20220905235415.9519-3-jarkko@kernel.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220905235415.9519-1-jarkko@kernel.org>
References: <20220905235415.9519-1-jarkko@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

From: Haitao Huang <haitao.huang@linux.intel.com>

VM_FAULT_NOPAGE is expected behaviour for -EBUSY failure path, when
augmenting a page, as this means that the reclaimer thread has been
triggered, and the intention is just to round-trip in ring-3, and
retry with a new page fault.

Fixes: 5a90d2c3f5ef ("x86/sgx: Support adding of pages to an initialized enclave")
Signed-off-by: Haitao Huang <haitao.huang@linux.intel.com>
Tested-by: Vijay Dhanraj <vijay.dhanraj@intel.com>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
v4:
* Remove extra white space.

v3:
* Added Reinette's ack.

v2:
* Removed reviewed-by, no other changes.
---
 arch/x86/kernel/cpu/sgx/encl.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index f40d64206ded..9f13d724172e 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -347,8 +347,11 @@ static vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
 	}
 
 	va_page = sgx_encl_grow(encl, false);
-	if (IS_ERR(va_page))
+	if (IS_ERR(va_page)) {
+		if (PTR_ERR(va_page) == -EBUSY)
+			vmret = VM_FAULT_NOPAGE;
 		goto err_out_epc;
+	}
 
 	if (va_page)
 		list_add(&va_page->list, &encl->va_pages);
-- 
2.37.2

