Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06FF229A31C
	for <linux-sgx@vger.kernel.org>; Tue, 29 Jul 2025 17:42:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753810969; cv=none; b=sq51MM8Ax9lwCZAnyqwS3jcB8ERCEX1g4bxr4ecLOG3isVFvdn64jzQMOPzHjsFeSPO50a3SHW1Ou5d8bHJ/i7Gp1PftelydejhfMIi7pIkoT4ciHKFLfY7UiZjZqT813Nhr1BDad6k6i6exGhtdKejPsabLkXUgPLnIsnxnM+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753810969; c=relaxed/simple;
	bh=HV9KqRi+UXjwAqAgOTdxJCi1FXQpzwK52ESSl7WIzoE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IGVCs/O33dmqBnRryaSpucOcqVEcAjsNau0lt1uB0gdoSQVKoGN3efqCoL718r4HwJNfx9wfjHtQ8VH7Pp8rb8nKqqjO62f89uqpRucGIsY6gcllwTxPbr/r+FLAvNdJZGV+taXNHO2xJGEg0QV+8UOT7B3zc87Oz+IK65IRetI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=B+T6beBJ; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="B+T6beBJ"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31f3cfdd3d3so737502a91.3
        for <linux-sgx@vger.kernel.org>; Tue, 29 Jul 2025 10:42:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753810967; x=1754415767; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=/DbcrgN3ecCQw7+uhqZKGmeiF8XPifOJ/SE5LpRMvY8=;
        b=B+T6beBJCIROfoaUDBFuJg8RdG42r7WuLLVlB6YC3vivIqfdMgazrvMqewOfD396AD
         IOtnxq6FS2xJV/AIY0AA/6G4Zw8Ws64WeS5VcU99QwYirxwR/xTvHSnhPZtFs4i3B6zD
         BhG76wSZLsL24ECylzHzXSl7gSIjcIr3l/0KJvtnmjI4iEYROKjWAcaUrSS5kg/IdJ7P
         DZDTJ/OsnIbgXzxYrIxndd0rFCS8eygs8fIFtEBQ357xnuuExIdZCZZ1NhWODEdOYo+9
         qZYnF1hntozS+T/GsT5MVCyt/dJo2G0TKhFzjfsjW7eqdLqmfhe+LNORfPEa48NnsC6V
         rHiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753810967; x=1754415767;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/DbcrgN3ecCQw7+uhqZKGmeiF8XPifOJ/SE5LpRMvY8=;
        b=tmdkQ9zYFpX62H9YmDNtxaNQIzrhNyhTX60ykR/rlO8DNUiyPXxlmDN/7wLdFuqaZ1
         wrKEvUgUw3APtt5WLV5WUggT2ApqfL4KKfKjhhEWDq1iZkS2hdz6isiFiaKwNCrv4Zcq
         /ferOyQ7pB1CqeR7hANxVOdGSk9s5q66ab/FB+n9gANG1ipfGpEdLYRUJeETGGCCypko
         +RWSC10j6VjLvvm6koB6MJ5klwozsnH1Z+WzKPQgXzjYnP0grRKQzBB3K9rj2YeXPw3S
         JpC74NyWz9nkoToLBwy2fwa+KbSxE7qDlb66gemfwLHDl3najOxhxrBOzNw6ltU9nq4k
         dSBQ==
X-Forwarded-Encrypted: i=1; AJvYcCXzaNji+Ybm/q6AOGL55M29+qaOY2qI3Y5UxeeFpzWAAA1N1yYos2FZVB2lQs/eh0giH4PMrRw1xOI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwZYXdX6E0me7DoI5yuZgqndqtBeUuPs2yxr9rGqksKOwBN9ihT
	5SggEGFk0vG0Ibw9lqdtjRJ+fmbK+5lGlbmU4qWtPKSCmcHmEQFCKpmbeAw2fCYD3UJTnqt/X8q
	btrxBcg==
X-Google-Smtp-Source: AGHT+IFH+wIDKMsSmrwhy/nAH7BTEpi34izfhqEJk0uofVTDFy3OPhYpSTuENnjPuH/IjmdxV+EpZXPT7WQ=
X-Received: from pjqx17.prod.google.com ([2002:a17:90a:b011:b0:314:29b4:453])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4a92:b0:31f:150:e02b
 with SMTP id 98e67ed59e1d1-31f5dd6fd0fmr572556a91.4.1753810966810; Tue, 29
 Jul 2025 10:42:46 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 29 Jul 2025 10:42:35 -0700
In-Reply-To: <20250729174238.593070-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250729174238.593070-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250729174238.593070-4-seanjc@google.com>
Subject: [PATCH 3/6] KVM: x86: Move kvm_intr_is_single_vcpu() to lapic.c
From: Sean Christopherson <seanjc@google.com>
To: Madhavan Srinivasan <maddy@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	Andy Lutomirski <luto@kernel.org>, Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Vitaly Kuznetsov <vkuznets@redhat.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "Kirill A. Shutemov" <kas@kernel.org>, 
	Tony Krowiak <akrowiak@linux.ibm.com>, Halil Pasic <pasic@linux.ibm.com>, 
	Jason Herne <jjherne@linux.ibm.com>, Harald Freudenberger <freude@linux.ibm.com>, 
	Holger Dengler <dengler@linux.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-sgx@vger.kernel.org, x86@kernel.org, linux-coco@lists.linux.dev, 
	linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Move kvm_intr_is_single_vcpu() to lapic.c, drop its export, and make its
"fast" helper local to lapic.c.  kvm_intr_is_single_vcpu() is only usable
if the local APIC is in-kernel, i.e. it most definitely belongs in the
local APIC code.

No functional change intended.

Fixes: 2f5fb6b965b3 ("KVM: x86: Dedup AVIC vs. PI code for identifying target vCPU")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm_host.h |  3 ---
 arch/x86/kvm/irq.c              | 28 ----------------------------
 arch/x86/kvm/lapic.c            | 32 ++++++++++++++++++++++++++++++--
 arch/x86/kvm/lapic.h            |  4 ++--
 4 files changed, 32 insertions(+), 35 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index f19a76d3ca0e..99c07a37bf80 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -2392,9 +2392,6 @@ void __user *__x86_set_memory_region(struct kvm *kvm, int id, gpa_t gpa,
 bool kvm_vcpu_is_reset_bsp(struct kvm_vcpu *vcpu);
 bool kvm_vcpu_is_bsp(struct kvm_vcpu *vcpu);
 
-bool kvm_intr_is_single_vcpu(struct kvm *kvm, struct kvm_lapic_irq *irq,
-			     struct kvm_vcpu **dest_vcpu);
-
 static inline bool kvm_irq_is_postable(struct kvm_lapic_irq *irq)
 {
 	/* We can only post Fixed and LowPrio IRQs */
diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c
index 16da89259011..a1a388c00187 100644
--- a/arch/x86/kvm/irq.c
+++ b/arch/x86/kvm/irq.c
@@ -411,34 +411,6 @@ int kvm_set_routing_entry(struct kvm *kvm,
 	return 0;
 }
 
-bool kvm_intr_is_single_vcpu(struct kvm *kvm, struct kvm_lapic_irq *irq,
-			     struct kvm_vcpu **dest_vcpu)
-{
-	int r = 0;
-	unsigned long i;
-	struct kvm_vcpu *vcpu;
-
-	if (kvm_intr_is_single_vcpu_fast(kvm, irq, dest_vcpu))
-		return true;
-
-	kvm_for_each_vcpu(i, vcpu, kvm) {
-		if (!kvm_apic_present(vcpu))
-			continue;
-
-		if (!kvm_apic_match_dest(vcpu, NULL, irq->shorthand,
-					irq->dest_id, irq->dest_mode))
-			continue;
-
-		if (++r == 2)
-			return false;
-
-		*dest_vcpu = vcpu;
-	}
-
-	return r == 1;
-}
-EXPORT_SYMBOL_GPL(kvm_intr_is_single_vcpu);
-
 void kvm_scan_ioapic_irq(struct kvm_vcpu *vcpu, u32 dest_id, u16 dest_mode,
 			 u8 vector, unsigned long *ioapic_handled_vectors)
 {
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 8172c2042dd6..20f7a7d0c422 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1228,8 +1228,9 @@ bool kvm_irq_delivery_to_apic_fast(struct kvm *kvm, struct kvm_lapic *src,
  *	   interrupt.
  * - Otherwise, use remapped mode to inject the interrupt.
  */
-bool kvm_intr_is_single_vcpu_fast(struct kvm *kvm, struct kvm_lapic_irq *irq,
-			struct kvm_vcpu **dest_vcpu)
+static bool kvm_intr_is_single_vcpu_fast(struct kvm *kvm,
+					 struct kvm_lapic_irq *irq,
+					 struct kvm_vcpu **dest_vcpu)
 {
 	struct kvm_apic_map *map;
 	unsigned long bitmap;
@@ -1256,6 +1257,33 @@ bool kvm_intr_is_single_vcpu_fast(struct kvm *kvm, struct kvm_lapic_irq *irq,
 	return ret;
 }
 
+bool kvm_intr_is_single_vcpu(struct kvm *kvm, struct kvm_lapic_irq *irq,
+			     struct kvm_vcpu **dest_vcpu)
+{
+	int r = 0;
+	unsigned long i;
+	struct kvm_vcpu *vcpu;
+
+	if (kvm_intr_is_single_vcpu_fast(kvm, irq, dest_vcpu))
+		return true;
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		if (!kvm_apic_present(vcpu))
+			continue;
+
+		if (!kvm_apic_match_dest(vcpu, NULL, irq->shorthand,
+					irq->dest_id, irq->dest_mode))
+			continue;
+
+		if (++r == 2)
+			return false;
+
+		*dest_vcpu = vcpu;
+	}
+
+	return r == 1;
+}
+
 /*
  * Add a pending IRQ into lapic.
  * Return 1 if successfully added and 0 if discarded.
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 72de14527698..b9e44956c162 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -240,8 +240,8 @@ void kvm_wait_lapic_expire(struct kvm_vcpu *vcpu);
 void kvm_bitmap_or_dest_vcpus(struct kvm *kvm, struct kvm_lapic_irq *irq,
 			      unsigned long *vcpu_bitmap);
 
-bool kvm_intr_is_single_vcpu_fast(struct kvm *kvm, struct kvm_lapic_irq *irq,
-			struct kvm_vcpu **dest_vcpu);
+bool kvm_intr_is_single_vcpu(struct kvm *kvm, struct kvm_lapic_irq *irq,
+			     struct kvm_vcpu **dest_vcpu);
 int kvm_vector_to_index(u32 vector, u32 dest_vcpus,
 			const unsigned long *bitmap, u32 bitmap_size);
 void kvm_lapic_switch_to_sw_timer(struct kvm_vcpu *vcpu);
-- 
2.50.1.552.g942d659e1b-goog

