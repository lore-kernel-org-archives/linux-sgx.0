Return-Path: <SRS0=R+G5=WJ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0640C32759
	for <linux-sgx@archiver.kernel.org>; Tue, 13 Aug 2019 01:12:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADF6C206A2
	for <linux-sgx@archiver.kernel.org>; Tue, 13 Aug 2019 01:12:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbfHMBMz (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 12 Aug 2019 21:12:55 -0400
Received: from mga03.intel.com ([134.134.136.65]:29948 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726479AbfHMBMz (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 12 Aug 2019 21:12:55 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Aug 2019 18:12:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,379,1559545200"; 
   d="scan'208";a="176062481"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga008.fm.intel.com with ESMTP; 12 Aug 2019 18:12:53 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, Andy Lutomirski <luto@kernel.org>
Subject: [PATCH for_v22 v2 4/8] x86/sgx: Set SGX_ENCL_PAGE_TCS when allocating encl_page
Date:   Mon, 12 Aug 2019 18:12:48 -0700
Message-Id: <20190813011252.4121-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190813011252.4121-1-sean.j.christopherson@intel.com>
References: <20190813011252.4121-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Set SGX_ENCL_PAGE_TCS when encl_page->desc is initialized in
sgx_encl_page_alloc() to improve readability, and so that the code
isn't affected when the bulk of __sgx_encl_add_page() is rewritten
to remove the EADD worker in a future patch.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/driver/ioctl.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
index 5831f51d64cd..2b3b86412131 100644
--- a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
@@ -247,7 +247,8 @@ static int sgx_validate_secs(const struct sgx_secs *secs,
 
 static struct sgx_encl_page *sgx_encl_page_alloc(struct sgx_encl *encl,
 						 unsigned long addr,
-						 unsigned long prot)
+						 unsigned long prot,
+						 u64 page_type)
 {
 	struct sgx_encl_page *encl_page;
 	int ret;
@@ -258,6 +259,8 @@ static struct sgx_encl_page *sgx_encl_page_alloc(struct sgx_encl *encl,
 	if (!encl_page)
 		return ERR_PTR(-ENOMEM);
 	encl_page->desc = addr;
+	if (page_type == SGX_SECINFO_TCS)
+		encl_page->desc |= SGX_ENCL_PAGE_TCS;
 	encl_page->encl = encl;
 	encl_page->vm_prot_bits = calc_vm_prot_bits(prot, 0);
 	ret = radix_tree_insert(&encl->page_tree, PFN_DOWN(encl_page->desc),
@@ -476,7 +479,6 @@ static int __sgx_encl_add_page(struct sgx_encl *encl,
 			       unsigned int mrmask)
 {
 	unsigned long page_index = sgx_encl_get_index(encl_page);
-	u64 page_type = secinfo->flags & SGX_SECINFO_PAGE_TYPE_MASK;
 	struct sgx_add_page_req *req = NULL;
 	struct page *backing;
 	void *backing_ptr;
@@ -495,8 +497,7 @@ static int __sgx_encl_add_page(struct sgx_encl *encl,
 	backing_ptr = kmap(backing);
 	memcpy(backing_ptr, data, PAGE_SIZE);
 	kunmap(backing);
-	if (page_type == SGX_SECINFO_TCS)
-		encl_page->desc |= SGX_ENCL_PAGE_TCS;
+
 	memcpy(&req->secinfo, secinfo, sizeof(*secinfo));
 	req->encl = encl;
 	req->encl_page = encl_page;
@@ -533,7 +534,7 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long addr,
 		goto err_out_unlock;
 	}
 
-	encl_page = sgx_encl_page_alloc(encl, addr, prot);
+	encl_page = sgx_encl_page_alloc(encl, addr, prot, page_type);
 	if (IS_ERR(encl_page)) {
 		ret = PTR_ERR(encl_page);
 		goto err_out_shrink;
-- 
2.22.0

