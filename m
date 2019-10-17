Return-Path: <SRS0=Q6PB=YK=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25F2AFA372B
	for <linux-sgx@archiver.kernel.org>; Thu, 17 Oct 2019 00:05:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0382020872
	for <linux-sgx@archiver.kernel.org>; Thu, 17 Oct 2019 00:05:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390285AbfJQAF4 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 16 Oct 2019 20:05:56 -0400
Received: from mga03.intel.com ([134.134.136.65]:28763 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727859AbfJQAF4 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 16 Oct 2019 20:05:56 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Oct 2019 17:05:55 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,305,1566889200"; 
   d="scan'208";a="370965124"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga005.jf.intel.com with ESMTP; 16 Oct 2019 17:05:55 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, Cedric Xing <cedric.xing@intel.com>
Subject: [PATCH for_v23 v2 1/3] x86/vdso: sgx: Save untrusted stack before aligning %rsp
Date:   Wed, 16 Oct 2019 17:05:52 -0700
Message-Id: <20191017000554.11927-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191017000554.11927-1-sean.j.christopherson@intel.com>
References: <20191017000554.11927-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

The untrusted stack is restored from %rbx after the userspace exit
handler, but that only works if %rsp is first saved into %rbx...

Reported-by: Cedric Xing <cedric.xing@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/entry/vdso/vsgx_enter_enclave.S | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.S b/arch/x86/entry/vdso/vsgx_enter_enclave.S
index 94f613b53b13..e56737cc9f2c 100644
--- a/arch/x86/entry/vdso/vsgx_enter_enclave.S
+++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
@@ -137,6 +137,9 @@ ENTRY(__vdso_sgx_enter_enclave)
 	/* Pass the untrusted RSP (at exit) to the callback via %rcx. */
 	mov	%rsp, %rcx
 
+	/* Save the untrusted RSP in %rbx (non-volatile register). */
+	mov	%rsp, %rbx
+
 	/*
 	 * Align stack per x86_64 ABI. Note, %rsp needs to be 16-byte aligned
 	 * _after_ pushing the three parameters on the stack.
-- 
2.22.0

