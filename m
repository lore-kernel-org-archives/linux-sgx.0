Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70940C433FE
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Mar 2022 10:40:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbiCIKl1 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 9 Mar 2022 05:41:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230490AbiCIKl1 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 9 Mar 2022 05:41:27 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C2583EA97
        for <linux-sgx@vger.kernel.org>; Wed,  9 Mar 2022 02:40:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646822427; x=1678358427;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=eo8eRy18WOMEfF6XezKel2X6wCXcvho3sORMilAr+Pw=;
  b=irDiujUWXX1mpEIzhmjfJJE33f063gi+I+n7V+BNd0arTHADJYUQ1wPd
   wxdzhptFKxi18xgSeeWOFRGWyzbzlUgKztVnLi5Qrc0kVc/qOEjsXtMUZ
   hzK1V5Dt/atRSc9ElORs4hfhVdYHktvAaHMokileNy1MhSzbHIlilrUIw
   Hfqi29Xo3nn9bfDl/KeZuXFEUyN+bx3ZrFLaloWsaE1uQdWgih8HR6Tid
   vIaj+PU32xpyrnWcq/vQJXPSrQrfR9cwKO+PfZUSdxxD9PkYNb0LiYScQ
   RLASBFH8uy/w9M2w5rkrq3UuEhk3eUkpRXN8Bai8H1MJ+Dra+Y48v0sKF
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10280"; a="341373551"
X-IronPort-AV: E=Sophos;i="5.90,167,1643702400"; 
   d="scan'208";a="341373551"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 02:40:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,167,1643702400"; 
   d="scan'208";a="547582868"
Received: from cathy-vostro-3670.bj.intel.com ([10.238.156.128])
  by fmsmga007.fm.intel.com with ESMTP; 09 Mar 2022 02:40:25 -0800
From:   Cathy Zhang <cathy.zhang@intel.com>
To:     linux-sgx@vger.kernel.org, x86@kernel.org
Cc:     dave.hansen@intel.com, cathy.zhang@intel.com
Subject: [RFC PATCH 03/11] x86/sgx: Save enclave pointer for VA page
Date:   Wed,  9 Mar 2022 18:40:42 +0800
Message-Id: <20220309104050.18207-4-cathy.zhang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220309104050.18207-1-cathy.zhang@intel.com>
References: <20220309104050.18207-1-cathy.zhang@intel.com>
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
index 1807a7f55065..e6f14c45ad49 100644
--- a/arch/x86/kernel/cpu/sgx/encl.h
+++ b/arch/x86/kernel/cpu/sgx/encl.h
@@ -77,6 +77,7 @@ struct sgx_va_page {
 	struct sgx_epc_page *epc_page;
 	DECLARE_BITMAP(slots, SGX_VA_SLOT_COUNT);
 	struct list_head list;
+	struct sgx_encl *encl;
 };
 
 struct sgx_backing {
diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 9eb429aeb319..0f7b3e24fb94 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -30,6 +30,7 @@ struct sgx_va_page *sgx_encl_grow(struct sgx_encl *encl)
 		if (!va_page)
 			return ERR_PTR(-ENOMEM);
 
+		va_page->encl = encl;
 		va_page->epc_page = sgx_alloc_va_page(va_page);
 		if (IS_ERR(va_page->epc_page)) {
 			err = ERR_CAST(va_page->epc_page);
-- 
2.17.1

