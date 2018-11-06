Return-Path: <SRS0=XAjE=NR=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6278C32789
	for <linux-sgx@archiver.kernel.org>; Tue,  6 Nov 2018 13:51:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B91D02083D
	for <linux-sgx@archiver.kernel.org>; Tue,  6 Nov 2018 13:51:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B91D02083D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388672AbeKFXRD (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 6 Nov 2018 18:17:03 -0500
Received: from mga14.intel.com ([192.55.52.115]:2584 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388065AbeKFXRD (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 6 Nov 2018 18:17:03 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Nov 2018 05:51:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.54,472,1534834800"; 
   d="scan'208";a="271779486"
Received: from fhoeg-mobl.ger.corp.intel.com (HELO localhost) ([10.249.254.66])
  by orsmga005.jf.intel.com with ESMTP; 06 Nov 2018 05:51:35 -0800
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     x86@kernel.org, platform-driver-x86@vger.kernel.org,
        linux-sgx@vger.kernel.org
Cc:     dave.hansen@intel.com, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, Haim Cohen <haim.cohen@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Matt Turner <mattst88@gmail.com>,
        Janakarajan Natarajan <Janakarajan.Natarajan@amd.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT))
Subject: [PATCH v16 13/22] x86/msr: Add SGX Launch Control MSR definitions
Date:   Tue,  6 Nov 2018 15:45:52 +0200
Message-Id: <20181106134758.10572-14-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181106134758.10572-1-jarkko.sakkinen@linux.intel.com>
References: <20181106134758.10572-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org
Message-ID: <20181106134552.s5vO9glBrCOzmQRxHK7qo6GsmdjcrksrcUGgFwnPFTg@z>

From: Sean Christopherson <sean.j.christopherson@intel.com>

Add a new IA32_FEATURE_CONTROL bit, SGX_LE_WR.  When set, SGX_LE_WR
allows software to write the SGXLEPUBKEYHASH MSRs (see below).  The
The existence of the bit is enumerated by CPUID as X86_FEATURE_SGX_LC.
Like all other flags in IA32_FEATURE_CONTROL, the MSR must be locked
for SGX_LE_WR to take effect.

Add four MSRs, SGXLEPUBKEYHASH{0,1,2,3}, or in human readable form,
the SGX Launch Enclave Public Key Hash MSRs.  These MSRs correspond to
the key that is used by the CPU to determine whether or not to allow
software to enter an enclave.  When ENCLS[EINIT] is executed, which is
a prerequisite to entering the enclave, the CPU compares the key
(technically its hash) used to sign the enclave with the key hash
stored in the MSRs, and will reject EINIT if the keys do not match.

Enclaves can also be blessed by proxy, in which case a Launch Enclave
generates and signs an EINIT TOKEN.  If a valid token is provided,
ENCLS[EINIT] compares the signer of the token against the MSRs instead
of the signer of the enclave.  The SGXLEPUBKEYHASH MSRs only exist on
CPUs that support SGX Launch Control, enumerated by X86_FEATURE_SGX_LC.
CPUs without Launch Control use a hardcoded key for the ENCLS[EINIT]
checks.  An internal hardcoded key is also used as the reset value for
the hash MSRs when they exist.

As a final note, the SGX_LEPUBKEYHASH MSRs can also be written by
pre-boot firmware prior to activating SGX (SGX activation is done by
setting bit 0 in MSR 0x7A).  Thus, firmware can lock the MSRs to a
non-Intel value by writing the MSRs and locking IA32_FEATURE_CONTROL
without setting SGX_LE_WR.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Co-developed-by: Haim Cohen <haim.cohen@intel.com>
Signed-off-by: Haim Cohen <haim.cohen@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/include/asm/msr-index.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 2837f65ac817..ffae9df1c0ab 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -486,6 +486,7 @@
 #define FEATURE_CONTROL_LOCKED				(1<<0)
 #define FEATURE_CONTROL_VMXON_ENABLED_INSIDE_SMX	(1<<1)
 #define FEATURE_CONTROL_VMXON_ENABLED_OUTSIDE_SMX	(1<<2)
+#define FEATURE_CONTROL_SGX_LE_WR			(1<<17)
 #define FEATURE_CONTROL_SGX_ENABLE			(1<<18)
 #define FEATURE_CONTROL_LMCE				(1<<20)
 
@@ -499,6 +500,12 @@
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
2.19.1

