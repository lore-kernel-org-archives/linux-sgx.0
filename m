Return-Path: <SRS0=rDpG=ST=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 675BFC10F12
	for <linux-sgx@archiver.kernel.org>; Wed, 17 Apr 2019 10:42:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B46620821
	for <linux-sgx@archiver.kernel.org>; Wed, 17 Apr 2019 10:42:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731789AbfDQKmn (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 17 Apr 2019 06:42:43 -0400
Received: from mga04.intel.com ([192.55.52.120]:54702 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731509AbfDQKmn (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 17 Apr 2019 06:42:43 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Apr 2019 03:42:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,361,1549958400"; 
   d="scan'208";a="132120247"
Received: from jsakkine-mobl1.tm.intel.com (HELO localhost) ([10.237.50.189])
  by orsmga007.jf.intel.com with ESMTP; 17 Apr 2019 03:42:34 -0700
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
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Subject: [PATCH v20 23/28] x86/vdso: Add __vdso_sgx_enter_enclave() to wrap SGX enclave transitions
Date:   Wed, 17 Apr 2019 13:39:33 +0300
Message-Id: <20190417103938.7762-24-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190417103938.7762-1-jarkko.sakkinen@linux.intel.com>
References: <20190417103938.7762-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

Intel Software Guard Extensions (SGX) introduces a new CPL3-only enclave
mode that runs as a sort of black box shared object that is hosted by an
untrusted normal CPL3 process.

Skipping over a great deal of gory architecture details[1], SGX was
designed in such a way that the host process can utilize a library to
build, launch and run an enclave.  This is roughly analogous to how
e.g. libc implementations are used by most applications so that the
application can focus on its business logic.

The big gotcha is that because enclaves can generate *and* handle
exceptions, any SGX library must be prepared to handle nearly any
exception at any time (well, any time a thread is executing in an
enclave).  In Linux, this means the SGX library must register a
signal handler in order to intercept relevant exceptions and forward
them to the enclave (or in some cases, take action on behalf of the
enclave).  Unfortunately, Linux's signal mechanism doesn't mesh well
with libraries, e.g. signal handlers are process wide, are difficult
to chain, etc...  This becomes particularly nasty when using multiple
levels of libraries that register signal handlers, e.g. running an
enclave via cgo inside of the Go runtime.

In comes vDSO to save the day.  Now that vDSO can fixup exceptions,
add a function, __vdso_sgx_enter_enclave(), to wrap enclave transitions
and intercept any exceptions that occur when running the enclave.

__vdso_sgx_enter_enclave() does NOT adhere to the x86-64 ABI and instead
uses a custom calling convention.  The primary motivation is to avoid
issues that arise due to asynchronous enclave exits.  The x86-64 ABI
requires that EFLAGS.DF, MXCSR and FCW be preserved by the callee, and
unfortunately for the vDSO, the aformentioned registers/bits are not
restored after an asynchronous exit, e.g. EFLAGS.DF is in an unknown
state while MXCSR and FCW are reset to their init values.  So the vDSO
cannot simply pass the buck by requiring enclaves to adhere to the
x86-64 ABI.  That leaves three somewhat reasonable options:

  1) Save/restore non-volatile GPRs, MXCSR and FCW, and clear EFLAGS.DF

     + 100% compliant with the x86-64 ABI
     + Callable from any code
     + Minimal documentation required
     - Restoring MXCSR/FCW is likely unnecessary 99% of the time
     - Slow

  2) Save/restore non-volatile GPRs and clear EFLAGS.DF

     + Mostly compliant with the x86-64 ABI
     + Callable from any code that doesn't use SIMD registers
     - Need to document deviations from x86-64 ABI, i.e. MXCSR and FCW

  3) Require the caller to save/restore everything.

     + Fast
     + Userspace can pass all GPRs to the enclave (minus EAX, RBX and RCX)
     - Custom ABI
     - For all intents and purposes must be called from an assembly wrapper

__vdso_sgx_enter_enclave() implements option (3).  The custom ABI is
mostly a documentation issue, and even that is offset by the fact that
being more similar to hardware's ENCLU[EENTER/ERESUME] ABI reduces the
amount of documentation needed for the vDSO, e.g. options (2) and (3)
would need to document which registers are marshalled to/from enclaves.
Requiring an assembly wrapper imparts minimal pain on userspace as SGX
libraries and/or applications need a healthy chunk of assembly, e.g. in
the enclave, regardless of the vDSO's implementation.

Note, the C-like pseudocode describing the assembly routine is wrapped
in a non-existent macro instead of in a comment to trick kernel-doc into
auto-parsing the documentation and function prototype.  This is a double
win as the pseudocode is intended to aid kernel developers, not userland
enclave developers.

[1] Documentation/x86/sgx/1.Architecture.rst

Suggested-by: Andy Lutomirski <luto@amacapital.net>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Haitao Huang <haitao.huang@linux.intel.com>
Cc: Jethro Beekman <jethro@fortanix.com>
Cc: Dr. Greg Wettstein <greg@enjellic.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/entry/vdso/Makefile             |   2 +
 arch/x86/entry/vdso/vdso.lds.S           |   1 +
 arch/x86/entry/vdso/vsgx_enter_enclave.S | 101 +++++++++++++++++++++++
 arch/x86/include/uapi/asm/sgx.h          |  18 ++++
 4 files changed, 122 insertions(+)
 create mode 100644 arch/x86/entry/vdso/vsgx_enter_enclave.S

diff --git a/arch/x86/entry/vdso/Makefile b/arch/x86/entry/vdso/Makefile
index 34bcf87d358c..fb5b9960b192 100644
--- a/arch/x86/entry/vdso/Makefile
+++ b/arch/x86/entry/vdso/Makefile
@@ -18,6 +18,7 @@ VDSO32-$(CONFIG_IA32_EMULATION)	:= y
 
 # files to link into the vdso
 vobjs-y := vdso-note.o vclock_gettime.o vgetcpu.o
+vobjs-$(VDSO64-y)		+= vsgx_enter_enclave.o
 
 # files to link into kernel
 obj-y				+= vma.o extable.o
@@ -85,6 +86,7 @@ CFLAGS_REMOVE_vdso-note.o = -pg
 CFLAGS_REMOVE_vclock_gettime.o = -pg
 CFLAGS_REMOVE_vgetcpu.o = -pg
 CFLAGS_REMOVE_vvar.o = -pg
+CFLAGS_REMOVE_vsgx_enter_enclave.o = -pg
 
 #
 # X32 processes use x32 vDSO to access 64bit kernel data.
diff --git a/arch/x86/entry/vdso/vdso.lds.S b/arch/x86/entry/vdso/vdso.lds.S
index d3a2dce4cfa9..50952a995a6c 100644
--- a/arch/x86/entry/vdso/vdso.lds.S
+++ b/arch/x86/entry/vdso/vdso.lds.S
@@ -25,6 +25,7 @@ VERSION {
 		__vdso_getcpu;
 		time;
 		__vdso_time;
+		__vdso_sgx_enter_enclave;
 	local: *;
 	};
 }
diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.S b/arch/x86/entry/vdso/vsgx_enter_enclave.S
new file mode 100644
index 000000000000..fe0bf6671d6d
--- /dev/null
+++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
@@ -0,0 +1,101 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#include <linux/linkage.h>
+#include <asm/export.h>
+#include <asm/errno.h>
+
+#include "extable.h"
+
+#define EX_LEAF		0*8
+#define EX_TRAPNR	0*8+4
+#define EX_ERROR_CODE	0*8+6
+#define EX_ADDRESS	1*8
+
+.code64
+.section .text, "ax"
+
+#ifdef SGX_KERNEL_DOC
+/**
+ * __vdso_sgx_enter_enclave() - Enter an SGX enclave
+ *
+ * @leaf:	**IN \%eax** - ENCLU leaf, must be EENTER or ERESUME
+ * @tcs:	**IN \%rbx** - TCS, must be non-NULL
+ * @ex_info:	**IN \%rcx** - Optional 'struct sgx_enclave_exception' pointer
+ *
+ * Return:
+ *  **OUT \%eax** -
+ *  %0 on a clean entry/exit to/from the enclave, %-EINVAL if ENCLU leaf is
+ *  not allowed or if TCS is NULL, %-EFAULT if ENCLU or the enclave faults
+ *
+ * **Important!**  __vdso_sgx_enter_enclave() is **NOT** compliant with the
+ * x86-64 ABI, i.e. cannot be called from standard C code.   As noted above,
+ * input parameters must be passed via ``%eax``, ``%rbx`` and ``%rcx``, with
+ * the return value passed via ``%eax``.  All registers except ``%rsp`` must
+ * be treated as volatile from the caller's perspective, including but not
+ * limited to GPRs, EFLAGS.DF, MXCSR, FCW, etc...  Conversely, the enclave
+ * being run **must** preserve the untrusted ``%rsp`` and stack.
+ */
+__vdso_sgx_enter_enclave(u32 leaf, void *tcs,
+			 struct sgx_enclave_exception *ex_info)
+{
+	if (leaf != SGX_EENTER && leaf != SGX_ERESUME)
+		return -EINVAL;
+
+	if (!tcs)
+		return -EINVAL;
+
+	try {
+		ENCLU[leaf];
+	} catch (exception) {
+		if (e)
+			*e = exception;
+		return -EFAULT;
+	}
+
+	return 0;
+}
+#endif
+ENTRY(__vdso_sgx_enter_enclave)
+	/* EENTER <= leaf <= ERESUME */
+	cmp	$0x2, %eax
+	jb	bad_input
+
+	cmp	$0x3, %eax
+	ja	bad_input
+
+	/* TCS must be non-NULL */
+	test	%rbx, %rbx
+	je	bad_input
+
+	/* Save @exception_info */
+	push	%rcx
+
+	/* Load AEP for ENCLU */
+	lea	1f(%rip),  %rcx
+1:	enclu
+
+	add	$0x8, %rsp
+	xor	%eax, %eax
+	ret
+
+bad_input:
+	mov     $(-EINVAL), %rax
+	ret
+
+.pushsection .fixup, "ax"
+	/* Re-load @exception_info and fill it (if it's non-NULL) */
+2:	pop	%rcx
+	test    %rcx, %rcx
+	je      3f
+
+	mov	%eax, EX_LEAF(%rcx)
+	mov	%di,  EX_TRAPNR(%rcx)
+	mov	%si,  EX_ERROR_CODE(%rcx)
+	mov	%rdx, EX_ADDRESS(%rcx)
+3:	mov	$(-EFAULT), %rax
+	ret
+.popsection
+
+_ASM_VDSO_EXTABLE_HANDLE(1b, 2b)
+
+ENDPROC(__vdso_sgx_enter_enclave)
diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
index 3b80acde8671..9ed690a38c70 100644
--- a/arch/x86/include/uapi/asm/sgx.h
+++ b/arch/x86/include/uapi/asm/sgx.h
@@ -65,4 +65,22 @@ struct sgx_enclave_set_attribute {
 	__u64	attribute_fd;
 };
 
+/**
+ * struct sgx_enclave_exception - structure to report exceptions encountered in
+ *				  __vdso_sgx_enter_enclave()
+ *
+ * @leaf:	ENCLU leaf from \%eax at time of exception
+ * @trapnr:	exception trap number, a.k.a. fault vector
+ * @error_code:	exception error code
+ * @address:	exception address, e.g. CR2 on a #PF
+ * @reserved:	reserved for future use
+ */
+struct sgx_enclave_exception {
+	__u32 leaf;
+	__u16 trapnr;
+	__u16 error_code;
+	__u64 address;
+	__u64 reserved[2];
+};
+
 #endif /* _UAPI_ASM_X86_SGX_H */
-- 
2.19.1

