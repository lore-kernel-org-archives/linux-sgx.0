Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3CD25FA0E;
	Fri,  1 Aug 2025 11:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754047626; cv=none; b=Es3yX37czaaWctFfihiqE/kiOhjAkc3U91l8fVgz4chyn4TbRxVOSb/s8TGSnVKou35I+s61YGGrqKnxMtVw54BaG99wGneNu3+pui235VS1WaLT6JBDrzQJPMPqr0T//pHB5Z3K6BB5HRtqpTPrDy1SmAoIEmU2MSA+OhCs+UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754047626; c=relaxed/simple;
	bh=EqzZR6x+jlTAFlsZNXoNtgbomi6NZavFwSY55lkKRek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hYYYaA3IT235YHvXricyosuhGrtveiovWczfhkC9pWiAnlyYzQUuOu3Eq3ugjg6KyFZDPvTx6xNFah8/KffwzeieVn3G3fcYVvfZdM0/p/R/dbxLxu6pFhkMyQ74Z3uEV6oiA9cIvbwWuRdCztDSgIypU4A2Jv8Sq8uqmjOIdwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mDOiapPm; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mDOiapPm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754047625; x=1785583625;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=EqzZR6x+jlTAFlsZNXoNtgbomi6NZavFwSY55lkKRek=;
  b=mDOiapPmDic3Kf8Xo7aj7odPYce5KMArTp1UToSRtXca0qXwgZAi6Fzd
   4vJT1Lc1N85YK0c17EWy+ZyQiz8leAcPcoj0x36FnVADPbm7w33gJtt8b
   rZXXcC7SsrBZ6KbeEe+gM2Cz415DFPhKTfvAxeZxIfJouB2yFNZe7EXMU
   qOoFHw1LYksDaEww+WPeoAvliQF+8Xz+90uK2EP6myBt9XoM3K2uQDBdm
   lFuV6lp1ZXJ44MFIClzBi6SHk0TGIfU+NkZ57RpBJNZcdaf26HrLB6+5O
   RZDphxHaytEAsDLboEQzFSOdzioCSY/jZino3Dr4dUJjZ6ZQBF2x9g3AJ
   Q==;
X-CSE-ConnectionGUID: 7OpwAb9QSH+5AEcoPrT30w==
X-CSE-MsgGUID: ZBFLU9ckQdSiTNWoxtNIow==
X-IronPort-AV: E=McAfee;i="6800,10657,11508"; a="59014812"
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="59014812"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2025 04:27:05 -0700
X-CSE-ConnectionGUID: MBSxvSPrRl+qcyuhEXYxuw==
X-CSE-MsgGUID: uUyBRwnHQYiexbMolYIusw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="167727170"
Received: from sschumil-mobl2.ger.corp.intel.com (HELO eresheto-mobl3.ger.corp.intel.com) ([10.245.244.159])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2025 04:27:01 -0700
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
Subject: [PATCH v10 6/6] x86/sgx: Enable automatic SVN updates for SGX enclaves
Date: Fri,  1 Aug 2025 14:25:21 +0300
Message-ID: <20250801112619.1117549-7-elena.reshetova@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250801112619.1117549-1-elena.reshetova@intel.com>
References: <20250801112619.1117549-1-elena.reshetova@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

== Background ==

ENCLS[EUPDATESVN] is a new SGX instruction [1] which allows enclave
attestation to include information about updated microcode SVN without a
reboot. Before an EUPDATESVN operation can be successful, all SGX memory
(aka. EPC) must be marked as “unused” in the SGX hardware metadata
(aka.EPCM). This requirement ensures that no compromised enclave can
survive the EUPDATESVN procedure and provides an opportunity to generate
new cryptographic assets.

== Solution ==

Attempt to execute ENCLS[EUPDATESVN] every time the first file descriptor
is obtained via sgx_(vepc_)open(). In the most common case the microcode
SVN is already up-to-date, and the operation succeeds without updating SVN.
Note: while in such cases the underlying CR_BASE_KEY is regenrated, it does
not affect enclaves' visible keys obtained via EGETKEY instruction.

If it fails with any other error code than SGX_INSUFFICIENT_ENTROPY, this
is considered unexpected and the *open() returns an error. This should not
happen in practice.

On contrary, SGX_INSUFFICIENT_ENTROPY might happen due
to a pressure on the system's DRNG (RDSEED) and therefore the *open() can
be safely retried to allow normal enclave operation.

[1] Runtime Microcode Updates with Intel Software Guard Extensions,
https://cdrdv2.intel.com/v1/dl/getContent/648682

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
---
 arch/x86/kernel/cpu/sgx/main.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 5aae0c881963..6a5d5cd726f6 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -934,7 +934,7 @@ EXPORT_SYMBOL_GPL(sgx_set_attribute);
  *  entropy in RNG.
  * -EIO: Unexpected error, retries are not advisable.
  */
-static int __maybe_unused sgx_update_svn(void)
+static int sgx_update_svn(void)
 {
 	int ret;
 
@@ -978,14 +978,25 @@ static int __maybe_unused sgx_update_svn(void)
 	return -EIO;
 }
 
+/* Counter to count the active SGX users */
+static int sgx_usage_count;
+
+/* Mutex to ensure no concurrent EPC accesses during EUPDATESVN */
+static DEFINE_MUTEX(sgx_svn_lock);
+
 int sgx_inc_usage_count(void)
 {
+	guard(mutex)(&sgx_svn_lock);
+
+	if (sgx_usage_count++ == 0)
+		return sgx_update_svn();
+
 	return 0;
 }
 
 void sgx_dec_usage_count(void)
 {
-	return;
+	sgx_usage_count--;
 }
 
 static int __init sgx_init(void)
-- 
2.45.2

