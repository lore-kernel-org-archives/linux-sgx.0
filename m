Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DA86226D1E;
	Fri, 21 Mar 2025 12:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742560809; cv=none; b=VZr8YQHS3GTaPKaifmF/J/LRkpm21/Vsoe9tCrH7TJ4briRePYYKU4a6p1s4lFUtf7ZqbFMiLccuTZhFOGLnhzka+gsLT15hVM0f+gpMwHbkbb8TtaMnAz0P2xtSL0SAKjudsBaMYWGtIBr4WPludorZHA3USn24fKDj0zMBQlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742560809; c=relaxed/simple;
	bh=hcWvFi80BBGrynZntG4NGp0zz+211rv5V7sFIsl5teA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=l8LpFc4RwYY0rTHE3MZX0yBKqRZZ5Uuo5bboHGEUpsZfdCda0uAzxmEQs8irRiJ5v4bZHvblF3covRc15H9Tjht7DxlVyKZqN1aJzvKCtzt0zRPSh9Yt8YtKVk878SuQiBZHj8ON31ffOGXeSlT/VSlyCOI+9IEYMqMnnOgkvYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N2UgelIG; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N2UgelIG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742560807; x=1774096807;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=hcWvFi80BBGrynZntG4NGp0zz+211rv5V7sFIsl5teA=;
  b=N2UgelIGJWW3TvgiBod7VASx/pz40X2KnALRRVLrlH3BJae9OnIP+40w
   Q42ZBa2Xh+k4Yprzh3mxPzLngQTqXEocjVsIMDjJf98zFLNxxbCwLuWoL
   b8rLOkOvh7bfpahOla9pJsvhyZpxVM9rqbiqr2MXOEpnX4pptvQwbmu/y
   hU5B/y2QCu8S0Ro/oEsjRb0RQZ8zncoqP6pvujwXR6NQE8OcF84vSBgBm
   VZwrKs0ZCdJXDYwJjASK2NYfiDF/Ry5V0n+RGBsT7YJ51GOQyrbkbvJAX
   c7G9DihePJ56AWFzRpjlznCZcBxgLXF9j98PhXACDPRiFzoXR+GnVhuuz
   Q==;
X-CSE-ConnectionGUID: M2VJARcxQt2XVdpnHJawxQ==
X-CSE-MsgGUID: A5WWiM+lRQOIBi8CmjVVIQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11380"; a="54493348"
X-IronPort-AV: E=Sophos;i="6.14,264,1736841600"; 
   d="scan'208";a="54493348"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2025 05:40:06 -0700
X-CSE-ConnectionGUID: nKVePy+AT/iY4z00Ld0faw==
X-CSE-MsgGUID: hATTo9ZCTtyBori9ECO+tw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,264,1736841600"; 
   d="scan'208";a="154399873"
Received: from mwiniars-desk2.ger.corp.intel.com (HELO eresheto-mobl3.ger.corp.intel.com) ([10.245.246.189])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2025 05:39:52 -0700
From: Elena Reshetova <elena.reshetova@intel.com>
To: dave.hansen@intel.com
Cc: jarkko@kernel.org,
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
Subject: [PATCH 0/4] Enable automatic SVN updates for SGX enclaves
Date: Fri, 21 Mar 2025 14:34:39 +0200
Message-ID: <20250321123938.802763-1-elena.reshetova@intel.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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

Tested on EMR machine using kernel-6.14.0_rc7 & sgx selftests.
If Google folks in CC can test on their side, it would be greatly appreciated.


References
----------

[1] https://cdrdv2.intel.com/v1/dl/getContent/648682?explicitVersion=true
[2] https://lore.kernel.org/all/20220520103904.1216-1-cathy.zhang@intel.com/T/#r2399940e5b10465162529c05e9579b30883849f1

Elena Reshetova (4):
  x86/sgx: Add total number of EPC pages
  x86/sgx: Change counter sgx_nr_free_pages -> sgx_nr_used_pages
  x86/sgx: Define error codes for ENCLS[EUPDATESVN]
  x86/sgx: Implement ENCLS[EUPDATESVN] and opportunistically call it
    during first EPC page alloc

 arch/x86/include/asm/sgx.h      | 41 ++++++++++-------
 arch/x86/kernel/cpu/sgx/encls.h |  6 +++
 arch/x86/kernel/cpu/sgx/main.c  | 78 ++++++++++++++++++++++++++++++---
 arch/x86/kernel/cpu/sgx/sgx.h   |  2 +
 4 files changed, 107 insertions(+), 20 deletions(-)

-- 
2.45.2

