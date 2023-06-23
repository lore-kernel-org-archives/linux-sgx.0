Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50427EB64D7
	for <linux-sgx@archiver.kernel.org>; Fri, 23 Jun 2023 21:21:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232970AbjFWVVr (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 23 Jun 2023 17:21:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232754AbjFWVVR (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 23 Jun 2023 17:21:17 -0400
Received: from mail3-relais-sop.national.inria.fr (mail3-relais-sop.national.inria.fr [192.134.164.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF7AD35AD
        for <linux-sgx@vger.kernel.org>; Fri, 23 Jun 2023 14:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qV5G73GxtezcE7jW6SYetBuixStXGKiX50k7hlLQiPI=;
  b=D51bNxx3+NCOjAzU8GhU1cIyLUhkDHrYSC94pyiQyblzcGfm6MHi5CUK
   TvZc5kxyOIspVbl2ClJqlsUb8ZKRt14bc0NfiU4O9w/U7pvI5eLxNyOWn
   22WDtlFdhPqTCvxDq0AwaJhrNmHKRupFifZlpHJ6E4mIZJz7yDpQt9k6Z
   8=;
Authentication-Results: mail3-relais-sop.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=Julia.Lawall@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="6.01,153,1684792800"; 
   d="scan'208";a="59686179"
Received: from i80.paris.inria.fr (HELO i80.paris.inria.fr.) ([128.93.90.48])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2023 23:15:14 +0200
From:   Julia Lawall <Julia.Lawall@inria.fr>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     keescook@chromium.org, kernel-janitors@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 21/26] x86/sgx: use array_size
Date:   Fri, 23 Jun 2023 23:14:52 +0200
Message-Id: <20230623211457.102544-22-Julia.Lawall@inria.fr>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20230623211457.102544-1-Julia.Lawall@inria.fr>
References: <20230623211457.102544-1-Julia.Lawall@inria.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Use array_size to protect against multiplication overflows.

The changes were done using the following Coccinelle semantic patch:

// <smpl>
@@
    expression E1, E2;
    constant C1, C2;
    identifier alloc = {vmalloc,vzalloc};
@@
    
(
      alloc(C1 * C2,...)
|
      alloc(
-           (E1) * (E2)
+           array_size(E1, E2)
      ,...)
)
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>

---
 arch/x86/kernel/cpu/sgx/main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 166692f2d501..3a234942c586 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -628,7 +628,8 @@ static bool __init sgx_setup_epc_section(u64 phys_addr, u64 size,
 	if (!section->virt_addr)
 		return false;
 
-	section->pages = vmalloc(nr_pages * sizeof(struct sgx_epc_page));
+	section->pages = vmalloc(array_size(nr_pages,
+					    sizeof(struct sgx_epc_page)));
 	if (!section->pages) {
 		memunmap(section->virt_addr);
 		return false;

