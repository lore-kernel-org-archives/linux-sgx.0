Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 444BBC61DA4
	for <linux-sgx@archiver.kernel.org>; Sat, 28 Jan 2023 04:55:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232846AbjA1Ezc (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 27 Jan 2023 23:55:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232788AbjA1Ezb (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 27 Jan 2023 23:55:31 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC66284B40
        for <linux-sgx@vger.kernel.org>; Fri, 27 Jan 2023 20:55:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674881730; x=1706417730;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=oxyTiO35hY2GeoWb+XRp8uFFt8zjnCMjAA8Q4+dneAI=;
  b=lSY6TUHMHbE7mQI6BnybHjRr0NwQLU10Fw5MaFD4XVrF3nL0RtrR+FH0
   AXTt//U3gvhidoZf1QFJnDhOiCORj3lsBm3RUisuE1028X9Tkm0I5Cp4P
   b9UT0dHePWqgvSBkgBUr2QWa5Hd1sZ4y78OJQtRE+hfvnsVrx91IonlAN
   SyLGBsgGi737COcrF0J2n+7bUEOVZqg+cqQhuMrOFUbsZ3rLrxIHOOVH9
   nOiCyOHYxI18RWI9cfO4oh5hdIt/7KOCPu9x/Y5tkCT6Wh9XNK8qIq7iW
   b6eZ8obNp5SIH8sTJxUOiEplHNT7GC3QOSTreBdR+x4NNKVl1zIX/JKbH
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10603"; a="413484074"
X-IronPort-AV: E=Sophos;i="5.97,253,1669104000"; 
   d="scan'208";a="413484074"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2023 20:55:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10603"; a="640942039"
X-IronPort-AV: E=Sophos;i="5.97,253,1669104000"; 
   d="scan'208";a="640942039"
Received: from b4969161e530.jf.intel.com ([10.165.56.46])
  by orsmga006.jf.intel.com with ESMTP; 27 Jan 2023 20:55:29 -0800
From:   Haitao Huang <haitao.huang@linux.intel.com>
To:     linux-sgx@vger.kernel.org, jarkko@kernel.org,
        dave.hansen@linux.intel.com, reinette.chatre@intel.com,
        vijay.dhanraj@intel.com
Subject: [RFC PATCH v4 1/4] x86/sgx: Export sgx_encl_eaug_page
Date:   Fri, 27 Jan 2023 20:55:26 -0800
Message-Id: <20230128045529.15749-2-haitao.huang@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230128045529.15749-1-haitao.huang@linux.intel.com>
References: <20230128045529.15749-1-haitao.huang@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

This function will be called by both the page fault handler
and the fops->fadvise callback.

Signed-off-by: Haitao Huang <haitao.huang@linux.intel.com>
Acked-by: Jarkko Sakkinen <jarkko@kernel.org>
---
 arch/x86/kernel/cpu/sgx/encl.c | 4 ++--
 arch/x86/kernel/cpu/sgx/encl.h | 2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 2a0e90fe2abc..0185c5ab48dd 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -311,8 +311,8 @@ struct sgx_encl_page *sgx_encl_load_page(struct sgx_encl *encl,
  * Returns: Appropriate vm_fault_t: VM_FAULT_NOPAGE when PTE was installed
  * successfully, VM_FAULT_SIGBUS or VM_FAULT_OOM as error otherwise.
  */
-static vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
-				     struct sgx_encl *encl, unsigned long addr)
+vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
+			      struct sgx_encl *encl, unsigned long addr)
 {
 	vm_fault_t vmret = VM_FAULT_SIGBUS;
 	struct sgx_pageinfo pginfo = {0};
diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
index f94ff14c9486..9f19b06c3ae3 100644
--- a/arch/x86/kernel/cpu/sgx/encl.h
+++ b/arch/x86/kernel/cpu/sgx/encl.h
@@ -125,5 +125,7 @@ struct sgx_encl_page *sgx_encl_load_page(struct sgx_encl *encl,
 					 unsigned long addr);
 struct sgx_va_page *sgx_encl_grow(struct sgx_encl *encl, bool reclaim);
 void sgx_encl_shrink(struct sgx_encl *encl, struct sgx_va_page *va_page);
+vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
+			      struct sgx_encl *encl, unsigned long addr);
 
 #endif /* _X86_ENCL_H */
-- 
2.25.1

