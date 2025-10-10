Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB5B26561D;
	Fri, 10 Oct 2025 08:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760086468; cv=none; b=f8jUPmUlVEa9fenJwoxQPn9yB1eDz6ybNb/vXZsApFojeJbA7kjmQJ/0UgA866i1Jq1AA8n8TzEd3Wzq4aW4U1vQ5PD9UHNC1ggfxcTg7lMutL6ZbUg/p/ST6nnqrhuVR7cz4d5F474cgqKphOgGPLl2MPeXFAzp+VMhKJP/L9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760086468; c=relaxed/simple;
	bh=omk+H227w99hQHnvhhAyXagsaFNACP5FrVuwGpjF8XU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uJ279Q+5vcdEfe2flFy9Xj0rbEXdsksvVsBtJPwHbNOg7QjhQPnnv+QNUkrIgTleRJMkbcIClpgHDoxtnE3Xjc3wifNLhSZ+7CDrOuhd59GVtCJSbtOcUfkYP7pL4L9XL8f614pKJ5LwzpEGSvNFiqEMGIc3yBla+hZx0fC/Eyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CHHmkm28; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CHHmkm28"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760086467; x=1791622467;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=omk+H227w99hQHnvhhAyXagsaFNACP5FrVuwGpjF8XU=;
  b=CHHmkm28KjoAEfPnlNHu4CehIO4c5eP3EVbT5nzO63F/UCTvMCBY9FSR
   XLEbVoi0PAims8fDtZa9GztdKR3iLEv6QOOE5xHgLE7Huu+RkMqNHpE+m
   EpLZoEttkZPRd2S5UGEmENIvanrN4KRD9VgEDRY0wa1flQVCVdPxkE5Vz
   POMHRYZ7w/hv3yX1Yudz3GdQ4iuc2xfcKQLWwJU7ZC6yavRNoOf6t7KDR
   BMeBuNnhltv4FGUFKzMNs78XF8w+U62xsefX2NHnj1KIGc6x37gl3ypHs
   B+0omH6l9RY8veDPZd0o0n9J6iO9hGArp4bWMCvKYmtRThKH+eTz+V1T+
   w==;
X-CSE-ConnectionGUID: 4Lmf88vPSr2X/tNgAx8iIQ==
X-CSE-MsgGUID: Rqaq8JqfSVyzlAiCGfP+PQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11577"; a="62188040"
X-IronPort-AV: E=Sophos;i="6.19,218,1754982000"; 
   d="scan'208";a="62188040"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2025 01:54:27 -0700
X-CSE-ConnectionGUID: 8Oa6ullQT/acsEBF8TxT0Q==
X-CSE-MsgGUID: Z4V1DSFfTtavonL60Bk0QA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,218,1754982000"; 
   d="scan'208";a="180181667"
Received: from mjarzebo-mobl1.ger.corp.intel.com (HELO eresheto-mobl3.ger.corp.intel.com) ([10.245.245.124])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2025 01:54:21 -0700
From: Elena Reshetova <elena.reshetova@intel.com>
To: dave.hansen@intel.com
Cc: jarkko@kernel.org,
	seanjc@google.com,
	kai.huang@intel.com,
	mingo@kernel.org,
	linux-sgx@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	asit.k.mallick@intel.com,
	vincent.r.scarlata@intel.com,
	chongc@google.com,
	erdemaktas@google.com,
	vannapurve@google.com,
	bondarn@google.com,
	scott.raynor@intel.com,
	Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH v16 3/5] x86/sgx: Define error codes for use by ENCLS[EUPDATESVN]
Date: Fri, 10 Oct 2025 11:52:09 +0300
Message-ID: <20251010085346.292287-4-elena.reshetova@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20251010085346.292287-1-elena.reshetova@intel.com>
References: <20251010085346.292287-1-elena.reshetova@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add error codes for ENCLS[EUPDATESVN], then SGX CPUSVN update process can
know the execution state of EUPDATESVN and notify userspace.

EUPDATESVN will be called when no active SGX users is guaranteed. Only add
the error codes that can legally happen. E.g., it could also fail due to
"SGX not ready" when there's SGX users but it wouldn't happen in this
implementation.

Reviewed-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Tested-by: Nataliia Bondarevska <bondarn@google.com>
---
 arch/x86/include/asm/sgx.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
index 6a0069761508..73348cf4fd78 100644
--- a/arch/x86/include/asm/sgx.h
+++ b/arch/x86/include/asm/sgx.h
@@ -73,6 +73,10 @@ enum sgx_encls_function {
  *				public key does not match IA32_SGXLEPUBKEYHASH.
  * %SGX_PAGE_NOT_MODIFIABLE:	The EPC page cannot be modified because it
  *				is in the PENDING or MODIFIED state.
+ * %SGX_INSUFFICIENT_ENTROPY:	Insufficient entropy in RNG.
+ * %SGX_NO_UPDATE:		EUPDATESVN could not update the CPUSVN because the
+ *				current SVN was not newer than CPUSVN. This is the most
+ *				common error code returned by EUPDATESVN.
  * %SGX_UNMASKED_EVENT:		An unmasked event, e.g. INTR, was received
  */
 enum sgx_return_code {
@@ -81,6 +85,8 @@ enum sgx_return_code {
 	SGX_CHILD_PRESENT		= 13,
 	SGX_INVALID_EINITTOKEN		= 16,
 	SGX_PAGE_NOT_MODIFIABLE		= 20,
+	SGX_INSUFFICIENT_ENTROPY	= 29,
+	SGX_NO_UPDATE			= 31,
 	SGX_UNMASKED_EVENT		= 128,
 };
 
-- 
2.45.2

