Received: from mga07.intel.com ([134.134.136.100]:35184 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP        id
 S2388191AbeKFXPu (ORCPT <rfc822;linux-sgx@vger.kernel.org>);        Tue, 6
 Nov 2018 18:15:50 -0500
From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: <x86@kernel.org>, <platform-driver-x86@vger.kernel.org>,
	<linux-sgx@vger.kernel.org>
CC: <dave.hansen@intel.com>, <sean.j.christopherson@intel.com>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, <serge.ayoun@intel.com>,
	<shay.katz-zamir@intel.com>, <haitao.huang@intel.com>,
	<andriy.shevchenko@linux.intel.com>, <tglx@linutronix.de>,
	<kai.svahn@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, "Jarkko
 Sakkinen" <jarkko.sakkinen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, "Andy
 Lutomirski" <luto@kernel.org>, "open list:X86 ARCHITECTURE (32-BIT AND
        64-BIT)" <linux-kernel@vger.kernel.org>
Subject: [PATCH v16 07/22] x86/mm: x86/sgx: Add new 'PF_SGX' page fault error code bit
Date: Tue, 6 Nov 2018 15:45:46 +0200
Message-ID: <20181106134758.10572-8-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <20181106134758.10572-1-jarkko.sakkinen@linux.intel.com>
References: <20181106134758.10572-1-jarkko.sakkinen@linux.intel.com>
Sender: <linux-sgx-owner@vger.kernel.org>
List-ID: <linux-sgx.vger.kernel.org>
Content-Type: text/plain
Return-Path: linux-sgx-owner@vger.kernel.org
MIME-Version: 1.0

From: Sean Christopherson <sean.j.christopherson@intel.com>

The SGX bit is set in the #PF error code if and only if the fault is
detected by the Enclave Page Cache Map (EPCM), a hardware-managed
table that enforces the paging permissions defined by the enclave,
e.g. to prevent the kernel from changing the permissions of an
enclave's page(s).

Cc: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/include/asm/traps.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/traps.h b/arch/x86/include/asm/traps.h
index 3de69330e6c5..165c93dd700e 100644
--- a/arch/x86/include/asm/traps.h
+++ b/arch/x86/include/asm/traps.h
@@ -162,5 +162,6 @@ enum x86_pf_error_code {
 	X86_PF_RSVD	=		1 << 3,
 	X86_PF_INSTR	=		1 << 4,
 	X86_PF_PK	=		1 << 5,
+	X86_PF_SGX	=		1 << 15,
 };
 #endif /* _ASM_X86_TRAPS_H */
-- 
2.19.1
