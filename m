Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F3126C3AC;
	Thu, 14 Aug 2025 07:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755157035; cv=none; b=b+Nj1ujmUa2p2y4eN3oEz16Duk4EEupyPEbWwDjUR80WTf84+GqcBpvzwpXZu2l3LrT+p1NzdXh/5sN83B6igv0lAePuZ/E7MlQ8cXVSg7riQ1iLyWcqbU2mCDFlVdIxqU0LLRhJNbW46+ZG+Xuc8jQ6jT4YJBlLejiC75PbFrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755157035; c=relaxed/simple;
	bh=cX5A+CNwKi9QHAUjvAxuyixnSiBYkXnaPIzlYfdju7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mwnhxeRzD4+n8VogP6gMzEDlw42x7AnCtF61MkUnxiXVXHZgLd2mZ3EOFw0q8FKHuOMUYeZnMpwdW4zLQrDgOQwf0IU5q3NuXBYgqWADZLWfoWLpWpQFdQgQZkIQXGI4KwI/SYC0duK7u2j93riop/XCZQ99RFCAKJwhxbBZ7MI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DV6HQmSu; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DV6HQmSu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755157033; x=1786693033;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cX5A+CNwKi9QHAUjvAxuyixnSiBYkXnaPIzlYfdju7A=;
  b=DV6HQmSu8Ot7newMwOHeUtqpBDKLkIqe2/gsFQEb5gXp+uyO3YOy4oWZ
   M7HZ4pWqvg3ZFZ4/5SynvIOqf8VeIAMbiwbKIt5E5mNOUA6M2Tqznh5I4
   AHhncRlSAjBxAteR5TziCcwWI62dmjk2EFOkvyhFhyJ1kytBlYHMIZG5l
   /R052fhN8D4b4HUmsKR4MLpJ8O1qnBJouK0018cvQA7/kQzMyDLJ8uvUg
   jOHqPpcyTvYSzKmB8tsxX3+lL03l017/+XQBv20r6Ci6rX+W/i7tUkzRd
   XlHH7vCzj0Rzs6KybuXfIPp8IUHf0EIbqFfe0KOuOsSfMO5eQNm9Gcs7m
   Q==;
X-CSE-ConnectionGUID: tggVjhGLTnGoqkfGNwac3g==
X-CSE-MsgGUID: hmI9NXvrR/2d8tc7XECQIg==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="82899357"
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="82899357"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 00:37:13 -0700
X-CSE-ConnectionGUID: IQXUWfx8Qa+joPFNU5FXhA==
X-CSE-MsgGUID: +qTfbqmYRfSPmUIMT78m4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="171927373"
Received: from foboril-desk.ger.corp.intel.com (HELO eresheto-mobl3.ger.corp.intel.com) ([10.245.244.138])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 00:37:09 -0700
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
Subject: [PATCH v14 2/5] x86/cpufeatures: Add X86_FEATURE_SGX_EUPDATESVN feature flag
Date: Thu, 14 Aug 2025 10:34:22 +0300
Message-ID: <20250814073640.1507050-3-elena.reshetova@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250814073640.1507050-1-elena.reshetova@intel.com>
References: <20250814073640.1507050-1-elena.reshetova@intel.com>
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

