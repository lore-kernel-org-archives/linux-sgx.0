Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A109292915;
	Tue, 15 Apr 2025 11:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744718024; cv=none; b=sHBlH7UufRawP4NQR49kn5FpdI/OLgRYT52VcI8mVONhmbrsfDwtjiCb4xFM7q6bUHmyYL/RnBbql8nkU6OxSDaXJkMx4OWc4Bsfof5lILOKZONO2nzB9tk/1gFwC4NPFoa61UF18zbt06DqsXIHmMhyJVmXFkWQUaTwMpFLlG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744718024; c=relaxed/simple;
	bh=R5kGg1zx/kMXvSooMDzD+NGpVHcFbXL2ru+kAlccJJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pC/9FqMAMhrsZEzJCWg0bVSNd4k6av4T9qHIe9/bqxAM++PeM+5VyNXAur5FsRGUZ05BxkXpP3jjBGA1SjtURhkF4XoFo41Q2FN936qFtAZFeoltXYzpj4h0rGe3O91dRujeonS9sx/fGS4CG5JbzG3UUbOsOwt195Q2fvrsDHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=N7kC90te; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="N7kC90te"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744718023; x=1776254023;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=R5kGg1zx/kMXvSooMDzD+NGpVHcFbXL2ru+kAlccJJY=;
  b=N7kC90teJUJQvtpSOtZlsHi6B2nhpWFw+V19Ya/xvF8FQWh/Ml2L0A1G
   +JjDmxyYG0ENU5SkDJcK7S/r2o5yb4mRCR28orupMgJcgbvbf2igY34v9
   xERb1fs8tntDXql1HyG6uHDcNEp4pIIFidNHQNCSGM2bXnsV7Jd1aVVAt
   FeyLwRYSX+W+kkRlK1tFvt4b30ZKPXqhZBm8Qna5hHgx1VXmX78P/expB
   3e4vg/HKWa9u4VUnUGD+KP9+CD4aBey38aJad4d8FTXuaMZxFlmYcfUsH
   0zRoVfWy0qkeioAbDPHPX2jT6qFYpqSt1uVWhw3IMVK3C0iozxEsfZbpi
   A==;
X-CSE-ConnectionGUID: 3OaUvNH/Rpax6K1f9b9s7w==
X-CSE-MsgGUID: HUfAzPF2TwShbnJJFkjO+g==
X-IronPort-AV: E=McAfee;i="6700,10204,11403"; a="46235108"
X-IronPort-AV: E=Sophos;i="6.15,213,1739865600"; 
   d="scan'208";a="46235108"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2025 04:52:38 -0700
X-CSE-ConnectionGUID: cw4Kj0PmTwSYcWgWQssiaQ==
X-CSE-MsgGUID: hSTnOcAfRuKAIuCJIffHRA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,213,1739865600"; 
   d="scan'208";a="130997575"
Received: from bergbenj-mobl1.ger.corp.intel.com (HELO eresheto-mobl3.ger.corp.intel.com) ([10.245.246.46])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2025 04:52:32 -0700
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
Subject: [PATCH v3 1/2] x86/sgx: Use sgx_nr_used_pages for EPC page count instead of sgx_nr_free_pages
Date: Tue, 15 Apr 2025 14:51:21 +0300
Message-ID: <20250415115213.291449-2-elena.reshetova@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250415115213.291449-1-elena.reshetova@intel.com>
References: <20250415115213.291449-1-elena.reshetova@intel.com>
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
EPC and preferably a fast lockless way of checking for this
condition in all code paths where EPC is already used, change the
reclaiming code to track the number of used pages via
sgx_nr_used_pages instead of sgx_nr_free_pages.
For this change to work in the page reclamation code, add a new
variable, sgx_nr_total_pages, that will keep track of total
number of EPC pages.

It would have been possible to implement ENCLS[EUPDATESVN] using
existing sgx_nr_free_pages counter and a new sgx_nr_total_pages
counter, but it won't be possible to avoid taking a lock *every time*
a new EPC page is being allocated. The conversion of sgx_nr_free_pages
into sgx_nr_used_pages allows avoiding the lock in all cases except
when it is the first EPC page being allocated via a quick
atomic_long_inc_not_zero check.

Note: The serialization for sgx_nr_total_pages is not needed because
the variable is only updated during the initialization and there's no
concurrent access.

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
---
 arch/x86/kernel/cpu/sgx/main.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 8ce352fc72ac..b61d3bad0446 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -32,7 +32,8 @@ static DEFINE_XARRAY(sgx_epc_address_space);
 static LIST_HEAD(sgx_active_page_list);
 static DEFINE_SPINLOCK(sgx_reclaimer_lock);
 
-static atomic_long_t sgx_nr_free_pages = ATOMIC_LONG_INIT(0);
+static atomic_long_t sgx_nr_used_pages = ATOMIC_LONG_INIT(0);
+static unsigned long sgx_nr_total_pages;
 
 /* Nodes with one or more EPC sections. */
 static nodemask_t sgx_numa_mask;
@@ -378,8 +379,8 @@ static void sgx_reclaim_pages(void)
 
 static bool sgx_should_reclaim(unsigned long watermark)
 {
-	return atomic_long_read(&sgx_nr_free_pages) < watermark &&
-	       !list_empty(&sgx_active_page_list);
+	return (sgx_nr_total_pages - atomic_long_read(&sgx_nr_used_pages))
+	       < watermark && !list_empty(&sgx_active_page_list);
 }
 
 /*
@@ -456,7 +457,7 @@ static struct sgx_epc_page *__sgx_alloc_epc_page_from_node(int nid)
 	page->flags = 0;
 
 	spin_unlock(&node->lock);
-	atomic_long_dec(&sgx_nr_free_pages);
+	atomic_long_inc(&sgx_nr_used_pages);
 
 	return page;
 }
@@ -616,7 +617,7 @@ void sgx_free_epc_page(struct sgx_epc_page *page)
 	page->flags = SGX_EPC_PAGE_IS_FREE;
 
 	spin_unlock(&node->lock);
-	atomic_long_inc(&sgx_nr_free_pages);
+	atomic_long_dec(&sgx_nr_used_pages);
 }
 
 static bool __init sgx_setup_epc_section(u64 phys_addr, u64 size,
@@ -648,6 +649,8 @@ static bool __init sgx_setup_epc_section(u64 phys_addr, u64 size,
 		list_add_tail(&section->pages[i].list, &sgx_dirty_page_list);
 	}
 
+	sgx_nr_total_pages += nr_pages;
+
 	return true;
 }
 
@@ -848,6 +851,8 @@ static bool __init sgx_page_cache_init(void)
 		return false;
 	}
 
+	atomic_long_set(&sgx_nr_used_pages, sgx_nr_total_pages);
+
 	for_each_online_node(nid) {
 		if (!node_isset(nid, sgx_numa_mask) &&
 		    node_state(nid, N_MEMORY) && node_state(nid, N_CPU))
-- 
2.45.2

