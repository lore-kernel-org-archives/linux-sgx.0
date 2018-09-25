From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: <x86@kernel.org>, <platform-driver-x86@vger.kernel.org>
CC: <dave.hansen@intel.com>, <sean.j.christopherson@intel.com>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, <serge.ayoun@intel.com>,
	<shay.katz-zamir@intel.com>, <linux-sgx@vger.kernel.org>,
	<andriy.shevchenko@linux.intel.com>, Dave Hansen
	<dave.hansen@linux.intel.com>, Jarkko Sakkinen
	<jarkko.sakkinen@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>, "open
 list:GENERIC INCLUDE/ASM HEADER FILES" <linux-arch@vger.kernel.org>, "open
 list" <linux-kernel@vger.kernel.org>
Subject: [PATCH v14 08/19] signal: x86/sgx: Add SIGSEGV siginfo code for SGX EPCM fault
Date: Tue, 25 Sep 2018 16:06:45 +0300
Message-ID: <20180925130845.9962-9-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <20180925130845.9962-1-jarkko.sakkinen@linux.intel.com>
References: <20180925130845.9962-1-jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain
Return-Path: jarkko.sakkinen@intel.com
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

From: Sean Christopherson <sean.j.christopherson@intel.com>

The SGX Enclave Page Cache Map (EPCM) is a hardware-managed table
that enforces accesses to an enclave's EPC page in addition to the
software-managed kernel page tables, i.e. the effective permissions
for an EPC page are a logical AND of the kernel's page tables and
the corresponding EPCM entry.  The primary purpose of the EPCM is
to prevent a malcious or compromised kernel from attacking an enclave
by modifying the enclave's page tables.  The EPCM entires for an
enclave are populated when the enclave is built and verified, using
metadata provided by the enclave that is included in the measurement
used to verify the enclave.

In normal operation of a properly functioning, non-malicious kernel
(and enclave), the EPCM permissions will never trigger a fault, i.e.
the kernel may make the permissions for an EPC page more restrictive,
e.g. mark it not-present to swap out the EPC page, but the kernel will
never make its permissions less restrictive.

But, there is a legitimate scenario in which the kernel's page tables
can become less restrictive than the EPCM: on current hardware all
enclaves are destroyed (by hardware) on a transition to S3 or lower
sleep states, i.e. all EPCM entries are invalid (not-present) after
the system resumes from its sleep state.

Unfortunately, on CPUs that support only SGX1, EPCM violations result
in a #GP.  The upside of the #GP is that no kernel changes are needed
to deal with the EPCM being blasted away by hardware, e.g. userspace
gets a SIGSEGV, assumes the EPCM was lost and restarts its enclave
and everyone is happy.  The downside is that userspace has to assume
the SIGSEGV was because the EPC was lost (or possibly do some leg work
to rule out other causes).

In SGX2, the oddity of delivering a #GP due to what are inherently
paging related violations is remedied.  CPUs that support SGX2 deliver
EPCM violations as #PFs with a new SGX error code bit set.  So, now
that hardware provides us with a way to unequivocally determine that
a fault was due to a EPCM violation, define a signfo code for SIGSEGV
so that the information can be passed onto userspace.

Cc: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 include/uapi/asm-generic/siginfo.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/uapi/asm-generic/siginfo.h b/include/uapi/asm-generic/siginfo.h
index 80e2a7227205..fdd898e2325b 100644
--- a/include/uapi/asm-generic/siginfo.h
+++ b/include/uapi/asm-generic/siginfo.h
@@ -225,7 +225,11 @@ typedef struct siginfo {
 #else
 # define SEGV_PKUERR	4	/* failed protection key checks */
 #endif
+#ifdef __x86_64__
+#define SEGV_SGXERR	5	/* SGX Enclave Page Cache Map fault */
+#else
 #define SEGV_ACCADI	5	/* ADI not enabled for mapped object */
+#endif
 #define SEGV_ADIDERR	6	/* Disrupting MCD error */
 #define SEGV_ADIPERR	7	/* Precise MCD exception */
 #define NSIGSEGV	7
-- 
2.17.1
