Return-Path: <SRS0=httf=UQ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 675C4C31E63
	for <linux-sgx@archiver.kernel.org>; Mon, 17 Jun 2019 22:24:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 484C82080A
	for <linux-sgx@archiver.kernel.org>; Mon, 17 Jun 2019 22:24:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728720AbfFQWYu (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 17 Jun 2019 18:24:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:43047 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726593AbfFQWYu (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 17 Jun 2019 18:24:50 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jun 2019 15:24:48 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.36])
  by orsmga005.jf.intel.com with ESMTP; 17 Jun 2019 15:24:47 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>,
        Stephen Smalley <sds@tycho.nsa.gov>
Subject: [RFC PATCH v3 04/12] x86/sgx: Require userspace to define enclave pages' protection bits
Date:   Mon, 17 Jun 2019 15:24:30 -0700
Message-Id: <20190617222438.2080-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190617222438.2080-1-sean.j.christopherson@intel.com>
References: <20190617222438.2080-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Existing Linux Security Module policies restrict userspace's ability to
map memory, e.g. may require priveleged permissions to map a page that
is simultaneously writable and executable.  Said permissions are often
tied to the file which backs the mapped memory, i.e. vm_file.

For reasons explained below, SGX does not allow LSMs to enforce policies
using existing LSM hooks such as file_mprotect().  Explicitly track the
protection bits for an enclave page (separate from the vma/pte bits) and
require userspace to explicit define a page's protection bits when the
page is added to the enclave.  Enclave page protection bits paves the
way to adding security_enclave_load() LSM hook as an SGX equivalent to
security_file_mprotect(), e.g. SGX can pass the page's protection bits
and source vma to LSMs.   The source vma will allow LSMs to tie
permissions to files, e.g. the file containing the enclave's code and
initial data, and the protection bits will allow LSMs to make decisions
based on the capabilities of the process, e.g. if a process is allowed
to load unmeasured code or load code from anonymous memory.

Due to the nature of the Enclave Page Cache, and because the EPC is
manually managed by SGX, all enclave vmas are backed by the same file,
i.e. /dev/sgx/enclave.  Specifically, a single file allows SGX to use
file op hooks to move pages in/out of the EPC.

Furthermore, EPC pages for any given enclave are fundamentally shared
between processes, i.e. CoW semantics are not possible with EPC pages
due to hardware restrictions such as 1:1 mappings between virtual and
physical addresses (within the enclave).

Lastly, all real world enclaves will need read, write and execute
permissions to EPC pages.

As a result, SGX does not play nice with existing LSM behavior as it is
impossible to apply policies to enclaves with reasonable granularity,
e.g. an LSM can deny access to EPC altogether, but can't deny
potentially unwanted behavior such as mapping pages WX, loading code
from anonymous memory, loading unmeasured code, etc...

For example, because all (practical) enclaves need RW pages for data and
RX pages for code, SELinux's existing policies will require all enclaves
to have FILE__READ, FILE__WRITE and FILE__EXECUTE permissions on
/dev/sgx/enclave.  Witholding FILE__WRITE or FILE__EXECUTE in an attempt
to deny RW->RX or RWX would prevent running *any* enclave, even those
that cleanly separate RW and RX pages.  And because /dev/sgx/enclave
requires MAP_SHARED, the anonymous/CoW checks that would trigger
FILE__EXECMOD or PROCESS__EXECMEM permissions will never fire.

Taking protection bits has a second use in that it can be used to
prevent loading an enclave from a noexec file system.  On SGX2 hardware,
regardless of kernel support for SGX2, userspace could EADD a page from
a noexec path using read-only permissions and later mprotect() and
ENCLU[EMODPE] the page to gain execute permissions.  By requiring
the enclave's page protections up front, SGX will be able to enforce
noexec paths when building enclaves.

To prevent userspace from circumventing the allowed protections, do not
allow PROT_{READ,WRITE,EXEC} mappings to an enclave without an
associated enclave page, i.e. prevent creating a mapping with unchecked
protection bits.

Many alternatives[1][2] have been explored, most notably the concept of
having SGX check (at load time) and save the permissions of the enclave
loader.  The permissions would then be enforced by SGX at run time, e.g.
via mmap()/mprotect() hooks of some form.  The basic functionality of
pre-checking permissions is relatively straightforward, but supporting
LSM auditing is complex and fraught with pitfalls.  If auditing is done
at the time of denial then the audit logs will potentially show a large
number of false positives.  Auditing when the denial is enforced, e.g.
at mprotect(), suffers from its own problems, e.g.:

  - Requires LSMs to pre-generate audit messages so that they can be
    replayed by SGX when the denial is actually enforced.

  - System changes can result in stale audit messages, e.g. if files
    are removed from the system, an LSM profile is modified, etc...

  - A process could log what is essentially a false positive denial,
    e.g. if the current process has the requisite capability but the
    original enclave loader did not.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/uapi/asm/sgx.h        |  5 +--
 arch/x86/kernel/cpu/sgx/driver/ioctl.c | 15 +++++---
 arch/x86/kernel/cpu/sgx/driver/main.c  | 49 ++++++++++++++++++++++++++
 arch/x86/kernel/cpu/sgx/encl.h         |  1 +
 tools/testing/selftests/x86/sgx/main.c | 32 +++++++++++++++--
 5 files changed, 93 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
index 6dba9f282232..4144242ab690 100644
--- a/arch/x86/include/uapi/asm/sgx.h
+++ b/arch/x86/include/uapi/asm/sgx.h
@@ -35,15 +35,16 @@ struct sgx_enclave_create  {
  * @src:	address for the page data
  * @secinfo:	address for the SECINFO data
  * @mrmask:	bitmask for the measured 256 byte chunks
+ * @flags:	flags, e.g. PROT_{READ,WRITE,EXEC}
  */
 struct sgx_enclave_add_page {
 	__u64	addr;
 	__u64	src;
 	__u64	secinfo;
-	__u64	mrmask;
+	__u32	mrmask;
+	__u32	flags;
 };
 
-
 /**
  * struct sgx_enclave_init - parameter structure for the
  *                           %SGX_IOC_ENCLAVE_INIT ioctl
diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
index 3552d642b26f..8e95e45411f2 100644
--- a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
@@ -2,6 +2,7 @@
 // Copyright(c) 2016-19 Intel Corporation.
 
 #include <asm/mman.h>
+#include <linux/mman.h>
 #include <linux/delay.h>
 #include <linux/file.h>
 #include <linux/hashtable.h>
@@ -235,7 +236,8 @@ static int sgx_validate_secs(const struct sgx_secs *secs,
 }
 
 static struct sgx_encl_page *sgx_encl_page_alloc(struct sgx_encl *encl,
-						 unsigned long addr)
+						 unsigned long addr,
+						 unsigned long prot)
 {
 	struct sgx_encl_page *encl_page;
 	int ret;
@@ -247,6 +249,7 @@ static struct sgx_encl_page *sgx_encl_page_alloc(struct sgx_encl *encl,
 		return ERR_PTR(-ENOMEM);
 	encl_page->desc = addr;
 	encl_page->encl = encl;
+	encl_page->vm_prot_bits = calc_vm_prot_bits(prot, 0);
 	ret = radix_tree_insert(&encl->page_tree, PFN_DOWN(encl_page->desc),
 				encl_page);
 	if (ret) {
@@ -517,7 +520,7 @@ static int __sgx_encl_add_page(struct sgx_encl *encl,
 
 static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long addr,
 			     void *data, struct sgx_secinfo *secinfo,
-			     unsigned int mrmask)
+			     unsigned int mrmask, unsigned long prot)
 {
 	u64 page_type = secinfo->flags & SGX_SECINFO_PAGE_TYPE_MASK;
 	struct sgx_encl_page *encl_page;
@@ -543,7 +546,7 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long addr,
 		goto out;
 	}
 
-	encl_page = sgx_encl_page_alloc(encl, addr);
+	encl_page = sgx_encl_page_alloc(encl, addr, prot);
 	if (IS_ERR(encl_page)) {
 		ret = PTR_ERR(encl_page);
 		goto out;
@@ -584,6 +587,7 @@ static long sgx_ioc_enclave_add_page(struct file *filep, void __user *arg)
 	struct sgx_enclave_add_page addp;
 	struct sgx_secinfo secinfo;
 	struct page *data_page;
+	unsigned long prot;
 	void *data;
 	int ret;
 
@@ -605,7 +609,10 @@ static long sgx_ioc_enclave_add_page(struct file *filep, void __user *arg)
 		goto out;
 	}
 
-	ret = sgx_encl_add_page(encl, addp.addr, data, &secinfo, addp.mrmask);
+	prot = addp.flags & (PROT_READ | PROT_WRITE | PROT_EXEC);
+
+	ret = sgx_encl_add_page(encl, addp.addr, data, &secinfo, addp.mrmask,
+				prot);
 	if (ret)
 		goto out;
 
diff --git a/arch/x86/kernel/cpu/sgx/driver/main.c b/arch/x86/kernel/cpu/sgx/driver/main.c
index d7de4d9aea87..cfc348b44ffb 100644
--- a/arch/x86/kernel/cpu/sgx/driver/main.c
+++ b/arch/x86/kernel/cpu/sgx/driver/main.c
@@ -79,17 +79,66 @@ static int sgx_encl_mm_add(struct sgx_encl *encl, struct mm_struct *mm)
 	return 0;
 }
 
+/*
+ * Returns the AND of VM_{READ,WRITE,EXEC} permissions across all pages
+ * covered by the specific VMA.  A non-existent (or yet to be added) enclave
+ * page is considered to have no RWX permissions, i.e. is inaccessible.
+ */
+static unsigned long sgx_allowed_rwx(struct sgx_encl *encl,
+				     struct vm_area_struct *vma)
+{
+	unsigned long allowed_rwx = VM_READ | VM_WRITE | VM_EXEC;
+	unsigned long idx, idx_start, idx_end;
+	struct sgx_encl_page *page;
+
+	idx_start = PFN_DOWN(vma->vm_start);
+	idx_end = PFN_DOWN(vma->vm_end - 1);
+
+	for (idx = idx_start; idx <= idx_end; ++idx) {
+		/*
+		 * No need to take encl->lock, vm_prot_bits is set prior to
+		 * insertion and never changes, and racing with adding pages is
+		 * a userspace bug.
+		 */
+		rcu_read_lock();
+		page = radix_tree_lookup(&encl->page_tree, idx);
+		rcu_read_unlock();
+
+		/* Do not allow R|W|X to a non-existent page. */
+		if (!page)
+			allowed_rwx = 0;
+		else
+			allowed_rwx &= page->vm_prot_bits;
+		if (!allowed_rwx)
+			break;
+	}
+
+	return allowed_rwx;
+}
+
 static int sgx_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct sgx_encl *encl = file->private_data;
+	unsigned long allowed_rwx;
 	int ret;
 
+	allowed_rwx = sgx_allowed_rwx(encl, vma);
+	if (vma->vm_flags & (VM_READ | VM_WRITE | VM_EXEC) & ~allowed_rwx)
+		return -EACCES;
+
 	if (!sgx_encl_get_mm(encl, vma->vm_mm)) {
 		ret = sgx_encl_mm_add(encl, vma->vm_mm);
 		if (ret)
 			return ret;
 	}
 
+	if (!(allowed_rwx & VM_READ))
+		vma->vm_flags &= ~VM_MAYREAD;
+	if (!(allowed_rwx & VM_WRITE))
+		vma->vm_flags &= ~VM_MAYWRITE;
+	if (!(allowed_rwx & VM_EXEC))
+		vma->vm_flags &= ~VM_MAYEXEC;
+
 	vma->vm_ops = &sgx_vm_ops;
 	vma->vm_flags |= VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP | VM_IO;
 	vma->vm_private_data = encl;
diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
index 7b339334d875..5cb0f2653d4c 100644
--- a/arch/x86/kernel/cpu/sgx/encl.h
+++ b/arch/x86/kernel/cpu/sgx/encl.h
@@ -41,6 +41,7 @@ enum sgx_encl_page_desc {
 
 struct sgx_encl_page {
 	unsigned long desc;
+	unsigned long vm_prot_bits;
 	struct sgx_epc_page *epc_page;
 	struct sgx_va_page *va_page;
 	struct sgx_encl *encl;
diff --git a/tools/testing/selftests/x86/sgx/main.c b/tools/testing/selftests/x86/sgx/main.c
index e2265f841fb0..e14a34adc0e4 100644
--- a/tools/testing/selftests/x86/sgx/main.c
+++ b/tools/testing/selftests/x86/sgx/main.c
@@ -2,6 +2,7 @@
 // Copyright(c) 2016-18 Intel Corporation.
 
 #include <elf.h>
+#include <errno.h>
 #include <fcntl.h>
 #include <stdbool.h>
 #include <stdio.h>
@@ -18,6 +19,8 @@
 #include "../../../../../arch/x86/kernel/cpu/sgx/arch.h"
 #include "../../../../../arch/x86/include/uapi/asm/sgx.h"
 
+#define PAGE_SIZE  4096
+
 static const uint64_t MAGIC = 0x1122334455667788ULL;
 
 struct vdso_symtab {
@@ -135,8 +138,7 @@ static bool encl_create(int dev_fd, unsigned long bin_size,
 	for (secs->size = 4096; secs->size < bin_size; )
 		secs->size <<= 1;
 
-	base = mmap(NULL, secs->size, PROT_READ | PROT_WRITE | PROT_EXEC,
-		    MAP_SHARED, dev_fd, 0);
+	base = mmap(NULL, secs->size, PROT_NONE, MAP_SHARED, dev_fd, 0);
 	if (base == MAP_FAILED) {
 		perror("mmap");
 		return false;
@@ -147,7 +149,7 @@ static bool encl_create(int dev_fd, unsigned long bin_size,
 	ioc.src = (unsigned long)secs;
 	rc = ioctl(dev_fd, SGX_IOC_ENCLAVE_CREATE, &ioc);
 	if (rc) {
-		fprintf(stderr, "ECREATE failed rc=%d.\n", rc);
+		fprintf(stderr, "ECREATE failed rc=%d, err=%d.\n", rc, errno);
 		munmap(base, secs->size);
 		return false;
 	}
@@ -160,8 +162,14 @@ static bool encl_add_page(int dev_fd, unsigned long addr, void *data,
 {
 	struct sgx_enclave_add_page ioc;
 	struct sgx_secinfo secinfo;
+	unsigned long prot;
 	int rc;
 
+	if (flags == SGX_SECINFO_TCS)
+		prot = PROT_READ | PROT_WRITE;
+	else
+		prot = PROT_READ | PROT_WRITE | PROT_EXEC;
+
 	memset(&secinfo, 0, sizeof(secinfo));
 	secinfo.flags = flags;
 
@@ -169,6 +177,7 @@ static bool encl_add_page(int dev_fd, unsigned long addr, void *data,
 	ioc.mrmask = 0xFFFF;
 	ioc.addr = addr;
 	ioc.src = (uint64_t)data;
+	ioc.flags = prot;
 
 	rc = ioctl(dev_fd, SGX_IOC_ENCLAVE_ADD_PAGE, &ioc);
 	if (rc) {
@@ -184,6 +193,7 @@ static bool encl_load(struct sgx_secs *secs, unsigned long bin_size)
 	struct sgx_enclave_init ioc;
 	uint64_t offset;
 	uint64_t flags;
+	void *addr;
 	int dev_fd;
 	int rc;
 
@@ -215,6 +225,22 @@ static bool encl_load(struct sgx_secs *secs, unsigned long bin_size)
 		goto out_map;
 	}
 
+	addr = mmap((void *)secs->base, PAGE_SIZE, PROT_READ | PROT_WRITE,
+		    MAP_SHARED | MAP_FIXED, dev_fd, 0);
+	if (addr == MAP_FAILED) {
+		fprintf(stderr, "mmap() failed on TCS, errno=%d.\n", errno);
+		return false;
+	}
+
+	addr = mmap((void *)(secs->base + PAGE_SIZE), bin_size - PAGE_SIZE,
+		    PROT_READ | PROT_WRITE | PROT_EXEC,
+		    MAP_SHARED | MAP_FIXED, dev_fd, 0);
+	if (addr == MAP_FAILED) {
+		fprintf(stderr, "mmap() failed, errno=%d.\n", errno);
+		return false;
+	}
+
+
 	close(dev_fd);
 	return true;
 out_map:
-- 
2.21.0

