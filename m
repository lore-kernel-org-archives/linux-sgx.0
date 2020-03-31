Return-Path: <SRS0=QQlo=5Q=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0A9DC43331
	for <linux-sgx@archiver.kernel.org>; Tue, 31 Mar 2020 11:44:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF4F7206DB
	for <linux-sgx@archiver.kernel.org>; Tue, 31 Mar 2020 11:44:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730642AbgCaLot (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 31 Mar 2020 07:44:49 -0400
Received: from mga07.intel.com ([134.134.136.100]:45935 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730542AbgCaLot (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 31 Mar 2020 07:44:49 -0400
IronPort-SDR: HfFVOmP3xn8ijXeOQewJ7uPFRTHuxv6GTXLIPvfl3dxDjVrdw015nc/rzMuyyFBi7ffGpD4+xr
 Q47sfqvgEKSQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2020 04:44:48 -0700
IronPort-SDR: S36AzHGR9Nb+BXDuEFT3Ql9WYve7T1kjLSvwIzZ5kO+RNvMRpW/UfOBRDnJhKJeypCfdRIGlUJ
 ZowhcH2l5k+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,327,1580803200"; 
   d="scan'208";a="272717070"
Received: from tking1-mobl2.ger.corp.intel.com (HELO localhost) ([10.252.59.94])
  by fmsmga004.fm.intel.com with ESMTP; 31 Mar 2020 04:44:44 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-sgx@vger.kernel.org
Cc:     kai.svahn@intel.com, bruce.schlobohm@intel.com,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        luto@kernel.org, Stephen Smalley <sds@tycho.nsa.gov>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH 2/4] x86/sgx: Put enclaves into anonymous files
Date:   Tue, 31 Mar 2020 14:44:30 +0300
Message-Id: <20200331114432.7593-3-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200331114432.7593-1-jarkko.sakkinen@linux.intel.com>
References: <20200331114432.7593-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

When creating an enclave attach it to an anonymous file. This prepares the
code to have a separate interface at runtime, which can be published to the
user space after the enclave has been fully initialized.

Cc: luto@kernel.org
Cc: Stephen Smalley <sds@tycho.nsa.gov>
Cc: Casey Schaufler <casey@schaufler-ca.com>
Cc: Haitao Huang <haitao.huang@linux.intel.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/kernel/cpu/sgx/driver.c | 102 +++++++++++++++++++++----------
 arch/x86/kernel/cpu/sgx/ioctl.c  |   3 +-
 2 files changed, 71 insertions(+), 34 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx/driver.c
index 997a7f4117c5..1c825ef957db 100644
--- a/arch/x86/kernel/cpu/sgx/driver.c
+++ b/arch/x86/kernel/cpu/sgx/driver.c
@@ -6,6 +6,7 @@
 #include <linux/mman.h>
 #include <linux/security.h>
 #include <linux/suspend.h>
+#include <linux/anon_inodes.h>
 #include <asm/traps.h>
 #include "driver.h"
 #include "encl.h"
@@ -21,35 +22,7 @@ u64 sgx_attributes_reserved_mask;
 u64 sgx_xfrm_reserved_mask = ~0x3;
 u32 sgx_xsave_size_tbl[64];
 
-static int sgx_open(struct inode *inode, struct file *file)
-{
-	struct sgx_encl *encl;
-	int ret;
-
-	encl = kzalloc(sizeof(*encl), GFP_KERNEL);
-	if (!encl)
-		return -ENOMEM;
-
-	atomic_set(&encl->flags, 0);
-	kref_init(&encl->refcount);
-	INIT_LIST_HEAD(&encl->va_pages);
-	INIT_RADIX_TREE(&encl->page_tree, GFP_KERNEL);
-	mutex_init(&encl->lock);
-	INIT_LIST_HEAD(&encl->mm_list);
-	spin_lock_init(&encl->mm_lock);
-
-	ret = init_srcu_struct(&encl->srcu);
-	if (ret) {
-		kfree(encl);
-		return ret;
-	}
-
-	file->private_data = encl;
-
-	return 0;
-}
-
-static int sgx_release(struct inode *inode, struct file *file)
+static int sgx_encl_file_release(struct inode *inode, struct file *file)
 {
 	struct sgx_encl *encl = file->private_data;
 	struct sgx_encl_mm *encl_mm;
@@ -84,6 +57,68 @@ static int sgx_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
+static const struct file_operations sgx_encl_file_fops = {
+	.owner			= THIS_MODULE,
+	.release		= sgx_encl_file_release,
+};
+
+static int sgx_open(struct inode *inode, struct file *file)
+{
+	struct file *encl_file = NULL;
+	struct sgx_encl *encl = NULL;
+	int ret;
+
+	encl = kzalloc(sizeof(*encl), GFP_KERNEL);
+	if (!encl) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	encl_file = anon_inode_getfile("[sgx]", &sgx_encl_file_fops, encl,
+				       O_RDWR);
+	if (IS_ERR(encl_file)) {
+		ret = PTR_ERR(encl_file);
+		goto err;
+	}
+
+	ret = init_srcu_struct(&encl->srcu);
+	if (ret)
+		goto err;
+
+	atomic_set(&encl->flags, 0);
+	kref_init(&encl->refcount);
+	INIT_LIST_HEAD(&encl->va_pages);
+	INIT_RADIX_TREE(&encl->page_tree, GFP_KERNEL);
+	mutex_init(&encl->lock);
+	INIT_LIST_HEAD(&encl->mm_list);
+	spin_lock_init(&encl->mm_lock);
+
+	file->private_data = encl_file;
+
+	return 0;
+
+err:
+	if (encl_file)
+		fput(encl_file);
+
+	kfree(encl);
+	return ret;
+}
+
+static int sgx_encl_dev_release(struct inode *inode, struct file *file)
+{
+	struct file *encl_file = file->private_data;
+
+	/*
+	 * Can be NULL when the enclave file has been handed over to the
+	 * user space.
+	 */
+	if (encl_file)
+		fput(encl_file);
+
+	return 0;
+}
+
 #ifdef CONFIG_COMPAT
 static long sgx_compat_ioctl(struct file *filep, unsigned int cmd,
 			      unsigned long arg)
@@ -94,7 +129,8 @@ static long sgx_compat_ioctl(struct file *filep, unsigned int cmd,
 
 static int sgx_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	struct sgx_encl *encl = file->private_data;
+	struct file *encl_file = file->private_data;
+	struct sgx_encl *encl = encl_file->private_data;
 	int ret;
 
 	ret = sgx_encl_may_map(encl, vma->vm_start, vma->vm_end,
@@ -128,10 +164,10 @@ static unsigned long sgx_get_unmapped_area(struct file *file,
 	return current->mm->get_unmapped_area(file, addr, len, pgoff, flags);
 }
 
-static const struct file_operations sgx_encl_fops = {
+static const struct file_operations sgx_encl_dev_fops = {
 	.owner			= THIS_MODULE,
 	.open			= sgx_open,
-	.release		= sgx_release,
+	.release		= sgx_encl_dev_release,
 	.unlocked_ioctl		= sgx_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl		= sgx_compat_ioctl,
@@ -148,7 +184,7 @@ static struct miscdevice sgx_dev_enclave = {
 	.minor = MISC_DYNAMIC_MINOR,
 	.name = "enclave",
 	.nodename = "sgx/enclave",
-	.fops = &sgx_encl_fops,
+	.fops = &sgx_encl_dev_fops,
 };
 
 static struct miscdevice sgx_dev_provision = {
diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 3af0596530a8..891aa9395907 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -766,7 +766,8 @@ static long sgx_ioc_enclave_set_attribute(struct sgx_encl *encl,
 
 long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 {
-	struct sgx_encl *encl = filep->private_data;
+	struct file *encl_file = filep->private_data;
+	struct sgx_encl *encl = encl_file->private_data;
 	int ret, encl_flags;
 
 	encl_flags = atomic_fetch_or(SGX_ENCL_IOCTL, &encl->flags);
-- 
2.25.1

