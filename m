Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B515E8594A;
	Wed, 15 May 2024 13:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715779274; cv=none; b=PePAdVQ0lqR3Yi4UmHyUYK0gbkAUndxthHvOJ9YCP+ox46VMx/nMtwByIxPqSDY5UrGesK+hWdKAxZuHou+JogI/4/Z/NjhvkLPT7yQcORMExit1M9ZAECEnK3qPK75bPr3LhTHwGmqxsLlJfewBVfwiSI94qcf8zPAgSkGsC3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715779274; c=relaxed/simple;
	bh=Z9vmlCFkz6VRPDWj2yh7t44lq4JjqhBWjDgdEDdA5iQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YHmZnt1mWoPRJ/kiYTL7sOA+doRoafGhNX0CuDyJH3iR7kag5yDLs3WaGI2p14pEHvG/dBDkC1kU8khOQ5TQgi9nckUTGoJTIEi0I/0KRLIo4KI/HAj+0XNGTqrt8Xn/2K/9rVGwibRXV2BRGcr5z7xuVFHyq3l5H5rukhEE+N4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Sq6hwGZE; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Sq6hwGZE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715779273; x=1747315273;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Z9vmlCFkz6VRPDWj2yh7t44lq4JjqhBWjDgdEDdA5iQ=;
  b=Sq6hwGZEpLR5vxYe0TeVyNViLxFs82qLc7ZNKXVHd6biKCQKDkMbq4Cb
   PhOaE54pqoOzyI1Yr2EqHGu8sPufwqfkOlFbEVlXHPSeAM7NImgmAc8Pd
   ExS9c6lgiGzlMR+EvStrAJpOF1UbyjeBAPJKfm48/xKBR/3w05bHE6x9t
   bJllc7YNQG6LUDK734CPvtQIQL0KRWKlLdBuzBZXjuPUjWCSt2XPCDucm
   gv39RYBS0yxvW7yMvGtl+nc/Oq0KovNa/vHHEgEj8A73XhShknLuDgxi7
   nlnwRFIYD4mPG9xLuzbY+b3VAlbx77RUCwCNB2OChh0qaHtbwFrsAgjmu
   A==;
X-CSE-ConnectionGUID: nk653v75T+e7tfqp4i/rDg==
X-CSE-MsgGUID: KVhWwJPETaidfp3Pzgkt5g==
X-IronPort-AV: E=McAfee;i="6600,9927,11073"; a="15648215"
X-IronPort-AV: E=Sophos;i="6.08,161,1712646000"; 
   d="scan'208";a="15648215"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 06:21:03 -0700
X-CSE-ConnectionGUID: NXgAzgoYQh20XDnJKgq2ow==
X-CSE-MsgGUID: 7reUfwCvQ7SFD51SxbuK9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,161,1712646000"; 
   d="scan'208";a="68510855"
Received: from mehlow-prequal01.jf.intel.com ([10.54.102.156])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 06:21:02 -0700
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
Subject: [PATCH v2 1/2] x86/sgx: Resolve EAUG race where losing thread returns SIGBUS
Date: Wed, 15 May 2024 06:12:39 -0700
Message-Id: <20240515131240.1304824-2-dmitrii.kuvaiskii@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240515131240.1304824-1-dmitrii.kuvaiskii@intel.com>
References: <20240515131240.1304824-1-dmitrii.kuvaiskii@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Organization: Intel Deutschland GmbH - Registered Address: Am Campeon 10, 85579 Neubiberg, Germany
Content-Transfer-Encoding: 8bit

Two enclave threads may try to access the same non-present enclave page
simultaneously (e.g., if the SGX runtime supports lazy allocation). The
threads will end up in sgx_encl_eaug_page(), racing to acquire the
enclave lock. The winning thread will perform EAUG, set up the page
table entry, and insert the page into encl->page_array. The losing
thread will then get -EBUSY on xa_insert(&encl->page_array) and proceed
to error handling path.

This race condition can be illustrated as follows:

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

The err_out_shrink error handling path contains two bugs: (1) function
sgx_encl_free_epc_page() is called that performs EREMOVE even though the
enclave page was never intended to be removed, and (2) SIGBUS is sent to
userspace even though the enclave page is correctly installed by another
thread.

The first bug renders the enclave page perpetually inaccessible (until
another SGX_IOC_ENCLAVE_REMOVE_PAGES ioctl). This is because the page is
marked accessible in the PTE entry but is not EAUGed, and any subsequent
access to this page raises a fault: with the kernel believing there to
be a valid VMA, the unlikely error code X86_PF_SGX encountered by code
path do_user_addr_fault() -> access_error() causes the SGX driver's
sgx_vma_fault() to be skipped and user space receives a SIGSEGV instead.
The userspace SIGSEGV handler cannot perform EACCEPT because the page
was not EAUGed. Thus, the user space is stuck with the inaccessible
page. The second bug is less severe: a spurious SIGBUS signal is
unnecessarily sent to user space.

Fix these two bugs (1) by returning VM_FAULT_NOPAGE to the generic Linux
fault handler so that no signal is sent to userspace, and (2) by
replacing sgx_encl_free_epc_page() with sgx_free_epc_page() so that no
EREMOVE is performed.

Note that sgx_encl_free_epc_page() performs an additional WARN_ON_ONCE
check in comparison to sgx_free_epc_page(): whether the EPC page is
being reclaimer tracked. However, the EPC page is allocated in
sgx_encl_eaug_page() and has zeroed-out flags in all error handling
paths. In other words, the page is marked as reclaimable only in the
happy path of sgx_encl_eaug_page(). Therefore, in the particular code
path affected in this commit, the "page reclaimer tracked" condition is
always false and the warning is never printed. Thus, it is safe to
replace sgx_encl_free_epc_page() with sgx_free_epc_page().

Fixes: 5a90d2c3f5ef ("x86/sgx: Support adding of pages to an initialized enclave")
Cc: stable@vger.kernel.org
Reported-by: Marcelina Kościelnicka <mwk@invisiblethingslab.com>
Suggested-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Dmitrii Kuvaiskii <dmitrii.kuvaiskii@intel.com>
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

