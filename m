Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D52F1BBBC6
	for <linux-sgx@vger.kernel.org>; Thu, 28 Nov 2024 01:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732757730; cv=none; b=UN1mRkhLN6Xrjm6mohkZ8dQhzdeRpKZ81cvZMoVaDHgLZXY/FbO0olWr0rINj9Mtuxz0VIZrcku5cMI2I8v/BqO48x6gIhrOKyk6z5BXVaMllruanfTp7wyH3woSZUmeCdARUbe5aPHCgX7IMUySwdAmUY7NEG6agQPlQwqeJ8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732757730; c=relaxed/simple;
	bh=6DB4trFrbk9yBinrFJAMaiHYTeHNXaksqKnSo6VP/88=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OSC7ifWwXC+2QA21iJ6IBwjBYsaZ2ZL90O0BU3WlK58a8hicQyibQZtuv3Qe+EURLXtpCfwCxhvUydtlweDtCq6Mzok7RUSs5hn//qKXF1X64MJmNRIUtIhNIcarBWl2O+zmattptWu6qWYxMW9BJTm4QlglypERjtcxpz3CCvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GP+108G6; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GP+108G6"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2edba08c89bso389089a91.1
        for <linux-sgx@vger.kernel.org>; Wed, 27 Nov 2024 17:35:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732757728; x=1733362528; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=H4mMlNuJ9TX7gyN173237rpU6OTOfVXmiajFLJnFb4Y=;
        b=GP+108G6Lx4mfYJfbEUcjoCXR72RZCiNH/poX+lxAiVVudRaL0urxJVmRH88OuhYUK
         am7ujQq5RKVBao+YzZyvmmlbH/+Rfdfy+7LHMxqJ+XiCOsd2ntzfs81INv5PBVvAjxIG
         g+oPXVgqDn/TrNID1jvN0nNUEmJYYhllnJcbcAszYDxisUMtiLNnxwCKzlr7W2rnH+WC
         Kblvsl9aYviN3sP5Y/GYkk1DdPRM9mw6he9wGldbXx/kIdp1UBwmQJs6GzsK0OWm/9SR
         pr0DXfYrDOnh2h6MCsTPjEOr/vVd+yMnQICbdlrNjs/+4V7h/qLHGO/v3MFNc5TfmzQV
         miIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732757728; x=1733362528;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=H4mMlNuJ9TX7gyN173237rpU6OTOfVXmiajFLJnFb4Y=;
        b=ve9bS9MgADuRc7agRHmxrwgROT7kvjBPpsCwt0EoHwhe9jnUNGVTGoCnIhZSEawrGp
         qCUiz/uiqxafEK7jrB5dnsQ0ADse8LA5EWX3lt2/GOtGHwJxfmysBBDprQrH0ZGPESt6
         PQ4OYYaFaM0k+RDVMVZRwl3gPjlxM/5/CWpnE0GGwnFT8GjHnE3CEcTRjqu5afktJYa7
         WnTiqYvG3DViMtHT922Ol9B2yD8BOx++fZqMgWTEEx0xOP/y9nJ+nk5L9b5u5aNgfv47
         iWpAzyzxF+/odOZqHFowt+8/DfJ3Av0BJrCLvrP18J5T599iTf/UVNHMa3SZtomk/RD8
         g/zQ==
X-Forwarded-Encrypted: i=1; AJvYcCU5Vbkiejgw8cYFnwPzU8dweNgIQNXbQh50y9TTt6H7+pfAzRgeBbiH4He32lvpXK3IHWRTp3x9G5o=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw95An+eXMNlPteJVH6vrSw2D5qqOn16lkcg6BMHQUb0Wfebmfq
	N/FEprmjqqmzmltTw8Vgv3oNDEu3o1wmvYcdAhElpVhkQUKyZSZAMyhw9Mp/enI+4taSsaQcHGd
	SLg==
X-Google-Smtp-Source: AGHT+IFoRYZVgegQAj1HVnIpOo2eSCJNS5N/CF8iITVF/m1xuDHH3WwCi9qcJb1yo4fRCv1bgRo8QRagug4=
X-Received: from pjbrr15.prod.google.com ([2002:a17:90b:2b4f:b0:2ea:adc3:8daa])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d410:b0:2ea:a9ac:eedd
 with SMTP id 98e67ed59e1d1-2ee08eb1d90mr6910625a91.9.1732757727712; Wed, 27
 Nov 2024 17:35:27 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 17:33:59 -0800
In-Reply-To: <20241128013424.4096668-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128013424.4096668-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128013424.4096668-33-seanjc@google.com>
Subject: [PATCH v3 32/57] KVM: x86: Clear PV_UNHALT for !HLT-exiting only when
 userspace sets CPUID
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

Now that KVM disallows disabling HLT-exiting after vCPUs have been created,
i.e. now that it's impossible for kvm_hlt_in_guest() to change while vCPUs
are running, apply KVM's PV_UNHALT quirk only when userspace is setting
guest CPUID.

Opportunistically rename the helper to make it clear that KVM's behavior
is a quirk that should never have been added.  KVM's documentation
explicitly states that userspace should not advertise PV_UNHALT if
HLT-exiting is disabled, but for unknown reasons, commit caa057a2cad6
("KVM: X86: Provide a capability to disable HLT intercepts") didn't stop
at documenting the requirement and also massaged the incoming guest CPUID.

Unfortunately, it's quite likely that userspace has come to rely on KVM's
behavior, i.e. the code can't simply be deleted.  The only reason KVM
doesn't have an "official" quirk is that there is no known use case where
disabling the quirk would make sense, i.e. letting userspace disable the
quirk would further increase KVM's burden without any benefit.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index e8c30de2faa9..3ba0e6a67823 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -157,6 +157,8 @@ static int kvm_check_cpuid(struct kvm_vcpu *vcpu)
 	return fpu_enable_guest_xfd_features(&vcpu->arch.guest_fpu, xfeatures);
 }
 
+static u32 kvm_apply_cpuid_pv_features_quirk(struct kvm_vcpu *vcpu);
+
 /* Check whether the supplied CPUID data is equal to what is already set for the vCPU. */
 static int kvm_cpuid_check_equal(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2 *e2,
 				 int nent)
@@ -176,6 +178,7 @@ static int kvm_cpuid_check_equal(struct kvm_vcpu *vcpu, struct kvm_cpuid_entry2
 	 * Note!  @e2 and @nent track the _old_ CPUID entries!
 	 */
 	kvm_update_cpuid_runtime(vcpu);
+	kvm_apply_cpuid_pv_features_quirk(vcpu);
 
 	if (nent != vcpu->arch.cpuid_nent)
 		return -EINVAL;
@@ -246,18 +249,17 @@ static struct kvm_cpuid_entry2 *kvm_find_kvm_cpuid_features(struct kvm_vcpu *vcp
 					     vcpu->arch.cpuid_nent, base);
 }
 
-static void kvm_update_pv_runtime(struct kvm_vcpu *vcpu)
+static u32 kvm_apply_cpuid_pv_features_quirk(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best = kvm_find_kvm_cpuid_features(vcpu);
 
-	vcpu->arch.pv_cpuid.features = 0;
+	if (!best)
+		return 0;
 
-	/*
-	 * save the feature bitmap to avoid cpuid lookup for every PV
-	 * operation
-	 */
-	if (best)
-		vcpu->arch.pv_cpuid.features = best->eax;
+	if (kvm_hlt_in_guest(vcpu->kvm))
+		best->eax &= ~(1 << KVM_FEATURE_PV_UNHALT);
+
+	return best->eax;
 }
 
 /*
@@ -279,7 +281,6 @@ static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_e
 				       int nent)
 {
 	struct kvm_cpuid_entry2 *best;
-	struct kvm_hypervisor_cpuid kvm_cpuid;
 
 	best = cpuid_entry2_find(entries, nent, 1, KVM_CPUID_INDEX_NOT_SIGNIFICANT);
 	if (best) {
@@ -306,13 +307,6 @@ static void __kvm_update_cpuid_runtime(struct kvm_vcpu *vcpu, struct kvm_cpuid_e
 		     cpuid_entry_has(best, X86_FEATURE_XSAVEC)))
 		best->ebx = xstate_required_size(vcpu->arch.xcr0, true);
 
-	kvm_cpuid = __kvm_get_hypervisor_cpuid(entries, nent, KVM_SIGNATURE);
-	if (kvm_cpuid.base) {
-		best = __kvm_find_kvm_cpuid_features(entries, nent, kvm_cpuid.base);
-		if (kvm_hlt_in_guest(vcpu->kvm) && best)
-			best->eax &= ~(1 << KVM_FEATURE_PV_UNHALT);
-	}
-
 	if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT)) {
 		best = cpuid_entry2_find(entries, nent, 0x1, KVM_CPUID_INDEX_NOT_SIGNIFICANT);
 		if (best)
@@ -396,7 +390,7 @@ void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	vcpu->arch.guest_supported_xcr0 =
 		cpuid_get_supported_xcr0(vcpu->arch.cpuid_entries, vcpu->arch.cpuid_nent);
 
-	kvm_update_pv_runtime(vcpu);
+	vcpu->arch.pv_cpuid.features = kvm_apply_cpuid_pv_features_quirk(vcpu);
 
 	vcpu->arch.is_amd_compatible = guest_cpuid_is_amd_or_hygon(vcpu);
 	vcpu->arch.maxphyaddr = cpuid_query_maxphyaddr(vcpu);
-- 
2.47.0.338.g60cca15819-goog

