Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 100741A00F0
	for <linux-sgx@vger.kernel.org>; Thu, 28 Nov 2024 01:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732757717; cv=none; b=jVIXJBM2MgRK2eLDyOEyDfr+LDADLF3/mHjBcdDYJ3jke6S9TH7bYOGQr5yA9PebfvCc4KVzyrJQU/r5Z2jHM8kiy3dPpYNGfQQmbT1NWlW1gbPESXdw1VrjMmvbZ00NyWO/1vxChbzHDCdKx+St0VNPp5bcB0852TMq4GeIE24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732757717; c=relaxed/simple;
	bh=Wq5LM6NqLa3bJHEUV5BTVIFsmH63BQ1SZbZwRoHeBQQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MIwtXm7rRRABMYyRqHBYbxvX+HPdyirK8x/pxiqgobyc3HhY50G9u7y9JQmcMIC4SW64ulNtMN+fcYmxeaOsTqMz1GwnYs4B/QUtp44bALD0Z84dQ6658KBX8Cz5VThFIDko2Va2U7rbprAROOhZgev+pQ3dNVe6NPKqgOIMdHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tipgPEUP; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tipgPEUP"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2e5efb04da7so379841a91.0
        for <linux-sgx@vger.kernel.org>; Wed, 27 Nov 2024 17:35:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732757715; x=1733362515; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=4bBB0NQOkuxY/fMRl1/Z0GmdB3PHk1lvBMv7RHKM/5o=;
        b=tipgPEUPv4NrBSsd4AiteBFW7P/aWwAQiT29+mxuNuPntDECpNmfPud5HhL7Wrq02U
         IOsvzbNVO/S17IpniAieMucecdTM3o+mLIL50KxTXwFG+LdyqEkq2PqJTNFwk2bl6O/U
         92fAm8ZLyoYWvI7AbHrhqaY1MZYCnsoqIwMeYiL0dorp86UJ8m+Q9ngTpsH/ugQH8arr
         b1g9GwUP/g3kvxB+9SihjBsPbcSQL7Q6uGLOhXzyfpg2UKdNLAyj6bVQ41epuW/Sp9Tr
         QFv24mVo+J1N8zk9IkP9kSFg3nRix6N4vARTZRYhb7kSvV0IcwSsttCx12TMii46goeD
         473w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732757715; x=1733362515;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4bBB0NQOkuxY/fMRl1/Z0GmdB3PHk1lvBMv7RHKM/5o=;
        b=KV1SoYu1rsAcYP7m/lSkbNk+27HHtmRFJLw1tcqiW7znGqkhSSfjN9IDcL3KbUM/BJ
         HPk8ZqjYb6SejZrh3AtsXk6KzrFQBwmcSIwR2m1HoufACG5ow7vdbnWST5CFfjUfusaj
         byERu6mflH2SsyjIi+HPoIea+yJEOLTyZ/gJ9vLFRcUC+BT1dzD68J55GowFGt07SK7I
         CZYcuTp8q3javYqAtMQmCF6wZTS5GCfhj5WbkzKlY8WqDCTZ2HdmBIb1ZfvThHe10xOS
         yZeQIzzy4ZzXpAjoDLflV/pne44rRl0g+4GjdioIx7GmTagWqQ9cIR3D2tzT9V0ysk8m
         rpig==
X-Forwarded-Encrypted: i=1; AJvYcCXco9lTNWCOODuoU/1v8xCxRVTxMge3S1W81qkZgKha/LxVzoHzJNxB8VHS9mDsMrRTlzXMOV2Fg68=@vger.kernel.org
X-Gm-Message-State: AOJu0YyPDv734rowEnO9VGpwKakqk6EGkVtWxSiXpp7pLbP9EC9efxtS
	8rngbnC0YejTkWpzEdA0r7IiV9sTwKEA+cXRyJ+EecWae1LNYreTmVXKn+B+kFPTxJwmNiWT0jC
	Ybw==
X-Google-Smtp-Source: AGHT+IGwrEfLn6hBewUj/il+Vfs6v5UsNGJgiFF2RXZQmzZ8b1U9q7mlrLEDaSRSfx3tH3diTdGghP34XRs=
X-Received: from pjbqn7.prod.google.com ([2002:a17:90b:3d47:b0:2e0:a50e:a55e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4c46:b0:2ea:aa69:1067
 with SMTP id 98e67ed59e1d1-2ee08e5e389mr6492735a91.3.1732757715563; Wed, 27
 Nov 2024 17:35:15 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 17:33:52 -0800
In-Reply-To: <20241128013424.4096668-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128013424.4096668-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128013424.4096668-26-seanjc@google.com>
Subject: [PATCH v3 25/57] KVM: x86: Add a macro to precisely handle aliased
 0x1.EDX CPUID features
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

Add a macro to precisely handle CPUID features that AMD duplicated from
CPUID.0x1.EDX into CPUID.0x8000_0001.EDX.  This will allow adding an
assert that all features passed to kvm_cpu_cap_init() match the word being
processed, e.g. to prevent passing a feature from CPUID 0x7 to CPUID 0x1.

Because the kernel simply reuses the X86_FEATURE_* definitions from
CPUID.0x1.EDX, KVM's use of the aliased features would result in false
positives from such an assert.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 47 +++++++++++++++++++++++++++-----------------
 1 file changed, 29 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 9219e164c810..ddff0c7c78b9 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -648,6 +648,16 @@ static __always_inline void kvm_cpu_cap_init(enum cpuid_leafs leaf, u32 mask)
 	(IS_ENABLED(CONFIG_X86_64) ? F(name) : 0);		\
 })
 
+/*
+ * Aliased Features - For features in 0x8000_0001.EDX that are duplicates of
+ * identical 0x1.EDX features, and thus are aliased from 0x1 to 0x8000_0001.
+ */
+#define ALIASED_1_EDX_F(name)							\
+({										\
+	BUILD_BUG_ON(__feature_leaf(X86_FEATURE_##name) != CPUID_1_EDX);	\
+	feature_bit(name);							\
+})
+
 void kvm_set_cpu_caps(void)
 {
 	memset(kvm_cpu_caps, 0, sizeof(kvm_cpu_caps));
@@ -892,30 +902,30 @@ void kvm_set_cpu_caps(void)
 	);
 
 	kvm_cpu_cap_init(CPUID_8000_0001_EDX,
-		F(FPU) |
-		F(VME) |
-		F(DE) |
-		F(PSE) |
-		F(TSC) |
-		F(MSR) |
-		F(PAE) |
-		F(MCE) |
-		F(CX8) |
-		F(APIC) |
+		ALIASED_1_EDX_F(FPU) |
+		ALIASED_1_EDX_F(VME) |
+		ALIASED_1_EDX_F(DE) |
+		ALIASED_1_EDX_F(PSE) |
+		ALIASED_1_EDX_F(TSC) |
+		ALIASED_1_EDX_F(MSR) |
+		ALIASED_1_EDX_F(PAE) |
+		ALIASED_1_EDX_F(MCE) |
+		ALIASED_1_EDX_F(CX8) |
+		ALIASED_1_EDX_F(APIC) |
 		0 /* Reserved */ |
 		F(SYSCALL) |
-		F(MTRR) |
-		F(PGE) |
-		F(MCA) |
-		F(CMOV) |
-		F(PAT) |
-		F(PSE36) |
+		ALIASED_1_EDX_F(MTRR) |
+		ALIASED_1_EDX_F(PGE) |
+		ALIASED_1_EDX_F(MCA) |
+		ALIASED_1_EDX_F(CMOV) |
+		ALIASED_1_EDX_F(PAT) |
+		ALIASED_1_EDX_F(PSE36) |
 		0 /* Reserved */ |
 		F(NX) |
 		0 /* Reserved */ |
 		F(MMXEXT) |
-		F(MMX) |
-		F(FXSR) |
+		ALIASED_1_EDX_F(MMX) |
+		ALIASED_1_EDX_F(FXSR) |
 		F(FXSR_OPT) |
 		X86_64_F(GBPAGES) |
 		F(RDTSCP) |
@@ -1055,6 +1065,7 @@ EXPORT_SYMBOL_GPL(kvm_set_cpu_caps);
 #undef F
 #undef SF
 #undef X86_64_F
+#undef ALIASED_1_EDX_F
 
 struct kvm_cpuid_array {
 	struct kvm_cpuid_entry2 *entries;
-- 
2.47.0.338.g60cca15819-goog

