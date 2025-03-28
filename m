Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD3191DE4C7;
	Fri, 28 Mar 2025 12:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743166761; cv=none; b=J8y2IsfcTzYvkyYAAI1h34E1qiTdpu2AQMJyRSd+BkAQPclA6360tGjSfdrjduVSiNtv2/xA5rC31JCzDWvf3Ywsp3vFBcNENOJJqYgN78sqoxeWzUlhXUtkjCeH8xS3zqix1KriSAuSG4a+Gz8+bMAoHZEYRQHsg4g7Scn+uJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743166761; c=relaxed/simple;
	bh=wih2ilrATlQIKSO34GAvANb28/Na5qATEonTK3ldWBo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qSC1La4s4+iVul2+29bgZO+EX/4cOY5ccuVtI67i9VMam+7SWMi0sfHdwqCkU0LUDfjXqP4eYGp48ZT4MZRae6DDt6OxY5Q9/A6FbovwPNq094GhTW+3s1LixBT3SsI9AndJTd23gcuSwoFGbBlKw/Cxi+hdoMBZhn8d6D30NJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Qv6lsn2g; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Qv6lsn2g"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743166760; x=1774702760;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=wih2ilrATlQIKSO34GAvANb28/Na5qATEonTK3ldWBo=;
  b=Qv6lsn2gj7g6upWhMIbmEu8BLU2j78r1kKLVO2znd8MPo3doZm+5Y7RQ
   47uXJqsRuqs7jUZYsQsMRChRiuvu9b+JaT6qjOa82f4y6PQ/eTC3Fm7xc
   l/qGRK/6V8rPfx0kAFLv6V8h7wDdBZBFJ7/h1XXKhg7VrQl3X2sv1Px/p
   +8h9m6aX4ju7sY+2EKcCT4eV8f8SPMmMNAb4WGwCiOBwxPZH6MqXYHID9
   Eyf03PQyPuZEPSA3VrY2cQ5LopC33F8j/IaTrav3Yk9hIXA8ZzL+ljg/n
   0EpJdfRRkOctXiHbyxGYZmWm1iO1HWkOZb323EVQMxT6U70D+sHXkydsr
   A==;
X-CSE-ConnectionGUID: Zpvu2Jx4QMydaPuXA9Q/mA==
X-CSE-MsgGUID: PR6vxF4VRSORGp/Wf76FhQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11387"; a="44420671"
X-IronPort-AV: E=Sophos;i="6.14,283,1736841600"; 
   d="scan'208";a="44420671"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2025 05:59:18 -0700
X-CSE-ConnectionGUID: NtBeb7CyRhm5L9y6zWGUtg==
X-CSE-MsgGUID: 65ngfoncQaWkK0/tNiIpfA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,283,1736841600"; 
   d="scan'208";a="125341378"
Received: from lfiedoro-mobl.ger.corp.intel.com (HELO eresheto-mobl3.ger.corp.intel.com) ([10.245.246.104])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2025 05:59:12 -0700
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
Subject: [PATCH v2 0/2] Enable automatic SVN updates for SGX enclaves
Date: Fri, 28 Mar 2025 14:57:39 +0200
Message-ID: <20250328125859.73803-1-elena.reshetova@intel.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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

 arch/x86/include/asm/sgx.h      | 41 +++++++++++-------
 arch/x86/kernel/cpu/sgx/encls.h |  6 +++
 arch/x86/kernel/cpu/sgx/main.c  | 76 ++++++++++++++++++++++++++++++---
 arch/x86/kernel/cpu/sgx/sgx.h   |  1 +
 4 files changed, 104 insertions(+), 20 deletions(-)

-- 
2.45.2

