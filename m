Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D7EE1946B8
	for <linux-sgx@vger.kernel.org>; Thu, 28 Nov 2024 01:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732757705; cv=none; b=eddmOraqUyQg6ySgwVDN1fhM9xA3yQLul3mlhTu2aqbB0IjKySF9KQiXt/B2veBFzlf5rkjxYbBFzNk8gI/g2MtALyziZd13w5eEr4A2OYiPE9f5B6jIiiYqcHaxQNGbpNmmjHD4AnDsivJ5vS4bi1yxq8A+/M+tLv7nXSWyRsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732757705; c=relaxed/simple;
	bh=j1lspzAZSnatGtAyYEzo99bnshmjMvNle264S7qnyEM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CuGgYMJe1TOy/QVz2X7E2FXVS64hYWRD9+AgY4/1lN5g6oSJG0tzP033lT9FmIX5BvfHlO7FqkUMt2Jw4XWLmcSlUgH8U0io9Azp/KOwYB1JaD8EFsAxW5qRa6tqadgfM0Je91V/yUZB44eymoHIQnoOhH22dSKB/HJyw+ngT2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0RFTtWXD; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0RFTtWXD"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ea65508e51so464349a91.0
        for <linux-sgx@vger.kernel.org>; Wed, 27 Nov 2024 17:35:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732757702; x=1733362502; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=XLo8wdW1hY4DyAa14l4zhcQr5XZUx+Z57AoVSIEO6Vs=;
        b=0RFTtWXDiQ8MstnVWSEs4p4/r+aiqJ6FZuqnOhO9Dswp+JeuyCDmLALN6zfk2uQBoH
         mgNbFi8qmAiftWzaR5UYFq4HFbKZ4hRPd55fptenWBOpkHmvzOX6o0/hu7rXrMoKoaw6
         6bbC5j1Bf/5L2UgxzJ2rRc9htu6WUYI6kGTYyBhwDIEFNpxDl8vf87a4wMSLPqdG0dEt
         sTTCMHYBNlKv9WEXX2VgURimzi5+we+IS7xpEG+LgN8EkS0DOXdh5/xxdlzWZt2ZikL9
         uA+jpbSZ0qqFUtlehstvQ45cLPMmJ4EzuiOB60fX7aihyjrnCN/wX+/9NEPQl+DNV/UP
         ndbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732757702; x=1733362502;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XLo8wdW1hY4DyAa14l4zhcQr5XZUx+Z57AoVSIEO6Vs=;
        b=VTAvAF/Oq+9LcCsXIYi3QUR3uhWR0B3keI+lInjJdD3Lft06lKaeiXD94TdcRgpIDs
         J+Zn46EXp4d0SlHShX04wlbZPYnD62J/+MK1S8+9PZnaIaDJTa0WZXHle9VaMONnRcGT
         DgMoKjyHcGa+47sPboj5hYmR3ZJgdiYTyGC9X2aIw9upP2eZJUQ8WfWOZUO0Z3lvk+3f
         tNXfDWB1JgUxOg+/a1CNx1SvF874vT4wchHnpFh1bUKrSs7xuKrpQLjX39L4MNFhIoB9
         +cLqf5uupLRQ4nCQ1sRhN+KI7IFBAgMp//Vifrxb69G7QlGyn9vRjm3Sy3T3GXRTE5+w
         SQAg==
X-Forwarded-Encrypted: i=1; AJvYcCV6Cb1U6JSabpXAKUuzJuAAeP3wva9rNHXuZFLQfiJ58h0t0HEzjggN5r44dDXqFnkaqUr/E1fctn0=@vger.kernel.org
X-Gm-Message-State: AOJu0YwzJCV7eX0lhDBFR9lKckpQTmXY997WoWjv+75x0hCHqm/qOqJD
	wEG2qpYwszqZh0YcqfnrMlhuJi41XqsqRDy8wI/oaPwXY9uBMJ5jYJCbwWbHoE4LgaFEODSbpSc
	gjg==
X-Google-Smtp-Source: AGHT+IHyVZYklRIZXblHAU0wo0hjicXubUhgilAq45apylTWtGkdHw/j/lrE0oNG5NnvnHBwCmvn7YOyk/M=
X-Received: from pjbnd11.prod.google.com ([2002:a17:90b:4ccb:b0:2e9:ee22:8881])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4b87:b0:2ea:6551:da5d
 with SMTP id 98e67ed59e1d1-2ee08eb2b6emr6361094a91.13.1732757701830; Wed, 27
 Nov 2024 17:35:01 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 17:33:44 -0800
In-Reply-To: <20241128013424.4096668-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128013424.4096668-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128013424.4096668-18-seanjc@google.com>
Subject: [PATCH v3 17/57] KVM: selftests: Update x86's KVM PV test to match
 KVM's disabling exits behavior
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

Rework x86's KVM PV features test to align with KVM's new, fixed behavior
of not allowing userspace to disable HLT-exiting after vCPUs have been
created.  Rework the core testcase to disable HLT-exiting before creating
a vCPU, and opportunistically modify keep the paired VM+vCPU creation to
verify that KVM rejects KVM_CAP_X86_DISABLE_EXITS as expected.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/kvm_pv_test.c        | 33 +++++++++++++++++--
 1 file changed, 30 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c b/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
index 2aee93108a54..1b805cbdb47b 100644
--- a/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
@@ -139,6 +139,7 @@ static void test_pv_unhalt(void)
 	struct kvm_vm *vm;
 	struct kvm_cpuid_entry2 *ent;
 	u32 kvm_sig_old;
+	int r;
 
 	if (!(kvm_check_cap(KVM_CAP_X86_DISABLE_EXITS) & KVM_X86_DISABLE_EXITS_HLT))
 		return;
@@ -152,19 +153,45 @@ static void test_pv_unhalt(void)
 	TEST_ASSERT(vcpu_cpuid_has(vcpu, X86_FEATURE_KVM_PV_UNHALT),
 		    "Enabling X86_FEATURE_KVM_PV_UNHALT had no effect");
 
-	/* Make sure KVM clears vcpu->arch.kvm_cpuid */
+	/* Verify KVM disallows disabling exits after vCPU creation. */
+	r = __vm_enable_cap(vm, KVM_CAP_X86_DISABLE_EXITS, KVM_X86_DISABLE_EXITS_HLT);
+	TEST_ASSERT(r && errno == EINVAL,
+		    "Disabling exits after vCPU creation didn't fail as expected");
+
+	kvm_vm_free(vm);
+
+	/* Verify that KVM clear PV_UNHALT from guest CPUID. */
+	vm = vm_create(1);
+	vm_enable_cap(vm, KVM_CAP_X86_DISABLE_EXITS, KVM_X86_DISABLE_EXITS_HLT);
+
+	vcpu = vm_vcpu_add(vm, 0, NULL);
+	TEST_ASSERT(!vcpu_cpuid_has(vcpu, X86_FEATURE_KVM_PV_UNHALT),
+		    "vCPU created with PV_UNHALT set by default");
+
+	vcpu_set_cpuid_feature(vcpu, X86_FEATURE_KVM_PV_UNHALT);
+	TEST_ASSERT(!vcpu_cpuid_has(vcpu, X86_FEATURE_KVM_PV_UNHALT),
+		    "PV_UNHALT set in guest CPUID when HLT-exiting is disabled");
+
+	/*
+	 * Clobber the KVM PV signature and verify KVM does NOT clear PV_UNHALT
+	 * when KVM PV is not present, and DOES clear PV_UNHALT when switching
+	 * back to the correct signature..
+	 */
 	ent = vcpu_get_cpuid_entry(vcpu, KVM_CPUID_SIGNATURE);
 	kvm_sig_old = ent->ebx;
 	ent->ebx = 0xdeadbeef;
 	vcpu_set_cpuid(vcpu);
 
-	vm_enable_cap(vm, KVM_CAP_X86_DISABLE_EXITS, KVM_X86_DISABLE_EXITS_HLT);
+	vcpu_set_cpuid_feature(vcpu, X86_FEATURE_KVM_PV_UNHALT);
+	TEST_ASSERT(vcpu_cpuid_has(vcpu, X86_FEATURE_KVM_PV_UNHALT),
+		    "PV_UNHALT cleared when using bogus KVM PV signature");
+
 	ent = vcpu_get_cpuid_entry(vcpu, KVM_CPUID_SIGNATURE);
 	ent->ebx = kvm_sig_old;
 	vcpu_set_cpuid(vcpu);
 
 	TEST_ASSERT(!vcpu_cpuid_has(vcpu, X86_FEATURE_KVM_PV_UNHALT),
-		    "KVM_FEATURE_PV_UNHALT is set with KVM_CAP_X86_DISABLE_EXITS");
+		    "PV_UNHALT set in guest CPUID when HLT-exiting is disabled");
 
 	/* FIXME: actually test KVM_FEATURE_PV_UNHALT feature */
 
-- 
2.47.0.338.g60cca15819-goog

