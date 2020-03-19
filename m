Return-Path: <SRS0=xedp=5E=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5077BC4332D
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Mar 2020 01:11:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25E4C20768
	for <linux-sgx@archiver.kernel.org>; Thu, 19 Mar 2020 01:11:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbgCSBLg (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 18 Mar 2020 21:11:36 -0400
Received: from mga18.intel.com ([134.134.136.126]:30443 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726623AbgCSBLg (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 18 Mar 2020 21:11:36 -0400
IronPort-SDR: rtmpQDcwoAeDWnTqqUFrLYPEYlCOXMD+5miOg5nP5M9lxNpiWu+dJjl8D7kHs68YD6gdxtUIfS
 zBCVQUa1F7qg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Mar 2020 18:11:35 -0700
IronPort-SDR: piS94afKj2luCC2wuRzCM2qMGMqSd8yIJK3fbaAFtRidC6vdyPj4LFaggSc7mab+XafDUUaFSP
 DfMiHIgf5kgA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,569,1574150400"; 
   d="scan'208";a="324358695"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.202])
  by orsmga001.jf.intel.com with ESMTP; 18 Mar 2020 18:11:35 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Nathaniel McCallum <npmccallum@redhat.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-sgx@vger.kernel.org
Subject: [PATCH for_v29 2/8] x86/sgx: vdso: Make the %rsp fixup on return from handler relative
Date:   Wed, 18 Mar 2020 18:11:24 -0700
Message-Id: <20200319011130.8556-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200319011130.8556-1-sean.j.christopherson@intel.com>
References: <20200319011130.8556-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Modify the %rsp fixup after returning from the exit handler to be
relative instead of absolute to avoid clobbering any %rsp adjustments
made by the exit handler, e.g. if the exit handler modifies the stack
prior to re-entering the enclave.

Reported-by: Nathaniel McCallum <npmccallum@redhat.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---

I'm on the fence as to whether or not this is a good idea.  It's not super
painful, but it's not exactly standard/obvious code.  Part of me thinks
its a bug to not let the exit handler manipulate %rsp, the other part of
me thinks it's straight up crazy :-)

 arch/x86/entry/vdso/vsgx_enter_enclave.S | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.S b/arch/x86/entry/vdso/vsgx_enter_enclave.S
index 22a22e0774d8..14f07d5e47ae 100644
--- a/arch/x86/entry/vdso/vsgx_enter_enclave.S
+++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
@@ -137,8 +137,9 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
 	/* Pass the untrusted RSP (at exit) to the callback via %rcx. */
 	mov	%rsp, %rcx
 
-	/* Save the untrusted RSP in %rbx (non-volatile register). */
+	/* Save the untrusted RSP offset in %rbx (non-volatile register). */
 	mov	%rsp, %rbx
+	and	$0xf, %rbx
 
 	/*
 	 * Align stack per x86_64 ABI. Note, %rsp needs to be 16-byte aligned
@@ -159,8 +160,8 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
 	mov	0x20(%rbp), %rax
 	call	.Lretpoline
 
-	/* Restore %rsp to its post-exit value. */
-	mov	%rbx, %rsp
+	/* Undo the post-exit %rsp adjustment. */
+	lea	0x20(%rsp,%rbx), %rsp
 
 	/*
 	 * If the return from callback is zero or negative, return immediately,
-- 
2.24.1

