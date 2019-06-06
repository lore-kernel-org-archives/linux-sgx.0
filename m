Return-Path: <SRS0=qw+Y=UF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E15AC28D18
	for <linux-sgx@archiver.kernel.org>; Thu,  6 Jun 2019 02:12:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4399320866
	for <linux-sgx@archiver.kernel.org>; Thu,  6 Jun 2019 02:12:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbfFFCMF (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 5 Jun 2019 22:12:05 -0400
Received: from mga17.intel.com ([192.55.52.151]:61631 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726721AbfFFCLv (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 5 Jun 2019 22:11:51 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Jun 2019 19:11:50 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.36])
  by orsmga004.jf.intel.com with ESMTP; 05 Jun 2019 19:11:49 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Cedric Xing <cedric.xing@intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>, selinux@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        linux-sgx@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, nhorman@redhat.com,
        npmccallum@redhat.com, Serge Ayoun <serge.ayoun@intel.com>,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Haitao Huang <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Kai Svahn <kai.svahn@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        Kai Huang <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>,
        William Roberts <william.c.roberts@intel.com>,
        Philip Tricca <philip.b.tricca@intel.com>
Subject: [RFC PATCH v2 2/5] x86/sgx: Require userspace to define enclave pages' protection bits
Date:   Wed,  5 Jun 2019 19:11:42 -0700
Message-Id: <20190606021145.12604-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190606021145.12604-1-sean.j.christopherson@intel.com>
References: <20190606021145.12604-1-sean.j.christopherson@intel.com>
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
require userspace to explicit define each page's protection bit when the
page is added to the enclave.  Enclave page protection bits pave the way
adding security_enclave_load() as an SGX equivalent to file_mprotect(),
e.g. SGX can pass the page's protection bits and source vma to LSMs.
The source vma will allow LSMs to tie permissions to files, e.g. the
file containing the enclave's code and initial data, and the protection
bits will allow LSMs to make decisions based on the capabilities of the
enclave, e.g. if a page can be converted from RW to RX.

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
potentially unwanted behavior such as mapping pages RW->RW or RWX.

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

Alternatively, SGX could pre-check what transitions are/aren't allowed
using some form of proxy for the enclave, e.g. its sigstruct, and
dynamically track protections in the SGX driver.  Dynamically tracking
protections and pre-checking permissions has several drawbacks:

  - Complicates the SGX implementation due to the need to coordinate
    tracking across multiple mm structs and vmas.

  - LSM auditing would log denials that never manifest in failure.

  - Requires additional SGX specific flags/definitions be passed to/from
    LSMs.

A second alternative would be to again use sigstruct as a proxy for the
enclave when performing access control checks, but hold a reference to
the sigstruct file and perform LSM checks during mmap()/mmprotect() as
opposed to pre-checking permissions at enclave build time.  The big
downside to this approach is that it effecitvely requires userspace to
place sigstruct in a file, and the SGX driver must "pin" said file by
holding a reference to the file for the lifetime of the enclave.

A third alternative would be to pull the protection bits from the page's
SECINFO, i.e. make decisions based on the protections enforced by
hardware.  However, with SGX2, userspace can extend the hardware-
enforced protections via ENCLU[EMODPE], e.g. can add a page as RW and
later convert it to RX.  With SGX2, making a decision based on the
initial protections would either create a security hole or force SGX to
dynamically track "dirty" pages (see first alternative above).

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/uapi/asm/sgx.h        |  2 +
 arch/x86/kernel/cpu/sgx/driver/ioctl.c | 14 +++++--
 arch/x86/kernel/cpu/sgx/driver/main.c  |  5 +++
 arch/x86/kernel/cpu/sgx/encl.c         | 53 ++++++++++++++++++++++++++
 arch/x86/kernel/cpu/sgx/encl.h         |  4 ++
 5 files changed, 74 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
index 9ed690a38c70..2c6198ffeaf8 100644
--- a/arch/x86/include/uapi/asm/sgx.h
+++ b/arch/x86/include/uapi/asm/sgx.h
@@ -37,12 +37,14 @@ struct sgx_enclave_create  {
  * @addr:	address within the ELRANGE
  * @src:	address for the page data
  * @secinfo:	address for the SECINFO data
+ * @flags:	flags, e.g. PROT_{READ,WRITE,EXEC}
  * @mrmask:	bitmask for the measured 256 byte chunks
  */
 struct sgx_enclave_add_page {
 	__u64	addr;
 	__u64	src;
 	__u64	secinfo;
+	__u32	flags;
 	__u16	mrmask;
 } __attribute__((__packed__));
 
diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
index a27ec26a9350..ef5c2ce0f37b 100644
--- a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
@@ -235,7 +235,8 @@ static int sgx_validate_secs(const struct sgx_secs *secs,
 }
 
 static struct sgx_encl_page *sgx_encl_page_alloc(struct sgx_encl *encl,
-						 unsigned long addr)
+						 unsigned long addr,
+						 unsigned long prot)
 {
 	struct sgx_encl_page *encl_page;
 	int ret;
@@ -247,6 +248,7 @@ static struct sgx_encl_page *sgx_encl_page_alloc(struct sgx_encl *encl,
 		return ERR_PTR(-ENOMEM);
 	encl_page->desc = addr;
 	encl_page->encl = encl;
+	encl_page->prot = prot;
 	ret = radix_tree_insert(&encl->page_tree, PFN_DOWN(encl_page->desc),
 				encl_page);
 	if (ret) {
@@ -531,7 +533,7 @@ static int __sgx_encl_add_page(struct sgx_encl *encl,
 
 static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long addr,
 			     void *data, struct sgx_secinfo *secinfo,
-			     unsigned int mrmask)
+			     unsigned int mrmask, unsigned long prot)
 {
 	u64 page_type = secinfo->flags & SGX_SECINFO_PAGE_TYPE_MASK;
 	struct sgx_encl_page *encl_page;
@@ -557,7 +559,7 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long addr,
 		goto out;
 	}
 
-	encl_page = sgx_encl_page_alloc(encl, addr);
+	encl_page = sgx_encl_page_alloc(encl, addr, prot);
 	if (IS_ERR(encl_page)) {
 		ret = PTR_ERR(encl_page);
 		goto out;
@@ -599,6 +601,7 @@ static long sgx_ioc_enclave_add_page(struct file *filep, unsigned int cmd,
 	struct sgx_enclave_add_page *addp = (void *)arg;
 	struct sgx_encl *encl = filep->private_data;
 	struct sgx_secinfo secinfo;
+	unsigned long prot;
 	struct page *data_page;
 	void *data;
 	int ret;
@@ -618,7 +621,10 @@ static long sgx_ioc_enclave_add_page(struct file *filep, unsigned int cmd,
 		goto out;
 	}
 
-	ret = sgx_encl_add_page(encl, addp->addr, data, &secinfo, addp->mrmask);
+	prot = addp->flags & (PROT_READ | PROT_WRITE | PROT_EXEC);
+
+	ret = sgx_encl_add_page(encl, addp->addr, data, &secinfo, addp->mrmask,
+				prot);
 	if (ret)
 		goto out;
 
diff --git a/arch/x86/kernel/cpu/sgx/driver/main.c b/arch/x86/kernel/cpu/sgx/driver/main.c
index 129d356aff30..65a87c2fdf02 100644
--- a/arch/x86/kernel/cpu/sgx/driver/main.c
+++ b/arch/x86/kernel/cpu/sgx/driver/main.c
@@ -63,6 +63,11 @@ static long sgx_compat_ioctl(struct file *filep, unsigned int cmd,
 static int sgx_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct sgx_encl *encl = file->private_data;
+	int ret;
+
+	ret = sgx_map_allowed(encl, vma->vm_start, vma->vm_end, vma->vm_flags);
+	if (ret)
+		return ret;
 
 	vma->vm_ops = &sgx_vm_ops;
 	vma->vm_flags |= VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP | VM_IO;
diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 7216bdf07bd0..a5a412220058 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -235,6 +235,58 @@ static void sgx_vma_close(struct vm_area_struct *vma)
 	kref_put(&encl->refcount, sgx_encl_release);
 }
 
+
+/**
+ * sgx_map_allowed - check vma protections against the associated enclave page
+ * @encl:	an enclave
+ * @start:	start address of the mapping (inclusive)
+ * @end:	end address of the mapping (exclusive)
+ * @prot:	protection bits of the mapping
+ *
+ * Verify a userspace mapping to an enclave page would not violate the security
+ * requirements of the *kernel*.  Note, this is in no way related to the
+ * page protections enforced by hardware via the EPCM.  The EPCM protections
+ * can be directly extended by the enclave, i.e. cannot be relied upon by the
+ * kernel for security guarantees of any kind.
+ *
+ * Return:
+ *   0 on success,
+ *   -EACCES if the mapping is disallowed
+ */
+int sgx_map_allowed(struct sgx_encl *encl, unsigned long start,
+		    unsigned long end, unsigned long prot)
+{
+	struct sgx_encl_page *page;
+	unsigned long addr;
+
+	prot &= (VM_READ | VM_WRITE | VM_EXEC);
+	if (!prot || !encl)
+		return 0;
+
+	mutex_lock(&encl->lock);
+
+	for (addr = start; addr < end; addr += PAGE_SIZE) {
+		page = radix_tree_lookup(&encl->page_tree, addr >> PAGE_SHIFT);
+
+		/*
+		 * Do not allow R|W|X to a non-existent page, or protections
+		 * beyond those of the existing enclave page.
+		 */
+		if (!page || (prot & ~page->prot))
+			return -EACCES;
+	}
+
+	mutex_unlock(&encl->lock);
+
+	return 0;
+}
+
+static int sgx_vma_mprotect(struct vm_area_struct *vma, unsigned long start,
+			    unsigned long end, unsigned long prot)
+{
+	return sgx_map_allowed(vma->vm_private_data, start, end, prot);
+}
+
 static unsigned int sgx_vma_fault(struct vm_fault *vmf)
 {
 	unsigned long addr = (unsigned long)vmf->address;
@@ -372,6 +424,7 @@ static int sgx_vma_access(struct vm_area_struct *vma, unsigned long addr,
 const struct vm_operations_struct sgx_vm_ops = {
 	.close = sgx_vma_close,
 	.open = sgx_vma_open,
+	.may_mprotect = sgx_vma_mprotect,
 	.fault = sgx_vma_fault,
 	.access = sgx_vma_access,
 };
diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
index c557f0374d74..176467c0eb22 100644
--- a/arch/x86/kernel/cpu/sgx/encl.h
+++ b/arch/x86/kernel/cpu/sgx/encl.h
@@ -41,6 +41,7 @@ enum sgx_encl_page_desc {
 
 struct sgx_encl_page {
 	unsigned long desc;
+	unsigned long prot;
 	struct sgx_epc_page *epc_page;
 	struct sgx_va_page *va_page;
 	struct sgx_encl *encl;
@@ -106,6 +107,9 @@ static inline unsigned long sgx_pcmd_offset(pgoff_t page_index)
 	       sizeof(struct sgx_pcmd);
 }
 
+int sgx_map_allowed(struct sgx_encl *encl, unsigned long start,
+		    unsigned long end, unsigned long prot);
+
 enum sgx_encl_mm_iter {
 	SGX_ENCL_MM_ITER_DONE		= 0,
 	SGX_ENCL_MM_ITER_NEXT		= 1,
-- 
2.21.0

