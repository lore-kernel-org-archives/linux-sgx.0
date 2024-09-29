Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFCC7155A24
	for <linux-sgx@vger.kernel.org>; Sun, 29 Sep 2024 10:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727607420; cv=none; b=gy0KM/sjGn6IM+Z+ngZZwpmmvn9Z7Cxf4qFzrIGbJa0YOhGMFoPj78N8knpNxjMkkET42WnOyOqwXl10AO24XbqNtlg8AwPQX/7uMZ9viSmtq9xWaufe/iUJFw19MWBtRUixr4b96O228z+xoMYl+z1ctPsfpA9XFUJR0H2dnxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727607420; c=relaxed/simple;
	bh=9mHIsMFvTeh1QwU3jC/p67Wn7bGYAnOLPtGoy0kGJuk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Zd4kQty1Nz+XXfq1PHRzjNKfDrpQYuWBMxdcN9UnCe3PE7tyzL2TTu0vn+8hfnou0qtPX8yU6KrJuxfu9IeLsi2Zc6pBAzv0BH/rtGgNXwsqF25iIV0RdiF8NrOcASH9J5qPU7tHqQiubrxYbG6kauH1NIwNJ/nKnS3dn3Q+IW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fpNo1SLp; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fpNo1SLp"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1727607415;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=RqGduFqDOSOpL9O8Z0ce0fvuvetnhPBd5N44plnni6s=;
	b=fpNo1SLpOztfv43MeCh8YpVP/TVhWRlJOwMda7FCvS88K8/BfVG7bCUcUiqfo9HDuUtl7p
	vOWIgtTQyJNf1iQyyj6Wh9BGKigxSzXW6UTGosZbslvUw23taJ7Ji5FAjmso6SGyeC1APT
	fQhvVGdn5TBnkJ9XAt5Snul8sHwCHgQ=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Jarkko Sakkinen <jarkko@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-sgx@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] x86/sgx: Use vmalloc_array() instead of vmalloc()
Date: Sun, 29 Sep 2024 12:56:43 +0200
Message-ID: <20240929105644.38797-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Use vmalloc_array() instead of vmalloc() to calculate the number of
bytes to allocate.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 arch/x86/kernel/cpu/sgx/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 9ace84486499..1a59e5956f4b 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -630,7 +630,7 @@ static bool __init sgx_setup_epc_section(u64 phys_addr, u64 size,
 	if (!section->virt_addr)
 		return false;
 
-	section->pages = vmalloc(nr_pages * sizeof(struct sgx_epc_page));
+	section->pages = vmalloc_array(nr_pages, sizeof(struct sgx_epc_page));
 	if (!section->pages) {
 		memunmap(section->virt_addr);
 		return false;
-- 
2.46.2

