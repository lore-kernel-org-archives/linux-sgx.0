Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DDAF34404F
	for <linux-sgx@vger.kernel.org>; Wed, 12 Nov 2025 16:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762963640; cv=none; b=lhtOXDBXRz0SiaLFE0OIrDEsEhT7y+H6aDtYj2H8Q6LvZ4h/FHeBH63IvJoLkyoG0YpG0izZ0Dz7MwttwP5DfPeDxpMWf0g9563x23eIqydsk5OAA7n/19SahbM+9rrr+aNrMhyLH0BM9nSMoRu8Jpfqx21/d9HlbBFreY1B16k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762963640; c=relaxed/simple;
	bh=9acULfMg/Em2axGK9DycBu+aaZYt/pGLTnRxCeFygXU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=imyF+Ei2edeLc9KNSHBcGHYN+AGzqTt6U41verKweplTvEaQKByek639y/9ZIzpoyTs+eFxig6kRXRwvzm/6zR0kP+YhTG7GD12HDBto2Tyf8DYbSU1o+cinLI0lPt2V+To9Qh9N6vyt+i1DUWBj4r6K3FEpxc4KQFT7Zggy0OI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JMj5eyIc; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JMj5eyIc"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7b6b194cf71so1077461b3a.3
        for <linux-sgx@vger.kernel.org>; Wed, 12 Nov 2025 08:07:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762963638; x=1763568438; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=T0PD3WVE3Et8Mx4ML0jlkTqIwvMykTxKsHBXz3f7gqI=;
        b=JMj5eyIcEKjeKgi28k6lLCC/fBQF6evMjnHpYAQxQjyNNKSqIqDxwC5utZGkAHMJEk
         bHZ/XKEYlMKIgh1awBlpBeIYaFz6EWcXt6qZ/mdXR/encqDyGbPbT/JZ+ZLmDFjXCPun
         8g2OfmelWnXQfL+6soHfX+IoR2y9Ti89SGsru35ypdrLmv6wfazn91nos1ulrivyl4DL
         r4hegxToPOFzqajoBPxMY35fekZ8kb1j/NC0+lcjaZxdyj80AzUFzCpQ2Mel5C/ZxjLy
         ZXLyqInsG3T5pyqb7RDPyiB6BIZa0g4GrHzNSQEsMODQ7bHJLITpMMVu+q1R8GeZQOgA
         +Oxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762963638; x=1763568438;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=T0PD3WVE3Et8Mx4ML0jlkTqIwvMykTxKsHBXz3f7gqI=;
        b=tHBDjnGXGPQY4DOVcjfTLLGDm+ZB+BVLUl3sHDmULY41rCDNaPTaFgN/Q5BAJcY5kU
         QJ4hWsMKTggv6q6TbXsbri1MMeG/H6zuxzdT9zn6CmyqxkVzKevSLXl+g34KH8N1GTkS
         QdZKV1nPXdvHzt8xCXKcQUZDCOztn27PxUS8t69rQaEj4ewex9+V3UhIWIYEjSoKh4wW
         tkes8SnCUSwlHv0qvjhAvSlqzlqGk6rqm0a0SOe5xB3JveSh2Ya9c5Y1e4dcLC6LwLCf
         BjN4kiJuOHdT9EbABdQxJ2hHuiywzIGiTanurzBaEeuKCeklVD/kkU9Ms8iHql3Kz/Mt
         UZTw==
X-Gm-Message-State: AOJu0YxGKkOMw2zp2rWIZxhLrNdGXbGP3MqL11LmB8Z26ea6fetEIrxF
	eqa9R4mzZRMmZBbuC1ahg9D8KW2yF1QjHDK8ISBEfMDoANKjBKeV+QlFvWQrlNzFbqj6uv10zS0
	6LM+Hwg==
X-Google-Smtp-Source: AGHT+IEjXXyndI3uyYnz6VdwVRwrRE/2TwTE6PlHeOG9AsQOOA8swuLYcU/PB/iJul+vKtv3h6P+91qtb18=
X-Received: from pgbfe27.prod.google.com ([2002:a05:6a02:289b:b0:bac:a20:5eed])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:6452:b0:359:9d33:df08
 with SMTP id adf61e73a8af0-3599d33e666mr2467151637.18.1762963637808; Wed, 12
 Nov 2025 08:07:17 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 12 Nov 2025 08:07:07 -0800
In-Reply-To: <20251112160708.1343355-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251112160708.1343355-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251112160708.1343355-5-seanjc@google.com>
Subject: [PATCH 4/5] x86/sgx: Remove superfluous asterisk from copyright
 comment in asm/sgx.h
From: Sean Christopherson <seanjc@google.com>
To: Jarkko Sakkinen <jarkko@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org
Cc: linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Stephen Rothwell <sfr@canb.auug.org.au>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Drop an asterisk from a file-level copyright comment so that the comment
isn't intrepeted as a kernel-doc comment.

E.g. if arch/x86/include/asm/sgx.h is fed into kernel-doc processing:

  WARNING: ./arch/x86/include/asm/sgx.h:2 This comment starts with '/**',
  but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/sgx.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
index a88c4ab95edd..3c90cae04e1d 100644
--- a/arch/x86/include/asm/sgx.h
+++ b/arch/x86/include/asm/sgx.h
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/**
+/*
  * Copyright(c) 2016-20 Intel Corporation.
  *
  * Intel Software Guard Extensions (SGX) support.
-- 
2.51.2.1041.gc1ab5b90ca-goog

