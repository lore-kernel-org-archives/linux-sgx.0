Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A641719067A
	for <linux-sgx@vger.kernel.org>; Thu, 28 Nov 2024 01:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732757702; cv=none; b=fXkq2UXtMzTOJPHGdnVVOSDmFoTU/7M11cpKT6e7O3TM+nMy7Mhzrt4SMZeYdBKpJHVa+XD+xzmkfFtrBX0MZFPk4cSc4pI2fPpuWrU4KoeaTgRch/OayxyWg6q50zhV3wC4uOVQ0lDOcOsBiOpwCFXi+IP+bfQox2rS6LHfdGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732757702; c=relaxed/simple;
	bh=cbbs+IW/NbNg8bOD1ExLdSHyieLi+4CBsRm7uNwsQy8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=d1MTqTED8HCZ/wJZrLN26heNvQL47FDpymYRGnn0QxZAXldubHCU1owVsFduDLJei1+oZ8Eoxf2xV1J+xZQYx3959GFcHQhNTReu+bzj/Wf8X/dhxnwh9VIKlsEUYNSnyReo5oOLlXwKZIL6+YhhoqXA8rVeGvpIpI3XW+2JoPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=y3ASrgPh; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="y3ASrgPh"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2ea9d209e75so329853a91.3
        for <linux-sgx@vger.kernel.org>; Wed, 27 Nov 2024 17:35:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732757700; x=1733362500; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=tkIRJi9hWBp1lddY87MgHAVSYrJKfSqjaHK6jf7PQL8=;
        b=y3ASrgPhyGBZqGT11pGYHcTavzPxvP/+RxcvCCpUZG5JSvIpBXrjy1llnSLzHnVx0k
         8n4C/44pxBlSC3wr4jyrkeJWURApGJR+5dnDY3QopB49TRpnXIuK1H/UDDE73PFt0tXi
         zbGCOPO55e9vhU705cF/BSy2o3+HHtMz4+aJYZWMAu5+7uw6uThP6PSWpgK8wwcTH/oU
         AClydoJ95H4LCFYa6aaEGcKIg+CpXk35fvvhS5Bbaz+WcLdoUlWfYTmcRRUYgYb/URkd
         FivY0ybGIl3VuuT/2gBhkWHK2h13tNjGtNNBoZp4ouWAKMi0ldomO4QUPglJsMLlFA1x
         lrkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732757700; x=1733362500;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tkIRJi9hWBp1lddY87MgHAVSYrJKfSqjaHK6jf7PQL8=;
        b=qZT7pxTJqKs4yLVpPm/VvI2NTVoBiX0+v3lOJjYKg8AqgWrhB13Cjd3+TcDKYzuk6V
         9/D6vMvQyxdKXEB42rdYNcvp3i1Ef72NwOAgwRlxpjn+umqjfsq70dEP14lABtXSjO4A
         tRCQtSOVxIZIzThI2ARVACYh8BfvQNsrahBp3947H9BNl7jIanhm5ym3/FPMctWnQL+I
         UpnopANDGHlYkWesw1dz0qZiz1ofu2p5dzy9Lw7QkpnFJAig1/lA3z4/qmLUo0PqskLL
         0RA7xXxkRUqX/wOyeTiVf7BIpjwc09lEOKc3/GVXeX7nPwwwAT+qybLjPUvTEKCBCEe+
         3RvQ==
X-Forwarded-Encrypted: i=1; AJvYcCWCide0Hanb7kLwx97xOirwB3DpWvRU0rIjGY2Zv6eAuO1H5mEK5ysrw8Hexav2MHLUXsqWSEBHgN4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyFF7gRRCX0bAcsHtzR8zet5r3rv8Py6+OKfJSjoqGQkD2S2PTQ
	Zq6F6GxZtj/MXQu0KphYGII7xVFKutdXQpSClAkOPcci3shtRm1vgfAcgt1tgwvPf2RXMUKLTcR
	ewg==
X-Google-Smtp-Source: AGHT+IHj7bunZqsrMJqyJ0DOJh4l8WYWBGi8wZuUkIl5BQnppNnhNxCcsaMgndMNUNsLOrxgCJY9E8zR6MQ=
X-Received: from pjbmf12.prod.google.com ([2002:a17:90b:184c:b0:2d8:8d32:2ea3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4b91:b0:2ea:3d61:1848
 with SMTP id 98e67ed59e1d1-2ee097e33d4mr5931840a91.34.1732757700100; Wed, 27
 Nov 2024 17:35:00 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 17:33:43 -0800
In-Reply-To: <20241128013424.4096668-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128013424.4096668-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128013424.4096668-17-seanjc@google.com>
Subject: [PATCH v3 16/57] KVM: selftests: Fix a bad TEST_REQUIRE() in x86's
 KVM PV test
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

Actually check for KVM support for disabling HLT-exiting instead of
effectively checking that KVM_CAP_X86_DISABLE_EXITS is #defined to a
non-zero value, and convert the TEST_REQUIRE() to a simple return so
that only the sub-test is skipped if HLT-exiting is mandatory.

The goof has likely gone unnoticed because all x86 CPUs support disabling
HLT-exiting, only systems with the opt-in mitigate_smt_rsb KVM module
param disallow HLT-exiting.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 tools/testing/selftests/kvm/x86_64/kvm_pv_test.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c b/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
index 78878b3a2725..2aee93108a54 100644
--- a/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
+++ b/tools/testing/selftests/kvm/x86_64/kvm_pv_test.c
@@ -140,10 +140,11 @@ static void test_pv_unhalt(void)
 	struct kvm_cpuid_entry2 *ent;
 	u32 kvm_sig_old;
 
+	if (!(kvm_check_cap(KVM_CAP_X86_DISABLE_EXITS) & KVM_X86_DISABLE_EXITS_HLT))
+		return;
+
 	pr_info("testing KVM_FEATURE_PV_UNHALT\n");
 
-	TEST_REQUIRE(KVM_CAP_X86_DISABLE_EXITS);
-
 	/* KVM_PV_UNHALT test */
 	vm = vm_create_with_one_vcpu(&vcpu, guest_main);
 	vcpu_set_cpuid_feature(vcpu, X86_FEATURE_KVM_PV_UNHALT);
-- 
2.47.0.338.g60cca15819-goog

