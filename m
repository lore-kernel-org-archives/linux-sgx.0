Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4353C433FE
	for <linux-sgx@archiver.kernel.org>; Fri,  1 Oct 2021 16:47:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82FF561ACF
	for <linux-sgx@archiver.kernel.org>; Fri,  1 Oct 2021 16:47:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355234AbhJAQtR (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 1 Oct 2021 12:49:17 -0400
Received: from mga11.intel.com ([192.55.52.93]:19801 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355220AbhJAQtQ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 1 Oct 2021 12:49:16 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10124"; a="222290385"
X-IronPort-AV: E=Sophos;i="5.85,339,1624345200"; 
   d="scan'208";a="222290385"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2021 09:47:31 -0700
X-IronPort-AV: E=Sophos;i="5.85,339,1624345200"; 
   d="scan'208";a="540357491"
Received: from agluck-desk2.sc.intel.com ([10.3.52.146])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2021 09:47:31 -0700
From:   Tony Luck <tony.luck@intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@intel.com>
Cc:     Cathy Zhang <cathy.zhang@intel.com>, linux-sgx@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>
Subject: [PATCH v8 2/7] x86/sgx: Add infrastructure to identify SGX EPC pages
Date:   Fri,  1 Oct 2021 09:47:19 -0700
Message-Id: <20211001164724.220532-3-tony.luck@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211001164724.220532-1-tony.luck@intel.com>
References: <20210927213452.212470-1-tony.luck@intel.com>
 <20211001164724.220532-1-tony.luck@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

X86 machine check architecture reports a physical address when there
is a memory error. Handling that error requires a method to determine
whether the physical address reported is in any of the areas reserved
for EPC pages by BIOS.

SGX EPC pages do not have Linux "struct page" associated with them.

Keep track of the mapping from ranges of EPC pages to the sections
that contain them using an xarray.

Create a function arch_is_platform_page() that simply reports whether an
address is an EPC page for use elsewhere in the kernel. The ACPI error
injection code needs this function and is typically built as a module,
so export it.

Note that arch_is_platform_page() will be slower than other similar
"what type is this page" functions that can simply check bits in the
"struct page".  If there is some future performance critical user of
this function it may need to be implemented in a more efficient way.

Note also that the current implementation of xarray allocates a few
hundred kilobytes for this usage on a system with 4GB of SGX EPC memory
configured. This isn't ideal, but worth it for the code simplicity.

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 arch/x86/kernel/cpu/sgx/main.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index d18988a46c13..09fa42690ff2 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -20,6 +20,7 @@ struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
 static int sgx_nr_epc_sections;
 static struct task_struct *ksgxd_tsk;
 static DECLARE_WAIT_QUEUE_HEAD(ksgxd_waitq);
+static DEFINE_XARRAY(sgx_epc_address_space);
 
 /*
  * These variables are part of the state of the reclaimer, and must be accessed
@@ -650,6 +651,8 @@ static bool __init sgx_setup_epc_section(u64 phys_addr, u64 size,
 	}
 
 	section->phys_addr = phys_addr;
+	xa_store_range(&sgx_epc_address_space, section->phys_addr,
+		       phys_addr + size - 1, section, GFP_KERNEL);
 
 	for (i = 0; i < nr_pages; i++) {
 		section->pages[i].section = index;
@@ -661,6 +664,12 @@ static bool __init sgx_setup_epc_section(u64 phys_addr, u64 size,
 	return true;
 }
 
+bool arch_is_platform_page(u64 paddr)
+{
+	return !!xa_load(&sgx_epc_address_space, paddr);
+}
+EXPORT_SYMBOL_GPL(arch_is_platform_page);
+
 /**
  * A section metric is concatenated in a way that @low bits 12-31 define the
  * bits 12-31 of the metric and @high bits 0-19 define the bits 32-51 of the
-- 
2.31.1

