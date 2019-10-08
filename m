Return-Path: <SRS0=MdAf=YB=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B9C2ECE597
	for <linux-sgx@archiver.kernel.org>; Tue,  8 Oct 2019 04:46:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73841206C2
	for <linux-sgx@archiver.kernel.org>; Tue,  8 Oct 2019 04:46:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729500AbfJHEqQ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 8 Oct 2019 00:46:16 -0400
Received: from mga11.intel.com ([192.55.52.93]:8175 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729285AbfJHEqQ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 8 Oct 2019 00:46:16 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Oct 2019 21:46:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,269,1566889200"; 
   d="scan'208";a="206566500"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga001.fm.intel.com with ESMTP; 07 Oct 2019 21:46:15 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v23 04/16] x86/vdso: sgx: Move enclave exit handler declaration to UAPI header
Date:   Mon,  7 Oct 2019 21:46:01 -0700
Message-Id: <20191008044613.12350-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191008044613.12350-1-sean.j.christopherson@intel.com>
References: <20191008044613.12350-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Move the typedef of the enclave exit handler to the UAPI header so that
it can be consumed by userspace and kernel-doc.  Add a proper comment,
primarily to document the parameters.  A future patch will update the
comment for __vdso_sgx_enter_enclave() to better describe how the
exit handler is used.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/entry/vdso/vsgx_enter_enclave.S |  3 ---
 arch/x86/include/uapi/asm/sgx.h          | 18 ++++++++++++++++++
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.S b/arch/x86/entry/vdso/vsgx_enter_enclave.S
index 5fbe07a03e6c..a382f3683b48 100644
--- a/arch/x86/entry/vdso/vsgx_enter_enclave.S
+++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
@@ -53,9 +53,6 @@
  *    -EFAULT if ENCL or the enclave faults or non-positive value is returned
  *     from the callback.
  */
-typedef int (*sgx_enclave_exit_handler_t)(long rdi, long rsi, long rdx, int ret,
-					  long r8, long r9, void *tcs, long ursp,
-					  struct sgx_enclave_exception *e);
 int __vdso_sgx_enter_enclave(int leaf, void *tcs,
 			     struct sgx_enclave_exception *e,
 			     sgx_enclave_exit_handler_t handler);
diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
index 8f4660e07f6b..0515de4e67cc 100644
--- a/arch/x86/include/uapi/asm/sgx.h
+++ b/arch/x86/include/uapi/asm/sgx.h
@@ -81,4 +81,22 @@ struct sgx_enclave_exception {
 	__u64 reserved[2];
 };
 
+/**
+ * typedef sgx_enclave_exit_handler_t - Exit handler function accepted by
+ *					__vdso_sgx_enter_enclave()
+ *
+ * @rdi:	RDI at the time of enclave exit
+ * @rsi:	RSI at the time of enclave exit
+ * @rdx:	RDX at the time of enclave exit
+ * @ret:	0 on success (EEXIT), -EFAULT on an exception
+ * @r8:		R8 at the time of enclave exit
+ * @r9:		R9 at the time of enclave exit
+ * @tcs:	Thread Control Structure used to enter enclave
+ * @ursp:	RSP at the time of enclave exit
+ * @e:		Pointer to struct sgx_enclave_exception (as provided by caller)
+ */
+typedef int (*sgx_enclave_exit_handler_t)(long rdi, long rsi, long rdx, int ret,
+					  long r8, long r9, void *tcs, long ursp,
+					  struct sgx_enclave_exception *e);
+
 #endif /* _UAPI_ASM_X86_SGX_H */
-- 
2.22.0

