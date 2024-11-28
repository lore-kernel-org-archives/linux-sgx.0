Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D2181C1F32
	for <linux-sgx@vger.kernel.org>; Thu, 28 Nov 2024 01:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732757740; cv=none; b=pp8wuyYDZFONRnnKsOsHxMu9NT08XQdFWMEqY5UdphFpO58lx+yy3yCG2BpZN1K1yIE1UN4siiDkBoBAh090uRNvKY81cGDLpqXYej4ENNQMMMirCWzwwFH8mnb6eo7tgTE5yq9fFfNbCDGaCK8JdvGU1YTvC5tE7amhLmzMXT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732757740; c=relaxed/simple;
	bh=I/YDR3JStGxjrdjAITcHrtFRex6HHvT0+U3XKq8mm6M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sqZonszyBeDkJOc7hnX1ekS57RzlYym49U2Hq9XsTDYhyZJSt6GpLuHbCPw9rD66Jr74yT/5fzhjcwKI9C8W+CNHa/iVtmzUBB2rG/6MQX+D/RsysojKqWtqKRXRhMUyNbJPPXoFQWYWCVBmT3Eeau02hEu8JR+lxWEVGSHFgAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=coHkjAS0; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="coHkjAS0"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7fbbb61a67cso151614a12.3
        for <linux-sgx@vger.kernel.org>; Wed, 27 Nov 2024 17:35:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732757738; x=1733362538; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=iYvz2Rhm4HLNhXyImO2FrXh2iHX5TjPw17ql6ofDjOI=;
        b=coHkjAS0VE0Ntv9SpGYT+KmW5QivqO9hdzy/8Ax60ZfvF72ph+inLrr0cuanXV5l3f
         fNX2R4CobbCm+VghtCvZciydhfQpP1cxLQdf3aX72gFWbt46AD4wqbhnb4op3InCxZCb
         98F6sD0OsuqrTRUv8BrtVJjKGNwTI1Zl1tkKjITkojEX7EWY4Jc00gwCQuBiydBco0eJ
         TwBlhlp3kGjpzVnfkOWQsTcZhFQj44bpe27d/Dn+egYGM+mzwXdYuJhsRh4Sw6O6czW9
         ZmDygonrDlAOp2myVj2NFtDPX/QEjqXDaZ7g0hYTiV0ltVIs3rQSn3bk7bI3w8zIiTlV
         SMVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732757738; x=1733362538;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iYvz2Rhm4HLNhXyImO2FrXh2iHX5TjPw17ql6ofDjOI=;
        b=AeiC1I8A7N4kSt3c5TojHuULdKWVHtgCrXZyhPLPcbea6izxQWm1T6GmQ+Nf6vo0FZ
         yaJN+sXv6GIOZR2SUVK7QMV/Fdh71IsXwyu2uyCzQGu18oDcYLIobAaoG/8QByZG6Ovs
         XY9UldqlsjKHg1+C36zt+eo2Jj9zR5B74f1MF5b6mLDWJdIa17/1eW1MRNIRPkbAzIgb
         nH78eSNlIylsNcEUUaxGXzAYVaNKUm3Sy1mnSbbJiyj+IkPq9keOt28tqrR/xRaAfwoj
         gFIfe7WzV31ndyd5zl9fhftaYhRCso/WAl1Wczu8gGYwusKyeXP7wfTgWe2q8U0yuTt8
         U4jA==
X-Forwarded-Encrypted: i=1; AJvYcCVU6yEYnHR5IEdWE0GE8CNoR+pX8sqcp0/rfTGFkQf7kxfTqMsMbApddCb1wBkOfG/ADEBmz1Ysz5M=@vger.kernel.org
X-Gm-Message-State: AOJu0YwLPIoOxqhElL+uSqn/kdUmBpB6tB0gDqkhs5847Yh4f3TexNEt
	uzO0dKWKyj9SjgHzYnXwkXczFxv1paHttx4gcBVuRX7IaG3aVi1Inc0UAJoz0Rnv9W54ptdCBPa
	Xgg==
X-Google-Smtp-Source: AGHT+IEVvsXIduk+X8FhHtMD4fvZwF9esFmBYy1M6G4Vt/JFtxhh+BZnNYrS8WzpeGLVp9j7hfA8IMyyDBc=
X-Received: from pfba4.prod.google.com ([2002:a05:6a00:ac04:b0:724:e712:5cbe])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:2451:b0:1e0:d45d:645f
 with SMTP id adf61e73a8af0-1e0e0b9a2fcmr9216517637.39.1732757738016; Wed, 27
 Nov 2024 17:35:38 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 17:34:05 -0800
In-Reply-To: <20241128013424.4096668-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128013424.4096668-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128013424.4096668-39-seanjc@google.com>
Subject: [PATCH v3 38/57] KVM: x86: Advertise HYPERVISOR in KVM_GET_SUPPORTED_CPUID
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

Unconditionally advertise "support" for the HYPERVISOR feature in CPUID,
as the flag simply communicates to the guest that's it's running under a
hypervisor.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 51792cf48cd7..a13bf0ab417d 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -722,7 +722,8 @@ void kvm_set_cpu_caps(void)
 		0 /* OSXSAVE */ |
 		F(AVX) |
 		F(F16C) |
-		F(RDRAND)
+		F(RDRAND) |
+		EMULATED_F(HYPERVISOR)
 	);
 
 	kvm_cpu_cap_init(CPUID_1_EDX,
-- 
2.47.0.338.g60cca15819-goog

