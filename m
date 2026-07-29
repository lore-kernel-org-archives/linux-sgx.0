Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234BF481249
	for <linux-sgx@vger.kernel.org>; Wed, 29 Jul 2026 12:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785329826; cv=none; b=S+MISi0z40C51zx5Q8CqJ0yYnLbFrPRZERtHTTiYPOaqR6ADE/8n8JCrTTfQ4z5pJHanyr62IjM4x9RLIE1fjHujM7DIfTimqdnupkxwSbk6dc2NyzhAMCx4AT12JRdtr8TU49S/jwkG2Gqwzmz3/H8jyjNX0KQN+SlAzYtNJ9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785329826; c=relaxed/simple;
	bh=X3c6XvG2/LESDQ+Yp7+0SIyjLL+XS4QEg9i4rVb4ph0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EC1VO4SNygLPOVKK8yvK53NhGpOQebKkXy1DQ3pW/cFLCoHfu/OsiQoTsNVMPXK1DYsRPsEIktAgXp+R7y7XEI0RkPiHsaanrAhIj4G+5eo8dY1o2w5Z/pp3b6cd5o70kTJL7yUo+PAp3YaCfeEcCvnpY1hNUIZsRm29h4oJ0ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=dY6d+izg; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dY6d+izg"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785329812;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X3aphzRXumDmdlbsIh55xAxufrVnOLM3ez70dreKOfo=;
	b=dY6d+izgpHq4swQqcbl9171H1LZ9dFOhhOhJMZCG6NFNkm00BqyjkZQp2Adp5KNHiBhrs0
	qKn1szoI/9XCMS7G12IjMtkJ1rR91cSquw0+lc6BL9IK3H7fRzQNbN5WScEjuJa1LHXPch
	TeKpgTTd5W+wjrZAUa1J6HbS72yqsYM=
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
Subject: [PATCH v2 2/3] x86/sgx: Remove unused size and count definitions
Date: Wed, 29 Jul 2026 14:56:27 +0200
Message-ID: <20260729125624.514697-7-thorsten.blum@linux.dev>
In-Reply-To: <20260729125624.514697-5-thorsten.blum@linux.dev>
References: <20260729125624.514697-5-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1498; i=thorsten.blum@linux.dev; h=from:subject; bh=X3c6XvG2/LESDQ+Yp7+0SIyjLL+XS4QEg9i4rVb4ph0=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFmZPypLumu2vRK/+2Vedrqc5HVlFwYJL0XG0nVv+t1T3 fxMszw6SlkYxLgYZMUUWR7M+jHDt7SmcpNJxE6YOaxMIEMYuDgFYCJ+hxj+6V1Xu3cnkPtC4ta5 5TPfHg1ufn8h1zfJ/9YnmzjH5o49Egx/OC9XPDbgf3jAxP/KLwd1mT8ZFjWRZTzLni/eWWjbolD FDwA=
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The definitions were added with commit 70d3b8ddcd20 ("x86/sgx: Add SGX
architectural data structures"), but have never been used. The SIGSTRUCT
reserved field sizes are also redundant because the structure uses
literal sizes instead. Remove them.

Acked-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 arch/x86/include/asm/sgx.h | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
index fe106c55a593..af5cd6ce9010 100644
--- a/arch/x86/include/asm/sgx.h
+++ b/arch/x86/include/asm/sgx.h
@@ -108,9 +108,6 @@ enum sgx_miscselect {
 
 #define SGX_MISC_RESERVED_MASK	GENMASK_ULL(63, 1)
 
-#define SGX_SSA_GPRS_SIZE		184
-#define SGX_SSA_MISC_EXINFO_SIZE	16
-
 /**
  * enum sgx_attribute - the attributes field in &struct sgx_secs
  * @SGX_ATTR_INIT:		Enclave can be entered (is initialized).
@@ -227,7 +224,6 @@ enum sgx_page_type {
 	SGX_PAGE_TYPE_TRIM,
 };
 
-#define SGX_NR_PAGE_TYPES	5
 #define SGX_PAGE_TYPE_MASK	GENMASK(7, 0)
 
 /**
@@ -288,11 +284,6 @@ struct sgx_pcmd {
 	u8  mac[16];
 } __packed __aligned(128);
 
-#define SGX_SIGSTRUCT_RESERVED1_SIZE 84
-#define SGX_SIGSTRUCT_RESERVED2_SIZE 20
-#define SGX_SIGSTRUCT_RESERVED3_SIZE 32
-#define SGX_SIGSTRUCT_RESERVED4_SIZE 12
-
 /**
  * struct sgx_sigstruct_header -  defines author of the enclave
  * @header1:		constant byte string
