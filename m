Return-Path: <SRS0=6XgF=UE=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD525C28D1B
	for <linux-sgx@archiver.kernel.org>; Wed,  5 Jun 2019 19:49:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89C392083E
	for <linux-sgx@archiver.kernel.org>; Wed,  5 Jun 2019 19:49:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbfFETta (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 5 Jun 2019 15:49:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:2918 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726537AbfFETta (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 5 Jun 2019 15:49:30 -0400
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
Subject: [PATCH 7/7] x86/sgx: Add a reserved field to sgx_enclave_add_region to drop 'packed'
Date:   Wed,  5 Jun 2019 12:48:45 -0700
Message-Id: <20190605194845.926-8-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190605194845.926-1-sean.j.christopherson@intel.com>
References: <20190605194845.926-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

A reserved field could prove useful in the future, and packed structs
can result in inefficiencies due to its impact on alignment.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/uapi/asm/sgx.h        | 4 +++-
 arch/x86/kernel/cpu/sgx/driver/ioctl.c | 3 +++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
index 18204722f238..e2d9b3d512ef 100644
--- a/arch/x86/include/uapi/asm/sgx.h
+++ b/arch/x86/include/uapi/asm/sgx.h
@@ -43,6 +43,7 @@ struct sgx_enclave_create  {
  * @secinfo:	address of the SECINFO data (common to the entire region)
  * @flags:	miscellaneous flags
  * @mrmask:	bitmask of 256 byte chunks to measure (applied per 4k page)
+ * @reserved:	reserved for future use, must be zero
  */
 struct sgx_enclave_add_region {
 	__u64	addr;
@@ -51,7 +52,8 @@ struct sgx_enclave_add_region {
 	__u64	secinfo;
 	__u32	flags;
 	__u16	mrmask;
-} __attribute__((__packed__));
+	__u16	reserved;
+};
 
 /**
  * struct sgx_enclave_init - parameter structure for the
diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
index e05a539e96fc..bae5f3155376 100644
--- a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
@@ -663,6 +663,9 @@ static long sgx_ioc_enclave_add_region(struct file *filep, void __user *arg)
 	if (!IS_ALIGNED(region.addr, 4096) || !IS_ALIGNED(region.size, 4096))
 		return -EINVAL;
 
+	if (region.reserved)
+		return -EINVAL;
+
 	if (!region.size)
 		return 0;
 
-- 
2.21.0

