Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 104A62DCF63;
	Mon, 11 Aug 2025 09:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754903323; cv=none; b=Pvo9Bsjic6indMZF17a/w/atakC06M7uWv9uzr31gtT3IAuzN16kctURuEBGpsNjmgckr7/63nsHVKlh2fKH2N7Cyr0rOp9Fy42gbHiLV19D7f3S+IgyGVIhJugM31RiL0G9KrcghnSCcH/8DHUgO1Lhv6Jicg4bLO1vyJSzE1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754903323; c=relaxed/simple;
	bh=knS2XNe2DoJ4Ucgl37YdMb6oib3bsWua4BsYxzvdB1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i+8rqflOEGJQwzAAEZ4fLXj4CWuk/VySu5qLLHdV6JjSUtWryqCOaAtJKLpqVoeiXgX0U+WX7p/uCMcbab8/EsHjNmZ4KnP9hci3hxT3cmM4yRE53nuhKq0siP3kz7wKywsoQq8/RgGfffv3zpH2RUxE3vzWH/fmFWSYgTpawp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jKZmapCJ; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jKZmapCJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754903322; x=1786439322;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=knS2XNe2DoJ4Ucgl37YdMb6oib3bsWua4BsYxzvdB1s=;
  b=jKZmapCJ8lJh+3cBO/7bWOCwdUlIF7VUC4+7ihKcHS3HgHW3e7bjGhgT
   8lqBbEJmiI6Az3bXywAW3VtTsE4IG/5Ze7n5olf//5o0U6viEi0nT3K9y
   32LU+9nL3/T3l83nBHUcUmdWS/VME/8ncilOmOH/0kAI6dulkPMBe/oNP
   o9sQP2jS9CWiscVVVyWhllmVYUwJGeEd5PGcEK/EHTbTUKOkGdI1saQlT
   +foqTRCwlnzrwpOISRdp8I2evr8aTQ7LU54EnoUZdu6V6FHSlXZxSNOhY
   JGs44j29rZgab+Xg+pbU1U+IHoxTqPwW+f2RJr91dWZSPq1KFpPf87GLa
   g==;
X-CSE-ConnectionGUID: OnN4rmnCSKeGuPDhOgwiVQ==
X-CSE-MsgGUID: /EsZlY+iR+mf/uAguV9p9g==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="57108599"
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="57108599"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 02:08:42 -0700
X-CSE-ConnectionGUID: 6fXOJV4YS2KGrzyy2oF1Xg==
X-CSE-MsgGUID: QDs3/qbvTg2l9xXBYgRGkA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,278,1747724400"; 
   d="scan'208";a="166222131"
Received: from bergbenj-mobl1.ger.corp.intel.com (HELO eresheto-mobl3.ger.corp.intel.com) ([10.245.244.162])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 02:08:36 -0700
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
Subject: [PATCH v12 5/5] x86/sgx: Enable automatic SVN updates for SGX enclaves
Date: Mon, 11 Aug 2025 12:06:09 +0300
Message-ID: <20250811090751.683841-6-elena.reshetova@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250811090751.683841-1-elena.reshetova@intel.com>
References: <20250811090751.683841-1-elena.reshetova@intel.com>
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
 arch/x86/kernel/cpu/sgx/main.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 829bcba77d41..39bff3488350 100644
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
 
@@ -992,14 +992,22 @@ static int __maybe_unused sgx_update_svn(void)
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

