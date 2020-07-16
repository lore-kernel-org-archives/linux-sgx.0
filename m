Return-Path: <SRS0=YHr7=A3=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1643C433E4
	for <linux-sgx@archiver.kernel.org>; Thu, 16 Jul 2020 13:58:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8664820787
	for <linux-sgx@archiver.kernel.org>; Thu, 16 Jul 2020 13:58:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728777AbgGPN6P (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 16 Jul 2020 09:58:15 -0400
Received: from mga06.intel.com ([134.134.136.31]:8285 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728579AbgGPN6O (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 16 Jul 2020 09:58:14 -0400
IronPort-SDR: 4bh/u52qGbkf+DzHb7UInrrRYMZXpv9V77Hbd0B2G362dHCUqJpeCQBoqilGSPblkACstCeWe3
 AqyYML6d1RrQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9683"; a="210910878"
X-IronPort-AV: E=Sophos;i="5.75,359,1589266800"; 
   d="scan'208";a="210910878"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2020 06:58:13 -0700
IronPort-SDR: BWXDzhDeG0OnfD2wXCj+mJxgU840yq8J/y/LI3qF/gA7UOUXJM1/jJs0uNRj0sjz6QdvQAKVVC
 nTX6hnXj+dBQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,359,1589266800"; 
   d="scan'208";a="325150774"
Received: from lettner-mobl.ger.corp.intel.com (HELO localhost) ([10.252.32.212])
  by FMSMGA003.fm.intel.com with ESMTP; 16 Jul 2020 06:58:01 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     x86@kernel.org, linux-sgx@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Jethro Beekman <jethro@fortanix.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, bp@alien8.de, cedric.xing@intel.com,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: [PATCH v36 20/24] x86/traps: Attempt to fixup exceptions in vDSO before signaling
Date:   Thu, 16 Jul 2020 16:52:59 +0300
Message-Id: <20200716135303.276442-21-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200716135303.276442-1-jarkko.sakkinen@linux.intel.com>
References: <20200716135303.276442-1-jarkko.sakkinen@linux.intel.com>
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
Acked-by: Jethro Beekman <jethro@fortanix.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/kernel/traps.c | 19 ++++++++++++++++---
 arch/x86/mm/fault.c     |  8 ++++++++
 2 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index b038695f36c5..c2c306f81045 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -59,6 +59,7 @@
 #include <asm/umip.h>
 #include <asm/insn.h>
 #include <asm/insn-eval.h>
+#include <asm/vdso.h>
 
 #ifdef CONFIG_X86_64
 #include <asm/x86_init.h>
@@ -117,6 +118,9 @@ do_trap_no_signal(struct task_struct *tsk, int trapnr, const char *str,
 		tsk->thread.error_code = error_code;
 		tsk->thread.trap_nr = trapnr;
 		die(str, regs, error_code);
+	} else {
+		if (fixup_vdso_exception(regs, trapnr, error_code, 0))
+			return 0;
 	}
 
 	/*
@@ -548,6 +552,9 @@ DEFINE_IDTENTRY_ERRORCODE(exc_general_protection)
 		tsk->thread.error_code = error_code;
 		tsk->thread.trap_nr = X86_TRAP_GP;
 
+		if (fixup_vdso_exception(regs, X86_TRAP_GP, error_code, 0))
+			return;
+
 		show_signal(tsk, SIGSEGV, "", desc, regs, error_code);
 		force_sig(SIGSEGV);
 		goto exit;
@@ -829,9 +836,12 @@ static void handle_debug(struct pt_regs *regs, unsigned long dr6, bool user)
 #endif
 
 	if (notify_die(DIE_DEBUG, "debug", regs, (long)&dr6, 0,
-		       SIGTRAP) == NOTIFY_STOP) {
-		return;
-	}
+		       SIGTRAP) == NOTIFY_STOP)
+		goto out;
+
+	if (user_mode(regs) &&
+	    fixup_vdso_exception(regs, X86_TRAP_DB, 0, 0))
+		goto out;
 
 	/* It's safe to allow irq's after DR6 has been saved */
 	cond_local_irq_enable(regs);
@@ -985,6 +995,9 @@ static void math_error(struct pt_regs *regs, int trapnr)
 	if (!si_code)
 		goto exit;
 
+	if (fixup_vdso_exception(regs, trapnr, 0, 0))
+		return;
+
 	force_sig_fault(SIGFPE, si_code,
 			(void __user *)uprobe_get_trap_addr(regs));
 exit:
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 8ba78384ea73..9f44ff217418 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -31,6 +31,7 @@
 #include <asm/cpu_entry_area.h>		/* exception stack		*/
 #include <asm/pgtable_areas.h>		/* VMALLOC_START, ...		*/
 #include <asm/kvm_para.h>		/* kvm_handle_async_pf		*/
+#include <asm/vdso.h>			/* fixup_vdso_exception()	*/
 
 #define CREATE_TRACE_POINTS
 #include <asm/trace/exceptions.h>
@@ -776,6 +777,10 @@ __bad_area_nosemaphore(struct pt_regs *regs, unsigned long error_code,
 
 		sanitize_error_code(address, &error_code);
 
+		if (fixup_vdso_exception(regs, X86_TRAP_PF, error_code,
+		    address))
+			return;
+
 		if (likely(show_unhandled_signals))
 			show_signal_msg(regs, error_code, address, tsk);
 
@@ -895,6 +900,9 @@ do_sigbus(struct pt_regs *regs, unsigned long error_code, unsigned long address,
 
 	sanitize_error_code(address, &error_code);
 
+	if (fixup_vdso_exception(regs, X86_TRAP_PF, error_code, address))
+		return;
+
 	set_signal_archinfo(address, error_code);
 
 #ifdef CONFIG_MEMORY_FAILURE
-- 
2.25.1

