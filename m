Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92EA61A9B55
	for <linux-sgx@vger.kernel.org>; Thu, 28 Nov 2024 01:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732757720; cv=none; b=rkP/UTVHx1RMu8JQnAmfzgs5ULvw3IaOoZ+wRCM81uwdg81joNWMHWiBBFroWXVYZllIvVYZYMEFXI7cLlFWDDP6aDyY0ZnLvs7+0xZrwAB5yhAFK0bXDOLgW7fiO8j2udj+NP+vx68fXksI4TwLKIM9f5KbYU8SkClaXL9K1PQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732757720; c=relaxed/simple;
	bh=p3CBzhkm6ujU4s52ZTEXum8M/Hl6dyxVOGgM/SCeLYc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RmbfaL/rEk2U3qKtS8YUWoMNV9/C06m0avOvIzYlea0t4QTNV2N3sYr6Q5jBsx3AL7YVRYx+rsyOJdfcwluxxACxfrpNVwucyThVxCoX0Qo+K4kGqCb9UnscwtXI4dc/LJnpcGN4ACnzKmqlubCtWOut7PQAbemb6hsafbLvmvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=us+LS7wO; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="us+LS7wO"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ea2dd29d16so345560a91.0
        for <linux-sgx@vger.kernel.org>; Wed, 27 Nov 2024 17:35:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732757719; x=1733362519; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=gZJBOmAP26+0yF/bEhrb3rRX/4R15M+YqMVdFmFdghQ=;
        b=us+LS7wOwWyTFD1Y0pQmV2cFsogvUO+pXs52ig6hkj2TxrGbDbRkLSiz4x+FwGfFUZ
         p8YD7vnr0zykd8tkovHP5QATnQeRDMiKLBCrNFzE/yV2R4+oGL2oYM7IFv2HGohZnEjJ
         B8b5FGBlkqdQ4tsP7901n3dTcNFm+OdUdw83ziYHnTP03A3PAnRoGBIOOWhoaLrmK+ah
         LV39KBO4yKfpVrhXGv+l2U0hJ8y8fc8CtU6jZqrxFyUm8KMWupq2K1OesGUuZpECkgvZ
         34b/x2bVOXglwYAI4bkdcP5FICf/J5/0DcIGBzPzFY4okLai1aMXPhUnn29gLTzdMSKf
         j4tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732757719; x=1733362519;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gZJBOmAP26+0yF/bEhrb3rRX/4R15M+YqMVdFmFdghQ=;
        b=rEsJG8gBlyhklfA42PuPpy34LVf0GMVdTOK1lcWsODvZb7XNNJqrD+5ip4VPer+6BX
         ZEDgCInIjiFREImxxmFvifvTGDyrK4gXNauYifMm0vdDUuvwFiw/eIM/63xU317IPgKS
         DG04GXQ2n1oGnOnzxmo3B4161DMxr8BU2pvQ7/8pjLK4tPLoxb0v3PJ6MVZF0BM0JcL2
         glta4G75KHsL7NBSgKwYvQKjYzW4PuUy1CPtsqraQWRVfFMw5yPqQSbc5mWiJHTQtxAM
         V8JGMqtDcawuop4B03QMvJUXfns6XfZX0gNntV2Lv750lfTeJPbFNgb3bCOtRNc369/W
         2Hug==
X-Forwarded-Encrypted: i=1; AJvYcCUzNST9aLfNn5g/L7zAYu2S+AdiJQUwJ3UogMTQS9wZZgQfqddYJaeR60tTMbWR66TW3x8ZKGnkUss=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx90Nnl+XKHmD0VGsUQK2hwTOi+aKZKvhVEvasycKg4SLxAKSBD
	Cy1IYGHtkeFItQv5A7/umqFXuliwL6C+HcoFPI3GicKzyFsUyjXDF/ncw4hYkPS1Iau9F8OmPM4
	ylw==
X-Google-Smtp-Source: AGHT+IHoBRCOykd0M/JG0OnOX96GiVjTOBq+7QjcigybBzm1eoql7wNABr53Ji6d8itQZ8cWe3pKz5HSf/8=
X-Received: from pjbli10.prod.google.com ([2002:a17:90b:48ca:b0:2e1:8750:2b46])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:1bcb:b0:2ea:4e67:5638
 with SMTP id 98e67ed59e1d1-2ee097e3b21mr6975530a91.35.1732757719107; Wed, 27
 Nov 2024 17:35:19 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 17:33:54 -0800
In-Reply-To: <20241128013424.4096668-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128013424.4096668-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128013424.4096668-28-seanjc@google.com>
Subject: [PATCH v3 27/57] KVM: x86: #undef SPEC_CTRL_SSBD in cpuid.c to avoid
 macro collisions
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

Undefine SPEC_CTRL_SSBD, which is #defined by msr-index.h to represent the
enable flag in MSR_IA32_SPEC_CTRL, to avoid issues with the macro being
unpacked into its raw value when passed to KVM's F() macro.  This will
allow using multiple layers of macros in F() and friends, e.g. to harden
against incorrect usage of F().

No functional change intended (cpuid.c doesn't consume SPEC_CTRL_SSBD).

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 73e756d097e4..efff83da3df3 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -644,6 +644,12 @@ static __always_inline void kvm_cpu_cap_init(u32 leaf, u32 mask)
 	feature_bit(name);							\
 })
 
+/*
+ * Undefine the MSR bit macro to avoid token concatenation issues when
+ * processing X86_FEATURE_SPEC_CTRL_SSBD.
+ */
+#undef SPEC_CTRL_SSBD
+
 void kvm_set_cpu_caps(void)
 {
 	memset(kvm_cpu_caps, 0, sizeof(kvm_cpu_caps));
-- 
2.47.0.338.g60cca15819-goog

