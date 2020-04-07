Return-Path: <SRS0=BG2U=5X=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	TRACKER_ID,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 647B9C2BABC
	for <linux-sgx@archiver.kernel.org>; Tue,  7 Apr 2020 09:20:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2D157206C0
	for <linux-sgx@archiver.kernel.org>; Tue,  7 Apr 2020 09:20:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726687AbgDGJUo (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 7 Apr 2020 05:20:44 -0400
Received: from wind.enjellic.com ([76.10.64.91]:34404 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726591AbgDGJUn (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 7 Apr 2020 05:20:43 -0400
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id 0379KdgV011878;
        Tue, 7 Apr 2020 04:20:39 -0500
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id 0379KdWN011877;
        Tue, 7 Apr 2020 04:20:39 -0500
Date:   Tue, 7 Apr 2020 04:20:39 -0500
From:   "Dr. Greg" <greg@enjellic.com>
To:     linux-sgx@vger.kernel.org
Cc:     serge.ayoun@intel.com, shay.katz-zamir@intel.com
Subject: [PATCH 1/1] Implement cryptographic initialization control.
Message-ID: <20200407092039.GA11846@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Tue, 07 Apr 2020 04:20:39 -0500 (CDT)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

This patch introduces the ability of the platform owner to
implement cryptographically controlled enclave initialization
policy.  This functionality provides the platform owner with the
ability to use the identity modulus signature of an enclave
signer (SHA256 hash of the modulus of the signing key) to gate
access to enclave initialization, rather then simply relying
on discretionary access controls that are applied to the SGX
relevant device driver nodes.

The following policy functionality is introduced in this commit:

1.) Control over which keys are allowed to initialize an
enclave.

2.) Control over which keys are allowed to implement launch
enclaves.

3.) Control over which keys are allowed to initialize enclaves
that have access to the PROVISION_KEY attribute.

For each policy type a plurality of key signatures are allowed.

Absent an intent by the platform owner/administrator to use
cryptographic initialization policies, this functionality does
not change the standard behavior of the driver, which is to
allow any enclave presented to the driver to be initialized.

Cryptographic initialization policy is accessed through the
following three pseudo-files that are implemented by this patch:

/sys/kernel/security/signing_keys

/sys/kernel/security/launch_keys

/sys/kernel/security/provisioning_keys

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

In order to support a plurality of launch keys the code that
loops over initialization attempts was pushed downward into a new
function that is named as follows:

sgx_try_init()

Primarily to avoid excessive indentation that would otherwise be
needed in the sgx_encl_init() function.

Signed-off-by: Dr. Greg Wettstein <greg@enjellic.com>
---
 arch/x86/Kconfig                 |   1 +
 arch/x86/include/uapi/asm/sgx.h  |   1 +
 arch/x86/kernel/cpu/sgx/Makefile |   3 +-
 arch/x86/kernel/cpu/sgx/driver.c |   8 +
 arch/x86/kernel/cpu/sgx/driver.h |   2 +
 arch/x86/kernel/cpu/sgx/encl.h   |   2 +
 arch/x86/kernel/cpu/sgx/ioctl.c  |  82 ++---
 arch/x86/kernel/cpu/sgx/policy.c | 513 +++++++++++++++++++++++++++++++
 8 files changed, 573 insertions(+), 39 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/sgx/policy.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 8bbb4313fae3..5cfde1d36dc9 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1955,6 +1955,7 @@ config INTEL_SGX
 	depends on X86_64 && CPU_SUP_INTEL
 	select SRCU
 	select MMU_NOTIFIER
+	select SECURITYFS
 	help
 	  Intel(R) SGX is a set of CPU instructions that can be used by
 	  applications to set aside private regions of code and data, referred
diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
index e196cfd44b70..1c3cdbce533d 100644
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
index f8d32da3a67a..d8ee2a889ca1 100644
--- a/arch/x86/kernel/cpu/sgx/Makefile
+++ b/arch/x86/kernel/cpu/sgx/Makefile
@@ -3,4 +3,5 @@ obj-y += \
 	encl.o \
 	ioctl.o \
 	main.o \
-	reclaim.o
+	reclaim.o \
+	policy.o
diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx/driver.c
index 997a7f4117c5..d4330b32c243 100644
--- a/arch/x86/kernel/cpu/sgx/driver.c
+++ b/arch/x86/kernel/cpu/sgx/driver.c
@@ -205,5 +205,13 @@ int __init sgx_drv_init(void)
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
index 72747d01c046..8293f4d12e82 100644
--- a/arch/x86/kernel/cpu/sgx/driver.h
+++ b/arch/x86/kernel/cpu/sgx/driver.h
@@ -29,4 +29,6 @@ long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg);
 
 int sgx_drv_init(void);
 
+int sgx_policy_fs_init(void);
+u64 *sgx_policy_get_launch_signer(u64 *signature);
 #endif /* __ARCH_X86_SGX_DRIVER_H__ */
diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/encl.h
index 44b353aa8866..b5be1f2233ea 100644
--- a/arch/x86/kernel/cpu/sgx/encl.h
+++ b/arch/x86/kernel/cpu/sgx/encl.h
@@ -124,4 +124,6 @@ unsigned int sgx_alloc_va_slot(struct sgx_va_page *va_page);
 void sgx_free_va_slot(struct sgx_va_page *va_page, unsigned int offset);
 bool sgx_va_page_full(struct sgx_va_page *va_page);
 
+int sgx_policy_get_params(struct sgx_encl *encl, void *modulus, u64 *signer,
+			  int *signcnt);
 #endif /* _X86_ENCL_H */
diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 12e1496f8a8b..e960be8f924c 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -556,31 +556,6 @@ static long sgx_ioc_enclave_add_pages(struct sgx_encl *encl, void __user *arg)
 	return ret;
 }
 
-static int __sgx_get_key_hash(struct crypto_shash *tfm, const void *modulus,
-			      void *hash)
-{
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
 static void sgx_update_lepubkeyhash_msrs(u64 *lepubkeyhash, bool enforce)
 {
 	u64 *cache;
@@ -611,22 +586,14 @@ static int sgx_einit(struct sgx_sigstruct *sigstruct, void *token,
 	return ret;
 }
 
-static int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct *sigstruct,
-			 void *token)
+static int sgx_try_init(struct sgx_encl *encl, struct sgx_sigstruct *sigstruct,
+			void *token, u64 *lepubkeyhash)
+
 {
-	u64 mrsigner[4];
 	int ret;
 	int i;
 	int j;
 
-	/* Check that the required attributes have been authorized. */
-	if (encl->secs_attributes & ~encl->allowed_attributes)
-		return -EACCES;
-
-	ret = sgx_get_key_hash(sigstruct->modulus, mrsigner);
-	if (ret)
-		return ret;
-
 	mutex_lock(&encl->lock);
 
 	if (atomic_read(&encl->flags) & SGX_ENCL_INITIALIZED) {
@@ -637,7 +604,7 @@ static int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct *sigstruct,
 	for (i = 0; i < SGX_EINIT_SLEEP_COUNT; i++) {
 		for (j = 0; j < SGX_EINIT_SPIN_COUNT; j++) {
 			ret = sgx_einit(sigstruct, token, encl->secs.epc_page,
-					mrsigner);
+					lepubkeyhash);
 			if (ret == SGX_UNMASKED_EVENT)
 				continue;
 			else
@@ -673,6 +640,36 @@ static int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct *sigstruct,
 	return ret;
 }
 
+static int sgx_encl_init(struct sgx_encl *encl,
+			 struct sgx_sigstruct *sigstruct, void *token)
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
+	/* Check that the required attributes have been authorized. */
+	if (encl->secs_attributes & ~encl->allowed_attributes)
+		return -EACCES;
+
+	signer = mrsigner;
+	while (signcnt--) {
+		ret = sgx_try_init(encl, sigstruct, token, signer);
+		if (!ret)
+			return ret;
+		if (signcnt)
+			signer = sgx_policy_get_launch_signer(signer);
+	}
+
+	return ret;
+}
+
 /**
  * sgx_ioc_enclave_init - handler for %SGX_IOC_ENCLAVE_INIT
  *
@@ -708,7 +705,16 @@ static long sgx_ioc_enclave_init(struct sgx_encl *encl, void __user *arg)
 
 	sigstruct = kmap(initp_page);
 	token = (void *)((unsigned long)sigstruct + PAGE_SIZE / 2);
-	memset(token, 0, SGX_LAUNCH_TOKEN_SIZE);
+	if (!einit.token)
+		memset(token, 0, SGX_LAUNCH_TOKEN_SIZE);
+	else {
+		if (copy_from_user((uint8_t *) token,
+				   (void __user *) einit.token,
+				   SGX_LAUNCH_TOKEN_SIZE)) {
+			ret = -EFAULT;
+			goto out;
+		}
+	}
 
 	if (copy_from_user(sigstruct, (void __user *)einit.sigstruct,
 			   sizeof(*sigstruct))) {
diff --git a/arch/x86/kernel/cpu/sgx/policy.c b/arch/x86/kernel/cpu/sgx/policy.c
new file mode 100644
index 000000000000..04ff13e4ce73
--- /dev/null
+++ b/arch/x86/kernel/cpu/sgx/policy.c
@@ -0,0 +1,513 @@
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
+/**
+ * have_signer - Verify the presence presence of a key signer.
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
+		encl->allowed_attributes |= SGX_ATTR_PROVISIONKEY;
+
+	if (signing_keys_count > 0 &&
+	    have_signer(&signing_key_list, &signing_key_list_mutex, mrsigner))
+		goto have_signer;
+
+	if (encl->secs_attributes & SGX_ATTR_EINITTOKENKEY &&
+	    launch_keys_count > 0) {
+		if (have_signer(&launch_key_list, &launch_key_list_mutex,
+				 mrsigner)) {
+			encl->allowed_attributes |= SGX_ATTR_EINITTOKENKEY;
+			goto have_signer;
+		} else
+			goto no_signer;
+	}
+
+	if (launch_keys_count > 0) {
+		*signcnt = launch_keys_count;
+		kp = list_first_entry(&launch_key_list, struct list_key, list);
+		memcpy(mrsigner, kp->key, KEY_SIZE);
+	}
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
+ * sgx_policy_get_launch_signer - Iterate through list of enclave authorizers.
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
+u64 *sgx_policy_get_launch_signer(u64 *signer)
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
+	return 0;
+
+ err:
+	return retn;
+}
-- 
2.19.2

