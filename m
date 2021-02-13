Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93E13C433E0
	for <linux-sgx@archiver.kernel.org>; Sat, 13 Feb 2021 13:32:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 658C364E46
	for <linux-sgx@archiver.kernel.org>; Sat, 13 Feb 2021 13:32:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbhBMNcL (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 13 Feb 2021 08:32:11 -0500
Received: from mga01.intel.com ([192.55.52.88]:30429 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229651AbhBMNb0 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 13 Feb 2021 08:31:26 -0500
IronPort-SDR: gDDDUwdu+7Yapze9VvLhdvFnP8XTgrjj0DiH8HrwJSF3NhIDWDBTRFutaxT+VWwF7o556sQEXR
 wDa0K5SQY0Bw==
X-IronPort-AV: E=McAfee;i="6000,8403,9893"; a="201682460"
X-IronPort-AV: E=Sophos;i="5.81,176,1610438400"; 
   d="scan'208";a="201682460"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2021 05:30:21 -0800
IronPort-SDR: 5ss3k4n3DXDx2r0C3KokRE2cnBGPzZ45gExiXaxCaczLQ7y+ou1RSKr31jYLfPBJExWAB7IKhu
 siUXK17pfLng==
X-IronPort-AV: E=Sophos;i="5.81,176,1610438400"; 
   d="scan'208";a="398366187"
Received: from kshah-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.255.230.239])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2021 05:30:17 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jmattson@google.com, joro@8bytes.org, vkuznets@redhat.com,
        wanpengli@tencent.com, Kai Huang <kai.huang@intel.com>
Subject: [RFC PATCH v5 19/26] KVM: x86: Add reverse-CPUID lookup support for scattered SGX features
Date:   Sun, 14 Feb 2021 02:29:47 +1300
Message-Id: <2c2863023a6439b9f1fb35248b16b0000c08da84.1613221549.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1613221549.git.kai.huang@intel.com>
References: <cover.1613221549.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

Define a new KVM-only feature word for advertising and querying SGX
sub-features in CPUID.0x12.0x0.EAX.  Because SGX1 and SGX2 are scattered
in the kernel's feature word, they need to be translated so that the
bit numbers match those of hardware.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/kvm/cpuid.h | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 2041e2f07347..f55701ef58fc 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -13,13 +13,18 @@
  * "bug" caps, but KVM doesn't use those.
  */
 enum kvm_only_cpuid_leafs {
-	NR_KVM_CPU_CAPS = NCAPINTS,
+	CPUID_12_EAX	 = NCAPINTS,
+	NR_KVM_CPU_CAPS,
 
 	NKVMCAPINTS = NR_KVM_CPU_CAPS - NCAPINTS,
 };
 
 #define X86_KVM_FEATURE(w, f)		((w)*32 + (f))
 
+/* Intel-defined SGX sub-features, CPUID level 0x12 (EAX). */
+#define __X86_FEATURE_SGX1		X86_KVM_FEATURE(CPUID_12_EAX, 0)
+#define __X86_FEATURE_SGX2		X86_KVM_FEATURE(CPUID_12_EAX, 1)
+
 extern u32 kvm_cpu_caps[NR_KVM_CPU_CAPS] __read_mostly;
 void kvm_set_cpu_caps(void);
 
@@ -76,6 +81,7 @@ static const struct cpuid_reg reverse_cpuid[] = {
 	[CPUID_8000_0007_EBX] = {0x80000007, 0, CPUID_EBX},
 	[CPUID_7_EDX]         = {         7, 0, CPUID_EDX},
 	[CPUID_7_1_EAX]       = {         7, 1, CPUID_EAX},
+	[CPUID_12_EAX]        = {0x00000012, 0, CPUID_EAX},
 };
 
 /*
@@ -102,6 +108,11 @@ static __always_inline void reverse_cpuid_check(unsigned int x86_leaf)
  */
 static __always_inline u32 __feature_translate(int x86_feature)
 {
+	if (x86_feature == X86_FEATURE_SGX1)
+		return __X86_FEATURE_SGX1;
+	else if (x86_feature == X86_FEATURE_SGX2)
+		return __X86_FEATURE_SGX2;
+
 	return x86_feature;
 }
 
-- 
2.29.2

