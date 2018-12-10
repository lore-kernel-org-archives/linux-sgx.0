Return-Path: <SRS0=QEGF=OT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E4A7C5CFFE
	for <linux-sgx@archiver.kernel.org>; Mon, 10 Dec 2018 23:22:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 077002081F
	for <linux-sgx@archiver.kernel.org>; Mon, 10 Dec 2018 23:22:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 077002081F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727919AbeLJXWQ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 10 Dec 2018 18:22:16 -0500
Received: from mga04.intel.com ([192.55.52.120]:11277 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729772AbeLJXWA (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 10 Dec 2018 18:22:00 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Dec 2018 15:21:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,340,1539673200"; 
   d="scan'208";a="117684789"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.154])
  by orsmga001.jf.intel.com with ESMTP; 10 Dec 2018 15:21:57 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-sgx@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Josh Triplett <josh@joshtriplett.org>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Subject: [RFC PATCH v3 4/4] x86/sgx: Add an SGX IOCTL to register a per-mm ENCLU exception handler
Date:   Mon, 10 Dec 2018 15:21:41 -0800
Message-Id: <20181210232141.5425-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181210232141.5425-1-sean.j.christopherson@intel.com>
References: <20181210232141.5425-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Intel Software Guard Extensions (SGX) SGX introduces a new CPL3-only
enclave mode that runs as a sort of black box shared object that is
hosted by an untrusted normal CPL3 process.

Enclave transitions have semantics that are a lovely blend of SYCALL,
SYSRET and VM-Exit.  In a non-faulting scenario, entering and exiting
an enclave can only be done through SGX-specific instructions, EENTER
and EEXIT respectively.  EENTER+EEXIT is analogous to SYSCALL+SYSRET,
e.g. EENTER/SYSCALL load RCX with the next RIP and EEXIT/SYSRET load
RIP from R{B,C}X.

But in a faulting/interrupting scenario, enclave transitions act more
like VM-Exit and VMRESUME.  Maintaining the black box nature of the
enclave means that hardware must automatically switch CPU context when
an Asynchronous Exiting Event (AEE) occurs, an AEE being any interrupt
or exception (exceptions are AEEs because asynchronous in this context
is relative to the enclave and not CPU execution, e.g. the enclave
doesn't get an opportunity to save/fuzz CPU state).

Like VM-Exits, all AEEs jump to a common location, referred to as the
Asynchronous Exiting Point (AEP).  The AEP is specified at enclave entry
via register passed to EENTER/ERESUME, similar to how the hypervisor
specifies the VM-Exit point (via VMCS.HOST_RIP at VMLAUNCH/VMRESUME).
Resuming the enclave/VM after the exiting event is handled is done via
ERESUME/VMRESUME respectively.  In SGX, AEEs that are handled by the
kernel, e.g. INTR, NMI and most page faults, IRET will journey back to
the AEP which then ERESUMEs th enclave.

Enclaves also behave a bit like VMs in the sense that they can generate
exceptions as part of their normal operation that for all intents and
purposes need to handled in the enclave/VM.  However, unlike VMX, SGX
doesn't allow the host to modify its guest's, a.k.a. enclave's, state,
as doing so would circumvent the enclave's security.  So to handle an
exception, the enclave must first be re-entered through the normal
EENTER flow (SYSCALL/SYSRET behavior), and then resumed via ERESUME
(VMRESUME behavior) after the source of the exception is resolved.

All of the above is just the tip of the iceberg when it comes to running
an enclave.  But, SGX was designed in such a way that the host process
can utilize an enclave agnostic library to build, launch and run an
enclave.  This is roughly analogous to how e.g. normal applications
leverage libc implementations and a standardized dynamic linker so that
the application on business logic instead of the gory details of system
calls, vDSO functions, dynamic linking, etc...

However, offloading the heavy lifting to a library comes with a rather
large caveat.  Because enclaves can generate *and* handle exceptions,
SGX libraries must be prepared to handle nearly any exception whenever
at least one thread is executing in an enclave.  On Linux, this means
the SGX library must register a signal handler in order to intercept
relevant exceptions and forward them to the enclave (or in some cases,
take action on behalf of the enclave).

Unfortunately, Linux's signal mechanism doesn't mesh well with libraries,
e.g. signal handlers are process wide, are difficult to chain, etc...
This becomes particularly nasty when using multiple levels of libraries
that register signal handlers, e.g. running an enclave via cgo inside of
the Go runtime.

Luckily, signals (due to exceptions) can be avoided entirely by taking
advantage of several key properties of SGX/enclaves:

  - Enclaves can only be entered through SGX-specific instructions,
    and all CPL3 SGX instructions share a single umbrella opcode under
    the mnemonic ENCLU.
  - When an event/exception occurs in an enclave, hardware preps the
    post-exit state so that executing ENCLU will automagically ERESUME
    the enclave.  This means that ENCLU[EENTER] and ENCLU[ERESUME] for
    an enclave can be the exact same ENCLU instruction.
  - Exceptions within the enclave appear to the kernel as if they
    occurred on the AEP, i.e. ENCLU[ERESUME].
  - Enclaves are essentially just shared objects with a specialized
    dynamic linker, so it's not unreasonable to require a process to
    use a single loader and entry point, i.e. ENCLU, for all enclaves.

So, to avoid forcing SGX libraries to juggle signal handlers, provide
an IOCTL through /dev/sgx to allow a process to register an exception
handler for a single per-mm, i.e. per-process, ENCLU instruction.  If
an unhandled exception occurs on the ENCLU, i.e. a signal would be
generated, load DI, SI and DX with the trap number, error code and
faulting address respectively in lieu of generating a signal.

Softly enforce the use of the ENCLU handler mechanism by refusing to
create enclaves for a process if it has not registered an ENCLU handler.
In other words, the only ABI supported by the Linux kernel for handling
exceptions on/in enclaves is to register an ENCLU exception handler.
Obviously a process can register a dummy handler, but such behavior is
NOT officially supported.

Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Haitao Huang <haitao.huang@linux.intel.com>
Cc: Jethro Beekman <jethro@fortanix.com>
Cc: Dr. Greg Wettstein <greg@enjellic.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/uapi/asm/sgx.h        | 23 ++++++++++++++++++-----
 arch/x86/kernel/cpu/sgx/driver/encl.c  |  6 ++++++
 arch/x86/kernel/cpu/sgx/driver/ioctl.c | 20 ++++++++++++++++++++
 3 files changed, 44 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
index 266b813eefa1..63bd64e9535d 100644
--- a/arch/x86/include/uapi/asm/sgx.h
+++ b/arch/x86/include/uapi/asm/sgx.h
@@ -10,20 +10,33 @@
 
 #define SGX_MAGIC 0xA4
 
+#define SGX_IOC_ENCLU_REGISTER \
+	_IOW(SGX_MAGIC, 0x00, struct sgx_enclu_register)
 #define SGX_IOC_ENCLAVE_CREATE \
-	_IOW(SGX_MAGIC, 0x00, struct sgx_enclave_create)
+	_IOW(SGX_MAGIC, 0x01, struct sgx_enclave_create)
 #define SGX_IOC_ENCLAVE_ADD_PAGE \
-	_IOW(SGX_MAGIC, 0x01, struct sgx_enclave_add_page)
+	_IOW(SGX_MAGIC, 0x02, struct sgx_enclave_add_page)
 #define SGX_IOC_ENCLAVE_INIT \
-	_IOW(SGX_MAGIC, 0x02, struct sgx_enclave_init)
+	_IOW(SGX_MAGIC, 0x03, struct sgx_enclave_init)
 #define SGX_IOC_ENCLAVE_REMOVE_PAGES \
-	_IOW(SGX_MAGIC, 0x03, struct sgx_enclave_remove_pages)
+	_IOW(SGX_MAGIC, 0x04, struct sgx_enclave_remove_pages)
 #define SGX_IOC_ENCLAVE_MODIFY_PAGES \
-	_IOW(SGX_MAGIC, 0x04, struct sgx_enclave_modify_pages)
+	_IOW(SGX_MAGIC, 0x05, struct sgx_enclave_modify_pages)
 
 /* IOCTL return values */
 #define SGX_POWER_LOST_ENCLAVE		0x40000000
 
+/**
+ * struct sgx_enclu_register - parameter structure for the
+ *                             %SGX_IOC_ENCLU_REGISTER ioctl
+ * @enclu:	address of the userspace process' ENCLU instruction
+ * @handler:	address of the userspace process' ENCLU exception handler
+ */
+struct sgx_enclu_register  {
+	__u64	enclu;
+	__u64	handler;
+};
+
 /**
  * struct sgx_enclave_create - parameter structure for the
  *                             %SGX_IOC_ENCLAVE_CREATE ioctl
diff --git a/arch/x86/kernel/cpu/sgx/driver/encl.c b/arch/x86/kernel/cpu/sgx/driver/encl.c
index 61a14cc310f4..ed5df48fba63 100644
--- a/arch/x86/kernel/cpu/sgx/driver/encl.c
+++ b/arch/x86/kernel/cpu/sgx/driver/encl.c
@@ -525,6 +525,12 @@ int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
 	}
 
 	down_read(&current->mm->mmap_sem);
+	if (!current->mm->context.enclu_address &&
+	    !current->mm->context.enclu_exception_handler) {
+		up_read(&current->mm->mmap_sem);
+		return -EFAULT;
+	}
+
 	ret = sgx_encl_find(current->mm, secs->base, &vma);
 	if (ret != -ENOENT) {
 		if (!ret)
diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
index 44edfcd9a6ff..66f2aadd8f0a 100644
--- a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
@@ -11,6 +11,23 @@
 #include <linux/slab.h>
 #include "driver.h"
 
+static long sgx_ioc_enclu_register(struct file *filep, unsigned int cmd,
+				   unsigned long arg)
+{
+	struct sgx_enclu_register *reg = (struct sgx_enclu_register *)arg;
+
+	if (reg->enclu == reg->handler)
+		return -EINVAL;
+
+	if (down_write_killable(&current->mm->mmap_sem))
+		return -EINTR;
+	current->mm->context.enclu_address = reg->enclu;
+	current->mm->context.enclu_exception_handler = reg->handler;
+	up_write(&current->mm->mmap_sem);
+
+	return 0;
+}
+
 static int sgx_encl_get(unsigned long addr, struct sgx_encl **encl)
 {
 	struct mm_struct *mm = current->mm;
@@ -317,6 +334,9 @@ long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 	long ret;
 
 	switch (cmd) {
+	case SGX_IOC_ENCLU_REGISTER:
+		handler = sgx_ioc_enclu_register;
+		break;
 	case SGX_IOC_ENCLAVE_CREATE:
 		handler = sgx_ioc_enclave_create;
 		break;
-- 
2.19.2

