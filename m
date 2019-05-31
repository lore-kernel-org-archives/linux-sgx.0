Return-Path: <SRS0=g3U3=T7=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8238DC28CC2
	for <linux-sgx@archiver.kernel.org>; Fri, 31 May 2019 23:33:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5AF7F25725
	for <linux-sgx@archiver.kernel.org>; Fri, 31 May 2019 23:33:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbfEaXch (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 31 May 2019 19:32:37 -0400
Received: from mga07.intel.com ([134.134.136.100]:59345 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726550AbfEaXcd (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 31 May 2019 19:32:33 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 May 2019 16:32:30 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.36])
  by orsmga008.jf.intel.com with ESMTP; 31 May 2019 16:32:30 -0700
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
Subject: [RFC PATCH 3/9] x86/sgx: Allow userspace to add multiple pages in single ioctl()
Date:   Fri, 31 May 2019 16:31:53 -0700
Message-Id: <20190531233159.30992-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190531233159.30992-1-sean.j.christopherson@intel.com>
References: <20190531233159.30992-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

...to improve performance when building enclaves by reducing the number
of user<->system transitions.  Rather than provide arbitrary batching,
e.g. with per-page SECINFO and mrmask, take advantage of the fact that
any sane enclave will have large swaths of pages with identical
properties, e.g. code vs. data sections.

For simplicity and stability in the initial implementation, loop over
the existing add page flow instead of taking a more agressive approach,
which would require tracking transitions between VMAs and holding
mmap_sem for an extended duration.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/uapi/asm/sgx.h        |  21 ++---
 arch/x86/kernel/cpu/sgx/driver/ioctl.c | 104 +++++++++++++++----------
 2 files changed, 74 insertions(+), 51 deletions(-)

diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
index 9ed690a38c70..4a12d6abbcb7 100644
--- a/arch/x86/include/uapi/asm/sgx.h
+++ b/arch/x86/include/uapi/asm/sgx.h
@@ -12,8 +12,8 @@
 
 #define SGX_IOC_ENCLAVE_CREATE \
 	_IOW(SGX_MAGIC, 0x00, struct sgx_enclave_create)
-#define SGX_IOC_ENCLAVE_ADD_PAGE \
-	_IOW(SGX_MAGIC, 0x01, struct sgx_enclave_add_page)
+#define SGX_IOC_ENCLAVE_ADD_PAGES \
+	_IOW(SGX_MAGIC, 0x01, struct sgx_enclave_add_pages)
 #define SGX_IOC_ENCLAVE_INIT \
 	_IOW(SGX_MAGIC, 0x02, struct sgx_enclave_init)
 #define SGX_IOC_ENCLAVE_SET_ATTRIBUTE \
@@ -32,21 +32,22 @@ struct sgx_enclave_create  {
 };
 
 /**
- * struct sgx_enclave_add_page - parameter structure for the
- *                               %SGX_IOC_ENCLAVE_ADD_PAGE ioctl
- * @addr:	address within the ELRANGE
- * @src:	address for the page data
- * @secinfo:	address for the SECINFO data
- * @mrmask:	bitmask for the measured 256 byte chunks
+ * struct sgx_enclave_add_pages - parameter structure for the
+ *                                %SGX_IOC_ENCLAVE_ADD_PAGES ioctl
+ * @addr:	start address within the ELRANGE
+ * @src:	start address for the pages' data
+ * @secinfo:	address for the SECINFO data (common to all pages)
+ * @nr_pages:	number of pages (must be virtually contiguous)
+ * @mrmask:	bitmask for the measured 256 byte chunks (common to all pages)
  */
-struct sgx_enclave_add_page {
+struct sgx_enclave_add_pages {
 	__u64	addr;
 	__u64	src;
 	__u64	secinfo;
+	__u32	nr_pages;
 	__u16	mrmask;
 } __attribute__((__packed__));
 
-
 /**
  * struct sgx_enclave_init - parameter structure for the
  *                           %SGX_IOC_ENCLAVE_INIT ioctl
diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
index a27ec26a9350..6acfcbdeca9a 100644
--- a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
@@ -487,10 +487,9 @@ static int sgx_validate_tcs(struct sgx_encl *encl, struct sgx_tcs *tcs)
 	return 0;
 }
 
-static int __sgx_encl_add_page(struct sgx_encl *encl,
+static int sgx_encl_queue_page(struct sgx_encl *encl,
 			       struct sgx_encl_page *encl_page,
-			       void *data,
-			       struct sgx_secinfo *secinfo,
+			       void *data, struct sgx_secinfo *secinfo,
 			       unsigned int mrmask)
 {
 	unsigned long page_index = sgx_encl_get_index(encl, encl_page);
@@ -529,9 +528,9 @@ static int __sgx_encl_add_page(struct sgx_encl *encl,
 	return 0;
 }
 
-static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long addr,
-			     void *data, struct sgx_secinfo *secinfo,
-			     unsigned int mrmask)
+static int __sgx_encl_add_page(struct sgx_encl *encl, unsigned long addr,
+			       void *data, struct sgx_secinfo *secinfo,
+			       unsigned int mrmask)
 {
 	u64 page_type = secinfo->flags & SGX_SECINFO_PAGE_TYPE_MASK;
 	struct sgx_encl_page *encl_page;
@@ -563,7 +562,7 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long addr,
 		goto out;
 	}
 
-	ret = __sgx_encl_add_page(encl, encl_page, data, secinfo, mrmask);
+	ret = sgx_encl_queue_page(encl, encl_page, data, secinfo, mrmask);
 	if (ret) {
 		radix_tree_delete(&encl_page->encl->page_tree,
 				  PFN_DOWN(encl_page->desc));
@@ -575,56 +574,79 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long addr,
 	return ret;
 }
 
-/**
- * sgx_ioc_enclave_add_page - handler for %SGX_IOC_ENCLAVE_ADD_PAGE
- *
- * @filep:	open file to /dev/sgx
- * @cmd:	the command value
- * @arg:	pointer to an &sgx_enclave_add_page instance
- *
- * Add a page to an uninitialized enclave (EADD), and optionally extend the
- * enclave's measurement with the contents of the page (EEXTEND).  EADD and
- * EEXTEND are done asynchronously via worker threads.  A successful
- * sgx_ioc_enclave_add_page() only indicates the page has been added to the
- * work queue, it does not guarantee adding the page to the enclave will
- * succeed.
- *
- * Return:
- *   0 on success,
- *   -errno otherwise
- */
-static long sgx_ioc_enclave_add_page(struct file *filep, unsigned int cmd,
-				     unsigned long arg)
+static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long addr,
+			     unsigned long src, struct sgx_secinfo *secinfo,
+			     unsigned int mrmask)
 {
-	struct sgx_enclave_add_page *addp = (void *)arg;
-	struct sgx_encl *encl = filep->private_data;
-	struct sgx_secinfo secinfo;
 	struct page *data_page;
 	void *data;
 	int ret;
 
-	if (copy_from_user(&secinfo, (void __user *)addp->secinfo,
-			   sizeof(secinfo)))
-		return -EFAULT;
-
 	data_page = alloc_page(GFP_HIGHUSER);
 	if (!data_page)
 		return -ENOMEM;
 
 	data = kmap(data_page);
 
-	if (copy_from_user((void *)data, (void __user *)addp->src, PAGE_SIZE)) {
+	if (copy_from_user((void *)data, (void __user *)src, PAGE_SIZE)) {
 		ret = -EFAULT;
 		goto out;
 	}
 
-	ret = sgx_encl_add_page(encl, addp->addr, data, &secinfo, addp->mrmask);
-	if (ret)
-		goto out;
-
+	ret = __sgx_encl_add_page(encl, addr, data, secinfo, mrmask);
 out:
 	kunmap(data_page);
 	__free_page(data_page);
+
+	return ret;
+}
+
+/**
+ * sgx_ioc_enclave_add_pages - handler for %SGX_IOC_ENCLAVE_ADD_PAGES
+ *
+ * @filep:	open file to /dev/sgx
+ * @cmd:	the command value
+ * @arg:	pointer to an &sgx_enclave_add_page instance
+ *
+ * Add a range of pages to an uninitialized enclave (EADD), and optionally
+ * extend the enclave's measurement with the contents of the page (EEXTEND).
+ * The range of pages must be virtually contiguous.  The SECINFO and
+ * measurement maskare applied to all pages, i.e. pages with different
+ * properties must be added in separate calls.
+ *
+ * EADD and EEXTEND are done asynchronously via worker threads.  A successful
+ * sgx_ioc_enclave_add_page() only indicates the pages have been added to the
+ * work queue, it does not guarantee adding the pages to the enclave will
+ * succeed.
+ *
+ * Return:
+ *   0 on success,
+ *   -errno otherwise
+ */
+static long sgx_ioc_enclave_add_pages(struct file *filep, unsigned int cmd,
+				      unsigned long arg)
+{
+	struct sgx_enclave_add_pages *addp = (void *)arg;
+	struct sgx_encl *encl = filep->private_data;
+	struct sgx_secinfo secinfo;
+	unsigned int i;
+	int ret;
+
+	if (copy_from_user(&secinfo, (void __user *)addp->secinfo,
+			   sizeof(secinfo)))
+		return -EFAULT;
+
+	for (i = 0, ret = 0; i < addp->nr_pages && !ret; i++) {
+		if (signal_pending(current))
+			return -ERESTARTSYS;
+
+		if (need_resched())
+			cond_resched();
+
+		ret = sgx_encl_add_page(encl, addp->addr + i*PAGE_SIZE,
+					addp->src + i*PAGE_SIZE,
+					&secinfo, addp->mrmask);
+	}
 	return ret;
 }
 
@@ -823,8 +845,8 @@ long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 	case SGX_IOC_ENCLAVE_CREATE:
 		handler = sgx_ioc_enclave_create;
 		break;
-	case SGX_IOC_ENCLAVE_ADD_PAGE:
-		handler = sgx_ioc_enclave_add_page;
+	case SGX_IOC_ENCLAVE_ADD_PAGES:
+		handler = sgx_ioc_enclave_add_pages;
 		break;
 	case SGX_IOC_ENCLAVE_INIT:
 		handler = sgx_ioc_enclave_init;
-- 
2.21.0

