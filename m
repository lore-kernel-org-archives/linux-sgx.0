Return-Path: <SRS0=6XgF=UE=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED4D2C46460
	for <linux-sgx@archiver.kernel.org>; Wed,  5 Jun 2019 19:49:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D37772089E
	for <linux-sgx@archiver.kernel.org>; Wed,  5 Jun 2019 19:49:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbfFETt3 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 5 Jun 2019 15:49:29 -0400
Received: from mga01.intel.com ([192.55.52.88]:2918 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726537AbfFETt3 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
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
Subject: [PATCH 5/7] x86/sgx: Add flag to zero added region instead of copying from source
Date:   Wed,  5 Jun 2019 12:48:43 -0700
Message-Id: <20190605194845.926-6-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190605194845.926-1-sean.j.christopherson@intel.com>
References: <20190605194845.926-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

For some enclaves, e.g. an enclave with a small code footprint and a
large working set, the vast majority of pages added to the enclave are
zero pages.  Introduce a flag to denote such zero pages.  The major
benefit of the flag will be realized in a future patch to use Linux's
actual zero page as the source, as opposed to explicitly zeroing the
enclave's backing memory.

Use bit 8 for the SGX_ZERO_REGION flag to avoid an anticipated conflict
with passing PROT_{READ,WRITE,EXEC} in bits 2:0, and to leave room in
case there is a need for additional protection related bits.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/include/uapi/asm/sgx.h        |  5 +++++
 arch/x86/kernel/cpu/sgx/driver/ioctl.c | 15 ++++++++++++---
 2 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
index 30d114f6b3bd..18204722f238 100644
--- a/arch/x86/include/uapi/asm/sgx.h
+++ b/arch/x86/include/uapi/asm/sgx.h
@@ -31,6 +31,9 @@ struct sgx_enclave_create  {
 	__u64	src;
 };
 
+/* Zero an added region instead of copying data from a source page. */
+#define SGX_ZERO_REGION	0x100
+
 /**
  * struct sgx_enclave_add_region - parameter structure for the
  *                                 %SGX_IOC_ENCLAVE_ADD_REGION ioctl
@@ -38,6 +41,7 @@ struct sgx_enclave_create  {
  * @src:	start address for the pages' data
  * @size:	size of region, in bytes
  * @secinfo:	address of the SECINFO data (common to the entire region)
+ * @flags:	miscellaneous flags
  * @mrmask:	bitmask of 256 byte chunks to measure (applied per 4k page)
  */
 struct sgx_enclave_add_region {
@@ -45,6 +49,7 @@ struct sgx_enclave_add_region {
 	__u64	src;
 	__u64	size;
 	__u64	secinfo;
+	__u32	flags;
 	__u16	mrmask;
 } __attribute__((__packed__));
 
diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
index b69350696b87..c35264ea0c93 100644
--- a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
@@ -459,6 +459,9 @@ static int sgx_validate_tcs(struct sgx_encl *encl, struct sgx_tcs *tcs)
 {
 	int i;
 
+	if (!tcs)
+		return -EINVAL;
+
 	if (tcs->flags & SGX_TCS_RESERVED_MASK)
 		return -EINVAL;
 
@@ -510,7 +513,10 @@ static int sgx_encl_queue_page(struct sgx_encl *encl,
 	}
 
 	backing_ptr = kmap(backing);
-	memcpy(backing_ptr, data, PAGE_SIZE);
+	if (data)
+		memcpy(backing_ptr, data, PAGE_SIZE);
+	else
+		memset(backing_ptr, 0, PAGE_SIZE);
 	kunmap(backing);
 	if (page_type == SGX_SECINFO_TCS)
 		encl_page->desc |= SGX_ENCL_PAGE_TCS;
@@ -576,12 +582,15 @@ static int __sgx_encl_add_page(struct sgx_encl *encl, unsigned long addr,
 
 static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long addr,
 			     unsigned long src, struct sgx_secinfo *secinfo,
-			     unsigned int mrmask)
+			     unsigned int mrmask, unsigned long flags)
 {
 	struct page *data_page;
 	void *data;
 	int ret;
 
+	if (flags & SGX_ZERO_REGION)
+		return __sgx_encl_add_page(encl, addr, NULL, secinfo, mrmask);
+
 	data_page = alloc_page(GFP_HIGHUSER);
 	if (!data_page)
 		return -ENOMEM;
@@ -658,7 +667,7 @@ static long sgx_ioc_enclave_add_region(struct file *filep, void __user *arg)
 			cond_resched();
 
 		ret = sgx_encl_add_page(encl, region.addr + i, region.src + i,
-					&secinfo, region.mrmask);
+					&secinfo, region.mrmask, region.flags);
 		if (ret)
 			break;
 	}
-- 
2.21.0

