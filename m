Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61662ECAAD4
	for <linux-sgx@archiver.kernel.org>; Thu,  1 Sep 2022 00:32:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231955AbiIAAcR (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 31 Aug 2022 20:32:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232254AbiIAAcA (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 31 Aug 2022 20:32:00 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B333312E4C7
        for <linux-sgx@vger.kernel.org>; Wed, 31 Aug 2022 17:31:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661992288; x=1693528288;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0YlBncKolhJEITnw7i5WA77W5z/FzFpPIpatgJfRGps=;
  b=VqePgSxZbDOJouySoYpIzZF34fEttTbPay8kJdttKjYyneW5mx8ZtNWC
   GWb0WbnEYovLkSDjatDYPx10b0zBLaqJy/M+u1NY7/dEBm260dWEXskJr
   BrUvT46f26PdxzCG+G6aZerN/sCveNdddq1IfwXQB0XQUNHRg7LN2tqHE
   8sF22IP7/gmy/d2IhpwwtfYMFmUkChIqJi9iX9LqB6TLseRRgu3o9ES4y
   Psci9AuMKZL1PrpY4U4SDZxfNvcbpm6WCEnNTI33vYkEoUnIOa/4DrdvV
   NP7fzKR29y321zg/RueoLl60/k9+ICwb8XEoauORIUEqkrPcJiyBdwuLb
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10456"; a="282559325"
X-IronPort-AV: E=Sophos;i="5.93,279,1654585200"; 
   d="scan'208";a="282559325"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2022 17:31:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,279,1654585200"; 
   d="scan'208";a="940635011"
Received: from zhiquan-linux-dev.bj.intel.com ([10.238.155.101])
  by fmsmga005.fm.intel.com with ESMTP; 31 Aug 2022 17:31:24 -0700
From:   Zhiquan Li <zhiquan1.li@intel.com>
To:     linux-sgx@vger.kernel.org, tony.luck@intel.com, jarkko@kernel.org,
        dave.hansen@linux.intel.com, tglx@linutronix.de, bp@alien8.de
Cc:     seanjc@google.com, kai.huang@intel.com, fan.du@intel.com,
        cathy.zhang@intel.com, zhiquan1.li@intel.com
Subject: [PATCH v7 2/3] x86/sgx: Introduce union with vepc_vaddr field for virtualization case
Date:   Thu,  1 Sep 2022 08:36:00 +0800
Message-Id: <20220901003601.2048563-3-zhiquan1.li@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220901003601.2048563-1-zhiquan1.li@intel.com>
References: <20220901003601.2048563-1-zhiquan1.li@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

When a page triggers a machine check, it only reports the PFN.  But in
order to inject #MC into hypervisor, the virtual address is required.
The 'encl_owner' field is useless in virtualization case, then
repurpose it as 'vepc_vaddr' - the virtual address of the virtual EPC
page for such case so that arch_memory_failure() can easily retrieve it.

Introduce a union to prevent adding a new dedicated structure to
track the virtual address of virtual EPC page.  And it can also prevent
playing the casting games while using it.

Add a new EPC page flag - SGX_EPC_PAGE_KVM_GUEST to interpret the
meaning of the field.

Co-developed-by: Cathy Zhang <cathy.zhang@intel.com>
Signed-off-by: Cathy Zhang <cathy.zhang@intel.com>
Signed-off-by: Zhiquan Li <zhiquan1.li@intel.com>
Acked-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

---
No changes since V6.

Changes since V5:
- To prevent casting the 'encl_owner' field, introduce a union with
  another field - 'vepc_vaddr', sugguested by Dave Hansen.
- Add Reviewed-by from Jarkko.
  Link: https://lore.kernel.org/linux-sgx/Yrf27fugD7lkyaek@kernel.org/T/#m379d00fc7f1d43726a42b3884637532061a8c0d1

Changes since V4:
- Add Co-developed-by and Signed-off-by from Cathy Zhang, as she had
  fully discussed the flag name with Jarkko.
  Link: https://lore.kernel.org/all/df92395ade424401ac3c6322de568720@intel.com/
- Add Acked-by from Kai Huang
  Link: https://lore.kernel.org/linux-sgx/0676cd4e-d94b-e904-81ae-ca1c05d37070@intel.com/T/#mccfb11df30698dbd060f2b6f06383cda7f154ef3

Changes since V3:
- Take the definition of EPC page flag SGX_EPC_PAGE_KVM_GUEST from
  Cathy Zhang's third patch of SGX rebootless recovery patch set but
  discard irrelevant portion, since it might need some time to re-forge
  and these are two different features.
  Link: https://lore.kernel.org/linux-sgx/41704e5d4c03b49fcda12e695595211d950cfb08.camel@kernel.org/T/#m9782d23496cacecb7da07a67daa79f4b322ae170

Changes since V2:
- Remove struct sgx_vepc_page and relevant code.
- Rework the patch suggested by Jarkko.
- Remove new EPC page flag SGX_EPC_PAGE_IS_VEPC definition as it is
  duplicated to SGX_EPC_PAGE_KVM_GUEST.
  Link: https://lore.kernel.org/linux-sgx/eb95b32ecf3d44a695610cf7f2816785@intel.com/T/#u

Changes since V1:
- Add documentation suggested by Jarkko.
---
 arch/x86/kernel/cpu/sgx/main.c | 4 ++++
 arch/x86/kernel/cpu/sgx/sgx.h  | 8 +++++++-
 arch/x86/kernel/cpu/sgx/virt.c | 4 +++-
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 1315c69a733e..b319bedcaf1e 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -549,6 +549,10 @@ int sgx_unmark_page_reclaimable(struct sgx_epc_page *page)
  * Finally, wake up ksgxd when the number of pages goes below the watermark
  * before returning back to the caller.
  *
+ * When an EPC page is assigned to KVM guest, repurpose the 'encl_owner' field
+ * as the virtual address of virtual EPC page, since it is useless in such
+ * scenario, so 'owner' is assigned to 'vepc_vaddr'.
+ *
  * Return:
  *   an EPC page,
  *   -errno on error
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index 4d88abccd12e..d16a8baa28d4 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -28,12 +28,18 @@
 
 /* Pages on free list */
 #define SGX_EPC_PAGE_IS_FREE		BIT(1)
+/* Pages allocated for KVM guest */
+#define SGX_EPC_PAGE_KVM_GUEST		BIT(2)
 
 struct sgx_epc_page {
 	unsigned int section;
 	u16 flags;
 	u16 poison;
-	struct sgx_encl_page *encl_owner;
+	union {
+		struct sgx_encl_page *encl_owner;
+		/* Use when SGX_EPC_PAGE_KVM_GUEST set in ->flags: */
+		void __user *vepc_vaddr;
+	};
 	struct list_head list;
 };
 
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

