Return-Path: <SRS0=SeXc=WG=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BB72C433FF
	for <linux-sgx@archiver.kernel.org>; Sat, 10 Aug 2019 00:30:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3DD50214C6
	for <linux-sgx@archiver.kernel.org>; Sat, 10 Aug 2019 00:30:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbfHJAax (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 9 Aug 2019 20:30:53 -0400
Received: from mga14.intel.com ([192.55.52.115]:16579 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725985AbfHJAaw (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 9 Aug 2019 20:30:52 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Aug 2019 17:30:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,367,1559545200"; 
   d="scan'208";a="199555723"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga004.fm.intel.com with ESMTP; 09 Aug 2019 17:30:52 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v22] selftests/x86/sgx: Ensure SECS base (ELRANGE) is naturally aligned
Date:   Fri,  9 Aug 2019 17:30:51 -0700
Message-Id: <20190810003051.15712-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Manually align ELRANGE now that the kernel doesn't automatically do so
for SGX mappings.  To guarantee mmap() returns a region that can be
naturally aligned, temporarily map 2x the enclave size and do fancy
arithmetic to naturally align the base.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 tools/testing/selftests/x86/sgx/main.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/x86/sgx/main.c b/tools/testing/selftests/x86/sgx/main.c
index effcdb3380ad..5bbc60cf7f89 100644
--- a/tools/testing/selftests/x86/sgx/main.c
+++ b/tools/testing/selftests/x86/sgx/main.c
@@ -130,7 +130,8 @@ static bool encl_create(int dev_fd, unsigned long bin_size,
 			struct sgx_secs *secs)
 {
 	struct sgx_enclave_create ioc;
-	void *base;
+	uint64_t base;
+	void *basep;
 	int rc;
 
 	memset(secs, 0, sizeof(*secs));
@@ -141,19 +142,27 @@ static bool encl_create(int dev_fd, unsigned long bin_size,
 	for (secs->size = 4096; secs->size < bin_size; )
 		secs->size <<= 1;
 
-	base = mmap(NULL, secs->size, PROT_NONE, MAP_SHARED, dev_fd, 0);
-	if (base == MAP_FAILED) {
+	basep = mmap(NULL, secs->size * 2, PROT_NONE, MAP_SHARED, dev_fd, 0);
+	if (basep == MAP_FAILED) {
 		perror("mmap");
 		return false;
 	}
+	base = (uint64_t)basep;
 
-	secs->base = (uint64_t)base;
+	secs->base = base + secs->size - (base % secs->size);
+
+	if (secs->base != base)
+		munmap(basep, secs->base - base);
+
+	if (secs->base - secs->size != base)
+		munmap((void *)(secs->base + secs->size),
+		       base + secs->size - secs->base);
 
 	ioc.src = (unsigned long)secs;
 	rc = ioctl(dev_fd, SGX_IOC_ENCLAVE_CREATE, &ioc);
 	if (rc) {
 		fprintf(stderr, "ECREATE failed rc=%d, err=%d.\n", rc, errno);
-		munmap(base, secs->size);
+		munmap((void *)secs->base, secs->size);
 		return false;
 	}
 
-- 
2.22.0

