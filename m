Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D024154435
	for <linux-sgx@vger.kernel.org>; Thu, 28 Nov 2024 01:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732757697; cv=none; b=s/qvZKU0yEZtN6ikMeROM1QZoSUrTH4kU4iDUERaYVSe5fOkYmqP2DFcjSxionRC24iKdCQK8du/GBYhcJnLqdsCHMSQi/+b2G9WlVf/QQ6/2tX+H6bsCMD4tVUBoNinvoQPDVJwgbNncsfdiyF1zPUXPPfgpK83XlbEjCMbfrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732757697; c=relaxed/simple;
	bh=cCzjC4QslD/KqAdNK1lM8kydPh8drtJSilkfvomxB/8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TLgIzBiwYaiYPtM4gOMBl22TVCVLWUpcekZisdJflVarHUjSh/+9NIdPAH5k4ih3gjguNJ1OJmct/jxBAcwZwV9aka49ibhMs+Fw22ug35iue3jGPZrIBnL7SFa7hv46E1QNJSnbRjusKkE2r+hBzmnEkvernALdTaUr7SrbPTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2iYahZLx; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2iYahZLx"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ea764112f8so512883a91.3
        for <linux-sgx@vger.kernel.org>; Wed, 27 Nov 2024 17:34:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732757695; x=1733362495; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=sp9eOls36k21Hyc+rIhk8dMf6G4N5uopLTx46a/Tt/Q=;
        b=2iYahZLxGVrISXzfgvYlOjYNh12+C5zGT/ouXhYyV93ViL48KCf2d3k8KMjX/W/Ld0
         yd0BhmAK849LMDWEKQ7xHGyu4iNmOS1UxIgkwaT0+3o5eTSMK6cyPtuQoVv5q63u2uXj
         alAXvPA+KMn8+7tpAxsRzKmJS5uhPoemE0oG91qPg3/312C/NzyVFdITYHxCJkyLPusC
         2vhOAE7mr6zYp5a6VNEbWm41dVTgNwBi19iUdv143Fo7dSasaeF83obhLbFMBY2ticTM
         i3QeIhlvEQjxGLOXbNPW23C6UsWfL8R4GhafMjtDQRU5+dBq0+vHPRxbHB57witJNFhW
         M6/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732757695; x=1733362495;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sp9eOls36k21Hyc+rIhk8dMf6G4N5uopLTx46a/Tt/Q=;
        b=O5J8QSQeWAcaG6QD7AXUL3orAz7O97PlU9lB+8DfIQZx/IV5e5+WkjFLuGvAjQ6GSp
         YGugSPb/QBUH6ewGpoQ+ZBWWvc43POoxty0U5b9bm0md5MHd5PEiDE3Vjb3XNpxhQbzY
         KqSsbasQhNGsUA931+RepTcjdcKwQr5xY1ms97cUCaR+8wtbF1EG4223rVuSik7+pbn/
         xcOieWwM9WtUlqRrJfh3hvhslxSvs9tL1/lqiU1Gtjvo3dKbl16FUJS8nUqpNjyZk9PT
         7/nlU0J6gOmSHdFZJv1eo3DYcoEslkmbMnFEhggdhybj3UEiXk7FLrh3QE39bQsWerYN
         UVNQ==
X-Forwarded-Encrypted: i=1; AJvYcCUmYjW1sNvHOyF7q9O4ok71pZ78238dGM8h1twH7M/QzjpZdg9IZZ9J21GnGV7gRTKy8QgTU39YadY=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywe9WgayFLe24iwakaFD0aqS9RL8qdb4N1q66ecjFh+DHD/jfgA
	3+y5qk62FXDXoGY1a7SXQpiiiC3uK4iwHJ6pcVUfFRdiYbtZgMcuvuSLcsirHtkOoofXEfHnUZ9
	mmQ==
X-Google-Smtp-Source: AGHT+IGO9Q3kCgpJXKULD4MEqTnIQSGE8dD295rZZOUbRTv4NavzTlV2QtpqP0cKFjK70el4RN+9Yiup058=
X-Received: from pjbmf12.prod.google.com ([2002:a17:90b:184c:b0:2d8:8d32:2ea3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:35c9:b0:2ea:4a6b:79d1
 with SMTP id 98e67ed59e1d1-2ee08eb2bdfmr7008969a91.11.1732757695158; Wed, 27
 Nov 2024 17:34:55 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 17:33:40 -0800
In-Reply-To: <20241128013424.4096668-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128013424.4096668-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128013424.4096668-14-seanjc@google.com>
Subject: [PATCH v3 13/57] KVM: x86: Disallow KVM_CAP_X86_DISABLE_EXITS after
 vCPU creation
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

Reject KVM_CAP_X86_DISABLE_EXITS if vCPUs have been created, as disabling
PAUSE/MWAIT/HLT exits after vCPUs have been created is broken and useless,
e.g. except for PAUSE on SVM, the relevant intercepts aren't updated after
vCPU creation.  vCPUs may also end up with an inconsistent configuration
if exits are disabled between creation of multiple vCPUs.

Cc: Hou Wenlong <houwenlong.hwl@antgroup.com>
Link: https://lore.kernel.org/all/9227068821b275ac547eb2ede09ec65d2281fe07.1680179693.git.houwenlong.hwl@antgroup.com
Link: https://lore.kernel.org/all/20230121020738.2973-2-kechenl@nvidia.com
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 Documentation/virt/kvm/api.rst | 1 +
 arch/x86/kvm/x86.c             | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 454c2aaa155e..bbe445e6c113 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7670,6 +7670,7 @@ branch to guests' 0x200 interrupt vector.
 :Architectures: x86
 :Parameters: args[0] defines which exits are disabled
 :Returns: 0 on success, -EINVAL when args[0] contains invalid exits
+          or if any vCPUs have already been created
 
 Valid bits in args[0] are::
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d6a182d94c6f..c517d26f2c5b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6531,6 +6531,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		if (cap->args[0] & ~KVM_X86_DISABLE_VALID_EXITS)
 			break;
 
+		mutex_lock(&kvm->lock);
+		if (kvm->created_vcpus)
+			goto disable_exits_unlock;
+
 		if (cap->args[0] & KVM_X86_DISABLE_EXITS_PAUSE)
 			kvm->arch.pause_in_guest = true;
 
@@ -6552,6 +6556,8 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		}
 
 		r = 0;
+disable_exits_unlock:
+		mutex_unlock(&kvm->lock);
 		break;
 	case KVM_CAP_MSR_PLATFORM_INFO:
 		kvm->arch.guest_can_read_msr_platform_info = cap->args[0];
-- 
2.47.0.338.g60cca15819-goog

