Return-Path: <SRS0=BaFh=XH=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DB25C4CEC6
	for <linux-sgx@archiver.kernel.org>; Thu, 12 Sep 2019 19:39:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6AF022084D
	for <linux-sgx@archiver.kernel.org>; Thu, 12 Sep 2019 19:39:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726070AbfILTjA (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 12 Sep 2019 15:39:00 -0400
Received: from mga18.intel.com ([134.134.136.126]:21696 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726067AbfILTi7 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 12 Sep 2019 15:38:59 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Sep 2019 12:38:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,492,1559545200"; 
   d="scan'208";a="269187850"
Received: from dscaswel-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.53.44])
  by orsmga001.jf.intel.com with ESMTP; 12 Sep 2019 12:38:40 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH 1/2] x86/sgx: Wrap ENCLS[EWB]
Date:   Thu, 12 Sep 2019 20:38:08 +0100
Message-Id: <20190912193809.29336-1-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

A reclaimed page is represented by two entities:

1. A version number in the Enclave Page Cache (EPC). Version numbers are
   stored in Version Array (VA) pages [1].
2. Page contents and MAC [2] encrypted with a random transient key and the
   version number in the system memory.

This commit introduces a wrapper function for ENCLS[EWB], which transforms
a page from EPC to the system memory, resulting the forementioned entities.
The reason for having struct sgx_ewb_context is that the reclaiming process
can pin the resources in early phases of the page reclaiming process when a
clean rollback from a failure (e.g. running out of memory) is still
possible.

[1] Intel SDM: 37.18 VERSION ARRAY (VA)
[2] Intel SDM: 37.12 PAGING CRYPTO METADATA (PCMD)

Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/kernel/cpu/sgx/encls.c | 33 +++++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/sgx/encls.h | 10 ++++++++++
 2 files changed, 43 insertions(+)

diff --git a/arch/x86/kernel/cpu/sgx/encls.c b/arch/x86/kernel/cpu/sgx/encls.c
index cda09cf8b927..06004b665d88 100644
--- a/arch/x86/kernel/cpu/sgx/encls.c
+++ b/arch/x86/kernel/cpu/sgx/encls.c
@@ -54,3 +54,36 @@ int sgx_einit(struct sgx_sigstruct *sigstruct, struct sgx_einittoken *token,
 	preempt_enable();
 	return ret;
 }
+
+/**
+ * sgx_ewb() - Execute ENCLS[EWB]
+ * @ctx:		a struct &sgx_ewb_context
+ *
+ * Execute ENCLS[EWB], which transforms a page from EPC to the system memory.
+ * @ctx should be initialized to reference all of the data needed in this
+ * process.
+ *
+ * Return:
+ *   0 on success,
+ *   -errno or SGX error on failure
+ */
+int sgx_ewb(struct sgx_ewb_context *ctx)
+{
+	struct sgx_pageinfo pginfo;
+	int ret;
+
+	pginfo.addr = 0;
+	pginfo.contents = (unsigned long)kmap_atomic(ctx->contents);
+	pginfo.metadata = (unsigned long)kmap_atomic(ctx->pcmd) +
+						     ctx->pcmd_offset;
+	pginfo.secs = 0;
+
+	ret = __ewb(&pginfo, sgx_epc_addr(ctx->page),
+		    sgx_epc_addr(ctx->version_array) + ctx->version_offset);
+
+	kunmap_atomic((void *)(unsigned long)(pginfo.metadata -
+					      ctx->pcmd_offset));
+	kunmap_atomic((void *)(unsigned long)pginfo.contents);
+
+	return ret;
+}
diff --git a/arch/x86/kernel/cpu/sgx/encls.h b/arch/x86/kernel/cpu/sgx/encls.h
index e3713337c187..d27cbc2f76e0 100644
--- a/arch/x86/kernel/cpu/sgx/encls.h
+++ b/arch/x86/kernel/cpu/sgx/encls.h
@@ -257,7 +257,17 @@ static inline int __emodt(struct sgx_secinfo *secinfo, void *addr)
 	return __encls_ret_2(SGX_EMODT, secinfo, addr);
 }
 
+struct sgx_ewb_context {
+	struct sgx_epc_page *page;
+	struct page *contents;
+	struct page *pcmd;
+	unsigned long pcmd_offset;
+	struct sgx_epc_page *version_array;
+	unsigned long version_offset;
+};
+
 int sgx_einit(struct sgx_sigstruct *sigstruct, struct sgx_einittoken *token,
 	      struct sgx_epc_page *secs, u64 *lepubkeyhash);
+int sgx_ewb(struct sgx_ewb_context *ctx);
 
 #endif /* _X86_ENCLS_H */
-- 
2.20.1

