Return-Path: <SRS0=7vij=YC=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF515ECE596
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Oct 2019 04:42:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9798621835
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Oct 2019 04:42:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730339AbfJIEmo (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 9 Oct 2019 00:42:44 -0400
Received: from mga11.intel.com ([192.55.52.93]:6367 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729040AbfJIEmo (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 9 Oct 2019 00:42:44 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Oct 2019 21:42:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,273,1566889200"; 
   d="scan'208";a="218504427"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga004.fm.intel.com with ESMTP; 08 Oct 2019 21:42:43 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v23 5/7] x86/sgx: Add a flag to ADD_PAGES to allow replicating the source page
Date:   Tue,  8 Oct 2019 21:42:39 -0700
Message-Id: <20191009044241.3591-6-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191009044241.3591-1-sean.j.christopherson@intel.com>
References: <20191009044241.3591-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Add a flag to allow userspace to replicate a single source page to
multiple target pages in the enclave, e.g. to zero the .bss, initialize
the heap, etc...

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/uapi/asm/sgx.h | 7 ++++++-
 arch/x86/kernel/cpu/sgx/ioctl.c | 3 ++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
index 84734229d8dd..42634e99945e 100644
--- a/arch/x86/include/uapi/asm/sgx.h
+++ b/arch/x86/include/uapi/asm/sgx.h
@@ -28,6 +28,9 @@ struct sgx_enclave_create  {
 	__u64	src;
 };
 
+/* Replicate a single source data page to all target pages. */
+#define SGX_ADD_PAGES_REPLICATE_SRC	BIT(0)
+
 /**
  * struct sgx_enclave_add_pages - parameter structure for the
  *                                %SGX_IOC_ENCLAVE_ADD_PAGE ioctl
@@ -35,6 +38,7 @@ struct sgx_enclave_create  {
  * @src:	start address for the page data
  * @nr_pages:	number of pages to add to enclave
  * @secinfo:	address for the SECINFO data
+ * @flags:	misc control flags
  * @mrmask:	bitmask for the measured 256 byte chunks
  * @reserved:	reserved for future use
  */
@@ -43,8 +47,9 @@ struct sgx_enclave_add_pages {
 	__u64	src;
 	__u64	nr_pages;
 	__u64	secinfo;
+	__u32	flags;
 	__u16	mrmask;
-	__u8	reserved[6];
+	__u8	reserved[2];
 };
 
 /**
diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 4597dd8f5c91..9c6d582612cb 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -529,7 +529,8 @@ static long sgx_ioc_enclave_add_pages(struct sgx_encl *encl, void __user *arg)
 			break;
 
 		addp.offset += PAGE_SIZE;
-		addp.src += PAGE_SIZE;
+		if (!(addp.flags & SGX_ADD_PAGES_REPLICATE_SRC))
+			addp.src += PAGE_SIZE;
 	}
 
 	if (copy_to_user(arg, &addp, sizeof(addp)))
-- 
2.22.0

