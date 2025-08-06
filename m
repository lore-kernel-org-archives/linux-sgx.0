Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8648220F3F;
	Wed,  6 Aug 2025 08:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754468067; cv=none; b=GjogsnUlMRsMo2QLGluq0X6vY/Qk436ErgaSqtfnsH8hc2rDvzH5dCjk347D3M6pUKngNzjY1JDcCaQ+dt37G6ssvWh3ADlaOi3aHgBzNKc5OduUjJm0mInekCXftljcLVL1fovC7BwMRT2jZaZ9tpu276fnIjT/vqiLy49yXTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754468067; c=relaxed/simple;
	bh=1vILbtknjr4uoWGY1Re0hlIjHowCPUrx0wSo5cKjZf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KEHqZwmS8veLzWHSIlxoDI+x3GTcwlBVd1zkeLOrALwJqYPdByHqkA84007TOpKKihJWxzMBxM3BPyvLk2usfFYVcXy1r2FPCtW57aCLqvSFDZiTI215DhJBf54QFaq25I66/WjiYglexMLnXJNpz0o5CRHyqzllsp5j4HyXXTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CbEaEyCU; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CbEaEyCU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754468066; x=1786004066;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1vILbtknjr4uoWGY1Re0hlIjHowCPUrx0wSo5cKjZf4=;
  b=CbEaEyCUDvcKTHWoTPuKWgTCRBxvIsA6FbqA2z59g+28sg8GaylBrWaj
   PctFMoQASU6lBXvNwe1pK5RvJmHIn7b6kEgVWK+FFqSj6lOTM4vlG8Iam
   N1gd/NGIHFiojDa1sRhDl0jklTKdYIbfV5kEJ1gMCBlg7NR/E+6zk5u43
   l7GLRKDVYC3B8dFrjwL6VSiIiFazZqDSU8RejQghVLHXotzKoQjt2lcmF
   UONHwfpTZzEOO0UNBbvXR2Eyu6gpETYHTgW8PINHd5nT4Krt1PaLt1ZJu
   prktcY+iok8k/1TAwms3Avja9soaVNIxQgC3QV3sy8S5bXsQJODtfSbbp
   w==;
X-CSE-ConnectionGUID: S51//p0ZSWeHiULfnKAQGw==
X-CSE-MsgGUID: bLzyPVmDSKqw/kNB5U2n1Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11513"; a="56853647"
X-IronPort-AV: E=Sophos;i="6.17,268,1747724400"; 
   d="scan'208";a="56853647"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2025 01:14:24 -0700
X-CSE-ConnectionGUID: RBQS5ZuSR5OUT+lC1L6jEg==
X-CSE-MsgGUID: BNpT2Q5mSKmq9gr30eJheQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,268,1747724400"; 
   d="scan'208";a="169168499"
Received: from sschumil-mobl2.ger.corp.intel.com (HELO eresheto-mobl3.ger.corp.intel.com) ([10.245.244.125])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2025 01:14:18 -0700
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
Subject: [PATCH v11 3/5] x86/sgx: Define error codes for use by ENCLS[EUPDATESVN]
Date: Wed,  6 Aug 2025 11:11:54 +0300
Message-ID: <20250806081344.404004-4-elena.reshetova@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250806081344.404004-1-elena.reshetova@intel.com>
References: <20250806081344.404004-1-elena.reshetova@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add error codes for ENCLS[EUPDATESVN], then SGX CPUSVN update
process can know the execution state of EUPDATESVN and notify
userspace.

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
---
 arch/x86/include/asm/sgx.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
index 6a0069761508..2da5b3b117a1 100644
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
+	SGX_NO_UPDATE				= 31,
 	SGX_UNMASKED_EVENT		= 128,
 };
 
-- 
2.45.2

