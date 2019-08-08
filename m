Return-Path: <SRS0=scwG=WE=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88361C32756
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Aug 2019 00:13:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6740221872
	for <linux-sgx@archiver.kernel.org>; Thu,  8 Aug 2019 00:13:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730462AbfHHANA (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 7 Aug 2019 20:13:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:51242 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730038AbfHHANA (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 7 Aug 2019 20:13:00 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Aug 2019 17:12:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,358,1559545200"; 
   d="scan'208";a="165519362"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by orsmga007.jf.intel.com with ESMTP; 07 Aug 2019 17:12:58 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Serge Ayoun <serge.ayoun@intel.com>
Subject: [PATCH for_v22 07/11] x86/sgx: Check that enclave is created at beginning of EADD/EINIT ioctl
Date:   Wed,  7 Aug 2019 17:12:50 -0700
Message-Id: <20190808001254.11926-8-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808001254.11926-1-sean.j.christopherson@intel.com>
References: <20190808001254.11926-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Move the EADD/EINIT checks on SGX_ENCL_CREATED to the very beginning of
the ioctl() flows.  Deferring the check until the core code is fragile
as all code leading up to that point must be careful that it only uses
members of @encl that are initialized at allocation time.  For example,
the flush_work() call in sgx_encl_init() will crash if the enclave has
not been created.

Note, there is no need to take encl->lock to check SGX_ENCL_CREATED so
long as SGX_ENCL_CREATED is set only after the enclave is fully
initialized, it's not the kernel's responsibility to guard against
sgx_encl_create() racing with EADD/EINIT.  Add a comment to highlight
the dependency.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/driver/ioctl.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
index 6a580361e20e..700d65c96b9a 100644
--- a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
@@ -326,6 +326,12 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
 	encl->base = secs->base;
 	encl->size = secs->size;
 	encl->ssaframesize = secs->ssa_frame_size;
+
+	/*
+	 * Set SGX_ENCL_CREATED only after the enclave is fully prepped.  This
+	 * allows other flows to check if the enclave has been created without
+	 * taking encl->lock.
+	 */
 	encl->flags |= SGX_ENCL_CREATED;
 
 	mutex_unlock(&encl->lock);
@@ -516,8 +522,7 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long addr,
 
 	mutex_lock(&encl->lock);
 
-	if (!(encl->flags & SGX_ENCL_CREATED) ||
-	    (encl->flags & (SGX_ENCL_INITIALIZED | SGX_ENCL_DEAD))) {
+	if (encl->flags & (SGX_ENCL_INITIALIZED | SGX_ENCL_DEAD)) {
 		ret = -EFAULT;
 		goto out;
 	}
@@ -597,6 +602,9 @@ static long sgx_ioc_enclave_add_page(struct file *filep, void __user *arg)
 	void *data;
 	int ret;
 
+	if (!(encl->flags & SGX_ENCL_CREATED))
+		return -EINVAL;
+
 	if (copy_from_user(&addp, arg, sizeof(addp)))
 		return -EFAULT;
 
@@ -685,8 +693,7 @@ static int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct *sigstruct,
 
 	mutex_lock(&encl->lock);
 
-	if (!(encl->flags & SGX_ENCL_CREATED) ||
-	    (encl->flags & (SGX_ENCL_INITIALIZED | SGX_ENCL_DEAD))) {
+	if (encl->flags & (SGX_ENCL_INITIALIZED | SGX_ENCL_DEAD)) {
 		ret = -EFAULT;
 		goto err_out;
 	}
@@ -753,6 +760,9 @@ static long sgx_ioc_enclave_init(struct file *filep, void __user *arg)
 	struct page *initp_page;
 	int ret;
 
+	if (!(encl->flags & SGX_ENCL_CREATED))
+		return -EINVAL;
+
 	if (copy_from_user(&einit, arg, sizeof(einit)))
 		return -EFAULT;
 
-- 
2.22.0

