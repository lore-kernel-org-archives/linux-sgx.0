Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60C1E27933E;
	Mon, 18 Aug 2025 07:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755501221; cv=none; b=QzSqeLHVMy94N8ZTgl1mwox9HbmuXxWBDMP16ePz341gW2k1OU+Gs4eOvdnQNeBJmqggyQQyFxAGm+/cZCBzLw3FyKJlS1WqAq3BCZdC0mWQCfumIVvP319074Hc1W+zBYbDVDSRmB5MQRoeeeIpgLJWwZj9s3HI31YbxMef6n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755501221; c=relaxed/simple;
	bh=xBr7NCzOZ/LYGCsQhUYvCky1Z65cR7U+1ywo9OtqRHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NBhJtS2T3N1eLSellGJg0AbWBK/sPLyQGMSv5tTvdrVAC4RLM9uaS3QRLT0I2bwEHDoeGlwO4VzNL4+WgK2WR9MpixkHsq61yzmccKihhSFsO+9InOuj1tdPW0QADN/QnmpmZQyZl6eJ2YhhLom+zYDMkhPZGAAJtd31OusgilI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jKkGnejf; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jKkGnejf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755501221; x=1787037221;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xBr7NCzOZ/LYGCsQhUYvCky1Z65cR7U+1ywo9OtqRHQ=;
  b=jKkGnejfKC9u0/Pf6dWZrgxFBnjFXBXuHJLKzkne00BDpQtbeYDZZ7ZB
   x2pwiEdq7fi3obuk7V5mokPd3g76NA9PCqPnTnHq5qEhK1OcHIde6MT8X
   ApTK7UQEmXdVDDzi6sz447gYBiAFgu4OW21sRoBb7BCiU1JKWoiMbCVBa
   WrTZhYv3dtnxb7EEM/AjXjz/xNeZWoOOnmLHEf5pIHyg+2u5TkMYtq31b
   gitmLGrPWu4V517LkMOQrY+ocUF4PbFdwbgaDN3/Ja2oi5zeWFIwu4KvO
   3NQgO1cameCYajESSAJKO4Yf/6EXUYkMEA4VwcFg3xUz33NbbcMmJOq8E
   g==;
X-CSE-ConnectionGUID: brvnXJMZTNyxvcAkf+Borg==
X-CSE-MsgGUID: F1UViC+WQTKBUPrw4Ey34Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11524"; a="68809332"
X-IronPort-AV: E=Sophos;i="6.17,293,1747724400"; 
   d="scan'208";a="68809332"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2025 00:13:40 -0700
X-CSE-ConnectionGUID: SHFQCjH3TTG6zFluiRkUvQ==
X-CSE-MsgGUID: 91idmXFNThyPsbjIemqx3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,293,1747724400"; 
   d="scan'208";a="167421438"
Received: from opintica-mobl1 (HELO eresheto-mobl3.ger.corp.intel.com) ([10.245.245.174])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2025 00:13:35 -0700
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
Subject: [PATCH v15 3/5] x86/sgx: Define error codes for use by ENCLS[EUPDATESVN]
Date: Mon, 18 Aug 2025 10:11:21 +0300
Message-ID: <20250818071304.1717183-4-elena.reshetova@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250818071304.1717183-1-elena.reshetova@intel.com>
References: <20250818071304.1717183-1-elena.reshetova@intel.com>
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

