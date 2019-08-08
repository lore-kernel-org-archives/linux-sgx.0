Return-Path: <SRS0=scwG=WE=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E762C32754
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Aug 2019 22:13:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 425732173C
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Aug 2019 22:13:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404534AbfHHWNo (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 8 Aug 2019 18:13:44 -0400
Received: from mga03.intel.com ([134.134.136.65]:19058 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404325AbfHHWNn (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 8 Aug 2019 18:13:43 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Aug 2019 15:13:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,363,1559545200"; 
   d="scan'208";a="193247264"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga001.fm.intel.com with ESMTP; 08 Aug 2019 15:13:42 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, Andy Lutomirski <luto@kernel.org>
Subject: [PATCH for_v22 3/6] x86/sgx: Move encl_page insertion into tree out of alloc flow
Date:   Thu,  8 Aug 2019 15:13:37 -0700
Message-Id: <20190808221340.29460-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808221340.29460-1-sean.j.christopherson@intel.com>
References: <20190808221340.29460-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Move insertion into the page tree out of sgx_encl_page_alloc() so that
the function can be moved out from under encl->lock.  This is a
preparatory step for removing the add page worker, as the encl_page is
needed to allocate its EPC page, and EPC page allocation must be done
without holding encl->lock so that it can trigger reclaim if necessary.

Note, radix_tree_insert() returns -EEXIST if the the slot is already in
use, i.e. there's no need to pre-check via radix_tree_lookup().

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/driver/ioctl.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
index 64deab36ed05..126f95afa9a1 100644
--- a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
@@ -251,10 +251,7 @@ static struct sgx_encl_page *sgx_encl_page_alloc(struct sgx_encl *encl,
 						 u64 page_type)
 {
 	struct sgx_encl_page *encl_page;
-	int ret;
 
-	if (radix_tree_lookup(&encl->page_tree, PFN_DOWN(addr)))
-		return ERR_PTR(-EEXIST);
 	encl_page = kzalloc(sizeof(*encl_page), GFP_KERNEL);
 	if (!encl_page)
 		return ERR_PTR(-ENOMEM);
@@ -263,12 +260,7 @@ static struct sgx_encl_page *sgx_encl_page_alloc(struct sgx_encl *encl,
 		encl_page->desc |= SGX_ENCL_PAGE_TCS;
 	encl_page->encl = encl;
 	encl_page->vm_prot_bits = calc_vm_prot_bits(prot, 0);
-	ret = radix_tree_insert(&encl->page_tree, PFN_DOWN(encl_page->desc),
-				encl_page);
-	if (ret) {
-		kfree(encl_page);
-		return ERR_PTR(ret);
-	}
+
 	return encl_page;
 }
 
@@ -539,6 +531,11 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long addr,
 		goto err_out_shrink;
 	}
 
+	ret = radix_tree_insert(&encl->page_tree, PFN_DOWN(encl_page->desc),
+				encl_page);
+	if (ret)
+		goto err_out_free;
+
 	ret = __sgx_encl_add_page(encl, encl_page, data, secinfo, mrmask);
 	if (ret)
 		goto err_out;
@@ -549,6 +546,7 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long addr,
 err_out:
 	radix_tree_delete(&encl_page->encl->page_tree,
 			  PFN_DOWN(encl_page->desc));
+err_out_free:
 	kfree(encl_page);
 
 err_out_shrink:
-- 
2.22.0

