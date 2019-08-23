Return-Path: <SRS0=JCck=WT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03166C3A5A4
	for <linux-sgx@archiver.kernel.org>; Fri, 23 Aug 2019 16:17:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA21922CE3
	for <linux-sgx@archiver.kernel.org>; Fri, 23 Aug 2019 16:17:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436675AbfHWQRK (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 23 Aug 2019 12:17:10 -0400
Received: from mga09.intel.com ([134.134.136.24]:47957 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436677AbfHWQRK (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 23 Aug 2019 12:17:10 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Aug 2019 09:17:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,421,1559545200"; 
   d="scan'208";a="263231729"
Received: from unknown (HELO localhost) ([10.252.39.229])
  by orsmga001.jf.intel.com with ESMTP; 23 Aug 2019 09:16:40 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH 4/4] x86/sgx: Move VM prot bits calculation to sgx_encl_page_alloc()
Date:   Fri, 23 Aug 2019 19:16:16 +0300
Message-Id: <20190823161616.27644-5-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190823161616.27644-1-jarkko.sakkinen@linux.intel.com>
References: <20190823161616.27644-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Move full VM prot bits calculation to sgx_encl_page_alloc() so that we
don't pass duplicate data in the add page flow (@prot and @secinfo hold
intersecting data).

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/kernel/cpu/sgx/ioctl.c | 44 ++++++++++++++++-----------------
 1 file changed, 21 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 5423d7c45d5e..ead9fb2d9b69 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -130,10 +130,10 @@ static int sgx_validate_secs(const struct sgx_secs *secs,
 
 static struct sgx_encl_page *sgx_encl_page_alloc(struct sgx_encl *encl,
 						 unsigned long addr,
-						 unsigned long prot,
-						 u64 page_type)
+						 u64 secinfo_flags)
 {
 	struct sgx_encl_page *encl_page;
+       unsigned long prot;
 
 	encl_page = kzalloc(sizeof(*encl_page), GFP_KERNEL);
 	if (!encl_page)
@@ -142,9 +142,22 @@ static struct sgx_encl_page *sgx_encl_page_alloc(struct sgx_encl *encl,
 	encl_page->desc = addr;
 	encl_page->encl = encl;
 
-	if (page_type == SGX_SECINFO_TCS)
+	if (secinfo_flags & SGX_SECINFO_TCS)
 		encl_page->desc |= SGX_ENCL_PAGE_TCS;
 
+
+       prot = _calc_vm_trans(secinfo_flags, SGX_SECINFO_R, PROT_READ)  |
+	      _calc_vm_trans(secinfo_flags, SGX_SECINFO_W, PROT_WRITE) |
+	      _calc_vm_trans(secinfo_flags, SGX_SECINFO_X, PROT_EXEC);
+
+       /*
+	* TCS pages must always RW set for CPU access while the SECINFO
+	* permissions are *always* zero - the CPU ignores the user provided
+	* values and silently overwrites them with zero permissions.
+	*/
+       if ((secinfo_flags & SGX_SECINFO_PAGE_TYPE_MASK) == SGX_SECINFO_TCS)
+	       prot |= PROT_READ | PROT_WRITE;
+
 	/* Calculate maximum of the VM flags for the page. */
 	encl_page->vm_max_prot_bits = calc_vm_prot_bits(prot, 0);
 
@@ -318,7 +331,7 @@ static int __sgx_encl_add_page(struct sgx_encl *encl,
 			       struct sgx_encl_page *encl_page,
 			       struct sgx_epc_page *epc_page,
 			       struct sgx_secinfo *secinfo, unsigned long src,
-			       unsigned long prot, unsigned long mrmask)
+			       unsigned long mrmask)
 {
 	struct sgx_pageinfo pginfo;
 	struct vm_area_struct *vma;
@@ -375,15 +388,14 @@ static int __sgx_encl_add_page(struct sgx_encl *encl,
 
 static int sgx_encl_add_page(struct sgx_encl *encl,
 			     struct sgx_enclave_add_page *addp,
-			     struct sgx_secinfo *secinfo, unsigned long prot)
+			     struct sgx_secinfo *secinfo)
 {
-	u64 page_type = secinfo->flags & SGX_SECINFO_PAGE_TYPE_MASK;
 	struct sgx_encl_page *encl_page;
 	struct sgx_epc_page *epc_page;
 	struct sgx_va_page *va_page;
 	int ret;
 
-	encl_page = sgx_encl_page_alloc(encl, addp->addr, prot, page_type);
+	encl_page = sgx_encl_page_alloc(encl, addp->addr, secinfo->flags);
 	if (IS_ERR(encl_page))
 		return PTR_ERR(encl_page);
 
@@ -407,7 +419,7 @@ static int sgx_encl_add_page(struct sgx_encl *encl,
 		goto err_out_shrink;
 
 	ret = __sgx_encl_add_page(encl, encl_page, epc_page, secinfo,
-				  addp->src, prot, addp->mrmask);
+				  addp->src, addp->mrmask);
 	if (ret)
 		goto err_out;
 
@@ -450,7 +462,6 @@ static long sgx_ioc_enclave_add_page(struct file *filep, void __user *arg)
 	struct sgx_encl *encl = filep->private_data;
 	struct sgx_enclave_add_page addp;
 	struct sgx_secinfo secinfo;
-	unsigned long prot;
 
 	if (!(encl->flags & SGX_ENCL_CREATED))
 		return -EINVAL;
@@ -472,20 +483,7 @@ static long sgx_ioc_enclave_add_page(struct file *filep, void __user *arg)
 	if (sgx_validate_secinfo(&secinfo))
 		return -EINVAL;
 
-	/* Set prot bits matching to the SECINFO permissions. */
-	prot = _calc_vm_trans(secinfo.flags, SGX_SECINFO_R, PROT_READ)  |
-	       _calc_vm_trans(secinfo.flags, SGX_SECINFO_W, PROT_WRITE) |
-	       _calc_vm_trans(secinfo.flags, SGX_SECINFO_X, PROT_EXEC);
-
-	/*
-	 * TCS pages must always RW set for CPU access while the SECINFO
-	 * permissions are *always* zero - the CPU ignores the user provided
-	 * values and silently overwrites with zero permissions.
-	 */
-	if ((secinfo.flags & SGX_SECINFO_PAGE_TYPE_MASK) == SGX_SECINFO_TCS)
-		prot |= PROT_READ | PROT_WRITE;
-
-	return sgx_encl_add_page(encl, &addp, &secinfo, prot);
+	return sgx_encl_add_page(encl, &addp, &secinfo);
 }
 
 static int __sgx_get_key_hash(struct crypto_shash *tfm, const void *modulus,
-- 
2.20.1

