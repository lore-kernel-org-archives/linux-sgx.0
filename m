Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E923267B7F;
	Thu, 14 Aug 2025 07:37:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755157060; cv=none; b=p+8gQRjsQ9yV43GE7H8oIBlK9HWxUFqR0TUEZ8laSJxuUsbMn2kzpgX2v+kYdLuwdHykduJCl4BQrWS2XD4TrllvMv7skrUitCHys/2amrdAuacYO874X5Q77TtuI7uv+7sTKo2FRo6OqHFTsPByaDFpcFqVHfAmYRQYWnjIVQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755157060; c=relaxed/simple;
	bh=DzD+0sx/bk7o02jG3gQmg3grzfbjeRejtCSSGMbpWTI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ceKxGPIocow2Qiwt2l9d1rYrRvj+dE8RxVZyUKZEtltwbyy1Tl0/6gX+7rBN+8sEPpkTe8HmwV+lw4IO876462PWQ/Tt+IcvXRwg6TTKKE2rK5m3ZtKZx349BBHYR2BNmXCx2x0AJyvrYBTwtOYktIaNXdg0n2JIbC+COb7yhl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aLm00YNT; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aLm00YNT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755157059; x=1786693059;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DzD+0sx/bk7o02jG3gQmg3grzfbjeRejtCSSGMbpWTI=;
  b=aLm00YNTnCouKtFxJw7IBA6lFxRqVjGQgGQMDrnR1a620zYjiGOcUbfd
   ITHHcbcrQRFVL0A3pQW9uXW/Z/r+3yU/7OokfhMasjog/ZS361mCsm4mF
   54dzZaSWC+7U9nyEWKHmDuQGqowOPS0q+4L1IJfoxA3fqTznE3H4ei9CJ
   /Ep2+2dPJJQvavR3Ia2nUJVBiQPJ9VkT4iQvpAXW2T0aIKy+70gPkhm9u
   41C15XeKVPwuTXztqs8bQ+7kOD3vupGttDbhkqJnAjmkngqV8BjrvdQPH
   V+w3JDLHcKuvw+FU17WORiQ9NoWMTgYR/CWN49At1PC4FiqO73X1thGOB
   A==;
X-CSE-ConnectionGUID: D+OsAT7rRX688lSMOqbqlw==
X-CSE-MsgGUID: 8A/PV2RoTZuKqrJOiV9B7w==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="82899415"
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="82899415"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 00:37:35 -0700
X-CSE-ConnectionGUID: uUCQ2EeHQFiWp8V8/58gKw==
X-CSE-MsgGUID: uBDfFsdWSf6ASUdJylz+cQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="171927400"
Received: from foboril-desk.ger.corp.intel.com (HELO eresheto-mobl3.ger.corp.intel.com) ([10.245.244.138])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 00:37:22 -0700
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
Subject: [PATCH v14 5/5] x86/sgx: Enable automatic SVN updates for SGX enclaves
Date: Thu, 14 Aug 2025 10:34:25 +0300
Message-ID: <20250814073640.1507050-6-elena.reshetova@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250814073640.1507050-1-elena.reshetova@intel.com>
References: <20250814073640.1507050-1-elena.reshetova@intel.com>
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

Note: while in such cases the underlying crypto assets are regenerated, it
does not affect enclaves' visible keys obtained via EGETKEY instruction.

If it fails with any other error code than SGX_INSUFFICIENT_ENTROPY, this
is considered unexpected and the *open() returns an error. This should not
happen in practice.

On contrary, SGX_INSUFFICIENT_ENTROPY might happen due to a pressure on the
system's DRNG (RDSEED) and therefore the *open() can be safely retried to
allow normal enclave operation.

[1] Runtime Microcode Updates with Intel Software Guard Extensions,
https://cdrdv2.intel.com/v1/dl/getContent/648682

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
---
 arch/x86/kernel/cpu/sgx/main.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 69ab28641e20..cff5c4d22ac2 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -934,7 +934,7 @@ static int sgx_usage_count;
  * *			entropy in RNG
  * * %-EIO:		- Unexpected error, retries are not advisable
  */
-static int __maybe_unused sgx_update_svn(void)
+static int sgx_update_svn(void)
 {
 	int ret;
 
@@ -992,14 +992,29 @@ static int __maybe_unused sgx_update_svn(void)
 	return -EIO;
 }
 
+/* Mutex to ensure no concurrent EPC accesses during EUPDATESVN */
+static DEFINE_MUTEX(sgx_svn_lock);
+
 int sgx_inc_usage_count(void)
 {
+	int ret;
+
+	guard(mutex)(&sgx_svn_lock);
+
+	if (!sgx_usage_count) {
+		ret = sgx_update_svn();
+		if (ret)
+			return ret;
+	}
+
+	sgx_usage_count++;
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

