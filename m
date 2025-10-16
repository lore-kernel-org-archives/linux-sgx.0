Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E1033A008;
	Thu, 16 Oct 2025 13:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760620456; cv=none; b=NV8m0pYwNCpWOdwnSOWSXsstzZ7uQL42jGbWg8V9zEIDOf0V/axRiw/Wv7jmfegYuHjnuay2ePVg4UL/xEsO/i1k5+qCsclsIWrBgPGPyWrCyoR7QTXuLG9azNFI0x+WAdn+S7KrFoZ/zuzguV4nCbVSwYqXip1UNITmZltwIlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760620456; c=relaxed/simple;
	bh=0N8/qd5qzLHbFEVNvXz6ej7DAPmf2eK2l9UUMC1Qd9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ANuxCHNjYM0HFVo1uyuJ3TN3Dkk25YgMBddbskh3o4k+DLgkJKb5+z58g5yywR/gqUR8xBxSqMPl58HG64x83LTN2iJ7Js09Ls1nMcb9niFADIubMZhG+n62k1GRkUL+d59AzcfVI8AWkt2nWArBWHN3yQiGD9Z64VzS1mZz9Fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Vn7F8YCc; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Vn7F8YCc"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760620454; x=1792156454;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0N8/qd5qzLHbFEVNvXz6ej7DAPmf2eK2l9UUMC1Qd9c=;
  b=Vn7F8YCcrw7zgKVrHyJ4DXdAPpl22cmnxqON7RmQg3oJldJ71031w+e7
   AwQ6EAImvMR3CSk11e2EAPcKnhzipB7W83/KkFPyT9BiLQgQwwIhpQogr
   TrUzUqLkjOb7HwEg9kpOygshKGbnIfcyJc4y3lbeks/PRYnmT+oaHjec2
   yxMLIL4Fsr/ar1WRW1jPQefinZ67I450+/MwesHRSzh4N+hPj2ty9I2DZ
   sbhPkvr4fk2xj5A3JZXvrk4Wq1CHWbofJBdeeX4V7zGQZto9m3f/A4TY9
   4jZCBxRHiKNB4g/tCGNfrTUffFLaCDgBL87vUdGa7aYZEN5g2rjBdeiGl
   g==;
X-CSE-ConnectionGUID: xcJsGYceS1qYXX3ubSUvYA==
X-CSE-MsgGUID: oifVkcWSTfaN0ajvjXHJsw==
X-IronPort-AV: E=McAfee;i="6800,10657,11584"; a="62904750"
X-IronPort-AV: E=Sophos;i="6.19,234,1754982000"; 
   d="scan'208";a="62904750"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2025 06:14:14 -0700
X-CSE-ConnectionGUID: /6qmLXwSSuujN6n5tJPkyg==
X-CSE-MsgGUID: GPjxXppZQzOxZThp/c/j8Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,234,1754982000"; 
   d="scan'208";a="182016030"
Received: from klitkey1-mobl1.ger.corp.intel.com (HELO eresheto-mobl3.ger.corp.intel.com) ([10.245.244.10])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2025 06:14:09 -0700
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
Subject: [PATCH v17 5/5] x86/sgx: Enable automatic SVN updates for SGX enclaves
Date: Thu, 16 Oct 2025 16:11:08 +0300
Message-ID: <20251016131314.17153-6-elena.reshetova@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20251016131314.17153-1-elena.reshetova@intel.com>
References: <20251016131314.17153-1-elena.reshetova@intel.com>
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

Reviewed-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Tested-by: Nataliia Bondarevska <bondarn@google.com>
---
 arch/x86/kernel/cpu/sgx/main.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index ffc7b9496218..3eda7e7942e6 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -934,7 +934,7 @@ static int sgx_usage_count;
  * *             entropy in RNG
  * * %-EIO:    - Unexpected error, retries are not advisable
  */
-static int __maybe_unused sgx_update_svn(void)
+static int sgx_update_svn(void)
 {
 	int ret;
 
@@ -992,14 +992,30 @@ static int __maybe_unused sgx_update_svn(void)
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
+	guard(mutex)(&sgx_svn_lock);
+	sgx_usage_count--;
 }
 
 static int __init sgx_init(void)
-- 
2.45.2

