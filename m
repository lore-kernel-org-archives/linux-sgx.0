Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A0FD26A08A;
	Thu, 14 Aug 2025 07:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755157040; cv=none; b=qTI4G0bQ0uZ5cUXImq0XkLi6A2cx2UjUzC7unmwdKJhcEc4qts3sIaNPXaQo5KmV3+5YgOQnK8qWbl9g0/Lx6ygDQCqWzR49EIjS2Z6QYMImNyKRJymNDtiSbPfAdoU9KX7Q92cjgR751WiEZPm3Wu+y29G1ZfFii2lf3aEufes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755157040; c=relaxed/simple;
	bh=xBr7NCzOZ/LYGCsQhUYvCky1Z65cR7U+1ywo9OtqRHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KG+zSCUX6ZYBdZ2gT4gqCDt7ja7sXkN8BN3TZlkjySagoDQh53zlzCM9VHQDayRwcNvbh04Uzclgs+thJMZczbe1fJiOR/e5S/xRpcX5HV+NiJoIMiyNNbkM2JBNS/BDBOoTFy8wt16A/Yvcxu04FltLftJnxbpS0y1izYvWgUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WeGOtGyW; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WeGOtGyW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755157038; x=1786693038;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xBr7NCzOZ/LYGCsQhUYvCky1Z65cR7U+1ywo9OtqRHQ=;
  b=WeGOtGyWub6rBqEkeZBIsH233K+HAy2EZ2dRFfBA5RA/h1sJIfNJqyeK
   8ppf64Md0kBiZ8LBKAPw0xJTRTvHzl0jW31147rUHdhti5AUB/GZ+RDpz
   tKTffBmjXRnl+Pk6X6hDGOnX5R4wQgfe33+aiN5ffUjETLaACxpXuAu0H
   JP+pVtOYaaPnuJIgZy/c18aTsrJXEd60cAtm/rwpC42n4rrQIpPUZkTaX
   yFvWhWtkVbvWXnNaNmTzx/7aSNJjFZ/USY/sc5E/nfi7Zg/d6pea+UknJ
   oG08omyMQS3WWfXzEpVDNp0ZDQ2EiIXOmD6yFECdjBJE80LydryFqK6Fn
   w==;
X-CSE-ConnectionGUID: IIckhhEvSYaW1unlMZYP6Q==
X-CSE-MsgGUID: LxqRDup6SUe5WsuCXwsGOg==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="82899373"
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="82899373"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 00:37:18 -0700
X-CSE-ConnectionGUID: 6qN9i1tjQUeC0Vige/fg8w==
X-CSE-MsgGUID: 5nGPWQU2R36MpCBia6xbLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="171927392"
Received: from foboril-desk.ger.corp.intel.com (HELO eresheto-mobl3.ger.corp.intel.com) ([10.245.244.138])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 00:37:13 -0700
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
Subject: [PATCH v14 3/5] x86/sgx: Define error codes for use by ENCLS[EUPDATESVN]
Date: Thu, 14 Aug 2025 10:34:23 +0300
Message-ID: <20250814073640.1507050-4-elena.reshetova@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250814073640.1507050-1-elena.reshetova@intel.com>
References: <20250814073640.1507050-1-elena.reshetova@intel.com>
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

