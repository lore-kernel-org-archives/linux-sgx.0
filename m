Return-Path: <SRS0=X7Hr=6F=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B97DC55186
	for <linux-sgx@archiver.kernel.org>; Tue, 21 Apr 2020 21:54:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 211E7206D9
	for <linux-sgx@archiver.kernel.org>; Tue, 21 Apr 2020 21:54:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbgDUVy5 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 21 Apr 2020 17:54:57 -0400
Received: from mga18.intel.com ([134.134.136.126]:11684 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726328AbgDUVy5 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 21 Apr 2020 17:54:57 -0400
IronPort-SDR: 8iAQZYegnjZZRRTHn56CI5XL3i9j5U4wHmH0z9nXPOKULjD3nIboYRcXaqfkZc41pQMDa8jKDx
 nULcA2K4Z8Dg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2020 14:54:56 -0700
IronPort-SDR: +Ytifug0Cko3ABfHqixzgKVqE8Z6cjILTlxeuCnWXu6HF7xZQxu1morvMW6g1R2y0zrK5fgH2f
 CYjLdzB7hfXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,411,1580803200"; 
   d="scan'208";a="456260810"
Received: from mnchalux-mobl2.gar.corp.intel.com (HELO localhost) ([10.252.44.234])
  by fmsmga005.fm.intel.com with ESMTP; 21 Apr 2020 14:54:51 -0700
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
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v29 16/20] x86/fault: Add helper function to sanitize error code
Date:   Wed, 22 Apr 2020 00:53:12 +0300
Message-Id: <20200421215316.56503-17-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200421215316.56503-1-jarkko.sakkinen@linux.intel.com>
References: <20200421215316.56503-1-jarkko.sakkinen@linux.intel.com>
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

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/mm/fault.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index dee9504cde79..6b662d272af6 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -682,6 +682,18 @@ pgtable_bad(struct pt_regs *regs, unsigned long error_code,
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
@@ -738,6 +750,8 @@ no_context(struct pt_regs *regs, unsigned long error_code,
 		 * faulting through the emulate_vsyscall() logic.
 		 */
 		if (current->thread.sig_on_uaccess_err && signal) {
+			sanitize_error_code(address, &error_code);
+
 			set_signal_archinfo(address, error_code);
 
 			/* XXX: hwpoison faults will set the wrong code. */
@@ -886,13 +900,7 @@ __bad_area_nosemaphore(struct pt_regs *regs, unsigned long error_code,
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
@@ -1009,6 +1017,8 @@ do_sigbus(struct pt_regs *regs, unsigned long error_code, unsigned long address,
 	if (is_prefetch(regs, error_code, address))
 		return;
 
+	sanitize_error_code(address, &error_code);
+
 	set_signal_archinfo(address, error_code);
 
 #ifdef CONFIG_MEMORY_FAILURE
-- 
2.25.1

