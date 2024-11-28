Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4518613C9A4
	for <linux-sgx@vger.kernel.org>; Thu, 28 Nov 2024 01:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732757684; cv=none; b=tn+I9CwSVqQFs8MsPgs6aj7cCleQ1n5nyqd+bHPtEIOJdJcfYxX0aZmc9EGFGL38ImkzioO12leXC+LrjHggt3WyIr/ll/mBa9ae/feaBrbBjvX5ILtNHqOYWsByqsvTfT/jl4zNXo3CHDHfLnhEtk6u1DMpu7Yyh8G5Sg3LwpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732757684; c=relaxed/simple;
	bh=QJc+FEzXVeCAxPo80C8wrYU7+g82FcSuNFBiAoHtEhk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WGX83dmwfeqK0I8j61rDXKLQjzug8hbc5eggh4Mu6QV6p1yzUoYJufs038B5S+KAMaP5F+/wlm3WH4xpZBFzJA03zE+bBeDWvP2rT6L/w9ahskVwPZ8fhUKkHpU1vD8lQgOJt08CwyYrMDYMTR+yM48N9my8R67okiKhJGg1SfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tUNwZTqV; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tUNwZTqV"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ea50564395so1192737a91.0
        for <linux-sgx@vger.kernel.org>; Wed, 27 Nov 2024 17:34:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732757682; x=1733362482; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=MtJpTug2Xv1CVCtWJOgvfGfe/Mgf3AkZEgip1AXL4x0=;
        b=tUNwZTqVryPRkUDCMbJBYqxEe3MWO1vfkYjm4TOPzxEYsx47Dy624jNTjAWvOp4eWT
         KXtlEkEXBPwYB/GLB9mpRsGIRLJn3bECDtYki5HP9zP08FHuh659jnFZKfBKLohU23wQ
         7bHXRAIDVdlGxk8xOpvqjbc6LArRY8eQygLXMbMOhkqcl2G8NUp0TWVInT/BnWXzq+QH
         4b8rnKriLhjRD2uogCG4lvm4GtkQ99CGpcbkGcEvvpkgkSQ6ThnkMY9dBLEjUjxY/u3T
         AUi6sNjEwkU8mf50yM2StY/fIMCxjbzcBKqOhscFbDHVqWICfvB3Y/DqXhIcu6KSUjNM
         Z53g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732757682; x=1733362482;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MtJpTug2Xv1CVCtWJOgvfGfe/Mgf3AkZEgip1AXL4x0=;
        b=peZwsw9hCKKaiSv2Hbx9WwGFzXTVXWpD9qK5ahtZpIJQbWeTmTddC2wuaJEFmy4wTL
         a482eGI9kT6/2hPW3bd1/T5C5bPBhhx9NVoKw0xHAVXC0jTItY+Dh0tUL4vRdbHeW7V6
         8xAJ6f1XErG6bE84ZQqMYWu8vRH6qDiuM+dG28K9b+hR4fy0FoDEOeSrEN+46d3CysNo
         KB56isLxKCdg2qFbn5nR//vaR74YEPiX21G0f2F2s7GJru5r3i4KqL9kT7qS+JmMP1d7
         njsTvPz8lOUrresbg9FhHeykuUlOwK8UmCwOHPSmwK4oUTVl+KsSg2Y88JeLKkTgUpik
         fFGA==
X-Forwarded-Encrypted: i=1; AJvYcCVb4xHBjZaFUNVMJ6AbRcdnVJ8J24vmSzJVGsMMBELoosqa31J3i2AM+8xl6P8wLVf4QJJqOOKXOR8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxZ8DbrOcls7Md6BGGZBQxrG370gdqa+/rcFi4jbwnTsu5anRcl
	jDGKAnq0PK1GOmB+tooqeC9gCM+QdLyoo+hdmUGgVw4xbObMlnBGzpHtB6BMciz3YLmX9rnBZQQ
	zgg==
X-Google-Smtp-Source: AGHT+IHs7YMO6bnbVTaHRci57mi0tZOsttWoO6yiCS1Zz6KI6+CuHBTdK+Spdw0gap5+9ulrrnY3jmx4M90=
X-Received: from pjbst14.prod.google.com ([2002:a17:90b:1fce:b0:2ea:9d23:79a0])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3ec3:b0:2ee:2ce7:7996
 with SMTP id 98e67ed59e1d1-2ee2ce77d98mr718912a91.17.1732757682565; Wed, 27
 Nov 2024 17:34:42 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 17:33:33 -0800
In-Reply-To: <20241128013424.4096668-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128013424.4096668-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128013424.4096668-7-seanjc@google.com>
Subject: [PATCH v3 06/57] KVM: selftests: Update x86's set_sregs_test to match
 KVM's CPUID enforcement
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

Rework x86's set sregs test to verify that KVM enforces CPUID vs. CR4
features even if userspace hasn't explicitly set guest CPUID.  KVM used to
allow userspace to set any KVM-supported CR4 value prior to KVM_SET_CPUID2,
and the test verified that behavior.

However, the testcase was written purely to verify KVM's existing behavior,
i.e. was NOT written to match the needs of real world VMMs.

Opportunistically verify that KVM continues to reject unsupported features
after KVM_SET_CPUID2 (using KVM_GET_SUPPORTED_CPUID).

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/set_sregs_test.c     | 53 +++++++++++--------
 1 file changed, 30 insertions(+), 23 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/set_sregs_test.c b/tools/testing/selftests/kvm/x86_64/set_sregs_test.c
index c021c0795a96..96fd690d479a 100644
--- a/tools/testing/selftests/kvm/x86_64/set_sregs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/set_sregs_test.c
@@ -41,13 +41,15 @@ do {										\
 	TEST_ASSERT(!memcmp(&new, &orig, sizeof(new)), "KVM modified sregs");	\
 } while (0)
 
+#define KVM_ALWAYS_ALLOWED_CR4 (X86_CR4_VME | X86_CR4_PVI | X86_CR4_TSD |	\
+				X86_CR4_DE | X86_CR4_PSE | X86_CR4_PAE |	\
+				X86_CR4_MCE | X86_CR4_PGE | X86_CR4_PCE |	\
+				X86_CR4_OSFXSR | X86_CR4_OSXMMEXCPT)
+
 static uint64_t calc_supported_cr4_feature_bits(void)
 {
-	uint64_t cr4;
+	uint64_t cr4 = KVM_ALWAYS_ALLOWED_CR4;
 
-	cr4 = X86_CR4_VME | X86_CR4_PVI | X86_CR4_TSD | X86_CR4_DE |
-	      X86_CR4_PSE | X86_CR4_PAE | X86_CR4_MCE | X86_CR4_PGE |
-	      X86_CR4_PCE | X86_CR4_OSFXSR | X86_CR4_OSXMMEXCPT;
 	if (kvm_cpu_has(X86_FEATURE_UMIP))
 		cr4 |= X86_CR4_UMIP;
 	if (kvm_cpu_has(X86_FEATURE_LA57))
@@ -72,28 +74,14 @@ static uint64_t calc_supported_cr4_feature_bits(void)
 	return cr4;
 }
 
-int main(int argc, char *argv[])
+static void test_cr_bits(struct kvm_vcpu *vcpu, uint64_t cr4)
 {
 	struct kvm_sregs sregs;
-	struct kvm_vcpu *vcpu;
-	struct kvm_vm *vm;
-	uint64_t cr4;
 	int rc, i;
 
-	/*
-	 * Create a dummy VM, specifically to avoid doing KVM_SET_CPUID2, and
-	 * use it to verify all supported CR4 bits can be set prior to defining
-	 * the vCPU model, i.e. without doing KVM_SET_CPUID2.
-	 */
-	vm = vm_create_barebones();
-	vcpu = __vm_vcpu_add(vm, 0);
-
 	vcpu_sregs_get(vcpu, &sregs);
-
-	sregs.cr0 = 0;
-	sregs.cr4 |= calc_supported_cr4_feature_bits();
-	cr4 = sregs.cr4;
-
+	sregs.cr0 &= ~(X86_CR0_CD | X86_CR0_NW);
+	sregs.cr4 |= cr4;
 	rc = _vcpu_sregs_set(vcpu, &sregs);
 	TEST_ASSERT(!rc, "Failed to set supported CR4 bits (0x%lx)", cr4);
 
@@ -101,7 +89,6 @@ int main(int argc, char *argv[])
 	TEST_ASSERT(sregs.cr4 == cr4, "sregs.CR4 (0x%llx) != CR4 (0x%lx)",
 		    sregs.cr4, cr4);
 
-	/* Verify all unsupported features are rejected by KVM. */
 	TEST_INVALID_CR_BIT(vcpu, cr4, sregs, X86_CR4_UMIP);
 	TEST_INVALID_CR_BIT(vcpu, cr4, sregs, X86_CR4_LA57);
 	TEST_INVALID_CR_BIT(vcpu, cr4, sregs, X86_CR4_VMXE);
@@ -119,10 +106,28 @@ int main(int argc, char *argv[])
 	/* NW without CD is illegal, as is PG without PE. */
 	TEST_INVALID_CR_BIT(vcpu, cr0, sregs, X86_CR0_NW);
 	TEST_INVALID_CR_BIT(vcpu, cr0, sregs, X86_CR0_PG);
+}
 
+int main(int argc, char *argv[])
+{
+	struct kvm_sregs sregs;
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	int rc;
+
+	/*
+	 * Create a dummy VM, specifically to avoid doing KVM_SET_CPUID2, and
+	 * use it to verify KVM enforces guest CPUID even if *userspace* never
+	 * sets CPUID.
+	 */
+	vm = vm_create_barebones();
+	vcpu = __vm_vcpu_add(vm, 0);
+	test_cr_bits(vcpu, KVM_ALWAYS_ALLOWED_CR4);
 	kvm_vm_free(vm);
 
-	/* Create a "real" VM and verify APIC_BASE can be set. */
+	/* Create a "real" VM with a fully populated guest CPUID and verify
+	 * APIC_BASE and all supported CR4 can be set.
+	 */
 	vm = vm_create_with_one_vcpu(&vcpu, NULL);
 
 	vcpu_sregs_get(vcpu, &sregs);
@@ -135,6 +140,8 @@ int main(int argc, char *argv[])
 	TEST_ASSERT(!rc, "Couldn't set IA32_APIC_BASE to %llx (valid)",
 		    sregs.apic_base);
 
+	test_cr_bits(vcpu, calc_supported_cr4_feature_bits());
+
 	kvm_vm_free(vm);
 
 	return 0;
-- 
2.47.0.338.g60cca15819-goog

