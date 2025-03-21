Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09100229B0F;
	Fri, 21 Mar 2025 12:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742560821; cv=none; b=JYM63SY9steY+xs8RrY4WzLBPPV1+x5HL8Q2D5ZzGA6YHYdw6GGsY2eOuoJMeQ1tvQIO2D7H3aZeCsIpsc0BjURGR4vLenKM5FPycVwtUeP1ywN4V0qmJCPUssmQEIbg6Ugdzr7axIokC0aKEjDu4S1l6QBsHANlz/QKTgYUx+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742560821; c=relaxed/simple;
	bh=mA5XfBE1h2HHAvbHLdxvCnHoABS/Zu51Nyotq5kLwPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S/e4zCYRj24jjRyrl9CD7APtKz13fY6L7Z/5i22eiK0lkSmGtT/7qvaFp6vNqkWIW/P/pLmHGBK3qYKu1QOLfTFeMms2eTTOe8LXzNO9RE10sdG8+iml8jln0gOpSHWr/i53Zw1CulLvj2oqJOG6te6hFFr4d4BbdpW3QpCRt/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CjGL0H6E; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CjGL0H6E"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742560820; x=1774096820;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mA5XfBE1h2HHAvbHLdxvCnHoABS/Zu51Nyotq5kLwPw=;
  b=CjGL0H6EVGhgOu1iqFTMBp6V22jZKUiCAtBU+EdZGWDssKF8rdNFxcLB
   8wA8U8fB7ttCR/7E4T0d7jpPMlU0m/YGfY6m73FPJgeFKUNTRiIa9+Lrf
   rDzmljlDGUKoX6kVCpUgxOvdbW0y+yUHhvY80xYIJjYtncVyyEoic+42x
   oYAmXzDY9sdzT0yhGHHcZBgG80R5PwuSl5a6q2Kpw2AwuV9+/shDFn+8H
   5aD9B1SCC3AeUl4Fy/StWxbhgshMVYcmbrl9VO7z9jmxPbA1zUhToZ0iU
   Ev2rtuYvmvsuy/p6dW+ClCcKoDF6Cqxr/XvBB8r/G/oRjtRQFV2/ngRqP
   g==;
X-CSE-ConnectionGUID: GqRj+POGS7SmWdu6oJBgFA==
X-CSE-MsgGUID: yMNG4C2dQ12606c+oUMUFg==
X-IronPort-AV: E=McAfee;i="6700,10204,11380"; a="54493384"
X-IronPort-AV: E=Sophos;i="6.14,264,1736841600"; 
   d="scan'208";a="54493384"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2025 05:40:20 -0700
X-CSE-ConnectionGUID: e4Cje6NWQQSBKaHM9TB7pA==
X-CSE-MsgGUID: toG9KI/GSJWpeAKbhEXfew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,264,1736841600"; 
   d="scan'208";a="154399962"
Received: from mwiniars-desk2.ger.corp.intel.com (HELO eresheto-mobl3.ger.corp.intel.com) ([10.245.246.189])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2025 05:40:13 -0700
From: Elena Reshetova <elena.reshetova@intel.com>
To: dave.hansen@intel.com
Cc: jarkko@kernel.org,
	linux-sgx@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	asit.k.mallick@intel.com,
	vincent.r.scarlata@intel.com,
	chongc@google.com,
	erdemaktas@google.com,
	vannapurve@google.com,
	dionnaglaze@google.com,
	bondarn@google.com,
	scott.raynor@intel.com,
	Elena Reshetova <elena.reshetova@intel.com>,
	Cathy Zhang <cathy.zhang@intel.com>
Subject: [PATCH 3/4] x86/sgx: Define error codes for ENCLS[EUPDATESVN]
Date: Fri, 21 Mar 2025 14:34:42 +0200
Message-ID: <20250321123938.802763-4-elena.reshetova@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250321123938.802763-1-elena.reshetova@intel.com>
References: <20250321123938.802763-1-elena.reshetova@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add error codes for ENCLS[EUPDATESVN], then SGX CPUSVN update
process can know the execution state of EUPDATESVN.

Code is from previous submission in https://lore.kernel.org/all/20220520103904.1216-1-cathy.zhang@intel.com/T/#m1becf67078dc8c59d454e2e6c6d67ca64db341a4

Co-developed-by: Cathy Zhang <cathy.zhang@intel.com>
Signed-off-by: Cathy Zhang <cathy.zhang@intel.com>
Co-developed-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
---
 arch/x86/include/asm/sgx.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
index 6a0069761508..8ba39bbf4e91 100644
--- a/arch/x86/include/asm/sgx.h
+++ b/arch/x86/include/asm/sgx.h
@@ -73,6 +73,11 @@ enum sgx_encls_function {
  *				public key does not match IA32_SGXLEPUBKEYHASH.
  * %SGX_PAGE_NOT_MODIFIABLE:	The EPC page cannot be modified because it
  *				is in the PENDING or MODIFIED state.
+ * %SGX_INSUFFICIENT_ENTROPY:	Insufficient entropy in RNG.
+ * %SGX_EPC_NOT_READY:		EPC is not ready for SVN update.
+ * %SGX_NO_UPDATE:		EUPDATESVN was successful, but CPUSVN was not
+ *				updated because current SVN was not newer than
+ *				CPUSVN.
  * %SGX_UNMASKED_EVENT:		An unmasked event, e.g. INTR, was received
  */
 enum sgx_return_code {
@@ -81,6 +86,9 @@ enum sgx_return_code {
 	SGX_CHILD_PRESENT		= 13,
 	SGX_INVALID_EINITTOKEN		= 16,
 	SGX_PAGE_NOT_MODIFIABLE		= 20,
+	SGX_INSUFFICIENT_ENTROPY	= 29,
+	SGX_EPC_NOT_READY		= 30,
+	SGX_NO_UPDATE			= 31,
 	SGX_UNMASKED_EVENT		= 128,
 };
 
-- 
2.45.2

