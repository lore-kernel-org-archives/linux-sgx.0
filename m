Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97AFD368D47
	for <linux-sgx@vger.kernel.org>; Sat, 11 Jul 2026 10:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783764087; cv=none; b=jpjxKencWrhwE+kINWF9YTwju59EftZF6X4YXnpuxCsm1AG+QNBeVnB6REfV9OsLOgPG069gX023Tf/f6zOk53/3EaBkzr+6t3OtPBqYwSZy6pYajApvudAeO2lolYtVqjO3y3ATkIrCcH2S3gxJFQZ2An6Zq1tTkCdKJhT02Sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783764087; c=relaxed/simple;
	bh=uicDhczzY9VBKgysdtMLeZry5lCZAiLOnQM1bwm4XS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iEIdjC3HcYxd6KEm9V+Yey+PYw5VRu1pW4Wut23n4XKZYbbcP2Y5Nqmd3jJcopd7Ztu/bu1jfvNEt1UgxdaXTXGoN8n/hu3DmD5BFtsfNdV7X1V68P94f9DZm6UbfKv+0zhMbjBv4ZeGa2+IPyhbpXmOWkYqcm0OkAbgVqxbaZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=rh9aQqy8; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="rh9aQqy8"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783764082;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sX97vORY2u/kl3BsdFam7e+/+bCiog5xLoh/i123rfI=;
	b=rh9aQqy8BypyyzWW/ITjF6kvd7lmTWjHHoQMHHLnyfv+jmVZJd9+GvHPSHusIPRoiVW5Oo
	ikJzqS3+EQKAijsTtGXK5vn6Pql+DfDQQWOSA5yeojxEJ1nHSHxi+8/Mcu9FJ7xYm5NP8d
	HQZoe1EbJtD6F8C3UkbsmgiisRs1gfk=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Jarkko Sakkinen <jarkko@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org
Cc: linux-sgx@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Thorsten Blum <thorsten.blum@linux.dev>
Subject: [PATCH 3/3] x86/sgx: Use SGX_LAUNCH_TOKEN_SIZE in __sgx_virt_einit()
Date: Sat, 11 Jul 2026 12:00:57 +0200
Message-ID: <20260711100053.739588-8-thorsten.blum@linux.dev>
In-Reply-To: <20260711100053.739588-5-thorsten.blum@linux.dev>
References: <20260711100053.739588-5-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1085; i=thorsten.blum@linux.dev; h=from:subject; bh=uicDhczzY9VBKgysdtMLeZry5lCZAiLOnQM1bwm4XS0=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFlBIuGrv0aLrTha83Jt8kTPjiPMxsGrbtb+/evvvm9qz lHPhc8qOkpZGMS4GGTFFFkezPoxw7e0pnKTScROmDmsTCBDGLg4BWAi5U4M/11LnboafhzMVX+4 MKbz2paXljs2X7vnOfP6YmsP94CAyRsYfrMz8gjOOeixZdWqg9kvmpUk/d/Js77Kc+q+nMxyfMO 2KG4A
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Both sgx_ioc_enclave_init() and __sgx_virt_einit() use the same 304-byte
launch token. Use SGX_LAUNCH_TOKEN_SIZE in __sgx_virt_einit() instead of
maintaining a second local definition, ensuring the token initialization
and validation paths use the same size.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 arch/x86/kernel/cpu/sgx/virt.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/virt.c
index db6806c40483..fa9173a9384a 100644
--- a/arch/x86/kernel/cpu/sgx/virt.c
+++ b/arch/x86/kernel/cpu/sgx/virt.c
@@ -394,9 +394,8 @@ static int __sgx_virt_einit(void __user *sigstruct, void __user *token,
 	 * All other checks deferred to ENCLS itself.  Also see comment
 	 * for @secs in sgx_virt_ecreate().
 	 */
-#define SGX_EINITTOKEN_SIZE	304
 	if (WARN_ON_ONCE(!access_ok(sigstruct, sizeof(struct sgx_sigstruct)) ||
-			 !access_ok(token, SGX_EINITTOKEN_SIZE) ||
+			 !access_ok(token, SGX_LAUNCH_TOKEN_SIZE) ||
 			 !access_ok(secs, PAGE_SIZE)))
 		return -EINVAL;
 
