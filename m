Return-Path: <SRS0=72mU=VK=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 999D0C71142
	for <linux-sgx@archiver.kernel.org>; Sat, 13 Jul 2019 17:12:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6084A2064A
	for <linux-sgx@archiver.kernel.org>; Sat, 13 Jul 2019 17:12:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727983AbfGMRMI (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 13 Jul 2019 13:12:08 -0400
Received: from mga18.intel.com ([134.134.136.126]:12302 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727853AbfGMRMH (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 13 Jul 2019 13:12:07 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Jul 2019 10:12:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,487,1557212400"; 
   d="scan'208";a="341981557"
Received: from hbriegel-mobl.ger.corp.intel.com (HELO localhost) ([10.252.50.48])
  by orsmga005.jf.intel.com with ESMTP; 13 Jul 2019 10:11:57 -0700
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
        cedric.xing@intel.com, Andy Lutomirski <luto@amacapital.net>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH v21 20/28] x86/vdso: Add support for exception fixup in vDSO functions
Date:   Sat, 13 Jul 2019 20:07:56 +0300
Message-Id: <20190713170804.2340-21-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190713170804.2340-1-jarkko.sakkinen@linux.intel.com>
References: <20190713170804.2340-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

From: Sean Christopherson <sean.j.christopherson@intel.com>

The basic concept and implementation is very similar to the kernel's
exception fixup mechanism.  The key differences are that the kernel
handler is hardcoded and the fixup entry addresses are relative to
the overall table as opposed to individual entries.

Hardcoding the kernel handler avoids the need to figure out how to
get userspace code to point at a kernel function.  Given that the
expected usage is to propagate information to userspace, dumping all
fault information into registers is likely the desired behavior for
the vast majority of yet-to-be-created functions.  Use registers
DI, SI and DX to communicate fault information, which follows Linux's
ABI for register consumption and hopefully avoids conflict with
hardware features that might leverage the fixup capabilities, e.g.
register usage for SGX instructions was at least partially designed
with calling conventions in mind.

Making fixup addresses relative to the overall table allows the table
to be stripped from the final vDSO image (it's a kernel construct)
without complicating the offset logic, e.g. entry-relative addressing
would also need to account for the table's location relative to the
image.

Regarding stripping the table, modify vdso2c to extract the table from
the raw, a.k.a. unstripped, data and dump it as a standalone byte array
in the resulting .c file.  The original base of the table, its length
and a pointer to the byte array are captured in struct vdso_image.
Alternatively, the table could be dumped directly into the struct,
but because the number of entries can vary per image, that would
require either hardcoding a max sized table into the struct definition
or defining the table as a flexible length array.  The flexible length
array approach has zero benefits, e.g. the base/size are still needed,
and prevents reusing the extraction code, while hardcoding the max size
adds ongoing maintenance just to avoid exporting the explicit size.

The immediate use case is for Intel Software Guard Extensions (SGX).
SGX introduces a new CPL3-only "enclave" mode that runs as a sort of
black box shared object that is hosted by an untrusted "normal" CPl3
process.

Entering an enclave can only be done through SGX-specific instructions,
EENTER and ERESUME, and is a non-trivial process.  Because of the
complexity of transitioning to/from an enclave, the vast majority of
enclaves are expected to utilize a library to handle the actual
transitions.  This is roughly analogous to how e.g. libc implementations
are used by most applications.

Another crucial characteristic of SGX enclaves is that they can generate
exceptions as part of their normal (at least as "normal" as SGX can be)
operation that need to be handled *in* the enclave and/or are unique
to SGX.

And because they are essentially fancy shared objects, a process can
host any number of enclaves, each of which can execute multiple threads
simultaneously.

Putting everything together, userspace enclaves will utilize a library
that must be prepared to handle any and (almost) all exceptions any time
at least one thread may be executing in an enclave.  Leveraging signals
to handle the enclave exceptions is unpleasant, to put it mildly, e.g.
the SGX library must constantly (un)register its signal handler based
on whether or not at least one thread is executing in an enclave, and
filter and forward exceptions that aren't related to its enclaves.  This
becomes particularly nasty when using multiple levels of libraries that
register signal handlers, e.g. running an enclave via cgo inside of the
Go runtime.

Enabling exception fixup in vDSO allows the kernel to provide a vDSO
function that wraps the low-level transitions to/from the enclave, i.e.
the EENTER and ERESUME instructions.  The vDSO function can intercept
exceptions that would otherwise generate a signal and return the fault
information directly to its caller, thus avoiding the need to juggle
signal handlers.

Note that unlike the kernel's _ASM_EXTABLE_HANDLE implementation, the
'C' version of _ASM_VDSO_EXTABLE_HANDLE doesn't use a pre-compiled
assembly macro.  Duplicating four lines of code is simpler than adding
the necessary infrastructure to generate pre-compiled assembly and the
intended benefit of massaging GCC's inlining algorithm is unlikely to
realized in the vDSO any time soon, if ever.

Suggested-by: Andy Lutomirski <luto@amacapital.net>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/entry/vdso/Makefile          |  6 +--
 arch/x86/entry/vdso/extable.c         | 46 +++++++++++++++++++++
 arch/x86/entry/vdso/extable.h         | 29 ++++++++++++++
 arch/x86/entry/vdso/vdso-layout.lds.S |  9 ++++-
 arch/x86/entry/vdso/vdso2c.h          | 58 +++++++++++++++++++++++----
 arch/x86/include/asm/vdso.h           |  5 +++
 6 files changed, 141 insertions(+), 12 deletions(-)
 create mode 100644 arch/x86/entry/vdso/extable.c
 create mode 100644 arch/x86/entry/vdso/extable.h

diff --git a/arch/x86/entry/vdso/Makefile b/arch/x86/entry/vdso/Makefile
index 39106111be86..715106395c71 100644
--- a/arch/x86/entry/vdso/Makefile
+++ b/arch/x86/entry/vdso/Makefile
@@ -26,7 +26,7 @@ VDSO32-$(CONFIG_IA32_EMULATION)	:= y
 vobjs-y := vdso-note.o vclock_gettime.o vgetcpu.o
 
 # files to link into kernel
-obj-y				+= vma.o
+obj-y				+= vma.o extable.o
 OBJECT_FILES_NON_STANDARD_vma.o	:= n
 
 # vDSO images to build
@@ -122,8 +122,8 @@ $(obj)/%-x32.o: $(obj)/%.o FORCE
 
 targets += vdsox32.lds $(vobjx32s-y)
 
-$(obj)/%.so: OBJCOPYFLAGS := -S
-$(obj)/%.so: $(obj)/%.so.dbg FORCE
+$(obj)/%.so: OBJCOPYFLAGS := -S --remove-section __ex_table
+$(obj)/%.so: $(obj)/%.so.dbg
 	$(call if_changed,objcopy)
 
 $(obj)/vdsox32.so.dbg: $(obj)/vdsox32.lds $(vobjx32s) FORCE
diff --git a/arch/x86/entry/vdso/extable.c b/arch/x86/entry/vdso/extable.c
new file mode 100644
index 000000000000..afcf5b65beef
--- /dev/null
+++ b/arch/x86/entry/vdso/extable.c
@@ -0,0 +1,46 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/err.h>
+#include <linux/mm.h>
+#include <asm/current.h>
+#include <asm/traps.h>
+#include <asm/vdso.h>
+
+struct vdso_exception_table_entry {
+	int insn, fixup;
+};
+
+bool fixup_vdso_exception(struct pt_regs *regs, int trapnr,
+			  unsigned long error_code, unsigned long fault_addr)
+{
+	const struct vdso_image *image = current->mm->context.vdso_image;
+	const struct vdso_exception_table_entry *extable;
+	unsigned int nr_entries, i;
+	unsigned long base;
+
+	/*
+	 * Do not attempt to fixup #DB or #BP.  It's impossible to identify
+	 * whether or not a #DB/#BP originated from within an SGX enclave and
+	 * SGX enclaves are currently the only use case for vDSO fixup.
+	 */
+	if (trapnr == X86_TRAP_DB || trapnr == X86_TRAP_BP)
+		return false;
+
+	if (!current->mm->context.vdso)
+		return false;
+
+	base =  (unsigned long)current->mm->context.vdso + image->extable_base;
+	nr_entries = image->extable_len / (sizeof(*extable));
+	extable = image->extable;
+
+	for (i = 0; i < nr_entries; i++) {
+		if (regs->ip == base + extable[i].insn) {
+			regs->ip = base + extable[i].fixup;
+			regs->di = trapnr;
+			regs->si = error_code;
+			regs->dx = fault_addr;
+			return true;
+		}
+	}
+
+	return false;
+}
diff --git a/arch/x86/entry/vdso/extable.h b/arch/x86/entry/vdso/extable.h
new file mode 100644
index 000000000000..aafdac396948
--- /dev/null
+++ b/arch/x86/entry/vdso/extable.h
@@ -0,0 +1,29 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __VDSO_EXTABLE_H
+#define __VDSO_EXTABLE_H
+
+/*
+ * Inject exception fixup for vDSO code.  Unlike normal exception fixup,
+ * vDSO uses a dedicated handler the addresses are relative to the overall
+ * exception table, not each individual entry.
+ */
+#ifdef __ASSEMBLY__
+#define _ASM_VDSO_EXTABLE_HANDLE(from, to)	\
+	ASM_VDSO_EXTABLE_HANDLE from to
+
+.macro ASM_VDSO_EXTABLE_HANDLE from:req to:req
+	.pushsection __ex_table, "a"
+	.long (\from) - __ex_table
+	.long (\to) - __ex_table
+	.popsection
+.endm
+#else
+#define _ASM_VDSO_EXTABLE_HANDLE(from, to)	\
+	".pushsection __ex_table, \"a\"\n"      \
+	".long (" #from ") - __ex_table\n"      \
+	".long (" #to ") - __ex_table\n"        \
+	".popsection\n"
+#endif
+
+#endif /* __VDSO_EXTABLE_H */
+
diff --git a/arch/x86/entry/vdso/vdso-layout.lds.S b/arch/x86/entry/vdso/vdso-layout.lds.S
index 93c6dc7812d0..8ef849064501 100644
--- a/arch/x86/entry/vdso/vdso-layout.lds.S
+++ b/arch/x86/entry/vdso/vdso-layout.lds.S
@@ -63,11 +63,18 @@ SECTIONS
 	 * stuff that isn't used at runtime in between.
 	 */
 
-	.text		: { *(.text*) }			:text	=0x90909090,
+	.text		: {
+		*(.text*)
+		*(.fixup)
+	}						:text	=0x90909090,
+
+
 
 	.altinstructions	: { *(.altinstructions) }	:text
 	.altinstr_replacement	: { *(.altinstr_replacement) }	:text
 
+	__ex_table		: { *(__ex_table) }		:text
+
 	/DISCARD/ : {
 		*(.discard)
 		*(.discard.*)
diff --git a/arch/x86/entry/vdso/vdso2c.h b/arch/x86/entry/vdso/vdso2c.h
index a20b134de2a8..04d04e46c98c 100644
--- a/arch/x86/entry/vdso/vdso2c.h
+++ b/arch/x86/entry/vdso/vdso2c.h
@@ -5,6 +5,41 @@
  * are built for 32-bit userspace.
  */
 
+static void BITSFUNC(copy)(FILE *outfile, const unsigned char *data, size_t len)
+{
+	size_t i;
+
+	for (i = 0; i < len; i++) {
+		if (i % 10 == 0)
+			fprintf(outfile, "\n\t");
+		fprintf(outfile, "0x%02X, ", (int)(data)[i]);
+	}
+}
+
+
+/*
+ * Extract a section from the input data into a standalone blob.  Used to
+ * capture kernel-only data that needs to persist indefinitely, e.g. the
+ * exception fixup tables, but only in the kernel, i.e. the section can
+ * be stripped from the final vDSO image.
+ */
+static void BITSFUNC(extract)(const unsigned char *data, size_t data_len,
+			      FILE *outfile, ELF(Shdr) *sec, const char *name)
+{
+	unsigned long offset;
+	size_t len;
+
+	offset = (unsigned long)GET_LE(&sec->sh_offset);
+	len = (size_t)GET_LE(&sec->sh_size);
+
+	if (offset + len > data_len)
+		fail("section to extract overruns input data");
+
+	fprintf(outfile, "static const unsigned char %s[%lu] = {", name, len);
+	BITSFUNC(copy)(outfile, data + offset, len);
+	fprintf(outfile, "\n};\n\n");
+}
+
 static void BITSFUNC(go)(void *raw_addr, size_t raw_len,
 			 void *stripped_addr, size_t stripped_len,
 			 FILE *outfile, const char *image_name)
@@ -14,9 +49,8 @@ static void BITSFUNC(go)(void *raw_addr, size_t raw_len,
 	unsigned long mapping_size;
 	ELF(Ehdr) *hdr = (ELF(Ehdr) *)raw_addr;
 	int i;
-	unsigned long j;
 	ELF(Shdr) *symtab_hdr = NULL, *strtab_hdr, *secstrings_hdr,
-		*alt_sec = NULL;
+		*alt_sec = NULL, *extable_sec = NULL;
 	ELF(Dyn) *dyn = 0, *dyn_end = 0;
 	const char *secstrings;
 	INT_BITS syms[NSYMS] = {};
@@ -78,6 +112,8 @@ static void BITSFUNC(go)(void *raw_addr, size_t raw_len,
 		if (!strcmp(secstrings + GET_LE(&sh->sh_name),
 			    ".altinstructions"))
 			alt_sec = sh;
+		if (!strcmp(secstrings + GET_LE(&sh->sh_name), "__ex_table"))
+			extable_sec = sh;
 	}
 
 	if (!symtab_hdr)
@@ -150,13 +186,11 @@ static void BITSFUNC(go)(void *raw_addr, size_t raw_len,
 	fprintf(outfile,
 		"static unsigned char raw_data[%lu] __ro_after_init __aligned(PAGE_SIZE) = {",
 		mapping_size);
-	for (j = 0; j < stripped_len; j++) {
-		if (j % 10 == 0)
-			fprintf(outfile, "\n\t");
-		fprintf(outfile, "0x%02X, ",
-			(int)((unsigned char *)stripped_addr)[j]);
-	}
+	BITSFUNC(copy)(outfile, stripped_addr, stripped_len);
 	fprintf(outfile, "\n};\n\n");
+	if (extable_sec)
+		BITSFUNC(extract)(raw_addr, raw_len, outfile,
+				  extable_sec, "extable");
 
 	fprintf(outfile, "const struct vdso_image %s = {\n", image_name);
 	fprintf(outfile, "\t.data = raw_data,\n");
@@ -167,6 +201,14 @@ static void BITSFUNC(go)(void *raw_addr, size_t raw_len,
 		fprintf(outfile, "\t.alt_len = %lu,\n",
 			(unsigned long)GET_LE(&alt_sec->sh_size));
 	}
+	if (extable_sec) {
+		fprintf(outfile, "\t.extable_base = %lu,\n",
+			(unsigned long)GET_LE(&extable_sec->sh_offset));
+		fprintf(outfile, "\t.extable_len = %lu,\n",
+			(unsigned long)GET_LE(&extable_sec->sh_size));
+		fprintf(outfile, "\t.extable = extable,\n");
+	}
+
 	for (i = 0; i < NSYMS; i++) {
 		if (required_syms[i].export && syms[i])
 			fprintf(outfile, "\t.sym_%s = %" PRIi64 ",\n",
diff --git a/arch/x86/include/asm/vdso.h b/arch/x86/include/asm/vdso.h
index 230474e2ddb5..745300a05f25 100644
--- a/arch/x86/include/asm/vdso.h
+++ b/arch/x86/include/asm/vdso.h
@@ -15,6 +15,8 @@ struct vdso_image {
 	unsigned long size;   /* Always a multiple of PAGE_SIZE */
 
 	unsigned long alt, alt_len;
+	unsigned long extable_base, extable_len;
+	const void *extable;
 
 	long sym_vvar_start;  /* Negative offset to the vvar area */
 
@@ -44,6 +46,9 @@ extern void __init init_vdso_image(const struct vdso_image *image);
 
 extern int map_vdso_once(const struct vdso_image *image, unsigned long addr);
 
+extern bool fixup_vdso_exception(struct pt_regs *regs, int trapnr,
+				 unsigned long error_code,
+				 unsigned long fault_addr);
 #endif /* __ASSEMBLER__ */
 
 #endif /* _ASM_X86_VDSO_H */
-- 
2.20.1

