Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A6F8C54EE9
	for <linux-sgx@archiver.kernel.org>; Tue, 20 Sep 2022 06:36:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbiITGgt (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 20 Sep 2022 02:36:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230374AbiITGgU (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Tue, 20 Sep 2022 02:36:20 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7EF85F223
        for <linux-sgx@vger.kernel.org>; Mon, 19 Sep 2022 23:34:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663655666; x=1695191666;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HilB6Pxgiuny/dMTP3XD/eHATyA8NIIY+sMypPSXVfQ=;
  b=QFOFGYXvlUNWL0c2eJNtkO19xUxQItH5eDMARjIeIDUYLqhj5eHwgRu1
   UJ37piOFhteI4fUlRAY3/hU7gzfBqR7bqL4NaZnhuSQ2mzJY/GsgN5DHM
   3zgJsRgHyDWOLbm2w0XNZP7bpjTHCNQtFhMP7n3SKj4FqrJDpQEe1jatT
   oQG3gpe/h1qqFfloetu2Cz3w9TehGMzaQTiUu7sQ1rnaQw/YQ3A5sXks3
   dBTJxeVHcVcgpiPeqTVtB30p+QZHNtApdpXMMmOnQyYf0cUlbQRKPgHZP
   TGwSno8T8erN6XWUL0nDLO5QTHB1253YHlqcRXjGwK6PvPbOyFKU9k7GI
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10475"; a="297203975"
X-IronPort-AV: E=Sophos;i="5.93,329,1654585200"; 
   d="scan'208";a="297203975"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2022 23:34:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,329,1654585200"; 
   d="scan'208";a="947538007"
Received: from zhiquan-linux-dev.bj.intel.com ([10.238.155.101])
  by fmsmga005.fm.intel.com with ESMTP; 19 Sep 2022 23:34:23 -0700
From:   Zhiquan Li <zhiquan1.li@intel.com>
To:     linux-sgx@vger.kernel.org, tony.luck@intel.com, jarkko@kernel.org,
        dave.hansen@linux.intel.com, tglx@linutronix.de, bp@alien8.de,
        kai.huang@intel.com
Cc:     seanjc@google.com, fan.du@intel.com, cathy.zhang@intel.com,
        zhiquan1.li@intel.com
Subject: [PATCH v9 2/3] x86/sgx: Introduce union with vepc_vaddr field for virtualization case
Date:   Tue, 20 Sep 2022 14:39:47 +0800
Message-Id: <20220920063948.3556917-3-zhiquan1.li@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220920063948.3556917-1-zhiquan1.li@intel.com>
References: <20220920063948.3556917-1-zhiquan1.li@intel.com>
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
Changes since V8:
- Remove excess Acked-by.

Changes since V7:
- Add Acked-by from Jarkko.

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
  discard irrelevant portion, since it might need some time to
  re-forge and these are two different features.
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

