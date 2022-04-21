Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43B59C4332F
	for <linux-sgx@archiver.kernel.org>; Thu, 21 Apr 2022 11:05:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388699AbiDULIi (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 21 Apr 2022 07:08:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388807AbiDULHw (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 21 Apr 2022 07:07:52 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 885592F004
        for <linux-sgx@vger.kernel.org>; Thu, 21 Apr 2022 04:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650539084; x=1682075084;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=5UZQOP41k04KXqjGY+XF9VRmCK0/zWpd1s1rgX0eZ50=;
  b=e6boCFVoMwhVf2MpkxGmm0xYCDeaeVl/YZE2ftf66HqfX1QxCeCq5VLM
   irK9+e+iPyMNYy1DMFHYJc5oB/s9BjXMUOkv4LPAfeSpaLE/R9BZ71/E6
   N+npUn64OiT9w4Dnz96z5SkIKusT9cP2oReQtNJifa+nyXI/WDWN+Lm4U
   MOedXC4aGJNMjjOGykmn7CqL0fiTjolMuP0GZXMBfnD+i6rfoWZ1EkQJ1
   hA4CdLYHdngIGd3GxJh9NICiTRqbUdtzqKyIkICu1VekXfav0GpvjCcaB
   ArtzJ1jm4Bv5Kf17W+gBUFxyMDonxu3u1UZRSVqrhd+JsyU+AiFsOZ+e1
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10323"; a="324759113"
X-IronPort-AV: E=Sophos;i="5.90,278,1643702400"; 
   d="scan'208";a="324759113"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 04:04:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,278,1643702400"; 
   d="scan'208";a="703039248"
Received: from cathy-vostro-3670.bj.intel.com ([10.238.156.128])
  by fmsmga001.fm.intel.com with ESMTP; 21 Apr 2022 04:04:39 -0700
From:   Cathy Zhang <cathy.zhang@intel.com>
To:     linux-sgx@vger.kernel.org, x86@kernel.org
Cc:     jarkko@kernel.org, reinette.chatre@intel.com,
        dave.hansen@intel.com, ashok.raj@intel.com, cathy.zhang@intel.com,
        chao.p.peng@intel.com, yang.zhong@intel.com
Subject: [PATCH v4 8/9] x86/cpu: Call ENCLS[EUPDATESVN] procedure in microcode update
Date:   Thu, 21 Apr 2022 19:03:25 +0800
Message-Id: <20220421110326.856-9-cathy.zhang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220421110326.856-1-cathy.zhang@intel.com>
References: <20220421110326.856-1-cathy.zhang@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

EUPDATESVN is the SGX instruction which allows enclave attestation
to include information about updated microcode without a reboot.

Microcode updates which affect SGX require two phases:

1. Do the main microcode update
2. Make the new CPUSVN available for enclave attestation via
   EUPDATESVN.

Before a EUPDATESVN can succeed, all enclave pages (EPC) must be
marked as unused in the SGX metadata (EPCM). This operation destroys
all preexisting SGX enclave data and metadata. This is by design and
mitigates the impact of vulnerabilities that may have compromised
enclaves or the SGX hardware itself prior to the update.

Signed-off-by: Cathy Zhang <cathy.zhang@intel.com>

---
Changes since v3:
 - Rename update_cpusvn_intel() as sgx_update_cpusvn_intel().
   (Dave Hansen)
 - Refine the comments when sgx_update_cpusvn_intel() is called by
   microcode_check(). (Borislav Petkov, Dave Hansen)
 - Define both the 'static inline' stub *and* the declaration for
   sgx_update_cpusvn_intel() in sgx.h. (Dave Hansen)

Changes since v1:
 - Remove the sysfs file svnupdate. (Thomas Gleixner, Dave Hansen)
 - Let late microcode load path call ENCLS[EUPDATESVN] procedure
   directly. (Borislav Petkov)
 - Redefine update_cpusvn_intel() to return void instead of int.
---
 arch/x86/include/asm/microcode.h |  1 +
 arch/x86/include/asm/sgx.h       |  6 ++++++
 arch/x86/kernel/cpu/common.c     | 10 ++++++++++
 arch/x86/kernel/cpu/sgx/main.c   | 12 ++++++++++++
 4 files changed, 29 insertions(+)

diff --git a/arch/x86/include/asm/microcode.h b/arch/x86/include/asm/microcode.h
index d6bfdfb0f0af..ec12392af371 100644
--- a/arch/x86/include/asm/microcode.h
+++ b/arch/x86/include/asm/microcode.h
@@ -3,6 +3,7 @@
 #define _ASM_X86_MICROCODE_H
 
 #include <asm/cpu.h>
+#include <asm/sgx.h>
 #include <linux/earlycpio.h>
 #include <linux/initrd.h>
 
diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
index 74bcb6841a4b..1321670a6338 100644
--- a/arch/x86/include/asm/sgx.h
+++ b/arch/x86/include/asm/sgx.h
@@ -409,4 +409,10 @@ int sgx_virt_einit(void __user *sigstruct, void __user *token,
 int sgx_set_attribute(unsigned long *allowed_attributes,
 		      unsigned int attribute_fd);
 
+#ifdef CONFIG_X86_SGX
+extern void sgx_update_cpusvn_intel(void);
+#else
+static inline void sgx_update_cpusvn_intel(void) {}
+#endif
+
 #endif /* _ASM_X86_SGX_H */
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 7b8382c11788..41bed20b586d 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -59,6 +59,7 @@
 #include <asm/cpu_device_id.h>
 #include <asm/uv/uv.h>
 #include <asm/sigframe.h>
+#include <asm/sgx.h>
 
 #include "cpu.h"
 
@@ -2086,6 +2087,15 @@ void microcode_check(void)
 
 	perf_check_microcode();
 
+	/*
+	 * SGX attestation incorporates the microcode versions of all processors
+	 * on the system and is affected by microcode updates. So, update SGX
+	 * attestation metric (called CPUSVN) to ensure enclaves attest to the
+	 * new version after microcode update.
+	 */
+	if (IS_ENABLED(CONFIG_X86_SGX) && (cpuid_eax(SGX_CPUID) & SGX_CPUID_EUPDATESVN))
+		sgx_update_cpusvn_intel();
+
 	/* Reload CPUID max function as it might've changed. */
 	info.cpuid_level = cpuid_eax(0);
 
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index fbb093c9fe1a..20be96a79cc1 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -1409,3 +1409,15 @@ static int sgx_updatesvn(void)
 
 	return ret;
 }
+
+void sgx_update_cpusvn_intel(void)
+{
+	sgx_lock_epc();
+	if (sgx_zap_pages())
+		goto out;
+
+	sgx_updatesvn();
+
+out:
+	sgx_unlock_epc();
+}
-- 
2.17.1

