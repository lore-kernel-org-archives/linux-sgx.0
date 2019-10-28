Return-Path: <SRS0=ep0c=YV=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 355DCCA9EC1
	for <linux-sgx@archiver.kernel.org>; Mon, 28 Oct 2019 21:07:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F5C9218AC
	for <linux-sgx@archiver.kernel.org>; Mon, 28 Oct 2019 21:07:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390176AbfJ1VG7 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 28 Oct 2019 17:06:59 -0400
Received: from mga06.intel.com ([134.134.136.31]:44723 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727689AbfJ1VG6 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 28 Oct 2019 17:06:58 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 28 Oct 2019 14:06:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,241,1569308400"; 
   d="scan'208";a="224760115"
Received: from shrehore-mobl1.ti.intel.com (HELO localhost) ([10.251.82.5])
  by fmsmga004.fm.intel.com with ESMTP; 28 Oct 2019 14:06:50 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     akpm@linux-foundation.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, puiterwijk@redhat.com,
        Andy Lutomirski <luto@amacapital.net>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v23 20/24] x86/traps: Attempt to fixup exceptions in vDSO before signaling
Date:   Mon, 28 Oct 2019 23:03:20 +0200
Message-Id: <20191028210324.12475-21-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191028210324.12475-1-jarkko.sakkinen@linux.intel.com>
References: <20191028210324.12475-1-jarkko.sakkinen@linux.intel.com>
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
index 4bb0f8447112..9f06a3441f10 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -61,6 +61,7 @@
 #include <asm/mpx.h>
 #include <asm/vm86.h>
 #include <asm/umip.h>
+#include <asm/vdso.h>
 
 #ifdef CONFIG_X86_64
 #include <asm/x86_init.h>
@@ -210,6 +211,9 @@ do_trap_no_signal(struct task_struct *tsk, int trapnr, const char *str,
 		tsk->thread.error_code = error_code;
 		tsk->thread.trap_nr = trapnr;
 		die(str, regs, error_code);
+	} else {
+		if (fixup_vdso_exception(regs, trapnr, error_code, 0))
+			return 0;
 	}
 
 	/*
@@ -557,6 +561,9 @@ do_general_protection(struct pt_regs *regs, long error_code)
 		return;
 	}
 
+	if (fixup_vdso_exception(regs, X86_TRAP_GP, error_code, 0))
+		return;
+
 	tsk->thread.error_code = error_code;
 	tsk->thread.trap_nr = X86_TRAP_GP;
 
@@ -771,6 +778,10 @@ dotraplinkage void do_debug(struct pt_regs *regs, long error_code)
 							SIGTRAP) == NOTIFY_STOP)
 		goto exit;
 
+	if (user_mode(regs) &&
+	    fixup_vdso_exception(regs, X86_TRAP_DB, error_code, 0))
+		goto exit;
+
 	/*
 	 * Let others (NMI) know that the debug stack is in use
 	 * as we may switch to the interrupt stack.
@@ -851,6 +862,9 @@ static void math_error(struct pt_regs *regs, int error_code, int trapnr)
 	if (!si_code)
 		return;
 
+	if (fixup_vdso_exception(regs, trapnr, error_code, 0))
+		return;
+
 	force_sig_fault(SIGFPE, si_code,
 			(void __user *)uprobe_get_trap_addr(regs));
 }
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 0e0842e941eb..105252776172 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -29,6 +29,7 @@
 #include <asm/efi.h>			/* efi_recover_from_page_fault()*/
 #include <asm/desc.h>			/* store_idt(), ...		*/
 #include <asm/cpu_entry_area.h>		/* exception stack		*/
+#include <asm/vdso.h>			/* fixup_vdso_exception()	*/
 
 #define CREATE_TRACE_POINTS
 #include <asm/trace/exceptions.h>
@@ -901,6 +902,10 @@ __bad_area_nosemaphore(struct pt_regs *regs, unsigned long error_code,
 
 		sanitize_error_code(address, &error_code);
 
+		if (fixup_vdso_exception(regs, X86_TRAP_PF, error_code,
+		    address))
+			return;
+
 		if (likely(show_unhandled_signals))
 			show_signal_msg(regs, error_code, address, tsk);
 
@@ -1018,6 +1023,9 @@ do_sigbus(struct pt_regs *regs, unsigned long error_code, unsigned long address,
 
 	sanitize_error_code(address, &error_code);
 
+	if (fixup_vdso_exception(regs, X86_TRAP_PF, error_code, address))
+		return;
+
 	set_signal_archinfo(address, error_code);
 
 #ifdef CONFIG_MEMORY_FAILURE
-- 
2.20.1

