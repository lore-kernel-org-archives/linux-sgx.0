Return-Path: <SRS0=MdAf=YB=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31193ECE58E
	for <linux-sgx@archiver.kernel.org>; Tue,  8 Oct 2019 04:46:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 073B52084D
	for <linux-sgx@archiver.kernel.org>; Tue,  8 Oct 2019 04:46:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729440AbfJHEqP (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 8 Oct 2019 00:46:15 -0400
Received: from mga11.intel.com ([192.55.52.93]:8175 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729375AbfJHEqP (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 8 Oct 2019 00:46:15 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Oct 2019 21:46:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,269,1566889200"; 
   d="scan'208";a="206566490"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga001.fm.intel.com with ESMTP; 07 Oct 2019 21:46:15 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v23 01/16] x86/vdso: sgx: Drop the pseudocode "documentation"
Date:   Mon,  7 Oct 2019 21:45:58 -0700
Message-Id: <20191008044613.12350-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191008044613.12350-1-sean.j.christopherson@intel.com>
References: <20191008044613.12350-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Remove the pseudocode documentation of __vdso_sgx_enter_enclave().  The
assembly itself needs to be cleaned up to be easily understood without
pseudocode, and the extra documentation adds maintenance overhead.

Only the prototype is needed to coerce kernel-doc into parsing the
function comment, so that isn't lost either.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/entry/vdso/vsgx_enter_enclave.S | 25 +-----------------------
 1 file changed, 1 insertion(+), 24 deletions(-)

diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.S b/arch/x86/entry/vdso/vsgx_enter_enclave.S
index 9331279b8fa6..96726000aa27 100644
--- a/arch/x86/entry/vdso/vsgx_enter_enclave.S
+++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
@@ -58,30 +58,7 @@ typedef int (*sgx_callback)(long rdi, long rsi, long rdx,
 			    long r9, void *tcs, long ursp);
 int __vdso_sgx_enter_enclave(int leaf, void *tcs,
 			     struct sgx_enclave_exinfo *exinfo,
-			     sgx_callback callback)
-{
-	while (leaf == EENTER || leaf == ERESUME) {
-		int rc;
-		try {
-			ENCLU[leaf];
-			rc = 0;
-			if (exinfo)
-				exinfo->leaf = EEXIT;
-		} catch (exception) {
-			rc = -EFAULT;
-			if (exinfo)
-				*exinfo = exception;
-		}
-
-		leaf = callback ? (*callback)(
-			rdi, rsi, rdx, exinfo, r8, r9, tcs, ursp) : rc;
-	}
-
-	if (leaf > 0)
-		return -EINVAL;
-
-	return leaf;
-}
+			     sgx_callback callback);
 #endif
 ENTRY(__vdso_sgx_enter_enclave)
 	/* Prolog */
-- 
2.22.0

