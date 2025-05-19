Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15FDC266565;
	Mon, 19 May 2025 07:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747639604; cv=none; b=Gad0hUdqYiI4b6+9YtNIX4DktQn9dkpo8CLHsOhwbGbnbepdeayxHWm6qpsoYVtNO7CsBEsQIsnLi+1gnBeTE1WdFkLJ1OAOez9hUxi+zyp96gZmzDgI5GLPp5+K9/MArMG+Zl3ST89QA05oZo8Cf7uy1MjY/4CfAVspp56BrMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747639604; c=relaxed/simple;
	bh=BIK0r4BaExouu0FiYPQHdUSzxmpZDIGwQoDlTSdUcRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I5yh0+sTRu9V/YV6I243JLatu59xhR2UIRSLodmIr5KkvxPv9WJ0VjxNV+yFbnHsqs2yPi/3RmTUDuZstdpE7xDqGd7tVhLnS+Tv3SaIEiNHQ+SABo3+BZ2DaHIrvQkGz4/B3035Gd/cTMg949tD8lQMtw4Nyam/P9To18qUmxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YS7x8vdz; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YS7x8vdz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747639603; x=1779175603;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BIK0r4BaExouu0FiYPQHdUSzxmpZDIGwQoDlTSdUcRk=;
  b=YS7x8vdz6HB2UJVT00Nux7ulz3LfK1cp+rbMZa0r24Y4ibT8NdYUoYdJ
   abGtSorscj/EVMZZ2OCIaR9lWTs9sEB94Ez94Kr/FViW3yBmQSXU5kZL2
   FuQLZFGosYEbCnxHbUZ6YU7IO5vYTXGzXcbUglp/x8OSC2eDJx5u3xUu+
   GyOaPCCtV6xTrq2857yzW0nT/PfrVISiriqZz6DSA+rJZc59QRTAT3zSd
   3SZ5NXFOp+ycoEhiXuL0i+JJR3VMqzBguO+c/2v0xN6iLS0iq1FxqEfd4
   3hl2Ekq8LLqGm924STkNHebXUVunePHfOppo3V496IVIUm+R2EdpyvpEP
   A==;
X-CSE-ConnectionGUID: GKVK3hl/QjGcXN/Uuh3IxQ==
X-CSE-MsgGUID: /g4l1y+aQxmJv4wg5LIltw==
X-IronPort-AV: E=McAfee;i="6700,10204,11437"; a="49591605"
X-IronPort-AV: E=Sophos;i="6.15,300,1739865600"; 
   d="scan'208";a="49591605"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 00:26:43 -0700
X-CSE-ConnectionGUID: 5e50GbfXTOWNBTkdBmxc9Q==
X-CSE-MsgGUID: 6KqnI+cqRnmh5SIQC9FQ+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,300,1739865600"; 
   d="scan'208";a="139029757"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO eresheto-mobl3.ger.corp.intel.com) ([10.245.244.195])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 00:26:38 -0700
From: Elena Reshetova <elena.reshetova@intel.com>
To: dave.hansen@intel.com
Cc: jarkko@kernel.org,
	seanjc@google.com,
	kai.huang@intel.com,
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
	Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH v5 3/5] x86/sgx: Define error codes for use by ENCLS[EUPDATESVN]
Date: Mon, 19 May 2025 10:24:29 +0300
Message-ID: <20250519072603.328429-4-elena.reshetova@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250519072603.328429-1-elena.reshetova@intel.com>
References: <20250519072603.328429-1-elena.reshetova@intel.com>
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
 arch/x86/include/asm/sgx.h | 39 +++++++++++++++++++++++---------------
 1 file changed, 24 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
index 6a0069761508..0361a6f91359 100644
--- a/arch/x86/include/asm/sgx.h
+++ b/arch/x86/include/asm/sgx.h
@@ -28,21 +28,22 @@
 #define SGX_CPUID_EPC_MASK	GENMASK(3, 0)
 
 enum sgx_encls_function {
-	ECREATE	= 0x00,
-	EADD	= 0x01,
-	EINIT	= 0x02,
-	EREMOVE	= 0x03,
-	EDGBRD	= 0x04,
-	EDGBWR	= 0x05,
-	EEXTEND	= 0x06,
-	ELDU	= 0x08,
-	EBLOCK	= 0x09,
-	EPA	= 0x0A,
-	EWB	= 0x0B,
-	ETRACK	= 0x0C,
-	EAUG	= 0x0D,
-	EMODPR	= 0x0E,
-	EMODT	= 0x0F,
+	ECREATE		= 0x00,
+	EADD		= 0x01,
+	EINIT		= 0x02,
+	EREMOVE		= 0x03,
+	EDGBRD		= 0x04,
+	EDGBWR		= 0x05,
+	EEXTEND		= 0x06,
+	ELDU		= 0x08,
+	EBLOCK		= 0x09,
+	EPA			= 0x0A,
+	EWB			= 0x0B,
+	ETRACK		= 0x0C,
+	EAUG		= 0x0D,
+	EMODPR		= 0x0E,
+	EMODT		= 0x0F,
+	EUPDATESVN	= 0x18,
 };
 
 /**
@@ -73,6 +74,11 @@ enum sgx_encls_function {
  *				public key does not match IA32_SGXLEPUBKEYHASH.
  * %SGX_PAGE_NOT_MODIFIABLE:	The EPC page cannot be modified because it
  *				is in the PENDING or MODIFIED state.
+ * %SGX_INSUFFICIENT_ENTROPY:	Insufficient entropy in RNG.
+ * %SGX_EPC_NOT_READY:			EPC is not ready for SVN update.
+ * %SGX_NO_UPDATE:		EUPDATESVN was successful, but CPUSVN was not
+ *				updated because current SVN was not newer than
+ *				CPUSVN.
  * %SGX_UNMASKED_EVENT:		An unmasked event, e.g. INTR, was received
  */
 enum sgx_return_code {
@@ -81,6 +87,9 @@ enum sgx_return_code {
 	SGX_CHILD_PRESENT		= 13,
 	SGX_INVALID_EINITTOKEN		= 16,
 	SGX_PAGE_NOT_MODIFIABLE		= 20,
+	SGX_INSUFFICIENT_ENTROPY	= 29,
+	SGX_EPC_NOT_READY			= 30,
+	SGX_NO_UPDATE				= 31,
 	SGX_UNMASKED_EVENT		= 128,
 };
 
-- 
2.45.2

