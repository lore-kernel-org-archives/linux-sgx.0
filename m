Return-Path: <SRS0=QEGF=OT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5F52C5CFFE
	for <linux-sgx@archiver.kernel.org>; Mon, 10 Dec 2018 23:22:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A195F2081F
	for <linux-sgx@archiver.kernel.org>; Mon, 10 Dec 2018 23:22:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A195F2081F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729963AbeLJXWA (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 10 Dec 2018 18:22:00 -0500
Received: from mga04.intel.com ([192.55.52.120]:11282 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729768AbeLJXV7 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 10 Dec 2018 18:21:59 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Dec 2018 15:21:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,340,1539673200"; 
   d="scan'208";a="117684783"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.154])
  by orsmga001.jf.intel.com with ESMTP; 10 Dec 2018 15:21:57 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-sgx@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Josh Triplett <josh@joshtriplett.org>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Subject: [RFC PATCH v3 3/4] x86/traps: Attempt to fixup exceptions in vDSO before signaling
Date:   Mon, 10 Dec 2018 15:21:40 -0800
Message-Id: <20181210232141.5425-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181210232141.5425-1-sean.j.christopherson@intel.com>
References: <20181210232141.5425-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Call fixup_sgx_enclu_exception() in all trap flows that generate
signals to userspace immediately prior to generating any such signal.
If the exception is fixed, return cleanly and don't generate a signal.

Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/traps.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 9b7c4ca8f0a7..dd664503803b 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -61,6 +61,7 @@
 #include <asm/mpx.h>
 #include <asm/vm86.h>
 #include <asm/umip.h>
+#include <asm/sgx.h>
 
 #ifdef CONFIG_X86_64
 #include <asm/x86_init.h>
@@ -223,6 +224,10 @@ do_trap_no_signal(struct task_struct *tsk, int trapnr, const char *str,
 	tsk->thread.error_code = error_code;
 	tsk->thread.trap_nr = trapnr;
 
+	if (user_mode(regs) &&
+	    fixup_sgx_enclu_exception(regs, trapnr, error_code, 0))
+		return 0;
+
 	return -1;
 }
 
@@ -563,6 +568,9 @@ do_general_protection(struct pt_regs *regs, long error_code)
 	tsk->thread.error_code = error_code;
 	tsk->thread.trap_nr = X86_TRAP_GP;
 
+	if (fixup_sgx_enclu_exception(regs, X86_TRAP_GP, error_code, 0))
+		return;
+
 	show_signal(tsk, SIGSEGV, "", desc, regs, error_code);
 
 	force_sig(SIGSEGV, tsk);
@@ -791,6 +799,10 @@ dotraplinkage void do_debug(struct pt_regs *regs, long error_code)
 		goto exit;
 	}
 
+	if (user_mode(regs) &&
+	    fixup_sgx_enclu_exception(regs, X86_TRAP_DB, error_code, 0))
+		goto exit;
+
 	if (WARN_ON_ONCE((dr6 & DR_STEP) && !user_mode(regs))) {
 		/*
 		 * Historical junk that used to handle SYSENTER single-stepping.
@@ -854,6 +866,9 @@ static void math_error(struct pt_regs *regs, int error_code, int trapnr)
 	if (!si_code)
 		return;
 
+	if (fixup_sgx_enclu_exception(regs, trapnr, error_code, 0))
+		return;
+
 	force_sig_fault(SIGFPE, si_code,
 			(void __user *)uprobe_get_trap_addr(regs), task);
 }
-- 
2.19.2

