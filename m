Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 505251CBA1F
	for <linux-sgx@vger.kernel.org>; Thu, 28 Nov 2024 01:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732757752; cv=none; b=eFDOa+SWuuTTonSV6cphAPOIFbpolBx+RENrRay+dz/jvRSYPZabR3fbL/MiqhYdY5QMRGPf7gM6nGk5sfwthBF2++og4sNLZxR8lAoGlNXMZRCLDw7tOS+XFsSJvTulpmZ1eJrSAA4Gz/kfhDE2Mkqqw54P8Y+YbspIwsNBH1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732757752; c=relaxed/simple;
	bh=h1o6xxhiRsATofWeY4XS6nAFlEHdA1rnXtEd6OclfKY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uo1oyyUsufDr4NyOzNycsmldlNpB/3Im4mqN9yuTuSQRHmz9MHCrSfHm1b412NKJiwHAgIEIKIbOLVikHL/KzVholuw+Z9nHeObDpJsKNlBZLsumSlzE/e6FzByqrrYSxabfLuWZHfTyBo5rRr/Ik18vh/v8LZrPWJE9nHgNrWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Fy792BiM; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Fy792BiM"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ea42039766so386704a91.3
        for <linux-sgx@vger.kernel.org>; Wed, 27 Nov 2024 17:35:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732757750; x=1733362550; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=vAP/rVhh2wy/ZcCYWV8qgeX607Ed3+jPmDcr0A7awL4=;
        b=Fy792BiMDJZMRmKcdsu0qJrDRwm/llELagsCUuiCMpTpyNN/ldQe9bVND59wtVoWPN
         lSsuB/JV6S5D0N6YppCnutblHAXz2954bTN05ojcTSKHolRjOMHJpp6Lmf1cynRjGuh9
         V13dHcyfulM/BVOD1wqLCfKNknBVhGnUWT7Gi1dBQoiW4KtKgEeLkciSad7FAJs7XBI4
         ZWWU92rKEBxHNdy6FUBer13s16mqNQEKnQOOfhqMG+JzvzJIJXG6tPN+eUyzAqWSQLZf
         dJ0foxooMOq9EwKxHiERutv6ZHwNWe3jsSG2lwWupDQ16rn3gM+MqCPwHz4Zw4kVBORO
         olPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732757750; x=1733362550;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vAP/rVhh2wy/ZcCYWV8qgeX607Ed3+jPmDcr0A7awL4=;
        b=EpAr3pOybcjcKhbAeYdZWoOIWgwvtjGCpBW4pFQ4y1LEr6P4+er2KS6oU3EzYv/hLg
         HXeAS71akdEPDKBQQJBWOhS1XWCSE046C546E2BqpioY9QiMGtz29AJLVUa2qPhwyzj3
         D0MhqyUmpDtTVgDlQ6P9Q54t1Gjpbk1j2WMG/qTAiR556VO3m+74vCcpZ7ihLLBq1CK6
         +Fuf8d8OLeX5kMPaxWoiJCqFS3GOrRaJVsAAeb9iG0jGwGUpX79aZXWwv+sJqR4RbzH4
         Em9QmKtts7G3/WP8f9iMhOZAWwVRcdAktXQr1PVY/9R49zP05SqMy58e52EKvbTdyie4
         M6Qw==
X-Forwarded-Encrypted: i=1; AJvYcCXSv2/DQsPuOcFb/b2i45ZYml8DYvLnmsiEK6zp2y1t4KesBek75e/5f1mCpdZTWDFUYXoGalTGYnQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzyGgXMjD6rSsR7HJOTYfLM9fWJ1pQT5UblSIQzEHCFQ9Imkc/S
	9lGT3D9QbrW2HOsgqPL0xhMB2gsxydIf1o1OmJeA7X9XBFjx3WLeTEyfF+UMMypxZry0TKETemA
	Vsg==
X-Google-Smtp-Source: AGHT+IH4S299/Qme5T+EzZT4W2pDSlPNgfKHdrqsbTxhkEGzPyX9GiJRIR7nFXLTy67066kc1KKNhDPc3pM=
X-Received: from pjuj11.prod.google.com ([2002:a17:90a:d00b:b0:2ea:7d73:294e])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:380c:b0:2ea:c096:b738
 with SMTP id 98e67ed59e1d1-2ee097bafaemr5779058a91.28.1732757750554; Wed, 27
 Nov 2024 17:35:50 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 17:34:12 -0800
In-Reply-To: <20241128013424.4096668-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128013424.4096668-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128013424.4096668-46-seanjc@google.com>
Subject: [PATCH v3 45/57] KVM: x86: Avoid double CPUID lookup when updating
 MWAIT at runtime
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

Move the handling of X86_FEATURE_MWAIT during CPUID runtime updates to
utilize the lookup done for other CPUID.0x1 features.

No functional change intended.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 8015d6b52a69..16cfa839e734 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -283,6 +283,11 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
 
 		cpuid_entry_change(best, X86_FEATURE_APIC,
 			   vcpu->arch.apic_base & MSR_IA32_APICBASE_ENABLE);
+
+		if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT))
+			cpuid_entry_change(best, X86_FEATURE_MWAIT,
+					   vcpu->arch.ia32_misc_enable_msr &
+					   MSR_IA32_MISC_ENABLE_MWAIT);
 	}
 
 	best = kvm_find_cpuid_entry_index(vcpu, 7, 0);
@@ -298,14 +303,6 @@ void kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu)
 	if (best && (cpuid_entry_has(best, X86_FEATURE_XSAVES) ||
 		     cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
 		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
-
-	if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT)) {
-		best = kvm_find_cpuid_entry(vcpu, 0x1);
-		if (best)
-			cpuid_entry_change(best, X86_FEATURE_MWAIT,
-					   vcpu->arch.ia32_misc_enable_msr &
-					   MSR_IA32_MISC_ENABLE_MWAIT);
-	}
 }
 EXPORT_SYMBOL_GPL(kvm_update_cpuid_runtime);
 
-- 
2.47.0.338.g60cca15819-goog

