Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54BDA8633F;
	Tue, 15 Apr 2025 11:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744718022; cv=none; b=S7dgq71Mo14LXvW+e2iQesCFV/ErQ1yZNdQfIoJiL7kY1R3ApTna7wj9bGuHWIKAh8elBFZ7nhxFFsGoTHGVOD6OMEv7kQwJ8vI32G4vFrAR3i9dcZT2NWQSLju4egZ/LH7ZzcE1akfIndxrxzDuH5k1kXSwROOecfdGNncRvbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744718022; c=relaxed/simple;
	bh=94q2RCnuvgKPMAhQQ247fmAbMzm7oWd9X6frjs1q7vA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=C4heewH4UFPKcnlJdVnaHJXyec7i7CoAL4EhIQFsEPEZEGuh7MCmuzwMUcX9rf7oOjNxEmKXSEInOl+nS/iMDYfhUdj65bwCpKz3alg2mYmIiMt+UwVmQUBf3JTUOTGK5IavuiYgtdPHEwemccAV0oDfXC95YDDDJ9o6lnp5PSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DmXIOOFJ; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DmXIOOFJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744718021; x=1776254021;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=94q2RCnuvgKPMAhQQ247fmAbMzm7oWd9X6frjs1q7vA=;
  b=DmXIOOFJfBhkZW7qFUfy1iqMmclRJ7W8eDuXnjQUgzzWt+eivp0lBpYd
   KdvHF/dJLPcr7iCicb9dWyUcPlW7Zc96Yaxg0V/Al/2lX48cwkbLgY7g2
   olIzpn1gE5E8jTXZcY7uo2DnSyWrEm5ij9xqZbZ7srnZspa2e0qNkuBV0
   ow/10xggRqWo/J80ZR1y7MCEBDKm0PoY/zaz10Bo0aTyeDAokfd6WD1t/
   +sjMjA1IiJ/WgyRDqW9q56qeMq5oHof3k0m0NOrAHug3LajbtvD3A94ZV
   SjdhhOvj6cEx6yQNyMPDb0jnd29+fjYBdgu8JrfXYIgJFyLOqw7fReuA2
   Q==;
X-CSE-ConnectionGUID: gyCIpobASaurhb0EW/jMng==
X-CSE-MsgGUID: we+VG6dSQzuKHHwgpXyBhA==
X-IronPort-AV: E=McAfee;i="6700,10204,11403"; a="46235088"
X-IronPort-AV: E=Sophos;i="6.15,213,1739865600"; 
   d="scan'208";a="46235088"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2025 04:52:33 -0700
X-CSE-ConnectionGUID: T4qn1hVqSNyUbl4NE4bLDA==
X-CSE-MsgGUID: lwjj83WQQLi3TC8nr8RMqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,213,1739865600"; 
   d="scan'208";a="130997566"
Received: from bergbenj-mobl1.ger.corp.intel.com (HELO eresheto-mobl3.ger.corp.intel.com) ([10.245.246.46])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2025 04:52:27 -0700
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
Subject: [PATCH v3 0/2] Enable automatic SVN updates for SGX enclaves
Date: Tue, 15 Apr 2025 14:51:20 +0300
Message-ID: <20250415115213.291449-1-elena.reshetova@intel.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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

Tested on EMR machine using kernel-6.14.0_rc7 & sgx selftests.
If Google folks in CC can test on their side, it would be greatly appreciated.


References
----------

[1] https://cdrdv2.intel.com/v1/dl/getContent/648682?explicitVersion=true
[2] https://lore.kernel.org/all/20220520103904.1216-1-cathy.zhang@intel.com/

Elena Reshetova (2):
  x86/sgx: Use sgx_nr_used_pages for EPC page count instead of
    sgx_nr_free_pages
  x86/sgx: Implement EUPDATESVN and opportunistically call it during
    first EPC page alloc

 arch/x86/include/asm/sgx.h      | 41 ++++++++------
 arch/x86/kernel/cpu/sgx/encls.h |  6 +++
 arch/x86/kernel/cpu/sgx/main.c  | 95 +++++++++++++++++++++++++++++++--
 arch/x86/kernel/cpu/sgx/sgx.h   |  1 +
 4 files changed, 123 insertions(+), 20 deletions(-)

-- 
2.45.2

