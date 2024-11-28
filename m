Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E1A1CBA04
	for <linux-sgx@vger.kernel.org>; Thu, 28 Nov 2024 01:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732757758; cv=none; b=jFtvxy+1fC4ZKYi0Pnn1PmgtZZb5dXyPXjosaIahok8AKto0GnCng4MA5eXoGWgaT+7EK4pLeL2ZnOuVfJYFCZmSTK78EpDZuPVueB1EnIn2M2V90bq+/YBSAszbKOF3WcWlLikw3vsBzpU5b91pVfRR6bg5HZHWAvp9Yxq2OrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732757758; c=relaxed/simple;
	bh=G2lBHRid3/4PtvinjWp7apmL9dW9V1G0uvD3pQ009AE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hHHczH16Q++o992mTKlm1Qda4+iJrxMwhGCaVZ7/CDEf0QJQVp+HR9mhpU+JIoUzYJqhljW8aJgAW4nNXZFr7d+qgV4o0qfxcUNVAhQ6UjHyh01KJ7vLj3fJeP+anC0Z9Ta6WZV/gKzXOc7sFXmKLVPgLiiP6X6Zm9n8YVlqjHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=z5mxKueN; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="z5mxKueN"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7ea69eeb659so230404a12.0
        for <linux-sgx@vger.kernel.org>; Wed, 27 Nov 2024 17:35:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732757756; x=1733362556; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=q+2tj5qWfvzU/HpbeWp4U5fA1EnHQq5eiizkVcz8+0c=;
        b=z5mxKueNWyXHJWM59MSVLsWyfdugFOeKfhXvxI9Lb0GnPv7Nbxe+7V60/kqYMroiof
         jmmt4sKx4/Gcc06GYvEZFlweFMuQncjamE8GIUTZ59pgclIbFKUdQ73JWWbUJ9TSSOqv
         c9R0bM8NMldo5TmbRl0TJJCGTziVYEYfAzVi6MtuTcyFAlKQJQiFeHwUuDjM+/vQ3aW4
         PXODVxxW//zrsKZE08D/yXHaw54WIvzx+p9iHC3jNHtFvk+/RdLGQO7qCpr/QbKWN8R2
         0VRKFEObk/UwtpxhPIaVhQ3Y3axRqtzenoyfMzInjuMaZJkr+VaOOIsDJMI0rCevFEMH
         FMDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732757756; x=1733362556;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q+2tj5qWfvzU/HpbeWp4U5fA1EnHQq5eiizkVcz8+0c=;
        b=maGkmJzjox2+ntWxlVNEv6TKkzmIKOV1IgFyddYaNhzSwbsGM3maoAHtoo44AaSae9
         pf/GBsZt0amSFmgIlMaCHxKO/CbXXVkZCdmyHfaJolOyelG1+ZApih4khZTPgMqNuoyw
         fo5fW1Cq3Annrm/z2yeuuJHnypaN5lHGtJHzEIkvofQZtnrLQ0fSfCfax/wifUpyKbc7
         O+o5mgs08fSDTPJdBAujDXe48IQshHDqQXKryy7dGrIyTsMmBRE11MGvEaobEPnzw4fh
         GdsSapts2pO92c2NDKJHeDTsOtf43K7e0RvIzoJlaLUqT6M33EW6vVbJhbJJIViH0gyy
         2V0A==
X-Forwarded-Encrypted: i=1; AJvYcCUQh5Ok+m18rbOM5Ar8zhW05yZ+As0uZ59U9Vp77xFCdPkPxP8MSqiFaH5JRupY6/wdM3J+ueeOmz0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxnBebPF2FpXO2aopQzV3ZDZoCJcBhS87sG5ms9a1MVYrp+nsIy
	ovoRcaijMdZAKPaqbWQ61OQf3Y1VICp5m5TRbfGTiME/ecJEzwSKNgsrJzzA1j1DEwY52n4SE9o
	h+Q==
X-Google-Smtp-Source: AGHT+IHXcOjcRyaYqAsQ/WhFIeBd1rOxVK/Pjg6BAsmcNSYYFDZz/HBtaBNpLPxQAzICmeIHgQkvhjU8kiw=
X-Received: from pgbfy18.prod.google.com ([2002:a05:6a02:2a92:b0:7fc:7dce:edb4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:3944:b0:1e0:d632:b9e0
 with SMTP id adf61e73a8af0-1e0e0b0f127mr8764148637.13.1732757755865; Wed, 27
 Nov 2024 17:35:55 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 17:34:15 -0800
In-Reply-To: <20241128013424.4096668-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128013424.4096668-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128013424.4096668-49-seanjc@google.com>
Subject: [PATCH v3 48/57] KVM: x86: Update guest cpu_caps at runtime for
 dynamic CPUID-based features
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

When updating guest CPUID entries to emulate runtime behavior, e.g. when
the guest enables a CR4-based feature that is tied to a CPUID flag, also
update the vCPU's cpu_caps accordingly.  This will allow replacing all
usage of guest_cpuid_has() with guest_cpu_cap_has().

Note, this relies on kvm_set_cpuid() taking a snapshot of cpu_caps before
invoking kvm_update_cpuid_runtime(), i.e. when KVM is updating CPUID
entries that *may* become the vCPU's CPUID, so that unwinding to the old
cpu_caps is possible if userspace tries to set bogus CPUID information.

Note #2, none of the features in question use guest_cpu_cap_has() at this
time, i.e. aside from settings bits in cpu_caps, this is a glorified nop.

Cc: Yang Weijiang <weijiang.yang@intel.com>
Cc: Robert Hoo <robert.hoo.linux@gmail.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index be3357a408d4..d3c3e1327ca1 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -270,28 +270,38 @@ static u64 cpuid_get_supported_xcr0(struct kvm_vcpu *vcpu)
 	return (best->eax | ((u64)best->edx << 32)) & kvm_caps.supported_xcr0;
 }
 
+static __always_inline void kvm_update_feature_runtime(struct kvm_vcpu *vcpu,
+						       struct kvm_cpuid_entry2 *entry,
+						       unsigned int x86_feature,
+						       bool has_feature)
+{
+	cpuid_entry_change(entry, x86_feature, has_feature);
+	guest_cpu_cap_change(vcpu, x86_feature, has_feature);
+}
+
 void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best;
 
 	best = kvm_find_cpuid_entry(vcpu, 1);
 	if (best) {
-		cpuid_entry_change(best, X86_FEATURE_OSXSAVE,
-				   kvm_is_cr4_bit_set(vcpu, X86_CR4_OSXSAVE));
+		kvm_update_feature_runtime(vcpu, best, X86_FEATURE_OSXSAVE,
+					   kvm_is_cr4_bit_set(vcpu, X86_CR4_OSXSAVE));
 
-		cpuid_entry_change(best, X86_FEATURE_APIC,
-			   vcpu->arch.apic_base & MSR_IA32_APICBASE_ENABLE);
+		kvm_update_feature_runtime(vcpu, best, X86_FEATURE_APIC,
+					   vcpu->arch.apic_base & MSR_IA32_APICBASE_ENABLE);
 
 		if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT))
-			cpuid_entry_change(best, X86_FEATURE_MWAIT,
-					   vcpu->arch.ia32_misc_enable_msr &
-					   MSR_IA32_MISC_ENABLE_MWAIT);
+			kvm_update_feature_runtime(vcpu, best, X86_FEATURE_MWAIT,
+						   vcpu->arch.ia32_misc_enable_msr &
+						   MSR_IA32_MISC_ENABLE_MWAIT);
 	}
 
 	best = kvm_find_cpuid_entry_index(vcpu, 7, 0);
 	if (best)
-		cpuid_entry_change(best, X86_FEATURE_OSPKE,
-				   kvm_is_cr4_bit_set(vcpu, X86_CR4_PKE));
+		kvm_update_feature_runtime(vcpu, best, X86_FEATURE_OSPKE,
+					   kvm_is_cr4_bit_set(vcpu, X86_CR4_PKE));
+
 
 	best = kvm_find_cpuid_entry_index(vcpu, 0xD, 0);
 	if (best)
-- 
2.47.0.338.g60cca15819-goog

