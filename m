Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8CB1C4332F
	for <linux-sgx@archiver.kernel.org>; Fri,  1 Apr 2022 14:24:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346813AbiDAO0a (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 1 Apr 2022 10:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241890AbiDAO03 (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 1 Apr 2022 10:26:29 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0013511BE4E
        for <linux-sgx@vger.kernel.org>; Fri,  1 Apr 2022 07:24:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648823079; x=1680359079;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=8Ud/8FKTwZmPM06bP1l56ClVaV3l7zG/fPqY+plYj84=;
  b=kz2ZhikQ1PTsGquK3cnBJCqwQzQD+STndYB/b9f1zyDxSJSx4obNknmg
   AP5V+ryFt5qEp6p9WjUVM7snvIpO/ilhozwlwyaTSUIbe+KHk92Bh78zD
   gcRMHZDKm5z2rJjd7LzzVz6xr6WtOqiwSPLGS+/7tUXd3oMlu8z7uytKf
   kawqO5KfDFogjw56MGBKZ7AtcQnrimY8sS8UX9uBh6FKlvXGiDe++43Zg
   C7hxCBdgXEa8ySvPK9gwpCQcj8SiaoIGpKZinIfO/DOx5GqKhZdK760ee
   MtW79PlXF832KaNGDt9VdYlfY51Wpd/sH1gxQDJ/6gIRQo9jESZ9pCw/b
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10304"; a="240739919"
X-IronPort-AV: E=Sophos;i="5.90,227,1643702400"; 
   d="scan'208";a="240739919"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2022 07:24:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,227,1643702400"; 
   d="scan'208";a="695908415"
Received: from cathy-vostro-3670.bj.intel.com ([10.238.156.128])
  by fmsmga001.fm.intel.com with ESMTP; 01 Apr 2022 07:24:37 -0700
From:   Cathy Zhang <cathy.zhang@intel.com>
To:     linux-sgx@vger.kernel.org, x86@kernel.org
Cc:     jarkko@kernel.org, reinette.chatre@intel.com,
        dave.hansen@intel.com, ashok.raj@intel.com, cathy.zhang@intel.com
Subject: [RFC PATCH v3 09/10] x86/cpu: Call ENCLS[EUPDATESVN] procedure in microcode update
Date:   Fri,  1 Apr 2022 22:24:08 +0800
Message-Id: <20220401142409.26215-10-cathy.zhang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220401142409.26215-1-cathy.zhang@intel.com>
References: <20220401142409.26215-1-cathy.zhang@intel.com>
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
Changes since v1:
 - Remove the sysfs file svnupdate. (Thomas Gleixner, Dave Hansen)
 - Let late microcode load path call ENCLS[EUPDATESVN] procedure
   directly. (Borislav Petkov)
 - Redefine update_cpusvn_intel() to return void instead of int.
---
 arch/x86/include/asm/microcode.h |  5 +++++
 arch/x86/include/asm/sgx.h       |  5 +++++
 arch/x86/kernel/cpu/common.c     |  9 +++++++++
 arch/x86/kernel/cpu/sgx/main.c   | 12 ++++++++++++
 4 files changed, 31 insertions(+)

diff --git a/arch/x86/include/asm/microcode.h b/arch/x86/include/asm/microcode.h
index d6bfdfb0f0af..1ba66b9fe198 100644
--- a/arch/x86/include/asm/microcode.h
+++ b/arch/x86/include/asm/microcode.h
@@ -3,6 +3,7 @@
 #define _ASM_X86_MICROCODE_H
 
 #include <asm/cpu.h>
+#include <asm/sgx.h>
 #include <linux/earlycpio.h>
 #include <linux/initrd.h>
 
@@ -137,4 +138,8 @@ static inline void load_ucode_ap(void)				{ }
 static inline void reload_early_microcode(void)			{ }
 #endif
 
+#ifndef update_cpusvn_intel
+static inline void update_cpusvn_intel(void) {}
+#endif
+
 #endif /* _ASM_X86_MICROCODE_H */
diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
index 74bcb6841a4b..5867f5a78d13 100644
--- a/arch/x86/include/asm/sgx.h
+++ b/arch/x86/include/asm/sgx.h
@@ -409,4 +409,9 @@ int sgx_virt_einit(void __user *sigstruct, void __user *token,
 int sgx_set_attribute(unsigned long *allowed_attributes,
 		      unsigned int attribute_fd);
 
+#ifdef CONFIG_X86_SGX
+void update_cpusvn_intel(void);
+#define update_cpusvn_intel update_cpusvn_intel
+#endif
+
 #endif /* _ASM_X86_SGX_H */
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 7b8382c11788..f53fd877ba0d 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -59,6 +59,7 @@
 #include <asm/cpu_device_id.h>
 #include <asm/uv/uv.h>
 #include <asm/sigframe.h>
+#include <asm/sgx.h>
 
 #include "cpu.h"
 
@@ -2086,6 +2087,14 @@ void microcode_check(void)
 
 	perf_check_microcode();
 
+	/*
+	 * SGX related microcode update requires EUPDATESVN to update CPUSVN, which
+	 * will destroy all enclaves to ensure EPC is not in use. If SGX is configured
+	 * and EUPDATESVN is supported, call the EUPDATESVN procecure.
+	 */
+	if (IS_ENABLED(CONFIG_X86_SGX) && (cpuid_eax(SGX_CPUID) & SGX_CPUID_EUPDATESVN))
+		update_cpusvn_intel();
+
 	/* Reload CPUID max function as it might've changed. */
 	info.cpuid_level = cpuid_eax(0);
 
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 784780314762..20800c543110 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -1409,3 +1409,15 @@ static int sgx_updatesvn(void)
 
 	return ret;
 }
+
+void update_cpusvn_intel(void)
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

