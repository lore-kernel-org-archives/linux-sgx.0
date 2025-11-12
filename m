Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C77350281
	for <linux-sgx@vger.kernel.org>; Wed, 12 Nov 2025 16:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762963641; cv=none; b=HJ8dsPs5X15kqO7kJMpue96QiXqvLVEGwbbgHSbKavrhYnbVuUMaXuu6/aKN1v/W8MPr7qCEOTDPd8HnFiFuOKiab7I7RR8P1fPKDIv+4l/dko9pGoO9BJXI2RuEKbfw7DUcxSqLgUTkX9K930KP+ivmActBT11xrHD5V2bRZg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762963641; c=relaxed/simple;
	bh=/JOce5MvxYjnhG+9whc6YtktzEE1MUnOCL4g++H5Qvw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TP1qEXppQph59FGpEtta5WIjzt4tCFZDvS3SriHy9ZqreVWIQreU4j+3/23v9i8XekRom3gtLTFNWb/J3N8SDzAvNEUC4Edomi8q5VYg5YlZwh2kOuvfJMfINbmdyX3uN+ma5xABNSW1Yb+hqSVjbxO4kSUHHn5DnuwGFHthXgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rMMomRg3; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rMMomRg3"
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-343daf0f38aso1405877a91.3
        for <linux-sgx@vger.kernel.org>; Wed, 12 Nov 2025 08:07:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762963639; x=1763568439; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=NeRxT3I5fTlFPGzsOfdrv5zO/0SPs+Jxk1vfyCkm7NQ=;
        b=rMMomRg3V7MAGEUJ+gtjOKRCAO/apCDGxAXR3U04svMHL3XtFAC/cv43G1kIjvfTAj
         fQj2HGJUrw5/mwJouqNy3Oqrogas7AvAOyoHbF18sjYeVy/R0vsi6CKeM7cyu1XgmG1Z
         hgsdYIyNwagmXOAd8hCI/MB8xqdFEbjSerzYq+CAvUxXkJaF6JSHVfDdrtX9YsM0bnlq
         cZxZJ1PWZsFw+QK5mpd33DC1jIJcubtWtwIfmf+pspWBXX95rFwhml5femTxjYzA/nDK
         dJb62haGSN2fWxbNxISZ//baDFMU2j9YWefAw3qlnXR1QtP3WBJ7SfgqxRz7Vy695fuw
         pvBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762963639; x=1763568439;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NeRxT3I5fTlFPGzsOfdrv5zO/0SPs+Jxk1vfyCkm7NQ=;
        b=TzDTVZtBzr2P9LTFFK4wRhumM+q1XBlVBIcSdh0LyE/DCA10DUcUym38l3Lzl27heA
         WLBhdplWtZt6zKRNJ0UGOU8BWgHGqVushxhBS0HqtqmM1Hnqj7Dcip0dhxG2UtQpNN63
         e7l5zWe9qJpHjKvJgNIZzZDi+RuDhQ7XhVK8JU/Rl0X8Wrbv0XpJ/5Bk1BbiTgbM7waP
         34NAP32JA2iRhUSsEvQEo89oMsNfLRjMpoycHUWdo8Y3o5DxdZ3NWrs6R72Xl/iXsnQV
         /MY3YYNAlJ/DFzDAw6lymjMvEjk7qRtckvsC9eluZJMK7vvPR99A+OCOf3n4Xsi5oBgP
         vLWg==
X-Gm-Message-State: AOJu0YzDX69Z3InoDGCBwWCRBVpHtmEH0aa5LtvGfXbx+S0UZrvyp1sk
	IXr3FmiV9npZ2yS1ocWiG7AOpJkKYB+wjZtg02M/ZkL0HcWCaLEz/pHE0FuJYUkwpKQxaPUcGoj
	KuVDzng==
X-Google-Smtp-Source: AGHT+IHW/VRW2YS3MUxdH2USXZLmkU4KxcWEaSqjoMCmQ+a2fgXYqtxaEYVcXnrl//MQDzhTVtj5DS7SUhw=
X-Received: from pjpy13.prod.google.com ([2002:a17:90a:a40d:b0:33b:51fe:1a73])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3f43:b0:340:dd2c:a3da
 with SMTP id 98e67ed59e1d1-343ddde89f2mr3893297a91.8.1762963639540; Wed, 12
 Nov 2025 08:07:19 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Wed, 12 Nov 2025 08:07:08 -0800
In-Reply-To: <20251112160708.1343355-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251112160708.1343355-1-seanjc@google.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251112160708.1343355-6-seanjc@google.com>
Subject: [PATCH 5/5] x86/sgx: Fix a typo in the kernel-doc comment for enum sgx_attribute
From: Sean Christopherson <seanjc@google.com>
To: Jarkko Sakkinen <jarkko@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org
Cc: linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Stephen Rothwell <sfr@canb.auug.org.au>, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Use the exact enum name when documenting "enum sgx_attribute" to fix a
warning if the file is fed into kernel-doc processing:

  WARNING: ./arch/x86/include/asm/sgx.h:139 expecting prototype for enum
           sgx_attributes. Prototype was for enum sgx_attribute instead

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/sgx.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
index 3c90cae04e1d..04958459a7ca 100644
--- a/arch/x86/include/asm/sgx.h
+++ b/arch/x86/include/asm/sgx.h
@@ -112,7 +112,7 @@ enum sgx_miscselect {
 #define SGX_SSA_MISC_EXINFO_SIZE	16
 
 /**
- * enum sgx_attributes - the attributes field in &struct sgx_secs
+ * enum sgx_attribute - the attributes field in &struct sgx_secs
  * @SGX_ATTR_INIT:		Enclave can be entered (is initialized).
  * @SGX_ATTR_DEBUG:		Allow ENCLS(EDBGRD) and ENCLS(EDBGWR).
  * @SGX_ATTR_MODE64BIT:		Tell that this a 64-bit enclave.
-- 
2.51.2.1041.gc1ab5b90ca-goog

