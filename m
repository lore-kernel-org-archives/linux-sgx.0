Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2D16FA3743
	for <linux-sgx@archiver.kernel.org>; Thu, 27 Oct 2022 19:45:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236629AbiJ0Tpi (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 27 Oct 2022 15:45:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236322AbiJ0Tpg (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 27 Oct 2022 15:45:36 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 209125FF58
        for <linux-sgx@vger.kernel.org>; Thu, 27 Oct 2022 12:45:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666899936; x=1698435936;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=Oxv5SGcMEfOJY0KrKF5YdHFUZE3D54ECGrWr6qJ+HiM=;
  b=kg2uVj+T1wZHUS1xef2L9FyBYlkxulKN/qh9on3TRnrJoCMvBlJD4AbC
   PXG2vLBO5hY6PTocloIZ9T42SArIrhaUi+By8RWTDIaLT2cBJz9A9zRmX
   GZ5hNAtlOQUUg3XHIxfKIQ7kbFB3wwbQmqa4M4D+v55YZ9mDAwVQCWq2i
   HLxvWySJhGEgYX8zkgfg4qI1UyVhhUyp9Jqv+TiavaKX4xirac/eSJGZ0
   AvFHskopFefFdn5qIiTODkRgezbeFUGLzfs5PsOy2qlHCY25A7s036ysC
   ZciZKIRePTZx5J8iWeQOevjvtUkNwUHDvUZQuxBYX3c+jZxyTBtAQtXeG
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="310021407"
X-IronPort-AV: E=Sophos;i="5.95,218,1661842800"; 
   d="scan'208";a="310021407"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 12:45:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10513"; a="961753290"
X-IronPort-AV: E=Sophos;i="5.95,218,1661842800"; 
   d="scan'208";a="961753290"
Received: from b4969161e530.jf.intel.com ([10.165.56.46])
  by fmsmga005.fm.intel.com with ESMTP; 27 Oct 2022 12:45:32 -0700
From:   Haitao Huang <haitao.huang@linux.intel.com>
To:     linux-sgx@vger.kernel.org, jarkko@kernel.org,
        dave.hansen@linux.intel.com, reinette.chatre@intel.com,
        vijay.dhanraj@intel.com
Subject: [RFC PATCH v2 1/4] x86/sgx: Export sgx_encl_eaug_page
Date:   Thu, 27 Oct 2022 12:45:29 -0700
Message-Id: <20221027194532.180053-2-haitao.huang@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221027194532.180053-1-haitao.huang@linux.intel.com>
References: <20221027194532.180053-1-haitao.huang@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

This function will be called by both the page fault handler
and the fops->fadvise callback.

Signed-off-by: Haitao Huang <haitao.huang@linux.intel.com>
---
 arch/x86/kernel/cpu/sgx/encl.c | 4 ++--
 arch/x86/kernel/cpu/sgx/encl.h | 3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 8bdeae2fc309..1abc5e7f2660 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -308,8 +308,8 @@ struct sgx_encl_page *sgx_encl_load_page(struct sgx_encl *encl,
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
index a65a952116fd..500437981161 100644
--- a/arch/x86/kernel/cpu/sgx/encl.h
+++ b/arch/x86/kernel/cpu/sgx/encl.h
@@ -127,5 +127,6 @@ struct sgx_encl_page *sgx_encl_load_page(struct sgx_encl *encl,
 					 unsigned long addr);
 struct sgx_va_page *sgx_encl_grow(struct sgx_encl *encl, bool reclaim);
 void sgx_encl_shrink(struct sgx_encl *encl, struct sgx_va_page *va_page);
-
+vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
+			      struct sgx_encl *encl, unsigned long addr)
 #endif /* _X86_ENCL_H */
-- 
2.25.1

