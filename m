Return-Path: <SRS0=QEGF=OT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9AE3C67839
	for <linux-sgx@archiver.kernel.org>; Mon, 10 Dec 2018 23:22:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F8622081F
	for <linux-sgx@archiver.kernel.org>; Mon, 10 Dec 2018 23:22:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6F8622081F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729965AbeLJXWA (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 10 Dec 2018 18:22:00 -0500
Received: from mga04.intel.com ([192.55.52.120]:11277 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727919AbeLJXV7 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 10 Dec 2018 18:21:59 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Dec 2018 15:21:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,340,1539673200"; 
   d="scan'208";a="117684769"
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
Subject: [RFC PATCH v3 1/4] x86/sgx: Add a per-mm ENCLU exception fixup handler
Date:   Mon, 10 Dec 2018 15:21:38 -0800
Message-Id: <20181210232141.5425-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181210232141.5425-1-sean.j.christopherson@intel.com>
References: <20181210232141.5425-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Intel Software Guard Extensions (SGX) introduces a new CPL3-only
"enclave" mode that runs as a sort of black box shared object that is
hosted by an untrusted "normal" CPl3 process.

Entering an enclave can only be done through SGX-specific instructions,
EENTER and ERESUME, and is a non-trivial process.  Because of the
complexity of transitioning to/from an enclave, the vast majority of
enclaves are expected to utilize a library to handle the actual
transitions.  This is roughly analogous to how e.g. a libc and dynamic
linker are used by most applications.

Another crucial characteristic of SGX enclaves is that they can generate
exceptions as part of their normal (at least as "normal" as SGX can be)
operation that need to be handled *in* the enclave and/or are unique
to SGX.

And because they are essentially fancy shared objects, a process can
host any number of enclaves, each of which can execute multiple threads
simultaneously.

Putting everything together, userspace enclaves will utilize a library
that must be prepared to handle any and (almost) all exceptions any time
at least one thread may be executing in an enclave.  Leveraging signals
to handle the enclave exceptions is unpleasant, to put it mildly, e.g.
the SGX library must constantly (un)register its signal handler based
on whether or not at least one thread is executing in an enclave, and
filter and forward exceptions that aren't related to its enclaves.  This
becomes particularly nasty when using multiple levels of libraries that
register signal handlers, e.g. running an enclave via cgo inside of the
Go runtime.

Add per-mm, i.e. per-process, exception fixup on ENCLU to so that the
kernel can redirect unhandled exceptions, i.e. exceptions would otherwise
generate a signal, to a user-provided exception handler.  The exception
handler ABI roughly follows the System V 64-bit ABI for function calls:

  - %rdi: trap number
  - %rsi: error code
  - %rdx: address

Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/mmu.h     |  4 ++++
 arch/x86/include/asm/sgx.h     | 13 +++++++++++++
 arch/x86/kernel/cpu/sgx/main.c | 18 ++++++++++++++++++
 3 files changed, 35 insertions(+)

diff --git a/arch/x86/include/asm/mmu.h b/arch/x86/include/asm/mmu.h
index 5ff3e8af2c20..1665c84e5844 100644
--- a/arch/x86/include/asm/mmu.h
+++ b/arch/x86/include/asm/mmu.h
@@ -54,6 +54,10 @@ typedef struct {
 	/* address of the bounds directory */
 	void __user *bd_addr;
 #endif
+#ifdef CONFIG_INTEL_SGX_CORE
+	unsigned long enclu_address;
+	unsigned long enclu_exception_handler;
+#endif
 } mm_context_t;
 
 #define INIT_MM_CONTEXT(mm)						\
diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
index d4f61d1c5c2a..bbf808a0ca91 100644
--- a/arch/x86/include/asm/sgx.h
+++ b/arch/x86/include/asm/sgx.h
@@ -309,6 +309,19 @@ static inline int __emodt(struct sgx_secinfo *secinfo, void *addr)
 	return __encls_ret_2(SGX_EMODT, secinfo, addr);
 }
 
+#ifdef CONFIG_INTEL_SGX_CORE
+extern bool fixup_sgx_enclu_exception(struct pt_regs *regs, int trapnr,
+				      unsigned long error_code,
+				      unsigned long fault_addr);
+#else
+static inline bool fixup_sgx_enclu_exception(struct pt_regs *regs, int trapnr,
+					     unsigned long error_code,
+					     unsigned long fault_addr)
+{
+	return false;
+}
+#endif
+
 struct sgx_epc_page *sgx_alloc_page(void *owner, bool reclaim);
 int __sgx_free_page(struct sgx_epc_page *page);
 void sgx_free_page(struct sgx_epc_page *page);
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 30fd69f1fc07..1994e003581d 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -363,6 +363,24 @@ void sgx_page_reclaimable(struct sgx_epc_page *page)
 }
 EXPORT_SYMBOL_GPL(sgx_page_reclaimable);
 
+bool fixup_sgx_enclu_exception(struct pt_regs *regs, int trapnr,
+			       unsigned long error_code,
+			       unsigned long fault_addr)
+{
+	if (current->mm->context.enclu_address != regs->ip)
+		return false;
+
+	if (!current->mm->context.enclu_address &&
+	    !current->mm->context.enclu_exception_handler)
+		return false;
+
+	regs->ip = current->mm->context.enclu_exception_handler;
+	regs->di = trapnr;
+	regs->si = error_code;
+	regs->dx = fault_addr;
+	return true;
+}
+
 static __init void sgx_free_epc_section(struct sgx_epc_section *section)
 {
 	struct sgx_epc_page *page;
-- 
2.19.2

