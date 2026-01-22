Received: from mail-dy1-f194.google.com (mail-dy1-f194.google.com [74.125.82.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A766F38FF13
	for <linux-sgx@vger.kernel.org>; Thu, 22 Jan 2026 05:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769061300; cv=none; b=RGTewwamVvpi5Fvy1it+nh2yqJRXURcfXNOvwf7RLMFAQoUJ6T8iq1LF0T/rLrzmn86TVA/j3fpjmxqgwGGpAHokRJ5CjZeRxhirEAlN1RAMofsoosJooVFqtyvflLGAiz5COf0uKAJoaVcpmwOtowo03DMDb+OPApTCQqRTzuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769061300; c=relaxed/simple;
	bh=89YB+bX8aqw9NUb0tmozPQhtFRPS/xd9SOAGVjOJ0MI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=GdREYoNckMpi1mmEAPPFxNSImhkZc8auOcgdQAf0iLvjlhKBvRMg0/D9uFJvCNvx/sLNege3FYcfifM4ov4eMGhqgt+XUwmR+1DIGj7iUU9qlrtjeqwAXgZQJMqELz0+P3xXOsSShvS73wMu+DZZVLDa4Vx02XAu37lGrfEqWOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OGAVUzaB; arc=none smtp.client-ip=74.125.82.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OGAVUzaB"
Received: by mail-dy1-f194.google.com with SMTP id 5a478bee46e88-2b71d5b2a35so610894eec.1
        for <linux-sgx@vger.kernel.org>; Wed, 21 Jan 2026 21:54:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769061297; x=1769666097; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=db5L71lFil1nMt4m3zHfhoBZD7zBth9lGqCdL+1iytU=;
        b=OGAVUzaBbA//Bu1AN/31AZujFdXu8jjdxoyWC16psHNUALFgeoduE9lNVO6Kl7Mto/
         3dQNmX5vt1qqKRWcszULWK7JdvxBhf8ga87yYTSsxkv6Oe6xVzCXyuxvU6X6Nwrkin2Z
         Ic13TbxOiUu03ZsxeQVUX5z0pKzkRip8cdilY+OJwQviDDiRnr3m7K1x/yT9u+X9n4Ee
         QquDsyCNQ3zp8wI5c4VpOfqn9UgbKhsJ9oFO5Cxbz3nftA3fRjX0uqa1eIwD+Ho5y2IG
         3siBH8pXl54o44pKKxWMmVtVyBcNkw+gmUhlIMGnpCboDOQfD8fJTM46dEDpG9juo94r
         OWfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769061297; x=1769666097;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=db5L71lFil1nMt4m3zHfhoBZD7zBth9lGqCdL+1iytU=;
        b=tbJnfQq6AasxP84AZ4KG2skkOaY5CESikGy02Wb3NGQJX1FSofrwr5dPn30JphJBQX
         q8RLZK0lmmFphvPWaIdOEn8FbjMTTVN3RGcYr5A4xwwHpHjhu9VryBlirIC8ceWwRMfz
         qfpWTq09/bNm8s1DdVjVCgh6s0RqQZzGY+sc7lH6hQ9BQkjPwXdAf60EZ8Cms4i/wbxz
         WxQPINmjHfq9eBC2W2ynMTnswH5zu3cIfT5PNlkBRqs7IP2pEymVJa7B4WpuSjc3TcE9
         dgdtTgIOxUhj8b5iG0BCwT492it8vSR6w2B6XcqdpMxEXQEppp0V1bsGu7c9Fda54P3E
         pHvw==
X-Forwarded-Encrypted: i=1; AJvYcCW74N4nBcA83EFMBVsrFBO43avkKyh9CylHxXMPaYK5g9UpuDq9N1/pAwJzJdD9vLG5zCh9DyCmYsI=@vger.kernel.org
X-Gm-Message-State: AOJu0YwfdeDbk0qKvnpqDlBJ9fXomLlmj/NNQHy/ALj6Tm26UbLUdXtQ
	Zd2+AEKsTgg5EfgxN8CegVAo4F1tIz00adxbjf1lrrL0sK4hgRX+Bnro
X-Gm-Gg: AZuq6aIu1+1eSv0sS55mMWIdt8TS+JDz3oy0CTmdih+m2miA5ZO2uVEndTs2XpMU2A7
	HlWlEO5aAxessxy8Zxv8lmyoABeLPBn8RQGOiPG3ZBQqEnVySAyLsFhXz2cQuS2rvHPZW6T1Nl4
	6OrxNRRrO+zs25OI3ZRd3mA0hBZUqDrW3C541ebpjSqi8PWza+3YlAULUGVngceuZvBXhi3tAwQ
	5Nn/6OkOw2Ywr7KQ8O3nRFrrvITTTbb5ws3GzgAs1Ngw1EHgCjds7N6rmiQRDyCG3HKE/Pi0lt2
	agE5QiZ4pFDHDLrxamyL2aMjAcJsDN1dY+E1igycnDIRnANxplgcd4wGe7rq+GvpYwXxmkmnzEB
	1JBxePrs6cTmvG5DjOtfUFiaNoJnH/cjpYEpXw4cfsECcSxI/ksI5DnX245H5UcQXK4EZ3c19ab
	osNwujaq5vgdPGhG2cTnk70tLWATjQka6b37aUTnJYZEA4KWo=
X-Received: by 2002:a05:7300:d70b:b0:2b7:19a1:3bae with SMTP id 5a478bee46e88-2b724801cd0mr1034781eec.18.1769061296697;
        Wed, 21 Jan 2026 21:54:56 -0800 (PST)
Received: from 9fdcf7ea0ed5.localdomain ([142.171.172.108])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b7047b099bsm8154623eec.31.2026.01.21.21.54.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jan 2026 21:54:56 -0800 (PST)
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
Subject: [PATCH] x86/sgx: use vm_flags_t for vm_prot_bits
Date: Thu, 22 Jan 2026 13:54:35 +0800
Message-Id: <20260122055435.95911-1-tianwentong2000@gmail.com>
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
remaining vm_prot_bits usage in SGX code.

No functional change intended.

Signed-off-by: Wentong Tian <tianwentong2000@gmail.com>
---
 arch/x86/kernel/cpu/sgx/encl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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
-- 
2.34.1

