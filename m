Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B201CCED8
	for <linux-sgx@vger.kernel.org>; Thu, 28 Nov 2024 01:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732757759; cv=none; b=opp02z1kyD4E5DT8eV8auG4WXhHLcklibImsawJVvrwzz2wvCPgxRKSxEHCxPp43C8VljJ6oX6ueTZVU6ZX0ooXpI4idjAw6TxKm2U1YLwxz+Nr5h4+Gbq/F6tXTwUsegO2ZQG6NNO704djET7XcpIwk3G1n2w0cTOJAxa0Tj4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732757759; c=relaxed/simple;
	bh=X1KFY9JDaWm435e/48kpMrX7/Px0BLMN53pN+9kw0zE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VHRCjCXYaRIVx+iacrdWOxa0xNRbwsghRlGmyk1/Scne5YdUcgkLgDZZxVIe4DB4VeOSL82w0p7dpurrOfiyumb12cjf00FkNnfLoatredP64Yjsz8C6SZtMOdB88cogD+zthwKaOcSJL9uqcbC8HYjR5u7rDNu9nXMKxPj+iqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uZUD05qj; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uZUD05qj"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ea41a5bfe7so382737a91.2
        for <linux-sgx@vger.kernel.org>; Wed, 27 Nov 2024 17:35:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732757758; x=1733362558; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=T/azVSgkTWzv8BfKxc6pAx4oV5kx86H9lfQ2pUatGZc=;
        b=uZUD05qjXCwzPlHFpelfZO9kyiNKkERzx5/4XBuwQ8B7uznlBJI/speX1P5RFoh9O9
         2iLGrkMq+jzwhnJdUvBqggNIvEHZPE2rjEpb+HfGlhCF6IMVzkbW7SwTTpPJLi8s9oLX
         o80TZiXxFDBzUhM3j30JgYA9AnlsMMiBCF6oNlHgww5eDPMePIsowZXi7GJwAyobJIJy
         M7CpxeZc8TgCPXVmrKKFASOkd08lH8JVvjEkc29Cb5D9Nhm1eVi6Pirrb5zlF70t5WeS
         W0f0+CNxqDe51z5gWRxz/fq1qmRIsK7TjFa3D9P+EEjOQZSbQe/ONFTjdHm1oJvxwuo5
         P5dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732757758; x=1733362558;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T/azVSgkTWzv8BfKxc6pAx4oV5kx86H9lfQ2pUatGZc=;
        b=U/cuLpdjHIIAW1QGrY9GeA9x1GM3WS/itDJz5dwAowTDqbfN2AE2XXGzos45vMDihq
         CXJEq+Z2omchCGq6fwBiGWedYT9xUzeGrx7uxjyA1Tcq1Cbyx5dxbrvWpWaQGtupTQP+
         FNmP4zvClTxBPZN7nTVbmdnxG5rMyveVcg8rgPAj+a9TjRkKcXLu+hR6Pway2MKZek0V
         xIUvYvTP8D4WctGOm9Rk+dJPM8RCdJJ+jic1SQHI/Qq/LZ170maERYRUYqfutAId2xcy
         5/urFh+rvSOjT6l3zUbMCcUxF+/EKYtqOPgPLCIbj4ncR5y0yyX6j29yQgOC83yc36zk
         xU3Q==
X-Forwarded-Encrypted: i=1; AJvYcCVEeOArsMlE/DZoxLF8GlrmoKK/QrWNwN1pZxwpFiMbehJldGMH7qo1B/Jogo3DUymgsodR+0BxGgU=@vger.kernel.org
X-Gm-Message-State: AOJu0YztmBHENNXWYMWqWLqbWu6t8BeBtNkmWDGQ9orkKs9izdCMCSVk
	J9aL1WMNFx9IOiPBnJLbwXzQBMFvJo5oFnUHAXBQyaoGaFZ5Ow8U2iKh1LJ+SGSRpwV2qfCZh7/
	iWg==
X-Google-Smtp-Source: AGHT+IFdhHXXQ+hWXIP9ZWM5zz75noCfQ39mgDA87KnR6usRc7BuJxpaKOJmZEA1ozX7y4nqiAuKb26SQu4=
X-Received: from pjuj3.prod.google.com ([2002:a17:90a:d003:b0:2e0:9fee:4b86])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2252:b0:2ea:8b06:ffcb
 with SMTP id 98e67ed59e1d1-2ee08eb2b91mr6591707a91.14.1732757757742; Wed, 27
 Nov 2024 17:35:57 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 17:34:16 -0800
In-Reply-To: <20241128013424.4096668-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128013424.4096668-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128013424.4096668-50-seanjc@google.com>
Subject: [PATCH v3 49/57] KVM: x86: Shuffle code to prepare for dropping guest_cpuid_has()
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

Move the implementations of guest_has_{spec_ctrl,pred_cmd}_msr() down
below guest_cpu_cap_has() so that their use of guest_cpuid_has() can be
replaced with calls to guest_cpu_cap_has().

No functional change intended.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.h | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 27da0964355c..4901145ba2dc 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -149,21 +149,6 @@ static inline int guest_cpuid_stepping(struct kvm_vcpu *vcpu)
 	return x86_stepping(best->eax);
 }
 
-static inline bool guest_has_spec_ctrl_msr(struct kvm_vcpu *vcpu)
-{
-	return (guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL) ||
-		guest_cpuid_has(vcpu, X86_FEATURE_AMD_STIBP) ||
-		guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBRS) ||
-		guest_cpuid_has(vcpu, X86_FEATURE_AMD_SSBD));
-}
-
-static inline bool guest_has_pred_cmd_msr(struct kvm_vcpu *vcpu)
-{
-	return (guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL) ||
-		guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBPB) ||
-		guest_cpuid_has(vcpu, X86_FEATURE_SBPB));
-}
-
 static inline bool supports_cpuid_fault(struct kvm_vcpu *vcpu)
 {
 	return vcpu->arch.msr_platform_info & MSR_PLATFORM_INFO_CPUID_FAULT;
@@ -279,4 +264,19 @@ static inline bool kvm_vcpu_is_legal_cr3(struct kvm_vcpu *vcpu, unsigned long cr
 	return kvm_vcpu_is_legal_gpa(vcpu, cr3);
 }
 
+static inline bool guest_has_spec_ctrl_msr(struct kvm_vcpu *vcpu)
+{
+	return (guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL) ||
+		guest_cpuid_has(vcpu, X86_FEATURE_AMD_STIBP) ||
+		guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBRS) ||
+		guest_cpuid_has(vcpu, X86_FEATURE_AMD_SSBD));
+}
+
+static inline bool guest_has_pred_cmd_msr(struct kvm_vcpu *vcpu)
+{
+	return (guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL) ||
+		guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBPB) ||
+		guest_cpuid_has(vcpu, X86_FEATURE_SBPB));
+}
+
 #endif
-- 
2.47.0.338.g60cca15819-goog

