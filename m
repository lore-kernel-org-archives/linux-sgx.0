Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9F1415575C;
	Tue, 24 Sep 2024 09:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727171856; cv=none; b=Y4RkW6ElzSy5q7IPVO9haNBYIFepZdv+Wrjf4TPqQgEPJVjtQlHswenDH3Tr59vYraWjn2wFgAfIk+f7ipTZ0iSnQqGK7sVFF0SUos5yxJaeoBimJOQwC/aqDSF2uzaJfXOW8ajh8aoLMtRnlEs0ESL6z8I881Yab/oJ2QaG9A4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727171856; c=relaxed/simple;
	bh=SP6yAJu8cEkpUWA+jBBF4vilyREKBuAzXaQSUMXdhwI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HR3RbAAl3VYtbqa9c0QQL2ghnCybzMTkUxX7GGGNvVKxk2Rng+/ajrk7GR1Y57lFSEiPiDO4j0cBQoiwkJ2qjItocMWUrxon7hHtNsEm8kJIDaZwTJLuW44n/tmfZNPhdsfcEOlNzwWzJK5JpAskgMq1zEYPeNwOo0uEqCnNonk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UnyaUWzb; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UnyaUWzb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727171855; x=1758707855;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SP6yAJu8cEkpUWA+jBBF4vilyREKBuAzXaQSUMXdhwI=;
  b=UnyaUWzbmRrpwHoD6fkwmak+XCW7V3ugxo8DSAh6K6vI1zVh4mrmUhSp
   ++pl7l8y5y//b9F4CtMJTxCRT3TdXtYFwDv8pXvmWHa5VZ7MgTCaLIbxU
   EJIhHDZr81gPjECCKMykEEuhM9Jb3KLJafGVuu1T9q0rbf1TpiMufFmqH
   yTTBkSIfckV/Jw4bvIC1R95ldt5hYvB+hvpyR1gNCjDzco5Hv6BlDQAjs
   jkgtXaOf4m/wSYhDRC764zaStxaSiyzj7l1FvjyoKPhwDgYjpPQKD8wKy
   1gfLVXqwYn+bFU0znL3OoehFfth5/aeIRB5Z3QN1swTzMlt53gHc9zltd
   A==;
X-CSE-ConnectionGUID: DckuSJnSSjyKXjPryz+dUA==
X-CSE-MsgGUID: 3sa6nCFXSreX9vKKmoukHw==
X-IronPort-AV: E=McAfee;i="6700,10204,11204"; a="30041616"
X-IronPort-AV: E=Sophos;i="6.10,254,1719903600"; 
   d="scan'208";a="30041616"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2024 02:57:31 -0700
X-CSE-ConnectionGUID: dRsYFNrRQ+i5xIBCHzJmvw==
X-CSE-MsgGUID: mPLL4hO7R/aYuXSMst1Kcg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,254,1719903600"; 
   d="scan'208";a="76143103"
Received: from mehlow-prequal01.jf.intel.com ([10.54.102.156])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2024 02:57:31 -0700
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
Subject: [PATCH v6 1/3] x86/sgx: Split SGX_ENCL_PAGE_BEING_RECLAIMED into two flags
Date: Tue, 24 Sep 2024 02:49:12 -0700
Message-Id: <20240924094914.3873462-2-dmitrii.kuvaiskii@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240924094914.3873462-1-dmitrii.kuvaiskii@intel.com>
References: <20240924094914.3873462-1-dmitrii.kuvaiskii@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Organization: Intel Deutschland GmbH - Registered Address: Am Campeon 10, 85579 Neubiberg, Germany
Content-Transfer-Encoding: 8bit

The page reclaimer thread sets SGX_ENC_PAGE_BEING_RECLAIMED flag when
the enclave page is being reclaimed (moved to the backing store). This
flag however has two logical meanings:

1. Don't attempt to load the enclave page (the page is busy), see
   __sgx_encl_load_page().
2. Don't attempt to remove the PCMD page corresponding to this enclave
   page (the PCMD page is busy), see reclaimer_writing_to_pcmd().

To reflect these two meanings, split SGX_ENCL_PAGE_BEING_RECLAIMED into
two flags: SGX_ENCL_PAGE_BUSY and SGX_ENCL_PAGE_PCMD_BUSY. Currently,
both flags are set only when the enclave page is being reclaimed (by the
page reclaimer thread). A future commit will introduce new cases when
the enclave page is being operated on; these new cases will set only the
SGX_ENCL_PAGE_BUSY flag.

Cc: stable@vger.kernel.org
Signed-off-by: Dmitrii Kuvaiskii <dmitrii.kuvaiskii@intel.com>
Reviewed-by: Haitao Huang <haitao.huang@linux.intel.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Acked-by: Kai Huang <kai.huang@intel.com>
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
index f94ff14c9486..b566b8ad5f33 100644
--- a/arch/x86/kernel/cpu/sgx/encl.h
+++ b/arch/x86/kernel/cpu/sgx/encl.h
@@ -22,8 +22,14 @@
 /* 'desc' bits holding the offset in the VA (version array) page. */
 #define SGX_ENCL_PAGE_VA_OFFSET_MASK	GENMASK_ULL(11, 3)
 
-/* 'desc' bit marking that the page is being reclaimed. */
-#define SGX_ENCL_PAGE_BEING_RECLAIMED	BIT(3)
+/* 'desc' bit indicating that the page is busy (being reclaimed). */
+#define SGX_ENCL_PAGE_BUSY	BIT(2)
+
+/*
+ * 'desc' bit indicating that PCMD page associated with the enclave page is
+ * busy (because the enclave page is being reclaimed).
+ */
+#define SGX_ENCL_PAGE_PCMD_BUSY	BIT(3)
 
 struct sgx_encl_page {
 	unsigned long desc;
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index f3f1461273ee..da59f034b769 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -205,7 +205,7 @@ static void sgx_encl_ewb(struct sgx_epc_page *epc_page,
 	void *va_slot;
 	int ret;
 
-	encl_page->desc &= ~SGX_ENCL_PAGE_BEING_RECLAIMED;
+	encl_page->desc &= ~(SGX_ENCL_PAGE_BUSY | SGX_ENCL_PAGE_PCMD_BUSY);
 
 	va_page = list_first_entry(&encl->va_pages, struct sgx_va_page,
 				   list);
@@ -341,7 +341,7 @@ static void sgx_reclaim_pages(void)
 			goto skip;
 		}
 
-		encl_page->desc |= SGX_ENCL_PAGE_BEING_RECLAIMED;
+		encl_page->desc |= SGX_ENCL_PAGE_BUSY | SGX_ENCL_PAGE_PCMD_BUSY;
 		mutex_unlock(&encl_page->encl->lock);
 		continue;
 
-- 
2.43.0

