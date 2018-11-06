Received: from mga03.intel.com ([134.134.136.65]:62509 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP        id
 S2388191AbeKFXQA (ORCPT <rfc822;linux-sgx@vger.kernel.org>);        Tue, 6
 Nov 2018 18:16:00 -0500
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: <x86@kernel.org>, <platform-driver-x86@vger.kernel.org>,
	<linux-sgx@vger.kernel.org>
CC: <dave.hansen@intel.com>, <sean.j.christopherson@intel.com>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, <serge.ayoun@intel.com>,
	<shay.katz-zamir@intel.com>, <haitao.huang@intel.com>,
	<andriy.shevchenko@linux.intel.com>, <tglx@linutronix.de>,
	<kai.svahn@intel.com>, Andy Lutomirski <luto@amacapital.net>, Dave Hansen
	<dave.hansen@linux.intel.com>, Jarkko Sakkinen
	<jarkko.sakkinen@linux.intel.com>, Andy Lutomirski <luto@kernel.org>, "Peter
 Zijlstra" <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, "Borislav
 Petkov" <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, "open list:X86 MM"
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v16 08/22] x86/mm: x86/sgx: Signal SIGSEGV for userspace #PFs w/ PF_SGX
Date: Tue, 6 Nov 2018 15:45:47 +0200
Message-ID: <20181106134758.10572-9-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <20181106134758.10572-1-jarkko.sakkinen@linux.intel.com>
References: <20181106134758.10572-1-jarkko.sakkinen@linux.intel.com>
Sender: <linux-sgx-owner@vger.kernel.org>
List-ID: <linux-sgx.vger.kernel.org>
Content-Type: text/plain
Return-Path: linux-sgx-owner@vger.kernel.org
MIME-Version: 1.0

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
index 47bebfe6efa7..11d16bcf6e64 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -1153,6 +1153,19 @@ access_error(unsigned long error_code, struct vm_area_struct *vma)
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
