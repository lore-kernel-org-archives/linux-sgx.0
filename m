Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794573930;
	b=VcDxErhcChDGGGbEg1Pq02Ou3/JbuhX0g1IGNPlC/MzuG8MO+uB+TcNqtWXTd5toni6T
	 hOswZ3ioOGw0WanxQo+vBT7OErPtMh673/UAOLQLlEnJlNILapZu3s5f6li4TCm3YMmLn
	 O4u6eF6SDmJUOCblESa5SEiBJyGGzqcJbde37V5y1fV2bLQ12v4lxOPkrGzssx0R+fXWE
	 4bYM0U+/+xg7IwjI60i75HoYwNbbcrIhDM2ttIfwfCRFgrWHJuGk8FrMJVUDnFZZ+pdHO
	 /pquVjo5Bdo/x4uPVsTJuXPa0FuLPpRNyM2RbR1sRRw3S7c6Tsdi2h4UapSCmCIUT3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794573930;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:X-Developer-Signature:
	 X-Developer-Key:Content-Transfer-Encoding;
	bh=KMXReMhXYVZD2NLOqrCcax4dDoOfXYb/orwkzfp02xM=;
	b=qt0NIrVSXn5bSdPKVqWaFUd6z/NOsaZD3O86IChlXhcOKXwQTdNv5fEo4rOU42FJodbH
	 xNhfuk64qTe63gs2HznGBmSoX5wiP94Mukiz114337pTM619WYFCVUEI/XaYLN8xCuLIW
	 ITe7xYOItH0hgCBjajSnUZupruD7QCY72Bqm9qOMy1C5fLuIrqo8B2pfomW3W7xxxxUoa
	 wx5my3pSR1/dGJELMMH45JpDAqfiPu8C4+Iwh3F81EdUcadLlFLLOSjfH0RDdpJFAb3TR
	 QeLOrqZErBKqdhcyo+kqUcd6r19d1vVRFpbvZbDhhKbE91I58Bm4sJyXZzZfrMJP3mQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SCuYYgGE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E36D606A338;
	Fri, 13 Nov 2026 12:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SCuYYgGE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C2BC1F000C7;
	Fri, 13 Nov 2026 12:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794573929;
	bh=KMXReMhXYVZD2NLOqrCcax4dDoOfXYb/orwkzfp02xM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SCuYYgGEg2fp8C8m+lYWl2gF3n78YYLHuf42KD9Aiz8dMcAMayFIc4q5niu5b+rXo
	 c8u+vu5r7Tc5lL8Z333gHUZad5fcHLmqPieKfc5EYDZXO/SPn03V9kUoXjkNwU58Tr
	 R+MWbwgVhyR1hP3Ay0P+TKNOEShxYjRMPHxG46Iy56K6DJZzdld00yKlwWJu3SEXii
	 KVTcUYq38sv+mSXzbi4pxlC6FnP/ShD1tRCpyru+Fhwo9bc4Ggcj9jvmt1LpB0jZpN
	 UCLN5Qa/MtGnmjKsj/Q7GWasPh4qRr8frfde/rXS0ojtBm9dwvS4spkmHUShjknuHH
	 KbgR04TiwvnBw==
From: Thorsten Blum <blum@kernel.org>
To: Jarkko Sakkinen <jarkko@kernel.org>,
	Kai Huang <kai.huang@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org
Cc: linux-sgx@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Thorsten Blum <blum@kernel.org>
Subject: [PATCH RESEND v2 2/3] x86/sgx: Remove unused size and count definitions
Date: Fri, 13 Nov 2026 13:44:51 +0100
Message-ID: <20261113124448.70586-7-blum@kernel.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261113124448.70586-5-blum@kernel.org>
References: <20261113124448.70586-5-blum@kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Post: <mailto:linux-sgx@vger.kernel.org>
List-Help: <mailto:linux-sgx+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sgx+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1490; i=blum@kernel.org; h=from:subject; bh=vAf2C64KMrWZ7HWV/CthkUS15iLLCpHjpXStTrHoy+g=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFnf2dxtr3Qt+tK4wuT8i8e64lduFuT2h874+y8yWesm8 5H4GsvPHaUsDGJcDLJiiiwPZv2Y4VtaU7nJJGInzBxWJpAhDFycAjCRLElGhgVJZxgWrDj03DxG gGuvrYwPY4vz11CN69zPn3bMcWg/2cbI8DQ48cbJsnm8uzdsil8m2i5rm/1t76s/lhm6s1MPT0s vZwAA
X-Developer-Key: i=blum@kernel.org; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit

The definitions were added with commit 70d3b8ddcd20 ("x86/sgx: Add SGX
architectural data structures"), but have never been used. The SIGSTRUCT
reserved field sizes are also redundant because the structure uses
literal sizes instead. Remove them.

Acked-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Thorsten Blum <blum@kernel.org>
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
