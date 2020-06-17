Return-Path: <SRS0=OlnE=76=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65CE1C433DF
	for <linux-sgx@archiver.kernel.org>; Wed, 17 Jun 2020 22:12:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42DF321919
	for <linux-sgx@archiver.kernel.org>; Wed, 17 Jun 2020 22:12:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbgFQWM6 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 17 Jun 2020 18:12:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:37642 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726840AbgFQWM5 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 17 Jun 2020 18:12:57 -0400
IronPort-SDR: tWPTq/Xzq2AsQDzjyn3Gob9kF1MtvgeiioRaWnMRVhstsJ5mCLb8fVyc8frilcw0RWNo8w796T
 QDVR4Y189leQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jun 2020 15:12:57 -0700
IronPort-SDR: 9rvGj4OwJL1vKHo52XOwewQjwZ+jOS5Ulbl/H4SeIq+7oOsNpL//DVTgG4M7+tuGUvZYgmhYFl
 9UaP0pE+Ycxg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,523,1583222400"; 
   d="scan'208";a="421288646"
Received: from ysharon1-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.49.131])
  by orsmga004.jf.intel.com with ESMTP; 17 Jun 2020 15:12:45 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     x86@kernel.org, linux-sgx@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
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
Subject: [PATCH v33 16/21] x86/fault: Add helper function to sanitize error code
Date:   Thu, 18 Jun 2020 01:08:38 +0300
Message-Id: <20200617220844.57423-17-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200617220844.57423-1-jarkko.sakkinen@linux.intel.com>
References: <20200617220844.57423-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Add helper function to sanitize error code to prepare for vDSO exception
fixup, which will expose the error code to userspace and runs before
set_signal_archinfo(), i.e. suppresses the signal when fixup is successful.

Acked-by: Jethro Beekman <jethro@fortanix.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/mm/fault.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 25d48aae36c1..966af17523fb 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -556,6 +556,18 @@ pgtable_bad(struct pt_regs *regs, unsigned long error_code,
 	oops_end(flags, regs, sig);
 }
 
+static void sanitize_error_code(unsigned long address,
+				unsigned long *error_code)
+{
+	/*
+	 * To avoid leaking information about the kernel page
+	 * table layout, pretend that user-mode accesses to
+	 * kernel addresses are always protection faults.
+	 */
+	if (address >= TASK_SIZE_MAX)
+		*error_code |= X86_PF_PROT;
+}
+
 static void set_signal_archinfo(unsigned long address,
 				unsigned long error_code)
 {
@@ -612,6 +624,8 @@ no_context(struct pt_regs *regs, unsigned long error_code,
 		 * faulting through the emulate_vsyscall() logic.
 		 */
 		if (current->thread.sig_on_uaccess_err && signal) {
+			sanitize_error_code(address, &error_code);
+
 			set_signal_archinfo(address, error_code);
 
 			/* XXX: hwpoison faults will set the wrong code. */
@@ -760,13 +774,7 @@ __bad_area_nosemaphore(struct pt_regs *regs, unsigned long error_code,
 		if (is_errata100(regs, address))
 			return;
 
-		/*
-		 * To avoid leaking information about the kernel page table
-		 * layout, pretend that user-mode accesses to kernel addresses
-		 * are always protection faults.
-		 */
-		if (address >= TASK_SIZE_MAX)
-			error_code |= X86_PF_PROT;
+		sanitize_error_code(address, &error_code);
 
 		if (likely(show_unhandled_signals))
 			show_signal_msg(regs, error_code, address, tsk);
@@ -885,6 +893,8 @@ do_sigbus(struct pt_regs *regs, unsigned long error_code, unsigned long address,
 	if (is_prefetch(regs, error_code, address))
 		return;
 
+	sanitize_error_code(address, &error_code);
+
 	set_signal_archinfo(address, error_code);
 
 #ifdef CONFIG_MEMORY_FAILURE
-- 
2.25.1

