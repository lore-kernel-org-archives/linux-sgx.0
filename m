Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5792E3C489;
	Fri, 17 May 2024 11:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715944497; cv=none; b=jbtLQhLw1NFX5sZvuq4FWo9QUSr5uzHeg/B4AIbII/xMj1gtgm53VfzmZImGSWTjkXcbV8XbgZPr3drOg4bPhEtgzzDKhNzpCkHYseoGBEkvg/0bLXYrvUbZ5o/oEFYFXzL5szbXQa6jbsbHJVNiYQwAW9xG1DcG1aYIArBzRVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715944497; c=relaxed/simple;
	bh=IPVHLXpO3BrKI/CM9d1gqnp5/8wq3scbDt0L3OmEGCc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jyh1gGlTGKW41m/oS9rnQCRpactIWI1Sco/Q/T9vi8GS5PmyYATPxoYbp9hhwQTJ7ZdUwEKZ7j4mA3kFnyXSDRWIYtFKptAURFG5X1M4nO3iimYflC/Ql7w47ZqQg6uurEAFLI2E0sVcLbZDHoLJRqTzfAGbUO2+HIGlIUAKPTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=H5dZnPZ9; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="H5dZnPZ9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715944495; x=1747480495;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IPVHLXpO3BrKI/CM9d1gqnp5/8wq3scbDt0L3OmEGCc=;
  b=H5dZnPZ9rT626v44OmNzp6byKWAMRnjFKiyaegbrp9YENzjBaVtcbIaf
   fHuetilKt+NIH7Yf6gjYXv2djfLxQ5eqPKGLe96fRyvwzNm/pXasLbhtR
   alCLozRXFcllY+uYGhtFfqbFYwfA8IRljH3tJIef+JOMXYNvQJlx7JeLJ
   E0BM53V3hMFTQqOoKERUAKR04HrlKgKtmyNBLR3EWXCMxoN163Y1U8Yig
   ZaOBDRvguhKtGFjW9JbENyMVcfVPW+l3IC1bUlP0rDyFai96gSl06vlOS
   RujcVu2y7TDwF5IG3hWOVqQp4+y7EJbvl58kK5A5WNT/5i0wOltejF0Z3
   A==;
X-CSE-ConnectionGUID: dPFaK5FsTYqt6BTBrK7adA==
X-CSE-MsgGUID: LcD7kwLDRq6h4Sq2C6AwHw==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="23529050"
X-IronPort-AV: E=Sophos;i="6.08,167,1712646000"; 
   d="scan'208";a="23529050"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2024 04:14:53 -0700
X-CSE-ConnectionGUID: pNdjN9jlR6ybx6Y7KweJbw==
X-CSE-MsgGUID: QK9YnTUsT/qnjDVMUEA58A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,167,1712646000"; 
   d="scan'208";a="36276850"
Received: from mehlow-prequal01.jf.intel.com ([10.54.102.156])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2024 04:14:52 -0700
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
	stable@vger.kernel.org,
	=?UTF-8?q?Marcelina=20Ko=C5=9Bcielnicka?= <mwk@invisiblethingslab.com>
Subject: [PATCH v3 1/2] x86/sgx: Resolve EAUG race where losing thread returns SIGBUS
Date: Fri, 17 May 2024 04:06:30 -0700
Message-Id: <20240517110631.3441817-2-dmitrii.kuvaiskii@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240517110631.3441817-1-dmitrii.kuvaiskii@intel.com>
References: <20240517110631.3441817-1-dmitrii.kuvaiskii@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Organization: Intel Deutschland GmbH - Registered Address: Am Campeon 10, 85579 Neubiberg, Germany
Content-Transfer-Encoding: 8bit

Imagine an mmap()'d file. Two threads touch the same address at the same
time and fault. Both allocate a physical page and race to install a PTE
for that page. Only one will win the race. The loser frees its page, but
still continues handling the fault as a success and returns
VM_FAULT_NOPAGE from the fault handler.

The same race can happen with SGX. But there's a bug: the loser in the
SGX steers into a failure path. The loser EREMOVE's the winner's EPC
page, then returns SIGBUS, likely killing the app.

Fix the SGX loser's behavior. Change the return code to VM_FAULT_NOPAGE
to avoid SIGBUS and call sgx_free_epc_page() which avoids EREMOVE'ing
the winner's page and only frees the page that the loser allocated.

The race can be illustrated as follows:

/*                             /*
 * Fault on CPU1                * Fault on CPU2
 * on enclave page X            * on enclave page X
 */                             */
sgx_vma_fault() {              sgx_vma_fault() {

  xa_load(&encl->page_array)     xa_load(&encl->page_array)
      == NULL -->                    == NULL -->

  sgx_encl_eaug_page() {         sgx_encl_eaug_page() {

    ...                            ...

    /*                             /*
     * alloc encl_page              * alloc encl_page
     */                             */
                                   mutex_lock(&encl->lock);
                                   /*
                                    * alloc EPC page
                                    */
                                   epc_page = sgx_alloc_epc_page(...);
                                   /*
                                    * add page to enclave's xarray
                                    */
                                   xa_insert(&encl->page_array, ...);
                                   /*
                                    * add page to enclave via EAUG
                                    * (page is in pending state)
                                    */
                                   /*
                                    * add PTE entry
                                    */
                                   vmf_insert_pfn(...);

                                   mutex_unlock(&encl->lock);
                                   return VM_FAULT_NOPAGE;
                                 }
                               }
                               /*
                                * All good up to here: enclave page
                                * successfully added to enclave,
                                * ready for EACCEPT from user space
                                */
    mutex_lock(&encl->lock);
    /*
     * alloc EPC page
     */
    epc_page = sgx_alloc_epc_page(...);
    /*
     * add page to enclave's xarray,
     * this fails with -EBUSY as this
     * page was already added by CPU2
     */
    xa_insert(&encl->page_array, ...);

  err_out_shrink:
    sgx_encl_free_epc_page(epc_page) {
      /*
       * remove page via EREMOVE
       *
       * *BUG*: page added by CPU2 is
       * yanked from enclave while it
       * remains accessible from OS
       * perspective (PTE installed)
       */
      /*
       * free EPC page
       */
      sgx_free_epc_page(epc_page);
    }

    mutex_unlock(&encl->lock);
    /*
     * *BUG*: SIGBUS is returned
     * for a valid enclave page
     */
    return VM_FAULT_SIGBUS;
  }
}

Fixes: 5a90d2c3f5ef ("x86/sgx: Support adding of pages to an initialized enclave")
Cc: stable@vger.kernel.org
Reported-by: Marcelina Kościelnicka <mwk@invisiblethingslab.com>
Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Dmitrii Kuvaiskii <dmitrii.kuvaiskii@intel.com>
Reviewed-by: Haitao Huang <haitao.huang@linux.intel.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
---
 arch/x86/kernel/cpu/sgx/encl.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 279148e72459..41f14b1a3025 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -382,8 +382,11 @@ static vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
 	 * If ret == -EBUSY then page was created in another flow while
 	 * running without encl->lock
 	 */
-	if (ret)
+	if (ret) {
+		if (ret == -EBUSY)
+			vmret = VM_FAULT_NOPAGE;
 		goto err_out_shrink;
+	}
 
 	pginfo.secs = (unsigned long)sgx_get_epc_virt_addr(encl->secs.epc_page);
 	pginfo.addr = encl_page->desc & PAGE_MASK;
@@ -419,7 +422,7 @@ static vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
 err_out_shrink:
 	sgx_encl_shrink(encl, va_page);
 err_out_epc:
-	sgx_encl_free_epc_page(epc_page);
+	sgx_free_epc_page(epc_page);
 err_out_unlock:
 	mutex_unlock(&encl->lock);
 	kfree(encl_page);
-- 
2.34.1

