Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8DEB3559F2;
	Sat, 11 Jul 2026 10:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783764085; cv=none; b=IIDa8NxiuPNhNRZU6EMvy+QJTSUZ2xLgk93jMgrl5xQ6Tl+jEftHcJFvi4JSs+aVFqnps23AtHm2YbFSPghYKvErgFoAabY1y9w47+H9OdZyHzfwEGWMMnBdmdtl5kyceDboAeqodMlr3k56S7XutSAZAM0Dsj7ae1vgIB3P4QM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783764085; c=relaxed/simple;
	bh=1qU4mKWUigMvJRHBuKaHv0I60ezML+jv7EZsMtdq5lE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kdDxIX7qmyORaacSMHmCOluQDAk0ujS08zZXtWY2eD2Fw656RFGMenptOhN3vwR/DHf1P9tyQfnCw2Fk9l4AkUBt3D/AjYyKgBwpeB2RzOxQh+46VRzbUHgSOMiqD4qRYQlK4guyVvXn7QC1cpRkvY7XJFnE4PRDV8uNQcJyi78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RFxmFK3i; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RFxmFK3i"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783764081;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1IAi3dsjEzI+J9vi3IABnMe+p9SB6MgQaxiaAcXQ8PI=;
	b=RFxmFK3idpEpUJrH4SOyd2qmkBVDaY3EGCQP/0ZHlRu7Xn+BM4VSzHNVBQJINgsC6jywsB
	JpuhCtbSxLjybc40Jml5r8rrkWjdZfijZcdBBSXJgV/+fRttS2td8V9LE6RgG0PzTXPpWi
	rrYaHNzneRHXxnkNIUQ8t/9gHTJXTpg=
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
Subject: [PATCH 2/3] x86/sgx: Remove unused size and count definitions
Date: Sat, 11 Jul 2026 12:00:56 +0200
Message-ID: <20260711100053.739588-7-thorsten.blum@linux.dev>
In-Reply-To: <20260711100053.739588-5-thorsten.blum@linux.dev>
References: <20260711100053.739588-5-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1405; i=thorsten.blum@linux.dev; h=from:subject; bh=1qU4mKWUigMvJRHBuKaHv0I60ezML+jv7EZsMtdq5lE=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFlBImEx+5p4HGTKCv2sY+/lRBku+uupO8va/8/ZqPoDf 29OdbnXUcrCIMbFICumyPJg1o8ZvqU1lZtMInbCzGFlAhnCwMUpABMRimBkeO1a+afQ8vO7U3un W07q8S/lsZj0hvfGvE2HDWfrO6iIpzP8d+L8kzOhT7CpeoXwieZd2xSED9Rf3To1/tC7zdcrBDa t4gIA
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The definitions were added with commit 70d3b8ddcd20 ("x86/sgx: Add SGX
architectural data structures"), but have never been used. The SIGSTRUCT
reserved field sizes are also redundant because the structure uses
literal sizes instead. Remove them.

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
