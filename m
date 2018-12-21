Return-Path: <SRS0=Vmdy=O6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A4F8C43387
	for <linux-sgx@archiver.kernel.org>; Fri, 21 Dec 2018 23:13:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D83D621927
	for <linux-sgx@archiver.kernel.org>; Fri, 21 Dec 2018 23:13:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390892AbeLUXN2 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 21 Dec 2018 18:13:28 -0500
Received: from mga11.intel.com ([192.55.52.93]:21116 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390789AbeLUXN2 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 21 Dec 2018 18:13:28 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Dec 2018 15:13:28 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,383,1539673200"; 
   d="scan'208";a="120338370"
Received: from ncanderx-mobl.ger.corp.intel.com (HELO localhost) ([10.249.254.238])
  by FMSMGA003.fm.intel.com with ESMTP; 21 Dec 2018 15:13:21 -0800
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     x86@kernel.org, linux-sgx@vger.kernel.org
Cc:     akpm@linux-foundation.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v18 09/25] x86/sgx: Define SGX1 and SGX2 ENCLS leafs
Date:   Sat, 22 Dec 2018 01:11:38 +0200
Message-Id: <20181221231154.6120-10-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181221231154.6120-1-jarkko.sakkinen@linux.intel.com>
References: <20181221231154.6120-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

ENCLS, a.k.a. Enclave System instruction, is an umbrella instruction
for a variety of privileged SGX functions.  The ENCLS function to be
executed is specified in EAX, a la GETSEC of SMX/TXT fame.  Leafs may
use additional registers for function-specific operands.  ENCLS also
introduces its own set of error codes that (some) leafs use to return
pass/fail information to software.  Leafs that return an error code
also modify RFLAGS.  And finally, ENCLS generates ENCLS-specific #GPs
and #PFs.

ENCLS leafs functions are organized under SGX sub-features, e.g. SGX1
defines the base ENCLS function set and SGX2 adds ENCLS functions to
enable dynamic EPC management.  At this time, only the SGX1 and SGX2
function sets are supported by Linux; the other published sets relate
to VMM EPC oversubscription, which is far out on the horizon.

Define the ENCLS leafs in a dedicated file as more architecturally
defined SGX constants and data structures will be introduced in short
order.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/asm/sgx_arch.h | 54 +++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)
 create mode 100644 arch/x86/include/asm/sgx_arch.h

diff --git a/arch/x86/include/asm/sgx_arch.h b/arch/x86/include/asm/sgx_arch.h
new file mode 100644
index 000000000000..e068db46835e
--- /dev/null
+++ b/arch/x86/include/asm/sgx_arch.h
@@ -0,0 +1,54 @@
+/* SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause) */
+/**
+ * Copyright(c) 2016-18 Intel Corporation.
+ *
+ * Contains data structures defined by the SGX architecture.  Data structures
+ * defined by the Linux software stack should not be placed here.
+ */
+#ifndef _ASM_X86_SGX_ARCH_H
+#define _ASM_X86_SGX_ARCH_H
+
+/**
+ * enum sgx_encls_leaves - ENCLS leaf functions
+ * %SGX_ECREATE:	Create an enclave.
+ * %SGX_EADD:		Add a page to an uninitialized enclave.
+ * %SGX_EINIT:		Initialize an enclave, i.e. launch an enclave.
+ * %SGX_EREMOVE:	Remove a page from an enclave.
+ * %SGX_EDBGRD:		Read a word from an enclve (peek).
+ * %SGX_EDBGWR:		Write a word to an enclave (poke).
+ * %SGX_EEXTEND:	Measure 256 bytes of an added enclave page.
+ * %SGX_ELDB:		Load a swapped page in blocked state.
+ * %SGX_ELDU:		Load a swapped page in unblocked state.
+ * %SGX_EBLOCK:		Change page state to blocked i.e. entering hardware
+ *			threads cannot access it and create new TLB entries.
+ * %SGX_EPA:		Create a Version Array (VA) page used to store isvsvn
+ *			number for a swapped EPC page.
+ * %SGX_EWB:		Swap an enclave page to the regular memory. Checks that
+ *			all threads have exited that were in the previous
+ *			shoot-down sequence.
+ * %SGX_ETRACK:		Start a new shoot down sequence. Used to together with
+ *			EBLOCK to make sure that a page is safe to swap.
+ * %SGX_EAUG:		Add a page to an initialized enclave.
+ * %SGX_EMODPR:		Restrict an EPC page's permissions.
+ * %SGX_EMODT:		Modify the page type of an EPC page.
+ */
+enum sgx_encls_leaves {
+	SGX_ECREATE	= 0x00,
+	SGX_EADD	= 0x01,
+	SGX_EINIT	= 0x02,
+	SGX_EREMOVE	= 0x03,
+	SGX_EDGBRD	= 0x04,
+	SGX_EDGBWR	= 0x05,
+	SGX_EEXTEND	= 0x06,
+	SGX_ELDB	= 0x07,
+	SGX_ELDU	= 0x08,
+	SGX_EBLOCK	= 0x09,
+	SGX_EPA		= 0x0A,
+	SGX_EWB		= 0x0B,
+	SGX_ETRACK	= 0x0C,
+	SGX_EAUG	= 0x0D,
+	SGX_EMODPR	= 0x0E,
+	SGX_EMODT	= 0x0F,
+};
+
+#endif /* _ASM_X86_SGX_ARCH_H */
-- 
2.19.1

