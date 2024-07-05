Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C5D9132103;
	Fri,  5 Jul 2024 07:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720166050; cv=none; b=OpQr4JAtUyqgIlKO1iXu2ViqMD1GhU4DWtMtAYwUl4B1HfqiZlcLcrGnx1TG6cbVyaOt5NNTVPl9Sz6sgnzB25BG9wlSkmXDk/3e2aKrtzg/tyuySJruipOXGSHtZ2T1v0I6A0J8HAuD6w9QyGPrxxijo756pcdduLv2gYkYUPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720166050; c=relaxed/simple;
	bh=4yA/SqWhaSDPZ6/d0XAruoXDmzVaIS+v2bhSzKsdbBs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TRF7xjp5Mz49uFuHhCMAB6cDo8tiCgllUEZItPmh3ZFWU3YsOSspHMNdBOYhWQA81IepwMzNiFgoMKem/TJwu+6Nw17gOqyC00gEpe0vK+ROIfvLjzwBGYzGqs/I+puzapJuHzWedvQpZIyGBw/Qzh8FzA79seXxh3Cp1tt2/HU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J++aJw33; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J++aJw33"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720166048; x=1751702048;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4yA/SqWhaSDPZ6/d0XAruoXDmzVaIS+v2bhSzKsdbBs=;
  b=J++aJw33HUZ2bDMDgSnRCNppRa/bX3ZKFMHGrvc9ePdiO5F0Z96ry18B
   UKZEPQdjbB5uHmNvwZKoMNg8FIkKeZ7rrxk5HAClN7KUR0scOGUAwbbsX
   brPEQK+N/dVBW9/ZNRYQ7OVRBt7rbzP+wROL4996CvmuYrLAmXoUut20H
   uzinBGmYdaNNsoPq7RWmRWTHlGnfPCZ+acNxque4s/5iVvMRjY8hUMORs
   F5uJVwfNz+eab8aVJUqVdPGFssDaYjBVFooP1Z2jmzr5xHvSsplglOXn+
   v6etXbnMusK3Nviq6pxPy3WwBjhRabhiLNqJF/Lc/RE3fzgSr+xzWiF0i
   w==;
X-CSE-ConnectionGUID: h/PvsrUiQWavRV6IpuIJ9g==
X-CSE-MsgGUID: TxdkP8OgS22YtMj+5ZdXmA==
X-IronPort-AV: E=McAfee;i="6700,10204,11123"; a="34892877"
X-IronPort-AV: E=Sophos;i="6.09,184,1716274800"; 
   d="scan'208";a="34892877"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2024 00:53:42 -0700
X-CSE-ConnectionGUID: TX5lsDZVTyW1ptroyuUwbg==
X-CSE-MsgGUID: l5NbbIlXTSWBOTPYLj3F0w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,184,1716274800"; 
   d="scan'208";a="46918570"
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
	stable@vger.kernel.org,
	=?UTF-8?q?Marcelina=20Ko=C5=9Bcielnicka?= <mwk@invisiblethingslab.com>
Subject: [PATCH v4 2/3] x86/sgx: Resolve EAUG race where losing thread returns SIGBUS
Date: Fri,  5 Jul 2024 00:45:23 -0700
Message-Id: <20240705074524.443713-3-dmitrii.kuvaiskii@intel.com>
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
index c0a3c00284c8..9f7f9e57cdeb 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -380,8 +380,11 @@ static vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
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
@@ -417,7 +420,7 @@ static vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
 err_out_shrink:
 	sgx_encl_shrink(encl, va_page);
 err_out_epc:
-	sgx_encl_free_epc_page(epc_page);
+	sgx_free_epc_page(epc_page);
 err_out_unlock:
 	mutex_unlock(&encl->lock);
 	kfree(encl_page);
-- 
2.43.0

