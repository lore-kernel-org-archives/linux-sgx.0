Received: from mail-dl1-f68.google.com (mail-dl1-f68.google.com [74.125.82.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F4772ECEAC
	for <linux-sgx@vger.kernel.org>; Thu, 22 Jan 2026 13:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769089012; cv=none; b=FiGuJQP0BgDdzbIWemhS/9k+RTKpaRnH2M49Iau/ydxqCc9aQk52k1IkIEo/2lYT8Ga2idxKECAbWepTVzEmMnkMbxd223C2DG8WFwlS6EomREji/9Glc8gr18t18NsRx397Om68r+T8c4j4Gsk29UU4/dVai3pQ4rNc75y9rc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769089012; c=relaxed/simple;
	bh=GHzTv/yZEF80XWTFvMQv3en0xG8aRfZtcKsMZyYrGkE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ffWUoDnm6oKOXBS4Sx+uBgTTbERJeOOjH33JB9L7hihtc4s3eR7qVEXBAx4bSK9SeNwfbxzbA3KOHgPngla35XhHyZzpKfqLfgzfP+cVkY7Mf8zhe1QlqN0XbKI83tfv6vDUCsc2v44jvpyQbqsYCbI9s+r4OokESyLu1o9k2ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A7ecvZ8Q; arc=none smtp.client-ip=74.125.82.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A7ecvZ8Q"
Received: by mail-dl1-f68.google.com with SMTP id a92af1059eb24-11f36012fb2so1606705c88.1
        for <linux-sgx@vger.kernel.org>; Thu, 22 Jan 2026 05:36:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769089010; x=1769693810; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=opvHDwiOpdiGMuXFIvJiRhV19eFW2enM116TYEfgc4s=;
        b=A7ecvZ8Qp1gzwPgKusFcrEGdW3EqndTfEgsu1dazy+4lGLVWY9yvA2uSCYhIXmRZ4z
         QlsCDov/KOWfkPr5UxNiOamf2hSVA6QxbWeySxWcwrNnLS+m5rBerFB/QM00ciTLZ6Li
         GUEfe1uk/jJsGRoIoPZpf8vthe8jdm1Ln6SaPJ9PDzxvmwewEFbEb6MZkqThNexF/APX
         r3HRAYFi1qN5kViaQ3ZELbsetMoay73b0YQ6vRVuwnf2F6tECOw7g9W9K8R+7WLgTE2C
         a7s3+DDGr4oD0EgIp8I5E1Axt+l5lBY7xFR42EFZ+l25GyzWtY+N48JPmpETPFF2Qv63
         mAfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769089010; x=1769693810;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=opvHDwiOpdiGMuXFIvJiRhV19eFW2enM116TYEfgc4s=;
        b=GabGQmVPokBABAgQns/Z8nMJ9qK4nhx2P85v5SYCrfeHAkdJygS+f7j4ig+t+DXMfT
         C3t3dqiPG+zca0a8zC0yvMjhf4SoKc455oKl7f+EOBLQXnDdGSNOruELanAKmL+tATj9
         sqA4A+U+xh111KR8NK2SreIppxS+ZUPlYZO5eEdXt8ZSowEeDaCx/IhWYEyLTeHuwa9a
         wzaOfB4glEpFswMECh3F7qoPBzOmKtZ5PExs3zYRIFvLg9c1y3MmpZAx/KmIFkicnDXv
         oG1mn1AVVqJxkvTA++XFZUBxmrydfaWdoODvFB9C/r5zG8NM6c2ow04qnvOimCkUBVfJ
         u6JQ==
X-Forwarded-Encrypted: i=1; AJvYcCV7Vc8c6UsKgirCLqEXHNpK3ADuQb73caz/362s9ZTB33EmOlIyyIWdGanLFFpZzvei+aBGP523Mn8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzulrctLIsfpLQVldTtbT8tc1/1OVq8BQXkwiKqJZOa2NMFhyia
	uw+sCHXNAtC44NZU5JP8RrqKCFFCkB2tyntHmnTI2NXcGqLcCCG68nZe
X-Gm-Gg: AZuq6aK7PnZ1RR/TgQ/PpcAI64sZ8HoaExxje27xuBc2AKHBpQV3piCHRM2nYi8X1+d
	+u0y22GxSKMUsv30bt7rdazaEfk53XTm0g1vAAlZ3MkMIfjR6qzEuel4DotLDfivJGLlikfdIIU
	YxGOper4NeZ4mHsIBtFlnQXgiw7EEGBEgkOpwa2OU58RZXkKONMUVbk0PlUoKaznNO9iBLfIA14
	HRAJWYiDct1sQl1zeXceMAabLO3RWYiOr5pNQN2ttqglzuiU6scdMRz9yXrsl/uje4P1R1tmBZ+
	FPoGEZ6Q5JPUnN/f6huEXsx6VpAOxb/psUeE2dQfZGVVXqwBv9omqFR+zUiD+kILWjGaZx27fRV
	eWqsIiZZgPCIgKzbvasqHi4KMGZZTdmA6IAfpJIPRK65eT5hh9If0pT7AYOfl2hM8rdVKoYsu40
	g/Q94QedVdDRTZdaJBGTKjIS6t7oeyoZF6FFE=
X-Received: by 2002:a05:7022:b8a:b0:119:e56b:91d1 with SMTP id a92af1059eb24-1244b307e4bmr13222512c88.2.1769089009918;
        Thu, 22 Jan 2026 05:36:49 -0800 (PST)
Received: from 9fdcf7ea0ed5.localdomain ([38.207.158.12])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1244af108absm28378188c88.13.2026.01.22.05.36.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jan 2026 05:36:49 -0800 (PST)
From: Wentong Tian <tianwentong2000@gmail.com>
To: jarkko@kernel.org,
	dave.hansen@linux.intel.com
Cc: tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	x86@kernel.org,
	linux-sgx@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Wentong Tian <tianwentong2000@gmail.com>
Subject: [PATCH v2] x86/sgx: use vm_flags_t for vm_prot_bits
Date: Thu, 22 Jan 2026 21:36:33 +0800
Message-Id: <20260122133633.79792-1-tianwentong2000@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The vm_flags_t type is the dedicated type for virtual memory flags.
Architecture and driver code should use this type instead of assuming
vm_flags is an unsigned long, as the underlying type may change in the
future.

This follows the cleanup in commit d75fa3c94750 ("mm: update
architecture and driver code to use vm_flags_t") by converting the
remaining vm_prot_bits usage in SGX code. Also, update the vm_max_prot_bits
type in struct sgx_encl_page to vm_flags_t for consistency.

No functional change intended.

Signed-off-by: Wentong Tian <tianwentong2000@gmail.com>
---
v2:
 - Also convert the type of vm_max_prot_bits in struct sgx_encl_page
   to vm_flags_t, as suggested.

 arch/x86/kernel/cpu/sgx/encl.c | 2 +-
 arch/x86/kernel/cpu/sgx/encl.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index cf149b9f4916..814edcde225d 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -281,7 +281,7 @@ static struct sgx_encl_page *sgx_encl_load_page_in_vma(struct sgx_encl *encl,
 						       unsigned long addr,
 						       vm_flags_t vm_flags)
 {
-	unsigned long vm_prot_bits = vm_flags & VM_ACCESS_FLAGS;
+	vm_flags_t vm_prot_bits = vm_flags & VM_ACCESS_FLAGS;
 	struct sgx_encl_page *entry;
 
 	entry = xa_load(&encl->page_array, PFN_DOWN(addr));
diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
index 8ff47f6652b9..0e0b97e91905 100644
--- a/arch/x86/kernel/cpu/sgx/encl.h
+++ b/arch/x86/kernel/cpu/sgx/encl.h
@@ -27,7 +27,7 @@
 
 struct sgx_encl_page {
 	unsigned long desc;
-	unsigned long vm_max_prot_bits:8;
+	vm_flags_t vm_max_prot_bits:8;
 	enum sgx_page_type type:16;
 	struct sgx_epc_page *epc_page;
 	struct sgx_encl *encl;
-- 
2.34.1

