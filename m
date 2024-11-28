Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D7D6142623
	for <linux-sgx@vger.kernel.org>; Thu, 28 Nov 2024 01:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732757770; cv=none; b=WuxsNIzlapZam7fSzelXMvWEtTDCnNd/qJt/xMAgv4LNssdCMAnmUo4FrTJtXHO4NTM3j/8FfbDixztb/G+D5g2gTwwV04O4Vp0+deU42069967TMvW6S1i+aw1R/43TyhLYq7dvqPXUT+qThtYGZdq1fE8linQM3dvsNMyGAak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732757770; c=relaxed/simple;
	bh=R49XVj95vzRXKmLwQdP6oo0VVyehKxTCMWaAZazZJfA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bgso/dFx3dWAg/wTbd1P8DXctH6FdA4+WAYP7r/hj7rOuhFcuDiMFKheSQDxYFxkjX3pgV5LO5p6orBe9h27Jadb/cTa1JhtwP7M6EvVStjtBAtlM60ByDLr0nRGmMHipJS3U2PvFfTHoFSbOWP+XxlmgU0sW7Qzb+Ys+vy+uq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aUAWzpyc; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aUAWzpyc"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ea46465ce4so403311a91.2
        for <linux-sgx@vger.kernel.org>; Wed, 27 Nov 2024 17:36:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732757768; x=1733362568; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=BbCzGtzIrTwyJgXyO8iEL18RFxRsVT7iWqurAFzR1X8=;
        b=aUAWzpyc7X3PSYZE9Xa3pqjBTHSUEt62Ra9zFd74EJwbH5hZ2RdnwED/5+K+3DZiYY
         /e8/nZ6p+sjp0eYPlliEfMYGzmslDn9BuCrLlWkPqirs1Uu3uyk7TlgbHyZ5IAEVYJ08
         yUvO8TnUldqq9Z9r1PpSSVIcLFZVk8E2vu34TciSBqx0VoYvb9ogLE+fKgKYZoQcX7ej
         9Y/CaNZZ3KoHocmTYwaM9TzlfIr9bld6og8T+8P1PsDqoJhD3M1UlHEO2UQgIXXElvyU
         e+5ilHH8fTMMNLGfczX52wNMdHiRJz8Is/Ev1zwlIHEZ8Dw5Se7+YCDq0ljAkjAuSrho
         gZBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732757768; x=1733362568;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BbCzGtzIrTwyJgXyO8iEL18RFxRsVT7iWqurAFzR1X8=;
        b=JOYRwvOpPYKlofNYOCjlCA+FXW2JhRzKu/2IZ/THFW0uU2y+6gXxdS5sRJTpXaHony
         Pxb+3yepoNpgYpFgs2+gbLW1FIVYTKYg8uxzoie8nTrT7+J+7e6NEEOjwwPs2kawy303
         fosiaQ+mzhWvI9pLgbUgQkW2dH079tWQca8aLkPuOqLyXsWR4dBDLmKNX7Y3n+iMKC/4
         FtiA8cmbE2FPFONoC57zGyu3hnC4LwyUFzBWm/T4QIYWcGDV5ir5K6gWH+D7iDjPXt1g
         bMpX/yyLiiPvrkQpCLojoSpieCGXg3QVwo0dl6fYmVQGKl2KqE7JcfvOfXe++nFsUOiE
         UAZQ==
X-Forwarded-Encrypted: i=1; AJvYcCVD7R6fAzZphXGmZZcNsLi2JwWxoVfc/2dP4WqfxnUV3y7dxwPFOqCYuqrmVwSF1EzQeL4NebR7hmo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwfS4/SGPs34LXGKo3XU0MIiKsAssIj/i2iITI7DjkM/Ebab2fq
	ajbZY2r4GKp6O3TpWw6ExTXmIRXADBTYivqOGFyE5ciDFE6FG8Vc5ll6qSleZwPLW5o/IiH1pUs
	sHw==
X-Google-Smtp-Source: AGHT+IGANpzXQkLp25+HMAbiu14EmQkRHWfHHnr3gEjM9geytT/xBKhr7bm2r8T1054yxPvG8JKjq2RnVcg=
X-Received: from pjbta13.prod.google.com ([2002:a17:90b:4ecd:b0:2ea:931d:7ced])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3148:b0:2ea:5083:6b6c
 with SMTP id 98e67ed59e1d1-2ee08e9fd86mr8134901a91.12.1732757768378; Wed, 27
 Nov 2024 17:36:08 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 17:34:22 -0800
In-Reply-To: <20241128013424.4096668-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128013424.4096668-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128013424.4096668-56-seanjc@google.com>
Subject: [PATCH v3 55/57] KVM: x86: Explicitly track feature flags that
 require vendor enabling
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Jarkko Sakkinen <jarkko@kernel.org>
Cc: kvm@vger.kernel.org, linux-sgx@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>, 
	Hou Wenlong <houwenlong.hwl@antgroup.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Kechen Lu <kechenl@nvidia.com>, Oliver Upton <oliver.upton@linux.dev>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang <weijiang.yang@intel.com>, 
	Robert Hoo <robert.hoo.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Add another CPUID feature macro, VENDOR_F(), and use it to track features
that KVM supports, but that need additional vendor support and so are
conditionally enabled in vendor code.

Currently, VENDOR_F() is mostly just documentation, but tracking all
KVM-supported features will allow for asserting, at build time, take),
that all features that are set, cleared, *or* checked by KVM are known to
kvm_set_cpu_caps().

To fudge around a macro collision on 32-bit kernels, #undef DS to be able
to get at X86_FEATURE_DS.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 59 ++++++++++++++++++++++++++++++++------------
 1 file changed, 43 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index a1a80f1f10ec..5ac5fe2febf7 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -758,12 +758,25 @@ do {									\
 	feature_bit(name);							\
 })
 
+/*
+ * Vendor Features - For features that KVM supports, but are added in later
+ * because they require additional vendor enabling.
+ */
+#define VENDOR_F(name)						\
+({								\
+	KVM_VALIDATE_CPU_CAP_USAGE(name);			\
+	0;							\
+})
+
 /*
  * Undefine the MSR bit macro to avoid token concatenation issues when
  * processing X86_FEATURE_SPEC_CTRL_SSBD.
  */
 #undef SPEC_CTRL_SSBD
 
+/* DS is defined by ptrace-abi.h on 32-bit builds. */
+#undef DS
+
 void kvm_set_cpu_caps(void)
 {
 	memset(kvm_cpu_caps, 0, sizeof(kvm_cpu_caps));
@@ -774,13 +787,14 @@ void kvm_set_cpu_caps(void)
 	kvm_cpu_cap_init(CPUID_1_ECX,
 		F(XMM3) |
 		F(PCLMULQDQ) |
-		0 /* DTES64 */ |
+		VENDOR_F(DTES64) |
 		/*
 		 * NOTE: MONITOR (and MWAIT) are emulated as NOP, but *not*
 		 * advertised to guests via CPUID!
 		 */
 		0 /* MONITOR */ |
-		0 /* DS-CPL, VMX, SMX, EST */ |
+		VENDOR_F(VMX) |
+		0 /* DS-CPL, SMX, EST */ |
 		0 /* TM2 */ |
 		F(SSSE3) |
 		0 /* CNXT-ID */ |
@@ -827,7 +841,9 @@ void kvm_set_cpu_caps(void)
 		F(PSE36) |
 		0 /* PSN */ |
 		F(CLFLUSH) |
-		0 /* Reserved, DS, ACPI */ |
+		0 /* Reserved */ |
+		VENDOR_F(DS) |
+		0 /* ACPI */ |
 		F(MMX) |
 		F(FXSR) |
 		F(XMM) |
@@ -850,7 +866,7 @@ void kvm_set_cpu_caps(void)
 		F(INVPCID) |
 		F(RTM) |
 		F(ZERO_FCS_FDS) |
-		0 /*MPX*/ |
+		VENDOR_F(MPX) |
 		F(AVX512F) |
 		F(AVX512DQ) |
 		F(RDSEED) |
@@ -859,7 +875,7 @@ void kvm_set_cpu_caps(void)
 		F(AVX512IFMA) |
 		F(CLFLUSHOPT) |
 		F(CLWB) |
-		0 /*INTEL_PT*/ |
+		VENDOR_F(INTEL_PT) |
 		F(AVX512PF) |
 		F(AVX512ER) |
 		F(AVX512CD) |
@@ -884,7 +900,7 @@ void kvm_set_cpu_caps(void)
 		F(CLDEMOTE) |
 		F(MOVDIRI) |
 		F(MOVDIR64B) |
-		0 /*WAITPKG*/ |
+		VENDOR_F(WAITPKG) |
 		F(SGX_LC) |
 		F(BUS_LOCK_DETECT)
 	);
@@ -980,7 +996,7 @@ void kvm_set_cpu_caps(void)
 	kvm_cpu_cap_init(CPUID_8000_0001_ECX,
 		F(LAHF_LM) |
 		F(CMP_LEGACY) |
-		0 /*SVM*/ |
+		VENDOR_F(SVM) |
 		0 /* ExtApicSpace */ |
 		F(CR8_LEGACY) |
 		F(ABM) |
@@ -994,7 +1010,7 @@ void kvm_set_cpu_caps(void)
 		F(FMA4) |
 		F(TBM) |
 		F(TOPOEXT) |
-		0 /* PERFCTR_CORE */
+		VENDOR_F(PERFCTR_CORE)
 	);
 
 	kvm_cpu_cap_init(CPUID_8000_0001_EDX,
@@ -1080,17 +1096,27 @@ void kvm_set_cpu_caps(void)
 	    !boot_cpu_has(X86_FEATURE_AMD_SSBD))
 		kvm_cpu_cap_set(X86_FEATURE_VIRT_SSBD);
 
-	/*
-	 * Hide all SVM features by default, SVM will set the cap bits for
-	 * features it emulates and/or exposes for L1.
-	 */
-	kvm_cpu_cap_init(CPUID_8000_000A_EDX, 0);
+	/* All SVM features required additional vendor module enabling. */
+	kvm_cpu_cap_init(CPUID_8000_000A_EDX,
+		VENDOR_F(NPT) |
+		VENDOR_F(VMCBCLEAN) |
+		VENDOR_F(FLUSHBYASID) |
+		VENDOR_F(NRIPS) |
+		VENDOR_F(TSCRATEMSR) |
+		VENDOR_F(V_VMSAVE_VMLOAD) |
+		VENDOR_F(LBRV) |
+		VENDOR_F(PAUSEFILTER) |
+		VENDOR_F(PFTHRESHOLD) |
+		VENDOR_F(VGIF) |
+		VENDOR_F(VNMI) |
+		VENDOR_F(SVME_ADDR_CHK)
+	);
 
 	kvm_cpu_cap_init(CPUID_8000_001F_EAX,
-		0 /* SME */ |
-		0 /* SEV */ |
+		VENDOR_F(SME) |
+		VENDOR_F(SEV) |
 		0 /* VM_PAGE_FLUSH */ |
-		0 /* SEV_ES */ |
+		VENDOR_F(SEV_ES) |
 		F(SME_COHERENT)
 	);
 
@@ -1162,6 +1188,7 @@ EXPORT_SYMBOL_GPL(kvm_set_cpu_caps);
 #undef SYNTHESIZED_F
 #undef PASSTHROUGH_F
 #undef ALIASED_1_EDX_F
+#undef VENDOR_F
 
 struct kvm_cpuid_array {
 	struct kvm_cpuid_entry2 *entries;
-- 
2.47.0.338.g60cca15819-goog

