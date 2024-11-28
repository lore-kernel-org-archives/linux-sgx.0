Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3EE9199236
	for <linux-sgx@vger.kernel.org>; Thu, 28 Nov 2024 01:35:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732757715; cv=none; b=mw8l3+BYM5dAUfUrRHmTHegTwWaGLTqLRjIYgSXW+3WA2iAjHan+ZZANh6xkBdW3ByDLgeGUlNEs2UMohR2k/7T9yByUthbCBs+lsvHkm/ZO0wQNmTn9itnfE6keDE+QU//Tzn1bPBt1VHvR486NFA1CMrHufJ3j5VpFn4R0j+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732757715; c=relaxed/simple;
	bh=mynEW5RY1CwrThe8+BS7bdNjNj2INsikDNcPtpDixYQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=B6co45TdEsonCFOL3uYkLxMjj34lbR5znGSY2TqkAI9Z5qmbHTrqr6l4O1uMoMthibVmyC2TqRoTGoYNX5T+3NhTD8wNbriWSpRyuP5iyjAjoE9M3I8C7oBdQ6HRUVBXxHwRiyYwd+6D5XsVRebLWVmpnuLiQvo0sbXeszzPOBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZKFQro03; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZKFQro03"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ea42039766so386162a91.3
        for <linux-sgx@vger.kernel.org>; Wed, 27 Nov 2024 17:35:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732757712; x=1733362512; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=OKbbnnzMcL1oSr/+1CYLrjR1YFBXMiCmkqIHxxio/uQ=;
        b=ZKFQro0310nziF4OdcL3kpzqLS7vtZjBAyWUmu50pBH5dWA/mq001crjxmgwn2Zz+/
         1ftwZnOdFF/sTJgVGe9QjcQB1o2JTYFJq7ikqLwO7QEHAIwBqdWr4QZX3k9WUfWC7/rt
         OdU2sEv+/h5Lbvg9E6Q4IXLqzK71F31bcXF4mpyw0Rdv847tFjbGiLPoBn0Z3Om/+R5R
         3fEkEDRBWYmKRCFjRAFbXvFG8fBNuMccCgcECNqFa1DzIGxvYmia04yP2PnBAzB1da3H
         jCTXU2TMRnGnfstBy0JV2G1hb0/n6FbzJRb3b4xqyCovbLb43BpUvWEDZUxK+P6X0Vhp
         wu6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732757712; x=1733362512;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OKbbnnzMcL1oSr/+1CYLrjR1YFBXMiCmkqIHxxio/uQ=;
        b=J7gW8/9K+lIcg80s/mluOLUnflbpEhJps5xulqyQwQibhJXnZ6Bei41dlukl3YZZrJ
         z8ZJE6GjZLLFYjTaywZsXc5pr53RSSg9oU6EC9h+TxCHkfzPTHARxbXgAD+eOFJSp62d
         T6N71eWavcHYpHAJLbn3Vd3+z6Ox0FNaJ09WvMR4P+jO5QWBOde1bvYNgI98xWzPOc3W
         L5GwXTc8twTa/09D83tHayRv2RF+8NV3p1VStVQHYQSNl6MX7Pgrq42Un2ULBMpWxsaT
         AX+zFE4DcyPgvE0xoeGWbt30dF8p6l4fSD7LJteQ6DZOh1kxY1oGrWl8LQui/FYOafG0
         c1DQ==
X-Forwarded-Encrypted: i=1; AJvYcCWdwxjJdvs3h3pbhj7Chtkf0AjmKYMfoWwfAvo77V+fK38MQW8s2CeQ/fjYbv48Oawsup/W0XFktic=@vger.kernel.org
X-Gm-Message-State: AOJu0YweXYdj1NWp3KUyd58+YJub9CJK5xEP0uDcmCqAwGWKjEZGrrJD
	sQfaqsk9IaeC/rSMBnptV/zVA3oQkNa76qZ4l+sB/xWH59BT8a7bHDyH4EhKza41/SwrTcbrLBT
	/Mw==
X-Google-Smtp-Source: AGHT+IGgz1Bucp0lNJaHliSwg1cWwVq633SYzDJy333XRXNKxI0aXMjY9gyGucM1+gACgTGSirkX6s0TBl0=
X-Received: from pjbpq13.prod.google.com ([2002:a17:90b:3d8d:b0:2ea:3a1b:f493])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4d0d:b0:2ea:3f34:f194
 with SMTP id 98e67ed59e1d1-2ee08eaea41mr6810063a91.10.1732757712311; Wed, 27
 Nov 2024 17:35:12 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 17:33:50 -0800
In-Reply-To: <20241128013424.4096668-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128013424.4096668-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128013424.4096668-24-seanjc@google.com>
Subject: [PATCH v3 23/57] KVM: x86: Rename kvm_cpu_cap_mask() to kvm_cpu_cap_init()
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

Rename kvm_cpu_cap_mask() to kvm_cpu_cap_init() in anticipation of merging
it with kvm_cpu_cap_init_kvm_defined(), and in anticipation of _setting_
bits in the helper (a future commit will play macro games to set emulated
feature flags via kvm_cpu_cap_init()).

No functional change intended.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 00b5b1a2a66f..9bd8bac3cd52 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -615,7 +615,7 @@ static __always_inline void __kvm_cpu_cap_mask(unsigned int leaf)
 static __always_inline
 void kvm_cpu_cap_init_kvm_defined(enum kvm_only_cpuid_leafs leaf, u32 mask)
 {
-	/* Use kvm_cpu_cap_mask for leafs that aren't KVM-only. */
+	/* Use kvm_cpu_cap_init for leafs that aren't KVM-only. */
 	BUILD_BUG_ON(leaf < NCAPINTS);
 
 	kvm_cpu_caps[leaf] = mask;
@@ -623,7 +623,7 @@ void kvm_cpu_cap_init_kvm_defined(enum kvm_only_cpuid_leafs leaf, u32 mask)
 	__kvm_cpu_cap_mask(leaf);
 }
 
-static __always_inline void kvm_cpu_cap_mask(enum cpuid_leafs leaf, u32 mask)
+static __always_inline void kvm_cpu_cap_init(enum cpuid_leafs leaf, u32 mask)
 {
 	/* Use kvm_cpu_cap_init_kvm_defined for KVM-only leafs. */
 	BUILD_BUG_ON(leaf >= NCAPINTS);
@@ -661,7 +661,7 @@ void kvm_set_cpu_caps(void)
 	memcpy(&kvm_cpu_caps, &boot_cpu_data.x86_capability,
 	       sizeof(kvm_cpu_caps) - (NKVMCAPINTS * sizeof(*kvm_cpu_caps)));
 
-	kvm_cpu_cap_mask(CPUID_1_ECX,
+	kvm_cpu_cap_init(CPUID_1_ECX,
 		F(XMM3) |
 		F(PCLMULQDQ) |
 		0 /* DTES64 */ |
@@ -697,7 +697,7 @@ void kvm_set_cpu_caps(void)
 	/* KVM emulates x2apic in software irrespective of host support. */
 	kvm_cpu_cap_set(X86_FEATURE_X2APIC);
 
-	kvm_cpu_cap_mask(CPUID_1_EDX,
+	kvm_cpu_cap_init(CPUID_1_EDX,
 		F(FPU) |
 		F(VME) |
 		F(DE) |
@@ -727,7 +727,7 @@ void kvm_set_cpu_caps(void)
 		0 /* HTT, TM, Reserved, PBE */
 	);
 
-	kvm_cpu_cap_mask(CPUID_7_0_EBX,
+	kvm_cpu_cap_init(CPUID_7_0_EBX,
 		F(FSGSBASE) |
 		F(SGX) |
 		F(BMI1) |
@@ -757,7 +757,7 @@ void kvm_set_cpu_caps(void)
 		F(AVX512BW) |
 		F(AVX512VL));
 
-	kvm_cpu_cap_mask(CPUID_7_ECX,
+	kvm_cpu_cap_init(CPUID_7_ECX,
 		F(AVX512VBMI) |
 		F(LA57) |
 		F(PKU) |
@@ -789,7 +789,7 @@ void kvm_set_cpu_caps(void)
 	if (!tdp_enabled || !boot_cpu_has(X86_FEATURE_OSPKE))
 		kvm_cpu_cap_clear(X86_FEATURE_PKU);
 
-	kvm_cpu_cap_mask(CPUID_7_EDX,
+	kvm_cpu_cap_init(CPUID_7_EDX,
 		F(AVX512_4VNNIW) |
 		F(AVX512_4FMAPS) |
 		F(SPEC_CTRL) |
@@ -821,7 +821,7 @@ void kvm_set_cpu_caps(void)
 	if (boot_cpu_has(X86_FEATURE_AMD_SSBD))
 		kvm_cpu_cap_set(X86_FEATURE_SPEC_CTRL_SSBD);
 
-	kvm_cpu_cap_mask(CPUID_7_1_EAX,
+	kvm_cpu_cap_init(CPUID_7_1_EAX,
 		F(SHA512) |
 		F(SM3) |
 		F(SM4) |
@@ -854,7 +854,7 @@ void kvm_set_cpu_caps(void)
 		F(MCDT_NO)
 	);
 
-	kvm_cpu_cap_mask(CPUID_D_1_EAX,
+	kvm_cpu_cap_init(CPUID_D_1_EAX,
 		F(XSAVEOPT) |
 		F(XSAVEC) |
 		F(XGETBV1) |
@@ -874,7 +874,7 @@ void kvm_set_cpu_caps(void)
 		F(AVX10_512)
 	);
 
-	kvm_cpu_cap_mask(CPUID_8000_0001_ECX,
+	kvm_cpu_cap_init(CPUID_8000_0001_ECX,
 		F(LAHF_LM) |
 		F(CMP_LEGACY) |
 		0 /*SVM*/ |
@@ -894,7 +894,7 @@ void kvm_set_cpu_caps(void)
 		0 /* PERFCTR_CORE */
 	);
 
-	kvm_cpu_cap_mask(CPUID_8000_0001_EDX,
+	kvm_cpu_cap_init(CPUID_8000_0001_EDX,
 		F(FPU) |
 		F(VME) |
 		F(DE) |
@@ -935,7 +935,7 @@ void kvm_set_cpu_caps(void)
 		SF(CONSTANT_TSC)
 	);
 
-	kvm_cpu_cap_mask(CPUID_8000_0008_EBX,
+	kvm_cpu_cap_init(CPUID_8000_0008_EBX,
 		F(CLZERO) |
 		F(XSAVEERPTR) |
 		F(WBNOINVD) |
@@ -981,9 +981,9 @@ void kvm_set_cpu_caps(void)
 	 * Hide all SVM features by default, SVM will set the cap bits for
 	 * features it emulates and/or exposes for L1.
 	 */
-	kvm_cpu_cap_mask(CPUID_8000_000A_EDX, 0);
+	kvm_cpu_cap_init(CPUID_8000_000A_EDX, 0);
 
-	kvm_cpu_cap_mask(CPUID_8000_001F_EAX,
+	kvm_cpu_cap_init(CPUID_8000_001F_EAX,
 		0 /* SME */ |
 		0 /* SEV */ |
 		0 /* VM_PAGE_FLUSH */ |
@@ -991,7 +991,7 @@ void kvm_set_cpu_caps(void)
 		F(SME_COHERENT)
 	);
 
-	kvm_cpu_cap_mask(CPUID_8000_0021_EAX,
+	kvm_cpu_cap_init(CPUID_8000_0021_EAX,
 		F(NO_NESTED_DATA_BP) |
 		F(LFENCE_RDTSC) |
 		0 /* SmmPgCfgLock */ |
@@ -1015,7 +1015,7 @@ void kvm_set_cpu_caps(void)
 	 * kernel.  LFENCE_RDTSC was a Linux-defined synthetic feature long
 	 * before AMD joined the bandwagon, e.g. LFENCE is serializing on most
 	 * CPUs that support SSE2.  On CPUs that don't support AMD's leaf,
-	 * kvm_cpu_cap_mask() will unfortunately drop the flag due to ANDing
+	 * kvm_cpu_cap_init() will unfortunately drop the flag due to ANDing
 	 * the mask with the raw host CPUID, and reporting support in AMD's
 	 * leaf can make it easier for userspace to detect the feature.
 	 */
@@ -1025,7 +1025,7 @@ void kvm_set_cpu_caps(void)
 		kvm_cpu_cap_set(X86_FEATURE_NULL_SEL_CLR_BASE);
 	kvm_cpu_cap_set(X86_FEATURE_NO_SMM_CTL_MSR);
 
-	kvm_cpu_cap_mask(CPUID_C000_0001_EDX,
+	kvm_cpu_cap_init(CPUID_C000_0001_EDX,
 		F(XSTORE) |
 		F(XSTORE_EN) |
 		F(XCRYPT) |
-- 
2.47.0.338.g60cca15819-goog

