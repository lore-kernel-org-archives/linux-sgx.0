Return-Path: <SRS0=VWPK=5I=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12121C1975A
	for <linux-sgx@archiver.kernel.org>; Mon, 23 Mar 2020 03:46:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E41DC2070A
	for <linux-sgx@archiver.kernel.org>; Mon, 23 Mar 2020 03:46:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbgCWDqw (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 22 Mar 2020 23:46:52 -0400
Received: from mga06.intel.com ([134.134.136.31]:64502 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726979AbgCWDqw (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 22 Mar 2020 23:46:52 -0400
IronPort-SDR: IP6TcWf2I9vBarWKnukRys12bg6Dgw6Isx11ZQtJKJ2hoPa+uR9uar0UDbcqzbRJ61Fn9X3hXd
 JuwBM/OloaHA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2020 20:46:52 -0700
IronPort-SDR: PvB8cUOGuME9TwPRDDCdUNfGcVgejJFmuQ8CsaGnhcsWUPDbTUPrFDXoEujeh2L1oHRhqVg4fO
 Y3uX0h+YJ/vQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,295,1580803200"; 
   d="scan'208";a="239288298"
Received: from nspindel-mobl.ger.corp.intel.com (HELO localhost) ([10.214.214.10])
  by fmsmga008.fm.intel.com with ESMTP; 22 Mar 2020 20:46:49 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 4/5] selftest/sgx: Replace encl_build() with encl_build_segment()
Date:   Mon, 23 Mar 2020 05:46:33 +0200
Message-Id: <20200323034634.4157-4-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200323034634.4157-1-jarkko.sakkinen@linux.intel.com>
References: <20200323034634.4157-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Remove encl_build() and introduce encl_build_segment(), which builds and
maps one segment of the enclave with given flags and permissions. This
enables to load segments directly from an ELF files.

Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 tools/testing/selftests/sgx/main.c | 35 ++++++++++++++----------------
 1 file changed, 16 insertions(+), 19 deletions(-)

diff --git a/tools/testing/selftests/sgx/main.c b/tools/testing/selftests/sgx/main.c
index 995423565c83..a78e64159313 100644
--- a/tools/testing/selftests/sgx/main.c
+++ b/tools/testing/selftests/sgx/main.c
@@ -191,30 +191,18 @@ static bool encl_add_pages(int dev_fd, unsigned long offset, void *data,
 	return true;
 }
 
-#define SGX_REG_PAGE_FLAGS \
-	(SGX_SECINFO_REG | SGX_SECINFO_R | SGX_SECINFO_W | SGX_SECINFO_X)
 
-static bool encl_build(int encl_fd, struct sgx_secs *secs, void *bin,
-		       unsigned long bin_size)
+static bool encl_build_segment(int encl_fd, struct sgx_secs *secs, void *bin,
+			       unsigned long seg_offset, unsigned long seg_size,
+			       uint64_t flags, int prot)
 {
 	void *addr;
 
-	if (!encl_add_pages(encl_fd, 0, bin, PAGE_SIZE, SGX_SECINFO_TCS))
+	if (!encl_add_pages(encl_fd, seg_offset, bin + seg_offset, seg_size,
+			    flags))
 		return false;
 
-	if (!encl_add_pages(encl_fd, PAGE_SIZE, bin + PAGE_SIZE,
-			    bin_size - PAGE_SIZE, SGX_REG_PAGE_FLAGS))
-		return false;
-
-	addr = mmap((void *)secs->base, PAGE_SIZE, PROT_READ | PROT_WRITE,
-		    MAP_SHARED | MAP_FIXED, encl_fd, 0);
-	if (addr == MAP_FAILED) {
-		fprintf(stderr, "mmap() failed on TCS, errno=%d.\n", errno);
-		return false;
-	}
-
-	addr = mmap((void *)(secs->base + PAGE_SIZE), bin_size - PAGE_SIZE,
-		    PROT_READ | PROT_WRITE | PROT_EXEC,
+	addr = mmap((void *)secs->base + seg_offset, seg_size, prot,
 		    MAP_SHARED | MAP_FIXED, encl_fd, 0);
 	if (addr == MAP_FAILED) {
 		fprintf(stderr, "mmap() failed, errno=%d.\n", errno);
@@ -324,7 +312,16 @@ int main(int argc, char *argv[], char *envp[])
 	if (!encl_create(ctx.encl_fd, ctx.bin_size, &ctx.secs))
 		goto err;
 
-	if (!encl_build(ctx.encl_fd, &ctx.secs, ctx.bin, ctx.bin_size))
+	/* TCS */
+	if (!encl_build_segment(ctx.encl_fd, &ctx.secs, ctx.bin, 0, PAGE_SIZE,
+				SGX_SECINFO_TCS, PROT_READ | PROT_WRITE))
+		goto err;
+
+	if (!encl_build_segment(ctx.encl_fd, &ctx.secs, ctx.bin, PAGE_SIZE,
+				ctx.bin_size - PAGE_SIZE,
+				SGX_SECINFO_REG | SGX_SECINFO_R |
+				SGX_SECINFO_W | SGX_SECINFO_X,
+				PROT_READ | PROT_WRITE | PROT_EXEC))
 		goto err;
 
 	if (!encl_create_sigstruct(ctx.bin, ctx.bin_size, &sigstruct))
-- 
2.25.1

