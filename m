Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E32199234
	for <linux-sgx@vger.kernel.org>; Thu, 28 Nov 2024 01:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732757708; cv=none; b=sg5Hm4Fq0EhqyU8vEg2z5z6lrokXDXGSaxUeVoQ6hnKyxNJO5IhWLK03NA7weoVrfq0HF5fZGLMAxrnbWPqZ1KKbM2GH1aXFsVY6Vd8ZYQFdtiaS/adWOLRA5WRKOC+JXRfffZCJgYQnFPmW8CSee4vtR+s5iPmwLVWWS5H9GDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732757708; c=relaxed/simple;
	bh=2Q1kVrEyCnyB3DjsUNAWh7he2DHh+lSAwEDhcvm0RHc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pMBp80tG/j49y36C1ibuvS9zb04Cc6TNagy/jLDjB8twl0kBpYlvGtUtahMs8BcHoMaYhmddYwviKgHBW3LuRW5m8uf2x2jBnRPpeN16np8XExNvd220mPqe+hK93WdIItMpytuQ4GV4ujRgvdOwlhv8n8QXRBAIgQFUYev788w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kj57NTTt; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kj57NTTt"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7fbde8970d9so296424a12.0
        for <linux-sgx@vger.kernel.org>; Wed, 27 Nov 2024 17:35:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732757707; x=1733362507; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=sl6X5b0bxyRkVbn+G689ru052xqCH1IMhImemP9sZRw=;
        b=kj57NTTtd3xPYX+QUmYbH2dI45xf3uqtFUw1jR6NPFywnkEB7qMJbZCvFH/gqRjTIR
         uudzROw7hTQlYvVQcm03ZLm8SN+nQIgOyjo7xoNCxj5qJOgEXynyKGMJWuLwcjkdjPww
         XXEO9WMUWZM2OwQqpy9q6ZKTUtSkAVJYM9zmXoWsLXAxeO6V6zQOfZ1uuGdPfsRnifPv
         +Vci9jN/8DMrwTCf9Aiw8l5JXkFCquf0HHZZks961rla/B3qX2IRTn/niNp0RlrnVKlN
         J0ETxJLV6VvSUGRrW7bmFkspJwhqmeIZBjHqm9j+zeEisnYeVtpcnF5xX92Kkp66vpnf
         qheA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732757707; x=1733362507;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sl6X5b0bxyRkVbn+G689ru052xqCH1IMhImemP9sZRw=;
        b=GBC+VvIrEgzYj0D5vKnTKY+BFWDLQB7gDPn8ELRm8dg5Liz9jd1oVcI5p2AuKPJWdp
         m7A8GSjCD4bKnh7j9RxLydBAKOU7JOaI2KmDUhzeNva399UCI5xLAgHiLXCuIew42bym
         4qhXZIPGK+WxaSJ0+Bs6L4tMzT9HcuZ1HHVMx+ZamMU08dcLa56karaa8nFCuMsY7qxA
         axmpdnbuLNPO2iEYst1dGpF4l22ZESOaw2UHPFT8sLHvp8c84M9ROKfXVp4Faflzr2+p
         9IFcadL8fdMICzLC4gZ6EBT0lK3Pm5wYbjNKd0GYnw1FJEeoKmYKDw5O46EmJxtNJVZf
         qadw==
X-Forwarded-Encrypted: i=1; AJvYcCUOvyjvIL3QG9SFsw26KG3IrRuz1BpogMA/2zt6VTJQRZi6oYMIcDwsXB6dDWLpR9/R5qzIZzpp8Ds=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywc/tIoDhGEj1NAcItUKRIMDwODQZzf8giAxet39nBL3rEpii//
	w1tA5O2TBoORInHJtmfUZHA0m7H2LS+ERqspefoOGD9dGxtlhsn8KTtzpmRZB4gzyTjpasQm43P
	9qg==
X-Google-Smtp-Source: AGHT+IFDjKtecjGMKpdFToT37L1qnVgC6GL8sx1BJdKN0jqOJokIXOGEzKpUpCWGpaEd4aGPKFnXmjp1aMI=
X-Received: from pgg4.prod.google.com ([2002:a05:6a02:4d84:b0:7fc:2241:1b32])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:2583:b0:1e0:c8d9:3382
 with SMTP id adf61e73a8af0-1e0e0b8c5d1mr8141450637.45.1732757706780; Wed, 27
 Nov 2024 17:35:06 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 17:33:47 -0800
In-Reply-To: <20241128013424.4096668-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128013424.4096668-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128013424.4096668-21-seanjc@google.com>
Subject: [PATCH v3 20/57] KVM: x86: Do reverse CPUID sanity checks in __feature_leaf()
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

Do the compile-time sanity checks on reverse_cpuid in __feature_leaf() so
that higher level APIs don't need to "manually" perform the sanity checks.

No functional change intended.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.h         | 3 ---
 arch/x86/kvm/reverse_cpuid.h | 6 ++++--
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index d4ece5db7b46..5d0fe3793d75 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -179,7 +179,6 @@ static __always_inline void kvm_cpu_cap_clear(unsigned int x86_feature)
 {
 	unsigned int x86_leaf = __feature_leaf(x86_feature);
 
-	reverse_cpuid_check(x86_leaf);
 	kvm_cpu_caps[x86_leaf] &= ~__feature_bit(x86_feature);
 }
 
@@ -187,7 +186,6 @@ static __always_inline void kvm_cpu_cap_set(unsigned int x86_feature)
 {
 	unsigned int x86_leaf = __feature_leaf(x86_feature);
 
-	reverse_cpuid_check(x86_leaf);
 	kvm_cpu_caps[x86_leaf] |= __feature_bit(x86_feature);
 }
 
@@ -195,7 +193,6 @@ static __always_inline u32 kvm_cpu_cap_get(unsigned int x86_feature)
 {
 	unsigned int x86_leaf = __feature_leaf(x86_feature);
 
-	reverse_cpuid_check(x86_leaf);
 	return kvm_cpu_caps[x86_leaf] & __feature_bit(x86_feature);
 }
 
diff --git a/arch/x86/kvm/reverse_cpuid.h b/arch/x86/kvm/reverse_cpuid.h
index e46220ece83c..1d2db9d529ff 100644
--- a/arch/x86/kvm/reverse_cpuid.h
+++ b/arch/x86/kvm/reverse_cpuid.h
@@ -145,7 +145,10 @@ static __always_inline u32 __feature_translate(int x86_feature)
 
 static __always_inline u32 __feature_leaf(int x86_feature)
 {
-	return __feature_translate(x86_feature) / 32;
+	u32 x86_leaf = __feature_translate(x86_feature) / 32;
+
+	reverse_cpuid_check(x86_leaf);
+	return x86_leaf;
 }
 
 /*
@@ -168,7 +171,6 @@ static __always_inline struct cpuid_reg x86_feature_cpuid(unsigned int x86_featu
 {
 	unsigned int x86_leaf = __feature_leaf(x86_feature);
 
-	reverse_cpuid_check(x86_leaf);
 	return reverse_cpuid[x86_leaf];
 }
 
-- 
2.47.0.338.g60cca15819-goog

