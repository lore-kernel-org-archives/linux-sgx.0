Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11F8286D53;
	Thu, 22 May 2025 09:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747905808; cv=none; b=hPYN0GEgO5Na8HcImhJGVZDAYmdt2e871MwjEGJtUr75ZNlBke9GlX8EjEBB9hPYM8m29Or6kcAzzP4pGmxsXn1rBrErMABDEr8NI27+NUqIQAw6rkwNXQR40GE+4ZFZwO/d+xPy37G9ATGEznM6+2J8rGZ2inB7xCk5A/maB7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747905808; c=relaxed/simple;
	bh=MinhFm0PGjr1VPx3DakOEMjlIRpdXNwH0lAO/loccDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rsa+PZz1NiiBKDT2l7thhvLBxGlQEUWrSLt60/evhw5DUXhLeJG5zqQmsw60EqDMjnx0q1af2FeYaiO9mrfa23K9vacatCAqVGxULoKm2d4NA7V8qJDzOtime59NCETrmkL0pzX1ZNLx175dBCkTBXXf9RctrSTbXp/ORtrxMHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=djDVfTQK; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="djDVfTQK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747905807; x=1779441807;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MinhFm0PGjr1VPx3DakOEMjlIRpdXNwH0lAO/loccDY=;
  b=djDVfTQK2wcQhaDEuOYbMutSl71qmEe1uTPU4azKT5rp35zNyFbEsrgd
   yWSKAJEmEgmZMq4vTBp9Vc8GpYE93Fs7bntpYn87GLpub6C2IUHjH69Da
   nnx4in7mwdxrRhq43y2H9DZqVMYN8z3SkTlhI0b9GQus5JSZLpORi+fxO
   +Xr712ZYRGo9Y27EbZKXXweVunlB4l5/GlQKns0sKe/58205h8aSut9Ig
   8TSrErh5VhkAHGhhEW/AGXDPcrq6hvTx74Al/LLht/b22mD4WkSIq7brN
   sOBUMf/WJk9D3fIK941hKahRI6yKhWxoBCfYRQBtW5VfcuSIA9jWZIGaN
   A==;
X-CSE-ConnectionGUID: O4ia6yHzSqmThCofXP0I6g==
X-CSE-MsgGUID: ggrPbB+4Ru623ONRdrHvUQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11440"; a="72445691"
X-IronPort-AV: E=Sophos;i="6.15,305,1739865600"; 
   d="scan'208";a="72445691"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2025 02:23:27 -0700
X-CSE-ConnectionGUID: Aph0fXZaSWGZvzJJq74/Wg==
X-CSE-MsgGUID: b3/qxbFcSS2hSM5pgvknZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,305,1739865600"; 
   d="scan'208";a="145662059"
Received: from oandoniu-mobl3.ger.corp.intel.com (HELO eresheto-mobl3.ger.corp.intel.com) ([10.245.245.170])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2025 02:23:21 -0700
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
	dionnaglaze@google.com,
	bondarn@google.com,
	scott.raynor@intel.com,
	Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH v6 5/5] x86/sgx: Enable automatic SVN updates for SGX enclaves
Date: Thu, 22 May 2025 12:21:38 +0300
Message-ID: <20250522092237.7895-6-elena.reshetova@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250522092237.7895-1-elena.reshetova@intel.com>
References: <20250522092237.7895-1-elena.reshetova@intel.com>
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

== Patch Contents ==

Attempt to execute ENCLS[EUPDATESVN] every time the first file descriptor
is obtained via sgx_(vepc_)open(). In the most common case the microcode
SVN is already up-to-date, and the operation succeeds without updating SVN.
If it fails with any other error code than SGX_INSUFFICIENT_ENTROPY, this
is considered unexpected and the *open() returns an error. This should not
happen in practice. On contrary, SGX_INSUFFICIENT_ENTROPY might happen due
to a pressure on the system's DRNG (RDSEED) and therefore the *open() can
be safely retried to allow normal enclave operation.

[1] Runtime Microcode Updates with Intel Software Guard Extensions,
https://cdrdv2.intel.com/v1/dl/getContent/648682

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
---
 arch/x86/kernel/cpu/sgx/main.c | 35 ++++++++++++++++++++++++++++++++--
 1 file changed, 33 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 109d40c89fe8..73ec5ccff3ae 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -920,6 +920,8 @@ EXPORT_SYMBOL_GPL(sgx_set_attribute);
 
 /* Counter to count the active SGX users */
 static atomic64_t sgx_usage_count;
+/* Mutex to ensure no concurrent EPC accesses during EUPDATESVN */
+static DEFINE_MUTEX(sgx_svn_lock);
 
 /**
  * sgx_updatesvn() - Attempt to call ENCLS[EUPDATESVN].
@@ -989,8 +991,37 @@ static int sgx_update_svn(void)
 
 int sgx_inc_usage_count(void)
 {
-	atomic64_inc(&sgx_usage_count);
-	return 0;
+	int ret;
+
+	/*
+	 * Increments from non-zero indicate potential other
+	 * active EPC users and EUPDATESVN is not attempted.
+	 */
+	if (atomic64_inc_not_zero(&sgx_usage_count))
+		return 0;
+
+	/*
+	 * Ensure no other concurrent threads can start
+	 * touching EPC while EUPDATESVN is running.
+	 */
+	guard(mutex)(&sgx_svn_lock);
+
+	if (atomic64_inc_not_zero(&sgx_usage_count))
+		return 0;
+
+	/*
+	 * Attempt to call EUPDATESVN since EPC must be
+	 * empty at this point.
+	 */
+	ret = sgx_update_svn();
+
+	/*
+	 * If EUPDATESVN failed, return failure to sgx_(vepc_)open and
+	 * do not increment the sgx_usage_count.
+	 */
+	if (!ret)
+		atomic64_inc(&sgx_usage_count);
+	return ret;
 }
 
 void sgx_dec_usage_count(void)
-- 
2.45.2

