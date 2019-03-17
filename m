Return-Path: <SRS0=Bw5y=RU=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F507C43381
	for <linux-sgx@archiver.kernel.org>; Sun, 17 Mar 2019 21:18:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75A0A2082F
	for <linux-sgx@archiver.kernel.org>; Sun, 17 Mar 2019 21:18:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbfCQVSR (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 17 Mar 2019 17:18:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:8746 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726229AbfCQVSR (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 17 Mar 2019 17:18:17 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Mar 2019 14:18:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,491,1544515200"; 
   d="scan'208";a="142817207"
Received: from vanderss-mobl1.ger.corp.intel.com (HELO localhost) ([10.249.254.193])
  by orsmga002.jf.intel.com with ESMTP; 17 Mar 2019 14:18:03 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     x86@kernel.org, linux-sgx@vger.kernel.org
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
Subject: [PATCH v19 17/27] x86/sgx: Add provisioning
Date:   Sun, 17 Mar 2019 23:14:46 +0200
Message-Id: <20190317211456.13927-18-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190317211456.13927-1-jarkko.sakkinen@linux.intel.com>
References: <20190317211456.13927-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

In order to provide a mechanism for devilering provisoning rights:

1. Add a new file to the securityfs file called sgx/provision that works
   as a token for allowing an enclave to have the provisioning privileges.
2. Add a new ioctl called SGX_IOC_ENCLAVE_SET_ATTRIBUTE that accepts the
   following data structure:

   struct sgx_enclave_set_attribute {
           __u64 addr;
           __u64 token_fd;
   };

A daemon could sit on top of sgx/provision and send a file descriptor of
this file to a process that needs to be able to provision enclaves.

The way this API is used is more or less straight-forward. Lets assume that
dev_fd is a handle to /dev/sgx and prov_fd is a handle to sgx/provision.
You would allow SGX_IOC_ENCLAVE_CREATE to initialize an enclave with the
PROVISIONKEY attribute by

params.addr = <enclave address>;
params.token_fd = prov_fd;

ioctl(dev_fd, SGX_IOC_ENCLAVE_SET_ATTRIBUTE, &params);

Cc: James Morris <jmorris@namei.org>
Cc: Serge E. Hallyn <serge@hallyn.com>
Cc: linux-security-module@vger.kernel.org
Suggested-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/include/uapi/asm/sgx.h        | 13 +++++++
 arch/x86/kernel/cpu/sgx/driver/ioctl.c | 43 +++++++++++++++++++++++
 arch/x86/kernel/cpu/sgx/driver/main.c  | 47 ++++++++++++++++++++++++++
 3 files changed, 103 insertions(+)

diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
index aadf9c76e360..150a784db395 100644
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
@@ -56,4 +58,15 @@ struct sgx_enclave_init {
 	__u64	sigstruct;
 };
 
+/**
+ * struct sgx_enclave_set_attribute - parameter structure for the
+ *				      %SGX_IOC_ENCLAVE_INIT ioctl
+ * @addr:		address within the ELRANGE
+ * @attribute_fd:	file handle of the attribute file in the securityfs
+ */
+struct sgx_enclave_set_attribute {
+	__u64	addr;
+	__u64	attribute_fd;
+};
+
 #endif /* _UAPI_ASM_X86_SGX_H */
diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
index 4b9a91b53b50..5d85bd3f7876 100644
--- a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
@@ -759,6 +759,46 @@ static long sgx_ioc_enclave_init(struct file *filep, unsigned int cmd,
 	return ret;
 }
 
+/**
+ * sgx_ioc_enclave_set_attribute - handler for %SGX_IOC_ENCLAVE_SET_ATTRIBUTE
+ * @filep:	open file to /dev/sgx
+ * @cmd:	the command value
+ * @arg:	pointer to a struct sgx_enclave_set_attribute instance
+ *
+ * Sets an attribute matching the attribute file that is pointed by the
+ * parameter structure field attribute_fd.
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
+	if (attribute_file->f_op != &sgx_fs_provision_fops) {
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
 
@@ -778,6 +818,9 @@ long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
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
index 16f36cd0af04..9a5360dcad98 100644
--- a/arch/x86/kernel/cpu/sgx/driver/main.c
+++ b/arch/x86/kernel/cpu/sgx/driver/main.c
@@ -22,6 +22,11 @@ u64 sgx_attributes_reserved_mask;
 u64 sgx_xfrm_reserved_mask = ~0x3;
 u32 sgx_xsave_size_tbl[64];
 
+const struct file_operations sgx_fs_provision_fops;
+
+static struct dentry *sgx_fs;
+static struct dentry *sgx_fs_provision;
+
 #ifdef CONFIG_COMPAT
 static long sgx_compat_ioctl(struct file *filep, unsigned int cmd,
 			      unsigned long arg)
@@ -147,6 +152,40 @@ static struct sgx_dev_ctx *sgxm_dev_ctx_alloc(struct device *parent)
 	return ctx;
 }
 
+static int sgx_fs_init(struct device *dev)
+{
+	int ret;
+
+	sgx_fs = securityfs_create_dir(dev_name(dev), NULL);
+	if (IS_ERR(sgx_fs)) {
+		ret = PTR_ERR(sgx_fs);
+		goto err_sgx_fs;
+	}
+
+	sgx_fs_provision = securityfs_create_file("provision", 0600, sgx_fs,
+						  NULL, &sgx_fs_provision_fops);
+	if (IS_ERR(sgx_fs)) {
+		ret = PTR_ERR(sgx_fs_provision);
+		goto err_sgx_fs_provision;
+	}
+
+	return 0;
+
+err_sgx_fs_provision:
+	securityfs_remove(sgx_fs);
+	sgx_fs_provision = NULL;
+
+err_sgx_fs:
+	sgx_fs = NULL;
+	return ret;
+}
+
+static void sgx_fs_remove(void)
+{
+	securityfs_remove(sgx_fs_provision);
+	securityfs_remove(sgx_fs);
+}
+
 static int sgx_dev_init(struct device *parent)
 {
 	struct sgx_dev_ctx *sgx_dev;
@@ -190,6 +229,10 @@ static int sgx_dev_init(struct device *parent)
 	if (!sgx_encl_wq)
 		return -ENOMEM;
 
+	ret = sgx_fs_init(&sgx_dev->ctrl_dev);
+	if (ret)
+		goto err_fs_init;
+
 	ret = cdev_device_add(&sgx_dev->ctrl_cdev, &sgx_dev->ctrl_dev);
 	if (ret)
 		goto err_device_add;
@@ -197,6 +240,9 @@ static int sgx_dev_init(struct device *parent)
 	return 0;
 
 err_device_add:
+	sgx_fs_remove();
+
+err_fs_init:
 	destroy_workqueue(sgx_encl_wq);
 	return ret;
 }
@@ -220,6 +266,7 @@ static int sgx_drv_remove(struct platform_device *pdev)
 {
 	struct sgx_dev_ctx *ctx = dev_get_drvdata(&pdev->dev);
 
+	sgx_fs_remove();
 	cdev_device_del(&ctx->ctrl_cdev, &ctx->ctrl_dev);
 	destroy_workqueue(sgx_encl_wq);
 
-- 
2.19.1

