Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1BFF1CDFDD
	for <linux-sgx@vger.kernel.org>; Thu, 28 Nov 2024 01:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732757763; cv=none; b=jAKSCFvixcvtHEdueoxHfNhHMBu9i0pPtFPfVq/7roOPFyBruafW7Ulx+j3nCOPHo5BCt5yo6DdPHLuhh7Y/7IXNHNqjEqwoSMgMF2bGeqzT5ySa3vZcSAObG64ptrQKvUiIPnX0rcNvzUqRRdUB0hAHDlReOC1lLkjhN7o8iTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732757763; c=relaxed/simple;
	bh=UGQtKvn16ZV/4C8CCLUFGRgLWpqSOYFX6Ot6ILNhdrg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XuFnXCTCgiy4J1xnJjDM9LzrEduKEVSUNIL6CxSyMXwAqqspQ5YztoFZJaDpczN+mpabxOF2oCIUJV5L5OwuHsD5LWX1mHmRn+ysxx3Q9GjyU8XipQdx7Epz5oyj1RNK5/3AFydM8UmC1gUEH0/EF53U5IrhxGhU3rlmoX/Yhkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BjBrcJ10; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BjBrcJ10"
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7c6b192a39bso213653a12.2
        for <linux-sgx@vger.kernel.org>; Wed, 27 Nov 2024 17:36:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732757761; x=1733362561; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=taMQEzcRa7YqlC/xz4BvUNJGPN3JpmMrop9avvyNBPs=;
        b=BjBrcJ10RV6dYNRXJR4KfiZ0jrm6gdYfUS3JYuLp+QQfvY8IYol1zYYxTA/K5L0v2Q
         jfD66CiWIfe7UZQ8bIc3jpBFkbPkDpZAkcI+9LV1J03jvG9RZW9S8OibuycLKxzRG7ns
         ipqeDKhgWbKYSl/YhH7fZYGhmojoYhseK8aTLdxc7zEXaz7w0JH1nobhxX3O08Fsfdie
         vP6aXf+Agy4L+zrZeulWfXlc0k4v7JNWTYK0fGo6EBAGG2iGk8ji4jh9F03hObfHNE49
         Of8iUrvsKL8YsY4FKkbk3yDJcqDInCcJjnHXyMQi6fFuOj8p+qye7thMvsyU8bYoRy7h
         Lddw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732757761; x=1733362561;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=taMQEzcRa7YqlC/xz4BvUNJGPN3JpmMrop9avvyNBPs=;
        b=l5cR2qIJ5Kvp10oXwEGTRhzsO77RnomeUfP9o9N2DUVVLtUYFyObVY1lZUvP/5+iTl
         kSrX1odQ5K7g25cG7iXMJgWKYDZfZn5ZK9cZJ5a0weKdhMxmhlW+XeAao2wHu4mVqHmm
         LL2wlOnxN36bDO5Z+DvN9SOMMFIA8O89Ag77y9KLS10ok8y6+5l5DQccTD1M6FpCgmr7
         7WTDOHCQhzw3duOmeQW5uXadcUW8s+tKMCQ3R8h4yZsOK/g6fFtkxxnSi29DBKLT5Yqb
         fYZp5M3zvv3iTTmYPRC5jz1cvQ73HeHgICXHuVHSnZlccfIwXPR6MRuY9XH+e2iSjNLp
         Xdng==
X-Forwarded-Encrypted: i=1; AJvYcCWu8WdqqwMHVdm585Mt5qTKFRRZ4RmpinPOY4z2p/q3MncWU7EO18esoQV0H8uy6jKoa6755JA5CQw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxPvbnkrAgwuCzZ2bcbPPAAMzXhzmMKdWph1UG2h3r9snFTzqY8
	7bzulZjwYy+Bx107mpV7tS1CVQme8ano62hPB9Z4u1pS7Sxv3BopC4ItkUjZCKCZHGtdx2hs/67
	H4Q==
X-Google-Smtp-Source: AGHT+IFIVvp2w9dKtTRkfao6OgNQxbqBRKc/t7Il86/MlJOVJC006+/HRidtUDBBvGNaX9G3lBburcuABwE=
X-Received: from pjtd1.prod.google.com ([2002:a17:90b:41:b0:2ed:f958:16e6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:2583:b0:1e0:dd4d:1de4
 with SMTP id adf61e73a8af0-1e0e0b3688emr9046630637.23.1732757761302; Wed, 27
 Nov 2024 17:36:01 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 17:34:18 -0800
In-Reply-To: <20241128013424.4096668-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128013424.4096668-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128013424.4096668-52-seanjc@google.com>
Subject: [PATCH v3 51/57] KVM: x86: Drop superfluous host XSAVE check when
 adjusting guest XSAVES caps
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

Drop the manual boot_cpu_has() checks on XSAVE when adjusting the guest's
XSAVES capabilities now that guest cpu_caps incorporates KVM's support.
The guest's cpu_caps are initialized from kvm_cpu_caps, which are in turn
initialized from boot_cpu_data, i.e. checking guest_cpu_cap_has() also
checks host/KVM capabilities (which is the entire point of cpu_caps).

Cc: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 1 -
 arch/x86/kvm/vmx/vmx.c | 3 +--
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 734b3ca40311..07911ddf1efe 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4402,7 +4402,6 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	 * the guest read/write access to the host's XSS.
 	 */
 	guest_cpu_cap_change(vcpu, X86_FEATURE_XSAVES,
-			     boot_cpu_has(X86_FEATURE_XSAVE) &&
 			     boot_cpu_has(X86_FEATURE_XSAVES) &&
 			     guest_cpu_cap_has(vcpu, X86_FEATURE_XSAVE));
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6e5edaa2ba3a..cf872d8691b5 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7825,8 +7825,7 @@ void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	 * to the guest.  XSAVES depends on CR4.OSXSAVE, and CR4.OSXSAVE can be
 	 * set if and only if XSAVE is supported.
 	 */
-	if (!boot_cpu_has(X86_FEATURE_XSAVE) ||
-	    !guest_cpu_cap_has(vcpu, X86_FEATURE_XSAVE))
+	if (!guest_cpu_cap_has(vcpu, X86_FEATURE_XSAVE))
 		guest_cpu_cap_clear(vcpu, X86_FEATURE_XSAVES);
 
 	vmx_setup_uret_msrs(vmx);
-- 
2.47.0.338.g60cca15819-goog

