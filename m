Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96AD8C5519F
	for <linux-sgx@archiver.kernel.org>; Thu, 12 Nov 2020 22:03:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B5162223F
	for <linux-sgx@archiver.kernel.org>; Thu, 12 Nov 2020 22:03:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="CN6HEsLT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727388AbgKLWDS (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 12 Nov 2020 17:03:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:51664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727714AbgKLWDS (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 12 Nov 2020 17:03:18 -0500
Received: from suppilovahvero.lan (83-245-197-237.elisa-laajakaista.fi [83.245.197.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E667A22241;
        Thu, 12 Nov 2020 22:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605218596;
        bh=Vqp4o3mMef6/0mJsmtNbNzy2NYxwOAFZioTao2+0a+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CN6HEsLTnkIIcjvtx2DBNVe8Of08MolHHQrN5ngI3gFNyL/og6jjxLhedFuOYIAga
         UPGRENMYNaeDxmM0sBT8xL4Ww2VxXppJ7Kt0cxVCagJO00+BgxBer5TC2jphAZMQYu
         5flxWJCItjiHthU1brDM7G9IkF1WxKixqYk8Y2RQ=
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     x86@kernel.org, linux-sgx@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, bp@alien8.de, cedric.xing@intel.com,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, dave.hansen@intel.com, haitao.huang@intel.com,
        kai.huang@intel.com, kai.svahn@intel.com, kmoy@google.com,
        ludloff@google.com, luto@kernel.org, nhorman@redhat.com,
        npmccallum@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        sean.j.christopherson@intel.com, tglx@linutronix.de,
        yaozhangx@google.com, mikko.ylinen@intel.com
Subject: [PATCH v41 14/24] x86/sgx: Add SGX_IOC_ENCLAVE_INIT
Date:   Fri, 13 Nov 2020 00:01:25 +0200
Message-Id: <20201112220135.165028-15-jarkko@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201112220135.165028-1-jarkko@kernel.org>
References: <20201112220135.165028-1-jarkko@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Enclaves have two basic states.  They are either being built and are
malleable and can be modified by doing things like adding pages.  Or, they
are locked down and not accepting changes.  They can only be run after they
have been locked down.  The ENCLS[EINIT] function induces the transition
from being malleable to locked-down.

Add an ioctl() that performs ENCLS[EINIT].  After this, new pages can no
longer be added with ENCLS[EADD].  This is also the time where the enclave
can be measured to verify its integrity.

Tested-by: Jethro Beekman <jethro@fortanix.com> # v40
# Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
# Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
---
Changes from v39:
* Declare 'k' for the MSR updating loop. It was incorrectly using 'i'.
* Return -EIO instead of -EFAULT on EINIT failure, just like happens
  when EADD or EEXTEND fails.
* When EINIT fails, just return -EIO.  Leave the enclave cleanup as the
  duty of VFS and the page reclaimer.

 arch/x86/include/uapi/asm/sgx.h  |  11 ++
 arch/x86/kernel/cpu/sgx/driver.c |  27 +++++
 arch/x86/kernel/cpu/sgx/driver.h |   8 ++
 arch/x86/kernel/cpu/sgx/encl.h   |   3 +
 arch/x86/kernel/cpu/sgx/ioctl.c  | 193 ++++++++++++++++++++++++++++++-
 5 files changed, 241 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
index 835f7e588f0d..66f2d32cb4d7 100644
--- a/arch/x86/include/uapi/asm/sgx.h
+++ b/arch/x86/include/uapi/asm/sgx.h
@@ -23,6 +23,8 @@ enum sgx_page_flags {
 	_IOW(SGX_MAGIC, 0x00, struct sgx_enclave_create)
 #define SGX_IOC_ENCLAVE_ADD_PAGES \
 	_IOWR(SGX_MAGIC, 0x01, struct sgx_enclave_add_pages)
+#define SGX_IOC_ENCLAVE_INIT \
+	_IOW(SGX_MAGIC, 0x02, struct sgx_enclave_init)
 
 /**
  * struct sgx_enclave_create - parameter structure for the
@@ -52,4 +54,13 @@ struct sgx_enclave_add_pages {
 	__u64 count;
 };
 
+/**
+ * struct sgx_enclave_init - parameter structure for the
+ *                           %SGX_IOC_ENCLAVE_INIT ioctl
+ * @sigstruct:	address for the SIGSTRUCT data
+ */
+struct sgx_enclave_init {
+	__u64 sigstruct;
+};
+
 #endif /* _UAPI_ASM_X86_SGX_H */
diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx/driver.c
index 9878b542c616..ef14abbb67e1 100644
--- a/arch/x86/kernel/cpu/sgx/driver.c
+++ b/arch/x86/kernel/cpu/sgx/driver.c
@@ -10,6 +10,10 @@
 #include "driver.h"
 #include "encl.h"
 
+u64 sgx_attributes_reserved_mask;
+u64 sgx_xfrm_reserved_mask = ~0x3;
+u32 sgx_misc_reserved_mask;
+
 static int sgx_open(struct inode *inode, struct file *file)
 {
 	struct sgx_encl *encl;
@@ -117,8 +121,31 @@ static struct miscdevice sgx_dev_enclave = {
 
 int __init sgx_drv_init(void)
 {
+	unsigned int eax, ebx, ecx, edx;
+	u64 attr_mask;
+	u64 xfrm_mask;
+
 	if (!cpu_feature_enabled(X86_FEATURE_SGX_LC))
 		return -ENODEV;
 
+	cpuid_count(SGX_CPUID, 0, &eax, &ebx, &ecx, &edx);
+
+	if (!(eax & 1))  {
+		pr_err("SGX disabled: SGX1 instruction support not available.\n");
+		return -ENODEV;
+	}
+
+	sgx_misc_reserved_mask = ~ebx | SGX_MISC_RESERVED_MASK;
+
+	cpuid_count(SGX_CPUID, 1, &eax, &ebx, &ecx, &edx);
+
+	attr_mask = (((u64)ebx) << 32) + (u64)eax;
+	sgx_attributes_reserved_mask = ~attr_mask | SGX_ATTR_RESERVED_MASK;
+
+	if (cpu_feature_enabled(X86_FEATURE_OSXSAVE)) {
+		xfrm_mask = (((u64)edx) << 32) + (u64)ecx;
+		sgx_xfrm_reserved_mask = ~xfrm_mask;
+	}
+
 	return misc_register(&sgx_dev_enclave);
 }
diff --git a/arch/x86/kernel/cpu/sgx/driver.h b/arch/x86/kernel/cpu/sgx/driver.h
index a728e8e848bd..6b0063221659 100644
--- a/arch/x86/kernel/cpu/sgx/driver.h
+++ b/arch/x86/kernel/cpu/sgx/driver.h
@@ -12,6 +12,14 @@
 #include <uapi/asm/sgx.h>
 #include "sgx.h"
 
+#define SGX_EINIT_SPIN_COUNT	20
+#define SGX_EINIT_SLEEP_COUNT	50
+#define SGX_EINIT_SLEEP_TIME	20
+
+extern u64 sgx_attributes_reserved_mask;
+extern u64 sgx_xfrm_reserved_mask;
+extern u32 sgx_misc_reserved_mask;
+
 long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg);
 
 int sgx_drv_init(void);
diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
index 6ecb03c08edf..34088659cee6 100644
--- a/arch/x86/kernel/cpu/sgx/encl.h
+++ b/arch/x86/kernel/cpu/sgx/encl.h
@@ -30,6 +30,7 @@ enum sgx_encl_flags {
 	SGX_ENCL_IOCTL		= BIT(0),
 	SGX_ENCL_DEBUG		= BIT(1),
 	SGX_ENCL_CREATED	= BIT(2),
+	SGX_ENCL_INITIALIZED	= BIT(3),
 };
 
 struct sgx_encl {
@@ -41,6 +42,8 @@ struct sgx_encl {
 	struct mutex lock;
 	struct xarray page_array;
 	struct sgx_encl_page secs;
+	unsigned long attributes;
+	unsigned long attributes_mask;
 };
 
 extern const struct vm_operations_struct sgx_vm_ops;
diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 82acff7bda60..e036819ea5c1 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -51,6 +51,8 @@ static int sgx_encl_create(struct sgx_encl *encl, struct sgx_secs *secs)
 	encl->secs.encl = encl;
 	encl->base = secs->base;
 	encl->size = secs->size;
+	encl->attributes = secs->attributes;
+	encl->attributes_mask = SGX_ATTR_DEBUG | SGX_ATTR_MODE64BIT | SGX_ATTR_KSS;
 
 	/* Set only after completion, as encl->lock has not been taken. */
 	set_bit(SGX_ENCL_CREATED, &encl->flags);
@@ -334,7 +336,8 @@ static long sgx_ioc_enclave_add_pages(struct sgx_encl *encl, void __user *arg)
 	unsigned long c;
 	int ret;
 
-	if (!test_bit(SGX_ENCL_CREATED, &encl->flags))
+	if (!test_bit(SGX_ENCL_CREATED, &encl->flags) ||
+	    test_bit(SGX_ENCL_INITIALIZED, &encl->flags))
 		return -EINVAL;
 
 	if (copy_from_user(&add_arg, arg, sizeof(add_arg)))
@@ -382,6 +385,191 @@ static long sgx_ioc_enclave_add_pages(struct sgx_encl *encl, void __user *arg)
 	return ret;
 }
 
+static int __sgx_get_key_hash(struct crypto_shash *tfm, const void *modulus,
+			      void *hash)
+{
+	SHASH_DESC_ON_STACK(shash, tfm);
+
+	shash->tfm = tfm;
+
+	return crypto_shash_digest(shash, modulus, SGX_MODULUS_SIZE, hash);
+}
+
+static int sgx_get_key_hash(const void *modulus, void *hash)
+{
+	struct crypto_shash *tfm;
+	int ret;
+
+	tfm = crypto_alloc_shash("sha256", 0, CRYPTO_ALG_ASYNC);
+	if (IS_ERR(tfm))
+		return PTR_ERR(tfm);
+
+	ret = __sgx_get_key_hash(tfm, modulus, hash);
+
+	crypto_free_shash(tfm);
+	return ret;
+}
+
+static int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct *sigstruct,
+			 void *token)
+{
+	u64 mrsigner[4];
+	int i, j, k;
+	void *addr;
+	int ret;
+
+	/*
+	 * Deny initializing enclaves with attributes (namely provisioning)
+	 * that have not been explicitly allowed.
+	 */
+	if (encl->attributes & ~encl->attributes_mask)
+		return -EACCES;
+
+	/*
+	 * Attributes should not be enforced *only* against what's available on
+	 * platform (done in sgx_encl_create) but checked and enforced against
+	 * the mask for enforcement in sigstruct. For example an enclave could
+	 * opt to sign with AVX bit in xfrm, but still be loadable on a platform
+	 * without it if the sigstruct->body.attributes_mask does not turn that
+	 * bit on.
+	 */
+	if (sigstruct->body.attributes & sigstruct->body.attributes_mask &
+	    sgx_attributes_reserved_mask)
+		return -EINVAL;
+
+	if (sigstruct->body.miscselect & sigstruct->body.misc_mask &
+	    sgx_misc_reserved_mask)
+		return -EINVAL;
+
+	if (sigstruct->body.xfrm & sigstruct->body.xfrm_mask &
+	    sgx_xfrm_reserved_mask)
+		return -EINVAL;
+
+	ret = sgx_get_key_hash(sigstruct->modulus, mrsigner);
+	if (ret)
+		return ret;
+
+	mutex_lock(&encl->lock);
+
+	/*
+	 * ENCLS[EINIT] is interruptible because it has such a high latency,
+	 * e.g. 50k+ cycles on success. If an IRQ/NMI/SMI becomes pending,
+	 * EINIT may fail with SGX_UNMASKED_EVENT so that the event can be
+	 * serviced.
+	 */
+	for (i = 0; i < SGX_EINIT_SLEEP_COUNT; i++) {
+		for (j = 0; j < SGX_EINIT_SPIN_COUNT; j++) {
+			addr = sgx_get_epc_virt_addr(encl->secs.epc_page);
+
+			preempt_disable();
+
+			for (k = 0; k < 4; k++)
+				wrmsrl(MSR_IA32_SGXLEPUBKEYHASH0 + k, mrsigner[k]);
+
+			ret = __einit(sigstruct, token, addr);
+
+			preempt_enable();
+
+			if (ret == SGX_UNMASKED_EVENT)
+				continue;
+			else
+				break;
+		}
+
+		if (ret != SGX_UNMASKED_EVENT)
+			break;
+
+		msleep_interruptible(SGX_EINIT_SLEEP_TIME);
+
+		if (signal_pending(current)) {
+			ret = -ERESTARTSYS;
+			goto err_out;
+		}
+	}
+
+	if (ret & ENCLS_FAULT_FLAG) {
+		if (encls_failed(ret))
+			ENCLS_WARN(ret, "EINIT");
+
+		ret = -EIO;
+	} else if (ret) {
+		pr_debug("EINIT returned %d\n", ret);
+		ret = -EPERM;
+	} else {
+		set_bit(SGX_ENCL_INITIALIZED, &encl->flags);
+	}
+
+err_out:
+	mutex_unlock(&encl->lock);
+	return ret;
+}
+
+/**
+ * sgx_ioc_enclave_init() - handler for %SGX_IOC_ENCLAVE_INIT
+ * @encl:	an enclave pointer
+ * @arg:	userspace pointer to a struct sgx_enclave_init instance
+ *
+ * Flush any outstanding enqueued EADD operations and perform EINIT.  The
+ * Launch Enclave Public Key Hash MSRs are rewritten as necessary to match
+ * the enclave's MRSIGNER, which is caculated from the provided sigstruct.
+ *
+ * Return:
+ * - 0:		Success.
+ * - -EPERM:	Invalid SIGSTRUCT.
+ * - -EIO:	EINIT failed because of a power cycle.
+ * - -errno:	POSIX error.
+ */
+static long sgx_ioc_enclave_init(struct sgx_encl *encl, void __user *arg)
+{
+	struct sgx_sigstruct *sigstruct;
+	struct sgx_enclave_init init_arg;
+	struct page *initp_page;
+	void *token;
+	int ret;
+
+	if (!test_bit(SGX_ENCL_CREATED, &encl->flags) ||
+	    test_bit(SGX_ENCL_INITIALIZED, &encl->flags))
+		return -EINVAL;
+
+	if (copy_from_user(&init_arg, arg, sizeof(init_arg)))
+		return -EFAULT;
+
+	initp_page = alloc_page(GFP_KERNEL);
+	if (!initp_page)
+		return -ENOMEM;
+
+	sigstruct = kmap(initp_page);
+	token = (void *)((unsigned long)sigstruct + PAGE_SIZE / 2);
+	memset(token, 0, SGX_LAUNCH_TOKEN_SIZE);
+
+	if (copy_from_user(sigstruct, (void __user *)init_arg.sigstruct,
+			   sizeof(*sigstruct))) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	/*
+	 * A legacy field used with Intel signed enclaves. These used to mean
+	 * regular and architectural enclaves. The CPU only accepts these values
+	 * but they do not have any other meaning.
+	 *
+	 * Thus, reject any other values.
+	 */
+	if (sigstruct->header.vendor != 0x0000 &&
+	    sigstruct->header.vendor != 0x8086) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ret = sgx_encl_init(encl, sigstruct, token);
+
+out:
+	kunmap(initp_page);
+	__free_page(initp_page);
+	return ret;
+}
+
+
 long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 {
 	struct sgx_encl *encl = filep->private_data;
@@ -397,6 +585,9 @@ long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 	case SGX_IOC_ENCLAVE_ADD_PAGES:
 		ret = sgx_ioc_enclave_add_pages(encl, (void __user *)arg);
 		break;
+	case SGX_IOC_ENCLAVE_INIT:
+		ret = sgx_ioc_enclave_init(encl, (void __user *)arg);
+		break;
 	default:
 		ret = -ENOIOCTLCMD;
 		break;
-- 
2.27.0

