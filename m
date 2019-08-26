Return-Path: <SRS0=p0kK=WW=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48644C3A59E
	for <linux-sgx@archiver.kernel.org>; Mon, 26 Aug 2019 05:32:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C26E217F4
	for <linux-sgx@archiver.kernel.org>; Mon, 26 Aug 2019 05:32:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725446AbfHZFcx (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 26 Aug 2019 01:32:53 -0400
Received: from mga17.intel.com ([192.55.52.151]:1442 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726106AbfHZFcx (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 26 Aug 2019 01:32:53 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Aug 2019 22:32:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,431,1559545200"; 
   d="scan'208";a="380406758"
Received: from chlopez-mobl1.amr.corp.intel.com (HELO localhost) ([10.252.38.177])
  by fmsmga006.fm.intel.com with ESMTP; 25 Aug 2019 22:32:51 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Serge Ayoun <serge.ayoun@intel.com>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Sean Christoherson <sean.j.christopherson@intel.com>
Subject: [PATCH] x86/sgx: Fix sgx_ioc_enclave_add_page() documentation
Date:   Mon, 26 Aug 2019 08:32:48 +0300
Message-Id: <20190826053248.4403-1-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Refine the kdoc of sgx_ioc_enclave_add_page() with a proper description
about the interaction with mmap(). Without documentation, it is
impossible to review the code change.

Cc: Serge Ayoun <serge.ayoun@intel.com>
Cc: Casey Schaufler <casey@schaufler-ca.com>
Cc: Sean Christoherson <sean.j.christopherson@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/kernel/cpu/sgx/ioctl.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index ead9fb2d9b69..4d305b2c08e2 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -442,14 +442,22 @@ static int sgx_encl_add_page(struct sgx_encl *encl,
 }
 
 /**
- * sgx_ioc_enclave_add_page - handler for %SGX_IOC_ENCLAVE_ADD_PAGE
- *
+ * sgx_ioc_enclave_add_page() - The handler for %SGX_IOC_ENCLAVE_ADD_PAGE
  * @filep:	open file to /dev/sgx
  * @arg:	a user pointer to a struct sgx_enclave_add_page instance
  *
  * Add a page to an uninitialized enclave (EADD), and optionally extend the
  * enclave's measurement with the contents of the page (EEXTEND).
  *
+ * SECINFO limits the maximum permissions, which can be given to mmap(). When
+ * mapping a range of pages, a page with least permissions will be the limit
+ * for the whole address range. This differing access levels to the enclave
+ * memory based on task privileges.
+ *
+ * A non-existent page is interpreted as a page with no permissions. In effect,
+ * this allows mmap() with PROT_NONE to be used to seek an address range for
+ * the enclave that can be then populated into SECS.
+ *
  * Return:
  *   0 on success,
  *   -EINVAL if other than RWX protection bits have been set
-- 
2.20.1

