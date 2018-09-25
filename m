From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To: <x86@kernel.org>, <platform-driver-x86@vger.kernel.org>
CC: <dave.hansen@intel.com>, <sean.j.christopherson@intel.com>,
	<nhorman@redhat.com>, <npmccallum@redhat.com>, <serge.ayoun@intel.com>,
	<shay.katz-zamir@intel.com>, <linux-sgx@vger.kernel.org>,
	<andriy.shevchenko@linux.intel.com>, Dave Hansen
	<dave.hansen@linux.intel.com>, Jarkko Sakkinen
	<jarkko.sakkinen@linux.intel.com>, Andy Lutomirski <luto@kernel.org>, "Peter
 Zijlstra" <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>,
	"Ingo Molnar" <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter
 Anvin" <hpa@zytor.com>, "open list:X86 MM" <linux-kernel@vger.kernel.org>
Subject: [PATCH v14 07/19] x86/fault: x86/mm/pkeys: relocate stale comment regarding OSPKE
Date: Tue, 25 Sep 2018 16:06:44 +0300
Message-ID: <20180925130845.9962-8-jarkko.sakkinen@linux.intel.com>
In-Reply-To: <20180925130845.9962-1-jarkko.sakkinen@linux.intel.com>
References: <20180925130845.9962-1-jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain
Return-Path: jarkko.sakkinen@intel.com
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

From: Sean Christopherson <sean.j.christopherson@intel.com>

The code being referenced was moved to a separate helper function
but the comment was left behind.

Fixes: 33a709b25a76 ("mm/gup, x86/mm/pkeys: Check VMAs and PTEs for protection keys")
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/mm/fault.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 47bebfe6efa7..85d20516b2f3 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -940,6 +940,11 @@ static inline bool bad_area_access_from_pkeys(unsigned long error_code,
 	/* This code is always called on the current mm */
 	bool foreign = false;
 
+	/*
+	 * This OSPKE check is not strictly necessary at runtime.
+	 * But, doing it this way allows compiler optimizations
+	 * if pkeys are compiled out.
+	 */
 	if (!boot_cpu_has(X86_FEATURE_OSPKE))
 		return false;
 	if (error_code & X86_PF_PK)
@@ -955,11 +960,6 @@ static noinline void
 bad_area_access_error(struct pt_regs *regs, unsigned long error_code,
 		      unsigned long address, struct vm_area_struct *vma)
 {
-	/*
-	 * This OSPKE check is not strictly necessary at runtime.
-	 * But, doing it this way allows compiler optimizations
-	 * if pkeys are compiled out.
-	 */
 	if (bad_area_access_from_pkeys(error_code, vma))
 		__bad_area(regs, error_code, address, vma, SEGV_PKUERR);
 	else
-- 
2.17.1
