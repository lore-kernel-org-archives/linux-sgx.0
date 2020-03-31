Return-Path: <SRS0=QQlo=5Q=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21D79C43331
	for <linux-sgx@archiver.kernel.org>; Tue, 31 Mar 2020 11:44:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF35820658
	for <linux-sgx@archiver.kernel.org>; Tue, 31 Mar 2020 11:44:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730601AbgCaLon (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 31 Mar 2020 07:44:43 -0400
Received: from mga17.intel.com ([192.55.52.151]:15944 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730366AbgCaLon (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 31 Mar 2020 07:44:43 -0400
IronPort-SDR: OSPqXFkXqTJvuiN2DZgRp4BtwEAs8c4Bm1GX7Ftf7hyOnL+oCmKmvvx69RYKoADkttbfbipAvb
 KxiNDyHwVxlg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2020 04:44:43 -0700
IronPort-SDR: 3eMP/DmcO1bPzc7id5tY7e4Wz9QMOVZMZMIcn615ZODyBTAWhXPPTjAQ6DpUWqhs8k7qwyDxAX
 1FFekoogMZdA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,327,1580803200"; 
   d="scan'208";a="272717046"
Received: from tking1-mobl2.ger.corp.intel.com (HELO localhost) ([10.252.59.94])
  by fmsmga004.fm.intel.com with ESMTP; 31 Mar 2020 04:44:40 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     kai.svahn@intel.com, bruce.schlobohm@intel.com,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        luto@kernel.org, Stephen Smalley <sds@tycho.nsa.gov>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 1/4] x86/sgx: Remove PROT_NONE branch from sgx_encl_may_map().
Date:   Tue, 31 Mar 2020 14:44:29 +0300
Message-Id: <20200331114432.7593-2-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200331114432.7593-1-jarkko.sakkinen@linux.intel.com>
References: <20200331114432.7593-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

sgx_encl_may_map() always succeeding when PROT_NONE is given is not that
useful behaviour as one can just well as do an anonymous mapping as
demonstrated by the change in this patch to the test program. As a
consequence, remove the special case.

Pratically any possible way to make sure that you don't overwrite anything
useful in the memory, should be fine. MAP_FIXED does not care what's
underneath (if you want't it to care you ought to use
MAP_FIXED_NO_REPLACE).

After this change, the selftest run called sgx_mmap() only three times
(TCS, text, data) instead of four.

        test_sgx-1811  [002] ....   586.907585: sgx_mmap <-mmap_region
        test_sgx-1811  [002] ....   586.911752: sgx_mmap <-mmap_region
        test_sgx-1811  [002] ....   586.911756: sgx_mmap <-mmap_region

This also gives more angles to segregate enclave building and mapping as
the mmap()'s need to be applied only when the enclave is fully built:

Cc: luto@kernel.org
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Casey Schaufler <casey@schaufler-ca.com>
Cc: Haitao Huang <haitao.huang@linux.intel.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 Documentation/x86/sgx.rst          | 13 +++++--------
 arch/x86/kernel/cpu/sgx/encl.c     |  7 +------
 arch/x86/kernel/cpu/sgx/ioctl.c    |  5 -----
 tools/testing/selftests/sgx/load.c |  3 ++-
 4 files changed, 8 insertions(+), 20 deletions(-)

diff --git a/Documentation/x86/sgx.rst b/Documentation/x86/sgx.rst
index 79de1f01aa5b..9609a3409ad1 100644
--- a/Documentation/x86/sgx.rst
+++ b/Documentation/x86/sgx.rst
@@ -168,14 +168,11 @@ accounted to the processes of which behalf the kernel happened to be acting on.
 Access control
 ==============
 
-`mmap()` permissions are capped by the enclave permissions. The consequences of
-this is are:
-
-1. Pages for a VMA must built before `mmap()` can be applied with the
-   permissions required for running the enclave.
-2. An address range for an enclave can be reserved with a `PROT_NONE` mapping
-   (not required but usually makes sense to guarantee that the used address
-   range is available).
+`mmap()` permissions are capped by the enclave permissions. A direct
+consequence of this is that all the pages for an address range must be added
+before `mmap()` can be applied. Effectively an enclave page with minimum
+permission in the address range sets the permission cap for the mapping
+operation.
 
 Usage Models
 ============
diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index d6a19bdd1921..e0124a2f22d5 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -288,8 +288,7 @@ static unsigned int sgx_vma_fault(struct vm_fault *vmf)
  *
  * Iterate through the enclave pages contained within [@start, @end) to verify
  * the permissions requested by @vm_prot_bits do not exceed that of any enclave
- * page to be mapped.  Page addresses that do not have an associated enclave
- * page are interpreted to zero permissions.
+ * page to be mapped.
  *
  * Return:
  *   0 on success,
@@ -308,10 +307,6 @@ int sgx_encl_may_map(struct sgx_encl *encl, unsigned long start,
 	if (!!(current->personality & READ_IMPLIES_EXEC))
 		return -EACCES;
 
-	/* PROT_NONE always succeeds. */
-	if (!vm_prot_bits)
-		return 0;
-
 	idx_start = PFN_DOWN(start);
 	idx_end = PFN_DOWN(end - 1);
 
diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 12e1496f8a8b..3af0596530a8 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -481,15 +481,10 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long src,
  *
  * 1. A regular page: PROT_R, PROT_W and PROT_X match the SECINFO permissions.
  * 2. A TCS page: PROT_R | PROT_W.
- * 3. No page: PROT_NONE.
  *
  * mmap() is not allowed to surpass the minimum of the maximum protection bits
  * within the given address range.
  *
- * As stated above, a non-existent page is interpreted as a page with no
- * permissions. In effect, this allows mmap() with PROT_NONE to be used to seek
- * an address range for the enclave that can be then populated into SECS.
- *
  * If ENCLS opcode fails, that effectively means that EPC has been invalidated.
  * When this happens the enclave is destroyed and -EIO is returned to the
  * caller.
diff --git a/tools/testing/selftests/sgx/load.c b/tools/testing/selftests/sgx/load.c
index 35a2d7a47dd5..53c565347e9e 100644
--- a/tools/testing/selftests/sgx/load.c
+++ b/tools/testing/selftests/sgx/load.c
@@ -231,7 +231,8 @@ static bool encl_map_area(struct encl *encl)
 	size_t encl_size = encl->encl_size;
 	void *area;
 
-	area = mmap(NULL, encl_size * 2, PROT_NONE, MAP_SHARED, encl->fd, 0);
+	area = mmap(NULL, encl_size * 2, PROT_NONE,
+		    MAP_SHARED | MAP_ANONYMOUS, -1, 0);
 	if (area == MAP_FAILED) {
 		perror("mmap");
 		return false;
-- 
2.25.1

