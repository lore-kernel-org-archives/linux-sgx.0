Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 486561494B5
	for <linux-sgx@vger.kernel.org>; Thu, 28 Nov 2024 01:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732757691; cv=none; b=nSI5lfsF7HMw5P9BWiZPx55wdSJLifR49AVkUaosypB1OQy5KRrQKV17KdnBN88ktuD0phvHuGOt8XJlVMSriJWAPtvDRks33PHQQNYlOUG0l+Wt7kex0KDBRYRvbUIMVtPJFfsw2LpVDM0VIqO4KeoVV2ZCp/yGWU0Sk3OrUkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732757691; c=relaxed/simple;
	bh=XUJ82Rtg0dvNzftBjBgZdlUMYIOHxk/MRQT5EY38WoY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fniT4KF1eoBH9eZp+5NZ+vVayeSEc8h9V/2hVRM7kzb+pA+3ylyswmw68M/uWfzPMxc2/qFFJNSAZp7NhoYuiNQTgT/zOL49KE0wgl7p81dNAYQ2SvLi1O4gXbpaPUer5DQ0GUZFhdTsuGstcrQX7SLFxJfEAzpytQJ1vGPlM78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Nza6PhcQ; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Nza6PhcQ"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-211fcbd2325so3684475ad.1
        for <linux-sgx@vger.kernel.org>; Wed, 27 Nov 2024 17:34:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732757690; x=1733362490; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=QO1nbKSuw4xAHdvTKrWO+XAcBIQugd+Jc8EgRJlODfQ=;
        b=Nza6PhcQEXmZL+iho4fLgaJ6f3bq6o4OfIMQ6j5MzuOKBJ31D3s86/rzivsYIDNku0
         iFJ9IpnZVmlGgKQu4QIzRPx3xCo4W3BzvB0RO8c6nmSPA7vrtyE5JWbyJozNUNTbg8xT
         KWuXNLbD0SokMV/EZ3WVpMwDZ6SgJzCyxmap3SsQeaRiyjMMUopnhIBWlvJ8o3tgybUn
         WCsITdV8l436hjOQIbo87xEObU5ertnnfwlB6Rd+6jywJ/siq2wean0YlmHt6YaKQbX2
         u+2hDn/cQPkCAwjyp+3YqhIf3mBN9pQ+lZUHP13KRZnGagH0O3vpzvVgBPvW36aNK2fO
         IRIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732757690; x=1733362490;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QO1nbKSuw4xAHdvTKrWO+XAcBIQugd+Jc8EgRJlODfQ=;
        b=TSiKYVZfkO5LSMGbmKBMqRVD0Ap5PZ1rTpbyRVhSUJz/So1Dqjxd19XFR4sPDWNyvo
         CLAH60fCM6oh+ZAk3J0/mgxrAobL4R0dMu+fuVVthIKo8PfBppyRV3BStkodg5nhxKfd
         7BUlJfqCJ2nA9BvTDpWlGR1rF9yzy1HpMaGE+CgAy/w2E+lhC1TQUm35LuEOIUP6cw5Y
         MHyNg3bv/a2hIiA1MpaGWIgWY0304OuZBqOdsqme54QRx//XTQtWbBLokKwdDGsCRCYU
         6kBv9nNNOVt7hW17K4NMd6ljgn20C/fPHfg7n0VwZzIp+PTXM2+6JbCaeiN4S54kHA+E
         6wEw==
X-Forwarded-Encrypted: i=1; AJvYcCUiLtGgubPuZqq81/gIaE693jT1cE/ttf6otnAvpivo7b2iD/ISmibhxSW0Di2MkJcsOzOgXLbxbSg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyurHJuxzkLNdP/y+/fA5PPRtG9GTtuF1Sdn4iERBDEnfTy1WgS
	ulaXZDy1zoiVP39Msa0vXrMu/BWaF/vGb/Ijx4+Pi9eIENQghF27raxMKsYSaGZs4TevUjYArpX
	n1Q==
X-Google-Smtp-Source: AGHT+IFql/TwOfNwT9CVZ0WNulnEpsE+uGEyzsfAGgYdcC+q97T9HfG6pl6mZwpvJ0LoRod86oyPOYL8AVc=
X-Received: from pllb7.prod.google.com ([2002:a17:902:e947:b0:212:4557:e89b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d50f:b0:1fa:1dd8:947a
 with SMTP id d9443c01a7336-21501d58ac1mr60024385ad.46.1732757689708; Wed, 27
 Nov 2024 17:34:49 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 17:33:37 -0800
In-Reply-To: <20241128013424.4096668-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128013424.4096668-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128013424.4096668-11-seanjc@google.com>
Subject: [PATCH v3 10/57] KVM: x86: Move __kvm_is_valid_cr4() definition to x86.h
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

Let vendor code inline __kvm_is_valid_cr4() now x86.c's cr4_reserved_bits
no longer exists, as keeping cr4_reserved_bits local to x86.c was the only
reason for "hiding" the definition of __kvm_is_valid_cr4().

No functional change intended.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/x86.c | 9 ---------
 arch/x86/kvm/x86.h | 6 +++++-
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5288d53fef5c..5c6ade1f976e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1281,15 +1281,6 @@ int kvm_emulate_xsetbv(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_emulate_xsetbv);
 
-bool __kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
-{
-	if (cr4 & vcpu->arch.cr4_guest_rsvd_bits)
-		return false;
-
-	return true;
-}
-EXPORT_SYMBOL_GPL(__kvm_is_valid_cr4);
-
 static bool kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 {
 	return __kvm_is_valid_cr4(vcpu, cr4) &&
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index ec623d23d13d..7a87c5fc57f1 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -550,7 +550,6 @@ static inline void kvm_machine_check(void)
 void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu);
 void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu);
 int kvm_spec_ctrl_test_value(u64 value);
-bool __kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4);
 int kvm_handle_memory_failure(struct kvm_vcpu *vcpu, int r,
 			      struct x86_exception *e);
 int kvm_handle_invpcid(struct kvm_vcpu *vcpu, unsigned long type, gva_t gva);
@@ -577,6 +576,11 @@ enum kvm_msr_access {
 #define  KVM_MSR_RET_UNSUPPORTED	2
 #define  KVM_MSR_RET_FILTERED		3
 
+static inline bool __kvm_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
+{
+	return !(cr4 & vcpu->arch.cr4_guest_rsvd_bits);
+}
+
 #define __cr4_reserved_bits(__cpu_has, __c)             \
 ({                                                      \
 	u64 __reserved_bits = CR4_RESERVED_BITS;        \
-- 
2.47.0.338.g60cca15819-goog

