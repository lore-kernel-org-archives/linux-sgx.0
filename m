Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F28C31990A1;
	Thu,  5 Sep 2024 08:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725523827; cv=none; b=bOAbbtnLwbH2oJtxdb3hadn43f+OAiUK+Rik8zQRzY6+WVPhbh+9Ntu+DiKvRPx+tzTKOdICf272hNyEMH2TghXFPBVDP4RkOp9Yvaa7Mty75wT4piXsO4flac98zCP0R4j/15ZB5aHVNNV6CBAieEBEdlylNcDLgkpzeRRcx0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725523827; c=relaxed/simple;
	bh=Hg7PUwZlg6hJI/buMhoiEz04trQq8SB8gVZgQ/RqHNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cWMmQaTPMr0YdnmyOVgXhgWHl+HmFejBKXCohgYFic45wYy7TLxtMaC2wTBtfMWUbNpDbnSp5u/cyDDQftFOHxKYvZih5Frl9RCqmAPMVy5jO7Yr5fLlopA2H1Hfef7IpA6fo+nyviFhwylTlqzDv436OcUDa6BL9V9lanU6Sfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OZsTXe0W; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OZsTXe0W"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725523826; x=1757059826;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Hg7PUwZlg6hJI/buMhoiEz04trQq8SB8gVZgQ/RqHNc=;
  b=OZsTXe0WLCCUL0BCrg2S0r05jg6w23miIiFCLBRAbRWhAH+4L279PCL7
   uJYor+8V2UNBfEqeyPpRhO08lOBotKHTTj6rI6N1y9IDg2j0PZvUWNrVu
   Mk2l8018ZFSVJJaArwjW1Kl3FIwgOFlQfl2B3zeMKt61dNjmsMEQp/oZ7
   iJg0iybFQvIICWL6xGj8S2PytqfbkVPwzPZYQ0tdLFstYL7+NZHofFEwk
   M53vRdMJE3Db8MPwpjF7tL681csI9yIkMqoKZzbs64vHyfF/VNkODntT2
   tdXCUE119SiczSx6/MMzexq/M77T/PLasEfTjyeVwZxk5zw+4KuUkjv2l
   g==;
X-CSE-ConnectionGUID: ZGYur42+TrePMcMapaJElg==
X-CSE-MsgGUID: aebuCRfjS1yk382PCzQU+g==
X-IronPort-AV: E=McAfee;i="6700,10204,11185"; a="24176537"
X-IronPort-AV: E=Sophos;i="6.10,204,1719903600"; 
   d="scan'208";a="24176537"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2024 01:10:26 -0700
X-CSE-ConnectionGUID: HpMlT+c+RYGNMTx4AIofCA==
X-CSE-MsgGUID: 79/k3Db2Q++sghJK5ZcDZQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,204,1719903600"; 
   d="scan'208";a="65528396"
Received: from ziqianlu-desk2.sh.intel.com ([10.239.159.54])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2024 01:10:24 -0700
From: Aaron Lu <aaron.lu@intel.com>
To: Jarkko Sakkinen <jarkko@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Kai Huang <kai.huang@intel.com>
Cc: "Molina Sabido, Gerardo" <gerardo.molina.sabido@intel.com>,
	Zhimin Luo <zhimin.luo@intel.com>,
	linux-sgx@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH v2 2/2] x86/sgx: Log information when a node lacks an EPC section
Date: Thu,  5 Sep 2024 16:08:55 +0800
Message-ID: <20240905080855.1699814-3-aaron.lu@intel.com>
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

For optimized performance, firmware typically distributes EPC sections
evenly across different NUMA nodes. However, there are scenarios where
a node may have both CPUs and memory but no EPC section configured. For
example, in an 8-socket system with a Sub-Numa-Cluster=2 setup, there
are a total of 16 nodes. Given that the maximum number of supported EPC
sections is 8, it is simply not feasible to assign one EPC section to
each node. This configuration is not incorrect - SGX will still operate
correctly; it is just not optimized from a NUMA standpoint.

For this reason, log a message when a node with both CPUs and memory
lacks an EPC section. This will provide users with a hint as to why they
might be experiencing less-than-ideal performance when running SGX
enclaves.

Suggested-by: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 arch/x86/kernel/cpu/sgx/main.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 694fcf7a5e3a..3a79105455f1 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -848,6 +848,13 @@ static bool __init sgx_page_cache_init(void)
 		return false;
 	}
 
+	for_each_online_node(nid) {
+		if (!node_isset(nid, sgx_numa_mask) &&
+		    node_state(nid, N_MEMORY) && node_state(nid, N_CPU))
+			pr_info("node%d has both CPUs and memory but doesn't have an EPC section\n",
+				nid);
+	}
+
 	return true;
 }
 
-- 
2.45.2

