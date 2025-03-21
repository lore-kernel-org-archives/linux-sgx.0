Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1572227EB9;
	Fri, 21 Mar 2025 12:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742560811; cv=none; b=BUeFx+ZaJaYDXnfS1tToQW/pcJKhU4lkBRa9jILmzCnB3dNRJ7KCZ1Ji/8DZ0yFnvgRzBgHuqv5YttZ7DoVgynZyQoMbc3CQ5YvhIGiOwtCWKCWl6odOWRDnhzwjioKm/3XIl/NSaEAY+PRv1kAzhJM+6mji+hVvU8wUajcN4gY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742560811; c=relaxed/simple;
	bh=IOAEwjuwvTpvoDmLfJpU5w8aRyAfTgo3wIPPZaP8nzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ExfSukyrardUy6mqKxIox/gBBNJVvaWm+L4Drg9BIpHDcdp20gYlUVolt64e3edufUVRRwjvl8XVJm2ZFvdci6jQpVtH+glA9W5aIvSSjS9ja+3GegnHxF2QhWrmSnFgn2jHfvE1M9Kt9ubzUJhKcaJwqndCcHbbMfmnBldioDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cRfKZUyz; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cRfKZUyz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742560810; x=1774096810;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IOAEwjuwvTpvoDmLfJpU5w8aRyAfTgo3wIPPZaP8nzY=;
  b=cRfKZUyznORvfV64SHBAHG2EEWXsiqta0tOrlP8Bv0cjC118c2HvEq1r
   dDBLdTxZAWes5m9uBM8zaslDAk5HGtYuLsjTiqTr7HWnq0txV6GpBNXZ5
   CsDI72dKaia4QSBdmDWigZJVc1Pylu6ylLBq7N/eSiXKz/ozYONoremIQ
   gqHuH7IsHIxtGC9R3Yv/1Fuen1yGlq+Zlzbd5g6yAOK07DO7xbgeAVyRV
   O+o7UwR8F2aTcGiMjEk0HHTIyEN+VTEaG1s8MJsurMB9gpygkdRe5KJm5
   mDYRQFuqU4m2pEdPKCsp0ScJcxLKfjZ79AouyPih+bRW4qFDAtxOgQEG8
   A==;
X-CSE-ConnectionGUID: IXJcEfcaQES6OSfK2Qd1uw==
X-CSE-MsgGUID: 1ZEAvkM5QyG4Pf3M2CxwDA==
X-IronPort-AV: E=McAfee;i="6700,10204,11380"; a="54493358"
X-IronPort-AV: E=Sophos;i="6.14,264,1736841600"; 
   d="scan'208";a="54493358"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2025 05:40:09 -0700
X-CSE-ConnectionGUID: 9MORaErLQsGFzIeODt8paA==
X-CSE-MsgGUID: TIhiP0ayTJOAKcJRFWKc5w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,264,1736841600"; 
   d="scan'208";a="154399906"
Received: from mwiniars-desk2.ger.corp.intel.com (HELO eresheto-mobl3.ger.corp.intel.com) ([10.245.246.189])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2025 05:39:59 -0700
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
Subject: [PATCH 1/4] x86/sgx: Add total number of EPC pages
Date: Fri, 21 Mar 2025 14:34:40 +0200
Message-ID: <20250321123938.802763-2-elena.reshetova@intel.com>
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

In order to successfully execute ENCLS[EUPDATESVN], EPC must be empty.
SGX already has a variable sgx_nr_free_pages that tracks free
EPC pages. Add a new variable, sgx_nr_total_pages, that will keep
track of total number of EPC pages. It will be used in subsequent
patch to change the sgx_nr_free_pages into sgx_nr_used_pages and
allow an easy check for an empty EPC.

Note: The serialization for sgx_nr_total_pages is not needed because
the variable is only updated during the initialization and there's no
concurrent access.

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
---
 arch/x86/kernel/cpu/sgx/main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 8ce352fc72ac..d5df67dab247 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -33,6 +33,7 @@ static LIST_HEAD(sgx_active_page_list);
 static DEFINE_SPINLOCK(sgx_reclaimer_lock);
 
 static atomic_long_t sgx_nr_free_pages = ATOMIC_LONG_INIT(0);
+static unsigned long sgx_nr_total_pages;
 
 /* Nodes with one or more EPC sections. */
 static nodemask_t sgx_numa_mask;
@@ -648,6 +649,8 @@ static bool __init sgx_setup_epc_section(u64 phys_addr, u64 size,
 		list_add_tail(&section->pages[i].list, &sgx_dirty_page_list);
 	}
 
+	sgx_nr_total_pages += nr_pages;
+
 	return true;
 }
 
-- 
2.45.2

