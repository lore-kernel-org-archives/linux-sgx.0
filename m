Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E08F2EF9DD;
	Fri, 11 Jul 2025 16:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752252844; cv=none; b=p1dytKpEEWXqCXSMC7yINDfDw6oTNn5U0dWtScxHpjlvJQscyLMoHZf9seuH/umPCb3LK7ZskdTznogm4H081+NDaLXRwhL3hYSBzjHP4IG1xBOiMBZv1c8/1m8Ptuwvn8dHiZCkTxP4ggL5fzTUC5iW6QdfqikJ6V2C9frxA1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752252844; c=relaxed/simple;
	bh=+QIohnw87gs9YmMKFPk0eGu55BsmVC6pZrKo+VjR4vA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=offK6mbD0FCWoLs8tsSw3gZvyZLDYtx7y5NvTeiiHe2ZNQGw/YR4Dfm7cEqzFq5sVz506R7d1wRX4dx7eMMRxInPGGGLPJ0wXY8c5CTqkbLnfgQx9JaNWU6EaGTT6znp/qkARMNUs3mWCg4NaVW1MPvFOj7n3cf2pdRajlO8yJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ou1CKGSA; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ou1CKGSA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752252842; x=1783788842;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+QIohnw87gs9YmMKFPk0eGu55BsmVC6pZrKo+VjR4vA=;
  b=Ou1CKGSAoDaN9na8FyrnKUKJjvoL/7qhzex0ScvPL+R+yCbnpqGi9+yF
   RiphRIQDaEmZgb0HTzU58iYoApOqjo2ObFYI03OLbJ6pPfJUT8LQ3ZdIA
   X2pA/ZeoqawCXghFJQc1Ra8pAyzqXS7FeXNHg5LNVKWm0ebcSz1Apbod4
   axiDhclWk/KLufdT2a1nG/SHl7QXLuZiwP/TnrvEPR+kGIrM/vdrF/aRW
   HBjrfVyvzYPM0KDU8eNgWUqTIV3w+34aAzlfitUqInrg90NdVkocS2KME
   681aKfiX3/u+kr5A4XiLO2370osJn34NEygFjLaYgTVVSZD14hzwnB0wX
   Q==;
X-CSE-ConnectionGUID: +ZhvCDVtSl619XudDjOJCQ==
X-CSE-MsgGUID: ecX51GL3Q/Ksb+z+tG1QaA==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="53665422"
X-IronPort-AV: E=Sophos;i="6.16,304,1744095600"; 
   d="scan'208";a="53665422"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 09:52:35 -0700
X-CSE-ConnectionGUID: JOJUEFCqTmCp9u3h5X4vuQ==
X-CSE-MsgGUID: oHCWSfoCT0KpE/8T4lMQPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,304,1744095600"; 
   d="scan'208";a="187387756"
Received: from lfiedoro-mobl.ger.corp.intel.com (HELO eresheto-mobl3.ger.corp.intel.com) ([10.245.245.49])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 09:52:30 -0700
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
	dionnaglaze@google.com,
	bondarn@google.com,
	scott.raynor@intel.com,
	Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH v7 0/5] Enable automatic SVN updates for SGX enclaves
Date: Fri, 11 Jul 2025 19:50:29 +0300
Message-ID: <20250711165212.1354943-1-elena.reshetova@intel.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Changes since v6 following reviews by Kai,Jarkko
and Dave:

 - fix sgx_update_svn function description
 - add maybe_unused for sgx_update_svn in patch 4
 to silence the warning, remove it in patch 5
 - add note to patch 1 explaining why the prototype
 sgx_inc_usage_count returns int and not void
 - fix the order of return code checks in 
 sgx_update_svn
 - cosmetic fixes
 
Note: I didn't change the sgx_inc/dec_usage_count
to statics because they are called from a number of
different code locations and also rely on a static
sgx_usage_count, which lives naturally in main.c.

Changes since v5 following reviews by Ingo, Kai,
Jarkko and Dave:

 - rebase on x86 tip
 - patch 1 is fixed to do correct unwinding in
 case of errors
 - patch 2: add feature flag to cpuid-deps.c
 - patch 3: remove unused SGX_EPC_NOT_READY error code
 - patch 4: fix x86 feature check, return -EAGAIN
 on SGX_INSUFFICIENT_ENTROPY and -EIO on other non-
 expected errors. Comments/style are also fixed.
 - patch 5: rewrite commit message, add comments inline

Changes since v4 following reviews by Dave and Jarkko:

 - breakdown the single patch into 4 patches as
 suggested by Dave
 - fix error unwinding in sgx_(vepc_)open as 
 suggested by Jarkko
 - numerous code improvements suggested by Dave
 - numerous additional code comments and commit
 message improvements as suggested by Dave
 - switch to usage of atomic64_t for sgx_usage_count
 to ensure overflows cannot happen as suggested by Dave
 - do not return a error case when failing with
 SGX_INSUFFICIENT_ENTROPY, fail silently as suggested
 by Dave

Changes since v3 following reviews by Kai and Sean:

 - Change the overall approach to the one suggested
  by Sean and do the EUPDATESVN execution during
  sgx_open() and sgx_vepc_open().
  Note, I do not try to do EUPDATESVN during the release()
  flows since it doesnt save any noticable amount
  of time during next open flow per underlying EUPDATESVN
  microcode logic.
 - In sgx_update_svn() remove the check that we are
  running under VMM and expect the VMM to instead
  expose correct CPUID
 - Move the actual CPUID leaf check out of
  sgx_update_svn() into sgx_init()
 - Use existing RDRAND_RETRY_LOOPS define instead of 10
 - Change the sgx_update_svn() to return 0 only in
 success cases (or if unsupported)
 - Various smaller cosmetic fixes

The still to be discussed question is what sgx_update_svn()
should return in case of various failures. The current version
follows suggestion by Kai and would return an error (and block
sgx_(vepc_)open() in all cases, including running out of entropy.
I think this might be the correct approach for SGX_INSUFFICIENT_ENTROPY
since in such cases userspace can retry the open() and also
will get an info about what is actually blocking the EUPDATEVSN
(and can act on this). However, this is a change in existing API
and therefore debatable and I would like to hear people's feedback.

Changes since v2 following review by Jarkko:

 - formatting of comments is fixed
 - change from pr_error to ENCLS_WARN to communicate errors from
 EUPDATESVN
 - In case an unknown error is detected (must not happen per spec),
 make page allocation from EPC fail in order to prevent EPC usage

Changes since v1 following review by Jarkko:

 - first and second patch are squashed together and a better
   explanation of the change is added into the commit message
 - third and fourth patch are also combined for better understanding
   of error code purposes used in 4th patch
 - implementation of sgx_updatesvn adjusted following Jarkko's 
   suggestions
 - minor fixes in both commit messages and code from the review
 - dropping co-developed-by tag since the code now differs enough
   from the original submission. However, the reference where the
   original code came from and credits to original author is kept

Background
----------

In case an SGX vulnerability is discovered and TCB recovery
for SGX is triggered, Intel specifies a process that must be
followed for a given vulnerability. Steps to mitigate can vary
based on vulnerability type, affected components, etc.
In some cases, a vulnerability can be mitigated via a runtime
recovery flow by shutting down all running SGX enclaves,
clearing enclave page cache (EPC), applying a microcode patch
that does not require a reboot (via late microcode loading) and
restarting all SGX enclaves.


Problem statement
-------------------------
Even when the above-described runtime recovery flow to mitigate the
SGX vulnerability is followed, the SGX attestation evidence will
still reflect the security SVN version being equal to the previous
state of security SVN (containing vulnerability) that created
and managed the enclave until the runtime recovery event. This
limitation currently can be only overcome via a platform reboot,
which negates all the benefits from the rebootless late microcode
loading and not required in this case for functional or security
purposes.


Proposed solution
-----------------

SGX architecture introduced  a new instruction called EUPDATESVN [1]
to Ice Lake. It allows updating security SVN version, given that EPC
is completely empty. The latter is required for security reasons
in order to reason that enclave security posture is as secure as the
security SVN version of the TCB that created it.

This series enables opportunistic execution of EUPDATESVN upon first
EPC page allocation for a first enclave to be run on the platform.

This series is partly based on the previous work done by Cathy Zhang
[2], which attempted to enable forceful destruction of all SGX
enclaves and execution of EUPDATESVN upon successful application of
any microcode patch. This approach is determined as being too
intrusive for the running SGX enclaves, especially taking into account
that it would be performed upon *every* microcode patch application
regardless if it changes the security SVN version or not (change to the
security SVN version is a rare event).

Testing
-------

Tested on EMR machine using kernel-6.15.0_rc7 & sgx selftests.
Also tested on a Kaby Lake machine without EUPDATESVN support.
If Google folks in CC can test on their side, it would be greatly appreciated.


References
----------

[1] https://cdrdv2.intel.com/v1/dl/getContent/648682?explicitVersion=true
[2] https://lore.kernel.org/all/20220520103904.1216-1-cathy.zhang@intel.com/

Elena Reshetova (5):
  x86/sgx: Introduce a counter to count the sgx_(vepc_)open()
  x86/cpufeatures: Add X86_FEATURE_SGX_EUPDATESVN feature flag
  x86/sgx: Define error codes for use by ENCLS[EUPDATESVN]
  x86/sgx: Implement ENCLS[EUPDATESVN]
  x86/sgx: Enable automatic SVN updates for SGX enclaves

 arch/x86/include/asm/cpufeatures.h       |   1 +
 arch/x86/include/asm/sgx.h               |  37 ++++----
 arch/x86/kernel/cpu/cpuid-deps.c         |   1 +
 arch/x86/kernel/cpu/scattered.c          |   1 +
 arch/x86/kernel/cpu/sgx/driver.c         |  22 +++--
 arch/x86/kernel/cpu/sgx/encl.c           |   1 +
 arch/x86/kernel/cpu/sgx/encls.h          |   5 ++
 arch/x86/kernel/cpu/sgx/main.c           | 106 +++++++++++++++++++++++
 arch/x86/kernel/cpu/sgx/sgx.h            |   3 +
 arch/x86/kernel/cpu/sgx/virt.c           |  16 +++-
 tools/arch/x86/include/asm/cpufeatures.h |   1 +
 11 files changed, 171 insertions(+), 23 deletions(-)

-- 
2.45.2

