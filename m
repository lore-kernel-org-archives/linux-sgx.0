Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F7622F1FCA;
	Wed, 13 Aug 2025 08:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755075190; cv=none; b=h6y/ypDfVrDGBAycMBursDHJhFAZsyh97LzN32wh2U1IezA3N+Z7L8GdPr1LMZbktv52DRObys5Ig+LKV5SXdVSypzAEPTRSGm/so8ud4HvAIoxIZefXJ7YGn5AMsdMbU8pMtCKk7zdGrKjHLcIHb+kfi3AyF11FSQShrWphzXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755075190; c=relaxed/simple;
	bh=xBr7NCzOZ/LYGCsQhUYvCky1Z65cR7U+1ywo9OtqRHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OuEofPhUxEaQ3knpPk/0o2drYnO4yHgn+9gbYAzym3fa1TTGmQq9zfdO0G1C5D55jZ1/7YbrM3Q/DRHl+IvZQ2SnRnYIer71RwxrNc3bytN9AEWeoJeJznWtq/l4jtoK5YbU4c4bKvz38G7jyQz/vrDQozzZPSwPZIDfjW+sFjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q4cWmokx; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q4cWmokx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755075189; x=1786611189;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xBr7NCzOZ/LYGCsQhUYvCky1Z65cR7U+1ywo9OtqRHQ=;
  b=Q4cWmokxK20Ex4Zx6ZMIzId0f4zvUUHLcKCqX5YajaEIX0TcSu5FHk6J
   EJj8nrCX1jh8SojVhi0AJ5U5HsCQ7Xi3caFHevTlQ5kViDBjNWUTiRss0
   wJcKJ/hwkqwx6pckgIHWjoRJ1G/+pu7ascXKEdw5d9OxFUhWJUDNAWuer
   aL3mje0bHrm7U/j6v8p9lL+6jT9bVd26yN16O64iXuxbVQizGOMxYN7u2
   vo0qTuuQ4KNxXgi48TPENNS+X2UDA9V52AjZ+3lvkZ87vzAYJBPjLw9Kf
   kBGMhoFdF8WFhcTwCap1YasA/0eiextYWbUcU3Q0iZPt23KPJY3PIjTS2
   Q==;
X-CSE-ConnectionGUID: kQUbP/KKTaCyLMqNEnqr5A==
X-CSE-MsgGUID: +7hfR5myT3S0iWaHzakexg==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="57229157"
X-IronPort-AV: E=Sophos;i="6.17,285,1747724400"; 
   d="scan'208";a="57229157"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 01:53:09 -0700
X-CSE-ConnectionGUID: TSxcLK9VSSCQmrl+N4h15A==
X-CSE-MsgGUID: C/jewjOPRSWWYtTEHlXLBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,285,1747724400"; 
   d="scan'208";a="166299913"
Received: from bergbenj-mobl1.ger.corp.intel.com (HELO eresheto-mobl3.ger.corp.intel.com) ([10.245.245.248])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2025 01:53:05 -0700
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
Subject: [PATCH v13 3/5] x86/sgx: Define error codes for use by ENCLS[EUPDATESVN]
Date: Wed, 13 Aug 2025 11:50:37 +0300
Message-ID: <20250813085233.1369036-4-elena.reshetova@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250813085233.1369036-1-elena.reshetova@intel.com>
References: <20250813085233.1369036-1-elena.reshetova@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add error codes for ENCLS[EUPDATESVN], then SGX CPUSVN update process can
know the execution state of EUPDATESVN and notify userspace.

EUPDATESVN will be called when no active SGX users is guaranteed. Only add
the error codes that can legally happen. E.g., it could also fail due to
"SGX not ready" when there's SGX users but it wouldn't happen in this
implementation.

Reviewed-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
---
 arch/x86/include/asm/sgx.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
index 6a0069761508..73348cf4fd78 100644
--- a/arch/x86/include/asm/sgx.h
+++ b/arch/x86/include/asm/sgx.h
@@ -73,6 +73,10 @@ enum sgx_encls_function {
  *				public key does not match IA32_SGXLEPUBKEYHASH.
  * %SGX_PAGE_NOT_MODIFIABLE:	The EPC page cannot be modified because it
  *				is in the PENDING or MODIFIED state.
+ * %SGX_INSUFFICIENT_ENTROPY:	Insufficient entropy in RNG.
+ * %SGX_NO_UPDATE:		EUPDATESVN could not update the CPUSVN because the
+ *				current SVN was not newer than CPUSVN. This is the most
+ *				common error code returned by EUPDATESVN.
  * %SGX_UNMASKED_EVENT:		An unmasked event, e.g. INTR, was received
  */
 enum sgx_return_code {
@@ -81,6 +85,8 @@ enum sgx_return_code {
 	SGX_CHILD_PRESENT		= 13,
 	SGX_INVALID_EINITTOKEN		= 16,
 	SGX_PAGE_NOT_MODIFIABLE		= 20,
+	SGX_INSUFFICIENT_ENTROPY	= 29,
+	SGX_NO_UPDATE			= 31,
 	SGX_UNMASKED_EVENT		= 128,
 };
 
-- 
2.45.2

