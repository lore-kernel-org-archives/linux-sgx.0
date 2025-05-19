Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBF00266565;
	Mon, 19 May 2025 07:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747639599; cv=none; b=HJYtHe41dsUZv//JBcdskpk+I24DXoik2cAssbnwuripI/2tcNhmVuQvxS9xxQXq+2US6/FJoLP0O+xNypH3XVvUgHlJU1ekbH9cnSO+hgCyUWUT+Ysfn2NBh3wK4NafW+1eZMY9MYt6xHADPRuvULgKvKvHl3VTiEQOXaK8Loo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747639599; c=relaxed/simple;
	bh=e29DaBHvhlmcsQr4r4BBWzMBguAyQbp5kFhjFcxhsGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DocP/UtrCMCGrw7ORTJtk6lERCbWNAP0GZ8mFJCs12uTzFZZmnH6dGeI55JURFhUWWIXaqIp9x8gsnOduphhqMQTdFIwSO4n16ZwxWlIwA2KV6oD2Y23Im4mp0V0Qz65c4rTj1vMyT9qcnriNoN/peGQbRnHw1kF48f3wlcN+D8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BWd+C56m; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BWd+C56m"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747639598; x=1779175598;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=e29DaBHvhlmcsQr4r4BBWzMBguAyQbp5kFhjFcxhsGw=;
  b=BWd+C56mMSAqJOH4T4XoXOOtPquajAGQ0EPKm+8AHAX6BVkxiijBMz4Y
   fS9fkV6pl8Gk6dy8CQnSp0AWGLD4pZrsf8uwY8LATHUUDCOCFkQkGTKiY
   BspHXj5MQGS6AIxDAXd72dBmvhA8Ue1PQ77HidESUFGAlAPyQma9+9S2F
   ZLuYNy2fWaHvdjbgcMBqk4iraCQgR+eVocggJCdPbM0cx86mQWS1xdWv0
   vVMGjh4ZcksvHR8ncuXQKvfJDE9xyFjptwU74aCbXwyXRxgHZZD87F1Zq
   CVnK+6uTT1NB8+7kQuaXvFQtR2KOI3KngCkhVkXuO0Bj/H5VCh4rhNoOJ
   Q==;
X-CSE-ConnectionGUID: MU6mUge6RBiFK9fBnNyi4Q==
X-CSE-MsgGUID: gArviXkhTsS0e9Nj0UHvnA==
X-IronPort-AV: E=McAfee;i="6700,10204,11437"; a="49591602"
X-IronPort-AV: E=Sophos;i="6.15,300,1739865600"; 
   d="scan'208";a="49591602"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 00:26:38 -0700
X-CSE-ConnectionGUID: uw5YTDOnRtCCaan21DcLeQ==
X-CSE-MsgGUID: ulWvC3RvRoGavLJMAJLshw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,300,1739865600"; 
   d="scan'208";a="139029731"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO eresheto-mobl3.ger.corp.intel.com) ([10.245.244.195])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 00:26:33 -0700
From: Elena Reshetova <elena.reshetova@intel.com>
To: dave.hansen@intel.com
Cc: jarkko@kernel.org,
	seanjc@google.com,
	kai.huang@intel.com,
	linux-sgx@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	asit.k.mallick@intel.com,
	vincent.r.scarlata@intel.com,
	chongc@google.com,
	erdemaktas@google.com,
	vannapurve@google.com,
	dionnaglaze@google.com,
	bondarn@google.com,
	scott.raynor@intel.com,
	Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH v5 2/5] x86/cpufeatures: Add X86_FEATURE_SGX_EUPDATESVN feature flag
Date: Mon, 19 May 2025 10:24:28 +0300
Message-ID: <20250519072603.328429-3-elena.reshetova@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250519072603.328429-1-elena.reshetova@intel.com>
References: <20250519072603.328429-1-elena.reshetova@intel.com>
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
 arch/x86/kernel/cpu/scattered.c          | 1 +
 tools/arch/x86/include/asm/cpufeatures.h | 1 +
 3 files changed, 3 insertions(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 6c2c152d8a67..ed0c0fa5822a 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -481,6 +481,7 @@
 #define X86_FEATURE_AMD_HETEROGENEOUS_CORES (21*32 + 6) /* Heterogeneous Core Topology */
 #define X86_FEATURE_AMD_WORKLOAD_CLASS	(21*32 + 7) /* Workload Classification */
 #define X86_FEATURE_PREFER_YMM		(21*32 + 8) /* Avoid ZMM registers due to downclocking */
+#define X86_FEATURE_SGX_EUPDATESVN	(21*32 + 9) /* Support for ENCLS[EUPDATESVN] instruction */
 
 /*
  * BUG word(s)
diff --git a/arch/x86/kernel/cpu/scattered.c b/arch/x86/kernel/cpu/scattered.c
index 16f3ca30626a..a7e1fcedca3c 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -41,6 +41,7 @@ static const struct cpuid_bit cpuid_bits[] = {
 	{ X86_FEATURE_PER_THREAD_MBA,		CPUID_ECX,  0, 0x00000010, 3 },
 	{ X86_FEATURE_SGX1,			CPUID_EAX,  0, 0x00000012, 0 },
 	{ X86_FEATURE_SGX2,			CPUID_EAX,  1, 0x00000012, 0 },
+	{ X86_FEATURE_SGX_EUPDATESVN,	CPUID_EAX, 10, 0x00000012, 0 },
 	{ X86_FEATURE_SGX_EDECCSSA,		CPUID_EAX, 11, 0x00000012, 0 },
 	{ X86_FEATURE_HW_PSTATE,		CPUID_EDX,  7, 0x80000007, 0 },
 	{ X86_FEATURE_CPB,			CPUID_EDX,  9, 0x80000007, 0 },
diff --git a/tools/arch/x86/include/asm/cpufeatures.h b/tools/arch/x86/include/asm/cpufeatures.h
index 6c2c152d8a67..ed0c0fa5822a 100644
--- a/tools/arch/x86/include/asm/cpufeatures.h
+++ b/tools/arch/x86/include/asm/cpufeatures.h
@@ -481,6 +481,7 @@
 #define X86_FEATURE_AMD_HETEROGENEOUS_CORES (21*32 + 6) /* Heterogeneous Core Topology */
 #define X86_FEATURE_AMD_WORKLOAD_CLASS	(21*32 + 7) /* Workload Classification */
 #define X86_FEATURE_PREFER_YMM		(21*32 + 8) /* Avoid ZMM registers due to downclocking */
+#define X86_FEATURE_SGX_EUPDATESVN	(21*32 + 9) /* Support for ENCLS[EUPDATESVN] instruction */
 
 /*
  * BUG word(s)
-- 
2.45.2

