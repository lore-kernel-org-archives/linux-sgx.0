Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2383F1EB2F;
	Wed,  7 May 2025 11:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746616563; cv=none; b=UUGSfQu70PWM6yLPEAot9VVvDAQ3SH6xGMn+TI8vSQ52yqpBAFZ+CKY4GCzmHBm/sr87BAFeMtMuF3Fu6DumZ7ALrCuTlhxL1MLR/MKsL30Kcm4m5MUbil+iM4YVgKVcKYYxBHDZTt4z0wUnHDmdOTyd/kU7NZ3BtFtCXWEO22g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746616563; c=relaxed/simple;
	bh=uKAfoPLDuGlN4at1uYbGy/g18rTTTiv8PLKPzZpemCo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ijwQIc3duh5uWO/HzlBucKe2hUxYcGhJEtazkm31W4H+q8vuucd0EAgBNhbw2WvV8/hRomVSeJbrrnDO+2tm2RN1HLcUyMMh1zXIjnfbPU1NJueXQgfK8f3ZPCuZHM5Ym6wvDHd11N87eRzBAr319vehFQgGgVNmQQ2VkOhPxvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=n70XQHlY; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n70XQHlY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746616562; x=1778152562;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=uKAfoPLDuGlN4at1uYbGy/g18rTTTiv8PLKPzZpemCo=;
  b=n70XQHlYPJuq/v9hlhisw23Km7glEPIv0kd82N8RP43/2qVascFja0xP
   LKfYfNRwpXI4rg+iY4qh0kvt6TY6q16FR1ISjxTjQ5up/+aKCcNXe8PDe
   0D5i77tdPgYc9Rf5+JezLxTGAN2sTn8nV9XDG+gpNQd/Ok5IrDneqI0Le
   YVtzrGpdo7eWKG4SwHhWYTyiC4HfMYEVsw3QQ6IOMQuhfXhg/8DsFr1ck
   GrUtmLR0POdXRYKOPrchCN2CgASzleQH0fjxT7TuQYbrdVUdsqWcX1+Q2
   Q1VLoZvTX0g8gxzvVCx4cwU485BeyK3pbHPjeJMLD1BMYCGid8R/QIEqC
   g==;
X-CSE-ConnectionGUID: +jt3RxQcTVm9eAcstZYCyw==
X-CSE-MsgGUID: wvpS6tEpTMOhWhFSdjl6EQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11425"; a="59327506"
X-IronPort-AV: E=Sophos;i="6.15,269,1739865600"; 
   d="scan'208";a="59327506"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2025 04:16:01 -0700
X-CSE-ConnectionGUID: ZdVTAdx1RauabBD5cCMUCQ==
X-CSE-MsgGUID: ZeojCG1eT7Gc47ujLQ/Niw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,269,1739865600"; 
   d="scan'208";a="135637604"
Received: from smoticic-mobl1.ger.corp.intel.com (HELO eresheto-mobl3.ger.corp.intel.com) ([10.245.245.23])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2025 04:15:56 -0700
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
Subject: [PATCH v4 0/1] Enable automatic SVN updates for SGX enclaves
Date: Wed,  7 May 2025 14:13:59 +0300
Message-ID: <20250507111542.709858-1-elena.reshetova@intel.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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

[1] https://cdrdv2.intel.com/v1/dl/getContent/648682?explicitVersion=true
[2] https://lore.kernel.org/all/20220520103904.1216-1-cathy.zhang@intel.com/

Elena Reshetova (1):
  x86/sgx: Enable automatic SVN updates for SGX enclaves

 arch/x86/include/asm/sgx.h       | 42 ++++++++++++-------
 arch/x86/kernel/cpu/sgx/driver.c |  4 ++
 arch/x86/kernel/cpu/sgx/encl.c   |  1 +
 arch/x86/kernel/cpu/sgx/encls.h  |  5 +++
 arch/x86/kernel/cpu/sgx/main.c   | 70 ++++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/sgx/sgx.h    |  3 ++
 arch/x86/kernel/cpu/sgx/virt.c   |  6 +++
 7 files changed, 116 insertions(+), 15 deletions(-)

-- 
2.45.2

