Return-Path: <SRS0=6XgF=UE=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FB85C28CC5
	for <linux-sgx@archiver.kernel.org>; Wed,  5 Jun 2019 19:49:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54E932083E
	for <linux-sgx@archiver.kernel.org>; Wed,  5 Jun 2019 19:49:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbfFETta (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 5 Jun 2019 15:49:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:2919 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726501AbfFETta (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 5 Jun 2019 15:49:30 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Jun 2019 12:49:28 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.36])
  by orsmga008.jf.intel.com with ESMTP; 05 Jun 2019 12:49:27 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@intel.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Subject: [PATCH 4/7] x86/sgx: Allow userspace to add multiple pages in single ioctl()
Date:   Wed,  5 Jun 2019 12:48:42 -0700
Message-Id: <20190605194845.926-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190605194845.926-1-sean.j.christopherson@intel.com>
References: <20190605194845.926-1-sean.j.christopherson@intel.com>
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

On an error, update the userspace struct to reflect progress made, e.g.
so that the ioctl can be re-invoked to finish adding pages after a non-
fatal error.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 Documentation/x86/sgx/3.API.rst        |   2 +-
 arch/x86/include/uapi/asm/sgx.h        |  21 ++--
 arch/x86/kernel/cpu/sgx/driver/ioctl.c | 128 +++++++++++++++++--------
 3 files changed, 98 insertions(+), 53 deletions(-)

diff --git a/Documentation/x86/sgx/3.API.rst b/Documentation/x86/sgx/3.API.rst
index b113aeb05f54..44550aa41073 100644
--- a/Documentation/x86/sgx/3.API.rst
+++ b/Documentation/x86/sgx/3.API.rst
@@ -22,6 +22,6 @@ controls the `PROVISON_KEY` attribute.
 
 .. kernel-doc:: arch/x86/kernel/cpu/sgx/driver/ioctl.c
    :functions: sgx_ioc_enclave_create
-               sgx_ioc_enclave_add_page
+               sgx_ioc_enclave_add_region
                sgx_ioc_enclave_init
                sgx_ioc_enclave_set_attribute
diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
index 9ed690a38c70..30d114f6b3bd 100644
--- a/arch/x86/include/uapi/asm/sgx.h
+++ b/arch/x86/include/uapi/asm/sgx.h
@@ -12,8 +12,8 @@
 
 #define SGX_IOC_ENCLAVE_CREATE \
 	_IOW(SGX_MAGIC, 0x00, struct sgx_enclave_create)
-#define SGX_IOC_ENCLAVE_ADD_PAGE \
-	_IOW(SGX_MAGIC, 0x01, struct sgx_enclave_add_page)
+#define SGX_IOC_ENCLAVE_ADD_REGION \
+	_IOWR(SGX_MAGIC, 0x01, struct sgx_enclave_add_region)
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
+ * struct sgx_enclave_add_region - parameter structure for the
+ *                                 %SGX_IOC_ENCLAVE_ADD_REGION ioctl
+ * @addr:	start address within the ELRANGE
+ * @src:	start address for the pages' data
+ * @size:	size of region, in bytes
+ * @secinfo:	address of the SECINFO data (common to the entire region)
+ * @mrmask:	bitmask of 256 byte chunks to measure (applied per 4k page)
  */
-struct sgx_enclave_add_page {
+struct sgx_enclave_add_region {
 	__u64	addr;
 	__u64	src;
+	__u64	size;
 	__u64	secinfo;
 	__u16	mrmask;
 } __attribute__((__packed__));
 
-
 /**
  * struct sgx_enclave_init - parameter structure for the
  *                           %SGX_IOC_ENCLAVE_INIT ioctl
diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
index d17c60dca114..b69350696b87 100644
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
@@ -575,57 +574,102 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long addr,
 	return ret;
 }
 
-/**
- * sgx_ioc_enclave_add_page - handler for %SGX_IOC_ENCLAVE_ADD_PAGE
- *
- * @filep:	open file to /dev/sgx
- * @arg:	userspace pointer to a struct sgx_enclave_add_page instance
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
-static long sgx_ioc_enclave_add_page(struct file *filep, void __user *arg)
+static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long addr,
+			     unsigned long src, struct sgx_secinfo *secinfo,
+			     unsigned int mrmask)
 {
-	struct sgx_encl *encl = filep->private_data;
-	struct sgx_enclave_add_page addp;
-	struct sgx_secinfo secinfo;
 	struct page *data_page;
 	void *data;
 	int ret;
 
-	if (copy_from_user(&addp, arg, sizeof(addp)))
-		return -EFAULT;
-
-	if (copy_from_user(&secinfo, (void __user *)addp.secinfo,
-			   sizeof(secinfo)))
-		return -EFAULT;
-
 	data_page = alloc_page(GFP_HIGHUSER);
 	if (!data_page)
 		return -ENOMEM;
 
 	data = kmap(data_page);
 
-	if (copy_from_user((void *)data, (void __user *)addp.src, PAGE_SIZE)) {
+	if (copy_from_user((void *)data, (void __user *)src, PAGE_SIZE)) {
 		ret = -EFAULT;
 		goto out;
 	}
 
-	ret = sgx_encl_add_page(encl, addp.addr, data, &secinfo, addp.mrmask);
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
+ * sgx_ioc_enclave_add_region - handler for %SGX_IOC_ENCLAVE_ADD_REGION
+ *
+ * @filep:	open file to /dev/sgx
+ * @arg:	userspace pointer to a struct sgx_enclave_add_region instance
+ *
+ * Add a range of pages to an uninitialized enclave (EADD), and optionally
+ * extend the enclave's measurement with the contents of the page (EEXTEND).
+ * The range of pages must be virtually contiguous.  The SECINFO and
+ * measurement maskare applied to all pages, i.e. pages with different
+ * properties must be added in separate calls.
+ *
+ * EADD and EEXTEND are done asynchronously via worker threads.  A successful
+ * sgx_ioc_enclave_add_region() only indicates the pages have been added to the
+ * work queue, it does not guarantee adding the pages to the enclave will
+ * succeed.
+ *
+ * On failure, @arg->addr, @arg->src and @arg->size are adjusted to reflect
+ * the remaining pages that need to be added to the enclave, i.e. userspace
+ * can re-invoke SGX_IOC_ENCLAVE_ADD_REGION using the same struct.
+ *
+ * Return:
+ *   0 on success,
+ *   -errno otherwise
+ */
+static long sgx_ioc_enclave_add_region(struct file *filep, void __user *arg)
+{
+	struct sgx_encl *encl = filep->private_data;
+	struct sgx_enclave_add_region region;
+	struct sgx_secinfo secinfo;
+	unsigned long i;
+	int ret;
+
+	if (copy_from_user(&region, arg, sizeof(region)))
+		return -EFAULT;
+
+	if (!IS_ALIGNED(region.addr, 4096) || !IS_ALIGNED(region.size, 4096))
+		return -EINVAL;
+
+	if (!region.size)
+		return 0;
+
+	if (copy_from_user(&secinfo, (void __user *)region.secinfo,
+			   sizeof(secinfo)))
+		return -EFAULT;
+
+	ret = 0;
+	for (i = 0; i < region.size; i += PAGE_SIZE) {
+		if (signal_pending(current)) {
+			ret = -ERESTARTSYS;
+			break;
+		}
+
+		if (need_resched())
+			cond_resched();
+
+		ret = sgx_encl_add_page(encl, region.addr + i, region.src + i,
+					&secinfo, region.mrmask);
+		if (ret)
+			break;
+	}
+	if (ret && i) {
+		region.addr += i;
+		region.src  += i;
+		region.size -= i;
+
+		if (copy_to_user(arg, &region, sizeof(region)))
+			return -EFAULT;
+	}
 	return ret;
 }
 
@@ -817,8 +861,8 @@ long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 	switch (cmd) {
 	case SGX_IOC_ENCLAVE_CREATE:
 		return sgx_ioc_enclave_create(filep, (void __user *)arg);
-	case SGX_IOC_ENCLAVE_ADD_PAGE:
-		return sgx_ioc_enclave_add_page(filep, (void __user *)arg);
+	case SGX_IOC_ENCLAVE_ADD_REGION:
+		return sgx_ioc_enclave_add_region(filep, (void __user *)arg);
 	case SGX_IOC_ENCLAVE_INIT:
 		return sgx_ioc_enclave_init(filep, (void __user *)arg);
 	case SGX_IOC_ENCLAVE_SET_ATTRIBUTE:
-- 
2.21.0

