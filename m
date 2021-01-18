Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25F01C433E0
	for <linux-sgx@archiver.kernel.org>; Mon, 18 Jan 2021 03:28:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8AA4224B1
	for <linux-sgx@archiver.kernel.org>; Mon, 18 Jan 2021 03:28:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731642AbhARD2s (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 17 Jan 2021 22:28:48 -0500
Received: from mga04.intel.com ([192.55.52.120]:7981 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731646AbhARD2r (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 17 Jan 2021 22:28:47 -0500
IronPort-SDR: SF12W9Gf8CH+slz3lmh6hpDwUfGKZJpBVaAdzcBfgZvn/dNAUdiXajVIDcY62JoMg6x4IlZkFu
 YsrPPN9KWS8g==
X-IronPort-AV: E=McAfee;i="6000,8403,9867"; a="176181392"
X-IronPort-AV: E=Sophos;i="5.79,355,1602572400"; 
   d="scan'208";a="176181392"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2021 19:28:07 -0800
IronPort-SDR: uqOavVeQR26pbvbgyLnFeREj4UOaPqocmgCb+2uorgPZYA2+c3TeT0PDRBY5ah3cbwGdbD9r3F
 vKvqr+Reofcw==
X-IronPort-AV: E=Sophos;i="5.79,355,1602572400"; 
   d="scan'208";a="573150947"
Received: from amrahman-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.252.142.253])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2021 19:28:03 -0800
From:   Kai Huang <kai.huang@intel.com>
To:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org
Cc:     seanjc@google.com, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, haitao.huang@intel.com, pbonzini@redhat.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jethro@fortanix.com, Kai Huang <kai.huang@intel.com>
Subject: [RFC PATCH v2 09/26] x86/sgx: Move ENCLS leaf definitions to sgx_arch.h
Date:   Mon, 18 Jan 2021 16:27:50 +1300
Message-Id: <5a23890a36c31896addfd41bae9211545024f8ba.1610935432.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1610935432.git.kai.huang@intel.com>
References: <cover.1610935432.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Move the ENCLS leaf definitions to sgx_arch.h so that they can be used
by KVM.  And because they're architectural.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Acked-by: Dave Hansen <dave.hansen@intel.com>
Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/include/asm/sgx_arch.h | 15 +++++++++++++++
 arch/x86/kernel/cpu/sgx/encls.h | 15 ---------------
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/sgx_arch.h b/arch/x86/include/asm/sgx_arch.h
index 56b0f8ae3f92..38ef7ce3d3c7 100644
--- a/arch/x86/include/asm/sgx_arch.h
+++ b/arch/x86/include/asm/sgx_arch.h
@@ -22,6 +22,21 @@
 /* The bitmask for the EPC section type. */
 #define SGX_CPUID_EPC_MASK	GENMASK(3, 0)
 
+enum sgx_encls_function {
+	ECREATE	= 0x00,
+	EADD	= 0x01,
+	EINIT	= 0x02,
+	EREMOVE	= 0x03,
+	EDGBRD	= 0x04,
+	EDGBWR	= 0x05,
+	EEXTEND	= 0x06,
+	ELDU	= 0x08,
+	EBLOCK	= 0x09,
+	EPA	= 0x0A,
+	EWB	= 0x0B,
+	ETRACK	= 0x0C,
+};
+
 /**
  * enum sgx_return_code - The return code type for ENCLS, ENCLU and ENCLV
  * %SGX_NOT_TRACKED:		Previous ETRACK's shootdown sequence has not
diff --git a/arch/x86/kernel/cpu/sgx/encls.h b/arch/x86/kernel/cpu/sgx/encls.h
index 443188fe7e70..be5c49689980 100644
--- a/arch/x86/kernel/cpu/sgx/encls.h
+++ b/arch/x86/kernel/cpu/sgx/encls.h
@@ -11,21 +11,6 @@
 #include <asm/traps.h>
 #include "sgx.h"
 
-enum sgx_encls_function {
-	ECREATE	= 0x00,
-	EADD	= 0x01,
-	EINIT	= 0x02,
-	EREMOVE	= 0x03,
-	EDGBRD	= 0x04,
-	EDGBWR	= 0x05,
-	EEXTEND	= 0x06,
-	ELDU	= 0x08,
-	EBLOCK	= 0x09,
-	EPA	= 0x0A,
-	EWB	= 0x0B,
-	ETRACK	= 0x0C,
-};
-
 /**
  * ENCLS_FAULT_FLAG - flag signifying an ENCLS return code is a trapnr
  *
-- 
2.29.2

