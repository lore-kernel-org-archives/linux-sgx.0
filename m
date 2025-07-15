Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13DCD2E040D;
	Tue, 15 Jul 2025 12:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752583316; cv=none; b=E7PwTSGSdbFRQSLGmOhFJWy3YcO+U06YzeW9BIND54u3kD/GV2eICXIkYZYisd6rmcase+5k7agddREVpsMdezZAV8ifHYkxGfTxAIZH2iMEhUG28PHcIUlWDs69V8pzHanSr4mDs7hUqT3rLRUpEEJEBI192akWnMy886nuf0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752583316; c=relaxed/simple;
	bh=kTPbS5WV4fcTLPZZqpeiPTQ0D+DrIU5oiRwpDe/RW10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r/CWyHZC6wM7w8gsJQ3Eb9BFjkpL7rL4TPX4ggJd++VYAya8fet6NHENdz6t4hYYYd1yui2DhMpuqN5z8uOsOaQ/AaIMOBS18p9hyroOaLLNZINQN6tRCEvEAMZ0ROQNMPY6Embc2Pl2lCQODvLdbcZ6nB2V/zecpZwMwwOPLmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=clmBtK4W; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="clmBtK4W"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752583315; x=1784119315;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kTPbS5WV4fcTLPZZqpeiPTQ0D+DrIU5oiRwpDe/RW10=;
  b=clmBtK4WXYj6QTp6vwKsRhCJSseA9u+a7ohNL44OmiM49+MMA8x+L4H3
   X6D1KXVI2fnGpQfVQ/+u8ZPpc0CdkzozVzOE5S0EZBMB/fJM8Gw3PCzDI
   RTue0ian4u5i5CoNIX3nMm54YcL41ZH6BY2ZmxiuV0iTLSzCIKTZefGY2
   UtSlBTTFS6NLQ6XCj8cDH/Ti5o3QSKGF2dsQPc0kfnRVYH04t5dSXO+Gu
   RVGOOndC3mbBLgBlMeiO+wXSvETdCXfXyMU90w/wQijtr7kaoOTIdq+sP
   9KwKUHoUqfwvlEJXdq+qUIO3HlZegfObCSJ1oYbtqsO/2BRohW6lMZ3wb
   Q==;
X-CSE-ConnectionGUID: DxiPeDfnRP2Tcyumi58EqA==
X-CSE-MsgGUID: ye4c70JBRlyh1xvR6ABqpg==
X-IronPort-AV: E=McAfee;i="6800,10657,11493"; a="65498242"
X-IronPort-AV: E=Sophos;i="6.16,313,1744095600"; 
   d="scan'208";a="65498242"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2025 05:41:55 -0700
X-CSE-ConnectionGUID: deMFgW0RQECMKjVHMJQ3fw==
X-CSE-MsgGUID: 9HH43WNdRSWE0el2hd1lNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,313,1744095600"; 
   d="scan'208";a="157018463"
Received: from jkrzyszt-mobl2.ger.corp.intel.com (HELO eresheto-mobl3.ger.corp.intel.com) ([10.245.245.22])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2025 05:41:49 -0700
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
Subject: [PATCH v8 5/5] x86/sgx: Enable automatic SVN updates for SGX enclaves
Date: Tue, 15 Jul 2025 15:40:22 +0300
Message-ID: <20250715124109.1711717-6-elena.reshetova@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250715124109.1711717-1-elena.reshetova@intel.com>
References: <20250715124109.1711717-1-elena.reshetova@intel.com>
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
happen in practice.

On contrary, SGX_INSUFFICIENT_ENTROPY might happen due
to a pressure on the system's DRNG (RDSEED) and therefore the *open() can
be safely retried to allow normal enclave operation.

[1] Runtime Microcode Updates with Intel Software Guard Extensions,
https://cdrdv2.intel.com/v1/dl/getContent/648682

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
---
 arch/x86/kernel/cpu/sgx/main.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index c97bba16e4fd..58cc342bfdbd 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -921,6 +921,9 @@ EXPORT_SYMBOL_GPL(sgx_set_attribute);
 /* Counter to count the active SGX users */
 static int sgx_usage_count;
 
+/* Mutex to ensure no concurrent EPC accesses during EUPDATESVN */
+static DEFINE_MUTEX(sgx_svn_lock);
+
 /**
  * sgx_update_svn() - Attempt to call ENCLS[EUPDATESVN].
  * This instruction attempts to update CPUSVN to the
@@ -937,7 +940,7 @@ static int sgx_usage_count;
  *  entropy in RNG.
  * -EIO: Unexpected error, retries are not advisable.
  */
-static int __maybe_unused sgx_update_svn(void)
+static int sgx_update_svn(void)
 {
 	int ret;
 
@@ -983,7 +986,11 @@ static int __maybe_unused sgx_update_svn(void)
 
 int sgx_inc_usage_count(void)
 {
-	sgx_usage_count++;
+	guard(mutex)(&sgx_svn_lock);
+
+	if (sgx_usage_count++ == 0)
+		return sgx_update_svn();
+
 	return 0;
 }
 
-- 
2.45.2

