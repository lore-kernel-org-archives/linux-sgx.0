Return-Path: <SRS0=Vmdy=O6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 233CBC43387
	for <linux-sgx@archiver.kernel.org>; Fri, 21 Dec 2018 23:15:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E49CA2190A
	for <linux-sgx@archiver.kernel.org>; Fri, 21 Dec 2018 23:15:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403909AbeLUXPD (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 21 Dec 2018 18:15:03 -0500
Received: from mga09.intel.com ([134.134.136.24]:16862 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730803AbeLUXPD (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 21 Dec 2018 18:15:03 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Dec 2018 15:15:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,383,1539673200"; 
   d="scan'208";a="120338605"
Received: from ncanderx-mobl.ger.corp.intel.com (HELO localhost) ([10.249.254.238])
  by FMSMGA003.fm.intel.com with ESMTP; 21 Dec 2018 15:14:53 -0800
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     x86@kernel.org, linux-sgx@vger.kernel.org
Cc:     akpm@linux-foundation.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        linux-security-module@vger.kernel.org
Subject: [PATCH v18 19/25] x86/sgx: Add provisioning
Date:   Sat, 22 Dec 2018 01:11:48 +0200
Message-Id: <20181221231154.6120-20-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20181221231154.6120-1-jarkko.sakkinen@linux.intel.com>
References: <20181221231154.6120-1-jarkko.sakkinen@linux.intel.com>
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
 arch/x86/include/uapi/asm/sgx.h         | 13 +++++++
 arch/x86/kernel/cpu/sgx/driver/Makefile |  2 +-
 arch/x86/kernel/cpu/sgx/driver/driver.h |  5 +++
 arch/x86/kernel/cpu/sgx/driver/fs.c     | 49 +++++++++++++++++++++++++
 arch/x86/kernel/cpu/sgx/driver/ioctl.c  | 43 ++++++++++++++++++++++
 arch/x86/kernel/cpu/sgx/driver/main.c   |  7 ++++
 6 files changed, 118 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86/kernel/cpu/sgx/driver/fs.c

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
diff --git a/arch/x86/kernel/cpu/sgx/driver/Makefile b/arch/x86/kernel/cpu/sgx/driver/Makefile
index 2bd952cc8a65..0325de93d605 100644
--- a/arch/x86/kernel/cpu/sgx/driver/Makefile
+++ b/arch/x86/kernel/cpu/sgx/driver/Makefile
@@ -1,2 +1,2 @@
 obj-$(CONFIG_INTEL_SGX) += sgx.o
-sgx-$(CONFIG_INTEL_SGX) += encl.o ioctl.o main.o pte.o vma.o
+sgx-$(CONFIG_INTEL_SGX) += encl.o fs.o ioctl.o main.o pte.o vma.o
diff --git a/arch/x86/kernel/cpu/sgx/driver/driver.h b/arch/x86/kernel/cpu/sgx/driver/driver.h
index c9e40e090c58..e3487a077b6c 100644
--- a/arch/x86/kernel/cpu/sgx/driver/driver.h
+++ b/arch/x86/kernel/cpu/sgx/driver/driver.h
@@ -167,4 +167,9 @@ struct sgx_encl_page *sgx_fault_page(struct vm_area_struct *vma,
 int sgx_test_and_clear_young(struct sgx_encl_page *page);
 void sgx_flush_cpus(struct sgx_encl *encl);
 
+extern const struct file_operations sgx_fs_provision_fops;
+
+int sgx_fs_init(struct device *dev);
+void sgx_fs_remove(void);
+
 #endif /* __ARCH_X86_INTEL_SGX_H__ */
diff --git a/arch/x86/kernel/cpu/sgx/driver/fs.c b/arch/x86/kernel/cpu/sgx/driver/fs.c
new file mode 100644
index 000000000000..b36b62a9cafb
--- /dev/null
+++ b/arch/x86/kernel/cpu/sgx/driver/fs.c
@@ -0,0 +1,49 @@
+// SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
+// Copyright(c) 2016-18 Intel Corporation.
+
+#include <linux/acpi.h>
+#include <linux/cdev.h>
+#include <linux/platform_device.h>
+#include <linux/security.h>
+#include <linux/suspend.h>
+#include <asm/traps.h>
+#include "driver.h"
+
+const struct file_operations sgx_fs_provision_fops;
+
+static struct dentry *sgx_fs;
+static struct dentry *sgx_fs_provision;
+
+int sgx_fs_init(struct device *dev)
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
+void sgx_fs_remove(void)
+{
+	securityfs_remove(sgx_fs_provision);
+	securityfs_remove(sgx_fs);
+}
diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
index 3a712950e116..d249a4329116 100644
--- a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
@@ -193,6 +193,46 @@ static long sgx_ioc_enclave_init(struct file *filep, unsigned int cmd,
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
+	encl->attributes |= SGX_ATTR_PROVISIONKEY;
+	kref_put(&encl->refcount, sgx_encl_release);
+
+out:
+	fput(attribute_file);
+	return ret;
+}
+
 typedef long (*sgx_ioc_t)(struct file *filep, unsigned int cmd,
 			  unsigned long arg);
 
@@ -212,6 +252,9 @@ long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
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
index 19280863d703..ba125365a0d3 100644
--- a/arch/x86/kernel/cpu/sgx/driver/main.c
+++ b/arch/x86/kernel/cpu/sgx/driver/main.c
@@ -172,6 +172,10 @@ static int sgx_drv_init(struct device *parent)
 	if (!sgx_encl_wq)
 		return -ENOMEM;
 
+	ret = sgx_fs_init(&sgx_dev->ctrl_dev);
+	if (ret)
+		goto err_fs_init;
+
 	ret = cdev_device_add(&sgx_dev->ctrl_cdev, &sgx_dev->ctrl_dev);
 	if (ret)
 		goto err_device_add;
@@ -179,6 +183,9 @@ static int sgx_drv_init(struct device *parent)
 	return 0;
 
 err_device_add:
+	sgx_fs_remove();
+
+err_fs_init:
 	destroy_workqueue(sgx_encl_wq);
 	return ret;
 }
-- 
2.19.1

