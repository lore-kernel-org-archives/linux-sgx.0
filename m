Return-Path: <SRS0=E1/z=DM=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC357C35257
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Oct 2020 03:38:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FBEB207F7
	for <linux-sgx@archiver.kernel.org>; Mon,  5 Oct 2020 03:38:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725852AbgJEDiJ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 4 Oct 2020 23:38:09 -0400
Received: from mga18.intel.com ([134.134.136.126]:22439 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725845AbgJEDiJ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 4 Oct 2020 23:38:09 -0400
IronPort-SDR: 6E4EuIS3SzIfr5N5U2eec1jHZy2viIo5/7svsIchZb+Meaz3+wLn3S8B8jrTV54Au8o9WVDq0Q
 8w0k5/o0hALw==
X-IronPort-AV: E=McAfee;i="6000,8403,9764"; a="151108294"
X-IronPort-AV: E=Sophos;i="5.77,337,1596524400"; 
   d="scan'208";a="151108294"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2020 20:38:08 -0700
IronPort-SDR: BF3VvEOnbdyMbAhe0myD8h5kySZDMjBc7brs4gyK/zZs4oHElqMc/8opKU8bajrO4C6sHW6H7s
 lm9R6GB0c0rg==
X-IronPort-AV: E=Sophos;i="5.77,337,1596524400"; 
   d="scan'208";a="523332029"
Received: from sidorovd-mobl1.ccr.corp.intel.com (HELO localhost) ([10.252.48.68])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Oct 2020 20:38:06 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Haitao Huang <haitao.huang@linux.intel.com>
Subject: [PATCH v2] x86/sgx: Remove checks for platform limits from sgx_validate_secs()
Date:   Mon,  5 Oct 2020 06:38:03 +0300
Message-Id: <20201005033803.158793-1-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Remove from sgx_validate_secs():

	if (secs->miscselect & sgx_misc_reserved_mask ||
	    secs->attributes & sgx_attributes_reserved_mask ||
	    secs->xfrm & sgx_xfrm_reserved_mask)
		return -EINVAL;

SECS can surpass the platform limits because it's the SIGSTRUCT that
defines the limits that are used at run-time.

What SECS does is that it defines the overall limits that must apply for
any platform, i.e. SECS limits and platform limits are orthogonal. They are
not dependent.

Rename sgx_*_reserved_mask as sgx_cpu_* in order to bring some clarity
and separate them from SIGSTRUCT limits.

Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Jethro Beekman <jethro@fortanix.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Suggested-by: Haitao Huang <haitao.huang@linux.intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
v2: Rename sgx_*_reserved_mask as sgx_cpu_*.
 arch/x86/kernel/cpu/sgx/driver.c | 12 ++++++------
 arch/x86/kernel/cpu/sgx/driver.h |  6 +++---
 arch/x86/kernel/cpu/sgx/ioctl.c  | 11 +++--------
 3 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx/driver.c
index e8b6da3d8f58..181c4b5c402c 100644
--- a/arch/x86/kernel/cpu/sgx/driver.c
+++ b/arch/x86/kernel/cpu/sgx/driver.c
@@ -12,9 +12,9 @@
 
 u64 sgx_encl_size_max_32;
 u64 sgx_encl_size_max_64;
-u32 sgx_misc_reserved_mask;
-u64 sgx_attributes_reserved_mask;
-u64 sgx_xfrm_reserved_mask = ~0x3;
+u32 sgx_cpu_misc;
+u64 sgx_cpu_attributes;
+u64 sgx_cpu_xfrm = ~0x3;
 u32 sgx_xsave_size_tbl[64];
 
 static int sgx_open(struct inode *inode, struct file *file)
@@ -166,14 +166,14 @@ int __init sgx_drv_init(void)
 	}
 
 	cpuid_count(SGX_CPUID, 0, &eax, &ebx, &ecx, &edx);
-	sgx_misc_reserved_mask = ~ebx | SGX_MISC_RESERVED_MASK;
+	sgx_cpu_misc = ~ebx | SGX_MISC_RESERVED_MASK;
 	sgx_encl_size_max_64 = 1ULL << ((edx >> 8) & 0xFF);
 	sgx_encl_size_max_32 = 1ULL << (edx & 0xFF);
 
 	cpuid_count(SGX_CPUID, 1, &eax, &ebx, &ecx, &edx);
 
 	attr_mask = (((u64)ebx) << 32) + (u64)eax;
-	sgx_attributes_reserved_mask = ~attr_mask | SGX_ATTR_RESERVED_MASK;
+	sgx_cpu_attributes = ~attr_mask | SGX_ATTR_RESERVED_MASK;
 
 	if (boot_cpu_has(X86_FEATURE_OSXSAVE)) {
 		xfrm_mask = (((u64)edx) << 32) + (u64)ecx;
@@ -184,7 +184,7 @@ int __init sgx_drv_init(void)
 				sgx_xsave_size_tbl[i] = eax + ebx;
 		}
 
-		sgx_xfrm_reserved_mask = ~xfrm_mask;
+		sgx_cpu_xfrm = ~xfrm_mask;
 	}
 
 	ret = misc_register(&sgx_dev_enclave);
diff --git a/arch/x86/kernel/cpu/sgx/driver.h b/arch/x86/kernel/cpu/sgx/driver.h
index fd81b8818600..204866065c2f 100644
--- a/arch/x86/kernel/cpu/sgx/driver.h
+++ b/arch/x86/kernel/cpu/sgx/driver.h
@@ -18,9 +18,9 @@
 
 extern u64 sgx_encl_size_max_32;
 extern u64 sgx_encl_size_max_64;
-extern u32 sgx_misc_reserved_mask;
-extern u64 sgx_attributes_reserved_mask;
-extern u64 sgx_xfrm_reserved_mask;
+extern u32 sgx_cpu_misc;
+extern u64 sgx_cpu_attributes;
+extern u64 sgx_cpu_xfrm;
 extern u32 sgx_xsave_size_tbl[64];
 
 extern const struct file_operations sgx_provision_fops;
diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 6b3cc8483008..373ffde3f8c5 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -86,11 +86,6 @@ static int sgx_validate_secs(const struct sgx_secs *secs)
 	if (secs->base & (secs->size - 1))
 		return -EINVAL;
 
-	if (secs->miscselect & sgx_misc_reserved_mask ||
-	    secs->attributes & sgx_attributes_reserved_mask ||
-	    secs->xfrm & sgx_xfrm_reserved_mask)
-		return -EINVAL;
-
 	if (secs->size > max_size)
 		return -EINVAL;
 
@@ -611,15 +606,15 @@ static int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct *sigstruct,
 	 * bit on.
 	 */
 	if (sigstruct->body.attributes & sigstruct->body.attributes_mask &
-	    sgx_attributes_reserved_mask)
+	    sgx_cpu_attributes)
 		return -EINVAL;
 
 	if (sigstruct->body.miscselect & sigstruct->body.misc_mask &
-	    sgx_misc_reserved_mask)
+	    sgx_cpu_misc)
 		return -EINVAL;
 
 	if (sigstruct->body.xfrm & sigstruct->body.xfrm_mask &
-	    sgx_xfrm_reserved_mask)
+	    sgx_cpu_xfrm)
 		return -EINVAL;
 
 	ret = sgx_get_key_hash(sigstruct->modulus, mrsigner);
-- 
2.25.1

