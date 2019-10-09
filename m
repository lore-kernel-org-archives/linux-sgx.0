Return-Path: <SRS0=7vij=YC=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FBD0ECE599
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Oct 2019 04:42:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A096218DE
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Oct 2019 04:42:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729658AbfJIEmo (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 9 Oct 2019 00:42:44 -0400
Received: from mga11.intel.com ([192.55.52.93]:6369 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729040AbfJIEmo (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 9 Oct 2019 00:42:44 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Oct 2019 21:42:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,273,1566889200"; 
   d="scan'208";a="218504433"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga004.fm.intel.com with ESMTP; 08 Oct 2019 21:42:43 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v23 7/7] selftests/x86/sgx: Add test coverage for reclaim and replicate
Date:   Tue,  8 Oct 2019 21:42:41 -0700
Message-Id: <20191009044241.3591-8-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20191009044241.3591-1-sean.j.christopherson@intel.com>
References: <20191009044241.3591-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Pad 2*epc_size bytes to the end of the selftest enclave to test basic
reclaim functionality, and use the new replicate flag when adding the
pages.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 tools/testing/selftests/x86/sgx/defines.h | 28 +++++++++++++++++++++++
 tools/testing/selftests/x86/sgx/main.c    |  8 ++++++-
 tools/testing/selftests/x86/sgx/sgxsign.c | 20 ++++++++++++++--
 3 files changed, 53 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/x86/sgx/defines.h b/tools/testing/selftests/x86/sgx/defines.h
index 3ff73a9d9b93..8d7b19b7e658 100644
--- a/tools/testing/selftests/x86/sgx/defines.h
+++ b/tools/testing/selftests/x86/sgx/defines.h
@@ -36,4 +36,32 @@ typedef uint64_t u64;
 #include "../../../../../arch/x86/kernel/cpu/sgx/arch.h"
 #include "../../../../../arch/x86/include/uapi/asm/sgx.h"
 
+/* Used to tack on unused data to the enclave to test reclaim and replicate. */
+#define SGX_SELFTEST_FILL_VALUE 0xcc
+
+static inline uint64_t get_epc_size(void)
+{
+	uint32_t eax, ebx, ecx, edx;
+	uint64_t size = 0;
+	int i;
+
+	for (i = 2; ; i++) {
+		asm volatile("cpuid"
+			     : "=a"(eax), "=b"(ebx), "=c"(ecx), "=d"(edx)
+			     : "a"(0x12), "c"(i));
+
+		if ((eax & SGX_CPUID_SUB_LEAF_TYPE_MASK) !=
+			SGX_CPUID_SUB_LEAF_EPC_SECTION)
+			break;
+
+		size += ((ecx & 0xfffff000UL) | ((uint64_t)edx << 32));
+	}
+	return size;
+}
+
+static inline uint64_t get_fill_size(void)
+{
+	return get_epc_size() * 2;
+}
+
 #endif /* TYPES_H */
diff --git a/tools/testing/selftests/x86/sgx/main.c b/tools/testing/selftests/x86/sgx/main.c
index 0921aeda9942..d179b536d007 100644
--- a/tools/testing/selftests/x86/sgx/main.c
+++ b/tools/testing/selftests/x86/sgx/main.c
@@ -198,6 +198,8 @@ static bool encl_add_pages(int dev_fd, unsigned long offset, void *data,
 static bool encl_build(struct sgx_secs *secs, void *bin,
 		       unsigned long bin_size, struct sgx_sigstruct *sigstruct)
 {
+	uint8_t fill_page[PAGE_SIZE] __aligned(4096);
+	uint64_t fill_size = get_fill_size();
 	struct sgx_enclave_init ioc;
 	void *addr;
 	int dev_fd;
@@ -209,12 +211,16 @@ static bool encl_build(struct sgx_secs *secs, void *bin,
 		return false;
 	}
 
-	if (!encl_create(dev_fd, bin_size, secs))
+	if (!encl_create(dev_fd, bin_size + fill_size, secs))
 		goto out_dev_fd;
 
+	memset(fill_page, SGX_SELFTEST_FILL_VALUE, PAGE_SIZE);
+
 	encl_add_pages(dev_fd, 0, bin, 1, SGX_SECINFO_TCS, 0);
 	encl_add_pages(dev_fd, PAGE_SIZE, bin + PAGE_SIZE,
 		       (bin_size / PAGE_SIZE) - 1, SGX_REG_PAGE_FLAGS, 0);
+	encl_add_pages(dev_fd, bin_size, fill_page, fill_size / PAGE_SIZE,
+		       SGX_REG_PAGE_FLAGS, SGX_ADD_PAGES_REPLICATE_SRC);
 
 	ioc.sigstruct = (uint64_t)sigstruct;
 	rc = ioctl(dev_fd, SGX_IOC_ENCLAVE_INIT, &ioc);
diff --git a/tools/testing/selftests/x86/sgx/sgxsign.c b/tools/testing/selftests/x86/sgx/sgxsign.c
index 3d9007af40c9..98dee0d4b376 100644
--- a/tools/testing/selftests/x86/sgx/sgxsign.c
+++ b/tools/testing/selftests/x86/sgx/sgxsign.c
@@ -231,8 +231,9 @@ static bool measure_encl(const char *path, uint8_t *mrenclave)
 	struct stat sb;
 	EVP_MD_CTX *ctx;
 	uint64_t flags;
-	uint64_t offset;
+	uint64_t offset, i;
 	uint8_t data[0x1000];
+	uint64_t fill_size;
 	int rc;
 
 	ctx = EVP_MD_CTX_create();
@@ -257,7 +258,9 @@ static bool measure_encl(const char *path, uint8_t *mrenclave)
 		goto out;
 	}
 
-	if (!mrenclave_ecreate(ctx, sb.st_size))
+	fill_size = get_fill_size();
+
+	if (!mrenclave_ecreate(ctx, sb.st_size + fill_size))
 		goto out;
 
 	for (offset = 0; offset < sb.st_size; offset += 0x1000) {
@@ -280,6 +283,19 @@ static bool measure_encl(const char *path, uint8_t *mrenclave)
 			goto out;
 	}
 
+	memset(data, SGX_SELFTEST_FILL_VALUE, 0x1000);
+
+	for (i = 0; i < fill_size; i += 0x1000) {
+		flags = SGX_SECINFO_REG |
+			SGX_SECINFO_R | SGX_SECINFO_W | SGX_SECINFO_X;
+
+		if (!mrenclave_eadd(ctx, offset + i, flags))
+			goto out;
+
+		if (!mrenclave_eextend(ctx, offset + i, data))
+			goto out;
+	}
+
 	if (!mrenclave_commit(ctx, mrenclave))
 		goto out;
 
-- 
2.22.0

