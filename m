Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C0A32F004C;
	Fri, 11 Jul 2025 16:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752252846; cv=none; b=thn+wRzHqkLawHq3PdutqOkc7H9oAKkwm8GmZYZCEpiKDscgTkbUeY34PR4oguAxp773M4bMwI98Yjg0zkwbuoEdZquWIPfNXDSVG+3uj6YWIBNPDzgKx/spno1FI/2UIoB8R+eKlTN3S6ZieAMzyk6RJ8mnGN0g72N6OLbcu9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752252846; c=relaxed/simple;
	bh=YhOSrNE/P7MqWLr5FsFL3HrMWpWydQhdnKL9K5U7FuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lRj0uYGm5RfHo/wMf1DxWnoyS2k+Z027VJbR+93GgxXF3jOMBIrQUFMDHJyslSi593D9ThhtjSyiGjEDSPVbvEGw30okIddCsq8fXIxTykgj9va3ERIqKk/czlBS313SBXrzWtJijGAjDL5GasXfzv9GPa4zdKzsQcovhsBjJZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Oho7xc66; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Oho7xc66"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752252844; x=1783788844;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YhOSrNE/P7MqWLr5FsFL3HrMWpWydQhdnKL9K5U7FuM=;
  b=Oho7xc66VfPdB8Q2AyIv6XI/OwPASheV+O+7XsYeC9ewTmtyyPjitKPd
   cMnJ89qgqIZVZ3s8MNmMG1kWs35JD5qg/1nzRgAcpkeCfCOveXFcjwubv
   14j8aChroaHHnVvayZGdSXZcLifQxivGn0L6NGQsnJHdcudxOA9swjLMP
   aDjtydYhnyUDShlA+9yH/ZpwDcofxLb4fa2L+934LlEVW62VbqxmnSrJ8
   8eLL+ALCmZoD7hgDrmqAyEjNei6+oO0wbiV4ECpG3Y6XGXXt+2PR8gQNz
   c+AWOxKS5kmzYbzvUSr0YOpAcp7VdwICnxX90w1v042nXsnXHbkTXkCfP
   Q==;
X-CSE-ConnectionGUID: 6gqBZ21vQje5bzB+lPNmDA==
X-CSE-MsgGUID: BmFTqo6PRTGrVVVU7AU5+A==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="53665505"
X-IronPort-AV: E=Sophos;i="6.16,304,1744095600"; 
   d="scan'208";a="53665505"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 09:53:03 -0700
X-CSE-ConnectionGUID: o4yTvnURRwWYd/6p4u3E9w==
X-CSE-MsgGUID: 6OwkVNo7SMSbX719Po9/Yw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,304,1744095600"; 
   d="scan'208";a="187387814"
Received: from lfiedoro-mobl.ger.corp.intel.com (HELO eresheto-mobl3.ger.corp.intel.com) ([10.245.245.49])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 09:52:58 -0700
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
Subject: [PATCH v7 5/5] x86/sgx: Enable automatic SVN updates for SGX enclaves
Date: Fri, 11 Jul 2025 19:50:34 +0300
Message-ID: <20250711165212.1354943-6-elena.reshetova@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250711165212.1354943-1-elena.reshetova@intel.com>
References: <20250711165212.1354943-1-elena.reshetova@intel.com>
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
 arch/x86/kernel/cpu/sgx/main.c | 37 +++++++++++++++++++++++++++++++---
 1 file changed, 34 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 7615d92bb1ed..c3db49e6e967 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -920,6 +920,8 @@ EXPORT_SYMBOL_GPL(sgx_set_attribute);
 
 /* Counter to count the active SGX users */
 static atomic64_t sgx_usage_count;
+/* Mutex to ensure no concurrent EPC accesses during EUPDATESVN */
+static DEFINE_MUTEX(sgx_svn_lock);
 
 /**
  * sgx_update_svn() - Attempt to call ENCLS[EUPDATESVN].
@@ -937,7 +939,7 @@ static atomic64_t sgx_usage_count;
  *  entropy in RNG.
  * -EIO: Unexpected error, retries are not advisable.
  */
-static int __maybe_unused sgx_update_svn(void)
+static int sgx_update_svn(void)
 {
 	int ret;
 
@@ -983,8 +985,37 @@ static int __maybe_unused sgx_update_svn(void)
 
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

