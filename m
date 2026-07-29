Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D01AA3C3BFA
	for <linux-sgx@vger.kernel.org>; Wed, 29 Jul 2026 12:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785329829; cv=none; b=nzG45U8yElKGsnwpb36juUHklvPngCsU5JoeJ6xNkMa057/Ci3PZffr8c0Q75oVIpT9EFEvi4JWQ4uYjq8WJnxQ0DV5mWkN3Ot9Dm1TWifa8W58sr/n/PIm2v2TyuGszeTw/J2Vf2euNBvfW1NbPFlZutoDCNXUzhSnMqoYWzlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785329829; c=relaxed/simple;
	bh=QGiDIXr/JFABPhjDOULKPBaTgQfGgcL/30YZ0jzf/x0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QlvEOM7jegdaQYC2S83hpChOo3ASQHZnkVwM+CLSuHHTj+OiIgyHQI9+NMzAgV5GLYULUECSaYsypGZy/p5cfX8lMIybrTLtbtZ3eZJ+tx7DVdwJ6n+xI9wbZ4/wok7quZrqejIN5egaXRla9pwczo6Ct7hfSRKQbGLd0aPjQMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VT49o1d3; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VT49o1d3"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785329815;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NpRK1w04dTe0/VMhMyqDdAHkCv+c10bYjwG1efWA2jk=;
	b=VT49o1d3J2J6gh+hXqu/vTp/vzEjtoZ5h4lkBzoD6+m4/5H4MnnK08sn7RBUWtQy0iI/CN
	B9HPDRkXf7M6wDTYHWndT/JAc+Oe2h3cdweBtLMJLTHtfrBRCgDkg8hjhiMpKo18PK5U3E
	QNwIRKGEFI3yDa/Ya/5Z0HvjT2KW5HM=
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
	Thorsten Blum <thorsten.blum@linux.dev>,
	Kai Huang <kai.huang@intel.com>
Subject: [PATCH v2 3/3] x86/sgx: Use SGX_LAUNCH_TOKEN_SIZE in __sgx_virt_einit()
Date: Wed, 29 Jul 2026 14:56:28 +0200
Message-ID: <20260729125624.514697-8-thorsten.blum@linux.dev>
In-Reply-To: <20260729125624.514697-5-thorsten.blum@linux.dev>
References: <20260729125624.514697-5-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1106; i=thorsten.blum@linux.dev; h=from:subject; bh=QGiDIXr/JFABPhjDOULKPBaTgQfGgcL/30YZ0jzf/x0=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFmZPyql3tQxrMmuDDyyLmTV/TVHlyYdvdN25eDm6Y9Pt s+8Uu8g3lHKwiDGxSArpsjyYNaPGb6lNZWbTCJ2wsxhZQIZwsDFKQAT6QxhZFj64u+Oid5vz6Xo Sk93Z357+IK/8soLu94/cDOad/varT1XGBkOyWtG3mLwVt4Y8cz75qej7n4TRY18b2X6Rz/qZVt xTIIDAA==
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Both sgx_ioc_enclave_init() and __sgx_virt_einit() use the same 304-byte
launch token. Use SGX_LAUNCH_TOKEN_SIZE in __sgx_virt_einit() instead of
maintaining a second local definition.

Reviewed-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 arch/x86/kernel/cpu/sgx/virt.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/virt.c
index 6a1933ddc6fc..7c5ac5d38ee1 100644
--- a/arch/x86/kernel/cpu/sgx/virt.c
+++ b/arch/x86/kernel/cpu/sgx/virt.c
@@ -395,9 +395,8 @@ static int __sgx_virt_einit(void __user *sigstruct, void __user *token,
 	 * All other checks deferred to ENCLS itself.  Also see comment
 	 * for @secs in sgx_virt_ecreate().
 	 */
-#define SGX_EINITTOKEN_SIZE	304
 	if (WARN_ON_ONCE(!access_ok(sigstruct, sizeof(struct sgx_sigstruct)) ||
-			 !access_ok(token, SGX_EINITTOKEN_SIZE) ||
+			 !access_ok(token, SGX_LAUNCH_TOKEN_SIZE) ||
 			 !access_ok(secs, PAGE_SIZE)))
 		return -EINVAL;
 
