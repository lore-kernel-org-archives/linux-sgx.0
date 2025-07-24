Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7779E274B4D;
	Thu, 24 Jul 2025 08:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753344233; cv=none; b=HFsj+HTobEu2RwRm+qqLI1+CtY0zF3v3jHnFagq/7afq20Dj+SgXsIe8+qD7rY9b20nscOb08ohXS2Qy8qSUcsdd3LXO7aLD8yap64bHa6e1QT3ZYL/EtjuHYxd8rmr7NyThTimrTQOhjl4ktB/l6z52K3W5zUMIaR2rcmXcbYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753344233; c=relaxed/simple;
	bh=5tn1s0xpEgieBaW2rEVLCUgMZNIIbtgh5f8AiANQjxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bRSPfvWvaAXuLfVHf1ZFuEsCpDrBTTX5UN5HeNnUssgqfm4fAODn6j9NoOO2Syjb7ymwJsCZPpvijmd2TBizAAxrV63XselHZjuKP1ThuBvXuIEGshbXSpM8py4AtDX47Gxo86uutypS+o3DWxQvCzzJNgQ/2vNdhuy6aAkzHWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gveIbIrj; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gveIbIrj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753344233; x=1784880233;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5tn1s0xpEgieBaW2rEVLCUgMZNIIbtgh5f8AiANQjxI=;
  b=gveIbIrjYKVJC0i3BjzZODadcME+aV7TXBvOQ+RPdjZWUqDixgvvP1gB
   W/0YZd/BIMAP0oj/7OsVxvYKh4adB4IMOm5Ws20rA5+ivJ7OvKill6bPC
   vH67aNAEdNzX0ht4ZExsbhL7XWLNJNIeqI34IE2+VPzSlMozLo1wusKDY
   /MWndgpOtUd28yaDNrr+raIQgHnf/BmqE/efDmSPqe2qxVHayTgBoczOO
   G6/GqRiHGQgz0NMCyogmQo6pSBH7dKLd16D7WNlfjteKVZaY7mrXqt2s5
   glbl6WTg9ALkTMxdXQ4Hkm/nrdIRXv2QR3rT+h2ef/u3jUNtnxua4aiFR
   Q==;
X-CSE-ConnectionGUID: LVY/QKJfSvWL9tuNKtWWyw==
X-CSE-MsgGUID: bDmfCBi7SHOWibJvtPORQQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="66991972"
X-IronPort-AV: E=Sophos;i="6.16,336,1744095600"; 
   d="scan'208";a="66991972"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 01:03:53 -0700
X-CSE-ConnectionGUID: v98wCQaPSn+GsYbvI2v6Lw==
X-CSE-MsgGUID: hWa08Ve4S1aQS44DO8RiAA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,336,1744095600"; 
   d="scan'208";a="160341827"
Received: from savramon-mobl1 (HELO eresheto-mobl3.ger.corp.intel.com) ([10.245.244.60])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 01:03:47 -0700
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
Subject: [PATCH v9 4/6] x86/sgx: Define error codes for use by ENCLS[EUPDATESVN]
Date: Thu, 24 Jul 2025 11:02:13 +0300
Message-ID: <20250724080313.605676-5-elena.reshetova@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250724080313.605676-1-elena.reshetova@intel.com>
References: <20250724080313.605676-1-elena.reshetova@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add error codes for ENCLS[EUPDATESVN], then SGX CPUSVN update
process can know the execution state of EUPDATESVN and notify
userspace.

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
---
 arch/x86/include/asm/sgx.h | 37 ++++++++++++++++++++++---------------
 1 file changed, 22 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
index 6a0069761508..1abf1461fab6 100644
--- a/arch/x86/include/asm/sgx.h
+++ b/arch/x86/include/asm/sgx.h
@@ -28,21 +28,22 @@
 #define SGX_CPUID_EPC_MASK	GENMASK(3, 0)
 
 enum sgx_encls_function {
-	ECREATE	= 0x00,
-	EADD	= 0x01,
-	EINIT	= 0x02,
-	EREMOVE	= 0x03,
-	EDGBRD	= 0x04,
-	EDGBWR	= 0x05,
-	EEXTEND	= 0x06,
-	ELDU	= 0x08,
-	EBLOCK	= 0x09,
-	EPA	= 0x0A,
-	EWB	= 0x0B,
-	ETRACK	= 0x0C,
-	EAUG	= 0x0D,
-	EMODPR	= 0x0E,
-	EMODT	= 0x0F,
+	ECREATE		= 0x00,
+	EADD		= 0x01,
+	EINIT		= 0x02,
+	EREMOVE		= 0x03,
+	EDGBRD		= 0x04,
+	EDGBWR		= 0x05,
+	EEXTEND		= 0x06,
+	ELDU		= 0x08,
+	EBLOCK		= 0x09,
+	EPA		= 0x0A,
+	EWB		= 0x0B,
+	ETRACK		= 0x0C,
+	EAUG		= 0x0D,
+	EMODPR		= 0x0E,
+	EMODT		= 0x0F,
+	EUPDATESVN	= 0x18,
 };
 
 /**
@@ -73,6 +74,10 @@ enum sgx_encls_function {
  *				public key does not match IA32_SGXLEPUBKEYHASH.
  * %SGX_PAGE_NOT_MODIFIABLE:	The EPC page cannot be modified because it
  *				is in the PENDING or MODIFIED state.
+ * %SGX_INSUFFICIENT_ENTROPY:	Insufficient entropy in RNG.
+ * %SGX_NO_UPDATE:		EUPDATESVN was successful, but CPUSVN was not
+ *				updated because current SVN was not newer than
+ *				CPUSVN.
  * %SGX_UNMASKED_EVENT:		An unmasked event, e.g. INTR, was received
  */
 enum sgx_return_code {
@@ -81,6 +86,8 @@ enum sgx_return_code {
 	SGX_CHILD_PRESENT		= 13,
 	SGX_INVALID_EINITTOKEN		= 16,
 	SGX_PAGE_NOT_MODIFIABLE		= 20,
+	SGX_INSUFFICIENT_ENTROPY	= 29,
+	SGX_NO_UPDATE				= 31,
 	SGX_UNMASKED_EVENT		= 128,
 };
 
-- 
2.45.2

