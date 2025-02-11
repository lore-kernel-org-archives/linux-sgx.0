Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44FCB3C3C;
	Tue, 11 Feb 2025 15:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739286289; cv=none; b=Zeg78HKNjAjIPux/tNr5JTxuZMqBN3LjLrc9zHXhh8lI6Ew6OdAGrm6tghsIJtA6qaA4izQlRxYZVLztCD2S1I6+1lsT/870w2vk7mEMFQmZsCEtImE3d67fFDn8wGsmXzLWnV5CQLiVV0+U1f4Gm6p761ZHbgnv6JtO09CCCjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739286289; c=relaxed/simple;
	bh=JYOuphM9HrCh/8y+Ld6o2FfLd+KGdtaeU7rWIA4fkV0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MkqDZSPEPtOqnTqibIY7OnGPOex2T/3XOp2Har43TbBHSXC5DQwcYki7Q/LC6JAy7v7joqx2Vmr0pvoJJVhqEEji9BOkMd1Wu1dKHxshuDh1gaKlFSk1dqOQj9HcuofC8GZfXjc+tjMebzkRzjkYf98RyvovmXI6RoFWgx7fXb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4394a0c65fcso20048715e9.1;
        Tue, 11 Feb 2025 07:04:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739286285; x=1739891085;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=agTF5FJTbJ37GtMDB4O+QftxI8jxpB7nbp6gbFb5YLE=;
        b=TBsZuQudSQOq3O0YITcH898FU8CDPJGnG11PzfO2gmiwuNijN1J5RruEdFP423kdB5
         edGcjAPEbMWZZtS+FjZ4v5ZU/S0Crfvfft4tTz6z8Y2HH/Dzwsmh9efa2UDVgBiofZV2
         cj/2IckqSAdYPkooBvhD5Vw9pzOgcOFvN+NJL9JX1uo3hOpVPvTSKfYutkrsDE4iBoRk
         vljvVAuJT0Toa2ZGU56XUoY06cmeZ/f/+CHlohe4o5Fo+BeflbuRehBFrCFoZwAqE1+e
         rL7UKsDDOsU6Qi8PocoDtUR5pjRIVMVroPUnUVuL/drpekRFHt1ASZay4lapjXGAVxJx
         SmTQ==
X-Forwarded-Encrypted: i=1; AJvYcCX/ERlp7QJDSHilybdUP9IYtLucN0i0Y00i1mr66WxuNpSaSubL5cv0/Qwu0i0kEA/YiSyKOv5O1DHeewg=@vger.kernel.org, AJvYcCXsfKgmL9ScURBEs/oK8Qz42agwaKyjNGemeixx2gWj5NEd2u4fa2BEhNHpFh55Epno8tzkWpTqXy25@vger.kernel.org
X-Gm-Message-State: AOJu0YxUD55j7sF+EIUyYQovOd15nXrLgpCJxBw0fGWhV3EbxuOuvDyd
	ftBbZ2VsxodkGZvGC60T6mV/i84mCoRmUxIxMKkbJhRH5JPgG31t
X-Gm-Gg: ASbGncterfhh4VyPIScAd3XTnidbQE6l62k6dmPVmdPvrnJszyElo6A0VoflLB5GjVa
	QaIzvWXgZiSVFBVBLXrxDN5e0c/q6yrD+7yCcTxXxnNCjhzR+DQxaorin/0uv2F5ztXawZOr+jU
	aUNPohQ+c0Gcn0rZISzzxZ6hHZHHjignly8PCx8TtgWCci96blCHlF3XQObYhfQLQCJ6/40NmWx
	03fDjcIbmBTJxwn0CBYtHeUdPkxORQkIaJxfEDR5oepEuSEdsGSN9EtP/kySjutUOOOXsnRWeAZ
	+X9n9FkBZXXnnbi79EQuyEIQoD+uhaDpeh/EsQ==
X-Google-Smtp-Source: AGHT+IEmDsr4tU8emcczTRFVk+eRfqxVxknZQpSvk6Nu1yol1P+eQ9PYUohG02GI1CnOMUyWshQ2PA==
X-Received: by 2002:adf:f70b:0:b0:385:d7f9:f157 with SMTP id ffacd0b85a97d-38dc9135d53mr12421952f8f.36.1739286283708;
        Tue, 11 Feb 2025 07:04:43 -0800 (PST)
Received: from localhost.localdomain ([82.213.232.55])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab7d5f84968sm219582366b.164.2025.02.11.07.04.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2025 07:04:43 -0800 (PST)
From: Andrew Zaborowski <andrew.zaborowski@intel.com>
To: x86@kernel.org,
	linux-sgx@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@redhat.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	balrogg@gmail.com
Subject: [PATCH] x86: sgx: Don't track poisoned pages for reclaiming
Date: Tue, 11 Feb 2025 16:01:50 +0100
Message-ID: <20250211150150.519006-1-andrew.zaborowski@intel.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Pages used by an enclave only get page->poison set in
arch_memory_failure() but stay on sgx_active_page_list.
page->poison is not checked in the reclaimer logic meaning that a page could be
reclaimed and go through ETRACK, EBLOCK and EWB.  This can lead to the
firmware receiving and MCE in one of those operations and going into
"unbreakable shutdown" and triggering a kernel panic on remaining cores.

Remove the affected page from sgx_active_page_list but don't add it
immediately to &node->sgx_poison_page_list to keep most of the current
semantics.  It'll be added to &node->sgx_poison_page_list later in
sgx_encl_release()->sgx_free_epc_page()

Tested with CONFIG_PROVE_LOCKING as suggested by Tony Luck.

Signed-off-by: Andrew Zaborowski <andrew.zaborowski@intel.com>
---
 arch/x86/kernel/cpu/sgx/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 671c26513..7076464d4 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -719,6 +719,8 @@ int arch_memory_failure(unsigned long pfn, int flags)
 		goto out;
 	}
 
+	sgx_unmark_page_reclaimable(page);
+
 	/*
 	 * TBD: Add additional plumbing to enable pre-emptive
 	 * action for asynchronous poison notification. Until
-- 
2.43.5

