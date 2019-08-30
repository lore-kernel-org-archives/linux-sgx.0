Return-Path: <SRS0=mvcT=W2=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DA20C3A5A3
	for <linux-sgx@archiver.kernel.org>; Fri, 30 Aug 2019 00:17:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6054A2189D
	for <linux-sgx@archiver.kernel.org>; Fri, 30 Aug 2019 00:17:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbfH3ARJ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 29 Aug 2019 20:17:09 -0400
Received: from mga04.intel.com ([192.55.52.120]:31183 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726014AbfH3ARI (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 29 Aug 2019 20:17:08 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 29 Aug 2019 17:17:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,445,1559545200"; 
   d="scan'208";a="205917827"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga004.fm.intel.com with ESMTP; 29 Aug 2019 17:17:07 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH v3 4/5] x86/sgx: Reject all ioctls on dead enclaves
Date:   Thu, 29 Aug 2019 17:17:05 -0700
Message-Id: <20190830001706.29309-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190830001706.29309-1-sean.j.christopherson@intel.com>
References: <20190830001706.29309-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Do not allow userspace to operate on a dead enclave.

Note, moving the SGX_ENCL_DEAD for EINIT outside of encl->lock is safe
now that sgx_ioctl() prevents concurrent calls.  SGX_ENCL_DEAD is only
set when the fd is released, i.e. EINIT can no longer be reached, or
within an ioctl call.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/ioctl.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index d34a13d98148..3800281c5945 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -540,7 +540,7 @@ static int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct *sigstruct,
 
 	mutex_lock(&encl->lock);
 
-	if (atomic_read(&encl->flags) & (SGX_ENCL_INITIALIZED | SGX_ENCL_DEAD)) {
+	if (atomic_read(&encl->flags) & SGX_ENCL_INITIALIZED) {
 		ret = -EFAULT;
 		goto err_out;
 	}
@@ -683,11 +683,15 @@ static long sgx_ioc_enclave_set_attribute(struct sgx_encl *encl,
 long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 {
 	struct sgx_encl *encl = filep->private_data;
-	int ret;
+	int ret, encl_flags;
 
-	if (atomic_fetch_or(SGX_ENCL_IOCTL, &encl->flags) & SGX_ENCL_IOCTL)
+	encl_flags = atomic_fetch_or(SGX_ENCL_IOCTL, &encl->flags);
+	if (encl_flags & SGX_ENCL_IOCTL)
 		return -EBUSY;
 
+	if (encl_flags & SGX_ENCL_DEAD)
+		return -EFAULT;
+
 	switch (cmd) {
 	case SGX_IOC_ENCLAVE_CREATE:
 		ret = sgx_ioc_enclave_create(encl, (void __user *)arg);
-- 
2.22.0

