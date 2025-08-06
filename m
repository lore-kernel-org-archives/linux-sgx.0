Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BEA3223DCB;
	Wed,  6 Aug 2025 08:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754468080; cv=none; b=E8aNMg0TqERV/J0Um3qiGdanJRFLF9CIDTX1AVY62jOw7mD/Z5rFHW1GJRqk3zkxHKcqoONV1edZpXwqod+lzSIZZJhSmiGAx0FGzAXXEx+P87POE7BgDxQqgq7xHkU/0MQBfiiZxK+W3nQkL4E7l/zibho4Y+7JPFCATSfb4t4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754468080; c=relaxed/simple;
	bh=SxCU4TucgzhtSAI2BWtrWX3S2pYMUQHVykQovHNThKs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZqroZZbAvs3bB5qD/Je66f13lWDyPO5LWPgJ67ClZyk7nOTyRgHv/LmZN64IU7oy8zVVtTp0sJhyPLQDN7Zo+TAd6MolwGy332yHHsigvtMURfVmZIUNr+ZRX0SxmH7oc14eIIz7WB3jNEy3Vyrvp3Q394Au7l+m+8wgb6yM/wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YVVH5EFw; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YVVH5EFw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754468079; x=1786004079;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SxCU4TucgzhtSAI2BWtrWX3S2pYMUQHVykQovHNThKs=;
  b=YVVH5EFwncmvao4kFvVmvT/yndUYlk/loqv7VuftU+/y7gnJO5+uTc9Q
   wro5qarH4Gr2IxMBRXdbZm022W/9zTdtUmuYm3958J9D396CzOr0ulGjd
   b2wrpkcsDVb2oSR/a1eiBA5ntUFn3DHqxTtULz4mW88kZ6GXzay+7D26k
   GhR4yKFdJn50hRgOQ+U0odd55ZqD0Git3M8YxorLB7+waPqR2qtsKJuw0
   XAuTnES0JuUpf59MPs1EFWkjtNLelwfBqKI7L4UNeXEFwwDhos6vuR7n/
   B8FwxQLyvgIKFA5JR1hl5TPvG0d60FnjIq/y3GKYcBQwb6MK8rcfFGsYh
   g==;
X-CSE-ConnectionGUID: tm/9MNgFRdmmH0HYv71GpQ==
X-CSE-MsgGUID: atf+G4OQT/abFflWbS5vdw==
X-IronPort-AV: E=McAfee;i="6800,10657,11513"; a="56853724"
X-IronPort-AV: E=Sophos;i="6.17,268,1747724400"; 
   d="scan'208";a="56853724"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2025 01:14:37 -0700
X-CSE-ConnectionGUID: a3uPE6YBTP+zd0gYq+f6jA==
X-CSE-MsgGUID: akXaskC/SHGx6A9S1w9JKA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,268,1747724400"; 
   d="scan'208";a="169168559"
Received: from sschumil-mobl2.ger.corp.intel.com (HELO eresheto-mobl3.ger.corp.intel.com) ([10.245.244.125])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2025 01:14:30 -0700
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
Subject: [PATCH v11 5/5] x86/sgx: Enable automatic SVN updates for SGX enclaves
Date: Wed,  6 Aug 2025 11:11:56 +0300
Message-ID: <20250806081344.404004-6-elena.reshetova@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250806081344.404004-1-elena.reshetova@intel.com>
References: <20250806081344.404004-1-elena.reshetova@intel.com>
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
 arch/x86/kernel/cpu/sgx/main.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index d8c42524b590..b6f024802026 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -932,7 +932,7 @@ static int sgx_usage_count;
  *  entropy in RNG.
  * -EIO: Unexpected error, retries are not advisable.
  */
-static int __maybe_unused sgx_update_svn(void)
+static int sgx_update_svn(void)
 {
 	int ret;
 
@@ -990,14 +990,22 @@ static int __maybe_unused sgx_update_svn(void)
 	return -EIO;
 }
 
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

