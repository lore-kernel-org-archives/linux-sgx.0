Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7831315CD52;
	Tue, 24 Sep 2024 09:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727171857; cv=none; b=IkgQ8FKPCOfCtc0L80YV7fFBjc+uMxaZ0W0NpTNhCu0qmsgSbx1vrCxjo0da3H34gb8Zj/1X3E77uHNOqOKHsEEvtEmhbfIxX/4h2trf+vsUQyilnwWd6vGqtG3h0KQ9zA7Ol12lahaW9lWNWsZaGYoduq2fDZ1zAwsdSXXsev0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727171857; c=relaxed/simple;
	bh=bjA9MqyVQOVjJT/mwajE8QWYWgHE+b5A5U2DXcR/uf4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tqEy/bdPlmwYhE9qBZdjPLg++0IDLivpDf6pxDKsNAKf10dm5sgx19MyFb8awIvUYCxoKs8TipeE07ycKqYWIuanzVEsjZdLg73dQABY0CIbB8/HiLzUkUgYUy+/cypNuXpUek5e3ku+aQYQWdR3VRFQaxQBOIpnp3j3D7jE2ZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IGEg1UvR; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IGEg1UvR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727171856; x=1758707856;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bjA9MqyVQOVjJT/mwajE8QWYWgHE+b5A5U2DXcR/uf4=;
  b=IGEg1UvRCwtiCO031H7WQG8Gf7StIw5GqvK+EAhIadfnujPqgeaOpKF3
   Vcj0kFWujrDdpnXqjl9IcAWssgSx3jzwM4a9ApGYxwlZw/wVDd7w2lp2f
   y7H3SPSIT2l9T00wc937AB5mDNagfzAs19WQm/cfJpcz6Z9mIlxpwQyes
   0OgONbE8ul36oDts4x4Z4WMflAxKAAoEOkKgpYnVmlHfUF6zQjN8SNcTb
   pompvbS3lzXyXJ2ER6P1zSf7q8zjdsjVqeWJsd+NxUsVnT+FXW6dMBzMO
   4NVCGM1l4w0feb6Xn+QxYpRGizLjMizdIZ5sv5UX7QUDGxT2j4crmJ9Ri
   w==;
X-CSE-ConnectionGUID: xu/QOD98SrK9lHg5NYxBmQ==
X-CSE-MsgGUID: LZiBq8LaTTi06F3TpGaA4g==
X-IronPort-AV: E=McAfee;i="6700,10204,11204"; a="30041618"
X-IronPort-AV: E=Sophos;i="6.10,254,1719903600"; 
   d="scan'208";a="30041618"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2024 02:57:31 -0700
X-CSE-ConnectionGUID: rcGKA/wlT76Q49teFbINAA==
X-CSE-MsgGUID: HoQRh7IGR66ms2C2TpC0nw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,254,1719903600"; 
   d="scan'208";a="76143105"
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
	stable@vger.kernel.org,
	=?UTF-8?q?Marcelina=20Ko=C5=9Bcielnicka?= <mwk@invisiblethingslab.com>
Subject: [PATCH v6 2/3] x86/sgx: Resolve EAUG race where losing thread returns SIGBUS
Date: Tue, 24 Sep 2024 02:49:13 -0700
Message-Id: <20240924094914.3873462-3-dmitrii.kuvaiskii@intel.com>
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

Imagine an mmap()'d file. Two threads touch the same address at the same
time and fault. Both allocate a physical page and race to install a PTE
for that page. Only one will win the race. The loser frees its page, but
still continues handling the fault as a success and returns
VM_FAULT_NOPAGE from the fault handler.

The same race can happen with SGX. But there's a bug: the loser in the
SGX steers into a failure path. The loser EREMOVE's the winner's EPC
page, then returns SIGBUS, likely killing the app.

Fix the SGX loser's behavior. Check whether another thread already
allocated the page and if yes, return with VM_FAULT_NOPAGE.

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
Suggested-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Dmitrii Kuvaiskii <dmitrii.kuvaiskii@intel.com>
---
 arch/x86/kernel/cpu/sgx/encl.c | 36 ++++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index c0a3c00284c8..2aa7ced0e4a0 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -337,6 +337,16 @@ static vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
 	if (!test_bit(SGX_ENCL_INITIALIZED, &encl->flags))
 		return VM_FAULT_SIGBUS;
 
+	mutex_lock(&encl->lock);
+
+	/*
+	 * Multiple threads may try to fault on the same page concurrently.
+	 * Re-check if another thread has already done that.
+	 */
+	encl_page = xa_load(&encl->page_array, PFN_DOWN(addr));
+	if (encl_page)
+		goto done;
+
 	/*
 	 * Ignore internal permission checking for dynamically added pages.
 	 * They matter only for data added during the pre-initialization
@@ -345,23 +355,23 @@ static vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
 	 */
 	secinfo_flags = SGX_SECINFO_R | SGX_SECINFO_W | SGX_SECINFO_X;
 	encl_page = sgx_encl_page_alloc(encl, addr - encl->base, secinfo_flags);
-	if (IS_ERR(encl_page))
-		return VM_FAULT_OOM;
-
-	mutex_lock(&encl->lock);
+	if (IS_ERR(encl_page)) {
+		vmret = VM_FAULT_OOM;
+		goto err_out_unlock;
+	}
 
 	epc_page = sgx_encl_load_secs(encl);
 	if (IS_ERR(epc_page)) {
 		if (PTR_ERR(epc_page) == -EBUSY)
 			vmret = VM_FAULT_NOPAGE;
-		goto err_out_unlock;
+		goto err_out_encl;
 	}
 
 	epc_page = sgx_alloc_epc_page(encl_page, false);
 	if (IS_ERR(epc_page)) {
 		if (PTR_ERR(epc_page) == -EBUSY)
 			vmret =  VM_FAULT_NOPAGE;
-		goto err_out_unlock;
+		goto err_out_encl;
 	}
 
 	va_page = sgx_encl_grow(encl, false);
@@ -376,10 +386,6 @@ static vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
 
 	ret = xa_insert(&encl->page_array, PFN_DOWN(encl_page->desc),
 			encl_page, GFP_KERNEL);
-	/*
-	 * If ret == -EBUSY then page was created in another flow while
-	 * running without encl->lock
-	 */
 	if (ret)
 		goto err_out_shrink;
 
@@ -389,7 +395,7 @@ static vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
 
 	ret = __eaug(&pginfo, sgx_get_epc_virt_addr(epc_page));
 	if (ret)
-		goto err_out;
+		goto err_out_eaug;
 
 	encl_page->encl = encl;
 	encl_page->epc_page = epc_page;
@@ -408,20 +414,20 @@ static vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
 		mutex_unlock(&encl->lock);
 		return VM_FAULT_SIGBUS;
 	}
+done:
 	mutex_unlock(&encl->lock);
 	return VM_FAULT_NOPAGE;
 
-err_out:
+err_out_eaug:
 	xa_erase(&encl->page_array, PFN_DOWN(encl_page->desc));
-
 err_out_shrink:
 	sgx_encl_shrink(encl, va_page);
 err_out_epc:
 	sgx_encl_free_epc_page(epc_page);
+err_out_encl:
+	kfree(encl_page);
 err_out_unlock:
 	mutex_unlock(&encl->lock);
-	kfree(encl_page);
-
 	return vmret;
 }
 
-- 
2.43.0

