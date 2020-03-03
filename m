Return-Path: <SRS0=VHel=4U=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D30EC3F2C6
	for <linux-sgx@archiver.kernel.org>; Tue,  3 Mar 2020 23:39:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5954B2072D
	for <linux-sgx@archiver.kernel.org>; Tue,  3 Mar 2020 23:39:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728521AbgCCXjT (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 3 Mar 2020 18:39:19 -0500
Received: from mga09.intel.com ([134.134.136.24]:14498 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728317AbgCCXjT (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 3 Mar 2020 18:39:19 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Mar 2020 15:39:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,511,1574150400"; 
   d="scan'208";a="229117880"
Received: from kwasilew-mobl.ger.corp.intel.com (HELO localhost) ([10.251.88.57])
  by orsmga007.jf.intel.com with ESMTP; 03 Mar 2020 15:39:08 -0800
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     akpm@linux-foundation.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, puiterwijk@redhat.com,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-security-module@vger.kernel.org
Subject: [PATCH v28 15/22] x86/sgx: Add provisioning
Date:   Wed,  4 Mar 2020 01:36:02 +0200
Message-Id: <20200303233609.713348-16-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200303233609.713348-1-jarkko.sakkinen@linux.intel.com>
References: <20200303233609.713348-1-jarkko.sakkinen@linux.intel.com>
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

Cc: linux-security-module@vger.kernel.org
Suggested-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/include/uapi/asm/sgx.h  | 11 ++++++++
 arch/x86/kernel/cpu/sgx/driver.c | 14 ++++++++++
 arch/x86/kernel/cpu/sgx/driver.h |  2 ++
 arch/x86/kernel/cpu/sgx/ioctl.c  | 47 ++++++++++++++++++++++++++++++++
 4 files changed, 74 insertions(+)

diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
index 5edb08ab8fd0..57d0d30c79b3 100644
--- a/arch/x86/include/uapi/asm/sgx.h
+++ b/arch/x86/include/uapi/asm/sgx.h
@@ -25,6 +25,8 @@ enum sgx_page_flags {
 	_IOWR(SGX_MAGIC, 0x01, struct sgx_enclave_add_pages)
 #define SGX_IOC_ENCLAVE_INIT \
 	_IOW(SGX_MAGIC, 0x02, struct sgx_enclave_init)
+#define SGX_IOC_ENCLAVE_SET_ATTRIBUTE \
+	_IOW(SGX_MAGIC, 0x03, struct sgx_enclave_set_attribute)
 
 /**
  * struct sgx_enclave_create - parameter structure for the
@@ -63,4 +65,13 @@ struct sgx_enclave_init {
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
index b4aa7b9f8376..d90114cec1c3 100644
--- a/arch/x86/kernel/cpu/sgx/driver.c
+++ b/arch/x86/kernel/cpu/sgx/driver.c
@@ -150,6 +150,13 @@ static struct miscdevice sgx_dev_enclave = {
 	.fops = &sgx_encl_fops,
 };
 
+static struct miscdevice sgx_dev_provision = {
+	.minor = MISC_DYNAMIC_MINOR,
+	.name = "provision",
+	.nodename = "sgx/provision",
+	.fops = &sgx_provision_fops,
+};
+
 int __init sgx_drv_init(void)
 {
 	unsigned int eax, ebx, ecx, edx;
@@ -190,5 +197,12 @@ int __init sgx_drv_init(void)
 		return ret;
 	}
 
+	ret = misc_register(&sgx_dev_provision);
+	if (ret) {
+		pr_err("Creating /dev/sgx/provision failed with %d.\n", ret);
+		misc_deregister(&sgx_dev_enclave);
+		return ret;
+	}
+
 	return 0;
 }
diff --git a/arch/x86/kernel/cpu/sgx/driver.h b/arch/x86/kernel/cpu/sgx/driver.h
index e4063923115b..72747d01c046 100644
--- a/arch/x86/kernel/cpu/sgx/driver.h
+++ b/arch/x86/kernel/cpu/sgx/driver.h
@@ -23,6 +23,8 @@ extern u64 sgx_attributes_reserved_mask;
 extern u64 sgx_xfrm_reserved_mask;
 extern u32 sgx_xsave_size_tbl[64];
 
+extern const struct file_operations sgx_provision_fops;
+
 long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg);
 
 int sgx_drv_init(void);
diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 27de304efe39..251b7a989606 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -658,6 +658,50 @@ static long sgx_ioc_enclave_init(struct sgx_encl *encl, void __user *arg)
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
@@ -681,6 +725,9 @@ long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
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
2.25.0

