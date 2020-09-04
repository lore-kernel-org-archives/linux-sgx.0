Return-Path: <SRS0=DCUR=CN=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BE80C43461
	for <linux-sgx@archiver.kernel.org>; Fri,  4 Sep 2020 10:45:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 318482087C
	for <linux-sgx@archiver.kernel.org>; Fri,  4 Sep 2020 10:45:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729946AbgIDKpE (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 4 Sep 2020 06:45:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:43123 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729795AbgIDKpD (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 4 Sep 2020 06:45:03 -0400
IronPort-SDR: 6YZyB7Ig6EnqBfvFdR7CPhkan87xcCJhgblKUuuRSQqYRNjWB+x6ixfBifiTkB2QZB7KuIq9tg
 FM8f8JsmoDIQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9733"; a="145455663"
X-IronPort-AV: E=Sophos;i="5.76,389,1592895600"; 
   d="scan'208";a="145455663"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2020 03:44:47 -0700
IronPort-SDR: vQr7ifsOxoy402ul/b9x6ktU0UDpq+5keFntT8d/u24LmxvaAuf46r/8bTjz27Zl2x4B3d6Oo5
 U4rQHJypQiUw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,389,1592895600"; 
   d="scan'208";a="283026283"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.160])
  by fmsmga007.fm.intel.com with ESMTP; 04 Sep 2020 03:44:47 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Nathaniel McCallum <npmccallum@redhat.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-sgx@vger.kernel.org
Subject: [PATCH for_v37 3/6] x86/vdso: x86/sgx: Introduce dedicated SGX exit reasons for vDSO
Date:   Fri,  4 Sep 2020 03:44:34 -0700
Message-Id: <20200904104437.29555-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200904104437.29555-1-sean.j.christopherson@intel.com>
References: <20200904104437.29555-1-sean.j.christopherson@intel.com>
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
index 4fe3d06dd7878..adbd59d415171 100644
--- a/arch/x86/entry/vdso/vsgx_enter_enclave.S
+++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
@@ -18,6 +18,9 @@
 /* #define SGX_ENCLAVE_RUN_USER_DATA	3*8 */
 #define SGX_ENCLAVE_RUN_EXCEPTION	4*8
 
+#define SGX_SYNCHRONOUS_EXIT		0
+#define SGX_EXCEPTION_EXIT		1
+
 /* Offsets into sgx_enter_enclave.exception. */
 #define SGX_EX_LEAF			0*8
 #define SGX_EX_TRAPNR			0*8+4
@@ -65,7 +68,7 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
 	mov	SGX_ENCLAVE_RUN_PTR(%rbp), %rbx
 
 	/* Set exit_reason. */
-	movl	$0, SGX_ENCLAVE_RUN_EXIT_REASON(%rbx)
+	movl	$SGX_SYNCHRONOUS_EXIT, SGX_ENCLAVE_RUN_EXIT_REASON(%rbx)
 
 	/* Invoke userspace's exit handler if one was provided. */
 .Lhandle_exit:
@@ -92,7 +95,7 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
 	mov	SGX_ENCLAVE_RUN_PTR(%rbp), %rbx
 
 	/* Set the exit_reason and exception info. */
-	movl	$(-EFAULT), SGX_ENCLAVE_RUN_EXIT_REASON(%rbx)
+	movl	$SGX_EXCEPTION_EXIT, SGX_ENCLAVE_RUN_EXIT_REASON(%rbx)
 
 	mov	%eax, (SGX_ENCLAVE_RUN_EXCEPTION + SGX_EX_LEAF)(%rbx)
 	mov	%di,  (SGX_ENCLAVE_RUN_EXCEPTION + SGX_EX_TRAPNR)(%rbx)
diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
index 608daccc46553..b1d63f90ad643 100644
--- a/arch/x86/include/uapi/asm/sgx.h
+++ b/arch/x86/include/uapi/asm/sgx.h
@@ -74,6 +74,9 @@ struct sgx_enclave_provision {
 	__u64 attribute_fd;
 };
 
+#define SGX_SYNCHRONOUS_EXIT	0
+#define SGX_EXCEPTION_EXIT	1
+
 struct sgx_enclave_run;
 
 /**
-- 
2.28.0

