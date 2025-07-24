Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD437275103;
	Thu, 24 Jul 2025 08:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753344243; cv=none; b=c6a8CXgB/n6J2ggOlmdMWoCj2qQjnz3SRlalaxMkeyhw6HpTCKtpoUy64U/z/6oxdVj0giSHkBW4GBT4g/6+M++0H+eVrDtE8qvP5mD3XKdi8sWTOHMkEJOJSgsJRS9z93RjGA3JE/FFF5shdf3/hXw6ELuc7OPsjSISf7w+WqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753344243; c=relaxed/simple;
	bh=hJ78VH6KfiP/kPVA/V86syXh1HmFRiQnUtKrsFN/w9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lMbnyg2WtlnKNh8sTHBNdAB+/zy7OB9afdqkjTNsUgrMy8FVMc/dBqYPU1tyK0UCTD/E8k6k0xXfEqAHfIx0Ox3C92yT1N69NJIH36bM4rXBYVOvSPtiTkbSMksCwNu6BORFY86ZGAQXbpAcWhxp9sc+5HPFuAMkWjvPAirK1h0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=khMPqsSL; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="khMPqsSL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753344242; x=1784880242;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hJ78VH6KfiP/kPVA/V86syXh1HmFRiQnUtKrsFN/w9s=;
  b=khMPqsSLPcCD++WjGBRiMN+QYzUUtwDAFelR/TUHSxJlaQKI9ECw3OGz
   QnAmohTUtnbqOBpWKi+inv2nVP7DhWXF4NB/Mv9TDUAL7MBxDjebDshMx
   KYetdPNx3Og16YUXBMbRS7Xduw2+9LwgaL+FLrhNRCCvA0qDs+4hXJ04s
   1NNBVNbhGpqVAQgK6VPpgjKi3nFt7XloHhmAH7LdOmHg4sYf3KkkCIjFT
   Unpnrp/gX307ppSVst4u6HI7LIkfBY5VYa80eJW8QxTN5SY9t4YILTv/s
   SRwidJj6knrgnPsDx6qIXuXdTqMZos8huHNr6fU44FgqZ88a6m8rXNXC6
   Q==;
X-CSE-ConnectionGUID: a7bjVq1uRReqThIW9LiJ6A==
X-CSE-MsgGUID: E6pCpRoDRXitxITK2nSvVg==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="66992002"
X-IronPort-AV: E=Sophos;i="6.16,336,1744095600"; 
   d="scan'208";a="66992002"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 01:04:02 -0700
X-CSE-ConnectionGUID: gQyNVfTXRTSLHfVeYXAguQ==
X-CSE-MsgGUID: t20ShfOwRKCo6p1uKacpxA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,336,1744095600"; 
   d="scan'208";a="160342242"
Received: from savramon-mobl1 (HELO eresheto-mobl3.ger.corp.intel.com) ([10.245.244.60])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 01:03:57 -0700
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
Subject: [PATCH v9 6/6] x86/sgx: Enable automatic SVN updates for SGX enclaves
Date: Thu, 24 Jul 2025 11:02:15 +0300
Message-ID: <20250724080313.605676-7-elena.reshetova@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250724080313.605676-1-elena.reshetova@intel.com>
References: <20250724080313.605676-1-elena.reshetova@intel.com>
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
 arch/x86/kernel/cpu/sgx/main.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 206bf41d8325..90b7416969e4 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -921,6 +921,9 @@ EXPORT_SYMBOL_GPL(sgx_set_attribute);
 /* Counter to count the active SGX users */
 static int __maybe_unused sgx_usage_count;
 
+/* Mutex to ensure no concurrent EPC accesses during EUPDATESVN */
+static DEFINE_MUTEX(sgx_svn_lock);
+
 /**
  * sgx_update_svn() - Attempt to call ENCLS[EUPDATESVN].
  * This instruction attempts to update CPUSVN to the
@@ -937,7 +940,7 @@ static int __maybe_unused sgx_usage_count;
  *  entropy in RNG.
  * -EIO: Unexpected error, retries are not advisable.
  */
-static int __maybe_unused sgx_update_svn(void)
+static int sgx_update_svn(void)
 {
 	int ret;
 
@@ -983,12 +986,17 @@ static int __maybe_unused sgx_update_svn(void)
 
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

