Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C251C4332F
	for <linux-sgx@archiver.kernel.org>; Fri, 20 May 2022 10:41:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239447AbiETKlc (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 20 May 2022 06:41:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348276AbiETKlX (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 20 May 2022 06:41:23 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBB0917E16
        for <linux-sgx@vger.kernel.org>; Fri, 20 May 2022 03:41:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653043281; x=1684579281;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=Den95mSV36P4lwnzOdWK489sYzTnbE6vGSz244vdruc=;
  b=msjcr4KirF8UYx4dFDIM3LA5Gi+eo4WZW95Yv/grJWgmAm/QAPnw7gpF
   v8e5WCG9/1oliA1M7pr4FDH79UbB0G6D8Ijoiegwfg6oiO0ALRY04+BlP
   E04wD3o7mSWywgrajkXjAotifKTuMQtZpZXYjSFcgY8d6Ro5D/r8SIezo
   31ni/ANQxWpm+1qmFPgU5Gbap2qp0VsgHEx0ZhuMPY+Yg2J8U7yCjYS3a
   MD4GVix0Rnhe72rNGquZPnknbH7dCMAwpnIyPRuzqhwMXHpPJlkphsjGi
   pqQn8ugusBHZUcKcQAm4TDYpLm9v7ERjCV7XIElm78fYWvN+IKej0cCf4
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10352"; a="271387005"
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="271387005"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2022 03:41:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,238,1647327600"; 
   d="scan'208";a="715471058"
Received: from cathy-vostro-3670.bj.intel.com ([10.238.156.128])
  by fmsmga001.fm.intel.com with ESMTP; 20 May 2022 03:41:18 -0700
From:   Cathy Zhang <cathy.zhang@intel.com>
To:     linux-sgx@vger.kernel.org, x86@kernel.org
Cc:     jarkko@kernel.org, reinette.chatre@intel.com,
        dave.hansen@intel.com, ashok.raj@intel.com, cathy.zhang@intel.com,
        chao.p.peng@linux.intel.com, yang.zhong@intel.com
Subject: [PATCH v5 8/9] x86/cpu: Call ENCLS[EUPDATESVN] procedure in microcode update
Date:   Fri, 20 May 2022 18:39:03 +0800
Message-Id: <20220520103904.1216-9-cathy.zhang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220520103904.1216-1-cathy.zhang@intel.com>
References: <20220520103904.1216-1-cathy.zhang@intel.com>
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
Changes since v4:
 - Remove #include <asm/sgx.h> from microcode.h which is not needed
   in this file. (Borislav Petkov)

Changes since v3:
 - Rename update_cpusvn_intel() as sgx_update_cpusvn_intel().
   (Dave Hansen)
 - Refine the comments when sgx_update_cpusvn_intel is called by
   microcode_check(). (Borislav Petkov, Dave Hansen)
 - Define both the 'static inline' stub *and* the declaration for
   sgx_update_cpusvn_intel() in sgx.h. (Dave Hansen)

Changes since v1:
 - Remove the sysfs file svnupdate. (Thomas Gleixner, Dave Hansen)
 - Let late microcode load path call ENCLS[EUPDATESVN] procedure
   directly. (Borislav Petkov)
 - Redefine update_cpusvn_intel() to return void instead of int.
---
 arch/x86/include/asm/sgx.h     |  6 ++++++
 arch/x86/kernel/cpu/common.c   | 10 ++++++++++
 arch/x86/kernel/cpu/sgx/main.c | 12 ++++++++++++
 3 files changed, 28 insertions(+)

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
index e342ae4db3c4..a50e0e183139 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -59,6 +59,7 @@
 #include <asm/cpu_device_id.h>
 #include <asm/uv/uv.h>
 #include <asm/sigframe.h>
+#include <asm/sgx.h>
 #include <asm/traps.h>
 
 #include "cpu.h"
@@ -2224,6 +2225,15 @@ void microcode_check(void)
 
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
index 43dd2b34e040..0f541d01e561 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -1403,3 +1403,15 @@ static int sgx_updatesvn(void)
 
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

