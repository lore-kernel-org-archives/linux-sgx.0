Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7686142623
	for <linux-sgx@vger.kernel.org>; Thu, 28 Nov 2024 01:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732757772; cv=none; b=HTOEdvrgQOPaNn+kVUkmBMyOP6/638Xwpd3DJDsiQW4y4qy+FuJ6EpCvUhIqyiIiRV98MwgFrKhtH/1j2REAk52mkX3tSq4NqDXgUYF6Uh1POll0PBTRMkUKxZvDEkAIjv3g9xWJJuVpdwNV9YrKFSG2tA4v05WKsYlakM/5vW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732757772; c=relaxed/simple;
	bh=irc8Le9t/2+80quqPskqjkEtE694oI45PecCpS74YBg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=O79zdjD3MGJkhyJtEBOKqKbK+t4X9IOjdosdDFtWbQFu1cPGDgucfMH1X2FIoC+/wO8z2olNyUrZcCKdTq355hZz6YAxTUcsgJohOnDVc2xnIuUb6ZdGd5/vStJkmZWvYIPJXkug0LDFlKKbxZj5LGbDpKDj2S0Z9obH5skPNaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OIEvQn00; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OIEvQn00"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-724e565cd84so337439b3a.3
        for <linux-sgx@vger.kernel.org>; Wed, 27 Nov 2024 17:36:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732757770; x=1733362570; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=xiLgVENbF37xEr+aKdmhYet7DBz2tD95xIx77Ae2lio=;
        b=OIEvQn00827iLEQXgcIwh8NmxjnyWphh1J+qc7OFDnloylrYHz0nxSmg/UMCvwqh+g
         8PIEmmp4gGiGHKNnbYeClBhxIQxyA4TXedJNJLQDUI3VbKCZG+7QqAenG19ZS4oEzzRw
         bIaAZCaF8IGCfhPX6QnX9wjLuGtF7lYXabM/qbRT1B6x56aNK038btG1T5N0clSprLRy
         7W3JZ/f/sFK/u4XHQl0n/rEb2vG406uls/jN7VwbPzlmPNUynVoFqSpSHjWtj50TUDIh
         eRtpPDKUnMU8MpZ/QPVhVoeOAD66ykvi3/OnhTcEqezt+nl2L4AvHU4LBaneR6a+SSLq
         pAoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732757770; x=1733362570;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xiLgVENbF37xEr+aKdmhYet7DBz2tD95xIx77Ae2lio=;
        b=uuhB0yQEt8C4nYrPbfLLS85uiGQp7LyrSgyyYSmUzZnDlCgEEjBqgahFGJ5vTv+iI1
         H533uI/GUGCXWjS82ZOXbV3GJTH2LfUYy1oqUri4fVjnf1VFS4/NuGjZiueHHb/4t6wk
         DMHllsREodnyXvlzPIVrpYokifpjvapWneWYWPXiYTVNXogX7MSfzP7N+VkJJadS9Xqd
         w/dDAGT3Z5aWoEjI9/1/Il4m4qHg4Q5ptxJuKbdlA/eRPBHNpDxGeUvhAQddxZsBP8EQ
         eSd+UDCmNHt9tIRafVA5trnUliu0BdAIISFOfEj0VFfcCVqiE3vJNYXp9V8cIka6BEWD
         +gPw==
X-Forwarded-Encrypted: i=1; AJvYcCWqwFh6uegV8m1o4F0r3egcKDYlx6qgjmW+A4BUSpz7tV/ibfAhqdevedXRrQ68j0yjpVO9jIPZ2+k=@vger.kernel.org
X-Gm-Message-State: AOJu0YwArpwLhjbNg8ltvP4gfMB999At6iTuEX/5/4TjtYCbIyvOAABm
	euD78nzcjnmUF1tgSAFMbrBFPTr/hUNPLHxfi3xHPlgtk23gD8m+JJFQ45fWvzFz8mk6mFB3H9G
	udw==
X-Google-Smtp-Source: AGHT+IEoKJQaztiJQlzcINhEIAOdgtyjmMRnP8Lc1kKByNnQDVZuqJkARQENGVuqU8UB1VFBKIBP49R5j7M=
X-Received: from plrj13.prod.google.com ([2002:a17:903:28d:b0:212:3bf9:5eb6])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f705:b0:212:4c71:fef1
 with SMTP id d9443c01a7336-21501f77c44mr68213195ad.56.1732757770039; Wed, 27
 Nov 2024 17:36:10 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 27 Nov 2024 17:34:23 -0800
In-Reply-To: <20241128013424.4096668-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241128013424.4096668-1-seanjc@google.com>
X-Mailer: git-send-email 2.47.0.338.g60cca15819-goog
Message-ID: <20241128013424.4096668-57-seanjc@google.com>
Subject: [PATCH v3 56/57] KVM: x86: Explicitly track feature flags that are
 enabled at runtime
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

Add one last (hopefully) CPUID feature macro, RUNTIME_F(), and use it
to track features that KVM supports, but that are only set at runtime
(in response to other state), and aren't advertised to userspace via
KVM_GET_SUPPORTED_CPUID.

Currently, RUNTIME_F() is mostly just documentation, but tracking all
KVM-supported features will allow for asserting, at build time, take),
that all features that are set, cleared, *or* checked by KVM are known to
kvm_set_cpu_caps().

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 5ac5fe2febf7..e03154b9833f 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -768,6 +768,16 @@ do {									\
 	0;							\
 })
 
+/*
+ * Runtime Features - For features that KVM dynamically sets/clears at runtime,
+ * e.g. when CR4 changes, but which are never advertised to userspace.
+ */
+#define RUNTIME_F(name)						\
+({								\
+	KVM_VALIDATE_CPU_CAP_USAGE(name);			\
+	0;							\
+})
+
 /*
  * Undefine the MSR bit macro to avoid token concatenation issues when
  * processing X86_FEATURE_SPEC_CTRL_SSBD.
@@ -790,9 +800,11 @@ void kvm_set_cpu_caps(void)
 		VENDOR_F(DTES64) |
 		/*
 		 * NOTE: MONITOR (and MWAIT) are emulated as NOP, but *not*
-		 * advertised to guests via CPUID!
+		 * advertised to guests via CPUID!  MWAIT is also technically a
+		 * runtime flag thanks to IA32_MISC_ENABLES; mark it as such so
+		 * that KVM is aware that it's a known, unadvertised flag.
 		 */
-		0 /* MONITOR */ |
+		RUNTIME_F(MWAIT) |
 		VENDOR_F(VMX) |
 		0 /* DS-CPL, SMX, EST */ |
 		0 /* TM2 */ |
@@ -813,7 +825,7 @@ void kvm_set_cpu_caps(void)
 		EMULATED_F(TSC_DEADLINE_TIMER) |
 		F(AES) |
 		F(XSAVE) |
-		0 /* OSXSAVE */ |
+		RUNTIME_F(OSXSAVE) |
 		F(AVX) |
 		F(F16C) |
 		F(RDRAND) |
@@ -887,7 +899,7 @@ void kvm_set_cpu_caps(void)
 		F(AVX512VBMI) |
 		PASSTHROUGH_F(LA57) |
 		F(PKU) |
-		0 /*OSPKE*/ |
+		RUNTIME_F(OSPKE) |
 		F(RDPID) |
 		F(AVX512_VPOPCNTDQ) |
 		F(UMIP) |
@@ -1189,6 +1201,7 @@ EXPORT_SYMBOL_GPL(kvm_set_cpu_caps);
 #undef PASSTHROUGH_F
 #undef ALIASED_1_EDX_F
 #undef VENDOR_F
+#undef RUNTIME_F
 
 struct kvm_cpuid_array {
 	struct kvm_cpuid_entry2 *entries;
-- 
2.47.0.338.g60cca15819-goog

