Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0785C337696;
	Thu, 16 Oct 2025 13:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760620445; cv=none; b=W04WOdcrUeqVZ/JmPCpLm4uomvQVkYIiE1NAOWBDRcKRfWh9hliEojLWyF3Oo/NHGueqEPqvFQxF6hbBDeJwntTaMqYlKQHY1jfV2NsqTwVLXY/fmvozo96ZWp+4/vCQopTbtrtG59dW0bwU9VcntdXXwAA8TQne4ewHE/HF18I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760620445; c=relaxed/simple;
	bh=omk+H227w99hQHnvhhAyXagsaFNACP5FrVuwGpjF8XU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xawv7dYOmYGWYvA1vD3yko6OTaRUD5/rYIX99kLd0S2PZ8qbKGjYPjGPQZ7XB//vlbLaymMc63NUetC+DBjfBFRrb85Wr73/2Vl8fszoDVg27zfxwew8MwWp+yUyqYSirWnjl130pvQawHo/xFnL2B+38d5UOE/+lc3WvDSayUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Qmgt1mwY; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Qmgt1mwY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760620444; x=1792156444;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=omk+H227w99hQHnvhhAyXagsaFNACP5FrVuwGpjF8XU=;
  b=Qmgt1mwYjMaSW0ndPglyZefZz2lVX5hDMdBznp8M5iuwmeRcNpoe+WPB
   qksPVhl9swWJ5PJ/Tn1FWwg9WiWG9v8x2nVF1707IsDdsTlGIun8vRdEs
   kTYdJuPqLIx+dN+OK7i3mHySu2dgA8gmDP/rP4paSWCy3UB0C4cvloWZB
   GUG7bT4o7Hj0kNRhDsBdR813+MH6490oj9oHfU/o5wzZo6lG7l2I4iFp1
   QXjxMF/v6IGpsTOTP5AWNjNptM74XJEVFMo643DdWrYc6Q3KniSbYSCtp
   uhUhPJYoCUO7jpkvR4GDoBpd2u+3IlTKBOl+5VE7eZYiC3Ed5coFwIAeB
   g==;
X-CSE-ConnectionGUID: wCBIrgH/TVOYp6NS8ryumw==
X-CSE-MsgGUID: wvksVGIzSYmnJSxS2jBPmQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11584"; a="62904735"
X-IronPort-AV: E=Sophos;i="6.19,234,1754982000"; 
   d="scan'208";a="62904735"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2025 06:14:03 -0700
X-CSE-ConnectionGUID: xiRynRS3QfyAJx1oznHoFw==
X-CSE-MsgGUID: RilIYjLYQ+aaMhkbxHAnFA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,234,1754982000"; 
   d="scan'208";a="182016005"
Received: from klitkey1-mobl1.ger.corp.intel.com (HELO eresheto-mobl3.ger.corp.intel.com) ([10.245.244.10])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2025 06:13:59 -0700
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
Subject: [PATCH v17 3/5] x86/sgx: Define error codes for use by ENCLS[EUPDATESVN]
Date: Thu, 16 Oct 2025 16:11:06 +0300
Message-ID: <20251016131314.17153-4-elena.reshetova@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20251016131314.17153-1-elena.reshetova@intel.com>
References: <20251016131314.17153-1-elena.reshetova@intel.com>
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

