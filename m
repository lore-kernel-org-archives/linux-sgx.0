Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 590C5347BCA
	for <linux-sgx@vger.kernel.org>; Wed, 12 Nov 2025 17:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762969191; cv=none; b=CA/u7yjk+WmGpAoKchRKzPkqjNAybQzNB61TOiV0S6dX0BEFgHRWBsmcOu9YryeWcaKNTeAnwNldDHtG1Vvj8hSQIs8ML6KUY7QKCtqJzaGNpuh3UKYu7wxA6hxrynPHap5SohSM4hi3LzE97bsqk4+RzuvvC4RnZEECsC17tvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762969191; c=relaxed/simple;
	bh=3wjLaIqPwLhtaQu3sd4+Wy6uET4Lt+dOtxB/f9/oZG0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ep8pCl5+Ylih6KdK3K9tXQYqr4XQejB90gRwu11MkIrLbQDnfWRjrDa1bYSFJzU56Oj8KzNNypE1nz2eXv2HZM/n2dnUI7yCezU2/gA0XSiAfTEPZxPgrG0qVBpjPFhnC+E/WO7EBL02MIiMwpVBmcU605tV8Wd1IIyNBe0uv+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XE6L3XRY; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XE6L3XRY"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2982dec5ccbso23650735ad.3
        for <linux-sgx@vger.kernel.org>; Wed, 12 Nov 2025 09:39:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762969189; x=1763573989; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=B2W7BhYEA5i1i5woy4wPEVZBPGLjZrrhpv/7K43a+Bc=;
        b=XE6L3XRYIGnHXqzE2hZSNKwfPkIn+KABRpvnxQEPdhP4eA0mYWv2Mc2BVdivuxLdGC
         ZyUgylMBRHQymM1eD3cF0fpF5z5nj434JhRQjsYJ1aH/v+rzubvMv1HHU1vXM7BObPU1
         dLKdhw/05wX81YDE9rPIi6yMiWbYWC2cTVnK86ExM4NQpInpklfh+zQYq3mVYh7lv7ZU
         mDOXvlacBI6ZSswAXjmtkZAMa81eIEFBTASlnbKDUhjC7SD0EZVUunJzBsmV71JiNh7o
         G/Slb6srgBDzWkTVnEf7deRzZKKv8sGasq9mDjy5DiIuO4bJEkuOfb5PekIAfo0XX7z3
         ICtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762969189; x=1763573989;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B2W7BhYEA5i1i5woy4wPEVZBPGLjZrrhpv/7K43a+Bc=;
        b=M+t3xXhUDcTwn2u/HCZ5jciifQYp9HSXXvtLQfj4B6C6csE7b8kLhhyswh3yN6863t
         xfdsnEYouTB9NU9EvNBcEIQ4EsJaMoy1xwyc6LgjkfEnVxdevrt0r2A8yb7NCUPwvspr
         s7DSU6waxEEH9PjougtweEpYYC32ggiLjknqqMhbLxKsGpf9ZL7QdU4JlSEx0w9GeAiU
         srTQqgqzDQr+b/KWnpRt5I/gzCqCXzrSatOSMxZQ5h55Gv8SP5QrNmZGybuPrdppAuOW
         Cg9j10sEpKR/rkeRs7gFceUSfBa+VUz6aWC2TE51QQgLNaK1KnzRD7RSBjIN1CaY4oyL
         VnfA==
X-Forwarded-Encrypted: i=1; AJvYcCUrK7GitQalw3A3/4J7iGa3eKjrr/+kpgsWnTg7iFN6h0x5OiFpqFHWxn5BDj7/FY9yHqwGMdLb3lQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwABok7odg0AR644LPcBE0ltZ1RmSuVN0Y1sNTBFUu7/o3BkND2
	e6l1FUJpmenGY0vSzGuwEbVjMf2F8Wqv+mOfGFL2T1lXxJK7vtwUt8cg37e+B0Wizax0NNw5gUu
	wqer/TA==
X-Google-Smtp-Source: AGHT+IGQoB1Kabu3uhkCb7ua9Zbxd1SwMYzdy0+WZvzbXxJsOOkw0xVig1+MnTLbGmRa1/KiP7NDHIAhv+E=
X-Received: from plbks6.prod.google.com ([2002:a17:903:846:b0:27d:1f18:78ab])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d2c9:b0:297:e66a:2065
 with SMTP id d9443c01a7336-2984ee00891mr56835055ad.56.1762969188545; Wed, 12
 Nov 2025 09:39:48 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 12 Nov 2025 09:39:41 -0800
In-Reply-To: <20251112173944.1380633-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251112173944.1380633-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251112173944.1380633-2-seanjc@google.com>
Subject: [PATCH 1/4] x86/bugs: Drop unnecessary export of "x86_spec_ctrl_base"
From: Sean Christopherson <seanjc@google.com>
To: Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Xin Li <xin@zytor.com>, "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Jarkko Sakkinen <jarkko@kernel.org>, 
	"Kirill A. Shutemov" <kas@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	kvm@vger.kernel.org, linux-sgx@vger.kernel.org, linux-coco@lists.linux.dev, 
	Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"

Don't export x86_spec_ctrl_base as it's used only in bugs.c and process.c,
neither of which can be built into a module.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kernel/cpu/bugs.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index d7fa03bf51b4..57c1d0ed36a5 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -102,7 +102,6 @@ static void __init vmscape_apply_mitigation(void);
 
 /* The base value of the SPEC_CTRL MSR without task-specific bits set */
 u64 x86_spec_ctrl_base;
-EXPORT_SYMBOL_GPL(x86_spec_ctrl_base);
 
 /* The current value of the SPEC_CTRL MSR with task-specific bits set */
 DEFINE_PER_CPU(u64, x86_spec_ctrl_current);
-- 
2.51.2.1041.gc1ab5b90ca-goog

