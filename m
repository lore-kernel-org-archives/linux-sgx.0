Return-Path: <SRS0=8+LH=WX=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDC72C41514
	for <linux-sgx@archiver.kernel.org>; Tue, 27 Aug 2019 00:13:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B46BF2173E
	for <linux-sgx@archiver.kernel.org>; Tue, 27 Aug 2019 00:13:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727683AbfH0ANa (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 26 Aug 2019 20:13:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:1582 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727633AbfH0ANa (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 26 Aug 2019 20:13:30 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Aug 2019 17:11:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,435,1559545200"; 
   d="scan'208";a="171021241"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga007.jf.intel.com with ESMTP; 26 Aug 2019 17:11:28 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH 1/4] x86/sgx: Ensure enclave state is visible before marking it created
Date:   Mon, 26 Aug 2019 17:11:25 -0700
Message-Id: <20190827001128.25066-2-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190827001128.25066-1-sean.j.christopherson@intel.com>
References: <20190827001128.25066-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Add a memory barrier pair to ensure all enclave state is visible in
memory prior to SGX_ENCL_CREATED being set.  Without the barries, adding
pages and/or initializing the enclaves could theoretically consume stale
data.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/ioctl.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 911ff3b0f061..7134d68aecb3 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -163,6 +163,15 @@ static struct sgx_encl_page *sgx_encl_page_alloc(struct sgx_encl *encl,
 	return encl_page;
 }
 
+static bool is_encl_created(struct sgx_encl *encl)
+{
+	bool created = encl->flags & SGX_ENCL_CREATED;
+
+	/* Pairs with smp_wmb() in sgx_encl_create(). */
+	smp_rmb();
+	return created;
+}
+
 static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
 {
 	unsigned long encl_size = secs->size + PAGE_SIZE;
@@ -231,8 +240,9 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
 	/*
 	 * Set SGX_ENCL_CREATED only after the enclave is fully prepped.  This
 	 * allows other flows to check if the enclave has been created without
-	 * taking encl->lock.
+	 * taking encl->lock.  Pairs with smp_rmb() in is_encl_created().
 	 */
+	smp_wmb();
 	encl->flags |= SGX_ENCL_CREATED;
 
 	mutex_unlock(&encl->lock);
@@ -478,7 +488,7 @@ static long sgx_ioc_enclave_add_page(struct file *filep, void __user *arg)
 	struct sgx_enclave_add_page addp;
 	struct sgx_secinfo secinfo;
 
-	if (!(encl->flags & SGX_ENCL_CREATED))
+	if (!is_encl_created(encl))
 		return -EINVAL;
 
 	if (copy_from_user(&addp, arg, sizeof(addp)))
@@ -611,7 +621,7 @@ static long sgx_ioc_enclave_init(struct file *filep, void __user *arg)
 	struct page *initp_page;
 	int ret;
 
-	if (!(encl->flags & SGX_ENCL_CREATED))
+	if (!is_encl_created(encl))
 		return -EINVAL;
 
 	if (copy_from_user(&einit, arg, sizeof(einit)))
-- 
2.22.0

