Return-Path: <SRS0=REdw=RX=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F601C43381
	for <linux-sgx@archiver.kernel.org>; Wed, 20 Mar 2019 16:22:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57FA22183E
	for <linux-sgx@archiver.kernel.org>; Wed, 20 Mar 2019 16:22:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbfCTQWs (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 20 Mar 2019 12:22:48 -0400
Received: from mga05.intel.com ([192.55.52.43]:38734 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726366AbfCTQWs (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 20 Mar 2019 12:22:48 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Mar 2019 09:22:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,249,1549958400"; 
   d="scan'208";a="135714793"
Received: from sorenthe-mobl1.ger.corp.intel.com (HELO localhost) ([10.249.254.203])
  by orsmga003.jf.intel.com with ESMTP; 20 Mar 2019 09:22:37 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     akpm@linux-foundation.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        Andy Lutomirski <luto@amacapital.net>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v19,RESEND 07/27] x86/mm: x86/sgx: Signal SIGSEGV for userspace #PFs w/ PF_SGX
Date:   Wed, 20 Mar 2019 18:20:59 +0200
Message-Id: <20190320162119.4469-8-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190320162119.4469-1-jarkko.sakkinen@linux.intel.com>
References: <20190320162119.4469-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

The PF_SGX bit is set if and only if the #PF is detected by the SGX
Enclave Page Cache Map (EPCM).  The EPCM is a hardware-managed table
that enforces accesses to an enclave's EPC pages in addition to the
software-managed kernel page tables, i.e. the effective permissions
for an EPC page are a logical AND of the kernel's page tables and
the corresponding EPCM entry.

The EPCM is consulted only after an access walks the kernel's page
tables, i.e.:

  a. the access was allowed by the kernel
  b. the kernel's tables have become less restrictive than the EPCM
  c. the kernel cannot fixup the cause of the fault

Noteably, (b) implies that either the kernel has botched the EPC
mappings or the EPCM has been invalidated (see below).  Regardless of
why the fault occurred, userspace needs to be alerted so that it can
take appropriate action, e.g. restart the enclave.  This is reinforced
by (c) as the kernel doesn't really have any other reasonable option,
i.e. signalling SIGSEGV is actually the least severe action possible.

Although the primary purpose of the EPCM is to prevent a malicious or
compromised kernel from attacking an enclave, e.g. by modifying the
enclave's page tables, do not WARN on a #PF w/ PF_SGX set.  The SGX
architecture effectively allows the CPU to invalidate all EPCM entries
at will and requires that software be prepared to handle an EPCM fault
at any time.  The architecture defines this behavior because the EPCM
is encrypted with an ephemeral key that isn't exposed to software.  As
such, the EPCM entries cannot be preserved across transitions that
result in a new key being used, e.g. CPU power down as part of an S3
transition or when a VM is live migrated to a new physical system.

Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/mm/fault.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 667f1da36208..78e2807fbede 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -1214,6 +1214,19 @@ access_error(unsigned long error_code, struct vm_area_struct *vma)
 	if (error_code & X86_PF_PK)
 		return 1;
 
+	/*
+	 * Access is blocked by the Enclave Page Cache Map (EPCM), i.e. the
+	 * access is allowed by the PTE but not the EPCM.  This usually happens
+	 * when the EPCM is yanked out from under us, e.g. by hardware after a
+	 * suspend/resume cycle.  In any case, software, i.e. the kernel, can't
+	 * fix the source of the fault as the EPCM can't be directly modified
+	 * by software.  Handle the fault as an access error in order to signal
+	 * userspace, e.g. so that userspace can rebuild their enclave(s), even
+	 * though userspace may not have actually violated access permissions.
+	 */
+	if (unlikely(error_code & X86_PF_SGX))
+		return 1;
+
 	/*
 	 * Make sure to check the VMA so that we do not perform
 	 * faults just to hit a X86_PF_PK as soon as we fill in a
-- 
2.19.1

