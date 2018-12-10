Return-Path: <SRS0=QEGF=OT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4575EC04EB8
	for <linux-sgx@archiver.kernel.org>; Mon, 10 Dec 2018 23:22:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 127142081F
	for <linux-sgx@archiver.kernel.org>; Mon, 10 Dec 2018 23:22:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 127142081F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729868AbeLJXWA (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 10 Dec 2018 18:22:00 -0500
Received: from mga04.intel.com ([192.55.52.120]:11277 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727852AbeLJXV7 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 10 Dec 2018 18:21:59 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Dec 2018 15:21:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,340,1539673200"; 
   d="scan'208";a="117684777"
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
Subject: [RFC PATCH v3 2/4] x86/fault: Attempt to fixup unhandled #PF on ENCLU before signaling
Date:   Mon, 10 Dec 2018 15:21:39 -0800
Message-Id: <20181210232141.5425-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181210232141.5425-1-sean.j.christopherson@intel.com>
References: <20181210232141.5425-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Call fixup_sgx_enclu_exception() in the SIGSEGV and SIGBUS paths of
the page fault handler immediately prior to signaling.  If the fault
is fixed, return cleanly and do not generate a signal.

In the SIGSEGV flow, make sure the error code passed to userspace has
been sanitized.

Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/mm/fault.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 7e8a7558ca07..d3903965334c 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -28,6 +28,7 @@
 #include <asm/mmu_context.h>		/* vma_pkey()			*/
 #include <asm/efi.h>			/* efi_recover_from_page_fault()*/
 #include <asm/desc.h>			/* store_idt(), ...		*/
+#include <asm/sgx.h>			/* fixup_sgx_enclu_exception()	*/
 
 #define CREATE_TRACE_POINTS
 #include <asm/trace/exceptions.h>
@@ -928,6 +929,9 @@ __bad_area_nosemaphore(struct pt_regs *regs, unsigned long error_code,
 		if (address >= TASK_SIZE_MAX)
 			error_code |= X86_PF_PROT;
 
+		if (fixup_sgx_enclu_exception(regs, X86_TRAP_PF, error_code, address))
+			return;
+
 		if (likely(show_unhandled_signals))
 			show_signal_msg(regs, error_code, address, tsk);
 
@@ -1045,6 +1049,9 @@ do_sigbus(struct pt_regs *regs, unsigned long error_code, unsigned long address,
 	if (is_prefetch(regs, error_code, address))
 		return;
 
+	if (fixup_sgx_enclu_exception(regs, X86_TRAP_PF, error_code, address))
+		return;
+
 	set_signal_archinfo(address, error_code);
 
 #ifdef CONFIG_MEMORY_FAILURE
-- 
2.19.2

