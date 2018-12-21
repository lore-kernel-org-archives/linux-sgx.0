Return-Path: <SRS0=Vmdy=O6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CFDFC43387
	for <linux-sgx@archiver.kernel.org>; Fri, 21 Dec 2018 23:12:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 029E421927
	for <linux-sgx@archiver.kernel.org>; Fri, 21 Dec 2018 23:12:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387417AbeLUXMM (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 21 Dec 2018 18:12:12 -0500
Received: from mga18.intel.com ([134.134.136.126]:25740 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731990AbeLUXMM (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 21 Dec 2018 18:12:12 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Dec 2018 15:12:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,383,1539673200"; 
   d="scan'208";a="120338156"
Received: from ncanderx-mobl.ger.corp.intel.com (HELO localhost) ([10.249.254.238])
  by FMSMGA003.fm.intel.com with ESMTP; 21 Dec 2018 15:12:04 -0800
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     x86@kernel.org, linux-sgx@vger.kernel.org
Cc:     akpm@linux-foundation.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, Kai Huang <kai.huang@linux.intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v18 01/25] x86/cpufeatures: Add Intel-defined SGX feature bit
Date:   Sat, 22 Dec 2018 01:11:30 +0200
Message-Id: <20181221231154.6120-2-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181221231154.6120-1-jarkko.sakkinen@linux.intel.com>
References: <20181221231154.6120-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

From: Kai Huang <kai.huang@linux.intel.com>

X86_FEATURE_SGX reflects whether or not the CPU supports Intel's
Software Guard eXtensions (SGX).

Signed-off-by: Kai Huang <kai.huang@linux.intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Reviewed-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/include/asm/cpufeatures.h       | 1 +
 arch/x86/include/asm/disabled-features.h | 8 +++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 28c4a502b419..da7fed4939a3 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -236,6 +236,7 @@
 /* Intel-defined CPU features, CPUID level 0x00000007:0 (EBX), word 9 */
 #define X86_FEATURE_FSGSBASE		( 9*32+ 0) /* RDFSBASE, WRFSBASE, RDGSBASE, WRGSBASE instructions*/
 #define X86_FEATURE_TSC_ADJUST		( 9*32+ 1) /* TSC adjustment MSR 0x3B */
+#define X86_FEATURE_SGX			( 9*32+ 2) /* Software Guard Extensions */
 #define X86_FEATURE_BMI1		( 9*32+ 3) /* 1st group bit manipulation extensions */
 #define X86_FEATURE_HLE			( 9*32+ 4) /* Hardware Lock Elision */
 #define X86_FEATURE_AVX2		( 9*32+ 5) /* AVX2 instructions */
diff --git a/arch/x86/include/asm/disabled-features.h b/arch/x86/include/asm/disabled-features.h
index 33833d1909af..1e6da9b8c6f6 100644
--- a/arch/x86/include/asm/disabled-features.h
+++ b/arch/x86/include/asm/disabled-features.h
@@ -56,6 +56,12 @@
 # define DISABLE_PTI		(1 << (X86_FEATURE_PTI & 31))
 #endif
 
+#ifdef CONFIG_SGX_CORE
+# define DISABLE_SGX_CORE	0
+#else
+# define DISABLE_SGX_CORE	(1 << (X86_FEATURE_SGX & 31))
+#endif
+
 /*
  * Make sure to add features to the correct mask
  */
@@ -68,7 +74,7 @@
 #define DISABLED_MASK6	0
 #define DISABLED_MASK7	(DISABLE_PTI)
 #define DISABLED_MASK8	0
-#define DISABLED_MASK9	(DISABLE_MPX)
+#define DISABLED_MASK9	(DISABLE_MPX|DISABLE_SGX_CORE)
 #define DISABLED_MASK10	0
 #define DISABLED_MASK11	0
 #define DISABLED_MASK12	0
-- 
2.19.1

