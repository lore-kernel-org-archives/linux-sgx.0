Return-Path: <SRS0=rDpG=ST=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEF6CC10F12
	for <linux-sgx@archiver.kernel.org>; Wed, 17 Apr 2019 10:41:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB17C2173C
	for <linux-sgx@archiver.kernel.org>; Wed, 17 Apr 2019 10:41:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731693AbfDQKls (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 17 Apr 2019 06:41:48 -0400
Received: from mga17.intel.com ([192.55.52.151]:9722 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729522AbfDQKls (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 17 Apr 2019 06:41:48 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Apr 2019 03:41:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,361,1549958400"; 
   d="scan'208";a="132120105"
Received: from jsakkine-mobl1.tm.intel.com (HELO localhost) ([10.237.50.189])
  by orsmga007.jf.intel.com with ESMTP; 17 Apr 2019 03:41:40 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     akpm@linux-foundation.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        linux-security-module@vger.kernel.org
Subject: [PATCH v20 16/28] x86/sgx: Add provisioning
Date:   Wed, 17 Apr 2019 13:39:26 +0300
Message-Id: <20190417103938.7762-17-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190417103938.7762-1-jarkko.sakkinen@linux.intel.com>
References: <20190417103938.7762-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

In order to provide a mechanism for devilering provisoning rights:

1. Add a new device file /dev/sgx/provision that works as a token for
   allowing an enclave to have the provisioning privileges.
2. Add a new ioctl called SGX_IOC_ENCLAVE_SET_ATTRIBUTE that accepts the
   following data structure:

   struct sgx_enclave_set_attribute {
           __u64 addr;
           __u64 attribute_fd;
   };

A daemon could sit on top of /dev/sgx/provision and send a file
descriptor of this file to a process that needs to be able to provision
enclaves.

The way this API is used is straight-forward. Lets assume that dev_fd is
a handle to /dev/sgx/enclave and prov_fd is a handle to
/dev/sgx/provision.  You would allow SGX_IOC_ENCLAVE_CREATE to
initialize an enclave with the PROVISIONKEY attribute by

params.addr = <enclave address>;
params.token_fd = prov_fd;

ioctl(dev_fd, SGX_IOC_ENCLAVE_SET_ATTRIBUTE, &params);

Cc: James Morris <jmorris@namei.org>
Cc: Serge E. Hallyn <serge@hallyn.com>
Cc: linux-security-module@vger.kernel.org
Suggested-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/include/uapi/asm/sgx.h         | 11 ++++++
 arch/x86/kernel/cpu/sgx/driver/driver.h |  2 +-
 arch/x86/kernel/cpu/sgx/driver/ioctl.c  | 51 +++++++++++++++++++++++++
 arch/x86/kernel/cpu/sgx/driver/main.c   | 11 +++++-
 4 files changed, 73 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
index 7bf627ac4958..3b80acde8671 100644
--- a/arch/x86/include/uapi/asm/sgx.h
+++ b/arch/x86/include/uapi/asm/sgx.h
@@ -16,6 +16,8 @@
 	_IOW(SGX_MAGIC, 0x01, struct sgx_enclave_add_page)
 #define SGX_IOC_ENCLAVE_INIT \
 	_IOW(SGX_MAGIC, 0x02, struct sgx_enclave_init)
+#define SGX_IOC_ENCLAVE_SET_ATTRIBUTE \
+	_IOW(SGX_MAGIC, 0x03, struct sgx_enclave_set_attribute)
 
 /* IOCTL return values */
 #define SGX_POWER_LOST_ENCLAVE		0x40000000
@@ -54,4 +56,13 @@ struct sgx_enclave_init {
 	__u64	sigstruct;
 };
 
+/**
+ * struct sgx_enclave_set_attribute - parameter structure for the
+ *				      %SGX_IOC_ENCLAVE_SET_ATTRIBUTE ioctl
+ * @attribute_fd:	file handle of the attribute file in the securityfs
+ */
+struct sgx_enclave_set_attribute {
+	__u64	attribute_fd;
+};
+
 #endif /* _UAPI_ASM_X86_SGX_H */
diff --git a/arch/x86/kernel/cpu/sgx/driver/driver.h b/arch/x86/kernel/cpu/sgx/driver/driver.h
index 507712eb0a68..153b4a48aa6f 100644
--- a/arch/x86/kernel/cpu/sgx/driver/driver.h
+++ b/arch/x86/kernel/cpu/sgx/driver/driver.h
@@ -31,7 +31,7 @@ extern u64 sgx_attributes_reserved_mask;
 extern u64 sgx_xfrm_reserved_mask;
 extern u32 sgx_xsave_size_tbl[64];
 
-extern const struct file_operations sgx_fs_provision_fops;
+extern const struct file_operations sgx_provision_fops;
 
 long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg);
 
diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
index f88226518b21..65c9fb7b2a95 100644
--- a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
@@ -714,6 +714,54 @@ static long sgx_ioc_enclave_init(struct file *filep, unsigned int cmd,
 	return ret;
 }
 
+/**
+ * sgx_ioc_enclave_set_attribute - handler for %SGX_IOC_ENCLAVE_SET_ATTRIBUTE
+ * @filep:	open file to /dev/sgx
+ * @cmd:	the command value
+ * @arg:	pointer to a struct sgx_enclave_set_attribute instance
+ *
+ * Mark the enclave as being allowed to access a restricted attribute bit.
+ * The requested attribute is specified via the attribute_fd field in the
+ * provided struct sgx_enclave_set_attribute.  The attribute_fd must be a
+ * handle to an SGX attribute file, e.g. “/dev/sgx/provision".
+ *
+ * Failure to explicitly request access to a restricted attribute will cause
+ * sgx_ioc_enclave_init() to fail.  Currently, the only restricted attribute
+ * is access to the PROVISION_KEY.
+ *
+ * Note, access to the EINITTOKEN_KEY is disallowed entirely.
+ *
+ * Return: 0 on success, -errno otherwise
+ */
+static long sgx_ioc_enclave_set_attribute(struct file *filep, unsigned int cmd,
+					  unsigned long arg)
+{
+	struct sgx_enclave_set_attribute *params = (void *)arg;
+	struct file *attribute_file;
+	struct sgx_encl *encl;
+	int ret;
+
+	attribute_file = fget(params->attribute_fd);
+	if (!attribute_file->f_op)
+		return -EINVAL;
+
+	if (attribute_file->f_op != &sgx_provision_fops) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ret = sgx_encl_get(params->addr, &encl);
+	if (ret)
+		goto out;
+
+	encl->allowed_attributes |= SGX_ATTR_PROVISIONKEY;
+	kref_put(&encl->refcount, sgx_encl_release);
+
+out:
+	fput(attribute_file);
+	return ret;
+}
+
 typedef long (*sgx_ioc_t)(struct file *filep, unsigned int cmd,
 			  unsigned long arg);
 
@@ -733,6 +781,9 @@ long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 	case SGX_IOC_ENCLAVE_INIT:
 		handler = sgx_ioc_enclave_init;
 		break;
+	case SGX_IOC_ENCLAVE_SET_ATTRIBUTE:
+		handler = sgx_ioc_enclave_set_attribute;
+		break;
 	default:
 		return -ENOIOCTLCMD;
 	}
diff --git a/arch/x86/kernel/cpu/sgx/driver/main.c b/arch/x86/kernel/cpu/sgx/driver/main.c
index d371add399cd..8b79c4a60037 100644
--- a/arch/x86/kernel/cpu/sgx/driver/main.c
+++ b/arch/x86/kernel/cpu/sgx/driver/main.c
@@ -103,7 +103,7 @@ static const struct file_operations sgx_encl_fops = {
 	.get_unmapped_area	= sgx_get_unmapped_area,
 };
 
-static const struct file_operations sgx_provision_fops = {
+const struct file_operations sgx_provision_fops = {
 	.owner			= THIS_MODULE,
 };
 
@@ -261,8 +261,16 @@ static int sgx_dev_init(struct device *parent)
 	if (ret)
 		goto err_encl_dev_add;
 
+	ret = cdev_device_add(&sgx_dev->provision_cdev,
+			      &sgx_dev->provision_dev);
+	if (ret)
+		goto err_provision_dev_add;
+
 	return 0;
 
+err_provision_dev_add:
+	cdev_device_del(&sgx_dev->encl_cdev, &sgx_dev->encl_dev);
+
 err_encl_dev_add:
 	destroy_workqueue(sgx_encl_wq);
 
@@ -289,6 +297,7 @@ static int sgx_drv_remove(struct platform_device *pdev)
 	struct sgx_dev_ctx *ctx = dev_get_drvdata(&pdev->dev);
 
 	cdev_device_del(&ctx->encl_cdev, &ctx->encl_dev);
+	cdev_device_del(&ctx->provision_cdev, &ctx->provision_dev);
 	destroy_workqueue(sgx_encl_wq);
 
 	return 0;
-- 
2.19.1

