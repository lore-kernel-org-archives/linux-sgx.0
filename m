Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,TRACKER_ID,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BEA7C388F9
	for <linux-sgx@archiver.kernel.org>; Sat, 21 Nov 2020 15:13:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AED6F2224A
	for <linux-sgx@archiver.kernel.org>; Sat, 21 Nov 2020 15:13:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727874AbgKUPNi (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 21 Nov 2020 10:13:38 -0500
Received: from wind.enjellic.com ([76.10.64.91]:33192 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727741AbgKUPNh (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 21 Nov 2020 10:13:37 -0500
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id 0ALFD0H2004082;
        Sat, 21 Nov 2020 09:13:01 -0600
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id 0ALFCxIn004081;
        Sat, 21 Nov 2020 09:12:59 -0600
Date:   Sat, 21 Nov 2020 09:12:59 -0600
From:   "Dr. Greg" <greg@enjellic.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com, kai.huang@intel.com,
        kai.svahn@intel.com, kmoy@google.com, ludloff@google.com,
        luto@kernel.org, nhorman@redhat.com, npmccallum@redhat.com,
        puiterwijk@redhat.com, rientjes@google.com,
        sean.j.christopherson@intel.com, tglx@linutronix.de,
        yaozhangx@google.com, mikko.ylinen@intel.com
Subject: Re: [PATCH v40 00/24] Intel SGX foundations
Message-ID: <20201121151259.GA3948@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <20201104145430.300542-1-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201104145430.300542-1-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Sat, 21 Nov 2020 09:13:01 -0600 (CST)
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Nov 04, 2020 at 04:54:06PM +0200, Jarkko Sakkinen wrote:

Good morning, I hope the weekend is going well for everyone.

> Important Kernel Touch Points
> =============================
>
> This implementation is picky and will decline to work on hardware which
> is locked to Intel's root of trust.

Given that this driver is no longer locked to the Intel trust root, by
virtue of being restricted to run only on platforms which support
Flexible Launch Control, there is no longer any legitimate technical
reason to not expose all of the functionality of the hardware.

The patch that I am including below implements signature based policy
controls for enclave initialization.  It does so in a manner that is
completely transparent to the default behavior of the driver, which is
to initialize any enclave passed to it with the exception of enclaves
that set the PROVISION_KEY attribute bit.

Secondary to the discussions that have been ongoing regarding the
restriction of mmap/mprotect, this patch has been extended to
implement signature based controls on dynamic enclaves.  The default
behavior of the driver under this patch is to reject mmap/mprotect on
initialized enclaves, unless the platform owner has elected to allow
the enclave signer the option to implement 'dynamic' enclaves,
ie. enclaves that are allowed to modify their page permissions after
initialization.

There have been a number of 'GOOGLE-ites' copied on all of these
discussions.  The notion of signature based policy controls should be
uncontroversial since it allows platform owners to implement a
'Zero-Trust' security model, a notion that has been widely advocated
by GOOGLE and others in the industry.

The strongest platform security guarantees for trusted execution
environments, that offer strong confidentiality guarantees on both
code and data, are ultimately only reputational.  This patch enables
SGX platform owners to avail themselves of that option while not
restricting, in any way, what platform owners can do with their
hardware.

This patch is also available from the following location, given the
vagaries of e-mail based patch transmission:

ftp://ftp.enjellic.com/pub/sgx/kernel/SFLC-v41.patch

Have a good remainder of the weekend.

Dr. Greg

---------------------------------------------------------------------------
Implement signature based policy controls.

This patch implements the ability for the platform owner to
implement signature based enclave control policies.  It does so
in a manner that is completely transparent to the normal behavior
of the driver, which is to initialize any enclave that is
presented to it with the exception of enclaves that have the
PROVISION_KEY attribute set.

If a launch enclave control policy is not implemented, any attempt
to pass a launch token into the driver will cause enclave
initialization to fail.

Signature based policy control is based on the identity modulus
signature of the enclave signer which is the SHA256 hash of the
modulus of the enclave signing key.

The following policy functionality is implemented.

1.) Control over which keys are allowed to sign enclaves.

2.) Control over which keys are allowed to implement launch
enclaves.

3.) Control over which keys are allowed to sign enclaves that
have access to the PROVISION_KEY attribute.

4.) Control over which enclaves are allowed to have their page
permissions modified after enclave initialization.

For each policy type a plurality of key signatures are
allowed.

Cryptographic initialization policy is accessed through the
following four pseudo-files that are implemented by this patch:

/sys/kernel/security/sgx/signing_keys

/sys/kernel/security/sgx/launch_keys

/sys/kernel/security/sgx/provisioning_keys

/sys/kernel/security/sgx/dynamic_keys

Policy keys are registered with the driver by writing the identity
modulus signature to these files in simple hexadecimal format, ie:

0000000000000000000000000000000000000000000000000000000000000000

The current list of policy keys can be displayed by reading the
contents of the pseudo-files.

In addition to a key signature, the following keywords are
accepted as valid entries for a policy file:

clear

lock

The 'clear' keyword causes all existing entries in a policy list
to be deleted.

The 'lock' keyword causes any further modifications or access to
a policy list to be denied.

All of the policy code is implemented in a single file, policy.c,
with minimal impact to the driver at large.  Since the calculation
of the identity modulus signature needed to program a launch control
register is effectively a policy decision, the code to compute the
signature was moved from the ioctl.c file to the policy.c file.

Tested-by: Dr. Greg <greg@enjellic.com>
Signed-off-by: Dr. Greg <greg@enjellic.com>
---
 arch/x86/Kconfig                 |   1 +
 arch/x86/include/uapi/asm/sgx.h  |   1 +
 arch/x86/kernel/cpu/sgx/Makefile |   3 +-
 arch/x86/kernel/cpu/sgx/driver.c |   8 +
 arch/x86/kernel/cpu/sgx/driver.h |   2 +
 arch/x86/kernel/cpu/sgx/encl.c   |  47 +--
 arch/x86/kernel/cpu/sgx/encl.h   |   3 +
 arch/x86/kernel/cpu/sgx/ioctl.c  | 129 +++----
 arch/x86/kernel/cpu/sgx/policy.c | 569 +++++++++++++++++++++++++++++++
 9 files changed, 664 insertions(+), 99 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/sgx/policy.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 618d1aabccb8..575936aa4d91 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1937,6 +1937,7 @@ config X86_SGX
 	depends on CRYPTO_SHA256=y
 	select SRCU
 	select MMU_NOTIFIER
+	select SECURITYFS
 	help
 	  Intel(R) Software Guard eXtensions (SGX) is a set of CPU instructions
 	  that can be used by applications to set aside private regions of code
diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
index 791e45334a4a..48316ffe00b3 100644
--- a/arch/x86/include/uapi/asm/sgx.h
+++ b/arch/x86/include/uapi/asm/sgx.h
@@ -63,6 +63,7 @@ struct sgx_enclave_add_pages {
  */
 struct sgx_enclave_init {
 	__u64 sigstruct;
+	__u64 token;
 };
 
 /**
diff --git a/arch/x86/kernel/cpu/sgx/Makefile b/arch/x86/kernel/cpu/sgx/Makefile
index 91d3dc784a29..4576a491eb3f 100644
--- a/arch/x86/kernel/cpu/sgx/Makefile
+++ b/arch/x86/kernel/cpu/sgx/Makefile
@@ -2,4 +2,5 @@ obj-y += \
 	driver.o \
 	encl.o \
 	ioctl.o \
-	main.o
+	main.o \
+	policy.o
diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx/driver.c
index f2eac41bb4ff..35ff0ca362dd 100644
--- a/arch/x86/kernel/cpu/sgx/driver.c
+++ b/arch/x86/kernel/cpu/sgx/driver.c
@@ -190,5 +190,13 @@ int __init sgx_drv_init(void)
 		return ret;
 	}
 
+	ret = sgx_policy_fs_init();
+	if (ret) {
+		pr_err("SGX policy fs creation failed with %d.\n", ret);
+		misc_deregister(&sgx_dev_provision);
+		misc_deregister(&sgx_dev_enclave);
+		return ret;
+	}
+
 	return 0;
 }
diff --git a/arch/x86/kernel/cpu/sgx/driver.h b/arch/x86/kernel/cpu/sgx/driver.h
index 4eddb4d571ef..6c0fac29e6ff 100644
--- a/arch/x86/kernel/cpu/sgx/driver.h
+++ b/arch/x86/kernel/cpu/sgx/driver.h
@@ -26,4 +26,6 @@ long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg);
 
 int sgx_drv_init(void);
 
+int sgx_policy_fs_init(void);
+u64 *sgx_policy_get_signer(u64 *signature);
 #endif /* __ARCH_X86_SGX_DRIVER_H__ */
diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 5551c7d36483..2731edc296b8 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -212,27 +212,22 @@ static void sgx_vma_open(struct vm_area_struct *vma)
  * @end:		upper bound of the address range, exclusive
  * @vm_flags:		VMA flags
  *
- * Iterate through the enclave pages contained within [@start, @end) to verify
- * that the permissions requested by a subset of {VM_READ, VM_WRITE, VM_EXEC}
- * does not contain any permissions that are not contained in the build time
- * permissions of any of the enclave pages within the given address range.
+ * This function provides a method for determining whether or not mmap
+ * or mprotect can be invoked on the virtual memory address range of
+ * an enclave.  Page permission manipulations are only allowed on
+ * enclaves that have their dynamic flag set.
  *
- * An enclave creator must declare the strongest permissions that will be
- * needed for each enclave page  This ensures that mappings  have the identical
- * or weaker permissions that the earlier declared permissions.
+ * The function signature is left intact since future versions of the
+ * driver may implement verifications that the requested permission
+ * changes are consistent with the desire of the enclave author.
  *
  * Return: 0 on success, -EACCES otherwise
  */
 int sgx_encl_may_map(struct sgx_encl *encl, unsigned long start,
 		     unsigned long end, unsigned long vm_flags)
 {
-	unsigned long vm_prot_bits = vm_flags & (VM_READ | VM_WRITE | VM_EXEC);
-	struct sgx_encl_page *page;
-	unsigned long count = 0;
 	int ret = 0;
 
-	XA_STATE(xas, &encl->page_array, PFN_DOWN(start));
-
 	/*
 	 * Disallow READ_IMPLIES_EXEC tasks as their VMA permissions might
 	 * conflict with the enclave page permissions.
@@ -240,31 +235,9 @@ int sgx_encl_may_map(struct sgx_encl *encl, unsigned long start,
 	if (current->personality & READ_IMPLIES_EXEC)
 		return -EACCES;
 
-	mutex_lock(&encl->lock);
-	xas_lock(&xas);
-	xas_for_each(&xas, page, PFN_DOWN(end - 1)) {
-		if (!page)
-			break;
-
-		if (~page->vm_max_prot_bits & vm_prot_bits) {
-			ret = -EACCES;
-			break;
-		}
-
-		/* Reschedule on every XA_CHECK_SCHED iteration. */
-		if (!(++count % XA_CHECK_SCHED)) {
-			xas_pause(&xas);
-			xas_unlock(&xas);
-			mutex_unlock(&encl->lock);
-
-			cond_resched();
-
-			mutex_lock(&encl->lock);
-			xas_lock(&xas);
-		}
-	}
-	xas_unlock(&xas);
-	mutex_unlock(&encl->lock);
+	/* Disallow mapping on initialized enclave. */
+	if (test_bit(SGX_ENCL_INITIALIZED, &encl->flags) && !encl->dynamic)
+		ret = -EACCES;
 
 	return ret;
 }
diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
index 244e1d93fce2..cc4392929652 100644
--- a/arch/x86/kernel/cpu/sgx/encl.h
+++ b/arch/x86/kernel/cpu/sgx/encl.h
@@ -51,6 +51,7 @@ struct sgx_encl {
 	unsigned long base;
 	unsigned long size;
 	unsigned long flags;
+	unsigned int dynamic;
 	unsigned int page_cnt;
 	unsigned int secs_child_cnt;
 	struct mutex lock;
@@ -104,4 +105,6 @@ unsigned int sgx_alloc_va_slot(struct sgx_va_page *va_page);
 void sgx_free_va_slot(struct sgx_va_page *va_page, unsigned int offset);
 bool sgx_va_page_full(struct sgx_va_page *va_page);
 
+int sgx_policy_get_params(struct sgx_encl *encl, void *modulus, u64 *signer,
+			  int *signcnt);
 #endif /* _X86_ENCL_H */
diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 6d37117ac8a0..4c92f4e1d507 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -466,70 +466,14 @@ static long sgx_ioc_enclave_add_pages(struct sgx_encl *encl, void __user *arg)
 	return ret;
 }
 
-static int __sgx_get_key_hash(struct crypto_shash *tfm, const void *modulus,
-			      void *hash)
+static int sgx_encl_try_init(struct sgx_encl *encl,
+			     struct sgx_sigstruct *sigstruct, void *token,
+			     u64 *signer)
 {
-	SHASH_DESC_ON_STACK(shash, tfm);
-
-	shash->tfm = tfm;
-
-	return crypto_shash_digest(shash, modulus, SGX_MODULUS_SIZE, hash);
-}
-
-static int sgx_get_key_hash(const void *modulus, void *hash)
-{
-	struct crypto_shash *tfm;
-	int ret;
-
-	tfm = crypto_alloc_shash("sha256", 0, CRYPTO_ALG_ASYNC);
-	if (IS_ERR(tfm))
-		return PTR_ERR(tfm);
-
-	ret = __sgx_get_key_hash(tfm, modulus, hash);
-
-	crypto_free_shash(tfm);
-	return ret;
-}
-
-static int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct *sigstruct,
-			 void *token)
-{
-	u64 mrsigner[4];
 	int i, j, k;
 	void *addr;
 	int ret;
 
-	/*
-	 * Deny initializing enclaves with attributes (namely provisioning)
-	 * that have not been explicitly allowed.
-	 */
-	if (encl->attributes & ~encl->attributes_mask)
-		return -EACCES;
-
-	/*
-	 * Attributes should not be enforced *only* against what's available on
-	 * platform (done in sgx_encl_create) but checked and enforced against
-	 * the mask for enforcement in sigstruct. For example an enclave could
-	 * opt to sign with AVX bit in xfrm, but still be loadable on a platform
-	 * without it if the sigstruct->body.attributes_mask does not turn that
-	 * bit on.
-	 */
-	if (sigstruct->body.attributes & sigstruct->body.attributes_mask &
-	    sgx_attributes_reserved_mask)
-		return -EINVAL;
-
-	if (sigstruct->body.miscselect & sigstruct->body.misc_mask &
-	    sgx_misc_reserved_mask)
-		return -EINVAL;
-
-	if (sigstruct->body.xfrm & sigstruct->body.xfrm_mask &
-	    sgx_xfrm_reserved_mask)
-		return -EINVAL;
-
-	ret = sgx_get_key_hash(sigstruct->modulus, mrsigner);
-	if (ret)
-		return ret;
-
 	mutex_lock(&encl->lock);
 
 	/*
@@ -545,7 +489,7 @@ static int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct *sigstruct,
 			preempt_disable();
 
 			for (k = 0; k < 4; k++)
-				wrmsrl(MSR_IA32_SGXLEPUBKEYHASH0 + k, mrsigner[k]);
+				wrmsrl(MSR_IA32_SGXLEPUBKEYHASH0 + k, signer[k]);
 
 			ret = __einit(sigstruct, token, addr);
 
@@ -585,6 +529,60 @@ static int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct *sigstruct,
 	return ret;
 }
 
+static int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct *sigstruct,
+			 void *token)
+{
+	u64 mrsigner[4];
+	u64 *signer;
+	int ret;
+	int signcnt = 1;
+
+	/* Configure the launch policy. */
+	ret = sgx_policy_get_params(encl, sigstruct->modulus, mrsigner,
+				    &signcnt);
+	if (ret)
+		return ret;
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
+	/* Try the available policies. */
+	signer = mrsigner;
+	while (signcnt--) {
+		ret = sgx_encl_try_init(encl, sigstruct, token, signer);
+		if (!ret)
+			return ret;
+		if (signcnt)
+			signer = sgx_policy_get_signer(signer);
+	}
+
+	return ret;
+}
+
 /**
  * sgx_ioc_enclave_init() - handler for %SGX_IOC_ENCLAVE_INIT
  * @encl:	an enclave pointer
@@ -621,7 +619,16 @@ static long sgx_ioc_enclave_init(struct sgx_encl *encl, void __user *arg)
 
 	sigstruct = kmap(initp_page);
 	token = (void *)((unsigned long)sigstruct + PAGE_SIZE / 2);
-	memset(token, 0, SGX_LAUNCH_TOKEN_SIZE);
+	if (!init_arg.token)
+		memset(token, 0, SGX_LAUNCH_TOKEN_SIZE);
+	else {
+		if (copy_from_user((uint8_t *) token,
+				   (void __user *) init_arg.token,
+				   SGX_LAUNCH_TOKEN_SIZE)) {
+			ret = -EFAULT;
+			goto out;
+		}
+	}
 
 	if (copy_from_user(sigstruct, (void __user *)init_arg.sigstruct,
 			   sizeof(*sigstruct))) {
diff --git a/arch/x86/kernel/cpu/sgx/policy.c b/arch/x86/kernel/cpu/sgx/policy.c
new file mode 100644
index 000000000000..e51440759192
--- /dev/null
+++ b/arch/x86/kernel/cpu/sgx/policy.c
@@ -0,0 +1,569 @@
+// SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
+// Copyright(c) Enjellic Systems Development, LLC
+
+#define KEY_SIZE 32
+
+#include <linux/types.h>
+#include <linux/seq_file.h>
+#include <linux/atomic.h>
+#include <linux/security.h>
+#include "driver.h"
+#include "encl.h"
+
+static struct dentry *sgx_fs;
+
+struct list_key {
+	struct list_head list;
+	u64 key[KEY_SIZE / 8];
+};
+
+struct list_key_iterator {
+	char *type;
+	atomic_t *opencount;
+	unsigned int *count;
+	struct mutex *lock;
+	struct list_head *list;
+	bool *lockfile;
+};
+
+static struct dentry *launch_keys;
+static atomic_t launch_keys_opencount = ATOMIC_INIT(1);
+static unsigned int launch_keys_count;
+static bool launch_keys_locked;
+static DEFINE_MUTEX(launch_key_list_mutex);
+static LIST_HEAD(launch_key_list);
+
+static struct dentry *provision_keys;
+static atomic_t provision_keys_opencount = ATOMIC_INIT(1);
+static unsigned int provision_keys_count;
+static bool provision_keys_locked;
+static DEFINE_MUTEX(provision_key_list_mutex);
+static LIST_HEAD(provision_key_list);
+
+static struct dentry *signing_keys;
+static atomic_t signing_keys_opencount = ATOMIC_INIT(1);
+static unsigned int signing_keys_count;
+static bool signing_keys_locked;
+static DEFINE_MUTEX(signing_key_list_mutex);
+static LIST_HEAD(signing_key_list);
+
+static struct dentry *dynamic_keys;
+static atomic_t dynamic_keys_opencount = ATOMIC_INIT(1);
+static unsigned int dynamic_keys_count;
+static bool dynamic_keys_locked;
+static DEFINE_MUTEX(dynamic_key_list_mutex);
+static LIST_HEAD(dynamic_key_list);
+
+/**
+ * have_signer - Verify the presence of a key signer.
+ *
+ * @signature:	Pointer to signature of signer.
+ *
+ * Return:
+ *   0 Signer signature was not found.
+ *   1 Signer signature was found.
+ */
+static bool have_signer(struct list_head *keylist, struct mutex *lock,
+			uint8_t *signature)
+{
+	bool retn = false;
+	struct list_key *kp;
+
+	mutex_lock(lock);
+	list_for_each_entry(kp, keylist, list) {
+		pr_debug("%s: Checking signer=%*phN, ks=%*phN\n", __func__,
+			 KEY_SIZE, signature, KEY_SIZE, kp->key);
+		if (memcmp(kp->key, signature, KEY_SIZE) == 0) {
+			retn = true;
+			goto done;
+		}
+	}
+
+ done:
+	mutex_unlock(lock);
+	return retn;
+}
+
+static int process_write_key(const char __user *buf, size_t datalen,
+			     unsigned int *keycnt, struct mutex *lock,
+			     struct list_head *keylist)
+{
+	ssize_t retn;
+
+	char *p, keybufr[KEY_SIZE*2 + 1], key[KEY_SIZE];
+
+	struct list_key *kp;
+
+	if (datalen != sizeof(keybufr)) {
+		retn = -EINVAL;
+		goto done;
+	}
+
+	memset(keybufr, '\0', sizeof(keybufr));
+	if (copy_from_user(keybufr, buf, datalen)) {
+		retn = -EFAULT;
+		goto done;
+	}
+
+	p = strchr(keybufr, '\n');
+	if (!p) {
+		retn = -EINVAL;
+		goto done;
+	}
+	*p = '\0';
+	if (hex2bin(key, keybufr, sizeof(key))) {
+		retn = -EINVAL;
+		goto done;
+	}
+
+	kp = kzalloc(sizeof(*kp), GFP_KERNEL);
+	if (!kp) {
+		retn = -ENOMEM;
+		goto done;
+	}
+	memcpy(kp->key, key, sizeof(kp->key));
+
+	mutex_lock(lock);
+	list_add_tail(&kp->list, keylist);
+	++*keycnt;
+	mutex_unlock(lock);
+
+	retn = datalen;
+	pr_debug("%s: Added key: %*phN\n", __func__, KEY_SIZE, key);
+
+ done:
+	return retn;
+}
+
+static int process_lock(const char __user *buf, size_t datalen, bool *lockfile)
+{
+	char bufr[5];
+
+	if (datalen != strlen("lock") + 1)
+		return 0;
+
+	memset(bufr, '\0', sizeof(bufr));
+	if (copy_from_user(bufr, buf, datalen-1))
+		return -EFAULT;
+	if (strcmp(bufr, "lock") != 0)
+		return 0;
+
+	*lockfile = true;
+	return datalen;
+}
+
+static int process_clear(const char __user *buf, size_t datalen, char *type,
+			 unsigned int *keycnt, struct mutex *lock,
+			 struct list_head *keylist)
+{
+	char bufr[6];
+	struct list_key *kp, *kp_tmp;
+
+	if (datalen != strlen("clear") + 1)
+		return 0;
+
+	memset(bufr, '\0', sizeof(bufr));
+	if (copy_from_user(bufr, buf, datalen-1))
+		return -EFAULT;
+	if (strcmp(bufr, "clear") != 0)
+		return 0;
+
+	mutex_lock(lock);
+	list_for_each_entry_safe(kp, kp_tmp, keylist, list) {
+		pr_debug("[%s]: Freeing signature: %*phN\n", __FILE__,
+			 KEY_SIZE, kp->key);
+		list_del(&kp->list);
+		kfree(kp);
+	}
+	*keycnt = 0;
+	mutex_unlock(lock);
+
+	pr_info("Cleared %s signatures.\n", type);
+	return datalen;
+}
+
+static void *key_start(struct seq_file *c, loff_t *pos)
+{
+	struct list_key_iterator *ki = (struct list_key_iterator *) c->private;
+
+	if (*pos >= *ki->count)
+		return NULL;
+
+	mutex_lock(ki->lock);
+	return seq_list_start(ki->list, *pos);
+}
+
+static void *key_next(struct seq_file *c, void *p, loff_t *pos)
+{
+	struct list_key_iterator *ki = (struct list_key_iterator *) c->private;
+
+	return seq_list_next(p, ki->list, pos);
+}
+
+static void key_stop(struct seq_file *c, void *p)
+{
+	struct list_key_iterator *ki = (struct list_key_iterator *) c->private;
+
+	mutex_unlock(ki->lock);
+}
+
+static int key_show(struct seq_file *c, void *key)
+{
+	struct list_key *kp;
+
+	kp = list_entry(key, struct list_key, list);
+	seq_printf(c, "%*phN\n", KEY_SIZE, kp->key);
+	return 0;
+}
+
+static const struct seq_operations keys_seqops = {
+	.start = key_start,
+	.next = key_next,
+	.stop = key_stop,
+	.show = key_show
+};
+
+static ssize_t write_keys(struct file *file, const char __user *buf,
+			  size_t datalen, loff_t *ppos)
+{
+	struct seq_file *s = file->private_data;
+	struct list_key_iterator *ki = (struct list_key_iterator *) s->private;
+	ssize_t retn;
+
+	if (*ppos != 0)
+		return -EINVAL;
+
+	retn = process_lock(buf, datalen, ki->lockfile);
+	if (retn != 0)
+		return retn;
+
+	retn = process_clear(buf, datalen, ki->type, ki->count, ki->lock,
+			     ki->list);
+	if (retn != 0)
+		return retn;
+
+	retn = process_write_key(buf, datalen, ki->count, ki->lock, ki->list);
+	return retn;
+}
+
+static int release_keys(struct inode *inode, struct file *file)
+{
+	struct seq_file *s = file->private_data;
+	struct list_key_iterator *ki = (struct list_key_iterator *) s->private;
+
+	atomic_set(ki->opencount, 1);
+	seq_release_private(inode, file);
+	return 0;
+}
+
+static int open_launch_keys(struct inode *inode, struct file *filp)
+{
+	struct list_key_iterator *ki;
+
+	if (launch_keys_locked)
+		return -EACCES;
+
+	if (!atomic_dec_and_test(&launch_keys_opencount))
+		return -EBUSY;
+
+	ki = __seq_open_private(filp, &keys_seqops, sizeof(*ki));
+	if (!ki)
+		return -ENOMEM;
+
+	ki->type = "launch control";
+	ki->opencount = &launch_keys_opencount;
+	ki->count = &launch_keys_count;
+	ki->lock = &launch_key_list_mutex;
+	ki->list = &launch_key_list;
+	ki->lockfile = &launch_keys_locked;
+
+	return 0;
+}
+
+static const struct file_operations launch_keys_ops = {
+	.open = open_launch_keys,
+	.write = write_keys,
+	.release = release_keys,
+	.read = seq_read,
+	.llseek = seq_lseek,
+};
+
+/* Provisioning control. */
+
+static int open_provision_keys(struct inode *inode, struct file *filp)
+{
+	struct list_key_iterator *ki;
+
+	if (provision_keys_locked)
+		return -EACCES;
+
+	if (!atomic_dec_and_test(&provision_keys_opencount))
+		return -EBUSY;
+
+	ki = __seq_open_private(filp, &keys_seqops, sizeof(*ki));
+	if (!ki)
+		return -ENOMEM;
+
+	ki->type = "provisioning control";
+	ki->opencount = &provision_keys_opencount;
+	ki->count = &provision_keys_count;
+	ki->lock = &provision_key_list_mutex;
+	ki->list = &provision_key_list;
+
+	return 0;
+}
+
+static const struct file_operations provision_keys_ops = {
+	.open = open_provision_keys,
+	.write = write_keys,
+	.release = release_keys,
+	.read = seq_read,
+	.llseek = seq_lseek,
+};
+
+/* Signing control. */
+
+static int open_signing_keys(struct inode *inode, struct file *filp)
+{
+	struct list_key_iterator *ki;
+
+	if (signing_keys_locked)
+		return -EACCES;
+
+	if (!atomic_dec_and_test(&signing_keys_opencount))
+		return -EBUSY;
+
+	ki = __seq_open_private(filp, &keys_seqops, sizeof(*ki));
+	if (!ki)
+		return -ENOMEM;
+
+	ki->type = "signing control";
+	ki->opencount = &signing_keys_opencount;
+	ki->count = &signing_keys_count;
+	ki->lock = &signing_key_list_mutex;
+	ki->list = &signing_key_list;
+
+	return 0;
+}
+
+static const struct file_operations signing_keys_ops = {
+	.open = open_signing_keys,
+	.write = write_keys,
+	.release = release_keys,
+	.read = seq_read,
+	.llseek = seq_lseek,
+};
+
+/* Dynamic memory control. */
+
+static int open_dynamic_keys(struct inode *inode, struct file *filp)
+{
+	struct list_key_iterator *ki;
+
+	if (dynamic_keys_locked)
+		return -EACCES;
+
+	if (!atomic_dec_and_test(&dynamic_keys_opencount))
+		return -EBUSY;
+
+	ki = __seq_open_private(filp, &keys_seqops, sizeof(*ki));
+	if (!ki)
+		return -ENOMEM;
+
+	ki->type = "dynamic control";
+	ki->opencount = &dynamic_keys_opencount;
+	ki->count = &dynamic_keys_count;
+	ki->lock = &dynamic_key_list_mutex;
+	ki->list = &dynamic_key_list;
+	ki->lockfile = &dynamic_keys_locked;
+
+	return 0;
+}
+
+static const struct file_operations dynamic_keys_ops = {
+	.open = open_dynamic_keys,
+	.write = write_keys,
+	.release = release_keys,
+	.read = seq_read,
+	.llseek = seq_lseek,
+};
+
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
+/**
+ * sgx_policy_get_params
+ *
+ * This function sets the cryptographically configured initialization
+ * policy parameters.  These include the identity modulus signature to
+ * be used as well as the configuration of the allowed enclave
+ * attributes.
+ *
+ * Return:
+ *   0 on success.
+ *   -errno otherwise
+ */
+
+int sgx_policy_get_params(struct sgx_encl *encl, void *modulus, u64 *signer,
+			  int *signcnt)
+{
+	int retn = -EINVAL;
+	uint8_t mrsigner[KEY_SIZE];
+	struct list_key *kp;
+
+	retn = sgx_get_key_hash(modulus, mrsigner);
+	if (retn)
+		goto no_signer;
+
+	if (provision_keys_count > 0 &&
+	    have_signer(&provision_key_list, &provision_key_list_mutex,
+			mrsigner))
+		encl->attributes_mask |= SGX_ATTR_PROVISIONKEY;
+
+	if (dynamic_keys_count > 0 &&
+	   have_signer(&dynamic_key_list, &dynamic_key_list_mutex, mrsigner))
+		encl->dynamic = 1;
+
+	if (signing_keys_count == 0 && launch_keys_count == 0)
+		goto have_signer;
+
+	if (signing_keys_count > 0 &&
+	    have_signer(&signing_key_list, &signing_key_list_mutex,
+			mrsigner))
+		goto have_signer;
+
+	if (launch_keys_count == 0)
+		goto no_signer;
+
+	if (encl->attributes & SGX_ATTR_EINITTOKENKEY) {
+		if (have_signer(&launch_key_list, &launch_key_list_mutex,
+				 mrsigner)) {
+			encl->attributes_mask |= SGX_ATTR_EINITTOKENKEY;
+			goto have_signer;
+		} else
+			goto no_signer;
+	}
+
+	*signcnt = launch_keys_count;
+	kp = list_first_entry(&launch_key_list, struct list_key, list);
+	memcpy(mrsigner, kp->key, KEY_SIZE);
+
+ have_signer:
+	memcpy(signer, mrsigner, KEY_SIZE);
+	pr_debug("%s: Using signer: %*phN\n", __func__, KEY_SIZE, signer);
+	return 0;
+ no_signer:
+	memset(signer, '\0', KEY_SIZE);
+	return retn;
+}
+
+/**
+ * sgx_policy_get_launch_signer - Iterate through list of enclave signers.
+ *
+ * @signer:	The last returned enclave signer.
+ *
+ * This function iterates through the list of enclave signers from the
+ * last signature.  Calling the function with a NULL  value
+ * resets the iteration to the beginning of the list.
+ *
+ * Return:
+ *   NULL indicates end of list
+ *   non-NULL the next enclave signature on the list.
+ */
+
+u64 *sgx_policy_get_signer(u64 *signer)
+{
+	bool seeking = false;
+	u64 *retn = NULL;
+	struct list_key *kp;
+
+	if (!signer) {
+		kp = list_first_entry(&launch_key_list, struct list_key, list);
+		return kp->key;
+	}
+	kp = list_last_entry(&launch_key_list, struct list_key, list);
+	if (memcmp(kp->key, signer, sizeof(kp->key)) == 0)
+		return NULL;
+
+	mutex_lock(&launch_key_list_mutex);
+	list_for_each_entry(kp, &launch_key_list, list) {
+		if (seeking) {
+			retn = kp->key;
+			goto done;
+		}
+		pr_debug("%s: Skipping: %*phN\n", __func__, KEY_SIZE, kp->key);
+		if (memcmp(kp->key, signer, KEY_SIZE) == 0)
+			seeking = true;
+	}
+
+ done:
+	mutex_unlock(&launch_key_list_mutex);
+	return retn;
+}
+
+int __init sgx_policy_fs_init(void)
+{
+	int retn = -1;
+
+	sgx_fs = securityfs_create_dir("sgx", NULL);
+	if (IS_ERR(sgx_fs)) {
+		retn = PTR_ERR(sgx_fs);
+		goto err;
+	}
+
+	launch_keys = securityfs_create_file("launch_keys", 0600, sgx_fs,
+					     NULL, &launch_keys_ops);
+	if (IS_ERR(launch_keys)) {
+		retn = PTR_ERR(launch_keys);
+		goto err;
+	}
+
+	provision_keys = securityfs_create_file("provisioning_keys", 0600,
+						sgx_fs, NULL,
+						&provision_keys_ops);
+	if (IS_ERR(provision_keys)) {
+		retn = PTR_ERR(provision_keys);
+		goto err;
+	}
+
+	signing_keys = securityfs_create_file("signing_keys", 0600, sgx_fs,
+					      NULL, &signing_keys_ops);
+	if (IS_ERR(signing_keys)) {
+		retn = PTR_ERR(signing_keys);
+		goto err;
+	}
+
+	dynamic_keys = securityfs_create_file("dynamic_keys", 0600, sgx_fs,
+					      NULL, &dynamic_keys_ops);
+	if (IS_ERR(dynamic_keys)) {
+		retn = PTR_ERR(dynamic_keys);
+		goto err;
+	}
+
+	return 0;
+
+ err:
+	return retn;
+}
-- 
2.19.2

---------------------------------------------------------------------------

As always,
Dr. Greg Wettstein, Ph.D, Worker      Autonomously self-defensive
Enjellic Systems Development, LLC     IOT platforms and edge devices.
4206 N. 19th Ave.
Fargo, ND  58102
PH: 701-281-1686                      EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"If we thought this was a trap, we wouldn't be doing it, and as you know,
 we have a lot of lawyers."
                                -- Irving Wladawsky-Berger
