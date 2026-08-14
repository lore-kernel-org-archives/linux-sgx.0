Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D174756A1
	for <linux-sgx@vger.kernel.org>; Fri, 14 Aug 2026 13:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786714829; cv=none; b=pOe9gXgKqiTiJXp587MIOf29bepFrb85sr9W/Z0qPiOUQYm0Fr+r8loYYqXGZHDR/q+Pd/zg1yBmQ58OvF7J3G3gD4QBmqNVOtheXIi/YI+EjTJecDuYwiBCDfgAuJKNs2ePdTidHyrpSE62XWV/glw9IRC0Z38v4xKfDCLOXjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786714829; c=relaxed/simple;
	bh=I0ehPNrXJOJkMeTxKViwPYPFiiyE4jE0P6GPf6p2P9M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cnONK4Mw1UlAmdzOpgS9P7TWbFpMYu7fdxOs6xsnh2vUF/mlTC+VSX4KuUBU9CEgen59ma7W+1qgT5mcE5539iQcbs51K7vnH6euqd7Qp1uyKQtQ1pQJ/oVi49e0LaUBXg2iG+vgCMwAnbm+PcDRbqfQaZkTwyOj3NhtOJlUA60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dBlujz+8; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dBlujz+8"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-84830c774a0so868295b3a.1
        for <linux-sgx@vger.kernel.org>; Fri, 14 Aug 2026 06:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786714827; x=1787319627; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=pJeUUwL/0Zl20dgmzl6BoaeGKZrww8etqxc3eB5Gpwk=;
        b=dBlujz+8XYm2h+Xp2dp/02T723qTJXHNRAMMP9sM9IWhAbJOnsWVZrDRX3A5HljcC8
         GFv3qGTLaQGXn7y8HWzm7+VtXIdI0g8ENyRNAHiPc2+6vvtH14rZ57mOLX6a679RW+La
         UXQymzFCkTQoWRAa8MG/6v8ZPssnUWmtvucXVpLSqeWM29HS0L7rO6NnBQA2VRerT8/F
         3NIlbFWojRHyCUdrcCFxatJ4Uz77Vq73WDy3+v6sG1ilOZc8ydMBow2Un8N86p6iSRLW
         tzM2TAmtlY2lsAaBqhmYbgRvGMxBnD6qMjvh9wws/kFXf7ROByFgMPpyowTjo+GLUbmL
         HKkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786714827; x=1787319627;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pJeUUwL/0Zl20dgmzl6BoaeGKZrww8etqxc3eB5Gpwk=;
        b=my9XKwoS6x++Zh71aA1sXM/j2pf/holD9ENSWxcVxCwxgVEZz58sBshvgr53J5HCDR
         HxLrtneNC9+fG1yeVuzLf3FFbC4rTIbB18QBTugnuGKrt+RZCbi9g0zYGwiWQtQVJCDB
         x4Vi+PFjpSQZWXUdN0LB/ppY1ImobP04bDtZkaLOCQTfq/3GFWdOgPnvFY3RBQeLq2aA
         J2cYJSQUl0Rx+3+++96bDJVxzmUll4ezdCfbhE1uOLEDjtlvmqTdKm3B3zEx2t5kXFVv
         dUmTFq07Zvr43x+q09JFHK0TpmUBxjxlDD/nMq7pXLnsqrs1pn76kEmVFb6URpwMGsSh
         Wfog==
X-Forwarded-Encrypted: i=1; AHgh+Ro57Oul3mZWZJH2omWnm2N7eqZo+P8+zKrZ7dJhnG4vMR55mRLacxZyAdEebnPD1GKLX4NZQOUg6Bo=@vger.kernel.org
X-Gm-Message-State: AOJu0YwVSSy3cJ7dE+EbozkNak7mXfAH4imMT7y4Wz2pimx2tkDbMx5m
	WqRqW8QLdoCRxiznRjg2VxQEZdJNRUufbFFzOdKD/JohwcKdiUYUzIME
X-Gm-Gg: AR+sD10TP0wFX6CWyU3Hv1a0rzNBe4BDAFFAbjs3ZDAX+JyFwQlFEe23uy8x0mMCnPh
	D56vqGh2DJ23gSl2j1slcdvrGDP90GrDITXp9L2CyWN6m6wu0Q3GQut//Y97FzB4V5jSvL+Fyrh
	2LRlq+FopfH4b2By4kSClxhRpiuxGvjv1UcKHzO6+e2+wQ8+4ZtJ4URwNuGS30j5RZIVCv4eyQ+
	A+kAmIVOAxceyni5hafUt8IMotQma1RULmhRSWlGJR4JCipc5UUxxcBAhQBlMs9deqEAe4aCOnT
	TaM/1TPAYjpVu+Z2sLwDaIaHpigXys9NDTsLWm+tsW/REeZl4rh8p6Thi+n/OA4uFM8sPTOYG0I
	cVfIwOJ6lCbe+a474r1/C6DDcmQ/W5moJNnqf+Ri+EXsENPeQU9Qq8iO3MhfPZe1rDWRN5IKKtL
	cgNCgejde4NgIgHcM3dZJp2puOVflgWkXj5+/RoPRQxkEC166ZrppDu4ITlj7t3/QP/YaLwsEUh
	JPfT0m3Wh2JwhzcLpE=
X-Received: by 2002:a05:6a00:4193:b0:847:9315:fb8b with SMTP id d2e1a72fcca58-84fde1500e7mr6682127b3a.6.1786714826670;
        Fri, 14 Aug 2026 06:40:26 -0700 (PDT)
Received: from haichao.tail057a43.ts.net ([2001:da8:e000:1206:e9af:7c0e:be31:2c3f])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc08f388356sm659953a12.2.2026.08.14.06.40.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 06:40:26 -0700 (PDT)
From: Ruoyu Wang <ruoyuw560@gmail.com>
To: Jarkko Sakkinen <jarkko@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org,
	linux-sgx@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ruoyu Wang <ruoyuw560@gmail.com>
Subject: [PATCH] x86/sgx: Drop enclave reference on MMU notifier registration failure
Date: Fri, 14 Aug 2026 21:40:20 +0800
Message-ID: <20260814134020.1386599-1-ruoyuw560@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Each sgx_encl_mm instance holds an enclave reference so the enclave
outlives its MMU notifier. sgx_encl_mm_add() acquires that reference
before calling __mmu_notifier_register().

Notifier registration can fail while allocating subscription state or
when mm_take_all_locks() is interrupted. In that case no notifier or
mm_list entry takes ownership of encl_mm. The error path frees encl_mm
but leaves the enclave reference behind, preventing the enclave and its
resources from being released.

Drop the enclave reference before freeing the unpublished encl_mm. This
balances the acquisition without changing the successful registration
and teardown paths.

This issue was found by a static analysis checker and confirmed by
manual source review.

Fixes: 2ade0d60939b ("x86/sgx: Maintain encl->refcount for each encl->mm_list entry")
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
---
 arch/x86/kernel/cpu/sgx/encl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 3f0222d10f6e6..04fbf7e703e1e 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -866,6 +866,7 @@ int sgx_encl_mm_add(struct sgx_encl *encl, struct mm_struct *mm)
 
 	ret = __mmu_notifier_register(&encl_mm->mmu_notifier, mm);
 	if (ret) {
+		kref_put(&encl->refcount, sgx_encl_release);
 		kfree(encl_mm);
 		return ret;
 	}
-- 
2.51.0

