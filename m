Return-Path: <SRS0=R+G5=WJ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57FA2C32750
	for <linux-sgx@archiver.kernel.org>; Tue, 13 Aug 2019 01:12:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A3FF2070C
	for <linux-sgx@archiver.kernel.org>; Tue, 13 Aug 2019 01:12:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbfHMBMy (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 12 Aug 2019 21:12:54 -0400
Received: from mga03.intel.com ([134.134.136.65]:29948 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726479AbfHMBMy (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 12 Aug 2019 21:12:54 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Aug 2019 18:12:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,379,1559545200"; 
   d="scan'208";a="176062474"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga008.fm.intel.com with ESMTP; 12 Aug 2019 18:12:53 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org, Andy Lutomirski <luto@kernel.org>
Subject: [PATCH for_v22 v2 2/8] x86/sgx: Require EADD source to be page aligned
Date:   Mon, 12 Aug 2019 18:12:46 -0700
Message-Id: <20190813011252.4121-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190813011252.4121-1-sean.j.christopherson@intel.com>
References: <20190813011252.4121-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Reject the EADD ioctl() if the source address provided by userspace is
not page aligned.  Page alignment is required by hardware, but this is
not enforced on userspace as the kernel first copies the source page to
an internal (page aligned) buffer.  Require the userspace address to be
page aligned in preparation for reworking EADD to directly consume the
userspace address.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/driver/ioctl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
index 9b784a061a47..bc65249ed5df 100644
--- a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
@@ -624,7 +624,8 @@ static long sgx_ioc_enclave_add_page(struct file *filep, void __user *arg)
 	if (copy_from_user(&addp, arg, sizeof(addp)))
 		return -EFAULT;
 
-	if (!IS_ALIGNED(addp.addr, PAGE_SIZE))
+	if (!IS_ALIGNED(addp.addr, PAGE_SIZE) ||
+	    !IS_ALIGNED(addp.src, PAGE_SIZE))
 		return -EINVAL;
 
 	if (addp.addr < encl->base || addp.addr - encl->base >= encl->size)
-- 
2.22.0

