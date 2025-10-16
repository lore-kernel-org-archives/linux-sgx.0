Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53707338F42;
	Thu, 16 Oct 2025 13:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760620439; cv=none; b=pIXghB1bepdWgJt+HoGzAz7lfHw0fdeIgQsoFusiCYMPqpNf+1iyLX2XEaO+GV8b1kifuSbCYZVdL+FthKDw8X7N++anSmordMMetdnwr/SLoyqVCByaDA/jPaRTHLY9++L4csobmVx1a6HNx2Z1jUWw/9NoCU/lzQRijyCd7OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760620439; c=relaxed/simple;
	bh=jRoq7JF8rovb+jVv6uFar0LHx/5OA0LVzpA7utFnOGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zd/00h7j8YpJASh9lzILVxIegcMKY2Lbtg+yl8jvgXRPw+ljSUPh8KlRMTvIgPmoD6ix3U/MlVeAATU+9TM+Y6Y/NMh4EYDWj9yWBK/UHLXqcBpvhBfDE8WHZSMr1hQ9pwYuMDaU4uBAxLt4kG1IrHh2VF9vgSKVq2FSmUEUQlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IJRaVccV; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IJRaVccV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760620438; x=1792156438;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jRoq7JF8rovb+jVv6uFar0LHx/5OA0LVzpA7utFnOGw=;
  b=IJRaVccVtXc4SemnQApJeqUhMsrY2ATNubxhH5M4yGjRlL3uai7HeF40
   vqL0A6Rfhdi+TsRANvMELsq1b4mPlLU2wZ293L8JwS2r3kEEkU269urBM
   8Ppb9lmqy22IpYRVGD0unEslS1R2RC+g8FeVD/ybfYWUwVWW2mBXDMrNS
   2/99hdhLQzStsu/GBa9bPS7dYTSqhxIsk6EVRH4Uw/b1R+GntiqhiaF/s
   37wJn/7vqTLBOW6ErWdFFCYw6c4ZwsqMcEl9kw+OgRreslsyPqGijyMel
   1vSjX3dAWhxVSkhkR3Zu5nZdeoEKMfZzSq9ALqGC1+DGXNasb8fyurWv8
   Q==;
X-CSE-ConnectionGUID: drT0YiksSyajhWsD6Doefw==
X-CSE-MsgGUID: EWQpDh/2Q/KwUV91+nIv+g==
X-IronPort-AV: E=McAfee;i="6800,10657,11584"; a="62904728"
X-IronPort-AV: E=Sophos;i="6.19,234,1754982000"; 
   d="scan'208";a="62904728"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2025 06:13:58 -0700
X-CSE-ConnectionGUID: Y2fCOYF8QuCuCZ7dA9sd7Q==
X-CSE-MsgGUID: OLO6mKHgQ8anth41zjrWqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,234,1754982000"; 
   d="scan'208";a="182015994"
Received: from klitkey1-mobl1.ger.corp.intel.com (HELO eresheto-mobl3.ger.corp.intel.com) ([10.245.244.10])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Oct 2025 06:13:53 -0700
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
	Elena Reshetova <elena.reshetova@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH v17 2/5] x86/cpufeatures: Add X86_FEATURE_SGX_EUPDATESVN feature flag
Date: Thu, 16 Oct 2025 16:11:05 +0300
Message-ID: <20251016131314.17153-3-elena.reshetova@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20251016131314.17153-1-elena.reshetova@intel.com>
References: <20251016131314.17153-1-elena.reshetova@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a flag indicating whenever ENCLS[EUPDATESVN] SGX instruction is
supported. This will be used by SGX driver to perform CPU SVN updates.

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Tested-by: Nataliia Bondarevska <bondarn@google.com>
---
 arch/x86/include/asm/cpufeatures.h | 1 +
 arch/x86/kernel/cpu/cpuid-deps.c   | 1 +
 arch/x86/kernel/cpu/scattered.c    | 1 +
 3 files changed, 3 insertions(+)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 4091a776e37a..76364b6dd93b 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -499,6 +499,7 @@
 #define X86_FEATURE_IBPB_EXIT_TO_USER	(21*32+14) /* Use IBPB on exit-to-userspace, see VMSCAPE bug */
 #define X86_FEATURE_ABMC		(21*32+15) /* Assignable Bandwidth Monitoring Counters */
 #define X86_FEATURE_MSR_IMM		(21*32+16) /* MSR immediate form instructions */
+#define X86_FEATURE_SGX_EUPDATESVN	(21*32+17) /* Support for ENCLS[EUPDATESVN] instruction */
 
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
index caa4dc885c21..37850356a9b5 100644
--- a/arch/x86/kernel/cpu/scattered.c
+++ b/arch/x86/kernel/cpu/scattered.c
@@ -43,6 +43,7 @@ static const struct cpuid_bit cpuid_bits[] = {
 	{ X86_FEATURE_PER_THREAD_MBA,		CPUID_ECX,  0, 0x00000010, 3 },
 	{ X86_FEATURE_SGX1,			CPUID_EAX,  0, 0x00000012, 0 },
 	{ X86_FEATURE_SGX2,			CPUID_EAX,  1, 0x00000012, 0 },
+	{ X86_FEATURE_SGX_EUPDATESVN,		CPUID_EAX, 10, 0x00000012, 0 },
 	{ X86_FEATURE_SGX_EDECCSSA,		CPUID_EAX, 11, 0x00000012, 0 },
 	{ X86_FEATURE_HW_PSTATE,		CPUID_EDX,  7, 0x80000007, 0 },
 	{ X86_FEATURE_CPB,			CPUID_EDX,  9, 0x80000007, 0 },
-- 
2.45.2

