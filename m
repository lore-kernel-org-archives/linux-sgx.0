Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D522A1442F0;
	Fri,  5 Jul 2024 07:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720166052; cv=none; b=hMlwSTomUxgVgh/3093j3MEFNtFt9gCWbmcD01jAAouNm9WOcX9la7Tr4udbQpCAcIhMVeNBKVL9B2Ngk3X8xNY3bxWVbaEnmfhKgVAbfZGtoxTjnm2MeQsNlAKgV/cQ+wSwkAdNFBKP7DgTML6aBPHO+ngxrbaWrkV32Vwin4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720166052; c=relaxed/simple;
	bh=5OWW7SNa0nNrp39nyTHhqkbfg5MVC6mu3/hAnCEpYZY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J+W5I6Lxodby/y4Mcbdrdx25RMb7gcNhN7NnTC/tFxcfJYZX97e3ZAzGkofNNhdLjL+B+433TJCCBxnB4sS9F01YsL/YfhdNXExws0a2L9LFNyUhGwG9Q/kAzp+qQ5/73XJ+xXZnyDG4Q1OrhRdeJsCpXAFI4ycwl8f8m03Hk4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q9MBxORM; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q9MBxORM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720166050; x=1751702050;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5OWW7SNa0nNrp39nyTHhqkbfg5MVC6mu3/hAnCEpYZY=;
  b=Q9MBxORMw82VN/Lfess9v17JoEj1HXwi+6JCc9HYKtgEAyefa0uWIFMF
   e7bqoW7AQ4mnd6ET6ZxGjX+lZFk/sTQ2rcfJPgcsT6yh5qOYZ+Xwfrj/e
   qjGPSYALWjNO1ZP4agXcruHYbjufXWlqcpOpfyrtTKvHjvxFlyOEo1jRh
   l80T44c0jKZ6L5GSnhKRnYlVYkmIBRAu9S8Nt9HopRHpza2HsgCuDrt+0
   xEMv/THzapN7Gu2Gdp9E3HNByUVBpiwMvbI5cR+aA5OCNF+G2ME02KGL8
   BGtVatGNxY2z40NyP9WQoKEaj+p4H2LDvZNFH33EeIV7afTz8a6Cig9/y
   Q==;
X-CSE-ConnectionGUID: 64zhLc5bSEy3pt7Zh/ND6Q==
X-CSE-MsgGUID: 8+ZXjVL5SWW+tRUKmO4MBA==
X-IronPort-AV: E=McAfee;i="6700,10204,11123"; a="34892875"
X-IronPort-AV: E=Sophos;i="6.09,184,1716274800"; 
   d="scan'208";a="34892875"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2024 00:53:42 -0700
X-CSE-ConnectionGUID: +dTIeSjVRxiOIrG7SjdfyA==
X-CSE-MsgGUID: biB6J1XATHeOSubFTzNVuQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,184,1716274800"; 
   d="scan'208";a="46918566"
Received: from mehlow-prequal01.jf.intel.com ([10.54.102.156])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2024 00:53:43 -0700
From: Dmitrii Kuvaiskii <dmitrii.kuvaiskii@intel.com>
To: dave.hansen@linux.intel.com,
	jarkko@kernel.org,
	kai.huang@intel.com,
	haitao.huang@linux.intel.com,
	reinette.chatre@intel.com,
	linux-sgx@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: mona.vij@intel.com,
	kailun.qin@intel.com,
	stable@vger.kernel.org
Subject: [PATCH v4 1/3] x86/sgx: Split SGX_ENCL_PAGE_BEING_RECLAIMED into two flags
Date: Fri,  5 Jul 2024 00:45:22 -0700
Message-Id: <20240705074524.443713-2-dmitrii.kuvaiskii@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240705074524.443713-1-dmitrii.kuvaiskii@intel.com>
References: <20240705074524.443713-1-dmitrii.kuvaiskii@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Organization: Intel Deutschland GmbH - Registered Address: Am Campeon 10, 85579 Neubiberg, Germany
Content-Transfer-Encoding: 8bit

SGX_ENCL_PAGE_BEING_RECLAIMED flag is set when the enclave page is being
reclaimed (moved to the backing store). This flag however has two
logical meanings:

1. Don't attempt to load the enclave page (the page is busy).
2. Don't attempt to remove the PCMD page corresponding to this enclave
   page (the PCMD page is busy).

To reflect these two meanings, split SGX_ENCL_PAGE_BEING_RECLAIMED into
two flags: SGX_ENCL_PAGE_BUSY and SGX_ENCL_PAGE_PCMD_BUSY. Currently,
both flags are set only when the enclave page is being reclaimed. A
future commit will introduce a new case when the enclave page is being
removed; this new case will set only the SGX_ENCL_PAGE_BUSY flag.

Cc: stable@vger.kernel.org
Signed-off-by: Dmitrii Kuvaiskii <dmitrii.kuvaiskii@intel.com>
---
 arch/x86/kernel/cpu/sgx/encl.c | 16 +++++++---------
 arch/x86/kernel/cpu/sgx/encl.h | 10 ++++++++--
 arch/x86/kernel/cpu/sgx/main.c |  4 ++--
 3 files changed, 17 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 279148e72459..c0a3c00284c8 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -46,10 +46,10 @@ static int sgx_encl_lookup_backing(struct sgx_encl *encl, unsigned long page_ind
  * a check if an enclave page sharing the PCMD page is in the process of being
  * reclaimed.
  *
- * The reclaimer sets the SGX_ENCL_PAGE_BEING_RECLAIMED flag when it
- * intends to reclaim that enclave page - it means that the PCMD page
- * associated with that enclave page is about to get some data and thus
- * even if the PCMD page is empty, it should not be truncated.
+ * The reclaimer sets the SGX_ENCL_PAGE_PCMD_BUSY flag when it intends to
+ * reclaim that enclave page - it means that the PCMD page associated with that
+ * enclave page is about to get some data and thus even if the PCMD page is
+ * empty, it should not be truncated.
  *
  * Context: Enclave mutex (&sgx_encl->lock) must be held.
  * Return: 1 if the reclaimer is about to write to the PCMD page
@@ -77,8 +77,7 @@ static int reclaimer_writing_to_pcmd(struct sgx_encl *encl,
 		 * Stop when reaching the SECS page - it does not
 		 * have a page_array entry and its reclaim is
 		 * started and completed with enclave mutex held so
-		 * it does not use the SGX_ENCL_PAGE_BEING_RECLAIMED
-		 * flag.
+		 * it does not use the SGX_ENCL_PAGE_PCMD_BUSY flag.
 		 */
 		if (addr == encl->base + encl->size)
 			break;
@@ -91,8 +90,7 @@ static int reclaimer_writing_to_pcmd(struct sgx_encl *encl,
 		 * VA page slot ID uses same bit as the flag so it is important
 		 * to ensure that the page is not already in backing store.
 		 */
-		if (entry->epc_page &&
-		    (entry->desc & SGX_ENCL_PAGE_BEING_RECLAIMED)) {
+		if (entry->epc_page && (entry->desc & SGX_ENCL_PAGE_PCMD_BUSY)) {
 			reclaimed = 1;
 			break;
 		}
@@ -257,7 +255,7 @@ static struct sgx_encl_page *__sgx_encl_load_page(struct sgx_encl *encl,
 
 	/* Entry successfully located. */
 	if (entry->epc_page) {
-		if (entry->desc & SGX_ENCL_PAGE_BEING_RECLAIMED)
+		if (entry->desc & SGX_ENCL_PAGE_BUSY)
 			return ERR_PTR(-EBUSY);
 
 		return entry;
diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
index f94ff14c9486..11b09899cd92 100644
--- a/arch/x86/kernel/cpu/sgx/encl.h
+++ b/arch/x86/kernel/cpu/sgx/encl.h
@@ -22,8 +22,14 @@
 /* 'desc' bits holding the offset in the VA (version array) page. */
 #define SGX_ENCL_PAGE_VA_OFFSET_MASK	GENMASK_ULL(11, 3)
 
-/* 'desc' bit marking that the page is being reclaimed. */
-#define SGX_ENCL_PAGE_BEING_RECLAIMED	BIT(3)
+/* 'desc' bit indicating that the page is busy (e.g. being reclaimed). */
+#define SGX_ENCL_PAGE_BUSY	BIT(2)
+
+/*
+ * 'desc' bit indicating that PCMD page associated with the enclave page is
+ * busy (e.g. because the enclave page is being reclaimed).
+ */
+#define SGX_ENCL_PAGE_PCMD_BUSY	BIT(3)
 
 struct sgx_encl_page {
 	unsigned long desc;
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 166692f2d501..e94b09c43673 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -204,7 +204,7 @@ static void sgx_encl_ewb(struct sgx_epc_page *epc_page,
 	void *va_slot;
 	int ret;
 
-	encl_page->desc &= ~SGX_ENCL_PAGE_BEING_RECLAIMED;
+	encl_page->desc &= ~(SGX_ENCL_PAGE_BUSY | SGX_ENCL_PAGE_PCMD_BUSY);
 
 	va_page = list_first_entry(&encl->va_pages, struct sgx_va_page,
 				   list);
@@ -340,7 +340,7 @@ static void sgx_reclaim_pages(void)
 			goto skip;
 		}
 
-		encl_page->desc |= SGX_ENCL_PAGE_BEING_RECLAIMED;
+		encl_page->desc |= SGX_ENCL_PAGE_BUSY | SGX_ENCL_PAGE_PCMD_BUSY;
 		mutex_unlock(&encl_page->encl->lock);
 		continue;
 
-- 
2.43.0

