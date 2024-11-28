Received: from mail-oi1-f201.google.com (mail-oi1-f201.google.com [209.85.167.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1388914658B
	for <linux-sgx@vger.kernel.org>; Thu, 28 Nov 2024 01:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732757688; cv=none; b=XiZSAInZMShNhkaGngyVrZNe/h/VsKbs2wPUVfhAkXBd8gN3XCW3ElXTwNr08niCxIZOaWrtN6gvBtIukgy+TZCBIqEtREvqodXGGZOlfpJfuuo5H0Oft7PWPKWESuw7xtOOA3GG8kIx25i/sdtR7dWLwslnY/TL4eAsDBC8N60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732757688; c=relaxed/simple;
	bh=IP6FeP/Qfbs9O9vKDhVKY/b0iY7igzrnofl4+537Dgc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZbZQPL/pTTyQIQVPhktWkiYq+7BnCqSrY404CrLwZ7J62JBGJeVkuyb03/v4IUm1VtpJ5sDURa5jUaJRdR3Qg1n7IUaUmToKF52QWv2x7Hy0FGp4/sqBHD/usfeo03J5rWzOhQ0t77Gpw+mVTJ43bUkBHZb/msaSI2LRACnGNGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LjO9f2eg; arc=none smtp.client-ip=209.85.167.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LjO9f2eg"
Received: by mail-oi1-f201.google.com with SMTP id 5614622812f47-3ea46b9ddbeso341673b6e.0
        for <linux-sgx@vger.kernel.org>; Wed, 27 Nov 2024 17:34:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732757686; x=1733362486; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=TLrHqJ9mSX1ha7KdGJRhsd7odpGUfb16Qtx4XvpSUvg=;
        b=LjO9f2eg5wUPakoRfewmqrFUq6KLKizCSqUEExvqGPnThzMAG2xHFmlDoNx1BnXHos
         KfdoZwGhBhRbAmUExFmMopu5u8sBDxKVjwHOLcxmEgNA2EnNyWcQQlBhpCDttnMaK1Ty
         nKCSQR/EXm3tMaa/vquCCuR76hIHS9tbXZtxItI6482/L6NXKtI+lT7XRdNnn1NFCoD1
         PH1WNP7UWCetJpUvfHM6hHSNl5qiNgGKY5YUpmmKxLpC+pZvUfHjYmaaF60zmfc8RMbw
         lj35k96JvZ5sBwBKZnR/DEpuNczJ1r00SdmaMx4rw6icIbIu3ALVrPoJ66aRE+Q89KEH
         ZP0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732757686; x=1733362486;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TLrHqJ9mSX1ha7KdGJRhsd7odpGUfb16Qtx4XvpSUvg=;
        b=Wp+UyzQ1rCe9djHdPV0Knez4387n7ZDFN1c2d9Pu1+Ubysq2yEq7LYMFE33j0oiEgf
         Bawol5L+3c1DtiCOU5amqYd6gf5bn8MbOROywrSWiTFR+pV8GlJ1ofo2gbxOzwwpDLVJ
         7b0VEiofGVT4uCtgtb41sZXbwk1Ge6h4DtpIdyyTKZ9/a0yguR1vLnS2uYzSdMf2pbL9
         R6BU6fTFD4ruhs82BxiWwMOGcra9WJtumaXQnet+ETgkNdUuuOgM/0on+R6dhjFn0IYH
         VltFKw1o3gtU5ZzySesSlkCEGMw65UCZUZIRz1igHkaEoqgSZ8n0NSQdriPB3HKqjuyT
         MFvg==
X-Forwarded-Encrypted: i=1; AJvYcCX2a+wuclEbGITycDR2zzgqpQq2jMFP4gJMlYvtBL/6TybxH2AzkrOM/3YFduy2onHzStCKFWhbN7E=@vger.kernel.org
X-Gm-Message-State: AOJu0YzTKH6UA8s6PSEh59T7lKQ8UqEWS8/C6csXq9w2kf3nFJ8u3UNd
	bMDHWozA74QjSwiJ7y2qW4lETjECtz16R3QPyaf6wCDszZYysiBQwhNWMCiVM59qRFBkcle4DOP
	sWA==
X-Google-Smtp-Source: AGHT+IESYf1Xyb6kiu6qaapevmHMlzjJhf6SnFuIJKZSplm0ut8EdBE9r/Jj1NvLogghKzziZST+VWuQPvc=
X-Received: from pgbfe8.prod.google.com ([2002:a05:6a02:2888:b0:7fc:2ad4:6ecb])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6808:18a5:b0:3ea:556e:480d
 with SMTP id 5614622812f47-3ea6dd9c817mr5179869b6e.38.1732757686193; Wed, 27
 Nov 2024 17:34:46 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 17:33:35 -0800
In-Reply-To: <20241128013424.4096668-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128013424.4096668-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128013424.4096668-9-seanjc@google.com>
Subject: [PATCH v3 08/57] KVM: selftests: Refresh vCPU CPUID cache in __vcpu_get_cpuid_entry()
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

Refresh selftests' CPUID cache in the vCPU structure when querying a CPUID
entry so that tests don't consume stale data when KVM modifies CPUID as a
side effect to a completely unrelated change.  E.g. KVM adjusts OSXSAVE in
response to CR4.OSXSAVE changes.

Unnecessarily invoking KVM_GET_CPUID is suboptimal, but vcpu->cpuid exists
to simplify selftests development, not for performance reasons.  And,
unfortunately, trying to handle the side effects in tests or other flows
is unpleasant, e.g. selftests could manually refresh if KVM_SET_SREGS is
successful, but that would still leave a gap with respect to guest CR4
changes.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/include/x86_64/processor.h     | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
index bdc121ed4ce5..7d1ab2d2ddbb 100644
--- a/tools/testing/selftests/kvm/include/x86_64/processor.h
+++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
@@ -1012,12 +1012,19 @@ static inline struct kvm_cpuid2 *allocate_kvm_cpuid2(int nr_entries)
 
 void vcpu_init_cpuid(struct kvm_vcpu *vcpu, const struct kvm_cpuid2 *cpuid);
 
+static inline void vcpu_get_cpuid(struct kvm_vcpu *vcpu)
+{
+	vcpu_ioctl(vcpu, KVM_GET_CPUID2, vcpu->cpuid);
+}
+
 static inline struct kvm_cpuid_entry2 *__vcpu_get_cpuid_entry(struct kvm_vcpu *vcpu,
 							      uint32_t function,
 							      uint32_t index)
 {
 	TEST_ASSERT(vcpu->cpuid, "Must do vcpu_init_cpuid() first (or equivalent)");
 
+	vcpu_get_cpuid(vcpu);
+
 	return (struct kvm_cpuid_entry2 *)get_cpuid_entry(vcpu->cpuid,
 							  function, index);
 }
@@ -1038,7 +1045,7 @@ static inline int __vcpu_set_cpuid(struct kvm_vcpu *vcpu)
 		return r;
 
 	/* On success, refresh the cache to pick up adjustments made by KVM. */
-	vcpu_ioctl(vcpu, KVM_GET_CPUID2, vcpu->cpuid);
+	vcpu_get_cpuid(vcpu);
 	return 0;
 }
 
@@ -1048,12 +1055,7 @@ static inline void vcpu_set_cpuid(struct kvm_vcpu *vcpu)
 	vcpu_ioctl(vcpu, KVM_SET_CPUID2, vcpu->cpuid);
 
 	/* Refresh the cache to pick up adjustments made by KVM. */
-	vcpu_ioctl(vcpu, KVM_GET_CPUID2, vcpu->cpuid);
-}
-
-static inline void vcpu_get_cpuid(struct kvm_vcpu *vcpu)
-{
-	vcpu_ioctl(vcpu, KVM_GET_CPUID2, vcpu->cpuid);
+	vcpu_get_cpuid(vcpu);
 }
 
 void vcpu_set_cpuid_property(struct kvm_vcpu *vcpu,
-- 
2.47.0.338.g60cca15819-goog

