Return-Path: <SRS0=NgZr=W6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31EA6C3A5A2
	for <linux-sgx@archiver.kernel.org>; Tue,  3 Sep 2019 14:27:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0804C23697
	for <linux-sgx@archiver.kernel.org>; Tue,  3 Sep 2019 14:27:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728860AbfICO1Y (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 3 Sep 2019 10:27:24 -0400
Received: from mga03.intel.com ([134.134.136.65]:32910 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728571AbfICO1Y (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 3 Sep 2019 10:27:24 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Sep 2019 07:27:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,463,1559545200"; 
   d="scan'208";a="183567242"
Received: from vkuppusa-mobl2.ger.corp.intel.com (HELO localhost) ([10.252.39.67])
  by fmsmga007.fm.intel.com with ESMTP; 03 Sep 2019 07:27:16 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     akpm@linux-foundation.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, Kai Huang <kai.huang@linux.intel.com>,
        Haim Cohen <haim.cohen@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v22 02/24] x86/cpufeatures: x86/msr: Intel SGX Launch Control hardware bits
Date:   Tue,  3 Sep 2019 17:26:33 +0300
Message-Id: <20190903142655.21943-3-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903142655.21943-1-jarkko.sakkinen@linux.intel.com>
References: <20190903142655.21943-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

From: Kai Huang <kai.huang@linux.intel.com>

Add X86_FEATURE_SGX_LC, which informs whether or not the CPU supports SGX
Launch Control.

Add MSR_IA32_SGXLEPUBKEYHASH{0, 1, 2, 3}, which when combined contain a
SHA256 hash of a 3072-bit RSA public key. SGX backed software packages, so
called enclaves, are always signed. All enclaves signed with the public key
are unconditionally allowed to initialize. [1]

Add FEATURE_CONTROL_SGX_LE_WR bit of the feature control MSR, which informs
whether the formentioned MSRs are writable or not. If the bit is off, the
public key MSRs are read-only for the OS.

If the MSRs are read-only, the platform must provide a launch enclave (LE).
LE can create cryptographic tokens for other enclaves that they can pass
together with their signature to the ENCLS(EINIT) opcode, which is used
to initialize enclaves.

Linux is unlikely to support the locked configuration because it takes away
the control of the launch decisions from the kernel.

[1] Intel SDM: 38.1.4 Intel SGX Launch Control Configuration

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Co-developed-by: Haim Cohen <haim.cohen@intel.com>
Signed-off-by: Haim Cohen <haim.cohen@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/include/asm/msr-index.h   | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index c5582e766121..ca82226e25ec 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -355,6 +355,7 @@
 #define X86_FEATURE_CLDEMOTE		(16*32+25) /* CLDEMOTE instruction */
 #define X86_FEATURE_MOVDIRI		(16*32+27) /* MOVDIRI instruction */
 #define X86_FEATURE_MOVDIR64B		(16*32+28) /* MOVDIR64B instruction */
+#define X86_FEATURE_SGX_LC		(16*32+30) /* Software Guard Extensions Launch Control */
 
 /* AMD-defined CPU features, CPUID level 0x80000007 (EBX), word 17 */
 #define X86_FEATURE_OVERFLOW_RECOV	(17*32+ 0) /* MCA overflow recovery support */
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index c006ba8187aa..24da5800b1c6 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -542,6 +542,7 @@
 #define FEATURE_CONTROL_LOCKED				(1<<0)
 #define FEATURE_CONTROL_VMXON_ENABLED_INSIDE_SMX	(1<<1)
 #define FEATURE_CONTROL_VMXON_ENABLED_OUTSIDE_SMX	(1<<2)
+#define FEATURE_CONTROL_SGX_LE_WR			(1<<17)
 #define FEATURE_CONTROL_SGX_ENABLE			(1<<18)
 #define FEATURE_CONTROL_LMCE				(1<<20)
 
@@ -555,6 +556,12 @@
 #define MSR_IA32_UCODE_WRITE		0x00000079
 #define MSR_IA32_UCODE_REV		0x0000008b
 
+/* Intel SGX Launch Enclave Public Key Hash MSRs */
+#define MSR_IA32_SGXLEPUBKEYHASH0	0x0000008C
+#define MSR_IA32_SGXLEPUBKEYHASH1	0x0000008D
+#define MSR_IA32_SGXLEPUBKEYHASH2	0x0000008E
+#define MSR_IA32_SGXLEPUBKEYHASH3	0x0000008F
+
 #define MSR_IA32_SMM_MONITOR_CTL	0x0000009b
 #define MSR_IA32_SMBASE			0x0000009e
 
-- 
2.20.1

