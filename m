Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523F12DCF7E;
	Mon, 11 Aug 2025 09:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754903311; cv=none; b=UXTQvAYu3P7fio1Zzuv9c1bNPyFLQgNUmx5s63/n573bYr+VGzxhbP8Qb2OZl59Vho0abq2wRJaKV+vUenUNsKw2MCJulM3swoQ/7StSgDT34VbmoRsDT9jnNxlVUQ9JFUNyJBimMtkccSRzeyl07TT66qprOR1isaWVvrwiFZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754903311; c=relaxed/simple;
	bh=Q5C4talUa9WgY0lA7omzhzCuzvoG5IymBWPJkJuDiZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aViY1BmHLMZo+6ukTL6Z5zeGj+yg+ItKzMPn/2IdV/OtXX9hCRP+jeHHrOmcMkjt9zSZzJWPMV2WN9xYt3qaTBTDuVs/03OzOG944BAUZyxkcuZ/bnqY5FlAnPIVHOaawmuf6uzHDoTWW5JUHM8oYIs06LG5CFr0nSccW+TO+EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b6PPSrho; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b6PPSrho"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754903310; x=1786439310;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Q5C4talUa9WgY0lA7omzhzCuzvoG5IymBWPJkJuDiZE=;
  b=b6PPSrhon6vX65jllYB6V25Bygiapmwrd2VuupT3Bqs/o9XjZupSQLqO
   nfbnlDIIUzQRVi//SyGsBIGcjK4ZXIsssqJ4k/zL0NUnSVR5oYojHfM4m
   jH5zZV/n5qLdC8TltAo1B93hSlwZFnxp1+A6u/WAzJfnOkQuWE4UgFGK5
   yWSsKIMM3lu8WcxBipdrQ3XXc6C5mm69FauvJ3hOlPlPXEm4u4yUp6Eno
   x4vnlY2a3VVofwXOu9f6+tlTbIchM5XP+vAQsYV6ciZPOLeZo5cgWjEF2
   2OKonw9Of797jep9WIru6wblPBOrz+S2zRnu0CK12wmluznDUgIBu6asq
   w==;
X-CSE-ConnectionGUID: ykgIwx6pQQyzJ0ru9RQ09w==
X-CSE-MsgGUID: Nm++N0qmRDi+w+ay7QjGMA==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="57108590"
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="57108590"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 02:08:30 -0700
X-CSE-ConnectionGUID: yomuKRBwTvyQVjFLhuB6Vw==
X-CSE-MsgGUID: foU+UAqHRou9WgN3+gT1qg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="166222086"
Received: from bergbenj-mobl1.ger.corp.intel.com (HELO eresheto-mobl3.ger.corp.intel.com) ([10.245.244.162])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 02:08:25 -0700
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
Subject: [PATCH v12 3/5] x86/sgx: Define error codes for use by ENCLS[EUPDATESVN]
Date: Mon, 11 Aug 2025 12:06:07 +0300
Message-ID: <20250811090751.683841-4-elena.reshetova@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250811090751.683841-1-elena.reshetova@intel.com>
References: <20250811090751.683841-1-elena.reshetova@intel.com>
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

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
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

