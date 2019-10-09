Return-Path: <SRS0=7vij=YC=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E776DECE598
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Oct 2019 04:42:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C98CD206C0
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Oct 2019 04:42:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730358AbfJIEmo (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 9 Oct 2019 00:42:44 -0400
Received: from mga11.intel.com ([192.55.52.93]:6369 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729472AbfJIEmo (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 9 Oct 2019 00:42:44 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Oct 2019 21:42:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,273,1566889200"; 
   d="scan'208";a="218504419"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga004.fm.intel.com with ESMTP; 08 Oct 2019 21:42:43 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v23 3/7] x86/sgx: Tweak ADD_PAGE ioctl to allow adding multiple pages
Date:   Tue,  8 Oct 2019 21:42:37 -0700
Message-Id: <20191009044241.3591-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191009044241.3591-1-sean.j.christopherson@intel.com>
References: <20191009044241.3591-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Add a nr_pages param to the ioctl for adding pages to the enclave so
that userspace can batch multiple pages in a single syscall.  Update the
offset, src and nr_pages params prior to returning to userspace so that
the caller has sufficient information to analyze failures and can easily
restart the ioctl when appropriate.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/uapi/asm/sgx.h | 16 ++++----
 arch/x86/kernel/cpu/sgx/ioctl.c | 68 +++++++++++++++++++++++++--------
 2 files changed, 61 insertions(+), 23 deletions(-)

diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
index 67583b046af1..84734229d8dd 100644
--- a/arch/x86/include/uapi/asm/sgx.h
+++ b/arch/x86/include/uapi/asm/sgx.h
@@ -12,8 +12,8 @@
 
 #define SGX_IOC_ENCLAVE_CREATE \
 	_IOW(SGX_MAGIC, 0x00, struct sgx_enclave_create)
-#define SGX_IOC_ENCLAVE_ADD_PAGE \
-	_IOW(SGX_MAGIC, 0x01, struct sgx_enclave_add_page)
+#define SGX_IOC_ENCLAVE_ADD_PAGES \
+	_IOWR(SGX_MAGIC, 0x01, struct sgx_enclave_add_pages)
 #define SGX_IOC_ENCLAVE_INIT \
 	_IOW(SGX_MAGIC, 0x02, struct sgx_enclave_init)
 #define SGX_IOC_ENCLAVE_SET_ATTRIBUTE \
@@ -29,17 +29,19 @@ struct sgx_enclave_create  {
 };
 
 /**
- * struct sgx_enclave_add_page - parameter structure for the
- *                               %SGX_IOC_ENCLAVE_ADD_PAGE ioctl
- * @offset:	page offset within the enclave
- * @src:	address for the page data
+ * struct sgx_enclave_add_pages - parameter structure for the
+ *                                %SGX_IOC_ENCLAVE_ADD_PAGE ioctl
+ * @offset:	starting page offset within the ELRANGE
+ * @src:	start address for the page data
+ * @nr_pages:	number of pages to add to enclave
  * @secinfo:	address for the SECINFO data
  * @mrmask:	bitmask for the measured 256 byte chunks
  * @reserved:	reserved for future use
  */
-struct sgx_enclave_add_page {
+struct sgx_enclave_add_pages {
 	__u64	offset;
 	__u64	src;
+	__u64	nr_pages;
 	__u64	secinfo;
 	__u16	mrmask;
 	__u8	reserved[6];
diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index f407dd35f9e3..4597dd8f5c91 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -360,7 +360,7 @@ static int __sgx_encl_extend(struct sgx_encl *encl,
 }
 
 static int sgx_encl_add_page(struct sgx_encl *encl,
-			     struct sgx_enclave_add_page *addp,
+			     struct sgx_enclave_add_pages *addp,
 			     struct sgx_secinfo *secinfo)
 {
 	struct sgx_encl_page *encl_page;
@@ -443,14 +443,19 @@ static int sgx_encl_add_page(struct sgx_encl *encl,
 }
 
 /**
- * sgx_ioc_enclave_add_page() - The handler for %SGX_IOC_ENCLAVE_ADD_PAGE
- * @filep:	open file to /dev/sgx
- * @arg:	a user pointer to a struct sgx_enclave_add_page instance
+ * sgx_ioc_enclave_add_pages() - The handler for %SGX_IOC_ENCLAVE_ADD_PAGES
+ * @encl:       pointer to an enclave instance (via ioctl() file pointer)
+ * @arg:	a user pointer to a struct sgx_enclave_add_pages instance
  *
- * Add (EADD) a page to an uninitialized enclave, and optionally extend
- * (EEXTEND) the measurement with the contents of the page. A SECINFO for a TCS
- * is required to always contain zero permissions because CPU silently zeros
- * them. Allowing anything else would cause a mismatch in the measurement.
+ * Add (EADD) one or more pages to an uninitialized enclave, and optionally
+ * extend (EEXTEND) the measurement with the contents of the page. The range of
+ * pages must be virtually contiguous. The SECINFO and measurement mask are
+ * applied to all pages, i.e. pages with different properties must be added in
+ * separate calls.
+ *
+ * A SECINFO for a TCS is required to always contain zero permissions because
+ * CPU silently zeros them. Allowing anything else would cause a mismatch in
+ * the measurement.
  *
  * mmap()'s protection bits are capped by the page permissions. For each page
  * address, the maximum protection bits are computed with the following
@@ -467,17 +472,25 @@ static int sgx_encl_add_page(struct sgx_encl *encl,
  * permissions. In effect, this allows mmap() with PROT_NONE to be used to seek
  * an address range for the enclave that can be then populated into SECS.
  *
+ * @arg->addr, @arg->src and @arg->nr_pages are adjusted to reflect the
+ * remaining pages that need to be added to the enclave, e.g. userspace can
+ * re-invoke SGX_IOC_ENCLAVE_ADD_PAGES using the same struct in response to an
+ * ERESTARTSYS error.
+ *
  * Return:
  *   0 on success,
- *   -EINVAL if the SECINFO contains invalid data,
- *   -EACCES if the source page is located in a noexec partition,
+ *   -EINVAL if any input param or the SECINFO contains invalid data,
+ *   -EACCES if an executable source page is located in a noexec partition,
  *   -ENOMEM if any memory allocation, including EPC, fails,
+ *   -ERESTARTSYS if a pending signal is recognized,
  *   -errno otherwise
+
  */
-static long sgx_ioc_enclave_add_page(struct sgx_encl *encl, void __user *arg)
+static long sgx_ioc_enclave_add_pages(struct sgx_encl *encl, void __user *arg)
 {
-	struct sgx_enclave_add_page addp;
+	struct sgx_enclave_add_pages addp;
 	struct sgx_secinfo secinfo;
+	int ret;
 
 	if (!(atomic_read(&encl->flags) & SGX_ENCL_CREATED))
 		return -EINVAL;
@@ -489,7 +502,10 @@ static long sgx_ioc_enclave_add_page(struct sgx_encl *encl, void __user *arg)
 	    !IS_ALIGNED(addp.src, PAGE_SIZE))
 		return -EINVAL;
 
-	if (addp.offset >= encl->size)
+	if (!addp.nr_pages)
+		return -EINVAL;
+
+	if (addp.offset + ((addp.nr_pages - 1) * PAGE_SIZE) >= encl->size)
 		return -EINVAL;
 
 	if (copy_from_user(&secinfo, (void __user *)addp.secinfo,
@@ -499,7 +515,27 @@ static long sgx_ioc_enclave_add_page(struct sgx_encl *encl, void __user *arg)
 	if (sgx_validate_secinfo(&secinfo))
 		return -EINVAL;
 
-	return sgx_encl_add_page(encl, &addp, &secinfo);
+	for ( ; addp.nr_pages > 0; addp.nr_pages--) {
+		if (signal_pending(current)) {
+			ret = -ERESTARTSYS;
+			break;
+		}
+
+		if (need_resched())
+			cond_resched();
+
+		ret = sgx_encl_add_page(encl, &addp, &secinfo);
+		if (ret)
+			break;
+
+		addp.offset += PAGE_SIZE;
+		addp.src += PAGE_SIZE;
+	}
+
+	if (copy_to_user(arg, &addp, sizeof(addp)))
+		return -EFAULT;
+
+	return ret;
 }
 
 static int __sgx_get_key_hash(struct crypto_shash *tfm, const void *modulus,
@@ -702,8 +738,8 @@ long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 	case SGX_IOC_ENCLAVE_CREATE:
 		ret = sgx_ioc_enclave_create(encl, (void __user *)arg);
 		break;
-	case SGX_IOC_ENCLAVE_ADD_PAGE:
-		ret = sgx_ioc_enclave_add_page(encl, (void __user *)arg);
+	case SGX_IOC_ENCLAVE_ADD_PAGES:
+		ret = sgx_ioc_enclave_add_pages(encl, (void __user *)arg);
 		break;
 	case SGX_IOC_ENCLAVE_INIT:
 		ret = sgx_ioc_enclave_init(encl, (void __user *)arg);
-- 
2.22.0

