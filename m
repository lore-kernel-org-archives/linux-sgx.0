Return-Path: <SRS0=C5Ay=3X=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73CD6C35247
	for <linux-sgx@archiver.kernel.org>; Mon,  3 Feb 2020 20:02:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C49A20658
	for <linux-sgx@archiver.kernel.org>; Mon,  3 Feb 2020 20:02:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbgBCUCE (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 3 Feb 2020 15:02:04 -0500
Received: from mga17.intel.com ([192.55.52.151]:33560 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726187AbgBCUCE (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 3 Feb 2020 15:02:04 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Feb 2020 12:02:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,398,1574150400"; 
   d="scan'208";a="338595806"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 03 Feb 2020 12:02:03 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v25] x86/sgx: Fix exception fixup bug
Date:   Mon,  3 Feb 2020 12:02:02 -0800
Message-Id: <20200203200202.24729-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Call fixup_vdso_excpetion() in the user mode path of the #GP handler and
re-add the fixup_exception() call that was incorrectly sqaushed during
the rebase on to upstream/master destined for 5.6.

Fixes: 4e776e8f8be6 ("x86/traps: Attempt to fixup exceptions in vDSO before signaling")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/traps.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index f2855732b9a7..a814b1aea94d 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -522,13 +522,16 @@ dotraplinkage void do_general_protection(struct pt_regs *regs, long error_code)
 		tsk->thread.error_code = error_code;
 		tsk->thread.trap_nr = X86_TRAP_GP;
 
+		if (fixup_vdso_exception(regs, X86_TRAP_GP, error_code, 0))
+			return;
+
 		show_signal(tsk, SIGSEGV, "", desc, regs, error_code);
 		force_sig(SIGSEGV);
 
 		return;
 	}
 
-	if (fixup_vdso_exception(regs, X86_TRAP_GP, error_code, 0))
+	if (fixup_exception(regs, X86_TRAP_GP, error_code, 0))
 		return;
 
 	tsk->thread.error_code = error_code;
-- 
2.24.1

