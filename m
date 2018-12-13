Return-Path: <SRS0=MPu7=OW=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02543C67872
	for <linux-sgx@archiver.kernel.org>; Thu, 13 Dec 2018 21:31:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C30A720811
	for <linux-sgx@archiver.kernel.org>; Thu, 13 Dec 2018 21:31:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C30A720811
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727867AbeLMVbp (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 13 Dec 2018 16:31:45 -0500
Received: from mga03.intel.com ([134.134.136.65]:43547 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727586AbeLMVbm (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 13 Dec 2018 16:31:42 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Dec 2018 13:31:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,349,1539673200"; 
   d="scan'208";a="127709243"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.154])
  by fmsmga004.fm.intel.com with ESMTP; 13 Dec 2018 13:31:41 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-sgx@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Josh Triplett <josh@joshtriplett.org>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Subject: [RFC PATCH v4 4/5] x86/traps: Attempt to fixup exceptions in vDSO before signaling
Date:   Thu, 13 Dec 2018 13:31:34 -0800
Message-Id: <20181213213135.12913-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181213213135.12913-1-sean.j.christopherson@intel.com>
References: <20181213213135.12913-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Call fixup_vdso_exception() in all trap flows that generate signals to
userspace immediately prior to generating any such signal.  If the
exception is fixed, return cleanly and do not generate a signal.

The goal of vDSO fixup is not to fixup all faults, nor is it to avoid
all signals, but rather to report faults directly to userspace when the
fault would otherwise directly result in a signal being sent to the
process.

Suggested-by: Andy Lutomirski <luto@amacapital.net>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/traps.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 9b7c4ca8f0a7..b1ca05efb15e 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -61,6 +61,7 @@
 #include <asm/mpx.h>
 #include <asm/vm86.h>
 #include <asm/umip.h>
+#include <asm/vdso.h>
 
 #ifdef CONFIG_X86_64
 #include <asm/x86_init.h>
@@ -209,6 +210,9 @@ do_trap_no_signal(struct task_struct *tsk, int trapnr, const char *str,
 		tsk->thread.error_code = error_code;
 		tsk->thread.trap_nr = trapnr;
 		die(str, regs, error_code);
+	} else {
+		if (fixup_vdso_exception(regs, trapnr, error_code, 0))
+			return 0;
 	}
 
 	/*
@@ -560,6 +564,9 @@ do_general_protection(struct pt_regs *regs, long error_code)
 		return;
 	}
 
+	if (fixup_vdso_exception(regs, X86_TRAP_GP, error_code, 0))
+		return;
+
 	tsk->thread.error_code = error_code;
 	tsk->thread.trap_nr = X86_TRAP_GP;
 
@@ -774,6 +781,10 @@ dotraplinkage void do_debug(struct pt_regs *regs, long error_code)
 							SIGTRAP) == NOTIFY_STOP)
 		goto exit;
 
+	if (user_mode(regs) &&
+	    fixup_vdso_exception(regs, X86_TRAP_DB, error_code, 0))
+		goto exit;
+
 	/*
 	 * Let others (NMI) know that the debug stack is in use
 	 * as we may switch to the interrupt stack.
@@ -854,6 +865,9 @@ static void math_error(struct pt_regs *regs, int error_code, int trapnr)
 	if (!si_code)
 		return;
 
+	if (fixup_vdso_exception(regs, trapnr, error_code, 0))
+		return;
+
 	force_sig_fault(SIGFPE, si_code,
 			(void __user *)uprobe_get_trap_addr(regs), task);
 }
-- 
2.19.2

