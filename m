Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A905F1CC896
	for <linux-sgx@vger.kernel.org>; Thu, 28 Nov 2024 01:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732757756; cv=none; b=JT76c7U+FnKXU/l5BZG52qF4sJpJwNFzdYNn2QZliUHWig4jQXwUL1T7aUl6L5LuW380aeG1brXa5LdHAosAnvH5LB1twKFQSfcQ+NUZRMmdCitnMj/lNGe76aJ+/3jFdrARsn0/cZIKod6Q/zi/zSbaU3ECf8V0pRvDrs3I9wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732757756; c=relaxed/simple;
	bh=abV0OpWUpY5+yBAXoMXrcOmrPhWTKywAMUS8bJBf5tc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JdfxlqBw/Qglfrrva7g5hhtTbgmGWUK8yFv76eNFOk8SqeY1v/Forjr/5iphoEjoOVDImTmkb6FLow70rY7HW/Ph+x8P5nvuvToL1pKb92RNJ3B7SjDqyMZV3ZHT4PubZjwTLcKcXudNv52qdhURrGavLsZO+5RSZXth6S5upWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OpjOdGjB; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OpjOdGjB"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-72467cd273dso1082448b3a.1
        for <linux-sgx@vger.kernel.org>; Wed, 27 Nov 2024 17:35:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732757754; x=1733362554; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=em2i6mSq/FSOswh2gZbHOe2+rj1ku/tF6R6GVHGz2Ss=;
        b=OpjOdGjBZgQj92uf/LUH4riGU4XxinF+ywWP4cNaFtc8UdEdQ3DjuAr67b4StyHrvK
         F6WF/7+UNJT2bH6eiT7J+caS5TgThNGs4b7T+5KT60Vx7qbAIOMIyOAiKpJFD84eFirp
         BunQJLh2/t5rCJPWyHW5L9Y2+eQkBk1qohjqYuL4FgZNhUGajZKtTi7GkGeg+N08Vo+o
         iLVHZfCKeOSqXCiJlPvJqzkP4bMrUKtlrXkSNcGEAIbNfV4v9mdYkTc/g+Z4JAW8/0lV
         JvcVbvNJEjwQICJwljaUZjZQ715j36OJl0xdV2Lc//QgpRomH8JLayb6sGb70OxOANmN
         72HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732757754; x=1733362554;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=em2i6mSq/FSOswh2gZbHOe2+rj1ku/tF6R6GVHGz2Ss=;
        b=YBXn2dyr0PBqMqm/rE+DqSNsmi9NaQ/OKJy8kLHaGGd6nKUKORRNCcgSV+3MsEpAGn
         5kXbIBdAegs3es/GMsR2O+gVj6rZ5C+wKQfPNtyn5zhA3n31BxWT6hViLONxdXomJS/k
         P2Ox40viijtrj1ITLrLDvLFYFuLgfTkEKanVCelRrYmUnmJ5ssjLBBMfwcpzlR5mo48Y
         eoalJSAaZJyCuhvmB3+jSGEav7c6bmV2VCMBu1Aduezs3SlVmb+y5l+hyxslZEaSNMUa
         HHEnv9mActP+bSnJ4OonZuAxRRklJok7DUB2WtzXg9tMRV+Zf8kR+MDE6yOapnIBbvij
         VCkA==
X-Forwarded-Encrypted: i=1; AJvYcCUb4HIPcaU6rleKKGXV4ANHbf4yW6UMk27SSo4RAnLdPyPSO0cEjqbLfnhCt0xSkye5h/v3Q4keWKk=@vger.kernel.org
X-Gm-Message-State: AOJu0YwHdZt0AkmXO58HJg5ZF4kdJAVA/fTVifFlT8gbHItsh95LBSA0
	3cj6WRhRZQZMi6PZ2TkI3KUaKNt0raPm6Rl/HjlcaISoEUstAcTw61Cfd5aC6bp39XVE7qIZl/v
	tCQ==
X-Google-Smtp-Source: AGHT+IGGOzmJ2vI9VhH/NTQdD7nksABJ8Xh80dxB6NRhbDSMvvAWKI3TKxcmA3cvwGD6/f7BGRgkpyNTX64=
X-Received: from pjbpb1.prod.google.com ([2002:a17:90b:3c01:b0:2e2:9021:cf53])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4d0d:b0:2ea:5fed:4a32
 with SMTP id 98e67ed59e1d1-2ee25af2e0bmr2429796a91.11.1732757754067; Wed, 27
 Nov 2024 17:35:54 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 17:34:14 -0800
In-Reply-To: <20241128013424.4096668-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128013424.4096668-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128013424.4096668-48-seanjc@google.com>
Subject: [PATCH v3 47/57] KVM: x86: Update OS{XSAVE,PKE} bits in guest CPUID
 irrespective of host support
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

When making runtime CPUID updates, change OSXSAVE and OSPKE even if their
respective base features (XSAVE, PKU) are not supported by the host.  KVM
already incorporates host support in the vCPU's effective reserved CR4 bits.
I.e. OSXSAVE and OSPKE can be set if and only if the host supports them.

And conversely, since KVM's ABI is that KVM owns the dynamic OS feature
flags, clearing them when they obviously aren't supported and thus can't
be enabled is arguably a fix.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 7481926a0291..be3357a408d4 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -276,10 +276,8 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
 
 	best = kvm_find_cpuid_entry(vcpu, 1);
 	if (best) {
-		/* Update OSXSAVE bit */
-		if (boot_cpu_has(X86_FEATURE_XSAVE))
-			cpuid_entry_change(best, X86_FEATURE_OSXSAVE,
-					   kvm_is_cr4_bit_set(vcpu, X86_CR4_OSXSAVE));
+		cpuid_entry_change(best, X86_FEATURE_OSXSAVE,
+				   kvm_is_cr4_bit_set(vcpu, X86_CR4_OSXSAVE));
 
 		cpuid_entry_change(best, X86_FEATURE_APIC,
 			   vcpu->arch.apic_base & MSR_IA32_APICBASE_ENABLE);
@@ -291,7 +289,7 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
 	}
 
 	best = kvm_find_cpuid_entry_index(vcpu, 7, 0);
-	if (best && boot_cpu_has(X86_FEATURE_PKU))
+	if (best)
 		cpuid_entry_change(best, X86_FEATURE_OSPKE,
 				   kvm_is_cr4_bit_set(vcpu, X86_CR4_PKE));
 
-- 
2.47.0.338.g60cca15819-goog

