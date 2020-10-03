Return-Path: <SRS0=MzOG=DK=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D63FC47427
	for <linux-sgx@archiver.kernel.org>; Sat,  3 Oct 2020 04:52:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29CB62311D
	for <linux-sgx@archiver.kernel.org>; Sat,  3 Oct 2020 04:52:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725934AbgJCEvw (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 3 Oct 2020 00:51:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:51118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725911AbgJCEvg (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 3 Oct 2020 00:51:36 -0400
Received: from localhost (83-245-197-237.elisa-laajakaista.fi [83.245.197.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D452122204;
        Sat,  3 Oct 2020 04:51:33 +0000 (UTC)
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     x86@kernel.org, linux-sgx@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, bp@alien8.de, cedric.xing@intel.com,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, dave.hansen@intel.com, haitao.huang@intel.com,
        kai.huang@intel.com, kai.svahn@intel.com, kmoy@google.com,
        ludloff@google.com, luto@kernel.org, nhorman@redhat.com,
        puiterwijk@redhat.com, rientjes@google.com, tglx@linutronix.de,
        yaozhangx@google.com, mikko.ylinen@intel.com
Subject: [PATCH v39 13/24] x86/sgx: Add SGX_IOC_ENCLAVE_ADD_PAGES
Date:   Sat,  3 Oct 2020 07:50:48 +0300
Message-Id: <20201003045059.665934-14-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201003045059.665934-1-jarkko.sakkinen@linux.intel.com>
References: <20201003045059.665934-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Add an ioctl, which performs ENCLS[EADD] that adds new visible page to an
enclave, and optionally ENCLS[EEXTEND] operations that hash the page to the
enclave measurement. By visible we mean a page that can be mapped to the
address range of an enclave.

Acked-by: Jethro Beekman <jethro@fortanix.com>
Tested-by: Jethro Beekman <jethro@fortanix.com>
Tested-by: Haitao Huang <haitao.huang@linux.intel.com>
Tested-by: Chunyang Hui <sanqian.hcy@antfin.com>
Tested-by: Jordan Hand <jorhand@linux.microsoft.com>
Tested-by: Nathaniel McCallum <npmccallum@redhat.com>
Tested-by: Seth Moore <sethmo@google.com>
Tested-by: Darren Kenny <darren.kenny@oracle.com>
Reviewed-by: Darren Kenny <darren.kenny@oracle.com>
Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Co-developed-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/include/uapi/asm/sgx.h |  30 ++++
 arch/x86/kernel/cpu/sgx/ioctl.c | 299 ++++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/sgx/sgx.h   |   1 +
 3 files changed, 330 insertions(+)

diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
index c75b375f3770..10cd48d06318 100644
--- a/arch/x86/include/uapi/asm/sgx.h
+++ b/arch/x86/include/uapi/asm/sgx.h
@@ -8,10 +8,21 @@
 #include <linux/types.h>
 #include <linux/ioctl.h>
 
+/**
+ * enum sgx_epage_flags - page control flags
+ * %SGX_PAGE_MEASURE:	Measure the page contents with a sequence of
+ *			ENCLS[EEXTEND] operations.
+ */
+enum sgx_page_flags {
+	SGX_PAGE_MEASURE	= 0x01,
+};
+
 #define SGX_MAGIC 0xA4
 
 #define SGX_IOC_ENCLAVE_CREATE \
 	_IOW(SGX_MAGIC, 0x00, struct sgx_enclave_create)
+#define SGX_IOC_ENCLAVE_ADD_PAGES \
+	_IOWR(SGX_MAGIC, 0x01, struct sgx_enclave_add_pages)
 
 /**
  * struct sgx_enclave_create - parameter structure for the
@@ -22,4 +33,23 @@ struct sgx_enclave_create  {
 	__u64	src;
 };
 
+/**
+ * struct sgx_enclave_add_pages - parameter structure for the
+ *                                %SGX_IOC_ENCLAVE_ADD_PAGE ioctl
+ * @src:	start address for the page data
+ * @offset:	starting page offset
+ * @length:	length of the data (multiple of the page size)
+ * @secinfo:	address for the SECINFO data
+ * @flags:	page control flags
+ * @count:	number of bytes added (multiple of the page size)
+ */
+struct sgx_enclave_add_pages {
+	__u64 src;
+	__u64 offset;
+	__u64 length;
+	__u64 secinfo;
+	__u64 flags;
+	__u64 count;
+};
+
 #endif /* _UAPI_ASM_X86_SGX_H */
diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 9bb4694e57c1..e13e04737683 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -194,6 +194,302 @@ static long sgx_ioc_enclave_create(struct sgx_encl *encl, void __user *arg)
 	return ret;
 }
 
+static struct sgx_encl_page *sgx_encl_page_alloc(struct sgx_encl *encl,
+						 unsigned long offset,
+						 u64 secinfo_flags)
+{
+	struct sgx_encl_page *encl_page;
+	unsigned long prot;
+
+	encl_page = kzalloc(sizeof(*encl_page), GFP_KERNEL);
+	if (!encl_page)
+		return ERR_PTR(-ENOMEM);
+
+	encl_page->desc = encl->base + offset;
+	encl_page->encl = encl;
+
+	prot = _calc_vm_trans(secinfo_flags, SGX_SECINFO_R, PROT_READ)  |
+	       _calc_vm_trans(secinfo_flags, SGX_SECINFO_W, PROT_WRITE) |
+	       _calc_vm_trans(secinfo_flags, SGX_SECINFO_X, PROT_EXEC);
+
+	/*
+	 * TCS pages must always RW set for CPU access while the SECINFO
+	 * permissions are *always* zero - the CPU ignores the user provided
+	 * values and silently overwrites them with zero permissions.
+	 */
+	if ((secinfo_flags & SGX_SECINFO_PAGE_TYPE_MASK) == SGX_SECINFO_TCS)
+		prot |= PROT_READ | PROT_WRITE;
+
+	/* Calculate maximum of the VM flags for the page. */
+	encl_page->vm_max_prot_bits = calc_vm_prot_bits(prot, 0);
+
+	return encl_page;
+}
+
+static int sgx_validate_secinfo(struct sgx_secinfo *secinfo)
+{
+	u64 perm = secinfo->flags & SGX_SECINFO_PERMISSION_MASK;
+	u64 pt = secinfo->flags & SGX_SECINFO_PAGE_TYPE_MASK;
+
+	if (pt != SGX_SECINFO_REG && pt != SGX_SECINFO_TCS)
+		return -EINVAL;
+
+	if ((perm & SGX_SECINFO_W) && !(perm & SGX_SECINFO_R))
+		return -EINVAL;
+
+	/*
+	 * CPU will silently overwrite the permissions as zero, which means
+	 * that we need to validate it ourselves.
+	 */
+	if (pt == SGX_SECINFO_TCS && perm)
+		return -EINVAL;
+
+	if (secinfo->flags & SGX_SECINFO_RESERVED_MASK)
+		return -EINVAL;
+
+	if (memchr_inv(secinfo->reserved, 0, sizeof(secinfo->reserved)))
+		return -EINVAL;
+
+	return 0;
+}
+
+static int __sgx_encl_add_page(struct sgx_encl *encl,
+			       struct sgx_encl_page *encl_page,
+			       struct sgx_epc_page *epc_page,
+			       struct sgx_secinfo *secinfo, unsigned long src)
+{
+	struct sgx_pageinfo pginfo;
+	struct vm_area_struct *vma;
+	struct page *src_page;
+	int ret;
+
+	/* Deny noexec. */
+	vma = find_vma(current->mm, src);
+	if (!vma)
+		return -EFAULT;
+
+	if (!(vma->vm_flags & VM_MAYEXEC))
+		return -EACCES;
+
+	ret = get_user_pages(src, 1, 0, &src_page, NULL);
+	if (ret < 1)
+		return -EFAULT;
+
+	pginfo.secs = (unsigned long)sgx_get_epc_addr(encl->secs.epc_page);
+	pginfo.addr = SGX_ENCL_PAGE_ADDR(encl_page);
+	pginfo.metadata = (unsigned long)secinfo;
+	pginfo.contents = (unsigned long)kmap_atomic(src_page);
+
+	ret = __eadd(&pginfo, sgx_get_epc_addr(epc_page));
+
+	kunmap_atomic((void *)pginfo.contents);
+	put_page(src_page);
+
+	return ret ? -EIO : 0;
+}
+
+/*
+ * If the caller requires measurement of the page as a proof for the content,
+ * use EEXTEND to add a measurement for 256 bytes of the page. Repeat this
+ * operation until the entire page is measured."
+ */
+static int __sgx_encl_extend(struct sgx_encl *encl,
+			     struct sgx_epc_page *epc_page)
+{
+	int ret;
+	int i;
+
+	for (i = 0; i < 16; i++) {
+		ret = __eextend(sgx_get_epc_addr(encl->secs.epc_page),
+				sgx_get_epc_addr(epc_page) + (i * 0x100));
+		if (ret) {
+			if (encls_failed(ret))
+				ENCLS_WARN(ret, "EEXTEND");
+			return -EIO;
+		}
+	}
+
+	return 0;
+}
+
+static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long src,
+			     unsigned long offset, struct sgx_secinfo *secinfo,
+			     unsigned long flags)
+{
+	struct sgx_encl_page *encl_page;
+	struct sgx_epc_page *epc_page;
+	int ret;
+
+	encl_page = sgx_encl_page_alloc(encl, offset, secinfo->flags);
+	if (IS_ERR(encl_page))
+		return PTR_ERR(encl_page);
+
+	epc_page = __sgx_alloc_epc_page();
+	if (IS_ERR(epc_page)) {
+		kfree(encl_page);
+		return PTR_ERR(epc_page);
+	}
+
+	mmap_read_lock(current->mm);
+	mutex_lock(&encl->lock);
+
+	/*
+	 * Insert prior to EADD in case of OOM.  EADD modifies MRENCLAVE, i.e.
+	 * can't be gracefully unwound, while failure on EADD/EXTEND is limited
+	 * to userspace errors (or kernel/hardware bugs).
+	 */
+	ret = xa_insert(&encl->page_array, PFN_DOWN(encl_page->desc),
+			encl_page, GFP_KERNEL);
+	if (ret)
+		goto err_out_unlock;
+
+	ret = __sgx_encl_add_page(encl, encl_page, epc_page, secinfo,
+				  src);
+	if (ret)
+		goto err_out;
+
+	/*
+	 * Complete the "add" before doing the "extend" so that the "add"
+	 * isn't in a half-baked state in the extremely unlikely scenario
+	 * the enclave will be destroyed in response to EEXTEND failure.
+	 */
+	encl_page->encl = encl;
+	encl_page->epc_page = epc_page;
+	encl->secs_child_cnt++;
+
+	if (flags & SGX_PAGE_MEASURE) {
+		ret = __sgx_encl_extend(encl, epc_page);
+		if (ret)
+			goto err_out;
+	}
+
+	mutex_unlock(&encl->lock);
+	mmap_read_unlock(current->mm);
+	return ret;
+
+err_out:
+	xa_erase(&encl->page_array, PFN_DOWN(encl_page->desc));
+
+err_out_unlock:
+	mutex_unlock(&encl->lock);
+	mmap_read_unlock(current->mm);
+
+	sgx_free_epc_page(epc_page);
+	kfree(encl_page);
+
+	return ret;
+}
+
+/**
+ * sgx_ioc_enclave_add_pages() - The handler for %SGX_IOC_ENCLAVE_ADD_PAGES
+ * @encl:       an enclave pointer
+ * @arg:	a user pointer to a struct sgx_enclave_add_pages instance
+ *
+ * Add one or more pages to an uninitialized enclave, and optionally extend the
+ * measurement with the contents of the page. The SECINFO and measurement mask
+ * are applied to all pages.
+ *
+ * A SECINFO for a TCS is required to always contain zero permissions because
+ * CPU silently zeros them. Allowing anything else would cause a mismatch in
+ * the measurement.
+ *
+ * mmap()'s protection bits are capped by the page permissions. For each page
+ * address, the maximum protection bits are computed with the following
+ * heuristics:
+ *
+ * 1. A regular page: PROT_R, PROT_W and PROT_X match the SECINFO permissions.
+ * 2. A TCS page: PROT_R | PROT_W.
+ *
+ * mmap() is not allowed to surpass the minimum of the maximum protection bits
+ * within the given address range.
+ *
+ * The function deinitializes kernel data structures for enclave and returns
+ * -EIO in any of the following conditions:
+ *
+ * - Enclave Page Cache (EPC), the physical memory holding enclaves, has
+ *   been invalidated. This will cause EADD and EEXTEND to fail.
+ * - If the source address is corrupted somehow when executing EADD.
+ *
+ * Return:
+ *   length of the data processed on success,
+ *   -EACCES if an executable source page is located in a noexec partition,
+ *   -ENOMEM if the system is out of EPC pages,
+ *   -EINTR if the call was interrupted before any data was processed,
+ *   -EIO if the enclave was lost
+ *   -errno otherwise
+ */
+static long sgx_ioc_enclave_add_pages(struct sgx_encl *encl, void __user *arg)
+{
+	struct sgx_enclave_add_pages addp;
+	struct sgx_secinfo secinfo;
+	unsigned long c;
+	int ret;
+
+	if ((atomic_read(&encl->flags) & SGX_ENCL_INITIALIZED) ||
+	    !(atomic_read(&encl->flags) & SGX_ENCL_CREATED))
+		return -EINVAL;
+
+	if (copy_from_user(&addp, arg, sizeof(addp)))
+		return -EFAULT;
+
+	if (!IS_ALIGNED(addp.offset, PAGE_SIZE) ||
+	    !IS_ALIGNED(addp.src, PAGE_SIZE))
+		return -EINVAL;
+
+	if (!(access_ok(addp.src, PAGE_SIZE)))
+		return -EFAULT;
+
+	if (addp.length & (PAGE_SIZE - 1))
+		return -EINVAL;
+
+	if (addp.offset + addp.length - PAGE_SIZE >= encl->size)
+		return -EINVAL;
+
+	if (copy_from_user(&secinfo, (void __user *)addp.secinfo,
+			   sizeof(secinfo)))
+		return -EFAULT;
+
+	if (sgx_validate_secinfo(&secinfo))
+		return -EINVAL;
+
+	for (c = 0 ; c < addp.length; c += PAGE_SIZE) {
+		if (signal_pending(current)) {
+			if (!c)
+				ret = -ERESTARTSYS;
+
+			break;
+		}
+
+		if (c == SGX_MAX_ADD_PAGES_LENGTH)
+			break;
+
+		if (need_resched())
+			cond_resched();
+
+		ret = sgx_encl_add_page(encl, addp.src + c, addp.offset + c,
+					&secinfo, addp.flags);
+		if (ret)
+			break;
+	}
+
+	addp.count = c;
+
+	if (copy_to_user(arg, &addp, sizeof(addp)))
+		return -EFAULT;
+
+	/*
+	 * If the enlave was lost, deinitialize the internal data structures
+	 * for the enclave.
+	 */
+	if (ret == -EIO) {
+		mutex_lock(&encl->lock);
+		sgx_encl_destroy(encl);
+		mutex_unlock(&encl->lock);
+	}
+
+	return ret;
+}
+
 long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 {
 	struct sgx_encl *encl = filep->private_data;
@@ -212,6 +508,9 @@ long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 	case SGX_IOC_ENCLAVE_CREATE:
 		ret = sgx_ioc_enclave_create(encl, (void __user *)arg);
 		break;
+	case SGX_IOC_ENCLAVE_ADD_PAGES:
+		ret = sgx_ioc_enclave_add_pages(encl, (void __user *)arg);
+		break;
 	default:
 		ret = -ENOIOCTLCMD;
 		break;
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index fce756c3434b..8d126070db1e 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -34,6 +34,7 @@ struct sgx_epc_section {
 
 #define SGX_EPC_SECTION_MASK		GENMASK(7, 0)
 #define SGX_MAX_EPC_SECTIONS		(SGX_EPC_SECTION_MASK + 1)
+#define SGX_MAX_ADD_PAGES_LENGTH	0x100000
 
 extern struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SECTIONS];
 
-- 
2.25.1

