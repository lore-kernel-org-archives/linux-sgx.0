Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35013144D01;
	Fri,  5 Jul 2024 07:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720166052; cv=none; b=GRVA6HE7re/0pzV0NeQagF4l6p8PlbavD+Z554uj9PT5OoQ6iz9pjzVlIwDW9+Rw52fVP/uz1N3GALedV9S63HPiyrwgcNEyqld82+wcuP47l6HMSbSlJ5yDUKtmWQTzJPHR4HSAGZQQnCf4Nf3fsz/97KSFhfNE5XMQoJFXDb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720166052; c=relaxed/simple;
	bh=/HURQ9P7Vc7T3PAxMwL3oaZWdqdQeeykS7R4xZmGSKg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gRKoa85iP7L0CK3X09FLAsMB2/GgjQW12/65rWv9ZpOdYNxdi9nIDT+kN9RTbB4kzTK30BLIOVwHiJ318NccikEboR44ZwJ5QvNLZ532xBN6JhBinDWX13iTuY1eYbV+zrEaTgdaAbkO9ZzThTqm9XB6FvX/GFCvbsS2ED1aLJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jiXSWns7; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jiXSWns7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720166051; x=1751702051;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/HURQ9P7Vc7T3PAxMwL3oaZWdqdQeeykS7R4xZmGSKg=;
  b=jiXSWns7L2hZeZ+UCUofvfygaMq5xz62X+/imgeYXWd7kCUWoSw/ZqsZ
   cyPQwIjdSu1dI1rpkoh7FqqG4HSKwV611CLH37L4qK27In+aDbeakdBGC
   cyMsczNHEf/4hDa5isQRtJmMLz33DrEbtfhCtIpHnTU0OL5KNZF/0ksJe
   pOUZH+dpXTO/JyBF3Ro/tekUPVvmVXgWfW9R9ttQr0uIhi6EFT1BwoVc6
   XhNNS66s7Xj4RuWL7RauyyYx2opcEZkYSMliSAd0dls5Or34RuK1rzb7P
   mkRu2Iwlczb4o3jpHJr0M7kK0Q3aF8WbUHdVzLPmSwXyIV7tGwuMsxBcA
   w==;
X-CSE-ConnectionGUID: LkWUS+2jTHKq0ccP4Q5d6A==
X-CSE-MsgGUID: i+r4djDjR1+vk+S0AnbKzQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11123"; a="34892880"
X-IronPort-AV: E=Sophos;i="6.09,184,1716274800"; 
   d="scan'208";a="34892880"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2024 00:53:42 -0700
X-CSE-ConnectionGUID: tZahdZq+T3Oz49DbNqUNHw==
X-CSE-MsgGUID: +UmtMMtrRa+qoAGmJw7l3g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,184,1716274800"; 
   d="scan'208";a="46918572"
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
Subject: [PATCH v4 3/3] x86/sgx: Resolve EREMOVE page vs EAUG page data race
Date: Fri,  5 Jul 2024 00:45:24 -0700
Message-Id: <20240705074524.443713-4-dmitrii.kuvaiskii@intel.com>
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

Fixes: 9849bb27152c ("x86/sgx: Support complete page removal")
Cc: stable@vger.kernel.org
Signed-off-by: Dmitrii Kuvaiskii <dmitrii.kuvaiskii@intel.com>
---
 arch/x86/kernel/cpu/sgx/ioctl.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 5d390df21440..02441883401d 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -1141,7 +1141,14 @@ static long sgx_encl_remove_pages(struct sgx_encl *encl,
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

