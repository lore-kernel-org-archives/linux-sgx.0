Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC097C433F5
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Mar 2022 10:40:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbiCIKlg (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 9 Mar 2022 05:41:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230525AbiCIKlf (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Wed, 9 Mar 2022 05:41:35 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F048541B8
        for <linux-sgx@vger.kernel.org>; Wed,  9 Mar 2022 02:40:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646822437; x=1678358437;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=6zGVM1xNzAv8m/wTQa4ow2Pfh/GVaAUDGpn1MV9z7C0=;
  b=Pc7eSKBwSTtMwvn1dTKNZ+HJH+bwJM+HljyvTp/llUE+qdW06f+CGohp
   CUD+Ul3mHm6vJfFPDaCv68GhgW2tl9EWfFJUGtu2t15ffM1A+exCooEE4
   hVzXgZwXuy4A1Y4pS0YfOBVriemcPKWJwf8m3pbQ8HjQ0vMOsAMt0B+WA
   HyVMpfVn0NYmgTfoDGYnEYI+3ctQKf2Lf/L+2/b/ECnv6LnikBSjeNpn8
   bu9psLcSl0e6p3KiNa22PLSzs4wkkUooGzUVNEnNeyLywRWNP3THMMiZl
   FGB64qrJstN042cYCpvE0TBFcPU6PzYiffzTLxCFjxdrPIgR2dKy9yA5a
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10280"; a="341373595"
X-IronPort-AV: E=Sophos;i="5.90,167,1643702400"; 
   d="scan'208";a="341373595"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2022 02:40:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,167,1643702400"; 
   d="scan'208";a="547582941"
Received: from cathy-vostro-3670.bj.intel.com ([10.238.156.128])
  by fmsmga007.fm.intel.com with ESMTP; 09 Mar 2022 02:40:35 -0800
From:   Cathy Zhang <cathy.zhang@intel.com>
To:     linux-sgx@vger.kernel.org, x86@kernel.org
Cc:     dave.hansen@intel.com, cathy.zhang@intel.com
Subject: [RFC PATCH 09/11] x86/microcode: Expose EUPDATESVN procedure via sysfs
Date:   Wed,  9 Mar 2022 18:40:48 +0800
Message-Id: <20220309104050.18207-10-cathy.zhang@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220309104050.18207-1-cathy.zhang@intel.com>
References: <20220309104050.18207-1-cathy.zhang@intel.com>
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
 arch/x86/include/asm/microcode.h     |  5 ++++
 arch/x86/include/asm/sgx.h           |  5 ++++
 arch/x86/kernel/cpu/microcode/core.c | 44 ++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/sgx/main.c       | 40 +++++++++++++++++++++++++
 4 files changed, 94 insertions(+)

diff --git a/arch/x86/include/asm/microcode.h b/arch/x86/include/asm/microcode.h
index d6bfdfb0f0af..233e8cada691 100644
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
+static inline int update_cpusvn_intel(void) { return -EINVAL; }
+#endif
+
 #endif /* _ASM_X86_MICROCODE_H */
diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
index d5942d0848ec..72b853fedf0c 100644
--- a/arch/x86/include/asm/sgx.h
+++ b/arch/x86/include/asm/sgx.h
@@ -412,4 +412,9 @@ int sgx_virt_einit(void __user *sigstruct, void __user *token,
 int sgx_set_attribute(unsigned long *allowed_attributes,
 		      unsigned int attribute_fd);
 
+#ifdef CONFIG_X86_SGX
+int update_cpusvn_intel(void);
+#define update_cpusvn_intel update_cpusvn_intel
+#endif
+
 #endif /* _ASM_X86_SGX_H */
diff --git a/arch/x86/kernel/cpu/microcode/core.c b/arch/x86/kernel/cpu/microcode/core.c
index f955d25076ba..3a78a6fa0787 100644
--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -39,6 +39,7 @@
 #include <asm/processor.h>
 #include <asm/cmdline.h>
 #include <asm/setup.h>
+#include <asm/sgx.h>
 
 #define DRIVER_VERSION	"2.2"
 
@@ -803,6 +804,33 @@ static int mc_cpu_down_prep(unsigned int cpu)
 	return 0;
 }
 
+static ssize_t svnupdate_store(struct device *dev,
+			    struct device_attribute *attr,
+			    const char *buf, size_t size)
+{
+	unsigned long val;
+	ssize_t ret = 0;
+
+	ret = kstrtoul(buf, 0, &val);
+	if (ret)
+		return ret;
+
+	if (val != 1)
+		return size;
+
+	mutex_lock(&microcode_mutex);
+
+	ret = update_cpusvn_intel();
+
+	mutex_unlock(&microcode_mutex);
+
+	if (ret == 0)
+		ret = size;
+
+	return ret;
+}
+static DEVICE_ATTR_WO(svnupdate);
+
 static struct attribute *cpu_root_microcode_attrs[] = {
 	&dev_attr_reload.attr,
 	NULL
@@ -856,6 +884,22 @@ static int __init microcode_init(void)
 		goto out_driver;
 	}
 
+	/*
+	 * If SGX driver is enabled, and CPUID bit for EUPDATESVN
+	 * is on, allow svnupdate to occur.
+	 */
+	if (IS_ENABLED(CONFIG_X86_SGX) &&
+	    (cpuid_eax(SGX_CPUID) & SGX_CPUID_EUPDATESVN)) {
+		error = sysfs_add_file_to_group(&cpu_subsys.dev_root->kobj,
+						&dev_attr_svnupdate.attr,
+						"microcode");
+
+		if (error) {
+			pr_err("Error creating microcode svnupdate file!\n");
+			goto out_ucode_group;
+		}
+	}
+
 	error = microcode_dev_init();
 	if (error)
 		goto out_ucode_group;
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 7a464c8ac959..431a19e0ea41 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -1359,3 +1359,43 @@ static int sgx_updatesvn(void)
 
 	return ret;
 }
+
+int update_cpusvn_intel(void)
+{
+	int ret;
+
+	sgx_lock_epc();
+	ret = sgx_zap_pages();
+	if (ret)
+		goto out;
+
+	ret = sgx_updatesvn();
+
+	switch (ret) {
+	case 0:
+	case SGX_NO_UPDATE:
+		ret = 0;
+		break;
+	case SGX_EPC_NOT_READY:
+		ret = -EBUSY;
+		break;
+	case SGX_INSUFFICIENT_ENTROPY:
+		pr_info("CPUSVN update is failed due to Insufficient entropy in RNG,"
+			"please try it later.\n");
+		ret = -EINVAL;
+		break;
+	case SGX_EPC_PAGE_CONFLICT:
+		pr_info("CPUSVN update is failed due to concurrency violation, please"
+			 "stop running any other ENCLS leaf and try it later.\n");
+		ret = -EINVAL;
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+out:
+	sgx_unlock_epc();
+
+	return ret;
+}
-- 
2.17.1

