Received: from mail-io1-f74.google.com (mail-io1-f74.google.com [209.85.166.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A74FA1AA1FD
	for <linux-sgx@vger.kernel.org>; Thu, 28 Nov 2024 01:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732757723; cv=none; b=gWulLvxsqR2NMGJWCj4nFuXz97U3l1fd9WmmxVaES48IJBXqaD4KYEOIJ1lmG4ZRknEan6Lsf8qsk467qs38WkdtOfB5tZANnvemzbt8ZPXtyLveJ3vYyVpwtX6pBU5vcxjtg4bg18ftOVKZgqG6F/R3dP+5iJ2Ojoxt8wYMY+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732757723; c=relaxed/simple;
	bh=iscQsFl5jn+TPuQsDMETJQuayZSVqsIm4Yh6FwXeCHc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OAZ+sdjngXvSx8iQoAcsGmxRJl6II6I73J6f2XX8/duOolvB03US1xgfMD0BjA6O6HQXVRRQJeLp+e7QaYvNErZn28gO4ZDTHrFJncxpMlV3kL5sIrr/XO1jqw3AOY5tptZjjaLxjyhZYpHZj5vg6jxHIDgUhQNzeXvhDxFCWxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=arhCNEIQ; arc=none smtp.client-ip=209.85.166.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="arhCNEIQ"
Received: by mail-io1-f74.google.com with SMTP id ca18e2360f4ac-84181157edbso22379339f.2
        for <linux-sgx@vger.kernel.org>; Wed, 27 Nov 2024 17:35:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732757721; x=1733362521; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=or4dfW5NPPoBHl83ebbhI2Kl40dJajWBKajgnr00qAI=;
        b=arhCNEIQWJxXVCjhwGHwEZ4aie/XqprDER+g+XnJ1elRm5ZDK2IgX+kBJZHMB1fVLi
         gjvUVpUhAWCMwhEPdoxkvzJci0SJpwDvIr1Ybn5NRNsPn1vwOI5f42lNGFUMMSW/AVjz
         vMvu/FOrDK1dGhU7NKMAI9alEf7qxLGY4eJTsSdMTULr2K1hjJGDp8xZGUor8sHKgv3j
         1bG3Tc+SqowgCBEC3FnJqmQ8sy2pMUbq9SvjpQxcfqJu4oJN6c8eaWEgaobWLG3jm5QI
         5qy2XsLpcXIkUP6SvIHiJcyMtjjuUJNzQehfU+/flipcYR9HH/NbS3sahHwhbq0inBKK
         nR4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732757721; x=1733362521;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=or4dfW5NPPoBHl83ebbhI2Kl40dJajWBKajgnr00qAI=;
        b=UxNBgmPJrS5OHXuOa9wsOz99zBdBF5+z89rQVxNr3J3XtXmgnYE1XL5uKZj7BfQy+A
         Dkx5M+icjN9KWPZoDdi2N4wpCpr9v6WxxAv7C6UCznTtV4r7avo1UPwCj+ts5NTw6Upc
         B8uQ/qzxwZeyjjCxSGCcIYCqXnMmlXDryB8fjjnJZIqXacMls6oXuvN7sIe5NAhFGm7+
         /r3pAhQLnMl82qH6BE6k9sHMpXp/fT2V0kmNKWiWpWA2twqEdHGeENkAO2KdYc1FADfr
         fDxFun7J71qobwga403uT8irGuWWdnTJ5DfmSx/Zq3lnBuVG2nmvne9ao+kvVR+0O2KB
         PQEg==
X-Forwarded-Encrypted: i=1; AJvYcCUw2bBcS4FJ0ZUfa4a8XYmqx/pQf0kmPiLaKIEHi9mRnKgCn6LKZksv1JsDwtsavDX/2h/h/ukC5kc=@vger.kernel.org
X-Gm-Message-State: AOJu0YxqT2eqmXI+p5FgrQrLVUm3z1Hv0pfV9WXXSpQ4D9KjPHzT41Iw
	ThVmFQ0k2/zo73VaiDcF1cwPo0NPw3wzcGcYjnT4cFnL5/BvNi//N8niS+D5kQ9twJTmnPFyK9b
	eHQ==
X-Google-Smtp-Source: AGHT+IHqvArLP/DTLOy9MpelaMy9pJau/26PUrYe6mAmbmDCvrOFJgFkHYoGtDP5b19XPXc68OHJeJQvhkI=
X-Received: from pgbdl2.prod.google.com ([2002:a05:6a02:d02:b0:7fc:219e:bdd9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6e02:20e3:b0:3a7:87f2:b010
 with SMTP id e9e14a558f8ab-3a7c552574bmr59060575ab.5.1732757720946; Wed, 27
 Nov 2024 17:35:20 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 17:33:55 -0800
In-Reply-To: <20241128013424.4096668-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128013424.4096668-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128013424.4096668-29-seanjc@google.com>
Subject: [PATCH v3 28/57] KVM: x86: Harden CPU capabilities processing against
 out-of-scope features
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

Add compile-time assertions to verify that usage of F() and friends in
kvm_set_cpu_caps() is scoped to the correct CPUID word, e.g. to detect
bugs where KVM passes a feature bit from word X into word y.

Add a one-off assertion in the aliased feature macro to ensure that only
word 0x8000_0001.EDX aliased the features defined for 0x1.EDX.

To do so, convert kvm_cpu_cap_init() to a macro and have it define a
local variable to track which CPUID word is being initialized that is
then used to validate usage of F() (all of the inputs are compile-time
constants and thus can be fed into BUILD_BUG_ON()).

Redefine KVM_VALIDATE_CPU_CAP_USAGE after kvm_set_cpu_caps() to be a nop
so that F() can be used in other flows that aren't as easily hardened,
e.g. __do_cpuid_func_emulated() and __do_cpuid_func().

Invoke KVM_VALIDATE_CPU_CAP_USAGE() in SF() and X86_64_F() to ensure the
validation occurs, e.g. if the usage of F() is completely compiled out
(which shouldn't happen for boot_cpu_has(), but could happen in the future,
e.g. if KVM were to use cpu_feature_enabled()).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 51 ++++++++++++++++++++++++++++++--------------
 1 file changed, 35 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index efff83da3df3..c9a8513dbc30 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -602,35 +602,53 @@ static __always_inline u32 raw_cpuid_get(struct cpuid_reg cpuid)
 	return *__cpuid_entry_get_reg(&entry, cpuid.reg);
 }
 
-static __always_inline void kvm_cpu_cap_init(u32 leaf, u32 mask)
-{
-	const struct cpuid_reg cpuid = x86_feature_cpuid(leaf * 32);
+/*
+ * For kernel-defined leafs, mask the boot CPU's pre-populated value.  For KVM-
+ * defined leafs, explicitly set the leaf, as KVM is the one and only authority.
+ */
+#define kvm_cpu_cap_init(leaf, mask)					\
+do {									\
+	const struct cpuid_reg cpuid = x86_feature_cpuid(leaf * 32);	\
+	const u32 __maybe_unused kvm_cpu_cap_init_in_progress = leaf;	\
+									\
+	if (leaf < NCAPINTS)						\
+		kvm_cpu_caps[leaf] &= (mask);				\
+	else								\
+		kvm_cpu_caps[leaf] = (mask);				\
+									\
+	kvm_cpu_caps[leaf] &= raw_cpuid_get(cpuid);			\
+} while (0)
 
-	/*
-	 * For kernel-defined leafs, mask the boot CPU's pre-populated value.
-	 * For KVM-defined leafs, explicitly set the leaf, as KVM is the one
-	 * and only authority.
-	 */
-	if (leaf < NCAPINTS)
-		kvm_cpu_caps[leaf] &= mask;
-	else
-		kvm_cpu_caps[leaf] = mask;
+/*
+ * Assert that the feature bit being declared, e.g. via F(), is in the CPUID
+ * word that's being initialized.  Exempt 0x8000_0001.EDX usage of 0x1.EDX
+ * features, as AMD duplicated many 0x1.EDX features into 0x8000_0001.EDX.
+ */
+#define KVM_VALIDATE_CPU_CAP_USAGE(name)				\
+do {									\
+	u32 __leaf = __feature_leaf(X86_FEATURE_##name);		\
+									\
+	BUILD_BUG_ON(__leaf != kvm_cpu_cap_init_in_progress);		\
+} while (0)
 
-	kvm_cpu_caps[leaf] &= raw_cpuid_get(cpuid);
-}
-
-#define F feature_bit
+#define F(name)							\
+({								\
+	KVM_VALIDATE_CPU_CAP_USAGE(name);			\
+	feature_bit(name);					\
+})
 
 /* Scattered Flag - For features that are scattered by cpufeatures.h. */
 #define SF(name)						\
 ({								\
 	BUILD_BUG_ON(X86_FEATURE_##name >= MAX_CPU_FEATURES);	\
+	KVM_VALIDATE_CPU_CAP_USAGE(name);			\
 	(boot_cpu_has(X86_FEATURE_##name) ? F(name) : 0);	\
 })
 
 /* Features that KVM supports only on 64-bit kernels. */
 #define X86_64_F(name)						\
 ({								\
+	KVM_VALIDATE_CPU_CAP_USAGE(name);			\
 	(IS_ENABLED(CONFIG_X86_64) ? F(name) : 0);		\
 })
 
@@ -641,6 +659,7 @@ static __always_inline void kvm_cpu_cap_init(u32 leaf, u32 mask)
 #define ALIASED_1_EDX_F(name)							\
 ({										\
 	BUILD_BUG_ON(__feature_leaf(X86_FEATURE_##name) != CPUID_1_EDX);	\
+	BUILD_BUG_ON(kvm_cpu_cap_init_in_progress != CPUID_8000_0001_EDX);	\
 	feature_bit(name);							\
 })
 
-- 
2.47.0.338.g60cca15819-goog

