Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1483198E74;
	Thu,  5 Sep 2024 08:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725523824; cv=none; b=cSNsCPxKeZqx2AifMGKei4Qdrmz0maOCoHrrm4WLb1JDo9EPkc/Equ9DI4dkC9ygsV9l5SGeKycTrN1Mc/mDNwdt6Wqw49FEWmzKUM61EsE/tme5yddDGDDURyfZ6ZAZC7RpeiSLe9/1OGCZa8XyusDknOGKa8Uod3STp1dMyik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725523824; c=relaxed/simple;
	bh=VKvqN+dswVndho4oocKQbP+LGBzVfdRahbWZCmO6Tr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k8zwHgN4JNxWvO+nS7ESOLbMTcxjvi1MR49Hy5wwhMYuHrU/8SZ9L4nE6nLPds8ljpO7w5yqxKzRkkP2B059VtQlZ0dZRFjk5lByUzi/PyyPqjDjEUomfrGWva2hGRIsMcRKCKfHzzulRpdJWURn3D6waJT5KkrT4ZGL+AtvZ+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GRbq3jFy; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GRbq3jFy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725523823; x=1757059823;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VKvqN+dswVndho4oocKQbP+LGBzVfdRahbWZCmO6Tr8=;
  b=GRbq3jFy7i/ZGyQxlVGgBZs+h/+G/+8FNo/mxLYH28xyNOSOmnNO9QQg
   eAoOImM1dljz4PX9QLCXK5LdkkiXLaTsGWPekpcWav48mduMkS33Ms/z9
   +gz1GNTmP47xy2mwxpBiuzNyAPCAVwwUWiWtMrX4l7lXGIuny5SNPQ7eS
   shicY5yz86F32XqZVCdB64zGhcCDwiSoV43iLre61gX/H+/1Gp9QCwB+n
   e0qV0s/1EcJ5lADQ1gKS8XGM6PeUytvcWyPSOfSM/e1DrmRlbpxHXaJJp
   r+jReqmL6Ghng8qk8X//zS41EMrhg72I6v9KN6tRhEmonM7OtThAZz/2k
   Q==;
X-CSE-ConnectionGUID: gnwK4EpTQiifP08r/Hq9zA==
X-CSE-MsgGUID: WX7wKS7VTuSF+2qZjLOjuA==
X-IronPort-AV: E=McAfee;i="6700,10204,11185"; a="24176518"
X-IronPort-AV: E=Sophos;i="6.10,204,1719903600"; 
   d="scan'208";a="24176518"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2024 01:10:23 -0700
X-CSE-ConnectionGUID: RHLLrErlRlOI0RIe5Kc05A==
X-CSE-MsgGUID: aLENu7weSoGAs5r7CBI+uA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,204,1719903600"; 
   d="scan'208";a="65528393"
Received: from ziqianlu-desk2.sh.intel.com ([10.239.159.54])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2024 01:10:21 -0700
From: Aaron Lu <aaron.lu@intel.com>
To: Jarkko Sakkinen <jarkko@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Kai Huang <kai.huang@intel.com>
Cc: "Molina Sabido, Gerardo" <gerardo.molina.sabido@intel.com>,
	Zhimin Luo <zhimin.luo@intel.com>,
	linux-sgx@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH v2 1/2] x86/sgx: Fix deadlock in SGX NUMA node search
Date: Thu,  5 Sep 2024 16:08:54 +0800
Message-ID: <20240905080855.1699814-2-aaron.lu@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240905080855.1699814-1-aaron.lu@intel.com>
References: <20240905080855.1699814-1-aaron.lu@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When the current node doesn't have an EPC section configured by firmware
and all other EPC sections are used up, CPU can get stuck inside the
while loop that looks for an available EPC page from remote nodes
indefinitely, leading to a soft lockup. Note how nid_of_current will
never be equal to nid in that while loop because nid_of_current is not
set in sgx_numa_mask.

Also worth mentioning is that it's perfectly fine for the firmware not
to setup an EPC section on a node. While setting up an EPC section on
each node can enhance performance, it is not a requirement for
functionality.

Rework the loop to start and end on *a* node that has SGX memory. This
avoids the deadlock looking for the current SGX-lacking node to show up
in the loop when it never will.

Fixes: 901ddbb9ecf5 ("x86/sgx: Add a basic NUMA allocation scheme to sgx_alloc_epc_page()")
Reported-by: "Molina Sabido, Gerardo" <gerardo.molina.sabido@intel.com>
Tested-by: Zhimin Luo <zhimin.luo@intel.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
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
-- 
2.45.2

