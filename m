Return-Path: <SRS0=APC0=CZ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0034AC433E2
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Sep 2020 00:51:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF05220738
	for <linux-sgx@archiver.kernel.org>; Wed, 16 Sep 2020 00:50:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=kapsi.fi header.i=@kapsi.fi header.b="rwNMM2yG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbgIPAu7 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 15 Sep 2020 20:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726377AbgIOLkq (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 15 Sep 2020 07:40:46 -0400
Received: from mail.kapsi.fi (mail.kapsi.fi [IPv6:2001:67c:1be8::25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF50EC061797;
        Tue, 15 Sep 2020 04:40:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=kapsi.fi;
         s=20161220; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Dw0RXYIryfkngJ4OEuc3gpztJP0jIMz1MlJhMluSPdE=; b=rwNMM2yGWf96Z9H5K7tFNa/44J
        KMSbuF0mGreAxCwOa3YbNFCd44cR/fEJWPTwqOSejcvVXvUaWXYlHTQgn8oONbv83vlFVWrYQ0bqq
        UZjss7pPl9qcRrTDXxG3+90tJimd5tbEA00XtnE3GM7hkVCrMTXzU4iS4JK6jchRHfosjkNYt5xR4
        IRPoTIFfhuvSs9KaZ0Trag2JIu586Enm+b5H1U/M7vJLHLjikRyhSPlwoobmOIh1YjiCO/Vhnljgb
        kn4SjPl3C1fegpMyTLjOTyEhFwNY39SZMjqSOY18W/kbxh3wJiifDjFnhpSgcCmPLyg/QL8MDXAXk
        timqRhoA==;
Received: from 83-245-197-237.elisa-laajakaista.fi ([83.245.197.237] helo=localhost)
        by mail.kapsi.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <jarkko.sakkinen@linux.intel.com>)
        id 1kI8m8-0005sg-7I; Tue, 15 Sep 2020 14:05:28 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     x86@kernel.org, linux-sgx@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Jethro Beekman <jethro@fortanix.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: [PATCH v38 02/24] x86/cpufeatures: x86/msr: Add Intel SGX Launch Control hardware bits
Date:   Tue, 15 Sep 2020 14:05:00 +0300
Message-Id: <20200915110522.893152-3-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200915110522.893152-1-jarkko.sakkinen@linux.intel.com>
References: <20200915110522.893152-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 83.245.197.237
X-SA-Exim-Mail-From: jarkko.sakkinen@linux.intel.com
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Add X86_FEATURE_SGX_LC, which informs whether or not the CPU supports SGX
Launch Control.

Add MSR_IA32_SGXLEPUBKEYHASH{0, 1, 2, 3}, which when combined contain a
SHA256 hash of a 3072-bit RSA public key. SGX backed software packages, so
called enclaves, are always signed. All enclaves signed with the public key
are unconditionally allowed to initialize. [1]

Add FEAT_CTL_SGX_LC_ENABLED, which informs whether the aformentioned MSRs
are writable or not. If the bit is off, the public key MSRs are read-only
for the OS.

If the MSRs are read-only, the platform must provide a launch enclave (LE).
LE can create cryptographic tokens for other enclaves that they can pass
together with their signature to the ENCLS(EINIT) opcode, which is used
to initialize enclaves.

Linux is unlikely to support the locked configuration because it takes away
the control of the launch decisions from the kernel.

[1] Intel SDM: 38.1.4 Intel SGX Launch Control Configuration

Reviewed-by: Borislav Petkov <bp@alien8.de>
Acked-by: Jethro Beekman <jethro@fortanix.com>
Reviewed-by: Darren Kenny <darren.kenny@oracle.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Co-developed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/include/asm/msr-index.h   | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 159b635159c0..398e4f19c3d7 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -354,6 +354,7 @@
 #define X86_FEATURE_CLDEMOTE		(16*32+25) /* CLDEMOTE instruction */
 #define X86_FEATURE_MOVDIRI		(16*32+27) /* MOVDIRI instruction */
 #define X86_FEATURE_MOVDIR64B		(16*32+28) /* MOVDIR64B instruction */
+#define X86_FEATURE_SGX_LC		(16*32+30) /* Software Guard Extensions Launch Control */
 
 /* AMD-defined CPU features, CPUID level 0x80000007 (EBX), word 17 */
 #define X86_FEATURE_OVERFLOW_RECOV	(17*32+ 0) /* MCA overflow recovery support */
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index c0b04f020162..e574b4bb5aad 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -602,6 +602,7 @@
 #define FEAT_CTL_LOCKED				BIT(0)
 #define FEAT_CTL_VMX_ENABLED_INSIDE_SMX		BIT(1)
 #define FEAT_CTL_VMX_ENABLED_OUTSIDE_SMX	BIT(2)
+#define FEAT_CTL_SGX_LC_ENABLED			BIT(17)
 #define FEAT_CTL_SGX_ENABLED			BIT(18)
 #define FEAT_CTL_LMCE_ENABLED			BIT(20)
 
@@ -622,6 +623,12 @@
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
2.25.1

