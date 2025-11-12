Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FCA2343D75
	for <linux-sgx@vger.kernel.org>; Wed, 12 Nov 2025 16:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762963636; cv=none; b=KAx/tG/8pBFX78UREiAPX2y1HJURbai7TuzZqUBeKKW+WPCAWTi4k2RjXw9Ck9EiqjodzZy7hUIz92vXYcWqnfWIKgfFk9BOer3BVD/ibX4fq34jho8imTvAaC4CRmPQ9ycI7eNFjLlGIyzMe7fo53jP6VzXIvq59fnQzHzzdDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762963636; c=relaxed/simple;
	bh=vfPFTFts+O9/qnjhFzifocpQWwiaPjp7RusofTyF4ak=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=q/HFDQHKFqiAlnlNLCDRCaUyzohGdzY2m2yi5yK8Moc1LlJe1vQ1OGhNn9MHjd4QM1ohgSLlqBanlMwIzIdwod8N1Oj/dmvZFzJa7Yiim53+mGL7fi/FAho7vTL6odKhQx1eaVCW0M1GiocOq1D+2hu9mkhbiVTtfX62rEZsRM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0V6+CXFL; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0V6+CXFL"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-295595cd102so23465455ad.3
        for <linux-sgx@vger.kernel.org>; Wed, 12 Nov 2025 08:07:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762963634; x=1763568434; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=FfunJ/ItZMKzoPtNCzcWcDET3PL8bYrh6b1GoUKPhWM=;
        b=0V6+CXFLAGtOl4I/o8dh93du4E0qKRnFrClLo8Oz9JVvCDlZ4uEnBHyHK5vJ6Y0GFi
         0/gy9h7YnqoDlyIkZxOHhWIofDUrzUBVffk5wokCTGLWRB1bJfhQZA07LJW7Umxg7SRk
         DtPrr6f3vyD6EOjDgD0XQwnPUrfZnhdZzMEm3QRKWJ+B+VxNM3Rv6alCCIZs1azKtMLP
         ZHSUlznz0MdDldyLiIemk6zrvI85fDAJpCNlDwjQmJtt0cqK0RFEvc7g7hvh2z45Acj5
         5jaNvP22dw/OwuM6zlsI9LGV8DwLSMBpDbjrs9nZfF+DcgJYe0W+PeV4YLPbDNUvIoYC
         hl3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762963634; x=1763568434;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FfunJ/ItZMKzoPtNCzcWcDET3PL8bYrh6b1GoUKPhWM=;
        b=i6LWmcZtmo5zwq/67YHvqVEgdzoiq9T9+BmE3MlAeeSkv7akCdEj+CRXIYdmEbVtA1
         5mCqGONpe/pBbKyZMiQd8J/THS/IYKqROQOzmzrNzCBtGVtzT09xKu0Ah0XdsuNKwO2x
         v6EiXgRMt6COxl7/VeluMtSVXJc4B7cLyQarL0b3kG04NnLd1XhTjuuz1oK4vvsCLA3J
         5YjeaMtmdUu3FyqytCfKZ+dF34wMvdKdsEZDQn3kjTNJ9nCQrShxWg2y1WU8vRsqVxCd
         w4yc9KMtbGFkOzmChYvNr2NQmfZvlglv6gbPb+aFrtHHT8GdP7HA4BWIeJmL6+f85apK
         uyVQ==
X-Gm-Message-State: AOJu0YwCiuUxA979OxaH94l4FR9E0SuuMEoYa8V9UVNwXoQy40l/KAF7
	YJaomH6KBSkvfFvSCdsaFVKuLU5WlIdXWPSGwliK+Z2RHd+cv0+5j+YbgL548lglotfcWZUdjrv
	pcZXqLA==
X-Google-Smtp-Source: AGHT+IGPM+FL5iDTJezPnnxj3ZrI7o/h1RB9PJEV738qzsyjTKGBwTcX5RKvAm11TxhAvf6YY9dkHxnyxDY=
X-Received: from pldo20.prod.google.com ([2002:a17:903:94:b0:297:e751:aa56])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:3c4e:b0:295:5864:8009
 with SMTP id d9443c01a7336-2984ee03287mr41328465ad.44.1762963634199; Wed, 12
 Nov 2025 08:07:14 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 12 Nov 2025 08:07:05 -0800
In-Reply-To: <20251112160708.1343355-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251112160708.1343355-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251112160708.1343355-3-seanjc@google.com>
Subject: [PATCH 2/5] x86/sgx: Add kernel-doc descriptions for params passed to
 vDSO user handler
From: Sean Christopherson <seanjc@google.com>
To: Jarkko Sakkinen <jarkko@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org
Cc: linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Stephen Rothwell <sfr@canb.auug.org.au>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Add kernel-doc markup for the register parameters passed by the vDSO blob
to the user handler to suppress build warnings, e.g.

  WARNING: arch/x86/include/uapi/asm/sgx.h:157 function parameter 'r8' not
           described in 'sgx_enclave_user_handler_t'

Call out that except for RSP, the registers are undefined on asynchronous
exits as far as the vDSO ABI is concerned.  E.g. the vDSO's exception
handler clobbers RDX, RDI, and RSI, and the kernel doesn't guarantee that
R8 or R9 will be zero (the synthetic value loaded by the CPU).

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Closes: https://lore.kernel.org/all/20251106145506.145fc620@canb.auug.org.au
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/uapi/asm/sgx.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
index a438ea43bfd1..0d408f001ac6 100644
--- a/arch/x86/include/uapi/asm/sgx.h
+++ b/arch/x86/include/uapi/asm/sgx.h
@@ -143,6 +143,12 @@ struct sgx_enclave_run;
 /**
  * typedef sgx_enclave_user_handler_t - Exit handler function accepted by
  *					__vdso_sgx_enter_enclave()
+ * @rdi:	RDI at the time of EEXIT, undefined on AEX
+ * @rsi:	RSI at the time of EEXIT, undefined on AEX
+ * @rdx:	RDX at the time of EEXIT, undefined on AEX
+ * @rsp:	RSP (untrusted) at the time of EEXIT or AEX
+ * @r8:		R8 at the time of EEXIT, undefined on AEX
+ * @r9:		R9 at the time of EEXIT, undefined on AEX
  * @run:	The run instance given by the caller
  *
  * The register parameters contain the snapshot of their values at enclave
-- 
2.51.2.1041.gc1ab5b90ca-goog

