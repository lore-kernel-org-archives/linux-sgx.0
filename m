Return-Path: <SRS0=6XgF=UE=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFF51C28D19
	for <linux-sgx@archiver.kernel.org>; Wed,  5 Jun 2019 19:49:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A26702089E
	for <linux-sgx@archiver.kernel.org>; Wed,  5 Jun 2019 19:49:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbfFETt3 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 5 Jun 2019 15:49:29 -0400
Received: from mga01.intel.com ([192.55.52.88]:2918 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726512AbfFETt3 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
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
Subject: [PATCH 3/7] x86/sgx: Let ioctl helpers do copy to/from user
Date:   Wed,  5 Jun 2019 12:48:41 -0700
Message-Id: <20190605194845.926-4-sean.j.christopherson@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190605194845.926-1-sean.j.christopherson@intel.com>
References: <20190605194845.926-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

A future patch will extend SGX_IOC_ENCLAVE_ADD_PAGE to allow userspace
to add multiple pages in a single ioctl.  Because the number of pages
could be quite high, it's possible the ioctl could be interrupted, in
which case the driver will need to "return" the number of pages that
have been queued, e.g. so that userspace can restart the ioctl in the
event that the signal wasn't fatal.

In short, SGX_IOC_ENCLAVE_ADD_PAGE will become a conditional _IOWR
and will only do copy_to_user() on a non-zero return value.  Rather than
implement funky logic, pass the raw userspace argument to the helpers
so that they may do copy_{to,from}_user() at will.  This kills
pre-copying the data, but the value added by pre-copy is tenuous, e.g.
it consolidates two lines of code but requires use of a fixed size
buffer as well as an indirect handler and thus retpoline.  And the
pre-copy may lead to reader confusion due to @arg being a user pointer
in some flows and a kernel pointer in others.  Lastly, in the event that
a pure _IOR ioctl is added, there won't be a need to update the existing
code (to skip copy_from_user()).

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
---
 arch/x86/kernel/cpu/sgx/driver/ioctl.c | 73 ++++++++++++--------------
 1 file changed, 34 insertions(+), 39 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
index a0742d18aa36..d17c60dca114 100644
--- a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
@@ -383,7 +383,7 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
 /**
  * sgx_ioc_enclave_create - handler for %SGX_IOC_ENCLAVE_CREATE
  * @filep:	open file to /dev/sgx
- * @arg:	pointer to an &sgx_enclave_create instance
+ * @arg:	userspace pointer to a struct sgx_enclave_create instance
  *
  * Allocate kernel data structures for a new enclave and execute ECREATE after
  * verifying the correctness of the provided SECS.
@@ -396,25 +396,27 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
  *   0 on success,
  *   -errno otherwise
  */
-static long sgx_ioc_enclave_create(struct file *filep, unsigned long arg)
+static long sgx_ioc_enclave_create(struct file *filep, void __user *arg)
 {
-	struct sgx_enclave_create *createp = (struct sgx_enclave_create *)arg;
 	struct sgx_encl *encl = filep->private_data;
+	struct sgx_enclave_create ecreate;
 	struct page *secs_page;
 	struct sgx_secs *secs;
 	int ret;
 
+	if (copy_from_user(&ecreate, arg, sizeof(ecreate)))
+		return -EFAULT;
+
 	secs_page = alloc_page(GFP_HIGHUSER);
 	if (!secs_page)
 		return -ENOMEM;
 
 	secs = kmap(secs_page);
-	if (copy_from_user(secs, (void __user *)createp->src, sizeof(*secs))) {
+	if (copy_from_user(secs, (void __user *)ecreate.src, sizeof(*secs))) {
 		ret = -EFAULT;
 		goto out;
 	}
 
-
 	ret = sgx_encl_create(encl, secs);
 
 out:
@@ -577,7 +579,7 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long addr,
  * sgx_ioc_enclave_add_page - handler for %SGX_IOC_ENCLAVE_ADD_PAGE
  *
  * @filep:	open file to /dev/sgx
- * @arg:	pointer to an &sgx_enclave_add_page instance
+ * @arg:	userspace pointer to a struct sgx_enclave_add_page instance
  *
  * Add a page to an uninitialized enclave (EADD), and optionally extend the
  * enclave's measurement with the contents of the page (EEXTEND).  EADD and
@@ -590,16 +592,19 @@ static int sgx_encl_add_page(struct sgx_encl *encl, unsigned long addr,
  *   0 on success,
  *   -errno otherwise
  */
-static long sgx_ioc_enclave_add_page(struct file *filep, unsigned long arg)
+static long sgx_ioc_enclave_add_page(struct file *filep, void __user *arg)
 {
-	struct sgx_enclave_add_page *addp = (void *)arg;
 	struct sgx_encl *encl = filep->private_data;
+	struct sgx_enclave_add_page addp;
 	struct sgx_secinfo secinfo;
 	struct page *data_page;
 	void *data;
 	int ret;
 
-	if (copy_from_user(&secinfo, (void __user *)addp->secinfo,
+	if (copy_from_user(&addp, arg, sizeof(addp)))
+		return -EFAULT;
+
+	if (copy_from_user(&secinfo, (void __user *)addp.secinfo,
 			   sizeof(secinfo)))
 		return -EFAULT;
 
@@ -609,12 +614,12 @@ static long sgx_ioc_enclave_add_page(struct file *filep, unsigned long arg)
 
 	data = kmap(data_page);
 
-	if (copy_from_user((void *)data, (void __user *)addp->src, PAGE_SIZE)) {
+	if (copy_from_user((void *)data, (void __user *)addp.src, PAGE_SIZE)) {
 		ret = -EFAULT;
 		goto out;
 	}
 
-	ret = sgx_encl_add_page(encl, addp->addr, data, &secinfo, addp->mrmask);
+	ret = sgx_encl_add_page(encl, addp.addr, data, &secinfo, addp.mrmask);
 	if (ret)
 		goto out;
 
@@ -717,7 +722,7 @@ static int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct *sigstruct,
  * sgx_ioc_enclave_init - handler for %SGX_IOC_ENCLAVE_INIT
  *
  * @filep:	open file to /dev/sgx
- * @arg:	pointer to an &sgx_enclave_init instance
+ * @arg:	userspace pointer to a struct sgx_enclave_init instance
  *
  * Flush any outstanding enqueued EADD operations and perform EINIT.  The
  * Launch Enclave Public Key Hash MSRs are rewritten as necessary to match
@@ -728,15 +733,18 @@ static int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct *sigstruct,
  *   SGX error code on EINIT failure,
  *   -errno otherwise
  */
-static long sgx_ioc_enclave_init(struct file *filep, unsigned long arg)
+static long sgx_ioc_enclave_init(struct file *filep, void __user *arg)
 {
-	struct sgx_enclave_init *initp = (struct sgx_enclave_init *)arg;
 	struct sgx_encl *encl = filep->private_data;
 	struct sgx_einittoken *einittoken;
 	struct sgx_sigstruct *sigstruct;
+	struct sgx_enclave_init einit;
 	struct page *initp_page;
 	int ret;
 
+	if (copy_from_user(&einit, arg, sizeof(einit)))
+		return -EFAULT;
+
 	initp_page = alloc_page(GFP_HIGHUSER);
 	if (!initp_page)
 		return -ENOMEM;
@@ -746,13 +754,12 @@ static long sgx_ioc_enclave_init(struct file *filep, unsigned long arg)
 		((unsigned long)sigstruct + PAGE_SIZE / 2);
 	memset(einittoken, 0, sizeof(*einittoken));
 
-	if (copy_from_user(sigstruct, (void __user *)initp->sigstruct,
+	if (copy_from_user(sigstruct, (void __user *)einit.sigstruct,
 			   sizeof(*sigstruct))) {
 		ret = -EFAULT;
 		goto out;
 	}
 
-
 	ret = sgx_encl_init(encl, sigstruct, einittoken);
 
 out:
@@ -764,7 +771,7 @@ static long sgx_ioc_enclave_init(struct file *filep, unsigned long arg)
 /**
  * sgx_ioc_enclave_set_attribute - handler for %SGX_IOC_ENCLAVE_SET_ATTRIBUTE
  * @filep:	open file to /dev/sgx
- * @arg:	pointer to a struct sgx_enclave_set_attribute instance
+ * @arg:	userspace pointer to a struct sgx_enclave_set_attribute instance
  *
  * Mark the enclave as being allowed to access a restricted attribute bit.
  * The requested attribute is specified via the attribute_fd field in the
@@ -779,14 +786,17 @@ static long sgx_ioc_enclave_init(struct file *filep, unsigned long arg)
  *
  * Return: 0 on success, -errno otherwise
  */
-static long sgx_ioc_enclave_set_attribute(struct file *filep, unsigned long arg)
+static long sgx_ioc_enclave_set_attribute(struct file *filep, void __user *arg)
 {
-	struct sgx_enclave_set_attribute *params = (void *)arg;
 	struct sgx_encl *encl = filep->private_data;
+	struct sgx_enclave_set_attribute params;
 	struct file *attribute_file;
 	int ret;
 
-	attribute_file = fget(params->attribute_fd);
+	if (copy_from_user(&params, arg, sizeof(params)))
+		return -EFAULT;
+
+	attribute_file = fget(params.attribute_fd);
 	if (!attribute_file->f_op)
 		return -EINVAL;
 
@@ -802,33 +812,18 @@ static long sgx_ioc_enclave_set_attribute(struct file *filep, unsigned long arg)
 	return ret;
 }
 
-typedef long (*sgx_ioc_t)(struct file *filep, unsigned long arg);
-
 long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 {
-	char data[256];
-	sgx_ioc_t handler = NULL;
-	long ret;
-
 	switch (cmd) {
 	case SGX_IOC_ENCLAVE_CREATE:
-		handler = sgx_ioc_enclave_create;
-		break;
+		return sgx_ioc_enclave_create(filep, (void __user *)arg);
 	case SGX_IOC_ENCLAVE_ADD_PAGE:
-		handler = sgx_ioc_enclave_add_page;
-		break;
+		return sgx_ioc_enclave_add_page(filep, (void __user *)arg);
 	case SGX_IOC_ENCLAVE_INIT:
-		handler = sgx_ioc_enclave_init;
-		break;
+		return sgx_ioc_enclave_init(filep, (void __user *)arg);
 	case SGX_IOC_ENCLAVE_SET_ATTRIBUTE:
-		handler = sgx_ioc_enclave_set_attribute;
-		break;
+		return sgx_ioc_enclave_set_attribute(filep, (void __user *)arg);
 	default:
 		return -ENOIOCTLCMD;
 	}
-
-	if (copy_from_user(data, (void __user *)arg, _IOC_SIZE(cmd)))
-		return -EFAULT;
-
-	return handler(filep, (unsigned long)((void *)data));
 }
-- 
2.21.0

