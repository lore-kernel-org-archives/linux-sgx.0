Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 463051AF0A0
	for <linux-sgx@vger.kernel.org>; Thu, 28 Nov 2024 01:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732757725; cv=none; b=iSnTyZsDyslitoxIn72kf57ZvzcTHAfGpx9DGWDxR6zPxeoZ3N21CJLgPrQ8695TFt6XmD3lOBxxcF4rufyuFGqD0CLpVBwznsBAFBjkzvQmmLub4QgLjx4niI27bWEKtsArR3+4yZG5+4qUm2JCjVz+UR0pGxdcDVx/Po9zU3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732757725; c=relaxed/simple;
	bh=iparbKkxMUF353Y34z4B10W301N08LqLmil1yvKSLkg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=mdGNVddpcPfv+ptEzarJhQkNh3fcaRElOuNGOdy14uaqeaAwyMq4mG8wjwzPY5UxOncSbQaWuvUas/XdZINpXCRYM3FW0S+pMxjqlL/R43n87ZJ1hz+hHHBluRC/uc/8afJo1Z/w5wXTZ18/IuJVojzIZtsr3XFDwD0kJODpbkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IOiuxo7N; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IOiuxo7N"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ea3512feaeso444151a91.2
        for <linux-sgx@vger.kernel.org>; Wed, 27 Nov 2024 17:35:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732757723; x=1733362523; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=NZkn7uVX+fUFjolFig2q49G57BV4Dyx1JGLX/2AmIPM=;
        b=IOiuxo7NHB2mB4d7a+ycQxEb+dSKtToAGYncji8jgMfdMMlT17y3Ucg03qhJPymbka
         P9/Ii8q7WvMD1SG74dzuI9chLAflu3S0EBQjyk/OYIg95/Xgw4P8DHdTdHrHimSpE7Lf
         HiUrU+ekME8HtDo6+izv+jAgJO+hsttjHzP8MR6uQh6xipQ8ByZz4H0BMrihLWMqJsos
         eloD3UkUQYizf12KE7dVB5zBoOstFCB7wY82QjvU47ZHaHapGxiLpFfUVjtbbKCgE1rU
         2QyP9owM0IhowW/kiy5d86f9P3UysthYKs9PDaexd8RBqDscxmPk5RqXqrGvJ+KN8WfT
         +OgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732757723; x=1733362523;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NZkn7uVX+fUFjolFig2q49G57BV4Dyx1JGLX/2AmIPM=;
        b=VpgSMJI8y/LDfUWwNJ90uW15QESPwJJnasV3bXbrql3JcoHGHQT5ph10aVpoxCdqG5
         SjxI7bPZU9nl8TXUJDNCdZgMnzV5Uug0rm8zAtQ0e+RHIqhVLClR69Jjqr6vVXu4tkg7
         4D6xLuAeK7TAQMy1bZllVBNEA4AmFPZuYZFQzrMuFh5RZ9sqAhTo3uG/50fyGecul6vC
         /3V9kOtMqe58fXs0DtR1Sy+64U2T+P9cGQyxKFtEKv7yv0SHIkYjgw4hdVg++GsW1EiR
         x9TNHKLvS6dSK75EiFc4lrYEF+fckW38mQhvX+sfvm6GaWuRf5MjH8jb1QGTnVjshm9C
         Ss9g==
X-Forwarded-Encrypted: i=1; AJvYcCV9hyaEmCn4X9jTngIHJTW6xX0tEAEIGjdiIoX5v8PbQQ3P4domGFVZmzFR+reNFj4VRqwp2xgXCAk=@vger.kernel.org
X-Gm-Message-State: AOJu0YygWOtAcAUeHB1o1PN4d+6P9MuY5v44NClbycDmTxhXw67k54yF
	DE+jAGnnwFHlf0HBIOI+YMH++zboCF4QF1SoLJZAKczj59oxFX7esSQRTob+lcSTq23l9/fP7F6
	7Tg==
X-Google-Smtp-Source: AGHT+IGI8ND2VVwlZdDGAoDzV/xv9Z/3t6LJP6qC1wVUcOLzFmIaXT+GVqHfCqi9L4txvklzgu6maR67WTs=
X-Received: from pjbpq13.prod.google.com ([2002:a17:90b:3d8d:b0:2ea:3a1b:f493])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1d0e:b0:2ea:61ac:a50b
 with SMTP id 98e67ed59e1d1-2ee097e4795mr5918633a91.31.1732757722708; Wed, 27
 Nov 2024 17:35:22 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 17:33:56 -0800
In-Reply-To: <20241128013424.4096668-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128013424.4096668-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128013424.4096668-30-seanjc@google.com>
Subject: [PATCH v3 29/57] KVM: x86: Add a macro to init CPUID features that
 ignore host kernel support
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

Add a macro for use in kvm_set_cpu_caps() to automagically initialize
features that KVM wants to support based solely on the CPU's capabilities,
e.g. KVM advertises LA57 support if it's available in hardware, even if
the host kernel isn't utilizing 57-bit virtual addresses.

Track a features that are passed through to userspace (from hardware) in
a local variable, and simply OR them in *after* adjusting the capabilities
that came from boot_cpu_data.

Note, eliminating the open-coded call to cpuid_ecx() also fixes a largely
benign bug where KVM could incorrectly report LA57 support on Intel CPUs
whose max supported CPUID is less than 7, i.e. if the max supported leaf
(<7) happened to have bit 16 set.  In practice, barring a funky virtual
machine setup, the bug is benign as all known CPUs that support VMX also
support leaf 7.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index c9a8513dbc30..9bf324aa5fae 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -610,12 +610,14 @@ static __always_inline u32 raw_cpuid_get(struct cpuid_reg cpuid)
 do {									\
 	const struct cpuid_reg cpuid = x86_feature_cpuid(leaf * 32);	\
 	const u32 __maybe_unused kvm_cpu_cap_init_in_progress = leaf;	\
+	u32 kvm_cpu_cap_passthrough = 0;				\
 									\
 	if (leaf < NCAPINTS)						\
 		kvm_cpu_caps[leaf] &= (mask);				\
 	else								\
 		kvm_cpu_caps[leaf] = (mask);				\
 									\
+	kvm_cpu_caps[leaf] |= kvm_cpu_cap_passthrough;			\
 	kvm_cpu_caps[leaf] &= raw_cpuid_get(cpuid);			\
 } while (0)
 
@@ -652,6 +654,18 @@ do {									\
 	(IS_ENABLED(CONFIG_X86_64) ? F(name) : 0);		\
 })
 
+/*
+ * Passthrough Feature - For features that KVM supports based purely on raw
+ * hardware CPUID, i.e. that KVM virtualizes even if the host kernel doesn't
+ * use the feature.  Simply force set the feature in KVM's capabilities, raw
+ * CPUID support will be factored in by kvm_cpu_cap_mask().
+ */
+#define PASSTHROUGH_F(name)					\
+({								\
+	kvm_cpu_cap_passthrough |= F(name);			\
+	F(name);						\
+})
+
 /*
  * Aliased Features - For features in 0x8000_0001.EDX that are duplicates of
  * identical 0x1.EDX features, and thus are aliased from 0x1 to 0x8000_0001.
@@ -777,7 +791,7 @@ void kvm_set_cpu_caps(void)
 
 	kvm_cpu_cap_init(CPUID_7_ECX,
 		F(AVX512VBMI) |
-		F(LA57) |
+		PASSTHROUGH_F(LA57) |
 		F(PKU) |
 		0 /*OSPKE*/ |
 		F(RDPID) |
@@ -796,9 +810,6 @@ void kvm_set_cpu_caps(void)
 		F(SGX_LC) |
 		F(BUS_LOCK_DETECT)
 	);
-	/* Set LA57 based on hardware capability. */
-	if (cpuid_ecx(7) & feature_bit(LA57))
-		kvm_cpu_cap_set(X86_FEATURE_LA57);
 
 	/*
 	 * PKU not yet implemented for shadow paging and requires OSPKE
@@ -1076,6 +1087,7 @@ EXPORT_SYMBOL_GPL(kvm_set_cpu_caps);
 #undef F
 #undef SF
 #undef X86_64_F
+#undef PASSTHROUGH_F
 #undef ALIASED_1_EDX_F
 
 struct kvm_cpuid_array {
-- 
2.47.0.338.g60cca15819-goog

