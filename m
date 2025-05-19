Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D56E563B9;
	Mon, 19 May 2025 07:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747639589; cv=none; b=l1JUUo2OuFdXuNAdK3+nWAlMj6dEhdzdq2BzDhw10A15o0T+TEsMwgyp/kRp+C+cJ/Jh6hVSOP3BYJPtMx/l2ljayz+fH4uGCSXAoL5ZKDcF+6cItv35rKGiYIL/UiyaLpXtyeLrbGN7ZRDSfw8ZQnqJXYJgr58HqcOJykUEpiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747639589; c=relaxed/simple;
	bh=ykGT/4GiDmq1JcNuYgkjpZHmJ6x6SO7zNakX2hoV6sM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=VAYroaqBbOLk0so6y2u75ezW0OyMyLSe8XhbbhS502RBrDs5hLqtW2z49b2UQEqWprpuvXunoVTNCRUK6oKnEAWasb3h8gJXqybGnMqpeSvCDJ7bYw2Zf3HRcZWAzIMJ8LA9wORDbJ8+Pf1FafLgzpH4vhi1YpTETnscdimhBt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eBa5tgYN; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eBa5tgYN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747639588; x=1779175588;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ykGT/4GiDmq1JcNuYgkjpZHmJ6x6SO7zNakX2hoV6sM=;
  b=eBa5tgYNCLei0NWZssWTwauZ8qbZdE8jZavR076bBVuSRoFhJdAlrQwP
   UUM2+gv7GfltBIuSRK1eyPsxCvK4sq+MMslmOYSbVfe64KlIXK27fAgTZ
   hjNvvx1RT65fSH/F0KvRbygeVTVAHOkEyxglGjtEtRwr1dmvjphhUze0z
   B3zjJTAYsnZa0mIT9s8NNs+tYRyE6InD+GU8BXFhDIMLgU86mraQAP2uX
   dDYlODJOXh3Uenqy5knA7c7ggryHzb9uvhnqYhKOEApnT4WDvGfqvLS6e
   UBhKwjpcYLK8j8CS09hG4VT8aQUYL06QlyEHuGcbUrnz84G2t+2JHmheK
   g==;
X-CSE-ConnectionGUID: fw9tn9ouQPKMePu2i6OwUg==
X-CSE-MsgGUID: YZnjEazKQTqsvjFmQeh67A==
X-IronPort-AV: E=McAfee;i="6700,10204,11437"; a="49591588"
X-IronPort-AV: E=Sophos;i="6.15,300,1739865600"; 
   d="scan'208";a="49591588"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 00:26:27 -0700
X-CSE-ConnectionGUID: gojDP5mWSz2mUMkeBmywHg==
X-CSE-MsgGUID: DGV/9cODQHmyRd3/+sS/FA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,300,1739865600"; 
   d="scan'208";a="139029698"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO eresheto-mobl3.ger.corp.intel.com) ([10.245.244.195])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 00:26:21 -0700
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
Subject: [PATCH v5 0/5] Enable automatic SVN updates for SGX enclaves
Date: Mon, 19 May 2025 10:24:26 +0300
Message-ID: <20250519072603.328429-1-elena.reshetova@intel.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

Tested on EMR machine using kernel-6.15.0_rc5 & sgx selftests.
If Google folks in CC can test on their side, it would be greatly appreciated.


References
----------

[1] https://cdrdv2.intel.com/v1/dl/getContent/648682
[2] https://lore.kernel.org/all/20220520103904.1216-1-cathy.zhang@intel.com/

Elena Reshetova (5):
  x86/sgx: Introduce a counter to count the sgx_(vepc_)open()
  x86/cpufeatures: Add X86_FEATURE_SGX_EUPDATESVN feature flag
  x86/sgx: Define error codes for use by ENCLS[EUPDATESVN]
  x86/sgx: Implement ENCLS[EUPDATESVN]
  x86/sgx: Enable automatic SVN updates for SGX enclaves

 arch/x86/include/asm/cpufeatures.h       |   1 +
 arch/x86/include/asm/sgx.h               |  39 +++++----
 arch/x86/kernel/cpu/scattered.c          |   1 +
 arch/x86/kernel/cpu/sgx/driver.c         |  22 +++--
 arch/x86/kernel/cpu/sgx/encl.c           |   1 +
 arch/x86/kernel/cpu/sgx/encls.h          |   5 ++
 arch/x86/kernel/cpu/sgx/main.c           | 103 +++++++++++++++++++++++
 arch/x86/kernel/cpu/sgx/sgx.h            |   3 +
 arch/x86/kernel/cpu/sgx/virt.c           |  16 +++-
 tools/arch/x86/include/asm/cpufeatures.h |   1 +
 10 files changed, 169 insertions(+), 23 deletions(-)

-- 
2.45.2

