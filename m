Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 104C9C433EF
	for <linux-sgx@archiver.kernel.org>; Fri, 17 Sep 2021 21:38:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED65E60F51
	for <linux-sgx@archiver.kernel.org>; Fri, 17 Sep 2021 21:38:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242502AbhIQVkO (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 17 Sep 2021 17:40:14 -0400
Received: from mga07.intel.com ([134.134.136.100]:54592 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242239AbhIQVkN (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 17 Sep 2021 17:40:13 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10110"; a="286563053"
X-IronPort-AV: E=Sophos;i="5.85,302,1624345200"; 
   d="scan'208";a="286563053"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2021 14:38:50 -0700
X-IronPort-AV: E=Sophos;i="5.85,302,1624345200"; 
   d="scan'208";a="546646814"
Received: from agluck-desk2.sc.intel.com ([10.3.52.146])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Sep 2021 14:38:50 -0700
From:   Tony Luck <tony.luck@intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@intel.com>
Cc:     Cathy Zhang <cathy.zhang@intel.com>, linux-sgx@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Tony Luck <tony.luck@intel.com>
Subject: [PATCH v5 6/7] x86/sgx: Add hook to error injection address validation
Date:   Fri, 17 Sep 2021 14:38:35 -0700
Message-Id: <20210917213836.175138-7-tony.luck@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210917213836.175138-1-tony.luck@intel.com>
References: <20210827195543.1667168-1-tony.luck@intel.com>
 <20210917213836.175138-1-tony.luck@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

SGX reserved memory does not appear in the standard address maps.

Add hook to call into the SGX code to check if an address is located
in SGX memory.

There are other challenges in injecting errors into SGX. Update the
documentation with a sequence of operations to inject.

Signed-off-by: Tony Luck <tony.luck@intel.com>
---
 .../firmware-guide/acpi/apei/einj.rst         | 19 +++++++++++++++++++
 drivers/acpi/apei/einj.c                      |  3 ++-
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/Documentation/firmware-guide/acpi/apei/einj.rst b/Documentation/firmware-guide/acpi/apei/einj.rst
index c042176e1707..55e2331a6438 100644
--- a/Documentation/firmware-guide/acpi/apei/einj.rst
+++ b/Documentation/firmware-guide/acpi/apei/einj.rst
@@ -181,5 +181,24 @@ You should see something like this in dmesg::
   [22715.834759] EDAC sbridge MC3: PROCESSOR 0:306e7 TIME 1422553404 SOCKET 0 APIC 0
   [22716.616173] EDAC MC3: 1 CE memory read error on CPU_SrcID#0_Channel#0_DIMM#0 (channel:0 slot:0 page:0x12345 offset:0x0 grain:32 syndrome:0x0 -  area:DRAM err_code:0001:0090 socket:0 channel_mask:1 rank:0)
 
+Special notes for injection into SGX enclaves:
+
+There may be a separate BIOS setup option to enable SGX injection.
+
+The injection process consists of setting some special memory controller
+trigger that will inject the error on the next write to the target
+address. But the h/w prevents any software outside of an SGX enclave
+from accessing enclave pages (even BIOS SMM mode).
+
+The following sequence can be used:
+  1) Determine physical address of enclave page
+  2) Use "notrigger=1" mode to inject (this will setup
+     the injection address, but will not actually inject)
+  3) Enter the enclave
+  4) Store data to the virtual address matching physical address from step 1
+  5) Execute CLFLUSH for that virtual address
+  6) Spin delay for 250ms
+  7) Read from the virtual address. This will trigger the error
+
 For more information about EINJ, please refer to ACPI specification
 version 4.0, section 17.5 and ACPI 5.0, section 18.6.
diff --git a/drivers/acpi/apei/einj.c b/drivers/acpi/apei/einj.c
index 2882450c443e..67c335baad52 100644
--- a/drivers/acpi/apei/einj.c
+++ b/drivers/acpi/apei/einj.c
@@ -544,7 +544,8 @@ static int einj_error_inject(u32 type, u32 flags, u64 param1, u64 param2,
 	    ((region_intersects(base_addr, size, IORESOURCE_SYSTEM_RAM, IORES_DESC_NONE)
 				!= REGION_INTERSECTS) &&
 	     (region_intersects(base_addr, size, IORESOURCE_MEM, IORES_DESC_PERSISTENT_MEMORY)
-				!= REGION_INTERSECTS)))
+				!= REGION_INTERSECTS) &&
+	     !arch_is_platform_page(base_addr)))
 		return -EINVAL;
 
 inject:
-- 
2.31.1

