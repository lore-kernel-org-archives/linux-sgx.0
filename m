Return-Path: <SRS0=YHr7=A3=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 583C9C433DF
	for <linux-sgx@archiver.kernel.org>; Thu, 16 Jul 2020 13:54:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 349B420787
	for <linux-sgx@archiver.kernel.org>; Thu, 16 Jul 2020 13:54:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728892AbgGPNyB (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 16 Jul 2020 09:54:01 -0400
Received: from mga03.intel.com ([134.134.136.65]:23644 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726986AbgGPNyA (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 16 Jul 2020 09:54:00 -0400
IronPort-SDR: w+QU2Sg+icR1dR85uuECpxybGKfHJGuSjzJNoEYxXBNoPoiWEcJZwRsM07/u4ONivELCISWtkp
 8hA1d34X8I1Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9683"; a="149368483"
X-IronPort-AV: E=Sophos;i="5.75,359,1589266800"; 
   d="scan'208";a="149368483"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2020 06:53:59 -0700
IronPort-SDR: M2g6KUIQiTyzoq8ctF3vSur4t1WL2Oln3sweHYzSn5sAT2s6eO38HvdiKXiBkRZLSOxdEucH75
 1aUB6rHMcunQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,359,1589266800"; 
   d="scan'208";a="325150042"
Received: from lettner-mobl.ger.corp.intel.com (HELO localhost) ([10.252.32.212])
  by FMSMGA003.fm.intel.com with ESMTP; 16 Jul 2020 06:53:46 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     x86@kernel.org, linux-sgx@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, bp@alien8.de, cedric.xing@intel.com,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
Subject: [PATCH v36 03/24] x86/mm: x86/sgx: Signal SIGSEGV with PF_SGX
Date:   Thu, 16 Jul 2020 16:52:42 +0300
Message-Id: <20200716135303.276442-4-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200716135303.276442-1-jarkko.sakkinen@linux.intel.com>
References: <20200716135303.276442-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Include SGX bit to the PF error codes and throw SIGSEGV with PF_SGX when
a #PF with SGX set happens.

CPU throws a #PF with the SGX set in the event of Enclave Page Cache Map
(EPCM) conflict. The EPCM is a CPU-internal table, which describes the
properties for a enclave page. Enclaves are measured and signed software
entities, which SGX hosts. [1]

Although the primary purpose of the EPCM conflict checks  is to prevent
malicious accesses to an enclave, an illegit access can happen also for
legit reasons.

All SGX reserved memory, including EPCM is encrypted with a transient key
that does not survive from the power transition. Throwing a SIGSEGV allows
user space software to react when this happens (e.g. recreate the enclave,
which was invalidated).

[1] Intel SDM: 36.5.1 Enclave Page Cache Map (EPCM)

Acked-by: Jethro Beekman <jethro@fortanix.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/include/asm/traps.h | 14 ++++++++------
 arch/x86/mm/fault.c          | 13 +++++++++++++
 2 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index 714b1a30e7b0..4446f95ad997 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -44,12 +44,13 @@ void __noreturn handle_stack_overflow(const char *message,
 /*
  * Page fault error code bits:
  *
- *   bit 0 ==	 0: no page found	1: protection fault
- *   bit 1 ==	 0: read access		1: write access
- *   bit 2 ==	 0: kernel-mode access	1: user-mode access
- *   bit 3 ==				1: use of reserved bit detected
- *   bit 4 ==				1: fault was an instruction fetch
- *   bit 5 ==				1: protection keys block access
+ *   bit 0  ==	 0: no page found	1: protection fault
+ *   bit 1  ==	 0: read access		1: write access
+ *   bit 2  ==	 0: kernel-mode access	1: user-mode access
+ *   bit 3  ==				1: use of reserved bit detected
+ *   bit 4  ==				1: fault was an instruction fetch
+ *   bit 5  ==				1: protection keys block access
+ *   bit 15 ==				1: inside SGX enclave
  */
 enum x86_pf_error_code {
 	X86_PF_PROT	=		1 << 0,
@@ -58,5 +59,6 @@ enum x86_pf_error_code {
 	X86_PF_RSVD	=		1 << 3,
 	X86_PF_INSTR	=		1 << 4,
 	X86_PF_PK	=		1 << 5,
+	X86_PF_SGX	=		1 << 15,
 };
 #endif /* _ASM_X86_TRAPS_H */
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 1ead568c0101..1db6fbd7af8e 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -1055,6 +1055,19 @@ access_error(unsigned long error_code, struct vm_area_struct *vma)
 	if (error_code & X86_PF_PK)
 		return 1;
 
+	/*
+	 * Access is blocked by the Enclave Page Cache Map (EPCM), i.e. the
+	 * access is allowed by the PTE but not the EPCM. This usually happens
+	 * when the EPCM is yanked out from under us, e.g. by hardware after a
+	 * suspend/resume cycle. In any case, software, i.e. the kernel, can't
+	 * fix the source of the fault as the EPCM can't be directly modified by
+	 * software. Handle the fault as an access error in order to signal
+	 * userspace so that userspace can rebuild their enclave(s), even though
+	 * userspace may not have actually violated access permissions.
+	 */
+	if (unlikely(error_code & X86_PF_SGX))
+		return 1;
+
 	/*
 	 * Make sure to check the VMA so that we do not perform
 	 * faults just to hit a X86_PF_PK as soon as we fill in a
-- 
2.25.1

