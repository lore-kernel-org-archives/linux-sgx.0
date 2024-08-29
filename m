Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80378610B;
	Thu, 29 Aug 2024 02:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724899090; cv=none; b=QHvCY9OmgwDna5mmB2i0Puajs+lP0THQFuEbnKGKplsEV7MEjKmRCLMNlF2P7hvcFy5WHq7h58TTzkd/2unn0o6YrRQvj5gpzk8Ei2JMUZFNKeqbo42N+IU19b1xGJfUp5/CUKkaVy9c1+aaTWDWoolDFnTFDEmfsXBlum8al6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724899090; c=relaxed/simple;
	bh=OumzwTcuDEn5MdrTGE6WHRRJC4AZ6KuuHPCtsjrmkBs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gst4SRRRWeUCbVXxaQ9hoV+VVaSgIug3PKJMdWBcGPGdOynTx29K7ffpdbtcEkcQ7wlsXn6tasAGr4fWar7EfZGMYyryyqh0uSyo9hYb7yQhIkgt/XFUETGibfA+SHe8onqJOeTlnVHls0+niJhMvyxY2NnOMlLmE+x4l4vDYQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cmuPaUD6; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cmuPaUD6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724899088; x=1756435088;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=OumzwTcuDEn5MdrTGE6WHRRJC4AZ6KuuHPCtsjrmkBs=;
  b=cmuPaUD6sCyutOhGS3GqaA2a+Fhw077AR5lMehbKk9Cz3gHkSb4+abcM
   jfcSek3FZotYb+eE1jYfZeDW2Z59U4xqEjbqGf3OwLx1lwSbElv/Sr8t4
   ejfiDQ4BmnreBvV4NwMs8BxeYu9ajbF6ofH4ggePhzBXfJeCO3eddKkvp
   PFSJmvKEBlKMyBnzqqMu29yRsUs5UMo72e68gUHFFWmStQ8PpmIZykEz+
   YOwDqN/1zUPaIPYEft7z6ogHMOhSyb7CfMyRpHccipiHDpM4AfhvxJ8GI
   J3N+o9PsZU7CzwzhChJAJcjDf3qhrDB8rlNjg4jitBOU8iyMeuS5Kk8+Z
   w==;
X-CSE-ConnectionGUID: qskY3voWRnWYgry8aCabLQ==
X-CSE-MsgGUID: iOwMDZ//T02HVilnHkNArQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11178"; a="34124016"
X-IronPort-AV: E=Sophos;i="6.10,184,1719903600"; 
   d="scan'208";a="34124016"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2024 19:38:08 -0700
X-CSE-ConnectionGUID: szdhSx/RSnK9/fDauOe9FA==
X-CSE-MsgGUID: kL/Fp3leQfOHRl5pAvZ/6Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,184,1719903600"; 
   d="scan'208";a="63617590"
Received: from ziqianlu-desk2.sh.intel.com ([10.239.159.54])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2024 19:38:06 -0700
From: Aaron Lu <aaron.lu@intel.com>
To: Jarkko Sakkinen <jarkko@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>
Cc: x86@kernel.org,
	linux-sgx@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zhimin Luo <zhimin.luo@intel.com>
Subject: [PATCH] x86/sgx: Fix deadloop in __sgx_alloc_epc_page()
Date: Thu, 29 Aug 2024 10:38:00 +0800
Message-ID: <20240829023800.1671210-1-aaron.lu@intel.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When current node doesn't have a EPC section configured by firmware and
all other EPC sections memory are used up, CPU can stuck inside the
while loop in __sgx_alloc_epc_page() forever and soft lockup will happen.
Note how nid_of_current will never equal to nid in that while loop because
nid_of_current is not set in sgx_numa_mask.

Also worth mentioning is that it's perfectly fine for firmware to not
seup an EPC section on a node. Setting an EPC section on each node can
be good for performance but that's not a requirement functionality wise.

Fixes: 901ddbb9ecf5 ("x86/sgx: Add a basic NUMA allocation scheme to sgx_alloc_epc_page()")
Reported-by: Zhimin Luo <zhimin.luo@intel.com>
Tested-by: Zhimin Luo <zhimin.luo@intel.com>
Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
This issue is found by Zhimin when doing internal testing and no
external bug report has been sent out so there is no Closes: tag.

 arch/x86/kernel/cpu/sgx/main.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 1a000acd933a..694fcf7a5e3a 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -475,24 +475,25 @@ struct sgx_epc_page *__sgx_alloc_epc_page(void)
 {
 	struct sgx_epc_page *page;
 	int nid_of_current = numa_node_id();
-	int nid = nid_of_current;
+	int nid_start, nid;
 
-	if (node_isset(nid_of_current, sgx_numa_mask)) {
-		page = __sgx_alloc_epc_page_from_node(nid_of_current);
-		if (page)
-			return page;
-	}
-
-	/* Fall back to the non-local NUMA nodes: */
-	while (true) {
-		nid = next_node_in(nid, sgx_numa_mask);
-		if (nid == nid_of_current)
-			break;
+	/*
+	 * Try local node first. If it doesn't have an EPC section,
+	 * fall back to the non-local NUMA nodes.
+	 */
+	if (node_isset(nid_of_current, sgx_numa_mask))
+		nid_start = nid_of_current;
+	else
+		nid_start = next_node_in(nid_of_current, sgx_numa_mask);
 
+	nid = nid_start;
+	do {
 		page = __sgx_alloc_epc_page_from_node(nid);
 		if (page)
 			return page;
-	}
+
+		nid = next_node_in(nid, sgx_numa_mask);
+	} while (nid != nid_start);
 
 	return ERR_PTR(-ENOMEM);
 }

base-commit: a85536e1bce722cb184abbac98068217874bdd6e
-- 
2.45.2

