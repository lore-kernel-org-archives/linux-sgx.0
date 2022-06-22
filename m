Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8750DC43334
	for <linux-sgx@archiver.kernel.org>; Wed, 22 Jun 2022 09:37:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236854AbiFVJhA (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 22 Jun 2022 05:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235328AbiFVJg6 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 22 Jun 2022 05:36:58 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55FB43526C
        for <linux-sgx@vger.kernel.org>; Wed, 22 Jun 2022 02:36:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655890618; x=1687426618;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cVczxYOVbWktKTC3k1cfS17zBNVsdg+zCJlhBUjeNZU=;
  b=OegSKLuoOyIFFYAzLO0D8OELeUz3uiKW9jD1vRkmOs3ZcoNp2YS1HH1l
   APYOYIbiPpuDjacw09qUIiOV+PpgFLqMlyhCHL8G9SFb52Dj1Ij7cqKDK
   1kM6TZhDyqqb/rg1ZGn8t7+P9orXQPh2XF8z5ceSjFQG9NC3XZTj8Jrml
   /hp4alQwlJn12CEVxaQXXJhCa71x37Yx87xupTa3EDkRRO0S1Ez0xnrO9
   OY3A1T+OlFxMlv+sMibvbmSrU5Ssx7ymBqF9qlWbbETd9lWY9a3ngj6OE
   dImn10y1t9xoV5Q+/dZn49WHI7LWJqJnrmKZ3nrPPKKWGwl9sIbzfRQPN
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10385"; a="281100602"
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="281100602"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jun 2022 02:36:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="677448852"
Received: from zhiquan-linux-dev.bj.intel.com ([10.238.155.101])
  by FMSMGA003.fm.intel.com with ESMTP; 22 Jun 2022 02:36:54 -0700
From:   Zhiquan Li <zhiquan1.li@intel.com>
To:     linux-sgx@vger.kernel.org, tony.luck@intel.com, jarkko@kernel.org,
        dave.hansen@linux.intel.com
Cc:     seanjc@google.com, kai.huang@intel.com, fan.du@intel.com,
        cathy.zhang@intel.com, zhiquan1.li@intel.com
Subject: [PATCH v5 1/3] x86/sgx: Repurpose the owner field as the virtual address of virtual EPC page
Date:   Wed, 22 Jun 2022 17:37:03 +0800
Message-Id: <20220622093705.2891642-2-zhiquan1.li@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220622093705.2891642-1-zhiquan1.li@intel.com>
References: <20220622093705.2891642-1-zhiquan1.li@intel.com>
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

Co-developed-by: Cathy Zhang <cathy.zhang@intel.com>
Signed-off-by: Cathy Zhang <cathy.zhang@intel.com>
Signed-off-by: Zhiquan Li <zhiquan1.li@intel.com>
Acked-by: Kai Huang <kai.huang@intel.com>

---
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

