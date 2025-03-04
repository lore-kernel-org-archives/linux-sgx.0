Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A350727CB34;
	Tue,  4 Mar 2025 22:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741129017; cv=none; b=lHo5FLrJ9c+hpN/cIMzmoBEhrwvl7727kQ0w13o4LWgCAt6o5TTC0+Bdx2zBH4FAiEwjKTWM8abhhanwz5C2RRHLqEHavacf/gZOB84UBF3ynvOtfEMNMdqVuydmyqr1E70Zu7ZkLU6Yh3vma7oCja/S0i4mFV4hDQCWbPPnxSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741129017; c=relaxed/simple;
	bh=bRlqhB0230mfIlVKHsoerEPbZx5Lz7IFjEzcjkiGTDM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MKpDPAv0q7KqZHq2AmZFo97nAvrdv/YNPgdqDx3QGaICVSIY6qE1ZKV88gcbgQ76V7aEcOzcSyMB3C0wswrWVsyJ9iq74b7pHU5XLCAvWZXnPBhj24bo5y+94ylQ0Ia+uXA16oAFUSS6FjJhNU9krY03Or195V8PKX2SVBwwMwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WATPFRNH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WATPFRNH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADC80C4CEE5;
	Tue,  4 Mar 2025 22:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741129017;
	bh=bRlqhB0230mfIlVKHsoerEPbZx5Lz7IFjEzcjkiGTDM=;
	h=From:To:Cc:Subject:Date:From;
	b=WATPFRNHk9OktpR86T6h1w1vH7JknKhosipN69B+b6OnQpozabdcWTz0KQqSceTR8
	 Ll0qUTEGHIhJfiJgDKq/xEj1ZrrhRkbJtLdB4H9QPcknoLLLJg9XiRWcZHZmyr3dXP
	 zYSv9YCakg3gMbhTF/qSaS2G1+qHOVyUt0miMoiWh0npADn0u4ax6MgtbQOO4xhf7y
	 FZdkAKfnXJbgb6SYlXsp8ZZTN1G5NfGKOpWHlmlF3HlTFp7esgzKDmq3k+zcNU0iS1
	 6BDQ/wCWzMQsZbG4O3YNA/4IQcIvi3ynq8d0JJbE1VEbRfLdaAdLpxWkQlGG/+mVmM
	 MvN5dCetOVUmg==
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-sgx@vger.kernel.org,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] arch/x86: Fix size overflows in sgx_encl_create()
Date: Wed,  5 Mar 2025 00:56:48 +0200
Message-ID: <20250304225648.116440-1-jarkko@kernel.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The total size calculated for EPC can overflow u64 given the added up page
for SECS.  Further, the total size calculated for shmem can overflow even
when the EPC size stays within limits of u64, given that it adds the extra
space for 128 byte PCMD structures (one for each page).

Address this by adding the necessary validation for each partial results
before going forward. Return -E2BIG when an overflow is detected.

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/linux-sgx/c87e01a0-e7dd-4749-a348-0980d3444f04@stanley.mountain/
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 arch/x86/kernel/cpu/sgx/ioctl.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index b65ab214bdf5..176c2d8d9b60 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -56,14 +56,26 @@ void sgx_encl_shrink(struct sgx_encl *encl, struct sgx_va_page *va_page)
 
 static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
 {
+	u64 epc_size, pcmd_size, shmem_size;
 	struct sgx_epc_page *secs_epc;
 	struct sgx_va_page *va_page;
 	struct sgx_pageinfo pginfo;
 	struct sgx_secinfo secinfo;
-	unsigned long encl_size;
 	struct file *backing;
 	long ret;
 
+	if ((u64)PAGE_SIZE > ~secs->size)
+		return -E2BIG;
+
+	/* The extra page is for SECS: */
+	epc_size = secs->size + PAGE_SIZE;
+	pcmd_size = epc_size >> 5;
+
+	if (pcmd_size > ~epc_size)
+		return -E2BIG;
+
+	shmem_size = epc_size + pcmd_size;
+
 	va_page = sgx_encl_grow(encl, true);
 	if (IS_ERR(va_page))
 		return PTR_ERR(va_page);
@@ -71,11 +83,7 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
 		list_add(&va_page->list, &encl->va_pages);
 	/* else the tail page of the VA page list had free slots. */
 
-	/* The extra page goes to SECS. */
-	encl_size = secs->size + PAGE_SIZE;
-
-	backing = shmem_file_setup("SGX backing", encl_size + (encl_size >> 5),
-				   VM_NORESERVE);
+	backing = shmem_file_setup("SGX backing", shmem_size, VM_NORESERVE);
 	if (IS_ERR(backing)) {
 		ret = PTR_ERR(backing);
 		goto err_out_shrink;
-- 
2.48.1

