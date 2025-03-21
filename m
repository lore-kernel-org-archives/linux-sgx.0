Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A1B22A80A;
	Fri, 21 Mar 2025 12:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742560814; cv=none; b=LMzKPvpSQ5qKRtHYmBrIW/MUXdXCk48EoJR4lcIrDn2WvhhORqtulEk6ZSNds/Bfo1/c+YcaaqpU+wF5FyKL/HMxCvIacKK1Bv2DKjHOOGzhqMnysLfC1Aid5xnCbB61Qrl3OJ9J8wqYTcwVpyGjvujI1H1dOefHHJacXDoszjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742560814; c=relaxed/simple;
	bh=hJQVXM2DEDqhdEg7uoYNzkT5c/SzZC7bbnFTR6JAZFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A5URCTLuZBnEGMYCytmmEDPUN3p0u/1TNVRCr7hLUd0mwnAppLjfj9t2d2DHl74jdsW3JnSCrW2fHTIkRSikSm3b6Wh1PmVgkrvWZCe9vK49AE07aiww+Z7LrRxpG+dhZIrF4Q2uTp0YKvdh8reJ4cqfKPhTLVyx5vKjecZpx/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GcGZ+XU3; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GcGZ+XU3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742560813; x=1774096813;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hJQVXM2DEDqhdEg7uoYNzkT5c/SzZC7bbnFTR6JAZFg=;
  b=GcGZ+XU3WDPp73Het3aM2Ydd4aoOnVZO1Ux32SHRT9Fibjg1ZC8QUu5m
   0Qd6zaC2f3FLfp+rKyGlhrDidu7hI6mF4a6p41DtPryTyK5D+j7DvxY3M
   QB25bNLT7UeDYVjF4hq7H25pBQ6FNejlm9g/YHsgiShcULG6sj/j1IIFV
   ETkr2ah0/MSBqF79Fin7GGp39oEZXuIYe35sbaBhMGp8ljwuNT2RsDOsi
   hgeW/TY6uay8v3l4+p2Y5rn+KHn6CqQipQMkax5LBOVnd6g8yLYV33nmN
   DExqDctYkzsssb6ZwvorR+WEQxe9jg4keFNpwu5tzklkAibaZ/96mBVGP
   Q==;
X-CSE-ConnectionGUID: RLwMwAY4T1uqrgIFI7xQRw==
X-CSE-MsgGUID: 8DHAwMn7QG6Ch1fb91ypNQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11380"; a="54493371"
X-IronPort-AV: E=Sophos;i="6.14,264,1736841600"; 
   d="scan'208";a="54493371"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2025 05:40:13 -0700
X-CSE-ConnectionGUID: M/7+f0hVQ9yHtUv2RD4/nw==
X-CSE-MsgGUID: c8x/SvWrTNG58ewLK9oMzg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,264,1736841600"; 
   d="scan'208";a="154399933"
Received: from mwiniars-desk2.ger.corp.intel.com (HELO eresheto-mobl3.ger.corp.intel.com) ([10.245.246.189])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2025 05:40:07 -0700
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
Subject: [PATCH 2/4] x86/sgx: Change counter sgx_nr_free_pages -> sgx_nr_used_pages
Date: Fri, 21 Mar 2025 14:34:41 +0200
Message-ID: <20250321123938.802763-3-elena.reshetova@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250321123938.802763-1-elena.reshetova@intel.com>
References: <20250321123938.802763-1-elena.reshetova@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

sgx_nr_free_pages is an atomic that is used to keep track of
free EPC pages and detect whenever page reclaiming should start.
Since successful execution of ENCLS[EUPDATESVN] requires empty
EPC and a fast way of checking for this, change this variable
around to indicate number of used pages instead. The subsequent
patch that introduces ENCLS[EUPDATESVN] will take use of this change.

No functional changes intended.

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
---
 arch/x86/kernel/cpu/sgx/main.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index d5df67dab247..b61d3bad0446 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -32,7 +32,7 @@ static DEFINE_XARRAY(sgx_epc_address_space);
 static LIST_HEAD(sgx_active_page_list);
 static DEFINE_SPINLOCK(sgx_reclaimer_lock);
 
-static atomic_long_t sgx_nr_free_pages = ATOMIC_LONG_INIT(0);
+static atomic_long_t sgx_nr_used_pages = ATOMIC_LONG_INIT(0);
 static unsigned long sgx_nr_total_pages;
 
 /* Nodes with one or more EPC sections. */
@@ -379,8 +379,8 @@ static void sgx_reclaim_pages(void)
 
 static bool sgx_should_reclaim(unsigned long watermark)
 {
-	return atomic_long_read(&sgx_nr_free_pages) < watermark &&
-	       !list_empty(&sgx_active_page_list);
+	return (sgx_nr_total_pages - atomic_long_read(&sgx_nr_used_pages))
+	       < watermark && !list_empty(&sgx_active_page_list);
 }
 
 /*
@@ -457,7 +457,7 @@ static struct sgx_epc_page *__sgx_alloc_epc_page_from_node(int nid)
 	page->flags = 0;
 
 	spin_unlock(&node->lock);
-	atomic_long_dec(&sgx_nr_free_pages);
+	atomic_long_inc(&sgx_nr_used_pages);
 
 	return page;
 }
@@ -617,7 +617,7 @@ void sgx_free_epc_page(struct sgx_epc_page *page)
 	page->flags = SGX_EPC_PAGE_IS_FREE;
 
 	spin_unlock(&node->lock);
-	atomic_long_inc(&sgx_nr_free_pages);
+	atomic_long_dec(&sgx_nr_used_pages);
 }
 
 static bool __init sgx_setup_epc_section(u64 phys_addr, u64 size,
@@ -851,6 +851,8 @@ static bool __init sgx_page_cache_init(void)
 		return false;
 	}
 
+	atomic_long_set(&sgx_nr_used_pages, sgx_nr_total_pages);
+
 	for_each_online_node(nid) {
 		if (!node_isset(nid, sgx_numa_mask) &&
 		    node_state(nid, N_MEMORY) && node_state(nid, N_CPU))
-- 
2.45.2

