Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB1F9C43334
	for <linux-sgx@archiver.kernel.org>; Wed,  8 Jun 2022 06:00:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234031AbiFHGAs (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 8 Jun 2022 02:00:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235952AbiFHFuC (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 8 Jun 2022 01:50:02 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C4A01BBAC6
        for <linux-sgx@vger.kernel.org>; Tue,  7 Jun 2022 20:26:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654658804; x=1686194804;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=snECM3a9Dp6/x5oc/EHTo3dC1FRqmefM+pun0S/Vau4=;
  b=Egk68iOtQc7+xvG4E6vItGd/UbmwqR4RXghzkyOIOOcbRLz0L9wkOhA3
   Pu/WccFu4XZn/5n3mNHJ0/VLkXzLQmX2CcmcWnkoMAoj/m5TAYFi90UgD
   MkVPelilIIE13pfOVdb3gpqNt6b8gLUM2FbcWHV+Nc9NjBlMkZPZ4UOrJ
   AMUw7qUmD+eyRyY84yaf+mHYNXxuLu167gfe08ilRqKlsLLsP0p0gDHO2
   2vSkh0KRV5fvgQPlkfXeTBxS0VtxnzYJXj6BXoBgGo1StqPGyqr4mwl3q
   u8TkILQBENkPzhPow5vlhF13rdHiMeQst3GzomBCZbfZbHq1IghRY6sUz
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10371"; a="276819875"
X-IronPort-AV: E=Sophos;i="5.91,285,1647327600"; 
   d="scan'208";a="276819875"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2022 20:26:44 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,285,1647327600"; 
   d="scan'208";a="670325058"
Received: from zhiquan-linux-dev.bj.intel.com ([10.238.155.101])
  by FMSMGA003.fm.intel.com with ESMTP; 07 Jun 2022 20:26:41 -0700
From:   Zhiquan Li <zhiquan1.li@intel.com>
To:     linux-sgx@vger.kernel.org, tony.luck@intel.com, jarkko@kernel.org,
        dave.hansen@linux.intel.com
Cc:     seanjc@google.com, kai.huang@intel.com, fan.du@intel.com,
        cathy.zhang@intel.com, zhiquan1.li@intel.com
Subject: [PATCH v4 1/3] x86/sgx: Repurpose the owner field as the virtual address of virtual EPC page
Date:   Wed,  8 Jun 2022 11:26:52 +0800
Message-Id: <20220608032654.1764936-2-zhiquan1.li@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220608032654.1764936-1-zhiquan1.li@intel.com>
References: <20220608032654.1764936-1-zhiquan1.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

When a page triggers a machine check, it only reports the
physical address of EPC page. But in order to inject #MC into
hypervisor, the virtual address is required. Then repurpose the
"owner" field as the virtual address of the virtual EPC page so that
arch_memory_failure() can easily retrieve it.

Add a new EPC page flag - SGX_EPC_PAGE_KVM_GUEST to interpret the
meaning of the field.

Signed-off-by: Zhiquan Li <zhiquan1.li@intel.com>
---
Changes since V3:
- Move the definition of EPC page flag SGX_EPC_PAGE_KVM_GUEST from
  Cathy's third patch of SGX rebootless recovery patch set but discard
  irrelevant portion, since it might need more time to re-forge and
  these are two different features.
  Link: https://lore.kernel.org/linux-sgx/41704e5d4c03b49fcda12e695595211d950cfb08.camel@kernel.org/T/#m9782d23496cacecb7da07a67daa79f4b322ae170

Changes since V2:
- Rework the patch suggested by Jarkko.
- Remove struct sgx_vepc_page and relevant code.
- Remove new EPC page flag SGX_EPC_PAGE_IS_VEPC definition as it is
  duplicated to SGX_EPC_PAGE_KVM_GUEST.
  Link: https://lore.kernel.org/linux-sgx/eb95b32ecf3d44a695610cf7f2816785@intel.com/T/#u

Changes since V1:
- Add documentation suggested by Jarkko.
---
 arch/x86/kernel/cpu/sgx/sgx.h  | 2 ++
 arch/x86/kernel/cpu/sgx/virt.c | 4 +++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index 0f17def9fe6f..b43582da1bcf 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -28,6 +28,8 @@
 
 /* Pages on free list */
 #define SGX_EPC_PAGE_IS_FREE		BIT(1)
+/* Pages allocated for KVM guest */
+#define SGX_EPC_PAGE_KVM_GUEST		BIT(2)
 
 struct sgx_epc_page {
 	unsigned int section;
diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/virt.c
index 6a77a14eee38..776ae5c1c032 100644
--- a/arch/x86/kernel/cpu/sgx/virt.c
+++ b/arch/x86/kernel/cpu/sgx/virt.c
@@ -46,10 +46,12 @@ static int __sgx_vepc_fault(struct sgx_vepc *vepc,
 	if (epc_page)
 		return 0;
 
-	epc_page = sgx_alloc_epc_page(vepc, false);
+	epc_page = sgx_alloc_epc_page((void *)addr, false);
 	if (IS_ERR(epc_page))
 		return PTR_ERR(epc_page);
 
+	epc_page->flags |= SGX_EPC_PAGE_KVM_GUEST;
+
 	ret = xa_err(xa_store(&vepc->page_array, index, epc_page, GFP_KERNEL));
 	if (ret)
 		goto err_free;
-- 
2.25.1

