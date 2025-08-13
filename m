Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1F6E2F28E7;
	Wed, 13 Aug 2025 08:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755075199; cv=none; b=enKK38fIxLIbFFhhMSbaeWIbUG/6AsNSYmk1AtrUCpS9C9bZuuV9V3tt7GYSStYPwI9REXU6qvk6pYBmQklGEHb1YZt/ZgFyAzlgJ2JPyjIgAqwlnqT3MT3vl5f/tzU2uxEHuvMlvD5f0mtQqdXxE5JL1UuH/m9d3fUTjulE2kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755075199; c=relaxed/simple;
	bh=hOrZ8G8O5Y6GbgpoSuV/gPvqv7gwRx34YXICClzy+M0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hydiVMF0COMRvuMREdyc5gQHmeLlJACKQ7QL1npbxhud942BpSz0Ekio2oM1dbcSk4B7KMTmbhyRlp/VTIbJRi60OK8SL9ceRKzE49GR2/uHi3CPwQcTbyoUhEtRMTWkIFV3dzGlaEAqZspbb5kbrdMwb+Kzw6jk+6iSqIVmLhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Cw2J3m9N; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Cw2J3m9N"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755075197; x=1786611197;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hOrZ8G8O5Y6GbgpoSuV/gPvqv7gwRx34YXICClzy+M0=;
  b=Cw2J3m9NDLcVI1wNzDGLVGhlTNM50VhAgsVJQrNw6WUfed+9yF8D+1Sa
   gZumo7xDQo0q02IjPgW35cn8FzvEBEryt1U/SsYfBPpgxnBr2uDZxr03J
   rp/cEEmlPLpS7Jyj4Dy6sFcjPxikK28fWttMwNPSodiKXdu+ZDelfNZFC
   T9rEFOBfu46e8nN140AaJth4TWqMjJ8rBJN4btvDGjcFjSNGdILWhiCFI
   Jwdf8oechPvm035NcOgVidQEZqYZKZx8Bwh9sHvsK3mi7KUWb+OxEX6p/
   EdgB6uytfFrOh6z0wj+iZgGr05LgI+m6/uhOAKIry8WbByoqBEgzEFO+y
   w==;
X-CSE-ConnectionGUID: KhOMNNEBT9+7b7jKm7a5+A==
X-CSE-MsgGUID: JThIYPJVSVW5514BFbsjRg==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="57229179"
X-IronPort-AV: E=Sophos;i="6.17,285,1747724400"; 
   d="scan'208";a="57229179"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 01:53:17 -0700
X-CSE-ConnectionGUID: Zzm/ovSSS56nkCDEWFSoZw==
X-CSE-MsgGUID: R5/d26jWTVy9KRt8HnAaXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,285,1747724400"; 
   d="scan'208";a="166299937"
Received: from bergbenj-mobl1.ger.corp.intel.com (HELO eresheto-mobl3.ger.corp.intel.com) ([10.245.245.248])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 01:53:13 -0700
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
Subject: [PATCH v13 5/5] x86/sgx: Enable automatic SVN updates for SGX enclaves
Date: Wed, 13 Aug 2025 11:50:39 +0300
Message-ID: <20250813085233.1369036-6-elena.reshetova@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250813085233.1369036-1-elena.reshetova@intel.com>
References: <20250813085233.1369036-1-elena.reshetova@intel.com>
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

Note: while in such cases the underlying crypto assets are regenrated, it
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
 arch/x86/kernel/cpu/sgx/main.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 829bcba77d41..4ef1e40a195a 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -934,7 +934,7 @@ static int sgx_usage_count;
  *				entropy in RNG
  * %-EIO:		- Unexpected error, retries are not advisable
  */
-static int __maybe_unused sgx_update_svn(void)
+static int sgx_update_svn(void)
 {
 	int ret;
 
@@ -992,14 +992,28 @@ static int __maybe_unused sgx_update_svn(void)
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
+	if (sgx_usage_count++ == 0) {
+		ret = sgx_update_svn();
+		if (ret)
+			sgx_usage_count--;
+		return ret;
+	}
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

