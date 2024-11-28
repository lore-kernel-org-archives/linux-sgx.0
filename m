Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E18D13E49D
	for <linux-sgx@vger.kernel.org>; Thu, 28 Nov 2024 01:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732757690; cv=none; b=dWZWcpc3LHN5JDxP6Fmgy4saLvvs94iCx9+kvU8tqUVxdOYBR7+8M+HvvAiURXYvGuFUHnbVU1Qt3IbKJ+hoVnKfPiWKTc6C1XFy/x446v+UA8lp81sKOf5SKAYwf7R+zOXe+U1dill6oo+slqfm/qVwBRlhqaPqAZegnbJ0cJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732757690; c=relaxed/simple;
	bh=Zi6nLxvCtqg7sRDOs2S1uLN1ASc4dep+KLdJOASySug=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XsIByk3TReEeZtgS8g0+tFCr9IxJDO7UYHRBnphKrW2rSD2LH0zsFKh4DvBK4ZSvhXvGaq69LQA7SPcdaMbdnE4M6/e/psdl1QxEzbl5/sTEoPWAwroOoc5l7lTFUwGjYFwmOVawi9uOLL/ufJAMb5SNGd+lGaPywDscRlCYjBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZFJrUHej; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZFJrUHej"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-7fbbb61a67cso151178a12.3
        for <linux-sgx@vger.kernel.org>; Wed, 27 Nov 2024 17:34:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732757688; x=1733362488; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=imzmUI4pwQd0UqeKMzmq2IeaU1wm8Js0tpOStaLC/Qo=;
        b=ZFJrUHejVILf6u/DVmbe5F9msgvE3HIzxoejbPPpD8Y51fg2D1tRYuU5xqjF8vsiMc
         78/DSnhkaUEELbqqtPtDrCo3tA3wSYRNpUJB3oU1Si1sniJ+JxP4jBf4+ewivG37mQcf
         FPeFo8QWbsuPjyiGGesqg+lrWggZONOxCOvo+5mWJ6Qpmhk2VdTMojcfvjKMiiJRm2sm
         E3xZSPYrdwTpzeTLH3oujK4LXw7yPYN8jnZN+4dP15UJLWMsK2qYOg/8sS/ggJuEx9TO
         isvpUNHEz48WZD1am3H7ibYxza0hGRam8DOJU9JppMWUZV7WEpd0yy6Zo/zSwua/eM84
         SLjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732757688; x=1733362488;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=imzmUI4pwQd0UqeKMzmq2IeaU1wm8Js0tpOStaLC/Qo=;
        b=mZjw99WH438LaxCumeDDiDKZ3sgzN2ITxnKilc7oMU8OOy0H7npX0y7zIkDOM5PyMO
         n2RyPVtgn42B4DhyzcKDqkbL4Zwcc1ke7/FZpMbC9f/WpJTPO9Spy1OH68TBPj0oYN5n
         6+wNd/i4hGCR1TrS9ma2Ug4XLxD8wyyWaGInqDils6eOxZVsaBpmMwykIpML/K1OUYkH
         V3vOUgJeTOiiL8HGqf1qFIobTNduik6M+F3GwxDb6O8tq+ImZ+LoA0Bm7xHeuCONAHDV
         Xtv4vVZqZsDLGcStv6DepuX7WnA7B6jm4i9L/Lgm9XlcrHiAd/FmP7MTggbimg8c81NZ
         cAmg==
X-Forwarded-Encrypted: i=1; AJvYcCUSif/Yu/7fBXIE2pRMtWo4mtZxqQOZyI2kzMpgJ3G+zMF5Z7njuu2d1gNANG5c5SkS5W/Jgp4C3ts=@vger.kernel.org
X-Gm-Message-State: AOJu0YwnKTeIFoPuAuNa4YWwQBN3Z27+VqfZU08XPGRRZMZE1aq/YAv2
	rb0qE38f7rLhI1FdeNEEgLchDQGNk5zMXBz6Tq4I/Xisgb3ajX/gbCNS1qgTBJ7O/jFaEJeKpeU
	7OQ==
X-Google-Smtp-Source: AGHT+IHaM60Lr29ZkEqvcH1kdwSyGKEW3crO+fz+1pKWqPQXY9T6XKATriFjHO+n6jho2+7tLHiRqiLxy1A=
X-Received: from pgbfq20.prod.google.com ([2002:a05:6a02:2994:b0:7fc:2823:d6c4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:3291:b0:1e0:dde9:f383
 with SMTP id adf61e73a8af0-1e0e0ac69eamr10098846637.4.1732757687885; Wed, 27
 Nov 2024 17:34:47 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 17:33:36 -0800
In-Reply-To: <20241128013424.4096668-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128013424.4096668-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128013424.4096668-10-seanjc@google.com>
Subject: [PATCH v3 09/57] KVM: selftests: Verify KVM stuffs runtime CPUID OS
 bits on CR4 writes
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

Extend x86's set sregs test to verify that KVM sets/clears OSXSAVE and
OSKPKE according to CR4.XSAVE and CR4.PKE respectively.  For performance
reasons, KVM is responsible for emulating the architectural behavior of
the OS CPUID bits tracking CR4.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86_64/set_sregs_test.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86_64/set_sregs_test.c b/tools/testing/selftests/kvm/x86_64/set_sregs_test.c
index 96fd690d479a..f4095a3d1278 100644
--- a/tools/testing/selftests/kvm/x86_64/set_sregs_test.c
+++ b/tools/testing/selftests/kvm/x86_64/set_sregs_test.c
@@ -85,6 +85,16 @@ static void test_cr_bits(struct kvm_vcpu *vcpu, uint64_t cr4)
 	rc = _vcpu_sregs_set(vcpu, &sregs);
 	TEST_ASSERT(!rc, "Failed to set supported CR4 bits (0x%lx)", cr4);
 
+	TEST_ASSERT(!!(sregs.cr4 & X86_CR4_OSXSAVE) ==
+		    (vcpu->cpuid && vcpu_cpuid_has(vcpu, X86_FEATURE_OSXSAVE)),
+		    "KVM didn't %s OSXSAVE in CPUID as expected",
+		    (sregs.cr4 & X86_CR4_OSXSAVE) ? "set" : "clear");
+
+	TEST_ASSERT(!!(sregs.cr4 & X86_CR4_PKE) ==
+		    (vcpu->cpuid && vcpu_cpuid_has(vcpu, X86_FEATURE_OSPKE)),
+		    "KVM didn't %s OSPKE in CPUID as expected",
+		    (sregs.cr4 & X86_CR4_PKE) ? "set" : "clear");
+
 	vcpu_sregs_get(vcpu, &sregs);
 	TEST_ASSERT(sregs.cr4 == cr4, "sregs.CR4 (0x%llx) != CR4 (0x%lx)",
 		    sregs.cr4, cr4);
-- 
2.47.0.338.g60cca15819-goog

