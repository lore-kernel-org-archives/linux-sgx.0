Return-Path: <SRS0=Bw5y=RU=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9196C43381
	for <linux-sgx@archiver.kernel.org>; Sun, 17 Mar 2019 21:16:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82D8F2082F
	for <linux-sgx@archiver.kernel.org>; Sun, 17 Mar 2019 21:16:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbfCQVQM (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 17 Mar 2019 17:16:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:9044 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726446AbfCQVQM (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 17 Mar 2019 17:16:12 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Mar 2019 14:16:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,491,1544515200"; 
   d="scan'208";a="142816704"
Received: from vanderss-mobl1.ger.corp.intel.com (HELO localhost) ([10.249.254.193])
  by orsmga002.jf.intel.com with ESMTP; 17 Mar 2019 14:16:02 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     x86@kernel.org, linux-sgx@vger.kernel.org
Cc:     akpm@linux-foundation.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v19 06/27] x86/mm: x86/sgx: Add new 'PF_SGX' page fault error code bit
Date:   Sun, 17 Mar 2019 23:14:35 +0200
Message-Id: <20190317211456.13927-7-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190317211456.13927-1-jarkko.sakkinen@linux.intel.com>
References: <20190317211456.13927-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

The SGX bit is set in the #PF error code if and only if the fault is
detected by the Enclave Page Cache Map (EPCM), a hardware-managed
table that enforces the paging permissions defined by the enclave,
e.g. to prevent the kernel from changing the permissions of an
enclave's page(s).

Despite triggering a #PF, a #PF with PF_SGX has nothing to do with
paging.

Cc: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/include/asm/traps.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index 7d6f3f3fad78..c3e02912e9c7 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -171,5 +171,6 @@ enum x86_pf_error_code {
 	X86_PF_RSVD	=		1 << 3,
 	X86_PF_INSTR	=		1 << 4,
 	X86_PF_PK	=		1 << 5,
+	X86_PF_SGX	=		1 << 15,
 };
 #endif /* _ASM_X86_TRAPS_H */
-- 
2.19.1

