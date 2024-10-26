Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED1AB217F20
	for <linux-sgx@vger.kernel.org>; Sat, 26 Oct 2024 11:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729942411; cv=none; b=l2k/ZndnmRl1pcC+iM4MDArt6stdGwcdZ0RyHmu4pJu51NKTy4rrSf+tOFgi0WbxyxjyDcdpFEJ3xHeGX6mfIabgWeuBszX5o7PsIeT6Ix5SGbfWtCcE8wLkiUiJe09gKWgLeS5cLDF4Vo+Q9Updl+VxHYKMaEMDYSEYCKT0eLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729942411; c=relaxed/simple;
	bh=4EfySD8dguHXIi3sjSlBYJWgh3mjOa8JQ14gtIGYAJc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QiGGEHHJF+G5czIQxGDPL9VL/hPZJJuy+FUoFa4T3k1cpW+n6JrSQYzrGEMjbg7FyDmz6itg9fnLPYeeQ48eDj5CYyMHMT0qT0atmou8Al1bZkwDqqHYo6Hdb4f3rLh9vdURh9uCDjAnG8tVh0uEz+1R8wUyBK7X7c0wwH5LoDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NPVa/qCp; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NPVa/qCp"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729942406;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=/mTPa+MHBPWbALI+r9PSWRLltGGqQ3ro9y/4bwffy3k=;
	b=NPVa/qCpXyyfSnhTtBqO3jiUfCTKrCm6Q4H/vLTLfAZayAHmXdOziDPVAimIr9EyIuP8dM
	sKxwBYpYtglxnI3KTiaf5HFiLlbJ0u5ics31+A6XUUqUwZA4YXmPkwtZqkXOpGHy+8VuE+
	SNF/IDaiMRP+GLGwh6jjWwEGxeBalL4=
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
Subject: [RESEND PATCH] x86/sgx: Use vmalloc_array() instead of vmalloc()
Date: Sat, 26 Oct 2024 13:32:47 +0200
Message-ID: <20241026113248.129659-1-thorsten.blum@linux.dev>
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

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
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
2.47.0

