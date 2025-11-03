Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC202E7BB3
	for <linux-sgx@vger.kernel.org>; Mon,  3 Nov 2025 09:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762160516; cv=none; b=ObQbheMdyAKKBU8SLo1R2FSj2OpF4BW1Sw25shXDhQt7BHQOkmILDDf5hf7j0nFtVjp4LBtrWMVQx7Sc/KfJgKE3XAgv1AvWKTPQt0lmSDrf+AXs0axJla0ruv5p8XDd+402o5hEMjnL76vP8R2MOEWcyNi451JE1fSZzJWJne4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762160516; c=relaxed/simple;
	bh=/NdcaUMfQ0BGyNwZomCiV0RZvgN0AGZub7FE9predw0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=W/fs3ZvoKij+66R/aE0h5DuGJijLYhxwNt7bSwXeuOnZSkyFUex68kIhsXYlHZlIWYlX6XrMWInWIVd0k4IZ7SaINNiAvC/rKmOKc2cEYCDNSSQGzcZjVZv3LQqS5SX78jsEeItLzHTJoSpJu22OXESF3efQWisnOavj0PBoA2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=a/ReXCY9; arc=none smtp.client-ip=91.218.175.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="a/ReXCY9"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762160497;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=bkrUj1G/r3FtXK0JfLFqVkLf5znqH+CmB/WJED783ZA=;
	b=a/ReXCY9nhDEOgyQAv9hEmx9HuiK11hT2ERFx5B7viT/jta1Hyvka6ysaAwZHddthX5ibB
	6JYUBxdLmBuDxarJ1+GKMA6QBNz4BgsR++g6uorB0ofsAbsAi4jlq0hRWDeNtw4xKWMPux
	W4+fdOq1CRKp30oMMHwCbcALFSCbiNk=
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
Subject: [PATCH] x86/sgx: Fix typos and formatting in function comments
Date: Mon,  3 Nov 2025 10:01:04 +0100
Message-ID: <20251103090103.1415-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Fix typos and formatting in function comments to clarify that
sgx_set_attribute() returns 0, not -0, to avoid confusion and to be
consistent.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 arch/x86/kernel/cpu/sgx/main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 2de01b379aa3..c33e2b56a3fc 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -465,11 +465,11 @@ static struct sgx_epc_page *__sgx_alloc_epc_page_from_node(int nid)
 /**
  * __sgx_alloc_epc_page() - Allocate an EPC page
  *
- * Iterate through NUMA nodes and reserve ia free EPC page to the caller. Start
+ * Iterate through NUMA nodes and reserve a free EPC page to the caller. Start
  * from the NUMA node, where the caller is executing.
  *
  * Return:
- * - an EPC page:	A borrowed EPC pages were available.
+ * - an EPC page:	A borrowed EPC page if available.
  * - NULL:		Out of EPC pages.
  */
 struct sgx_epc_page *__sgx_alloc_epc_page(void)
@@ -898,8 +898,8 @@ static struct miscdevice sgx_dev_provision = {
  * /dev/sgx_provision is supported.
  *
  * Return:
- * -0:		SGX_ATTR_PROVISIONKEY is appended to allowed_attributes
- * -EINVAL:	Invalid, or not supported file descriptor
+ * - 0:		SGX_ATTR_PROVISIONKEY is appended to allowed_attributes
+ * - -EINVAL:	Invalid, or not supported file descriptor
  */
 int sgx_set_attribute(unsigned long *allowed_attributes,
 		      unsigned int attribute_fd)
-- 
2.51.1

