Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 238D6C433F5
	for <linux-sgx@archiver.kernel.org>; Mon,  3 Oct 2022 22:04:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbiJCWEs (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 3 Oct 2022 18:04:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbiJCWEq (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 3 Oct 2022 18:04:46 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B27767652;
        Mon,  3 Oct 2022 15:04:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664834683; x=1696370683;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TX27OPhzU6FkwQBBFhssDYk2QfF6ahRh6VMWmC5I3g4=;
  b=BPIippcQ4Y6V68R86uogfipByZScpcw5i5/HfzS/M0c5d5PzLfjtc1v9
   E9VLvcYcUXRgjFlip07vXGWURz67ZZsNSiEj2qtSLjWD3FpJq6xK1MAGU
   4rJMo+DKBlTCNioPWvjm0OLyC3gq4Z4gwg7GbbgIhrguO+WbtiG4OtNXi
   tLh1dPd02iCJKztA2r6yJzMTEeabsSkl0HQUIWmJJ4YD3uTxnpRahZW1T
   GHeTmEIsSIL4agl3ZT+w+lJORu9+zgaIrlgO/yTNLlVnHOaLUTHTk4yEy
   mB5OrPnfcyjLolGArfssngwMbT04Pxwo2A3Jsb8XkULHuGWH6UuSMavkx
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10489"; a="366869180"
X-IronPort-AV: E=Sophos;i="5.93,366,1654585200"; 
   d="scan'208";a="366869180"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2022 15:04:43 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10489"; a="686310975"
X-IronPort-AV: E=Sophos;i="5.93,366,1654585200"; 
   d="scan'208";a="686310975"
Received: from jparcemo-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.212.93.75])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Oct 2022 15:04:42 -0700
From:   Kai Huang <kai.huang@intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     dave.hansen@linux.intel.com, jarkko@kernel.org,
        tony.luck@intel.com, linux-kernel@vger.kernel.org
Subject: [RESEND PATCH 3/3] x86/sgx: Add xa_store_range() return value check in sgx_setup_epc_section()
Date:   Tue,  4 Oct 2022 11:04:29 +1300
Message-Id: <c02b60d3b92469a2ccfc0780e974d29da578be73.1664834225.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <cover.1664834225.git.kai.huang@intel.com>
References: <cover.1664834225.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

In sgx_setup_epc_section(), xa_store_range() is called to store EPC
pages' owner section to an Xarray using physical addresses of those EPC
pages as index.  Currently, the return value of xa_store_range() is not
checked, but actually it can fail (i.e. due to -ENOMEM).

Not checking the return value of xa_store_range() would result in the
EPC section being used by SGX driver (and KVM SGX guests), but part or
all of its EPC pages not being handled by the memory failure handling of
EPC page.  Such inconsistency should be avoided, even at the cost that
this section won't be used by the kernel.

Add the missing check of the return value of xa_store_range(), and when
it fails, clean up and fail to initialize the EPC section.

Fixes: 40e0e7843e23 ("x86/sgx: Add infrastructure to identify SGX EPC pages")
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/kernel/cpu/sgx/main.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 0fdbc490b0f8..5ddf9d9296f4 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -630,8 +630,12 @@ static bool __init sgx_setup_epc_section(u64 phys_addr, u64 size,
 	}
 
 	section->phys_addr = phys_addr;
-	xa_store_range(&sgx_epc_address_space, section->phys_addr,
-		       phys_addr + size - 1, section, GFP_KERNEL);
+	if (xa_err(xa_store_range(&sgx_epc_address_space, section->phys_addr,
+		       phys_addr + size - 1, section, GFP_KERNEL))) {
+		vfree(section->pages);
+		memunmap(section->virt_addr);
+		return false;
+	}
 
 	for (i = 0; i < nr_pages; i++) {
 		section->pages[i].section = index;
-- 
2.37.1

