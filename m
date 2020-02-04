Return-Path: <SRS0=RGqr=3Y=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84C12C3524A
	for <linux-sgx@archiver.kernel.org>; Tue,  4 Feb 2020 06:07:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62E6120674
	for <linux-sgx@archiver.kernel.org>; Tue,  4 Feb 2020 06:07:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbgBDGHq (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 4 Feb 2020 01:07:46 -0500
Received: from mga06.intel.com ([134.134.136.31]:62011 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726343AbgBDGHq (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 4 Feb 2020 01:07:46 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Feb 2020 22:07:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,398,1574150400"; 
   d="scan'208";a="249242505"
Received: from ncouniha-mobl6.ger.corp.intel.com (HELO localhost) ([10.252.20.163])
  by orsmga002.jf.intel.com with ESMTP; 03 Feb 2020 22:07:37 -0800
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     akpm@linux-foundation.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, puiterwijk@redhat.com,
        Andy Lutomirski <luto@amacapital.net>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v25 18/21] x86/traps: Attempt to fixup exceptions in vDSO before signaling
Date:   Tue,  4 Feb 2020 08:05:42 +0200
Message-Id: <20200204060545.31729-19-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200204060545.31729-1-jarkko.sakkinen@linux.intel.com>
References: <20200204060545.31729-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

vDSO functions can now leverage an exception fixup mechanism similar to
kernel exception fixup.  For vDSO exception fixup, the initial user is
Intel's Software Guard Extensions (SGX), which will wrap the low-level
transitions to/from the enclave, i.e. EENTER and ERESUME instructions,
in a vDSO function and leverage fixup to intercept exceptions that would
otherwise generate a signal.  This allows the vDSO wrapper to return the
fault information directly to its caller, obviating the need for SGX
applications and libraries to juggle signal handlers.

Attempt to fixup vDSO exceptions immediately prior to populating and
sending signal information.  Except for the delivery mechanism, an
exception in a vDSO function should be treated like any other exception
in userspace, e.g. any fault that is successfully handled by the kernel
should not be directly visible to userspace.

Although it's debatable whether or not all exceptions are of interest to
enclaves, defer to the vDSO fixup to decide whether to do fixup or
generate a signal.  Future users of vDSO fixup, if there ever are any,
will undoubtedly have different requirements than SGX enclaves, e.g. the
fixup vs. signal logic can be made function specific if/when necessary.

Suggested-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/kernel/traps.c | 14 ++++++++++++++
 arch/x86/mm/fault.c     |  8 ++++++++
 2 files changed, 22 insertions(+)

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 6ef00eb6fbb9..a814b1aea94d 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -56,6 +56,7 @@
 #include <asm/umip.h>
 #include <asm/insn.h>
 #include <asm/insn-eval.h>
+#include <asm/vdso.h>
 
 #ifdef CONFIG_X86_64
 #include <asm/x86_init.h>
@@ -205,6 +206,9 @@ do_trap_no_signal(struct task_struct *tsk, int trapnr, const char *str,
 		tsk->thread.error_code = error_code;
 		tsk->thread.trap_nr = trapnr;
 		die(str, regs, error_code);
+	} else {
+		if (fixup_vdso_exception(regs, trapnr, error_code, 0))
+			return 0;
 	}
 
 	/*
@@ -518,6 +522,9 @@ dotraplinkage void do_general_protection(struct pt_regs *regs, long error_code)
 		tsk->thread.error_code = error_code;
 		tsk->thread.trap_nr = X86_TRAP_GP;
 
+		if (fixup_vdso_exception(regs, X86_TRAP_GP, error_code, 0))
+			return;
+
 		show_signal(tsk, SIGSEGV, "", desc, regs, error_code);
 		force_sig(SIGSEGV);
 
@@ -762,6 +769,10 @@ dotraplinkage void do_debug(struct pt_regs *regs, long error_code)
 							SIGTRAP) == NOTIFY_STOP)
 		goto exit;
 
+	if (user_mode(regs) &&
+	    fixup_vdso_exception(regs, X86_TRAP_DB, error_code, 0))
+		goto exit;
+
 	/*
 	 * Let others (NMI) know that the debug stack is in use
 	 * as we may switch to the interrupt stack.
@@ -842,6 +853,9 @@ static void math_error(struct pt_regs *regs, int error_code, int trapnr)
 	if (!si_code)
 		return;
 
+	if (fixup_vdso_exception(regs, trapnr, error_code, 0))
+		return;
+
 	force_sig_fault(SIGFPE, si_code,
 			(void __user *)uprobe_get_trap_addr(regs));
 }
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 6b662d272af6..42965b47b52f 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -30,6 +30,7 @@
 #include <asm/desc.h>			/* store_idt(), ...		*/
 #include <asm/cpu_entry_area.h>		/* exception stack		*/
 #include <asm/pgtable_areas.h>		/* VMALLOC_START, ...		*/
+#include <asm/vdso.h>			/* fixup_vdso_exception()	*/
 
 #define CREATE_TRACE_POINTS
 #include <asm/trace/exceptions.h>
@@ -902,6 +903,10 @@ __bad_area_nosemaphore(struct pt_regs *regs, unsigned long error_code,
 
 		sanitize_error_code(address, &error_code);
 
+		if (fixup_vdso_exception(regs, X86_TRAP_PF, error_code,
+		    address))
+			return;
+
 		if (likely(show_unhandled_signals))
 			show_signal_msg(regs, error_code, address, tsk);
 
@@ -1019,6 +1024,9 @@ do_sigbus(struct pt_regs *regs, unsigned long error_code, unsigned long address,
 
 	sanitize_error_code(address, &error_code);
 
+	if (fixup_vdso_exception(regs, X86_TRAP_PF, error_code, address))
+		return;
+
 	set_signal_archinfo(address, error_code);
 
 #ifdef CONFIG_MEMORY_FAILURE
-- 
2.20.1

