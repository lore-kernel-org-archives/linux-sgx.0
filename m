Return-Path: <SRS0=MdAf=YB=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4CCEC4360C
	for <linux-sgx@archiver.kernel.org>; Tue,  8 Oct 2019 04:17:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C0448206BB
	for <linux-sgx@archiver.kernel.org>; Tue,  8 Oct 2019 04:17:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729832AbfJHERL (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 8 Oct 2019 00:17:11 -0400
Received: from mga17.intel.com ([192.55.52.151]:32118 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726193AbfJHERL (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 8 Oct 2019 00:17:11 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Oct 2019 21:17:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,269,1566889200"; 
   d="scan'208";a="192475727"
Received: from sjchrist-coffee.jf.intel.com ([10.54.74.41])
  by fmsmga008.fm.intel.com with ESMTP; 07 Oct 2019 21:17:10 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: [PATCH for_v23] x86/sgx: Update stale function comments for ioctl handlers
Date:   Mon,  7 Oct 2019 21:17:09 -0700
Message-Id: <20191008041709.3636-1-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Update the ioctl handler comments to reflect reality.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/ioctl.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 75f868bad3ea..6567680b1a50 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -235,11 +235,11 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
 
 /**
  * sgx_ioc_enclave_create - handler for %SGX_IOC_ENCLAVE_CREATE
- * @filep:	open file to /dev/sgx
+ * @encl:	pointer to an enclave instance (via ioctl() file pointer)
  * @arg:	userspace pointer to a struct sgx_enclave_create instance
  *
- * Allocate kernel data structures for a new enclave and execute ECREATE after
- * verifying the correctness of the provided SECS.
+ * Allocate kernel data structures for the enclave, verify the correctness of
+ * the provided SECS, and execute ECREATE.
  *
  * Note, enforcement of restricted and disallowed attributes is deferred until
  * sgx_ioc_enclave_init(), only the architectural correctness of the SECS is
@@ -444,7 +444,7 @@ static int sgx_encl_add_page(struct sgx_encl *encl,
 
 /**
  * sgx_ioc_enclave_add_page() - The handler for %SGX_IOC_ENCLAVE_ADD_PAGE
- * @filep:	open file to /dev/sgx
+ * @encl:	pointer to an enclave instance (via ioctl() file pointer)
  * @arg:	a user pointer to a struct sgx_enclave_add_page instance
  *
  * Add (EADD) a page to an uninitialized enclave, and optionally extend
@@ -591,11 +591,14 @@ static int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct *sigstruct,
 
 /**
  * sgx_ioc_enclave_init - handler for %SGX_IOC_ENCLAVE_INIT
- *
- * @filep:	open file to /dev/sgx
+ * @encl:	pointer to an enclave instance (via ioctl() file pointer)
  * @arg:	userspace pointer to a struct sgx_enclave_init instance
  *
- * Flush any outstanding enqueued EADD operations and perform EINIT.  The
+ * Check that the required attributes for the enclave have been authorized, and
+ * execute EINIT to initialize an enclave and make it runnable.  Success is not
+ * guaranteed even if all inputs are valid as EINIT is interruptible, i.e. the
+ * CPU may abort EINIT to service a pending interrupt.
+ *
  * Launch Enclave Public Key Hash MSRs are rewritten as necessary to match
  * the enclave's MRSIGNER, which is caculated from the provided sigstruct.
  *
@@ -643,7 +646,7 @@ static long sgx_ioc_enclave_init(struct sgx_encl *encl, void __user *arg)
 
 /**
  * sgx_ioc_enclave_set_attribute - handler for %SGX_IOC_ENCLAVE_SET_ATTRIBUTE
- * @filep:	open file to /dev/sgx
+ * @encl:	pointer to an enclave instance (via ioctl() file pointer)
  * @arg:	userspace pointer to a struct sgx_enclave_set_attribute instance
  *
  * Mark the enclave as being allowed to access a restricted attribute bit.
-- 
2.22.0

