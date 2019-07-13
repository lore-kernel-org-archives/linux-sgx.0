Return-Path: <SRS0=72mU=VK=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB669C71142
	for <linux-sgx@archiver.kernel.org>; Sat, 13 Jul 2019 17:11:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C13EE20850
	for <linux-sgx@archiver.kernel.org>; Sat, 13 Jul 2019 17:11:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728086AbfGMRLi (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 13 Jul 2019 13:11:38 -0400
Received: from mga17.intel.com ([192.55.52.151]:28671 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727919AbfGMRLi (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 13 Jul 2019 13:11:38 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Jul 2019 10:11:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,487,1557212400"; 
   d="scan'208";a="341981461"
Received: from hbriegel-mobl.ger.corp.intel.com (HELO localhost) ([10.252.50.48])
  by orsmga005.jf.intel.com with ESMTP; 13 Jul 2019 10:11:18 -0700
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
        cedric.xing@intel.com,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        linux-security-module@vger.kernel.org
Subject: [PATCH v21 17/28] x86/sgx: Add provisioning
Date:   Sat, 13 Jul 2019 20:07:53 +0300
Message-Id: <20190713170804.2340-18-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190713170804.2340-1-jarkko.sakkinen@linux.intel.com>
References: <20190713170804.2340-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=a
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
 arch/x86/kernel/cpu/sgx/driver/ioctl.c  | 45 +++++++++++++++++++++++++
 arch/x86/kernel/cpu/sgx/driver/main.c   | 23 ++++++++++++-
 4 files changed, 79 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
index 37d6770a654b..f17d37ca3496 100644
--- a/arch/x86/include/uapi/asm/sgx.h
+++ b/arch/x86/include/uapi/asm/sgx.h
@@ -16,6 +16,8 @@
 	_IOW(SGX_MAGIC, 0x01, struct sgx_enclave_add_page)
 #define SGX_IOC_ENCLAVE_INIT \
 	_IOW(SGX_MAGIC, 0x02, struct sgx_enclave_init)
+#define SGX_IOC_ENCLAVE_SET_ATTRIBUTE \
+	_IOW(SGX_MAGIC, 0x03, struct sgx_enclave_set_attribute)
 
 /**
  * struct sgx_enclave_create - parameter structure for the
@@ -52,4 +54,13 @@ struct sgx_enclave_init {
 	__u64 sigstruct;
 };
 
+/**
+ * struct sgx_enclave_set_attribute - parameter structure for the
+ *				      %SGX_IOC_ENCLAVE_SET_ATTRIBUTE ioctl
+ * @attribute_fd:	file handle of the attribute file in the securityfs
+ */
+struct sgx_enclave_set_attribute {
+	__u64 attribute_fd;
+};
+
 #endif /* _UAPI_ASM_X86_SGX_H */
diff --git a/arch/x86/kernel/cpu/sgx/driver/driver.h b/arch/x86/kernel/cpu/sgx/driver/driver.h
index 52f41426434b..da60839b133a 100644
--- a/arch/x86/kernel/cpu/sgx/driver/driver.h
+++ b/arch/x86/kernel/cpu/sgx/driver/driver.h
@@ -28,7 +28,7 @@ extern u64 sgx_attributes_reserved_mask;
 extern u64 sgx_xfrm_reserved_mask;
 extern u32 sgx_xsave_size_tbl[64];
 
-extern const struct file_operations sgx_fs_provision_fops;
+extern const struct file_operations sgx_provision_fops;
 
 long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg);
 
diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
index 1cbebcd3f397..958c1dbc02e7 100644
--- a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
@@ -718,6 +718,49 @@ static long sgx_ioc_enclave_init(struct file *filep, void __user *arg)
 	return ret;
 }
 
+/**
+ * sgx_ioc_enclave_set_attribute - handler for %SGX_IOC_ENCLAVE_SET_ATTRIBUTE
+ * @filep:	open file to /dev/sgx
+ * @arg:	userspace pointer to a struct sgx_enclave_set_attribute instance
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
+static long sgx_ioc_enclave_set_attribute(struct file *filep, void __user *arg)
+{
+	struct sgx_encl *encl = filep->private_data;
+	struct sgx_enclave_set_attribute params;
+	struct file *attribute_file;
+	int ret;
+
+	if (copy_from_user(&params, arg, sizeof(params)))
+		return -EFAULT;
+
+	attribute_file = fget(params.attribute_fd);
+	if (!attribute_file->f_op)
+		return -EINVAL;
+
+	if (attribute_file->f_op != &sgx_provision_fops) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	encl->allowed_attributes |= SGX_ATTR_PROVISIONKEY;
+
+out:
+	fput(attribute_file);
+	return ret;
+}
 
 long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 {
@@ -728,6 +771,8 @@ long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 		return sgx_ioc_enclave_add_page(filep, (void __user *)arg);
 	case SGX_IOC_ENCLAVE_INIT:
 		return sgx_ioc_enclave_init(filep, (void __user *)arg);
+	case SGX_IOC_ENCLAVE_SET_ATTRIBUTE:
+		return sgx_ioc_enclave_set_attribute(filep, (void __user *)arg);
 	default:
 		return -ENOIOCTLCMD;
 	}
diff --git a/arch/x86/kernel/cpu/sgx/driver/main.c b/arch/x86/kernel/cpu/sgx/driver/main.c
index 1ccc160020d1..5defd1ed3de5 100644
--- a/arch/x86/kernel/cpu/sgx/driver/main.c
+++ b/arch/x86/kernel/cpu/sgx/driver/main.c
@@ -153,12 +153,18 @@ static const struct file_operations sgx_encl_fops = {
 	.get_unmapped_area	= sgx_get_unmapped_area,
 };
 
+const struct file_operations sgx_provision_fops = {
+	.owner			= THIS_MODULE,
+};
+
 static struct bus_type sgx_bus_type = {
 	.name	= "sgx",
 };
 
 static struct device sgx_encl_dev;
 static struct cdev sgx_encl_cdev;
+static struct device sgx_provision_dev;
+static struct cdev sgx_provision_cdev;
 static dev_t sgx_devt;
 
 static void sgx_dev_release(struct device *dev)
@@ -235,22 +241,37 @@ int __init sgx_drv_init(void)
 	if (ret)
 		goto err_chrdev_region;
 
+	ret = sgx_dev_init("sgx/provision", &sgx_provision_dev,
+			   &sgx_provision_cdev, &sgx_provision_fops, 1);
+	if (ret)
+		goto err_encl_dev;
+
 	sgx_encl_wq = alloc_workqueue("sgx-encl-wq",
 				      WQ_UNBOUND | WQ_FREEZABLE, 1);
 	if (!sgx_encl_wq) {
 		ret = -ENOMEM;
-		goto err_encl_dev;
+		goto err_provision_dev;
 	}
 
 	ret = cdev_device_add(&sgx_encl_cdev, &sgx_encl_dev);
 	if (ret)
 		goto err_encl_wq;
 
+	ret = cdev_device_add(&sgx_provision_cdev, &sgx_provision_dev);
+	if (ret)
+		goto err_encl_cdev;
+
 	return 0;
 
+err_encl_cdev:
+	cdev_device_del(&sgx_encl_cdev, &sgx_encl_dev);
+
 err_encl_wq:
 	destroy_workqueue(sgx_encl_wq);
 
+err_provision_dev:
+	put_device(&sgx_provision_dev);
+
 err_encl_dev:
 	put_device(&sgx_encl_dev);
 
-- 
2.20.1

