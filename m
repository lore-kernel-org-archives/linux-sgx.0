Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50A7926A087;
	Fri, 10 Oct 2025 08:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760086480; cv=none; b=D1JJeqp330hhlUys5ec+qtAnrET1P49lemQo/ZCvd+adaWFT3IrZsf5UNy9MZC5PB3xetHzvdm1LSvaAaXYC64UW8cHHh/4Fa4I4iKVrVAoOL/tH621XVGJwwRXZQ1Jo8ddZeVw0y8rwg9RYzVL52WmAkJc5VdWLPQLXHF0vgFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760086480; c=relaxed/simple;
	bh=0N8/qd5qzLHbFEVNvXz6ej7DAPmf2eK2l9UUMC1Qd9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HFZq/SE99DUY/bXGeV/1uc5Mw9X5htXlYy5BrCn7zSQO2tZrbK3XpE/JJfUWbD00EbfJGIgkIeZ+Scv5KPKGRT129EkKJIMOJwHotras+TvyRt15q2hRSpKIxDxpmxluNebG+SpEjPJ2IRrbPsxalD8YYiA4kAjI2pUDpQ2qxvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YPWcNw7F; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YPWcNw7F"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760086480; x=1791622480;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0N8/qd5qzLHbFEVNvXz6ej7DAPmf2eK2l9UUMC1Qd9c=;
  b=YPWcNw7F+7gi41NSq/f9PXDzU81S2S/dEyd9ARHqwpicDRKVaTBKU2Sd
   CtNVyUVuTCZy+1sJOO8tqC5Rlrh7hYuhQx58iPCy9iukRUcP00d9VRUW8
   PgZznIkhVMRgvaISLN+FQcV1CGW9symcVaioVfZLhd2GEwgUkEPfh6xV6
   kNC52wzbbx4Hf98l4yTuAtZxB2jtZrJdy6LS7vbnOEDSmVJduw/XVxAO7
   IR0CQAdFQcPlYsIyVFyQYbvLHH0pAvfasW4PKdZv3mqIMhzgbmA/wRFRK
   lkayotDdNkhf0DmlpthuAkS4kcudzYOxjhqNuxKOG+SpOV7u22qii9NFR
   A==;
X-CSE-ConnectionGUID: 0g9eAetkSiKclvM6hyqHEA==
X-CSE-MsgGUID: rTFreFvxRrSp38q5dv8D+A==
X-IronPort-AV: E=McAfee;i="6800,10657,11577"; a="62188077"
X-IronPort-AV: E=Sophos;i="6.19,218,1754982000"; 
   d="scan'208";a="62188077"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2025 01:54:39 -0700
X-CSE-ConnectionGUID: Kb/ONSryQkej22NAgaBivQ==
X-CSE-MsgGUID: xI8Khs9sSQKI0j4XUjpo8Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,218,1754982000"; 
   d="scan'208";a="180181680"
Received: from mjarzebo-mobl1.ger.corp.intel.com (HELO eresheto-mobl3.ger.corp.intel.com) ([10.245.245.124])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2025 01:54:34 -0700
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
Subject: [PATCH v16 5/5] x86/sgx: Enable automatic SVN updates for SGX enclaves
Date: Fri, 10 Oct 2025 11:52:11 +0300
Message-ID: <20251010085346.292287-6-elena.reshetova@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20251010085346.292287-1-elena.reshetova@intel.com>
References: <20251010085346.292287-1-elena.reshetova@intel.com>
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

