Return-Path: <SRS0=6XgF=UE=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ED4DC28CC6
	for <linux-sgx@archiver.kernel.org>; Wed,  5 Jun 2019 19:49:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F66920874
	for <linux-sgx@archiver.kernel.org>; Wed,  5 Jun 2019 19:49:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbfFETt3 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 5 Jun 2019 15:49:29 -0400
Received: from mga01.intel.com ([192.55.52.88]:2918 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726501AbfFETt3 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
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
Subject: [PATCH 2/7] x86/sgx: Remove unnecessary @cmd parameter from ioctl helpers
Date:   Wed,  5 Jun 2019 12:48:40 -0700
Message-Id: <20190605194845.926-3-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190605194845.926-1-sean.j.christopherson@intel.com>
References: <20190605194845.926-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Each ioctl command is directly and uniquely associated with a handler,
i.e. the command is implied by the function itself.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/driver/ioctl.c | 21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
index cc057d487499..a0742d18aa36 100644
--- a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
@@ -383,7 +383,6 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
 /**
  * sgx_ioc_enclave_create - handler for %SGX_IOC_ENCLAVE_CREATE
  * @filep:	open file to /dev/sgx
- * @cmd:	the command value
  * @arg:	pointer to an &sgx_enclave_create instance
  *
  * Allocate kernel data structures for a new enclave and execute ECREATE after
@@ -397,8 +396,7 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
  *   0 on success,
  *   -errno otherwise
  */
-static long sgx_ioc_enclave_create(struct file *filep, unsigned int cmd,
-				   unsigned long arg)
+static long sgx_ioc_enclave_create(struct file *filep, unsigned long arg)
 {
 	struct sgx_enclave_create *createp = (struct sgx_enclave_create *)arg;
 	struct sgx_encl *encl = filep->private_data;
@@ -579,7 +577,6 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long addr,
  * sgx_ioc_enclave_add_page - handler for %SGX_IOC_ENCLAVE_ADD_PAGE
  *
  * @filep:	open file to /dev/sgx
- * @cmd:	the command value
  * @arg:	pointer to an &sgx_enclave_add_page instance
  *
  * Add a page to an uninitialized enclave (EADD), and optionally extend the
@@ -593,8 +590,7 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long addr,
  *   0 on success,
  *   -errno otherwise
  */
-static long sgx_ioc_enclave_add_page(struct file *filep, unsigned int cmd,
-				     unsigned long arg)
+static long sgx_ioc_enclave_add_page(struct file *filep, unsigned long arg)
 {
 	struct sgx_enclave_add_page *addp = (void *)arg;
 	struct sgx_encl *encl = filep->private_data;
@@ -721,7 +717,6 @@ static int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct *sigstruct,
  * sgx_ioc_enclave_init - handler for %SGX_IOC_ENCLAVE_INIT
  *
  * @filep:	open file to /dev/sgx
- * @cmd:	the command value
  * @arg:	pointer to an &sgx_enclave_init instance
  *
  * Flush any outstanding enqueued EADD operations and perform EINIT.  The
@@ -733,8 +728,7 @@ static int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct *sigstruct,
  *   SGX error code on EINIT failure,
  *   -errno otherwise
  */
-static long sgx_ioc_enclave_init(struct file *filep, unsigned int cmd,
-				 unsigned long arg)
+static long sgx_ioc_enclave_init(struct file *filep, unsigned long arg)
 {
 	struct sgx_enclave_init *initp = (struct sgx_enclave_init *)arg;
 	struct sgx_encl *encl = filep->private_data;
@@ -770,7 +764,6 @@ static long sgx_ioc_enclave_init(struct file *filep, unsigned int cmd,
 /**
  * sgx_ioc_enclave_set_attribute - handler for %SGX_IOC_ENCLAVE_SET_ATTRIBUTE
  * @filep:	open file to /dev/sgx
- * @cmd:	the command value
  * @arg:	pointer to a struct sgx_enclave_set_attribute instance
  *
  * Mark the enclave as being allowed to access a restricted attribute bit.
@@ -786,8 +779,7 @@ static long sgx_ioc_enclave_init(struct file *filep, unsigned int cmd,
  *
  * Return: 0 on success, -errno otherwise
  */
-static long sgx_ioc_enclave_set_attribute(struct file *filep, unsigned int cmd,
-					  unsigned long arg)
+static long sgx_ioc_enclave_set_attribute(struct file *filep, unsigned long arg)
 {
 	struct sgx_enclave_set_attribute *params = (void *)arg;
 	struct sgx_encl *encl = filep->private_data;
@@ -810,8 +802,7 @@ static long sgx_ioc_enclave_set_attribute(struct file *filep, unsigned int cmd,
 	return ret;
 }
 
-typedef long (*sgx_ioc_t)(struct file *filep, unsigned int cmd,
-			  unsigned long arg);
+typedef long (*sgx_ioc_t)(struct file *filep, unsigned long arg);
 
 long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 {
@@ -839,5 +830,5 @@ long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 	if (copy_from_user(data, (void __user *)arg, _IOC_SIZE(cmd)))
 		return -EFAULT;
 
-	return handler(filep, cmd, (unsigned long)((void *)data));
+	return handler(filep, (unsigned long)((void *)data));
 }
-- 
2.21.0

