Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A9F72459EA;
	Fri,  1 Aug 2025 11:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754047613; cv=none; b=irmc1g/3TKwtxJQNTI+32M5fTbGiGrXK/U1obeUnsvt8Q2UtAHGh8PzuQ08b9hRY52QAav5B6lks5Wzbf01SmKnROBHnv48bB6hew6PkBVc666cXFoX1T8sibNcsX75dm3KxxFIx9Z9hWtu2uzhJBtHSJZh8ImDLxBJdQ998hVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754047613; c=relaxed/simple;
	bh=p3OfQo+a9uQB6l65p1mAORFqE3su7GRtll6CjNHX3NQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uDLdgUWbOf6ALTCk0f/CnYSMXfTVTXZEwXZS3JVvqg7DvQXhSLIhbwkQ+oxERiUyh6/iZLXFaWKpxbpqwop/pL6alyhWOg5V8QVF1ZgvpEAhlkZdBQBSS2LTJdrWjaG1tmKpPxXidjHXLmZs2k12SsMK4+uTQoLgCoZn5V1VscY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EgApgbzu; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EgApgbzu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754047612; x=1785583612;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=p3OfQo+a9uQB6l65p1mAORFqE3su7GRtll6CjNHX3NQ=;
  b=EgApgbzuqDcMeV8tGv9WZYs8m5oPHI25OktbuPsmnWsErjiI95u+zJTX
   J9ksxvphYctm9BK7hC1S1UV++/7N8yL/Br1QglLxrujFRxJz274BDB9uM
   WxevEFNqL8EWNrb0imYOb0U0jPKeRPd9XfaG+rFDkBFgZaoFFGTPViq4v
   1UEV0yt3BnBfqkY+iM8U4MlfRMIWi/Qrg6CxYx5QDRgxaisSwjeCtmsA9
   E7wGidrDuIYugVrO1B7iLca2oJebMpHzXgWovFeVq9a6AbyFpwXfREidC
   VTf8r14DzG21IHiTR7xOBDi5TUHnu6CnkFGN/KI9RqtLqwNW0F4JGS9Rc
   g==;
X-CSE-ConnectionGUID: UJYMuC1RQQm8nfo0PYEfrQ==
X-CSE-MsgGUID: FCdEJ5AEQnu/std+SWAyGg==
X-IronPort-AV: E=McAfee;i="6800,10657,11508"; a="59014780"
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="59014780"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2025 04:26:51 -0700
X-CSE-ConnectionGUID: I4lC5i/oRcO3oBRqNNoBlg==
X-CSE-MsgGUID: +gsR9cUzRpODlUK7WuTxJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="167727121"
Received: from sschumil-mobl2.ger.corp.intel.com (HELO eresheto-mobl3.ger.corp.intel.com) ([10.245.244.159])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2025 04:26:46 -0700
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
Subject: [PATCH v10 3/6] x86/cpufeatures: Add X86_FEATURE_SGX_EUPDATESVN feature flag
Date: Fri,  1 Aug 2025 14:25:18 +0300
Message-ID: <20250801112619.1117549-4-elena.reshetova@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250801112619.1117549-1-elena.reshetova@intel.com>
References: <20250801112619.1117549-1-elena.reshetova@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a flag indicating whenever ENCLS[EUPDATESVN] SGX instruction
is supported. This will be used by SGX driver to perform CPU
SVN updates.

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
---
 arch/x86/include/asm/cpufeatures.h       | 1 +
 arch/x86/kernel/cpu/cpuid-deps.c         | 1 +
 arch/x86/kernel/cpu/scattered.c          | 1 +
 tools/arch/x86/include/asm/cpufeatures.h | 1 +
 4 files changed, 4 insertions(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 602957dd2609..830d24ff1ada 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -494,6 +494,7 @@
 #define X86_FEATURE_TSA_SQ_NO		(21*32+11) /* AMD CPU not vulnerable to TSA-SQ */
 #define X86_FEATURE_TSA_L1_NO		(21*32+12) /* AMD CPU not vulnerable to TSA-L1 */
 #define X86_FEATURE_CLEAR_CPU_BUF_VM	(21*32+13) /* Clear CPU buffers using VERW before VMRUN */
+#define X86_FEATURE_SGX_EUPDATESVN	(21*32+14) /* Support for ENCLS[EUPDATESVN] instruction */
 
 /*
  * BUG word(s)
diff --git a/arch/x86/kernel/cpu/cpuid-deps.c b/arch/x86/kernel/cpu/cpuid-deps.c
index 46efcbd6afa4..3d9f49ad0efd 100644
--- a/arch/x86/kernel/cpu/cpuid-deps.c
+++ b/arch/x86/kernel/cpu/cpuid-deps.c
@@ -79,6 +79,7 @@ static const struct cpuid_dep cpuid_deps[] = {
 	{ X86_FEATURE_SGX_LC,			X86_FEATURE_SGX	      },
 	{ X86_FEATURE_SGX1,			X86_FEATURE_SGX       },
 	{ X86_FEATURE_SGX2,			X86_FEATURE_SGX1      },
+	{ X86_FEATURE_SGX_EUPDATESVN,		X86_FEATURE_SGX1      },
 	{ X86_FEATURE_SGX_EDECCSSA,		X86_FEATURE_SGX1      },
 	{ X86_FEATURE_XFD,			X86_FEATURE_XSAVES    },
 	{ X86_FEATURE_XFD,			X86_FEATURE_XGETBV1   },
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index b4a1f6732a3a..d13444d11ba0 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -42,6 +42,7 @@ static const struct cpuid_bit cpuid_bits[] = {
 	{ X86_FEATURE_PER_THREAD_MBA,		CPUID_ECX,  0, 0x00000010, 3 },
 	{ X86_FEATURE_SGX1,			CPUID_EAX,  0, 0x00000012, 0 },
 	{ X86_FEATURE_SGX2,			CPUID_EAX,  1, 0x00000012, 0 },
+	{ X86_FEATURE_SGX_EUPDATESVN,		CPUID_EAX, 10, 0x00000012, 0 },
 	{ X86_FEATURE_SGX_EDECCSSA,		CPUID_EAX, 11, 0x00000012, 0 },
 	{ X86_FEATURE_HW_PSTATE,		CPUID_EDX,  7, 0x80000007, 0 },
 	{ X86_FEATURE_CPB,			CPUID_EDX,  9, 0x80000007, 0 },
diff --git a/tools/arch/x86/include/asm/cpufeatures.h b/tools/arch/x86/include/asm/cpufeatures.h
index ee176236c2be..78c3894c17c1 100644
--- a/tools/arch/x86/include/asm/cpufeatures.h
+++ b/tools/arch/x86/include/asm/cpufeatures.h
@@ -487,6 +487,7 @@
 #define X86_FEATURE_PREFER_YMM		(21*32+ 8) /* Avoid ZMM registers due to downclocking */
 #define X86_FEATURE_APX			(21*32+ 9) /* Advanced Performance Extensions */
 #define X86_FEATURE_INDIRECT_THUNK_ITS	(21*32+10) /* Use thunk for indirect branches in lower half of cacheline */
+#define X86_FEATURE_SGX_EUPDATESVN	(21*32+14) /* Support for ENCLS[EUPDATESVN] instruction */
 
 /*
  * BUG word(s)
-- 
2.45.2

