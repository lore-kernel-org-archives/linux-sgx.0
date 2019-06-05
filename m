Return-Path: <SRS0=6XgF=UE=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 305B1C28D1A
	for <linux-sgx@archiver.kernel.org>; Wed,  5 Jun 2019 19:49:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1683920883
	for <linux-sgx@archiver.kernel.org>; Wed,  5 Jun 2019 19:49:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbfFETt3 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 5 Jun 2019 15:49:29 -0400
Received: from mga01.intel.com ([192.55.52.88]:2918 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726512AbfFETt3 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 5 Jun 2019 15:49:29 -0400
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
Subject: [PATCH 6/7] x86/sgx: Use the actual zero page as the source when adding zero pages
Date:   Wed,  5 Jun 2019 12:48:44 -0700
Message-Id: <20190605194845.926-7-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190605194845.926-1-sean.j.christopherson@intel.com>
References: <20190605194845.926-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Using the zero page avoids dirtying the backing page, inserting TLB
entries, the cost of memset, etc...  For some enclaves, e.g. an enclave
with a small code footprint and a large working set, this results in a
20%+ reduction in enclave build time.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/driver/ioctl.c | 50 ++++++++++++++++----------
 1 file changed, 32 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
index c35264ea0c93..e05a539e96fc 100644
--- a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
@@ -19,6 +19,7 @@ struct sgx_add_page_req {
 	struct sgx_secinfo secinfo;
 	unsigned long mrmask;
 	struct list_head list;
+	bool zero_page;
 };
 
 static int sgx_encl_grow(struct sgx_encl *encl)
@@ -76,6 +77,7 @@ static bool sgx_process_add_page_req(struct sgx_add_page_req *req,
 	struct sgx_pageinfo pginfo;
 	struct page *backing;
 	unsigned long addr;
+	void *contents;
 	int ret;
 	int i;
 
@@ -84,9 +86,15 @@ static bool sgx_process_add_page_req(struct sgx_add_page_req *req,
 
 	addr = SGX_ENCL_PAGE_ADDR(encl_page);
 
-	backing = sgx_encl_get_backing_page(encl, page_index);
-	if (IS_ERR(backing))
-		return false;
+	if (!req->zero_page) {
+		backing = sgx_encl_get_backing_page(encl, page_index);
+		if (IS_ERR(backing))
+			return false;
+		contents = kmap_atomic(backing);
+	} else {
+		backing = NULL;
+		contents = __va(page_to_pfn(ZERO_PAGE(0)) << PAGE_SHIFT);
+	}
 
 	/*
 	 * The SECINFO field must be 64-byte aligned, copy it to a local
@@ -99,11 +107,13 @@ static bool sgx_process_add_page_req(struct sgx_add_page_req *req,
 	pginfo.secs = (unsigned long)sgx_epc_addr(encl->secs.epc_page);
 	pginfo.addr = addr;
 	pginfo.metadata = (unsigned long)&secinfo;
-	pginfo.contents = (unsigned long)kmap_atomic(backing);
+	pginfo.contents = (unsigned long)contents;
 	ret = __eadd(&pginfo, sgx_epc_addr(epc_page));
-	kunmap_atomic((void *)(unsigned long)pginfo.contents);
 
-	put_page(backing);
+	if (backing) {
+		kunmap_atomic(contents);
+		put_page(backing);
+	}
 
 	if (ret) {
 		if (encls_failed(ret))
@@ -506,18 +516,20 @@ static int sgx_encl_queue_page(struct sgx_encl *encl,
 	if (!req)
 		return -ENOMEM;
 
-	backing = sgx_encl_get_backing_page(encl, page_index);
-	if (IS_ERR(backing)) {
-		kfree(req);
-		return PTR_ERR(backing);
-	}
+	if (data) {
+		backing = sgx_encl_get_backing_page(encl, page_index);
+		if (IS_ERR(backing)) {
+			kfree(req);
+			return PTR_ERR(backing);
+		}
 
-	backing_ptr = kmap(backing);
-	if (data)
+		backing_ptr = kmap(backing);
 		memcpy(backing_ptr, data, PAGE_SIZE);
-	else
-		memset(backing_ptr, 0, PAGE_SIZE);
-	kunmap(backing);
+		kunmap(backing);
+	} else {
+		backing = NULL;
+		req->zero_page = true;
+	}
 	if (page_type == SGX_SECINFO_TCS)
 		encl_page->desc |= SGX_ENCL_PAGE_TCS;
 	memcpy(&req->secinfo, secinfo, sizeof(*secinfo));
@@ -529,8 +541,10 @@ static int sgx_encl_queue_page(struct sgx_encl *encl,
 	list_add_tail(&req->list, &encl->add_page_reqs);
 	if (empty)
 		queue_work(sgx_encl_wq, &encl->work);
-	set_page_dirty(backing);
-	put_page(backing);
+	if (backing) {
+		set_page_dirty(backing);
+		put_page(backing);
+	}
 	return 0;
 }
 
-- 
2.21.0

