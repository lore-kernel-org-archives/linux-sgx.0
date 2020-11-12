Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8028BC2D0E4
	for <linux-sgx@archiver.kernel.org>; Thu, 12 Nov 2020 22:02:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21F0822244
	for <linux-sgx@archiver.kernel.org>; Thu, 12 Nov 2020 22:02:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="2Bn2s+nd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727214AbgKLWCT (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 12 Nov 2020 17:02:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:49134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727477AbgKLWCQ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 12 Nov 2020 17:02:16 -0500
Received: from suppilovahvero.lan (83-245-197-237.elisa-laajakaista.fi [83.245.197.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E68322241;
        Thu, 12 Nov 2020 22:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605218534;
        bh=xMf6gQfqp1WEaDxJnUVEXOOcScjOkA1O6cDPDW317Js=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Bn2s+nd3EK7plLYCglYdsR2OhjazthzGlY4llPlCGQCo+Uf9UxWlYv1D/o2R9J1E
         V5OPh2C1d7RbsnKaAUc4ZHfEDl+U0WF6Oaw8B+yYdFdPCIYATVB7mzHQmJ9JTSRv4V
         FOeIs3RgCAhiRxU+y3yipDWk5YkgnXv1Dj3rkSZk=
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     x86@kernel.org, linux-sgx@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Jarkko Sakkinen <jarkko@kernel.org>, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com, kai.huang@intel.com,
        kai.svahn@intel.com, kmoy@google.com, ludloff@google.com,
        luto@kernel.org, nhorman@redhat.com, npmccallum@redhat.com,
        puiterwijk@redhat.com, rientjes@google.com, tglx@linutronix.de,
        yaozhangx@google.com, mikko.ylinen@intel.com
Subject: [PATCH v41 04/24] x86/cpufeatures: x86/msr: Add Intel SGX Launch Control hardware bits
Date:   Fri, 13 Nov 2020 00:01:15 +0200
Message-Id: <20201112220135.165028-5-jarkko@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201112220135.165028-1-jarkko@kernel.org>
References: <20201112220135.165028-1-jarkko@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

The SGX Launch Control hardware helps restrict which enclaves the
hardware will run.  Launch control is intended to restrict what software
can run with enclave protections, which helps protect the overall system
from bad enclaves.

For the kernel's purposes, there are effectively two modes in which the
launch control hardware can operate: rigid and flexible. In its rigid
mode, an entity other than the kernel has ultimate authority over which
enclaves can be run (firmware, Intel, etc...). In its flexible mode, the
kernel has ultimate authority over which enclaves can run.

Enable X86_FEATURE_SGX_LC to enumerate when the CPU supports SGX Launch
Control in general.

Add MSR_IA32_SGXLEPUBKEYHASH{0, 1, 2, 3}, which when combined contain a
SHA256 hash of a 3072-bit RSA public key. The hardware allows SGX enclaves
signed with this public key to initialize and run [*]. Enclaves not signed
with this key can not initialize and run.

Add FEAT_CTL_SGX_LC_ENABLED, which informs whether the SGXLEPUBKEYHASH MSRs
can be written by the kernel.

If the MSRs do not exist or are read-only, the launch control hardware is
operating in rigid mode. Linux does not and will not support creating
enclaves when hardware is configured in rigid mode because it takes away
the authority for launch decisions from the kernel. Note, this does not
preclude KVM from virtualizing/exposing SGX to a KVM guest when launch
control hardware is operating in rigid mode.

[*] Intel SDM: 38.1.4 Intel SGX Launch Control Configuration

Acked-by: Jethro Beekman <jethro@fortanix.com> # v40
# Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Co-developed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/include/asm/msr-index.h   | 7 +++++++
 2 files changed, 8 insertions(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 1181f5c7bbef..f5ef2d5b9231 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -357,6 +357,7 @@
 #define X86_FEATURE_MOVDIRI		(16*32+27) /* MOVDIRI instruction */
 #define X86_FEATURE_MOVDIR64B		(16*32+28) /* MOVDIR64B instruction */
 #define X86_FEATURE_ENQCMD		(16*32+29) /* ENQCMD and ENQCMDS instructions */
+#define X86_FEATURE_SGX_LC		(16*32+30) /* Software Guard Extensions Launch Control */
 
 /* AMD-defined CPU features, CPUID level 0x80000007 (EBX), word 17 */
 #define X86_FEATURE_OVERFLOW_RECOV	(17*32+ 0) /* MCA overflow recovery support */
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index 16154953704a..6a5085a5f9d8 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -610,6 +610,7 @@
 #define FEAT_CTL_LOCKED				BIT(0)
 #define FEAT_CTL_VMX_ENABLED_INSIDE_SMX		BIT(1)
 #define FEAT_CTL_VMX_ENABLED_OUTSIDE_SMX	BIT(2)
+#define FEAT_CTL_SGX_LC_ENABLED			BIT(17)
 #define FEAT_CTL_SGX_ENABLED			BIT(18)
 #define FEAT_CTL_LMCE_ENABLED			BIT(20)
 
@@ -630,6 +631,12 @@
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
2.27.0

