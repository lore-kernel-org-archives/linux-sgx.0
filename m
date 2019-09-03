Return-Path: <SRS0=NgZr=W6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFA56C3A5A2
	for <linux-sgx@archiver.kernel.org>; Tue,  3 Sep 2019 14:29:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 942E8206B8
	for <linux-sgx@archiver.kernel.org>; Tue,  3 Sep 2019 14:29:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729036AbfICO3C (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 3 Sep 2019 10:29:02 -0400
Received: from mga11.intel.com ([192.55.52.93]:49729 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729079AbfICO3C (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 3 Sep 2019 10:29:02 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Sep 2019 07:29:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,463,1559545200"; 
   d="scan'208";a="189826072"
Received: from vkuppusa-mobl2.ger.corp.intel.com (HELO localhost) ([10.252.39.67])
  by FMSMGA003.fm.intel.com with ESMTP; 03 Sep 2019 07:28:52 -0700
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
Subject: [PATCH v22 13/24] x86/sgx: Add provisioning
Date:   Tue,  3 Sep 2019 17:26:44 +0300
Message-Id: <20190903142655.21943-14-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903142655.21943-1-jarkko.sakkinen@linux.intel.com>
References: <20190903142655.21943-1-jarkko.sakkinen@linux.intel.com>
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
 arch/x86/include/uapi/asm/sgx.h  | 11 +++++++
 arch/x86/kernel/cpu/sgx/driver.c | 23 ++++++++++++++-
 arch/x86/kernel/cpu/sgx/driver.h |  2 +-
 arch/x86/kernel/cpu/sgx/ioctl.c  | 49 +++++++++++++++++++++++++++++++-
 4 files changed, 82 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
index c45eeed68144..420001ac205e 100644
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
diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx/driver.c
index 3eb45bdf9826..f046518cbdf6 100644
--- a/arch/x86/kernel/cpu/sgx/driver.c
+++ b/arch/x86/kernel/cpu/sgx/driver.c
@@ -140,12 +140,18 @@ static const struct file_operations sgx_encl_fops = {
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
@@ -222,22 +228,37 @@ int __init sgx_drv_init(void)
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
 
diff --git a/arch/x86/kernel/cpu/sgx/driver.h b/arch/x86/kernel/cpu/sgx/driver.h
index b045b1fcf258..1e35933cf8a4 100644
--- a/arch/x86/kernel/cpu/sgx/driver.h
+++ b/arch/x86/kernel/cpu/sgx/driver.h
@@ -28,7 +28,7 @@ extern u64 sgx_attributes_reserved_mask;
 extern u64 sgx_xfrm_reserved_mask;
 extern u32 sgx_xsave_size_tbl[64];
 
-extern const struct file_operations sgx_fs_provision_fops;
+extern const struct file_operations sgx_provision_fops;
 
 long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg);
 
diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index b2603db60c43..2fcdd080158e 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -159,7 +159,7 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
 
 	encl->secs.encl = encl;
 	encl->secs_attributes = secs->attributes;
-	encl->allowed_attributes = SGX_ATTR_ALLOWED_MASK;
+	encl->allowed_attributes |= SGX_ATTR_ALLOWED_MASK;
 	encl->base = secs->base;
 	encl->size = secs->size;
 	encl->ssaframesize = secs->ssa_frame_size;
@@ -578,6 +578,50 @@ static long sgx_ioc_enclave_init(struct sgx_encl *encl, void __user *arg)
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
+static long sgx_ioc_enclave_set_attribute(struct sgx_encl *encl,
+					  void __user *arg)
+{
+	struct sgx_enclave_set_attribute params;
+	struct file *attribute_file;
+	int ret;
+
+	if (copy_from_user(&params, arg, sizeof(params)))
+		return -EFAULT;
+
+	attribute_file = fget(params.attribute_fd);
+	if (!attribute_file)
+		return -EINVAL;
+
+	if (attribute_file->f_op != &sgx_provision_fops) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	encl->allowed_attributes |= SGX_ATTR_PROVISIONKEY;
+	ret = 0;
+
+out:
+	fput(attribute_file);
+	return ret;
+}
 
 long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 {
@@ -601,6 +645,9 @@ long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 	case SGX_IOC_ENCLAVE_INIT:
 		ret = sgx_ioc_enclave_init(encl, (void __user *)arg);
 		break;
+	case SGX_IOC_ENCLAVE_SET_ATTRIBUTE:
+		ret = sgx_ioc_enclave_set_attribute(encl, (void __user *)arg);
+		break;
 	default:
 		ret = -ENOIOCTLCMD;
 		break;
-- 
2.20.1

