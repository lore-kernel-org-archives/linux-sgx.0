Return-Path: <SRS0=pDj2=5P=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EA97C2D0EF
	for <linux-sgx@archiver.kernel.org>; Mon, 30 Mar 2020 18:08:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 72B4D20780
	for <linux-sgx@archiver.kernel.org>; Mon, 30 Mar 2020 18:08:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728336AbgC3SIP (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 30 Mar 2020 14:08:15 -0400
Received: from mga03.intel.com ([134.134.136.65]:35626 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726981AbgC3SIP (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 30 Mar 2020 14:08:15 -0400
IronPort-SDR: Ru5trJvgIhPBqnl+IESgvrp6JBpoo/kzcwBZaIhYzGM6aDpK0i3q8OGWrEo06xVT13cVxUlm/4
 n0mLDeYyXafQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2020 11:08:14 -0700
IronPort-SDR: QdWLjoO7hUaITVks4az2hQ33WEEiTn9tvyxFyTFOIvjLM8W3Cg3yCdSwWmeiYavpDZVjnyRQCg
 yPmFa5cb9V+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,325,1580803200"; 
   d="scan'208";a="283721711"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga002.fm.intel.com with ESMTP; 30 Mar 2020 11:08:14 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Nathaniel McCallum <npmccallum@redhat.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-sgx@vger.kernel.org
Subject: [PATCH for_v29 v2 3/5] selftests/sgx: Pass EENTER to vDSO wrapper instead of hardcoding
Date:   Mon, 30 Mar 2020 11:08:09 -0700
Message-Id: <20200330180811.31381-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200330180811.31381-1-sean.j.christopherson@intel.com>
References: <20200330180811.31381-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Pass EENTER to the vDSO wrapper via %ecx instead of hardcoding it to
make the wrapper compatible with the new vDSO calling convention.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 tools/testing/selftests/sgx/call.S    | 1 -
 tools/testing/selftests/sgx/defines.h | 1 +
 tools/testing/selftests/sgx/main.c    | 2 +-
 tools/testing/selftests/sgx/main.h    | 2 +-
 4 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/sgx/call.S b/tools/testing/selftests/sgx/call.S
index c37f55a607c8..77131e83db42 100644
--- a/tools/testing/selftests/sgx/call.S
+++ b/tools/testing/selftests/sgx/call.S
@@ -37,7 +37,6 @@ sgx_call_vdso:
 	.cfi_adjust_cfa_offset	8
 	push	0x48(%rsp)
 	.cfi_adjust_cfa_offset	8
-	mov	$2, %eax
 	call	*eenter(%rip)
 	add	$0x20, %rsp
 	.cfi_adjust_cfa_offset	-0x20
diff --git a/tools/testing/selftests/sgx/defines.h b/tools/testing/selftests/sgx/defines.h
index 1802cace7527..be8969922804 100644
--- a/tools/testing/selftests/sgx/defines.h
+++ b/tools/testing/selftests/sgx/defines.h
@@ -15,6 +15,7 @@
 #define __packed __attribute__((packed))
 
 #include "../../../../arch/x86/kernel/cpu/sgx/arch.h"
+#include "../../../../arch/x86/include/asm/enclu.h"
 #include "../../../../arch/x86/include/uapi/asm/sgx.h"
 
 #endif /* DEFINES_H */
diff --git a/tools/testing/selftests/sgx/main.c b/tools/testing/selftests/sgx/main.c
index 9238cce47f77..f6bb40f22884 100644
--- a/tools/testing/selftests/sgx/main.c
+++ b/tools/testing/selftests/sgx/main.c
@@ -171,7 +171,7 @@ int main(int argc, char *argv[], char *envp[])
 
 	eenter = addr + eenter_sym->st_value;
 
-	sgx_call_vdso((void *)&MAGIC, &result, 0, NULL, NULL, NULL,
+	sgx_call_vdso((void *)&MAGIC, &result, 0, EENTER, NULL, NULL,
 		      (void *)encl.encl_base, &exception, NULL);
 	if (result != MAGIC)
 		goto err;
diff --git a/tools/testing/selftests/sgx/main.h b/tools/testing/selftests/sgx/main.h
index 6e1ae292bd25..999422cc7343 100644
--- a/tools/testing/selftests/sgx/main.h
+++ b/tools/testing/selftests/sgx/main.h
@@ -32,7 +32,7 @@ bool encl_load(const char *path, struct encl *encl);
 bool encl_measure(struct encl *encl);
 bool encl_build(struct encl *encl);
 
-int sgx_call_vdso(void *rdi, void *rsi, long rdx, void *rcx, void *r8, void *r9,
+int sgx_call_vdso(void *rdi, void *rsi, long rdx, u32 leaf, void *r8, void *r9,
 		  void *tcs, struct sgx_enclave_exception *ei, void *cb);
 
 #endif /* MAIN_H */
-- 
2.24.1

