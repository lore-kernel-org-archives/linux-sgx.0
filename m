Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51C9FC433FE
	for <linux-sgx@archiver.kernel.org>; Fri,  1 Apr 2022 14:24:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346755AbiDAO0P (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 1 Apr 2022 10:26:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241890AbiDAO0O (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 1 Apr 2022 10:26:14 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5839E113D1D
        for <linux-sgx@vger.kernel.org>; Fri,  1 Apr 2022 07:24:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648823065; x=1680359065;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=RHJkEHM62QCOCGe4xh/rn0AQ0pihJS1FZyaOKFYuUOE=;
  b=EnDe3SIrULV7PVZ6JNLcNG4qDPV9W+kdbNwfLptKqQQRnGW408T5Iso0
   IPIyEwen3+w0TONLtCYGWOSuK5Q5C8+sensl1GX7ZNFMVPycz0Dxoi8gn
   GsVBs0dE9DHHhRg2C6op8KalXCMXv4EXpEa8TMc5tC06lNnJuL77MzWtf
   YENn/NBAdmz/22uizvkt8SQNtMl4jKvbrjrsaCgwTR1hurEfJvoLJvWxM
   AR3kqE6iyzqOzKw+nl/qizG7w5Wqi62VjF7F3+hV+qUXhGrbPMzT0Foxo
   MHA8gv77ZSdz8oLq+t/CWqaDf5sUemG09mbt5nICbZ5RZvv5MwdWZwuaX
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10304"; a="240739875"
X-IronPort-AV: E=Sophos;i="5.90,227,1643702400"; 
   d="scan'208";a="240739875"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2022 07:24:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,227,1643702400"; 
   d="scan'208";a="695908338"
Received: from cathy-vostro-3670.bj.intel.com ([10.238.156.128])
  by fmsmga001.fm.intel.com with ESMTP; 01 Apr 2022 07:24:23 -0700
From:   Cathy Zhang <cathy.zhang@intel.com>
To:     linux-sgx@vger.kernel.org, x86@kernel.org
Cc:     jarkko@kernel.org, reinette.chatre@intel.com,
        dave.hansen@intel.com, ashok.raj@intel.com, cathy.zhang@intel.com
Subject: [RFC PATCH v3 03/10] x86/sgx: Save enclave pointer for VA page
Date:   Fri,  1 Apr 2022 22:24:02 +0800
Message-Id: <20220401142409.26215-4-cathy.zhang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220401142409.26215-1-cathy.zhang@intel.com>
References: <20220401142409.26215-1-cathy.zhang@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Tearing down all enclaves is required by SGX SVN update, which
involves running the ENCLS[EREMOVE] instruction on every EPC
page. This (tearing down all enclaves) should be coordinated
with any enclaves that may be in the process of existing and thus
already be running ENCLS[EREMOVE] as part of enclave release.

In support of this coordination, it is required to know which enclave
owns each in-use EPC page. It is already possible to locate the
owning enclave of SECS and regular pages but not for VA pages.

Save the enclave pointer for each VA page to support locating its
owning enclave.

Note: to track 2T EPC memory, this scheme of tracking will use
additional 8M memory.

Signed-off-by: Cathy Zhang <cathy.zhang@intel.com>
---
 arch/x86/kernel/cpu/sgx/encl.h  | 1 +
 arch/x86/kernel/cpu/sgx/ioctl.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
index 0c8571fc30cf..59fbd4ed5c64 100644
--- a/arch/x86/kernel/cpu/sgx/encl.h
+++ b/arch/x86/kernel/cpu/sgx/encl.h
@@ -76,6 +76,7 @@ struct sgx_va_page {
 	struct sgx_epc_page *epc_page;
 	DECLARE_BITMAP(slots, SGX_VA_SLOT_COUNT);
 	struct list_head list;
+	struct sgx_encl *encl;
 };
 
 struct sgx_backing {
diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index f0ce96bd462a..da82abbb81b4 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -30,6 +30,7 @@ static struct sgx_va_page *sgx_encl_grow(struct sgx_encl *encl)
 		if (!va_page)
 			return ERR_PTR(-ENOMEM);
 
+		va_page->encl = encl;
 		va_page->epc_page = sgx_alloc_va_page(va_page);
 		if (IS_ERR(va_page->epc_page)) {
 			err = ERR_CAST(va_page->epc_page);
-- 
2.17.1

