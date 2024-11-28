Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FACA14B092
	for <linux-sgx@vger.kernel.org>; Thu, 28 Nov 2024 01:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732757693; cv=none; b=LIe2O7xrV7rnLy4liQPD8mKIm2CjfJa9th2LOjl3jGd1buBR7OOjEE4O0QJURsd9FhIwA47hS7tG7DkPgHjq/J8jUAqPK+BZq/I9uJZ2/bYF28LXKhQkjP15ID79jiV//697SZKPVhQaK7BQdaAbAotLRQ6QnNxcq1NmW28OPGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732757693; c=relaxed/simple;
	bh=8M4UbYKmp2Gh3Zl4jYlDZTt0BoGbSmn6dRyyLDCWFzs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rc1geP1l70Jw1/4C+SDCLXH0mo5Dwq7IddPUqYLlq7xcQKWGmO4I62wJSKD7IvvtP1/0gj7/PB17hWtzfJyuLazeJPdG/A7W7utyunnMoCv6rjESEMWqh3TGMPKa1iu6PiFypMniZ5UVCsJIar3VKj/z64Vi8rfZs/j/rzz9MjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MiKR/3qg; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MiKR/3qg"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2edba08c89bso388524a91.1
        for <linux-sgx@vger.kernel.org>; Wed, 27 Nov 2024 17:34:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732757691; x=1733362491; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=En/ebXFE7IQduzFpZQdCqb30HJiQ4lZcee0ytf8Ga+A=;
        b=MiKR/3qgJH4REfUoGPzlFpALpdIbgwl/ret7NLzLlKib7Wljca/iiqV4pPUpSaKbIt
         8DmAkqMeZY1inyBOyyTz40jX/PsobyH/V+dvmNMubEsquz8dzxFd3kF4IBzxs0P/ID2s
         44Rx5abNB77VoZJWa+2AQnlaqYpc2AhAr84Xer5rkhK0zS13bzdEtyh0+KZPE4eTn6NX
         N8obH6AQmv5dWVU6hiP+3rtv78P+2d4oAi+9+6T6GQSUW82LJLAkSBEQiNmjSN9SBMd3
         TpPHbX00NZl9I/GSHKUSyKuBAnOqXo6ZZ8l8QPgYBzoPP0jyRNSABcgcoK6KhcZNWp72
         WWoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732757691; x=1733362491;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=En/ebXFE7IQduzFpZQdCqb30HJiQ4lZcee0ytf8Ga+A=;
        b=My/3S++Xq+sXRsu9KjpkJmpNxn9GyZXzjr5ifyR4I6U7aOVNI1OTsN8rHTJPmO+ZdH
         fZe9p7q49niipxY5CQOpPiiOqamVoC5/Hf5Rt8NWTq8Zc7GaKy7JN5WyDTFU8v4eRXUK
         SoSiBPz8B71BK1czmyeWPR/fP/hZeAmDY1olIZC66CI6o9CPHVb7eFT5+ff0LHLMrzJ5
         e+gMEwW5H6DRgUANHqBRDUNwcrXUg+fmBfQTo1OvFd2VncHIqN9bjk+T39h+RYUSshyK
         jl7L287XMrOzAOmnbEL+RI6bpERQWGy8KsFRCtBbUa38eDfRFkzqlKC8rBviZbMJBj7S
         A6HQ==
X-Forwarded-Encrypted: i=1; AJvYcCVLdTHTOILNF8wpuxLH0GVlB9pweWP/A+u/ael8eN/3gUy3aXGcISVXITg7gN7brdKFLA7FwKxaTLs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyfJySuKDJjeiFu51oxcFeDooIvD7xZ9cZFf2YlW5dPra7rYOHc
	eOuljyyI1jIGW2Mj6fRkFRxynYqnvzUewZqeGDlXiZcV8TahAqOADtJb7LOXwbHjAVaS8u42Ag4
	YBg==
X-Google-Smtp-Source: AGHT+IEjLtBeoOk0kP8rZqlEKEWA2SUCicvERQLF5yyR4OIJCyQDVxB251zmH/KpQQb4kFZaHqyk1H0JDY0=
X-Received: from pjbpl3.prod.google.com ([2002:a17:90b:2683:b0:2e9:5043:f55b])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4b87:b0:2ea:8e42:c39
 with SMTP id 98e67ed59e1d1-2ee08eb2a35mr6655972a91.11.1732757691529; Wed, 27
 Nov 2024 17:34:51 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 17:33:38 -0800
In-Reply-To: <20241128013424.4096668-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128013424.4096668-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128013424.4096668-12-seanjc@google.com>
Subject: [PATCH v3 11/57] KVM: x86/pmu: Drop now-redundant refresh() during init()
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

Drop the manual kvm_pmu_refresh() from kvm_pmu_init() now that
kvm_arch_vcpu_create() performs the refresh via kvm_vcpu_after_set_cpuid().

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/pmu.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 47a46283c866..75e9cfc689f8 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -797,7 +797,6 @@ void kvm_pmu_init(struct kvm_vcpu *vcpu)
 
 	memset(pmu, 0, sizeof(*pmu));
 	kvm_pmu_call(init)(vcpu);
-	kvm_pmu_refresh(vcpu);
 }
 
 /* Release perf_events for vPMCs that have been unused for a full time slice.  */
-- 
2.47.0.338.g60cca15819-goog

