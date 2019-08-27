Return-Path: <SRS0=8+LH=WX=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F8ACC41514
	for <linux-sgx@archiver.kernel.org>; Tue, 27 Aug 2019 19:27:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 351A721881
	for <linux-sgx@archiver.kernel.org>; Tue, 27 Aug 2019 19:27:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729626AbfH0T1W (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 27 Aug 2019 15:27:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:33017 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730237AbfH0T1V (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 27 Aug 2019 15:27:21 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 12:27:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,438,1559545200"; 
   d="scan'208";a="180318616"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga008.fm.intel.com with ESMTP; 27 Aug 2019 12:27:19 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH v2 4/5] x86/sgx: Reject all ioctls on dead enclaves
Date:   Tue, 27 Aug 2019 12:27:16 -0700
Message-Id: <20190827192717.27312-5-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190827192717.27312-1-sean.j.christopherson@intel.com>
References: <20190827192717.27312-1-sean.j.christopherson@intel.com>
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
index a0ffbbb0dad1..7f605fb7e0f4 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -532,7 +532,7 @@ static int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct *sigstruct,
 
 	mutex_lock(&encl->lock);
 
-	if (atomic_read(&encl->flags) & (SGX_ENCL_INITIALIZED | SGX_ENCL_DEAD)) {
+	if (atomic_read(&encl->flags) & SGX_ENCL_INITIALIZED) {
 		ret = -EFAULT;
 		goto err_out;
 	}
@@ -675,11 +675,15 @@ static long sgx_ioc_enclave_set_attribute(struct sgx_encl *encl,
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

