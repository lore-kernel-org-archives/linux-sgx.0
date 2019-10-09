Return-Path: <SRS0=7vij=YC=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE389C47404
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Oct 2019 04:42:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0AAF21835
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Oct 2019 04:42:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729627AbfJIEmn (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 9 Oct 2019 00:42:43 -0400
Received: from mga11.intel.com ([192.55.52.93]:6367 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729472AbfJIEmn (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 9 Oct 2019 00:42:43 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Oct 2019 21:42:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,273,1566889200"; 
   d="scan'208";a="218504412"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga004.fm.intel.com with ESMTP; 08 Oct 2019 21:42:42 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v23 1/7] x86/sgx: Modify ADD_PAGE ioctl to take offset instead of full address
Date:   Tue,  8 Oct 2019 21:42:35 -0700
Message-Id: <20191009044241.3591-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191009044241.3591-1-sean.j.christopherson@intel.com>
References: <20191009044241.3591-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Change SGX_IOC_ENCLAVE_ADD_PAGE to take the target page as an offset
instead of a full address now that the API no longer uses the address to
find the target enclave.

Suggested-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/uapi/asm/sgx.h |  4 ++--
 arch/x86/kernel/cpu/sgx/ioctl.c | 10 +++++-----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
index 8f4660e07f6b..67583b046af1 100644
--- a/arch/x86/include/uapi/asm/sgx.h
+++ b/arch/x86/include/uapi/asm/sgx.h
@@ -31,14 +31,14 @@ struct sgx_enclave_create  {
 /**
  * struct sgx_enclave_add_page - parameter structure for the
  *                               %SGX_IOC_ENCLAVE_ADD_PAGE ioctl
- * @addr:	address within the ELRANGE
+ * @offset:	page offset within the enclave
  * @src:	address for the page data
  * @secinfo:	address for the SECINFO data
  * @mrmask:	bitmask for the measured 256 byte chunks
  * @reserved:	reserved for future use
  */
 struct sgx_enclave_add_page {
-	__u64	addr;
+	__u64	offset;
 	__u64	src;
 	__u64	secinfo;
 	__u16	mrmask;
diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 75f868bad3ea..f407dd35f9e3 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -113,7 +113,7 @@ static int sgx_validate_secs(const struct sgx_secs *secs,
 }
 
 static struct sgx_encl_page *sgx_encl_page_alloc(struct sgx_encl *encl,
-						 unsigned long addr,
+						 unsigned long offset,
 						 u64 secinfo_flags)
 {
 	struct sgx_encl_page *encl_page;
@@ -123,7 +123,7 @@ static struct sgx_encl_page *sgx_encl_page_alloc(struct sgx_encl *encl,
 	if (!encl_page)
 		return ERR_PTR(-ENOMEM);
 
-	encl_page->desc = addr;
+	encl_page->desc = encl->base + offset;
 	encl_page->encl = encl;
 
 	prot = _calc_vm_trans(secinfo_flags, SGX_SECINFO_R, PROT_READ)  |
@@ -368,7 +368,7 @@ static int sgx_encl_add_page(struct sgx_encl *encl,
 	struct sgx_va_page *va_page;
 	int ret;
 
-	encl_page = sgx_encl_page_alloc(encl, addp->addr, secinfo->flags);
+	encl_page = sgx_encl_page_alloc(encl, addp->offset, secinfo->flags);
 	if (IS_ERR(encl_page))
 		return PTR_ERR(encl_page);
 
@@ -485,11 +485,11 @@ static long sgx_ioc_enclave_add_page(struct sgx_encl *encl, void __user *arg)
 	if (copy_from_user(&addp, arg, sizeof(addp)))
 		return -EFAULT;
 
-	if (!IS_ALIGNED(addp.addr, PAGE_SIZE) ||
+	if (!IS_ALIGNED(addp.offset, PAGE_SIZE) ||
 	    !IS_ALIGNED(addp.src, PAGE_SIZE))
 		return -EINVAL;
 
-	if (addp.addr < encl->base || addp.addr - encl->base >= encl->size)
+	if (addp.offset >= encl->size)
 		return -EINVAL;
 
 	if (copy_from_user(&secinfo, (void __user *)addp.secinfo,
-- 
2.22.0

