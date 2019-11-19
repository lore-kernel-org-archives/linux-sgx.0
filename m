Return-Path: <SRS0=2BWz=ZL=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63BC6C432C0
	for <linux-sgx@archiver.kernel.org>; Tue, 19 Nov 2019 18:41:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 45C7D223E4
	for <linux-sgx@archiver.kernel.org>; Tue, 19 Nov 2019 18:41:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727205AbfKSSl6 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 19 Nov 2019 13:41:58 -0500
Received: from mga17.intel.com ([192.55.52.151]:7568 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726985AbfKSSl6 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 19 Nov 2019 13:41:58 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Nov 2019 10:41:57 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,219,1571727600"; 
   d="scan'208";a="357191690"
Received: from mthoma4-mobl.ger.corp.intel.com (HELO localhost) ([10.251.82.166])
  by orsmga004.jf.intel.com with ESMTP; 19 Nov 2019 10:41:54 -0800
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Mark Shanahan <mark.shanahan@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH for v24 v3 4/4] x86/sgx: Add @count to &sgx_enclave_add_pages
Date:   Tue, 19 Nov 2019 20:41:37 +0200
Message-Id: <20191119184137.16004-4-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191119184137.16004-1-jarkko.sakkinen@linux.intel.com>
References: <20191119184137.16004-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Add a single @count output variable to write the number of bytes
processed instead of encoding @count into three values and overwriting
input variable with those encodings.

This also more identical API to the comparable POSIX APIs (files and
sockets mainly).

Cc: Mark Shanahan <mark.shanahan@intel.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/include/uapi/asm/sgx.h |  2 ++
 arch/x86/kernel/cpu/sgx/ioctl.c | 17 ++++++-----------
 2 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
index 88644b6ad849..e196cfd44b70 100644
--- a/arch/x86/include/uapi/asm/sgx.h
+++ b/arch/x86/include/uapi/asm/sgx.h
@@ -45,6 +45,7 @@ struct sgx_enclave_create  {
  * @length:	length of the data (multiple of the page size)
  * @secinfo:	address for the SECINFO data
  * @flags:	page control flags
+ * @count:	number of bytes added (multiple of the page size)
  */
 struct sgx_enclave_add_pages {
 	__u64	src;
@@ -52,6 +53,7 @@ struct sgx_enclave_add_pages {
 	__u64	length;
 	__u64	secinfo;
 	__u64	flags;
+	__u64	count;
 };
 
 /**
diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index f08008bef943..ab9e48cd294b 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -491,11 +491,6 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long src,
  * permissions. In effect, this allows mmap() with PROT_NONE to be used to seek
  * an address range for the enclave that can be then populated into SECS.
  *
- * @arg->addr, @arg->src and @arg->length are adjusted to reflect the
- * remaining pages that need to be added to the enclave, e.g. userspace can
- * re-invoke SGX_IOC_ENCLAVE_ADD_PAGES using the same struct in response to an
- * ERESTARTSYS error.
- *
  * If ENCLS opcode fails, that effectively means that EPC has been invalidated.
  * When this happens the enclave is destroyed and -EIO is returned to the
  * caller.
@@ -510,6 +505,7 @@ static long sgx_ioc_enclave_add_pages(struct sgx_encl *encl, void __user *arg)
 {
 	struct sgx_enclave_add_pages addp;
 	struct sgx_secinfo secinfo;
+	unsigned long c;
 	int ret;
 
 	if (!(atomic_read(&encl->flags) & SGX_ENCL_CREATED))
@@ -538,7 +534,7 @@ static long sgx_ioc_enclave_add_pages(struct sgx_encl *encl, void __user *arg)
 	if (sgx_validate_secinfo(&secinfo))
 		return -EINVAL;
 
-	for ( ; addp.length > 0; addp.length -= PAGE_SIZE) {
+	for (c = 0 ; c < addp.length; c += PAGE_SIZE) {
 		if (signal_pending(current)) {
 			ret = -ERESTARTSYS;
 			break;
@@ -547,15 +543,14 @@ static long sgx_ioc_enclave_add_pages(struct sgx_encl *encl, void __user *arg)
 		if (need_resched())
 			cond_resched();
 
-		ret = sgx_encl_add_page(encl, addp.src, addp.offset,
-					addp.length, &secinfo, addp.flags);
+		ret = sgx_encl_add_page(encl, addp.src + c, addp.offset + c,
+					addp.length - c, &secinfo, addp.flags);
 		if (ret)
 			break;
-
-		addp.offset += PAGE_SIZE;
-		addp.src += PAGE_SIZE;
 	}
 
+	addp.count = c;
+
 	if (copy_to_user(arg, &addp, sizeof(addp)))
 		return -EFAULT;
 
-- 
2.20.1

