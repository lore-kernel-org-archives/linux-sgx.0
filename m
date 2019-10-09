Return-Path: <SRS0=7vij=YC=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19897ECE59A
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Oct 2019 04:42:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6D8521835
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Oct 2019 04:42:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729472AbfJIEmo (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 9 Oct 2019 00:42:44 -0400
Received: from mga11.intel.com ([192.55.52.93]:6367 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729658AbfJIEmo (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 9 Oct 2019 00:42:44 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Oct 2019 21:42:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,273,1566889200"; 
   d="scan'208";a="218504430"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga004.fm.intel.com with ESMTP; 08 Oct 2019 21:42:43 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v23 6/7] selftests/x86/sgx: Update selftest to account for ADD_PAGES flag
Date:   Tue,  8 Oct 2019 21:42:40 -0700
Message-Id: <20191009044241.3591-7-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191009044241.3591-1-sean.j.christopherson@intel.com>
References: <20191009044241.3591-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Update the call to SGX_IOC_ENCLAVE_ADD_PAGES to pass '0' for the flags,
i.e. retain the existing behavior.

No functional change intended.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 tools/testing/selftests/x86/sgx/main.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/x86/sgx/main.c b/tools/testing/selftests/x86/sgx/main.c
index 4b652fd800f5..0921aeda9942 100644
--- a/tools/testing/selftests/x86/sgx/main.c
+++ b/tools/testing/selftests/x86/sgx/main.c
@@ -165,20 +165,22 @@ static bool encl_create(int dev_fd, unsigned long bin_size,
 }
 
 static bool encl_add_pages(int dev_fd, unsigned long offset, void *data,
-			   unsigned long nr_pages, uint64_t flags)
+			   unsigned long nr_pages, uint64_t sec_flags,
+			   uint32_t misc_flags)
 {
 	struct sgx_enclave_add_pages ioc;
 	struct sgx_secinfo secinfo;
 	int rc;
 
 	memset(&secinfo, 0, sizeof(secinfo));
-	secinfo.flags = flags;
+	secinfo.flags = sec_flags;
 
 	ioc.secinfo = (unsigned long)&secinfo;
 	ioc.mrmask = 0xFFFF;
 	ioc.offset = offset;
 	ioc.src = (uint64_t)data;
 	ioc.nr_pages = nr_pages;
+	ioc.flags = misc_flags;
 	memset(ioc.reserved, 0, sizeof(ioc.reserved));
 
 	rc = ioctl(dev_fd, SGX_IOC_ENCLAVE_ADD_PAGES, &ioc);
@@ -210,9 +212,9 @@ static bool encl_build(struct sgx_secs *secs, void *bin,
 	if (!encl_create(dev_fd, bin_size, secs))
 		goto out_dev_fd;
 
-	encl_add_pages(dev_fd, 0, bin, 1, SGX_SECINFO_TCS);
+	encl_add_pages(dev_fd, 0, bin, 1, SGX_SECINFO_TCS, 0);
 	encl_add_pages(dev_fd, PAGE_SIZE, bin + PAGE_SIZE,
-		       (bin_size / PAGE_SIZE) - 1, SGX_REG_PAGE_FLAGS);
+		       (bin_size / PAGE_SIZE) - 1, SGX_REG_PAGE_FLAGS, 0);
 
 	ioc.sigstruct = (uint64_t)sigstruct;
 	rc = ioctl(dev_fd, SGX_IOC_ENCLAVE_INIT, &ioc);
-- 
2.22.0

