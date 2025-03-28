Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0EE01B5EA4;
	Fri, 28 Mar 2025 12:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743166766; cv=none; b=KEGbIseqmNY8K8o1aKVLfy82JGJwtvDLpfIbvwbYv3aTug0SI9XfKc64kmaXo/8b/oVieJ/a92o5SfhmVXyy/AU+gbiEUabl+s/g+WYqV+ZjmbF+tWE0kOrdxkogVHZckLV4E+Dqkj13Md1MXz6YXIKvW2qeil2mjhq6LO6gbIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743166766; c=relaxed/simple;
	bh=R5kGg1zx/kMXvSooMDzD+NGpVHcFbXL2ru+kAlccJJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZK/fEbG/kE3UqkGs9hP12guuBuEDFxVmagK0Zkx9eV4WdIoh1F8rMz8jIheqTvnJIeKQL2zGfeTDMOZfx6fmdZGoK2b3rsLeyU4zhjWmONlH8Y7ShT15jMHdzWm+uTsK6k882lkzcFec8666EYlkD7lGJsLPiJv3jGd9KrHDqEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=NtugThKU; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="NtugThKU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743166765; x=1774702765;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=R5kGg1zx/kMXvSooMDzD+NGpVHcFbXL2ru+kAlccJJY=;
  b=NtugThKUwTd2kYh2hhH7+F0LYC+vRkdaYAaC9dU23PQ8Majd9ZcXDMp9
   3H0LUrniKw0lLPqIeoXJWfAMmeFiHl/7KLN229nIDUGGps63YTH0ogRdP
   iTuOSyFvAn1SOjtpeLf2Ox9r2LyhKaBR4wX4oBjJo/7/l4qDxlTgm5/5j
   9azjhHVnwK6foItCSeKNjvnIKPkqRq8IAPyQ+FeRhI6V1Whg4iezbE4bN
   fs0WjAL4+XIZFXpWupJ+9amzLdAenbvHO5YjUjkWDwJ79T9virjfg0HsZ
   D0t5zlY+TZxmJybsAJ0zbGlFKyRk4dyLb1psMYj6LJ8d0925DMM9RPTmT
   w==;
X-CSE-ConnectionGUID: XMEitTzES7e6QFlr4q+X1A==
X-CSE-MsgGUID: 3np81NNaTmaJd+mFJxeeeQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11387"; a="44420676"
X-IronPort-AV: E=Sophos;i="6.14,283,1736841600"; 
   d="scan'208";a="44420676"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2025 05:59:25 -0700
X-CSE-ConnectionGUID: 40Zt4KclRNm6O5M98zDi9A==
X-CSE-MsgGUID: WgqlVSYLTyO3dw8QMLzTTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,283,1736841600"; 
   d="scan'208";a="125341398"
Received: from lfiedoro-mobl.ger.corp.intel.com (HELO eresheto-mobl3.ger.corp.intel.com) ([10.245.246.104])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2025 05:59:19 -0700
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
Subject: [PATCH v2 1/2] x86/sgx: Use sgx_nr_used_pages for EPC page count instead of sgx_nr_free_pages
Date: Fri, 28 Mar 2025 14:57:40 +0200
Message-ID: <20250328125859.73803-2-elena.reshetova@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250328125859.73803-1-elena.reshetova@intel.com>
References: <20250328125859.73803-1-elena.reshetova@intel.com>
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

