Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A21B43CF74;
	Fri, 17 May 2024 11:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715944497; cv=none; b=QdxUWattYV/lb/TWiUjC6jTIVjJVFQ2P4gKJKo/RDMd6P3TlBK+RUh6bvswcpufebjZA0L+BmNdRvsXhxm9vVTwss9QDdP22rm1bCQ8bxGdV5BjD/Ac7oyzpGWsldE7H7Y3l1CKdWRmoREQFPwjmK+DR/L1fJIGfWyUbeSmF4gY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715944497; c=relaxed/simple;
	bh=1AQLw6XT3mnToBpQL/o4G4Pk3fxWO0mx5XkrE9JobhA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=crvb/5CwEdyzuHs675+hLBpUXn3VjToy7qlSbRwA2ORm5Jj2s8czeTMGnYrkE16zZkIJ3d9Kwo7MHJ9p0u9V8cDMhvkDUjIn56a4MWOAIgv9OOmuD0Imw0PpDHfM3rytYx4UZZmihaO4bnCLJGqlLx7M+yHLl/Ip5nXiNlb5ZCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lIo0Tb0L; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lIo0Tb0L"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715944496; x=1747480496;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1AQLw6XT3mnToBpQL/o4G4Pk3fxWO0mx5XkrE9JobhA=;
  b=lIo0Tb0L0/Kmn7E8aRwBJqYhP5KbwAJznHOEgQI+w7YrNVEZaqBp+lKr
   Jj8YWN2wjkf6eMPODUhpa2/hFrAmV6+3bq1I48lvFThdnYtF63TSufq7t
   KjZ39yVjSjHepiFSl/CmMqEy6SMwrueCRngkgp3O7i++n/Yvuq9v6ByXD
   /Tt0VrddSu08TzvlQoKdKQaDZSPVJeb8lkbuSgl30udZm79EowZMkoF/6
   Ytu67HHqeLCfhmNsFU1CFPJHmnkYPUhJxDbK0h3B0IelGS2M+qrL9PeYX
   qZY0kTjNm726qE2F3zmw2Zo/Xd5S/MtbNh7yh2hi33nh4njFRBUVymwjE
   w==;
X-CSE-ConnectionGUID: OOOJuRTITCCTyuKiqo03pQ==
X-CSE-MsgGUID: 8VA6o41+S3aPVCZyZ8/n2A==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="23529054"
X-IronPort-AV: E=Sophos;i="6.08,167,1712646000"; 
   d="scan'208";a="23529054"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2024 04:14:53 -0700
X-CSE-ConnectionGUID: K64C8VC5RVC4zLZwfkX8uA==
X-CSE-MsgGUID: cJfoyT6TQLO2nbliraKaQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,167,1712646000"; 
   d="scan'208";a="36276853"
Received: from mehlow-prequal01.jf.intel.com ([10.54.102.156])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2024 04:14:53 -0700
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
Subject: [PATCH v3 2/2] x86/sgx: Resolve EREMOVE page vs EAUG page data race
Date: Fri, 17 May 2024 04:06:31 -0700
Message-Id: <20240517110631.3441817-3-dmitrii.kuvaiskii@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240517110631.3441817-1-dmitrii.kuvaiskii@intel.com>
References: <20240517110631.3441817-1-dmitrii.kuvaiskii@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
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
introducing a new flag SGX_ENCL_PAGE_BEING_REMOVED, which is unset by
default and set only right-before the first mutex_unlock() in
sgx_encl_remove_pages(). Upon loading the page, CPU2 checks whether this
page is being removed, and if yes then CPU2 backs off and waits until
the page is completely removed. After that, any memory access to this
page results in a normal "allocate and EAUG a page on #PF" flow.

Fixes: 9849bb27152c ("x86/sgx: Support complete page removal")
Cc: stable@vger.kernel.org
Signed-off-by: Dmitrii Kuvaiskii <dmitrii.kuvaiskii@intel.com>
Reviewed-by: Haitao Huang <haitao.huang@linux.intel.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Acked-by: Reinette Chatre <reinette.chatre@intel.com>
---
 arch/x86/kernel/cpu/sgx/encl.c  | 3 ++-
 arch/x86/kernel/cpu/sgx/encl.h  | 3 +++
 arch/x86/kernel/cpu/sgx/ioctl.c | 1 +
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 41f14b1a3025..7ccd8b2fce5f 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -257,7 +257,8 @@ static struct sgx_encl_page *__sgx_encl_load_page(struct sgx_encl *encl,
 
 	/* Entry successfully located. */
 	if (entry->epc_page) {
-		if (entry->desc & SGX_ENCL_PAGE_BEING_RECLAIMED)
+		if (entry->desc & (SGX_ENCL_PAGE_BEING_RECLAIMED |
+				   SGX_ENCL_PAGE_BEING_REMOVED))
 			return ERR_PTR(-EBUSY);
 
 		return entry;
diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
index f94ff14c9486..fff5f2293ae7 100644
--- a/arch/x86/kernel/cpu/sgx/encl.h
+++ b/arch/x86/kernel/cpu/sgx/encl.h
@@ -25,6 +25,9 @@
 /* 'desc' bit marking that the page is being reclaimed. */
 #define SGX_ENCL_PAGE_BEING_RECLAIMED	BIT(3)
 
+/* 'desc' bit marking that the page is being removed. */
+#define SGX_ENCL_PAGE_BEING_REMOVED	BIT(2)
+
 struct sgx_encl_page {
 	unsigned long desc;
 	unsigned long vm_max_prot_bits:8;
diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 5d390df21440..de59219ae794 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -1142,6 +1142,7 @@ static long sgx_encl_remove_pages(struct sgx_encl *encl,
 		 * Do not keep encl->lock because of dependency on
 		 * mmap_lock acquired in sgx_zap_enclave_ptes().
 		 */
+		entry->desc |= SGX_ENCL_PAGE_BEING_REMOVED;
 		mutex_unlock(&encl->lock);
 
 		sgx_zap_enclave_ptes(encl, addr);
-- 
2.34.1

