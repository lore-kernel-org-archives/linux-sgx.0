Return-Path: <SRS0=YHr7=A3=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B437C433E7
	for <linux-sgx@archiver.kernel.org>; Thu, 16 Jul 2020 13:56:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFC04207BC
	for <linux-sgx@archiver.kernel.org>; Thu, 16 Jul 2020 13:56:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728093AbgGPN4v (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 16 Jul 2020 09:56:51 -0400
Received: from mga01.intel.com ([192.55.52.88]:18704 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728087AbgGPN4v (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 16 Jul 2020 09:56:51 -0400
IronPort-SDR: 8OqLJGCdO9aRdPFMBQtQVj/+EbUuF6n5L1WDjIGlzzV8Wlyi5Qjbh0Q1Y5RUEYb1BaHip8JfrO
 iJmF1i3MH2EA==
X-IronPort-AV: E=McAfee;i="6000,8403,9683"; a="167511061"
X-IronPort-AV: E=Sophos;i="5.75,359,1589266800"; 
   d="scan'208";a="167511061"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2020 06:56:51 -0700
IronPort-SDR: A0C22MGicheGfFdx2tqpUBeKZ205x/OZUnjUTHehwHdrh5OerLV2/rF3k6OL63NZbci3roW2Ym
 rfKxCRXkku3g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,359,1589266800"; 
   d="scan'208";a="325150591"
Received: from lettner-mobl.ger.corp.intel.com (HELO localhost) ([10.252.32.212])
  by FMSMGA003.fm.intel.com with ESMTP; 16 Jul 2020 06:56:36 -0700
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     x86@kernel.org, linux-sgx@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Chunyang Hui <sanqian.hcy@antfin.com>,
        Jordan Hand <jorhand@linux.microsoft.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Seth Moore <sethmo@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, bp@alien8.de, cedric.xing@intel.com,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        tglx@linutronix.de, yaozhangx@google.com
Subject: [PATCH v36 14/24] x86/sgx: Add SGX_IOC_ENCLAVE_INIT
Date:   Thu, 16 Jul 2020 16:52:53 +0300
Message-Id: <20200716135303.276442-15-jarkko.sakkinen@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200716135303.276442-1-jarkko.sakkinen@linux.intel.com>
References: <20200716135303.276442-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Add an ioctl that performs ENCLS[EINIT], which locks down the measurement
and initializes the enclave for entrance. After this, new pages can no
longer be added.

Acked-by: Jethro Beekman <jethro@fortanix.com>
Tested-by: Jethro Beekman <jethro@fortanix.com>
Tested-by: Haitao Huang <haitao.huang@linux.intel.com>
Tested-by: Chunyang Hui <sanqian.hcy@antfin.com>
Tested-by: Jordan Hand <jorhand@linux.microsoft.com>
Tested-by: Nathaniel McCallum <npmccallum@redhat.com>
Tested-by: Seth Moore <sethmo@google.com>
Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Co-developed-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 arch/x86/include/uapi/asm/sgx.h |  11 ++
 arch/x86/kernel/cpu/sgx/ioctl.c | 188 ++++++++++++++++++++++++++++++++
 2 files changed, 199 insertions(+)

diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
index c8f199b3fb6f..5edb08ab8fd0 100644
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
 	__u64	count;
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
diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index c63a51362d14..3444de955191 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -16,6 +16,9 @@
 #include "encl.h"
 #include "encls.h"
 
+/* A per-cpu cache for the last known values of IA32_SGXLEPUBKEYHASHx MSRs. */
+static DEFINE_PER_CPU(u64 [4], sgx_lepubkeyhash_cache);
+
 static u32 sgx_calc_ssa_frame_size(u32 miscselect, u64 xfrm)
 {
 	u32 size_max = PAGE_SIZE;
@@ -485,6 +488,188 @@ static long sgx_ioc_enclave_add_pages(struct sgx_encl *encl, void __user *arg)
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
+static void sgx_update_lepubkeyhash_msrs(u64 *lepubkeyhash, bool enforce)
+{
+	u64 *cache;
+	int i;
+
+	cache = per_cpu(sgx_lepubkeyhash_cache, smp_processor_id());
+	for (i = 0; i < 4; i++) {
+		if (enforce || (lepubkeyhash[i] != cache[i])) {
+			wrmsrl(MSR_IA32_SGXLEPUBKEYHASH0 + i, lepubkeyhash[i]);
+			cache[i] = lepubkeyhash[i];
+		}
+	}
+}
+
+static int sgx_einit(struct sgx_sigstruct *sigstruct, void *token,
+		     struct sgx_epc_page *secs, u64 *lepubkeyhash)
+{
+	int ret;
+
+	preempt_disable();
+	sgx_update_lepubkeyhash_msrs(lepubkeyhash, false);
+	ret = __einit(sigstruct, token, sgx_get_epc_addr(secs));
+	if (ret == SGX_INVALID_EINITTOKEN) {
+		sgx_update_lepubkeyhash_msrs(lepubkeyhash, true);
+		ret = __einit(sigstruct, token, sgx_get_epc_addr(secs));
+	}
+	preempt_enable();
+	return ret;
+}
+
+static int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct *sigstruct,
+			 void *token)
+{
+	u64 mrsigner[4];
+	int ret;
+	int i;
+	int j;
+
+	/* Check that the required attributes have been authorized. */
+	if (encl->secs_attributes & ~encl->allowed_attributes)
+		return -EACCES;
+
+	ret = sgx_get_key_hash(sigstruct->modulus, mrsigner);
+	if (ret)
+		return ret;
+
+	mutex_lock(&encl->lock);
+
+	/*
+	 * Periodically, EINIT polls for certain asynchronous events. If such an
+	 * event is detected, it completes with SGX_UNMSKED_EVENT.
+	 */
+	for (i = 0; i < SGX_EINIT_SLEEP_COUNT; i++) {
+		for (j = 0; j < SGX_EINIT_SPIN_COUNT; j++) {
+			ret = sgx_einit(sigstruct, token, encl->secs.epc_page,
+					mrsigner);
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
+		sgx_encl_destroy(encl);
+		ret = -EFAULT;
+	} else if (ret) {
+		pr_debug("EINIT returned %d\n", ret);
+		ret = -EPERM;
+	} else {
+		atomic_or(SGX_ENCL_INITIALIZED, &encl->flags);
+	}
+
+err_out:
+	mutex_unlock(&encl->lock);
+	return ret;
+}
+
+/**
+ * sgx_ioc_enclave_init - handler for %SGX_IOC_ENCLAVE_INIT
+ *
+ * @filep:	open file to /dev/sgx
+ * @arg:	userspace pointer to a struct sgx_enclave_init instance
+ *
+ * Flush any outstanding enqueued EADD operations and perform EINIT.  The
+ * Launch Enclave Public Key Hash MSRs are rewritten as necessary to match
+ * the enclave's MRSIGNER, which is caculated from the provided sigstruct.
+ *
+ * Return:
+ *   0 on success,
+ *   SGX error code on EINIT failure,
+ *   -errno otherwise
+ */
+static long sgx_ioc_enclave_init(struct sgx_encl *encl, void __user *arg)
+{
+	struct sgx_sigstruct *sigstruct;
+	struct sgx_enclave_init einit;
+	struct page *initp_page;
+	void *token;
+	int ret;
+
+	if ((atomic_read(&encl->flags) & SGX_ENCL_INITIALIZED) ||
+	    !(atomic_read(&encl->flags) & SGX_ENCL_CREATED))
+		return -EINVAL;
+
+	if (copy_from_user(&einit, arg, sizeof(einit)))
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
+	if (copy_from_user(sigstruct, (void __user *)einit.sigstruct,
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
@@ -506,6 +691,9 @@ long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
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
2.25.1

