Return-Path: <SRS0=pDj2=5P=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1748C2D0F0
	for <linux-sgx@archiver.kernel.org>; Mon, 30 Mar 2020 18:08:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9CE0120771
	for <linux-sgx@archiver.kernel.org>; Mon, 30 Mar 2020 18:08:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726981AbgC3SIP (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 30 Mar 2020 14:08:15 -0400
Received: from mga03.intel.com ([134.134.136.65]:35628 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728096AbgC3SIP (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 30 Mar 2020 14:08:15 -0400
IronPort-SDR: RGd0MOo4saERgzOuqBRrG7JF6Z3quVVnD+zCR7VG82k+wP0xoOapEUHajJg+zJCwezDETX/E2j
 SxU1bxiguSAQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Mar 2020 11:08:14 -0700
IronPort-SDR: uKugzQLYYDl7csewef7R08qot+YSHwdGBRnfmBWrRqOx2vrJCgyqQoztj0l65FJOmemAfp/CFm
 Xu/c1wLeGkWw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,325,1580803200"; 
   d="scan'208";a="283721716"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by fmsmga002.fm.intel.com with ESMTP; 30 Mar 2020 11:08:14 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Nathaniel McCallum <npmccallum@redhat.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-sgx@vger.kernel.org
Subject: [PATCH for_v29 v2 4/5] selftests/sgx: Stop clobbering non-volatile registers
Date:   Mon, 30 Mar 2020 11:08:10 -0700
Message-Id: <20200330180811.31381-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200330180811.31381-1-sean.j.christopherson@intel.com>
References: <20200330180811.31381-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Stop clearing non-volatile registers in the enclave's trampoline code,
there are no secrets to preserve, and not clobbering the registers makes
the enclave compatible with calling the vDSO from C.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 tools/testing/selftests/sgx/test_encl_bootstrap.S | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/tools/testing/selftests/sgx/test_encl_bootstrap.S b/tools/testing/selftests/sgx/test_encl_bootstrap.S
index 6a5d734cbf16..6836ea86126e 100644
--- a/tools/testing/selftests/sgx/test_encl_bootstrap.S
+++ b/tools/testing/selftests/sgx/test_encl_bootstrap.S
@@ -54,7 +54,7 @@ encl_entry:
 
 	pop	%rbx # pop the enclave base address
 
-	# Clear GPRs.
+	/* Clear volatile GPRs, except RAX (EEXIT leaf). */
 	xor     %rcx, %rcx
 	xor     %rdx, %rdx
 	xor     %rdi, %rdi
@@ -63,10 +63,6 @@ encl_entry:
 	xor     %r9, %r9
 	xor     %r10, %r10
 	xor     %r11, %r11
-	xor     %r12, %r12
-	xor     %r13, %r13
-	xor     %r14, %r14
-	xor     %r15, %r15
 
 	# Reset status flags.
 	add     %rdx, %rdx # OF = SF = AF = CF = 0; ZF = PF = 1
-- 
2.24.1

