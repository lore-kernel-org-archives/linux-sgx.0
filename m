Return-Path: <SRS0=Vmdy=O6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B121C43387
	for <linux-sgx@archiver.kernel.org>; Fri, 21 Dec 2018 23:13:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4829121927
	for <linux-sgx@archiver.kernel.org>; Fri, 21 Dec 2018 23:13:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392206AbeLUXN7 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 21 Dec 2018 18:13:59 -0500
Received: from mga01.intel.com ([192.55.52.88]:11643 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390789AbeLUXN7 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 21 Dec 2018 18:13:59 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Dec 2018 15:13:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,383,1539673200"; 
   d="scan'208";a="120338426"
Received: from ncanderx-mobl.ger.corp.intel.com (HELO localhost) ([10.249.254.238])
  by FMSMGA003.fm.intel.com with ESMTP; 21 Dec 2018 15:13:50 -0800
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     x86@kernel.org, linux-sgx@vger.kernel.org
Cc:     akpm@linux-foundation.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v18 12/25] x86/sgx: Add definitions for SGX's CPUID leaf and variable sub-leafs
Date:   Sat, 22 Dec 2018 01:11:41 +0200
Message-Id: <20181221231154.6120-13-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181221231154.6120-1-jarkko.sakkinen@linux.intel.com>
References: <20181221231154.6120-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

SGX defines its own CPUID leaf, 0x12, along with a variable number of
sub-leafs.  Sub-leafs 0 and 1 are always available if SGX is supported
and enumerate various SGX features, e.g. instruction sets and enclave
capabilities.  Sub-leafs 2+ are variable, both in their existence and
in what they enumerate.  Bits 3:0 of EAX report the sub-leaf type,
with the remaining bits in EAX, EBX, ECX and EDX being type-specific.
Currently, the only known sub-leaf type enumerates an EPC section.  An
EPC section is simply a range of EPC memory available to software.
The "list" of varaible SGX sub-leafs is NULL-terminated, i.e. software
is expected to query CPUID until an invalid sub-leaf is encountered.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/sgx_arch.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/x86/include/asm/sgx_arch.h b/arch/x86/include/asm/sgx_arch.h
index d4c57154e6e6..188243e3eee1 100644
--- a/arch/x86/include/asm/sgx_arch.h
+++ b/arch/x86/include/asm/sgx_arch.h
@@ -11,6 +11,21 @@
 #include <linux/types.h>
 #include <uapi/asm/sgx_errno.h>
 
+#define SGX_CPUID				0x12
+#define SGX_CPUID_FIRST_VARIABLE_SUB_LEAF	2
+
+/**
+ * enum sgx_sub_leaf_types - SGX CPUID variable sub-leaf types
+ * %SGX_CPUID_SUB_LEAF_INVALID:		Indicates this sub-leaf is invalid.
+ * %SGX_CPUID_SUB_LEAF_EPC_SECTION:	Sub-leaf enumerates an EPC section.
+ * %SGX_CPUID_SUB_LEAF_TYPE_MASK:	Mask for bits containing the type.
+ */
+enum sgx_sub_leaf_types {
+	SGX_CPUID_SUB_LEAF_INVALID	= 0x0,
+	SGX_CPUID_SUB_LEAF_EPC_SECTION	= 0x1,
+	SGX_CPUID_SUB_LEAF_TYPE_MASK	= GENMASK(3, 0),
+};
+
 /**
  * enum sgx_encls_leaves - ENCLS leaf functions
  * %SGX_ECREATE:	Create an enclave.
-- 
2.19.1

