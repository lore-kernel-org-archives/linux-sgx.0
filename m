Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444B6341653
	for <linux-sgx@vger.kernel.org>; Wed, 12 Nov 2025 16:07:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762963634; cv=none; b=Z/UOSqwz5h7Sp0WnV/fTkQskvDtVq4qOSP2bH0V2u4c2h7lS9ewQvdmjyWoPH2PVbSjbnWvGrURQxYJ8w3KL1M/V1dyjo5QklBPqrlW7DYNUly4jDxH/Uv6K4H6PE2HGOCI86IlaivezH7XZ+Nmx89B9BjAT9UDtQlDeZ7Zfums=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762963634; c=relaxed/simple;
	bh=FWETxRtMVjkLK+WfqnbYriRIlbE+xBHWvnDlkLiYk1Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=C42A/3uCwobNo/RkP2vjKMumrnnFvxkcgakzKyJUQj/7R7U5YXl2Sya12yvfVZwqHncDBjx4Lw1lUQAWcJrXwR3jHV+xRxQULEp4oa87Fyxd4RROe1gpokB3q2N8s1QbPPyCJzkwNXopJB45QmF48Dr8U6BhdYO3lvWIS2RRbzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WnHC4DSp; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WnHC4DSp"
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3416dc5752aso2543924a91.1
        for <linux-sgx@vger.kernel.org>; Wed, 12 Nov 2025 08:07:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762963632; x=1763568432; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=eTjoKHmggOYgTdGIQs6uKfwAZuQVBnxqpwF3nx2QCb8=;
        b=WnHC4DSpUfKJhsrRGPaaQ+CzvM+A6EP8PztrnUZmOFMoK6rBZDY/JJlvVrF8CRWoyf
         HirmaA2stDhrnK+fUM8O2l+izCeZFQDGo2Bol48Q60CVVt9J8Oiy6S/DuoFSM5JTk7FP
         2yNUbwTWbYg96JlI+HFWqE153YaSmSVqfUI9dTdhEpaq5JKV5I/8VXalYqIZpoLVxtO0
         KTJL4VQ2EC4i7kj/uKserRpZ1L/idhNNqARjT4GNFD5uFZ7XJ+ZaO/ZG7o1cG/rxaLlu
         cn1SM0QGrbmvhEfVOyOgr8Xq00u0Dmwp77Pvxg6iD4XjK9gRGYVAYeKBzZZj/Ju+ZAIV
         zQJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762963632; x=1763568432;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eTjoKHmggOYgTdGIQs6uKfwAZuQVBnxqpwF3nx2QCb8=;
        b=kuc7L4IZhRUOjhvEQwfnxj3p1dKFN7KDqgB3K9ukaXkDiwQoV4PSk0c3JXnUIT3Sf4
         6EisufjAIU2IxYvHGzZsb8K20LUp/KUcwTOxoUiUMRK+8uPPwSZOg7+yRx7NVN4qWYWg
         IKJF1hEaRvW3CT1XlFDD5qqEQqe6onrVuJ4K65FCFEtP0TsLl9O4u1Q0ThuPJ43vYPUk
         cXXNKBFSojA9N3QCjeE/uc9zi/HemGtIwQkxq+1IP6rWcrbJ8p7RSyLDTB3ewbAa29Rx
         d+QlxriZ9knnVIt0tLHTIgoXJlP0EafvwcOsHjX4hGKpKL1Mx7UwZ17BUsUImlUkJuqE
         5B/w==
X-Gm-Message-State: AOJu0Yyf5FDC2xZlJjgjQWSg0Dpxpjuufcgq4v2XgfZ01g+O8dVHoLcb
	J+DvbWFDRnIMuFjxjXIY/UlfywycadjIgchUipzXmE+8vp9jF/bGWm7f3LvLgysGtG1Avcmjzyf
	qHdQ4Zg==
X-Google-Smtp-Source: AGHT+IHJZKkEiToM4fKaG/NQNsxc49aGGeWBuNh03TBSSQJQx8lPhD3KWW6Av/PBLEC9yzKJDa1KrmBSRaU=
X-Received: from pjboj14.prod.google.com ([2002:a17:90b:4d8e:b0:33b:c211:1fa9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:bc9:b0:343:e082:b327
 with SMTP id 98e67ed59e1d1-343e082b6ffmr2584900a91.31.1762963632513; Wed, 12
 Nov 2025 08:07:12 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 12 Nov 2025 08:07:04 -0800
In-Reply-To: <20251112160708.1343355-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251112160708.1343355-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251112160708.1343355-2-seanjc@google.com>
Subject: [PATCH 1/5] x86/sgx: Add a missing colon in kernel-doc markup for
 "struct sgx_enclave_run"
From: Sean Christopherson <seanjc@google.com>
To: Jarkko Sakkinen <jarkko@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org
Cc: linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Stephen Rothwell <sfr@canb.auug.org.au>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a missing ':' for the description of sgx_enclave_run.reserved so that
documentation for the member is correctly generated:

  WARNING: arch/x86/include/uapi/asm/sgx.h:184 struct member 'reserved' not
  described in 'sgx_enclave_run'

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Closes: https://lore.kernel.org/all/20251106145506.145fc620@canb.auug.org.au
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/uapi/asm/sgx.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
index 2dd35bbdc822..a438ea43bfd1 100644
--- a/arch/x86/include/uapi/asm/sgx.h
+++ b/arch/x86/include/uapi/asm/sgx.h
@@ -166,7 +166,7 @@ typedef int (*sgx_enclave_user_handler_t)(long rdi, long rsi, long rdx,
  * @exception_addr:		The address that triggered the exception
  * @user_handler:		User provided callback run on exception
  * @user_data:			Data passed to the user handler
- * @reserved			Reserved for future extensions
+ * @reserved:			Reserved for future extensions
  *
  * If @user_handler is provided, the handler will be invoked on all return paths
  * of the normal flow.  The user handler may transfer control, e.g. via a
-- 
2.51.2.1041.gc1ab5b90ca-goog

