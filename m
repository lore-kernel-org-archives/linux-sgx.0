Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A49FA20E8BC;
	Wed, 21 Aug 2024 10:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724235038; cv=none; b=FsxP0sAzoXcfAXkcs19cFtxcruU6KmXLjLJ7JlV9SHFofn1nQRJBlhP+LrsbMc4fCpb5EGmWM365tDLiLDXi/qvKGass92BaciOMvOgMp3zVC+0nj22PyW8Jz7UYWnsHQLfnCRWb/ZXGnMpW7VkEBEuxOLNZBX98nZOXs+VZT/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724235038; c=relaxed/simple;
	bh=hTtmGiR+l39MEwJWqeWC4bH94A1/LO80Z8ODXn4N4T4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UBwHZlWTZEIgI6nG6Be2hIP3/ROSKwdbHklENnpLNj3uI1/tGQqE+9mhy9qxIb8xDBDu4yrSuB6J3aY9BOKYpK1B7ta9CeaEXQll/7O+2+0NQc2OEFNd7SWZ3cEJk3lMQ/FW3d5lX2FJohXvtbm4/UVNKhFjPKa/sWHsigvJwl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SjV9TUKE; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SjV9TUKE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724235036; x=1755771036;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hTtmGiR+l39MEwJWqeWC4bH94A1/LO80Z8ODXn4N4T4=;
  b=SjV9TUKE023yyDBXQoR0H/q6zpC4wM0OElkr9grnUDg3cf7f647KMuhZ
   8CUah8qtK2CqA7dxV4N2U8FrpMQe76l609L2h5gvBBgSfgT6XbPmib6Lw
   SPGy0DA1C74l4URO0yMQDvBR0JvflGxnSQGf0xwlXfAQXqCOw0xLLQmfb
   1VeSvEjwGKgOq8cr/2KWRUKTKk0ERK9UyW9giVZOIWbQP2YVJX7fnkdfx
   raciz9aduEPVJQTfzJST7gZFjmbb2c/KCFCCeQaD1/DwS7EjfPTueLphu
   8Nb4gYJinGaywnfhCmJKqY4Y5mfD8Z7/99uaF9CUSSIwBdjd2EaeS6g8b
   w==;
X-CSE-ConnectionGUID: zSSv9Kb3RvyN0Duelc9fCQ==
X-CSE-MsgGUID: 0caYYtsISOeJuLyC8sDJOA==
X-IronPort-AV: E=McAfee;i="6700,10204,11170"; a="33203657"
X-IronPort-AV: E=Sophos;i="6.10,164,1719903600"; 
   d="scan'208";a="33203657"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2024 03:10:31 -0700
X-CSE-ConnectionGUID: gZ4HhtCeTyumMwSE2PqkkA==
X-CSE-MsgGUID: WFIftu52S1uFxe9B7fHsYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,164,1719903600"; 
   d="scan'208";a="61353157"
Received: from mehlow-prequal01.jf.intel.com ([10.54.102.156])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2024 03:10:31 -0700
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
Subject: [PATCH v5 3/3] x86/sgx: Resolve EREMOVE page vs EAUG page data race
Date: Wed, 21 Aug 2024 03:02:15 -0700
Message-Id: <20240821100215.4119457-4-dmitrii.kuvaiskii@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240821100215.4119457-1-dmitrii.kuvaiskii@intel.com>
References: <20240821100215.4119457-1-dmitrii.kuvaiskii@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Organization: Intel Deutschland GmbH - Registered Address: Am Campeon 10, 85579 Neubiberg, Germany
Content-Transfer-Encoding: 8bit

Two enclave threads may try to add and remove the same enclave page
simultaneously (e.g., if the SGX runtime supports both lazy allocation
and MADV_DONTNEED semantics). Consider some enclave page added to the
enclave. User space decides to temporarily remove this page (e.g.,
emulating the MADV_DONTNEED semantics) on CPU1. At the same time, user
space performs a memory access on the same page on CPU2, which results
in a #PF and ultimately in sgx_vma_fault(). Scenario proceeds as
follows:

/*
 * CPU1: User space performs
 * ioctl(SGX_IOC_ENCLAVE_REMOVE_PAGES)
 * on enclave page X
 */
sgx_encl_remove_pages() {

  mutex_lock(&encl->lock);

  entry = sgx_encl_load_page(encl);
  /*
   * verify that page is
   * trimmed and accepted
   */

  mutex_unlock(&encl->lock);

  /*
   * remove PTE entry; cannot
   * be performed under lock
   */
  sgx_zap_enclave_ptes(encl);
                                 /*
                                  * Fault on CPU2 on same page X
                                  */
                                 sgx_vma_fault() {
                                   /*
                                    * PTE entry was removed, but the
                                    * page is still in enclave's xarray
                                    */
                                   xa_load(&encl->page_array) != NULL ->
                                   /*
                                    * SGX driver thinks that this page
                                    * was swapped out and loads it
                                    */
                                   mutex_lock(&encl->lock);
                                   /*
                                    * this is effectively a no-op
                                    */
                                   entry = sgx_encl_load_page_in_vma();
                                   /*
                                    * add PTE entry
                                    *
                                    * *BUG*: a PTE is installed for a
                                    * page in process of being removed
                                    */
                                   vmf_insert_pfn(...);

                                   mutex_unlock(&encl->lock);
                                   return VM_FAULT_NOPAGE;
                                 }
  /*
   * continue with page removal
   */
  mutex_lock(&encl->lock);

  sgx_encl_free_epc_page(epc_page) {
    /*
     * remove page via EREMOVE
     */
    /*
     * free EPC page
     */
    sgx_free_epc_page(epc_page);
  }

  xa_erase(&encl->page_array);

  mutex_unlock(&encl->lock);
}

Here, CPU1 removed the page. However CPU2 installed the PTE entry on the
same page. This enclave page becomes perpetually inaccessible (until
another SGX_IOC_ENCLAVE_REMOVE_PAGES ioctl). This is because the page is
marked accessible in the PTE entry but is not EAUGed, and any subsequent
access to this page raises a fault: with the kernel believing there to
be a valid VMA, the unlikely error code X86_PF_SGX encountered by code
path do_user_addr_fault() -> access_error() causes the SGX driver's
sgx_vma_fault() to be skipped and user space receives a SIGSEGV instead.
The userspace SIGSEGV handler cannot perform EACCEPT because the page
was not EAUGed. Thus, the user space is stuck with the inaccessible
page.

Fix this race by forcing the fault handler on CPU2 to back off if the
page is currently being removed (on CPU1). This is achieved by
setting SGX_ENCL_PAGE_BUSY flag right-before the first mutex_unlock() in
sgx_encl_remove_pages(). Upon loading the page, CPU2 checks whether this
page is busy, and if yes then CPU2 backs off and waits until the page is
completely removed. After that, any memory access to this page results
in a normal "allocate and EAUG a page on #PF" flow.

Additionally fix a similar race: user space converts a normal enclave
page to a TCS page (via SGX_IOC_ENCLAVE_MODIFY_TYPES) on CPU1, and at
the same time, user space performs a memory access on the same page on
CPU2. This fix is not strictly necessary (this particular race would
indicate a bug in a user space application), but it gives a consistent
rule: if an enclave page is under certain operation by the kernel with
the mapping removed, then other threads trying to access that page are
temporarily blocked and should retry.

Fixes: 9849bb27152c ("x86/sgx: Support complete page removal")
Cc: stable@vger.kernel.org
Signed-off-by: Dmitrii Kuvaiskii <dmitrii.kuvaiskii@intel.com>
---
 arch/x86/kernel/cpu/sgx/encl.h  |  3 ++-
 arch/x86/kernel/cpu/sgx/ioctl.c | 17 +++++++++++++++++
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
index b566b8ad5f33..96b11e8fb770 100644
--- a/arch/x86/kernel/cpu/sgx/encl.h
+++ b/arch/x86/kernel/cpu/sgx/encl.h
@@ -22,7 +22,8 @@
 /* 'desc' bits holding the offset in the VA (version array) page. */
 #define SGX_ENCL_PAGE_VA_OFFSET_MASK	GENMASK_ULL(11, 3)
 
-/* 'desc' bit indicating that the page is busy (being reclaimed). */
+/* 'desc' bit indicating that the page is busy (being reclaimed, removed or
+ * converted to a TCS page). */
 #define SGX_ENCL_PAGE_BUSY	BIT(2)
 
 /*
diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 5d390df21440..ee619f2b3414 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -969,12 +969,22 @@ static long sgx_enclave_modify_types(struct sgx_encl *encl,
 			/*
 			 * Do not keep encl->lock because of dependency on
 			 * mmap_lock acquired in sgx_zap_enclave_ptes().
+			 *
+			 * Releasing encl->lock leads to a data race: while CPU1
+			 * performs sgx_zap_enclave_ptes() and removes the PTE
+			 * entry for the enclave page, CPU2 may attempt to load
+			 * this page (because the page is still in enclave's
+			 * xarray). To prevent CPU2 from loading the page, mark
+			 * the page as busy before unlock and unmark after lock
+			 * again.
 			 */
+			entry->desc |= SGX_ENCL_PAGE_BUSY;
 			mutex_unlock(&encl->lock);
 
 			sgx_zap_enclave_ptes(encl, addr);
 
 			mutex_lock(&encl->lock);
+			entry->desc &= ~SGX_ENCL_PAGE_BUSY;
 
 			sgx_mark_page_reclaimable(entry->epc_page);
 		}
@@ -1141,7 +1151,14 @@ static long sgx_encl_remove_pages(struct sgx_encl *encl,
 		/*
 		 * Do not keep encl->lock because of dependency on
 		 * mmap_lock acquired in sgx_zap_enclave_ptes().
+		 *
+		 * Releasing encl->lock leads to a data race: while CPU1
+		 * performs sgx_zap_enclave_ptes() and removes the PTE entry
+		 * for the enclave page, CPU2 may attempt to load this page
+		 * (because the page is still in enclave's xarray). To prevent
+		 * CPU2 from loading the page, mark the page as busy.
 		 */
+		entry->desc |= SGX_ENCL_PAGE_BUSY;
 		mutex_unlock(&encl->lock);
 
 		sgx_zap_enclave_ptes(encl, addr);
-- 
2.43.0

