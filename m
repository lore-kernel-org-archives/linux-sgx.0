Return-Path: <SRS0=VHel=4U=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 852A1C3F2D7
	for <linux-sgx@archiver.kernel.org>; Tue,  3 Mar 2020 20:54:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57DD2208C3
	for <linux-sgx@archiver.kernel.org>; Tue,  3 Mar 2020 20:54:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731995AbgCCUyM (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 3 Mar 2020 15:54:12 -0500
Received: from mga05.intel.com ([192.55.52.43]:5252 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731479AbgCCUyM (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 3 Mar 2020 15:54:12 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Mar 2020 12:54:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,511,1574150400"; 
   d="scan'208";a="274376063"
Received: from fkuchars-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.4.236])
  by fmsmga002.fm.intel.com with ESMTP; 03 Mar 2020 12:54:10 -0800
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 2/2] x86/sgx: Remove non-LC bit from sgx_einit()
Date:   Tue,  3 Mar 2020 22:53:59 +0200
Message-Id: <20200303205359.108336-2-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200303205359.108336-1-jarkko.sakkinen@linux.intel.com>
References: <20200303205359.108336-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Remove the non-LC flow. While doing this, start using __encls_ret_3()
instead __einit() to reduce the insane amount of wrapping we have in
this flow.

Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/kernel/cpu/sgx/encls.h |  5 -----
 arch/x86/kernel/cpu/sgx/ioctl.c | 12 +++++++-----
 2 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encls.h b/arch/x86/kernel/cpu/sgx/encls.h
index b4c27d8bd2ac..fb201e384bc7 100644
--- a/arch/x86/kernel/cpu/sgx/encls.h
+++ b/arch/x86/kernel/cpu/sgx/encls.h
@@ -186,11 +186,6 @@ static inline int __eadd(struct sgx_pageinfo *pginfo, void *addr)
 	return __encls_2(EADD, pginfo, addr);
 }
 
-static inline int __einit(void *sigstruct, void *token, void *secs)
-{
-	return __encls_ret_3(EINIT, sigstruct, secs, token);
-}
-
 static inline int __eremove(void *addr)
 {
 	return __encls_ret_1(EREMOVE, addr);
diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index eaae533578b9..6e9e6a7380b1 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -600,17 +600,19 @@ static int sgx_einit(struct sgx_sigstruct *sigstruct, void *token,
 {
 	int ret;
 
-	if (!boot_cpu_has(X86_FEATURE_SGX_LC))
-		return __einit(sigstruct, token, sgx_epc_addr(secs));
-
 	preempt_disable();
+
 	sgx_update_lepubkeyhash_msrs(lepubkeyhash, false);
-	ret = __einit(sigstruct, token, sgx_epc_addr(secs));
+	ret = __encls_ret_3(EINIT, sigstruct, sgx_epc_addr(secs), token);
+
 	if (ret == SGX_INVALID_EINITTOKEN) {
 		sgx_update_lepubkeyhash_msrs(lepubkeyhash, true);
-		ret = __einit(sigstruct, token, sgx_epc_addr(secs));
+		ret = __encls_ret_3(EINIT, sigstruct, sgx_epc_addr(secs),
+				    token);
 	}
+
 	preempt_enable();
+
 	return ret;
 }
 
-- 
2.25.0

