Return-Path: <SRS0=y25d=B4=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAEF0C433E4
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Aug 2020 04:24:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AAAC20706
	for <linux-sgx@archiver.kernel.org>; Tue, 18 Aug 2020 04:24:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbgHREYJ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 18 Aug 2020 00:24:09 -0400
Received: from mga07.intel.com ([134.134.136.100]:16710 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726483AbgHREYI (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 18 Aug 2020 00:24:08 -0400
IronPort-SDR: xrglv+LES4D5DrNFQ1io5QDgchMQoLfJLu2fISgEV98dgoeLaaEkdxr5dvRmT0E+CMuhqf1O4U
 kbYGv+GCAlsg==
X-IronPort-AV: E=McAfee;i="6000,8403,9716"; a="219156477"
X-IronPort-AV: E=Sophos;i="5.76,326,1592895600"; 
   d="scan'208";a="219156477"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2020 21:24:06 -0700
IronPort-SDR: sDVSplS0zf5RnQ5XgoLlvK07JwD4FBVI04JoYKw7Xmdy5bw8JMB8XWj/LTjlsLckZd4SjsnjtH
 H71e4mIPVtgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,326,1592895600"; 
   d="scan'208";a="334270270"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by FMSMGA003.fm.intel.com with ESMTP; 17 Aug 2020 21:24:06 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Nathaniel McCallum <npmccallum@redhat.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-sgx@vger.kernel.org
Subject: [RFC PATCH 3/4] x86/vdso: x86/sgx: Introduce dedicated SGX exit reasons for vDSO
Date:   Mon, 17 Aug 2020 21:24:04 -0700
Message-Id: <20200818042405.12871-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200818042405.12871-1-sean.j.christopherson@intel.com>
References: <20200818042405.12871-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Use dedicated exit reasons, e.g. SYNCHRONOUS and EXCEPTION, instead of
'0' and '-EFAULT' respectively.  Using -EFAULT is less than desirable as
it usually means "bad address", which may or may not be true for a fault
in the enclave or on ENCLU.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/entry/vdso/vsgx_enter_enclave.S | 7 +++++--
 arch/x86/include/uapi/asm/sgx.h          | 3 +++
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.S b/arch/x86/entry/vdso/vsgx_enter_enclave.S
index aaae6d6e28ac3..b09e87dbe9334 100644
--- a/arch/x86/entry/vdso/vsgx_enter_enclave.S
+++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
@@ -19,6 +19,9 @@
 /* #define USER_DATA_OFFSET	4*8 */
 #define EXCEPTION_OFFSET	5*8
 
+#define SGX_SYNCHRONOUS_EXIT	0
+#define SGX_EXCEPTION_EXIT	1
+
 /* Offsets into sgx_enter_enclave.exception. */
 #define EX_TRAPNR	0*8
 #define EX_ERROR_CODE	0*8+2
@@ -65,7 +68,7 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
 	mov	RUN_OFFSET(%rbp), %rbx
 
 	/* Set exit_reason. */
-	movl	$0, EXIT_REASON_OFFSET(%rbx)
+	movl	$SGX_SYNCHRONOUS_EXIT, EXIT_REASON_OFFSET(%rbx)
 
 	/* Invoke userspace's exit handler if one was provided. */
 .Lhandle_exit:
@@ -94,7 +97,7 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
 	mov	RUN_OFFSET(%rbp), %rbx
 
 	/* Set the exit_reason and exception info. */
-	movl	$(-EFAULT), EXIT_REASON_OFFSET(%rbx)
+	movl	$SGX_EXCEPTION_EXIT, EXIT_REASON_OFFSET(%rbx)
 
 	mov	%di,  (EXCEPTION_OFFSET + EX_TRAPNR)(%rbx)
 	mov	%si,  (EXCEPTION_OFFSET + EX_ERROR_CODE)(%rbx)
diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
index d3b107aac279d..80a8b7a949a23 100644
--- a/arch/x86/include/uapi/asm/sgx.h
+++ b/arch/x86/include/uapi/asm/sgx.h
@@ -74,6 +74,9 @@ struct sgx_enclave_set_attribute {
 	__u64 attribute_fd;
 };
 
+#define SGX_SYNCHRONOUS_EXIT	0
+#define SGX_EXCEPTION_EXIT	1
+
 struct sgx_enclave_run;
 
 /**
-- 
2.28.0

