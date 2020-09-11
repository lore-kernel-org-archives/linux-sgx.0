Return-Path: <SRS0=Q2gl=CU=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05F81C43461
	for <linux-sgx@archiver.kernel.org>; Fri, 11 Sep 2020 17:40:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D16F5221E7
	for <linux-sgx@archiver.kernel.org>; Fri, 11 Sep 2020 17:40:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbgIKRiM (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 11 Sep 2020 13:38:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:10795 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726005AbgIKMpx (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 11 Sep 2020 08:45:53 -0400
IronPort-SDR: f7aDAEkXv8ITObS+GbUXMqFGSFY+WHLjSNMKCNYu4UHaPEte3tIrVH4nphp0sItd7sY0/DXq24
 zgI40A5nkEvg==
X-IronPort-AV: E=McAfee;i="6000,8403,9740"; a="159683689"
X-IronPort-AV: E=Sophos;i="5.76,415,1592895600"; 
   d="scan'208";a="159683689"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2020 05:44:31 -0700
IronPort-SDR: Z86uuDqjEUVQTDrqxosXUyZKWVIfbIg0jOX8EIdahMt3MF/IPq8bLe5rH1n56CeUiakdAMRbMH
 3MO0CQrt9qKQ==
X-IronPort-AV: E=Sophos;i="5.76,415,1592895600"; 
   d="scan'208";a="505490493"
Received: from amaksymi-mobl.ger.corp.intel.com (HELO localhost) ([10.252.60.247])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2020 05:44:18 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     x86@kernel.org, linux-sgx@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-security-module@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Andy Lutomirski <luto@kernel.org>, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, nhorman@redhat.com,
        npmccallum@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        sean.j.christopherson@intel.com, tglx@linutronix.de,
        yaozhangx@google.com
Subject: [PATCH v37 15/24] x86/sgx: Enable provisioning for remote attestation
Date:   Fri, 11 Sep 2020 15:40:10 +0300
Message-Id: <20200911124019.42178-16-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200911124019.42178-1-jarkko.sakkinen@linux.intel.com>
References: <20200911124019.42178-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Provisioning Certification Enclave (PCE), the root of trust for other
enclaves, generates a signing key from a fused key called Provisioning
Certification Key. PCE can then use this key to certify an attestation key
of a Quoting Enclave (QE), e.g. we get the chain of trust down to the
hardware if the Intel signed PCE is used.

To use the needed keys, ATTRIBUTE.PROVISIONKEY is required but should be
only allowed for those who actually need it so that only the trusted
parties can certify QE's.

Obviously the attestation service should know the public key of the used
PCE and that way detect illegit attestation, but whitelisting the legit
users still adds an additional layer of defence.

Add new device file called /dev/sgx/provision. The sole purpose of this
file is to provide file descriptors that act as privilege tokens to allow
to build enclaves with ATTRIBUTE.PROVISIONKEY set. A new ioctl called
SGX_IOC_ENCLAVE_PROVISION is used to assign this token to an enclave.

Cc: linux-security-module@vger.kernel.org
Acked-by: Jethro Beekman <jethro@fortanix.com>
Reviewed-by: Darren Kenny <darren.kenny@oracle.com>
Suggested-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/include/uapi/asm/sgx.h  | 11 ++++++++
 arch/x86/kernel/cpu/sgx/driver.c | 18 ++++++++++++
 arch/x86/kernel/cpu/sgx/driver.h |  2 ++
 arch/x86/kernel/cpu/sgx/ioctl.c  | 47 ++++++++++++++++++++++++++++++++
 4 files changed, 78 insertions(+)

diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
index 7729730d8580..d0916fb9629e 100644
--- a/arch/x86/include/uapi/asm/sgx.h
+++ b/arch/x86/include/uapi/asm/sgx.h
@@ -25,6 +25,8 @@ enum sgx_page_flags {
 	_IOWR(SGX_MAGIC, 0x01, struct sgx_enclave_add_pages)
 #define SGX_IOC_ENCLAVE_INIT \
 	_IOW(SGX_MAGIC, 0x02, struct sgx_enclave_init)
+#define SGX_IOC_ENCLAVE_PROVISION \
+	_IOW(SGX_MAGIC, 0x03, struct sgx_enclave_provision)
 
 /**
  * struct sgx_enclave_create - parameter structure for the
@@ -61,4 +63,13 @@ struct sgx_enclave_init {
 	__u64 sigstruct;
 };
 
+/**
+ * struct sgx_enclave_provision - parameter structure for the
+ *				  %SGX_IOC_ENCLAVE_PROVISION ioctl
+ * @attribute_fd:	file handle of the attribute file in the securityfs
+ */
+struct sgx_enclave_provision {
+	__u64 attribute_fd;
+};
+
 #endif /* _UAPI_ASM_X86_SGX_H */
diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx/driver.c
index 7bdb49dfcca6..d01b28f7ce4a 100644
--- a/arch/x86/kernel/cpu/sgx/driver.c
+++ b/arch/x86/kernel/cpu/sgx/driver.c
@@ -134,6 +134,10 @@ static const struct file_operations sgx_encl_fops = {
 	.get_unmapped_area	= sgx_get_unmapped_area,
 };
 
+const struct file_operations sgx_provision_fops = {
+	.owner			= THIS_MODULE,
+};
+
 static struct miscdevice sgx_dev_enclave = {
 	.minor = MISC_DYNAMIC_MINOR,
 	.name = "enclave",
@@ -141,6 +145,13 @@ static struct miscdevice sgx_dev_enclave = {
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
@@ -181,5 +192,12 @@ int __init sgx_drv_init(void)
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
index 51d9b24379ff..7e74efdde780 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -668,6 +668,50 @@ static long sgx_ioc_enclave_init(struct sgx_encl *encl, void __user *arg)
 	return ret;
 }
 
+/**
+ * sgx_ioc_enclave_set_attribute - handler for %SGX_IOC_ENCLAVE_PROVISION
+ * @filep:	open file to /dev/sgx
+ * @arg:	userspace pointer to a struct sgx_enclave_provision instance
+ *
+ * Mark the enclave as being allowed to access a restricted attribute bit.
+ * The requested attribute is specified via the attribute_fd field in the
+ * provided struct sgx_enclave_provision.  The attribute_fd must be a
+ * handle to an SGX attribute file, e.g. "/dev/sgx/provision".
+ *
+ * Failure to explicitly request access to a restricted attribute will cause
+ * sgx_ioc_enclave_init() to fail.  Currently, the only restricted attribute
+ * is access to the PROVISION_KEY.
+ *
+ * Note, access to the EINITTOKEN_KEY is disallowed entirely.
+ *
+ * Return: 0 on success, -errno otherwise
+ */
+static long sgx_ioc_enclave_provision(struct sgx_encl *encl,
+					  void __user *arg)
+{
+	struct sgx_enclave_provision params;
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
+	encl->attributes |= SGX_ATTR_PROVISIONKEY;
+	ret = 0;
+
+out:
+	fput(attribute_file);
+	return ret;
+}
 
 long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 {
@@ -693,6 +737,9 @@ long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 	case SGX_IOC_ENCLAVE_INIT:
 		ret = sgx_ioc_enclave_init(encl, (void __user *)arg);
 		break;
+	case SGX_IOC_ENCLAVE_PROVISION:
+		ret = sgx_ioc_enclave_provision(encl, (void __user *)arg);
+		break;
 	default:
 		ret = -ENOIOCTLCMD;
 		break;
-- 
2.25.1

