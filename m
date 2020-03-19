Return-Path: <SRS0=xedp=5E=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE759C43332
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Mar 2020 01:11:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C469020768
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Mar 2020 01:11:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbgCSBLh (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 18 Mar 2020 21:11:37 -0400
Received: from mga18.intel.com ([134.134.136.126]:30444 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726596AbgCSBLh (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 18 Mar 2020 21:11:37 -0400
IronPort-SDR: YfXOqAFN+d3qe+41pMaDPOrkioKsrOAyRd/pipfD6QOgsYHh2VCSaRWoVgZt4xYiwTUekEGFd9
 8hWtif4BdlTw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2020 18:11:35 -0700
IronPort-SDR: HtnpJ9CJljuLvjsYx9P/hz/8hPbQRh+qWd1vaArtvLcTMflNvEomWJSzrOfdf1HmBhwdAmdA3X
 0sruqjI62nwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,569,1574150400"; 
   d="scan'208";a="324358693"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga001.jf.intel.com with ESMTP; 18 Mar 2020 18:11:35 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Nathaniel McCallum <npmccallum@redhat.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-sgx@vger.kernel.org
Subject: [PATCH for_v29 1/8] x86/sgx: vdso: Remove an incorrect statement the enter enclave comment
Date:   Wed, 18 Mar 2020 18:11:23 -0700
Message-Id: <20200319011130.8556-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200319011130.8556-1-sean.j.christopherson@intel.com>
References: <20200319011130.8556-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Remove the statement about the userspace exit handler being required to
clean up the untrusted stack, the vDSO unconditionally restores %rsp to
its value at the time of EEXIT.

Reported-by: Nathaniel McCallum <npmccallum@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/entry/vdso/vsgx_enter_enclave.S | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.S b/arch/x86/entry/vdso/vsgx_enter_enclave.S
index 94a8e5f99961..22a22e0774d8 100644
--- a/arch/x86/entry/vdso/vsgx_enter_enclave.S
+++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
@@ -59,10 +59,8 @@
  *   0:		success, return @ret to the caller
  *  <0:		error, return @ret to the caller
  *
- * The userspace exit handler is responsible for unwinding the stack, e.g. to
- * pop @e, u_rsp and @tcs, prior to returning to __vdso_sgx_enter_enclave().
- * The exit handler may also transfer control, e.g. via longjmp() or a C++
- * exception, without returning to __vdso_sgx_enter_enclave().
+ * The exit handler may transfer control, e.g. via longjmp() or C++ exception,
+ * without returning to __vdso_sgx_enter_enclave().
  *
  * Return:
  *  0 on success,
-- 
2.24.1

