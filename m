Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7B202CA6;
	Mon, 16 Jun 2025 08:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750064243; cv=none; b=puVtHIuFGhHUYV5h3qB/FaxHOg/G9LnoAYuCCHsV45gIcCTaC6xtFzHsiBX9LVAQ7101JTsuAVatAmUAWdoiV5N+xkCHRGusOfCXxz6oDgMo0WpIb89yqy/hFtkCpFxGOWzGRH9RwF8k5tVr3W2AVDSZ7uVC49Bie7fCYNXmigM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750064243; c=relaxed/simple;
	bh=CqQ87G1jjSB916VbM+zoGqGvHGQLsT9gACIfn9oGmiI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZnvhhxLIJEBZw+o/ek1Ed57kk5+Zmg0M1Ng7ryQdKMFA/etJ+dSq61ED25JncK1hF6rR3wUa6b387/JuO4ai/2Y7o+xNcKTjf3YlsnV2I+wgdt7+NKsqYTuQLyInagEhpgLaW2Hu1mjCp3RNRaCRE0RKeYHQZb87TrOhXFgGMsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DpaSMUPX; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DpaSMUPX"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-450cf0120cdso35266145e9.2;
        Mon, 16 Jun 2025 01:57:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750064240; x=1750669040; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=j9N/o59/xcktnPqfjOETZR6SArTa1DX5q/Dr/VTcZ8o=;
        b=DpaSMUPXWEviKq+2e2YT79TZthQjpAThzQmk13BmysUTdSiRJnxsWo9IK+3xoIcjBw
         DllKBNkSMIrQxv6BNb/M8E8ZTfk2b/T+Zh+6ZZdQj3Jg0s6otVhrOKPjRPyZRbvBH4nV
         TeXmNZTzMbLdvhngprjr9O9G80Fufc6yugatkJWPPWH+Cc/NF7XyAEL/+qk8LpjRdxWd
         kTvy/I6r8VfWlf8+nk47XwwnGS2HbKALWErrhPI3aYUxeoKODKcStHyr5zzEOQ/WU1r9
         5szuQcdfJSpUzHMdMVAop9IvAU2ECXJBRnYfbWQAE6ITxD1G7nAjYIVCvCFpibIkfz2v
         eACQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750064240; x=1750669040;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j9N/o59/xcktnPqfjOETZR6SArTa1DX5q/Dr/VTcZ8o=;
        b=JC3XkW/TKbdjeWyUKm9AEOaGQVZii9jyX7QH2UjON7ZB1bqkVsjZSVnjWKB5crbOu2
         1kZutZ8RSctLeuB9dGN7c4aPKo/cSevnbyUOoaHBn9uJEfmmyTkMt245SnYBxe3FrNr2
         XqH6ImPO4m/bsajs9uUVvtmheKnlPmlc3sguAzfXV55bIRz39reA28G9oGV91CAahGkQ
         6z0PFDRtMw8uixBsTWpF/9nDzjE6zVFHztMYJxoZGJ7d8BeA2gwdP7DLa0vAYStcWY3t
         9dBAerm5qBmphxcXBKx6YumQHYnfYikqZHZ9QQkhil2QS/i8d1J51YnZjnktKxET0iN7
         +PiQ==
X-Forwarded-Encrypted: i=1; AJvYcCWyNpKjTXx8K4ScjwxQgFQmrWoVFQb2RguEaGxmVgn1PhWd0f75x2F2/k/XeQQC6hd4tX2lVqjzdkFA2p0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxAFQvjQjmYK57VkHa9LNTATrtInZ2DgeM/2bH3DvU9d1lr6+Tq
	AAERo74GMENX7tWrqIdb0vrO7tL2YntPHrJNQPc1YvWV2FnvS/qf0ZJYe4yPrQ==
X-Gm-Gg: ASbGncuFeM9OuIM+ow/fjrxIQh+noRFpxL0WMW9rugZacWUSC7M3USQvwYu20ozf+ZY
	hcDPybNdmhsSKyjGjY7SXfn56N0yoTRZSUaNf0cogpDnJUVoGTD4EKRBttTq5JJqbGo1dptgymH
	QMiDp/gCcMh7CRPgY89768LImVmjnuJQZXoSj16o5gLyVs2bOrC31Bj5M8EEdM51TKiWQBMT2j0
	55RvIwRKHc1j7RfKYdpgz/pLa7phjqDrKoTWiWk1USdc2XaO56p6mmhJRrjhgy4oUvuDxDF9sNS
	45E2OH0fo0bCX8h6XNXsc5jndnMbTtrXicnY5aUxBn5iZG9JX9XSXA==
X-Google-Smtp-Source: AGHT+IFa1Ihe2CVKyT4tc/Oeq3Mi/wDbp85LZDN+gMmAzY9OsWuUt3ofEQcKyKTe9m+sE7hk8x6x4A==
X-Received: by 2002:a05:600c:c16a:b0:450:cea0:1781 with SMTP id 5b1f17b1804b1-4533caad471mr78889775e9.16.1750064239609;
        Mon, 16 Jun 2025 01:57:19 -0700 (PDT)
Received: from fedora.. ([193.77.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a578510edcsm6431446f8f.8.2025.06.16.01.57.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jun 2025 01:57:19 -0700 (PDT)
From: Uros Bizjak <ubizjak@gmail.com>
To: linux-sgx@vger.kernel.org,
	x86@kernel.org,
	linux-kernel@vger.kernel.org
Cc: Uros Bizjak <ubizjak@gmail.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH] x86/sgx: Use ENCLS mnemonic in <kernel/cpu/sgx/encls.h>
Date: Mon, 16 Jun 2025 10:56:30 +0200
Message-ID: <20250616085716.158942-1-ubizjak@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Current minimum required version of binutils is 2.30,
which supports ENCLS instruction mnemonic.

Replace the byte-wise specification of ENCLS with
this proper mnemonic.

No functional change intended.

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---
 arch/x86/kernel/cpu/sgx/encls.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encls.h b/arch/x86/kernel/cpu/sgx/encls.h
index 99004b02e2ed..42a088a337c5 100644
--- a/arch/x86/kernel/cpu/sgx/encls.h
+++ b/arch/x86/kernel/cpu/sgx/encls.h
@@ -68,7 +68,7 @@ static inline bool encls_failed(int ret)
 	({							\
 	int ret;						\
 	asm volatile(						\
-	"1: .byte 0x0f, 0x01, 0xcf;\n\t"			\
+	"1: encls\n"						\
 	"2:\n"							\
 	_ASM_EXTABLE_TYPE(1b, 2b, EX_TYPE_FAULT_SGX)		\
 	: "=a"(ret)						\
@@ -111,8 +111,8 @@ static inline bool encls_failed(int ret)
 	({							\
 	int ret;						\
 	asm volatile(						\
-	"1: .byte 0x0f, 0x01, 0xcf;\n\t"			\
-	"   xor %%eax,%%eax;\n"					\
+	"1: encls\n\t"						\
+	"xor %%eax,%%eax\n"					\
 	"2:\n"							\
 	_ASM_EXTABLE_TYPE(1b, 2b, EX_TYPE_FAULT_SGX)		\
 	: "=a"(ret), "=b"(rbx_out)				\
-- 
2.49.0

