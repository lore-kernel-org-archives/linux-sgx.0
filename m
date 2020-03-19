Return-Path: <SRS0=xedp=5E=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80135C55187
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Mar 2020 01:11:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5578020768
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Mar 2020 01:11:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbgCSBLi (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 18 Mar 2020 21:11:38 -0400
Received: from mga18.intel.com ([134.134.136.126]:30443 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726596AbgCSBLi (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 18 Mar 2020 21:11:38 -0400
IronPort-SDR: LGq0gtfA33QRUUD9U6iA6ldaxKq3n0DJHN62iJGeX+dY4M9tfXGoDXsSctLmu5PWc+9pbKM2/S
 hecqaNKtKohQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2020 18:11:35 -0700
IronPort-SDR: diW1A1DvCt7/yloVqOfJBVhaBO7tTzNw6ED+GyVaG/KvCdYTBw1uZI6XKuPyxY42keOa928Qky
 tGlpSPUiILAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,569,1574150400"; 
   d="scan'208";a="324358709"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga001.jf.intel.com with ESMTP; 18 Mar 2020 18:11:35 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Nathaniel McCallum <npmccallum@redhat.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-sgx@vger.kernel.org
Subject: [PATCH for_v29 7/8] selftests/x86: sgx: Stop clobbering non-volatile registers
Date:   Wed, 18 Mar 2020 18:11:29 -0700
Message-Id: <20200319011130.8556-8-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200319011130.8556-1-sean.j.christopherson@intel.com>
References: <20200319011130.8556-1-sean.j.christopherson@intel.com>
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
 tools/testing/selftests/x86/sgx/encl_bootstrap.S | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/tools/testing/selftests/x86/sgx/encl_bootstrap.S b/tools/testing/selftests/x86/sgx/encl_bootstrap.S
index 3a1479f1cdcf..173e76fa6da6 100644
--- a/tools/testing/selftests/x86/sgx/encl_bootstrap.S
+++ b/tools/testing/selftests/x86/sgx/encl_bootstrap.S
@@ -40,7 +40,7 @@ encl_entry:
 
 	pop	%rbx # pop the enclave base address
 
-	# Clear GPRs.
+	/* Clear volatile GPRs, except RAX (EEXIT leaf). */
 	xor     %rcx, %rcx
 	xor     %rdx, %rdx
 	xor     %rdi, %rdi
@@ -49,10 +49,6 @@ encl_entry:
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

