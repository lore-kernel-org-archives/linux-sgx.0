Return-Path: <SRS0=EsRn=SU=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,T_HK_NAME_DR,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FA00C10F0E
	for <linux-sgx@archiver.kernel.org>; Thu, 18 Apr 2019 17:11:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B11F2171F
	for <linux-sgx@archiver.kernel.org>; Thu, 18 Apr 2019 17:11:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388401AbfDRRLl (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 18 Apr 2019 13:11:41 -0400
Received: from wind.enjellic.com ([76.10.64.91]:58362 "EHLO wind.enjellic.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388346AbfDRRLl (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 18 Apr 2019 13:11:41 -0400
Received: from wind.enjellic.com (localhost [127.0.0.1])
        by wind.enjellic.com (8.15.2/8.15.2) with ESMTP id x3IHB1sT023846;
        Thu, 18 Apr 2019 12:11:01 -0500
Received: (from greg@localhost)
        by wind.enjellic.com (8.15.2/8.15.2/Submit) id x3IHAxs5023845;
        Thu, 18 Apr 2019 12:10:59 -0500
Date:   Thu, 18 Apr 2019 12:10:59 -0500
From:   "Dr. Greg" <greg@enjellic.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        akpm@linux-foundation.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com
Subject: Re: [PATCH v20 00/28] Intel SGX1 support
Message-ID: <20190418171059.GA20819@wind.enjellic.com>
Reply-To: "Dr. Greg" <greg@enjellic.com>
References: <20190417103938.7762-1-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="SLDf9lqlvOQaIe6s"
Content-Disposition: inline
In-Reply-To: <20190417103938.7762-1-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.4i
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.2.3 (wind.enjellic.com [127.0.0.1]); Thu, 18 Apr 2019 12:11:01 -0500 (CDT)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 17, 2019 at 01:39:10PM +0300, Jarkko Sakkinen wrote:

Good morning, I hope this note finds the impending end of the work
week going well for everyone.

First of all, a thank you to Jarkko for his efforts in advancing this
driver, a process that can be decidedly thankless.  Our apologies in
advance for contributing to this phenomenon.

> Intel(R) SGX is a set of CPU instructions that can be used by
> applications to set aside private regions of code and data. The code
> outside the enclave is disallowed to access the memory inside the
> enclave by the CPU access control.  In a way you can think that SGX
> provides inverted sandbox. It protects the application from a
> malicious host.

Unfortunately, in its current implementation, the driver will not
protect a host from malicious enclaves.  If it advances in its current
form, the mainline Linux kernel will be implementing a driver with
known and documented security issues.

In addition, the driver breaks all existing SGX software by breaking
compatibility with what is a 3+ year ABI provided by the existing
driver.  This seems to contravene the well understood philosophy that
Linux doesn't, if at all possible, break existing applications,
something that we believe can be easily prevented if those interested
in these issues choose to read on.

The following reflections and code come from a team that has been
active in SGX development, since before hardware was even publically
available.  A team that has authored a complete re-implementation of
all of the SGX runtime infrastructure, which is the only consumer of
the services provided by an SGX driver.  A team that has also authored
and maintains a significant cohort of SGX based applications.  So I
believe we speak from a vantage point of experience with respect to
these issues and not from a 'bike-shedding' or political perspective.

The fundamental problem is that the proposed driver lacks an enclave
initialization policy mechanism consistent with the security
guarantees that SGX hardware is designed to deliver.  SGX is designed
to provide system architects a framework for building IAGO resistent
security architectures through the use of cryptographically defined
identities.

Other then an attempt to limit acccess to the PROVISION attribute, the
driver makes no attempt to regulate, in a cryptographically secure
fashion, what enclaves can be initialized, who can initialize them or
what characteristics they can be initialized with.  The security
implications of this were recently documented in a paper by
researchers at Graz, here is the link for those interested:

https://arxiv.org/pdf/1702.08719.pdf

Both the current controls for enclave access to the PROVISION
attribute and the security controls that are being proposed to emerge
for the driver, sometime in the future, suffer from being dependent on
discretionary access controls, ie. file privileges, that can be
defeated by a privilege escalation attack.  Those of us building
architectures on top of this technology have a need to certify that an
application will provide security contracts robust in the face of a
privilege escalation event or platform compromise.

To be very blunt, and my apologies for doing so, the design for this
driver has been driven by idealogy rather then by technology.  Our
focus with this e-mail and proposed driver modification is an attempt
to satisfy both technical requirements and political idealogy, if that
is even possible.

When we raised these issues six months ago, we were told that we were
handwaving bloat into the kernel.  We take a criticism like that very
seriously so we are returning with code, in what we believe is
'bloat-free' form.

The attached patch, against the jarkko-sgx/master branch of Jarkko's
driver repository, provides a framework that implements
cryptographically secure enclave initialization policies.  The patch
and it's signature are also available from the following URL's:

ftp://ftp.idfusion.net/pub/idfusion/jarkko-master-SFLC.patch

ftp://ftp.idfusion.net/pub/idfusion/jarkko-master-SFLC.patch.asc

The modification, in series form, is also available in the following
GIT repository:

git://git.idfusion.net/src/linux-sgx/in-tree jarkko-master-SFLC

The driver modification implements cryptographically secure enclave
initialization only if the platform owner chooses to do so and does
not limit the development of alternative strategies in the future.  It
also allows the platform owner to choose the ability to remain
compatible with existing runtimes and applications.

The policy architecture allows just about any conceivable
initialization policy to be implemented and in any combination.  It
supports both a plurality of launch enclaves as well as support for
multiple signing keys if a token-less approach is desired.  It also
provides cryptographically secure control of access to the PROVISION
attribute and the ability to completely block access to the attribute
if that is desired.

The driver modification has been extensively tested in all of these
scenarios, including combinations thereof.  We just completed a major
round of development that was based on Flexible Launch Control
platforms and deployed onto fixed launch control platforms using the
out-of-tree driver, without a need to maintain disparate runtimes.

On that note, given that the new driver API is completely incompatible
with all of the existing runtime software in the field, we believe the
issue of proper testing of this driver is an open problem.  I'm assuming
that Intel has a yet to be released PSW/SDK that supports the driver,
otherwise our enhancements to the driver is the only way that it can
experience legitimate field testing.

The interface for using the policy management framework is straight
forward.  The following three pseudo-files are available:

/sys/kernel/security/sgx/launch_keys

/sys/kernel/security/sgx/provisioning_keys

/sys/kernel/security/sgx/signing_keys

The SHA256 hashes of the cryptographic keys used to sign enclaves
(MRSIGNER values) are written into these files, ie, the following
command:

echo "SHA256_HASH" >| /sys/kernel/security/sgx/signing_keys

Would only allow enclaves to be initialized whose MRSIGNER value
matches the SHA256_HASH value.

The 'launch_keys' file maintains a list of signer signatures that are
allowed to initialize enclaves with the EINITTOKEN attribute set.

The 'provisioning_keys' file maintains a list of signer signatures
that are allowed to initialize enclaves with the PROVISION attribute
set.

Writing the 'lock' keyword to a file permanently blocks any further
directives from being recognized.  At that point, a very targeted
ring-0 attack would need to be conducted to circumvent the enclave
initialization policies.  This provides a framework that allows a
flexible launch control platform to attain the approximate security
guarantees offered by a fixed launch control platform.

If the platform owner chooses to do nothing, the driver will
initialize any enclave that is presented to it.  FWIW, we have close
to a century of enterprise system's administration experience on our
team and we could not envision any competent system's administrator,
concerned about security, who would allow such a configuration.

So that is how it all works, the changelogs in the GIT repository have
much more extensive documentation.  We fit the entire architecture
into approximately one page of memory, which seems to be a minor
amount of bloat for everyone getting to do whatever they want to do,
including leaving Linux mainline with a secure driver implementation.

Here is the diffstat:

---------------------------------------------------------------------------
 arch/x86/include/uapi/asm/sgx.h         |   2 +
 arch/x86/kernel/cpu/sgx/driver/Makefile |   1 +
 arch/x86/kernel/cpu/sgx/driver/driver.h |   7 +
 arch/x86/kernel/cpu/sgx/driver/ioctl.c  |  88 ++++-
 arch/x86/kernel/cpu/sgx/driver/main.c   |   5 +
 arch/x86/kernel/cpu/sgx/driver/policy.c | 584 ++++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/sgx/main.c          |  27 +-
 arch/x86/kernel/cpu/sgx/sgx.h           |   3 +-
 8 files changed, 704 insertions(+), 13 deletions(-)
---------------------------------------------------------------------------

With respect to a mainline Linux driver at large, an issue that we
believe needs clarification is whether or not a mandate will be issued
by Intel to OEM's that Flexible Launch Control is mandatory on all
platforms that are henceforth shipped.  Otherwise the mainline Linux
driver will be in the unenviable position of only working sporadically
and will not be a universal solution for all hardware.

We have a solution for that as well, but the above is probably enough
cannon fodder for debate so we will leave that sleeping dog lie for
the time being.

Hopefully all of the above is helpful for enhancing the quality of the
Linux SGX eco-system.

Best wishes for a productive weekend.

Dr. Greg

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"I can only provide the information, I can't make you hear it."
                                -- Shelley Bainter

--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="jarkko-master-SFLC.patch"

 arch/x86/include/uapi/asm/sgx.h         |   2 +
 arch/x86/kernel/cpu/sgx/driver/Makefile |   1 +
 arch/x86/kernel/cpu/sgx/driver/driver.h |   7 +
 arch/x86/kernel/cpu/sgx/driver/ioctl.c  |  88 ++++-
 arch/x86/kernel/cpu/sgx/driver/main.c   |   5 +
 arch/x86/kernel/cpu/sgx/driver/policy.c | 584 ++++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/sgx/main.c          |  27 +-
 arch/x86/kernel/cpu/sgx/sgx.h           |   3 +-
 8 files changed, 704 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
index 9ed690a38c70..694981e03c65 100644
--- a/arch/x86/include/uapi/asm/sgx.h
+++ b/arch/x86/include/uapi/asm/sgx.h
@@ -53,7 +53,9 @@ struct sgx_enclave_add_page {
  * @sigstruct:	address for the SIGSTRUCT data
  */
 struct sgx_enclave_init {
+	__u64	addr;
 	__u64	sigstruct;
+	__u64	einittoken;
 };
 
 /**
diff --git a/arch/x86/kernel/cpu/sgx/driver/Makefile b/arch/x86/kernel/cpu/sgx/driver/Makefile
index 01ebbbb06a47..ac7702201229 100644
--- a/arch/x86/kernel/cpu/sgx/driver/Makefile
+++ b/arch/x86/kernel/cpu/sgx/driver/Makefile
@@ -1,3 +1,4 @@
 obj-$(CONFIG_INTEL_SGX_DRIVER) += sgx.o
 sgx-$(CONFIG_INTEL_SGX_DRIVER) += ioctl.o
 sgx-$(CONFIG_INTEL_SGX_DRIVER) += main.o
+sgx-$(CONFIG_INTEL_SGX_DRIVER) += policy.o
diff --git a/arch/x86/kernel/cpu/sgx/driver/driver.h b/arch/x86/kernel/cpu/sgx/driver/driver.h
index 153b4a48aa6f..d5994c4aa65d 100644
--- a/arch/x86/kernel/cpu/sgx/driver/driver.h
+++ b/arch/x86/kernel/cpu/sgx/driver/driver.h
@@ -33,6 +33,13 @@ extern u32 sgx_xsave_size_tbl[64];
 
 extern const struct file_operations sgx_provision_fops;
 
+uint8_t * sgx_get_launch_signer(uint8_t *signature);
+int sgx_get_key_hash(const void *modulus, void *hash);
+bool sgx_launch_control(uint8_t *modulus);
+bool sgx_provisioning_control(uint8_t *modulus);
+bool sgx_signing_control(uint8_t *modulus);
+int sgx_policy_fs(void);
+void sgx_policy_fs_remove(void);
 long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg);
 
 #endif /* __ARCH_X86_INTEL_SGX_H__ */
diff --git a/arch/x86/kernel/cpu/sgx/driver/ioctl.c b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
index 3a01c3dd579d..0d758f1498f7 100644
--- a/arch/x86/kernel/cpu/sgx/driver/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/driver/ioctl.c
@@ -639,7 +639,17 @@ static int __sgx_get_key_hash(struct crypto_shash *tfm, const void *modulus,
 	return crypto_shash_digest(shash, modulus, SGX_MODULUS_SIZE, hash);
 }
 
-static int sgx_get_key_hash(const void *modulus, void *hash)
+/**
+* sgx_get_key_hash - Compute the hash of the enclave signer.
+*
+* @modulus:	A pointer to the signature modulus.
+* @hash:	A pointer to the signature buffer.
+*
+* Return:
+*   0 on success,
+*   Cryptographic subsystem error.
+*/
+int sgx_get_key_hash(const void *modulus, void *hash)
 {
 	struct crypto_shash *tfm;
 	int ret;
@@ -655,20 +665,26 @@ static int sgx_get_key_hash(const void *modulus, void *hash)
 }
 
 static int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct *sigstruct,
-			 struct sgx_einittoken *token)
+			 struct sgx_einittoken *token, bool use_lc)
 {
 	u64 mrsigner[4];
 	int ret;
 	int i;
 	int j;
+	uint8_t *(*get_signer)(uint8_t *) = NULL;
 
 	/* Check that the required attributes have been authorized. */
 	if (encl->secs_attributes & ~encl->allowed_attributes)
 		return -EINVAL;
 
-	ret = sgx_get_key_hash(sigstruct->modulus, mrsigner);
-	if (ret)
-		return ret;
+	if (use_lc)
+		get_signer = sgx_get_launch_signer;
+	else {
+		pr_debug("%s: Using modulus signature.\n", __FILE__);
+		ret = sgx_get_key_hash(sigstruct->modulus, mrsigner);
+		if (ret)
+			return ret;
+	}
 
 	flush_work(&encl->work);
 
@@ -683,7 +699,7 @@ static int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct *sigstruct,
 	for (i = 0; i < SGX_EINIT_SLEEP_COUNT; i++) {
 		for (j = 0; j < SGX_EINIT_SPIN_COUNT; j++) {
 			ret = sgx_einit(sigstruct, token, encl->secs.epc_page,
-					mrsigner);
+					mrsigner, get_signer);
 			if (ret == SGX_UNMASKED_EVENT)
 				continue;
 			else
@@ -737,6 +753,7 @@ static int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct *sigstruct,
 static long sgx_ioc_enclave_init(struct file *filep, unsigned int cmd,
 				 unsigned long arg)
 {
+	bool use_sc, use_lc, use_pc;
 	struct sgx_enclave_init *initp = (struct sgx_enclave_init *)arg;
 	struct sgx_encl *encl = filep->private_data;
 	struct sgx_einittoken *einittoken;
@@ -744,6 +761,25 @@ static long sgx_ioc_enclave_init(struct file *filep, unsigned int cmd,
 	struct page *initp_page;
 	int ret;
 
+	use_sc = sgx_signing_control(NULL);
+	pr_debug("%s: Signing control status: %s\n", __FILE__,
+		 use_sc ? "active" : "disabled");
+
+	use_lc = sgx_launch_control(NULL);
+	pr_debug("%s: Launch control status: %s\n", __FILE__,
+		 use_lc ? "active" : "disabled");
+
+	use_pc = sgx_provisioning_control(NULL);
+	pr_debug("%s: Provisioning control status: %s\n", __FILE__,
+		 use_pc ? "active" : "disabled");
+
+	if (!use_sc) {
+		if (initp->einittoken != 0 && !use_lc)
+			return -EINVAL;
+		if (initp->einittoken == 0 && use_lc)
+			return -EINVAL;
+	}
+
 	initp_page = alloc_page(GFP_HIGHUSER);
 	if (!initp_page)
 		return -ENOMEM;
@@ -751,7 +787,16 @@ static long sgx_ioc_enclave_init(struct file *filep, unsigned int cmd,
 	sigstruct = kmap(initp_page);
 	einittoken = (struct sgx_einittoken *)
 		((unsigned long)sigstruct + PAGE_SIZE / 2);
-	memset(einittoken, 0, sizeof(*einittoken));
+	if ( !initp->einittoken )
+		memset(einittoken, 0, sizeof(*einittoken));
+	else {
+		if (copy_from_user(einittoken,
+				   (void __user *)initp->einittoken,
+				   sizeof(*einittoken))) {
+			ret = -EFAULT;
+			goto out;
+		}
+	}
 
 	if (copy_from_user(sigstruct, (void __user *)initp->sigstruct,
 			   sizeof(*sigstruct))) {
@@ -759,8 +804,35 @@ static long sgx_ioc_enclave_init(struct file *filep, unsigned int cmd,
 		goto out;
 	}
 
+	if (!use_lc && (sigstruct->body.attributes & SGX_ATTR_EINITTOKENKEY)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if ((sigstruct->body.attributes & SGX_ATTR_EINITTOKENKEY) &&
+	    sgx_launch_control(sigstruct->modulus))
+		encl->allowed_attributes |= SGX_ATTR_EINITTOKENKEY;
+
+	if (!use_pc)
+		encl->allowed_attributes |= SGX_ATTR_PROVISIONKEY;
+	else {
+		if ((sigstruct->body.attributes & SGX_ATTR_PROVISIONKEY) &&
+		    sgx_provisioning_control(sigstruct->modulus))
+			encl->allowed_attributes |= SGX_ATTR_PROVISIONKEY;
+	}
+
+	if (use_sc) {
+		use_sc = sgx_signing_control(sigstruct->modulus);
+		if (!use_sc && !use_lc) {
+			ret = -EINVAL;
+			goto out;
+		}
+		if (use_sc)
+			use_lc = false;
+	}
+
+	ret = sgx_encl_init(encl, sigstruct, einittoken, use_lc);
 
-	ret = sgx_encl_init(encl, sigstruct, einittoken);
 
 out:
 	kunmap(initp_page);
diff --git a/arch/x86/kernel/cpu/sgx/driver/main.c b/arch/x86/kernel/cpu/sgx/driver/main.c
index afe844aa81d6..503c2a9728ec 100644
--- a/arch/x86/kernel/cpu/sgx/driver/main.c
+++ b/arch/x86/kernel/cpu/sgx/driver/main.c
@@ -348,6 +348,10 @@ static int __init sgx_drv_init(void)
 {
 	int ret;
 
+	ret = sgx_policy_fs();
+	if (ret)
+		return ret;
+
 	ret = sgx_drv_subsys_init();
 	if (ret)
 		return ret;
@@ -362,6 +366,7 @@ module_init(sgx_drv_init);
 
 static void __exit sgx_drv_exit(void)
 {
+	sgx_policy_fs_remove();
 	platform_driver_unregister(&sgx_drv);
 	sgx_drv_subsys_exit();
 }
diff --git a/arch/x86/kernel/cpu/sgx/driver/policy.c b/arch/x86/kernel/cpu/sgx/driver/policy.c
new file mode 100644
index 000000000000..c72b1604c1fa
--- /dev/null
+++ b/arch/x86/kernel/cpu/sgx/driver/policy.c
@@ -0,0 +1,584 @@
+// SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause)
+// Copyright(c) IDfusion, LLC
+
+#define KEY_SIZE 32
+
+#include <linux/types.h>
+#include <linux/seq_file.h>
+#include <linux/atomic.h>
+#include <linux/security.h>
+#include "driver.h"
+
+/* Variables for launch key management. */
+struct list_key {
+	struct list_head list;
+	uint8_t key[KEY_SIZE];
+};
+
+static struct dentry *sgx_fs;
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
+/**
+ * sgx_launch_control - Launch Control policy status
+ *
+ * Verifies whether or not launch control is active.
+ *
+ * Return:
+ *   0 No launch control is authorized.
+ *   1 Launch control is permitted.
+ */
+bool sgx_launch_control(uint8_t *modulus)
+{
+	bool retn = false;
+	uint8_t mrsigner[KEY_SIZE];
+
+	if (modulus == NULL) {
+		retn = launch_keys_count > 0;
+		goto done;
+	}
+
+	pr_debug("%s: Verifying launch control modulus.\n", __func__);
+	if (sgx_get_key_hash(modulus, mrsigner))
+		goto done;
+	retn = have_signer(&launch_key_list, &launch_key_list_mutex, mrsigner);
+
+ done:
+	return retn;
+}
+
+/**
+ * sgx_get_launch_signer - Iterate through list of enclave authorizers.
+ *
+ * @signer:	The last returned enclave signer.
+ *
+ * This function iterates through the list of enclave signers from the
+ * last signature.  Calling the function with a NULL signer value
+ * resets the iteration to the beginning of the list.
+ *
+ * Return:
+ *   NULL indicates end of list
+ *   non-NULL the next enclave signature on the list.
+ */
+
+uint8_t * sgx_get_launch_signer(uint8_t *signature)
+{
+	bool seeking = false;
+	uint8_t *retn = NULL;
+	struct list_key *kp;
+
+	if (!signature) {
+		kp = list_first_entry(&launch_key_list, struct list_key, list);
+		return kp->key;
+	}
+
+	kp = list_last_entry(&launch_key_list, struct list_key, list);
+	if ( memcmp(kp->key, signature, sizeof(kp->key)) == 0 )
+		return NULL;
+
+	mutex_lock(&launch_key_list_mutex);
+	list_for_each_entry(kp, &launch_key_list, list) {
+		if (seeking) {
+			retn = kp->key;
+			goto done;
+		}
+		pr_debug("%s: Skipping: %*phN\n", __func__, KEY_SIZE, kp->key);
+		if (memcmp(kp->key, signature, KEY_SIZE) == 0)
+			seeking = true;
+	}
+
+ done:
+	mutex_unlock(&launch_key_list_mutex);
+	return retn;
+}
+
+/**
+ * sgx_provisioning_control - Provisioning control verification.
+ *
+ * This function returns a true value if provision control is active
+ * and the signature of the modulus of the signing key for an enclave
+ * with the PROVISION bit set is on the list of approved keys.
+ *
+ * Return:
+ *   0 No provisioning control is authorized.
+ *   1 Provisioning is authorized for the enclave.
+ */
+bool sgx_provisioning_control(uint8_t *modulus)
+{
+	bool retn = false;
+	uint8_t mrsigner[KEY_SIZE];
+
+	if (modulus == NULL) {
+		retn = provision_keys_count > 0;
+		goto done;
+	}
+
+	pr_debug("Verifying provisioning control signature.\n");
+	if (sgx_get_key_hash(modulus, mrsigner))
+		goto done;
+	retn = have_signer(&provision_key_list, &provision_key_list_mutex,
+			   mrsigner);
+
+ done:
+	return retn;
+}
+
+/**
+ * sgx_signing_control - Signing control verification.
+ *
+ * This function returns a true value if signing control is active
+ * and the signature of the modulus of the signing key for an enclave
+ * is on the list of approved keys.
+ *
+ * Return:
+ *   0 No signing control is authorized.
+ *   1 Signing is authorized for the enclave.
+ */
+bool sgx_signing_control(uint8_t *modulus)
+{
+	bool retn = false;
+	uint8_t mrsigner[KEY_SIZE];
+
+	if (modulus == NULL) {
+		retn = signing_keys_count > 0;
+		goto done;
+	}
+
+	pr_debug("Verifying signing control signature.\n");
+	if (sgx_get_key_hash(modulus, mrsigner))
+		goto done;
+	retn = have_signer(&signing_key_list, &signing_key_list_mutex,
+			   mrsigner);
+
+ done:
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
+	if ( strcmp(bufr, "lock") != 0 )
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
+	if ( strcmp(bufr, "clear") != 0 )
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
+static int process_dump(const char __user *buf, size_t datalen, char *type,
+			struct mutex *lock, struct list_head *keylist)
+{
+	char bufr[5];
+	struct list_key *kp;
+
+	if (datalen != strlen("dump") + 1)
+		return 0;
+
+	memset(bufr, '\0', sizeof(bufr));
+	if (copy_from_user(bufr, buf, datalen-1))
+		return -EFAULT;
+	if ( strcmp(bufr, "dump") != 0 )
+		return 0;
+
+	pr_info("SGX %s keys:\n", type);
+	mutex_lock(lock);
+	list_for_each_entry(kp, keylist, list) {
+		pr_info("SGX %s: %*phN\n", type, KEY_SIZE, kp->key);
+	}
+	mutex_unlock(lock);
+
+	return datalen;
+}
+
+static int open_launch_keys(struct inode * inode, struct file * filp)
+{
+	if (!(filp->f_flags & O_WRONLY))
+		return -EACCES;
+	if (atomic_dec_and_test(&launch_keys_opencount))
+		return 0;
+	return -EBUSY;
+}
+
+static ssize_t write_launch_keys(struct file *file, const char __user *buf,
+				 size_t datalen, loff_t *ppos)
+{
+	ssize_t retn;
+
+	if (launch_keys_locked) {
+		retn = -EINVAL;
+		goto done;
+	}
+
+	if (*ppos != 0) {
+		retn = -EINVAL;
+		goto done;
+	}
+
+	retn = process_lock(buf, datalen, &launch_keys_locked);
+	if (retn != 0)
+		return retn;
+
+	retn = process_clear(buf, datalen, "launch control",
+			     &launch_keys_count, &launch_key_list_mutex,
+			     &launch_key_list);
+	if (retn != 0)
+		return retn;
+
+	retn = process_dump(buf, datalen, "lc", &launch_key_list_mutex,
+			    &launch_key_list);
+	if (retn != 0)
+		return retn;
+
+	retn = process_write_key(buf, datalen, &launch_keys_count,
+				 &launch_key_list_mutex, &launch_key_list);
+
+done:
+	return retn;
+}
+
+static int release_launch_keys(struct inode *inode, struct file *file)
+{
+	atomic_set(&launch_keys_opencount, 1);
+	return 0;
+}
+
+static const struct file_operations launch_keys_ops = {
+	.open = open_launch_keys,
+	.write = write_launch_keys,
+	.release = release_launch_keys,
+	.llseek = generic_file_llseek,
+};
+
+/* Provisioning control. */
+
+static int open_provision_keys(struct inode * inode, struct file * filp)
+{
+	if (!(filp->f_flags & O_WRONLY))
+		return -EACCES;
+	if (atomic_dec_and_test(&provision_keys_opencount))
+		return 0;
+	return -EBUSY;
+}
+
+static ssize_t write_provision_keys(struct file *file, const char __user *buf,
+				    size_t datalen, loff_t *ppos)
+{
+	ssize_t retn;
+
+	if (provision_keys_locked) {
+		retn = -EINVAL;
+		goto done;
+	}
+
+	if (*ppos != 0) {
+		retn = -EINVAL;
+		goto done;
+	}
+
+	retn = process_lock(buf, datalen, &provision_keys_locked);
+	if (retn != 0)
+		return retn;
+
+	retn = process_clear(buf, datalen, "provisioning control",
+			     &provision_keys_count, &provision_key_list_mutex,
+			     &provision_key_list);
+	if (retn != 0)
+		return retn;
+
+	retn = process_dump(buf, datalen, "pc", &provision_key_list_mutex,
+			    &provision_key_list);
+	if (retn != 0)
+		return retn;
+
+	retn = process_write_key(buf, datalen, &provision_keys_count,
+				 &provision_key_list_mutex,
+				 &provision_key_list);
+done:
+	return retn;
+}
+
+static int release_provision_keys(struct inode *inode, struct file *file)
+{
+	atomic_set(&provision_keys_opencount, 1);
+	return 0;
+}
+
+static const struct file_operations provision_keys_ops = {
+	.open = open_provision_keys,
+	.write = write_provision_keys,
+	.release = release_provision_keys,
+	.llseek = generic_file_llseek,
+};
+
+/*
+ * Signing control.
+ */
+
+static int open_signing_keys(struct inode * inode, struct file * filp)
+{
+	if (!(filp->f_flags & O_WRONLY))
+		return -EACCES;
+	if (atomic_dec_and_test(&signing_keys_opencount))
+		return 0;
+	return -EBUSY;
+}
+
+static ssize_t write_signing_keys(struct file *file, const char __user *buf,
+				  size_t datalen, loff_t *ppos)
+{
+	ssize_t retn;
+
+	if (signing_keys_locked) {
+		retn = -EINVAL;
+		goto done;
+	}
+
+	if (*ppos != 0) {
+		retn = -EINVAL;
+		goto done;
+	}
+
+	retn = process_lock(buf, datalen, &signing_keys_locked);
+	if (retn != 0)
+		return retn;
+
+	retn = process_clear(buf, datalen, "signing control",
+			     &signing_keys_count, &signing_key_list_mutex,
+			     &signing_key_list);
+	if (retn != 0)
+		return retn;
+
+	retn = process_dump(buf, datalen, "sc", &signing_key_list_mutex,
+			    &signing_key_list);
+	if (retn != 0)
+		return retn;
+
+	retn = process_write_key(buf, datalen, &signing_keys_count,
+				 &signing_key_list_mutex, &signing_key_list);
+done:
+	return retn;
+}
+
+static int release_signing_keys(struct inode *inode, struct file *file)
+{
+	atomic_set(&signing_keys_opencount, 1);
+	return 0;
+}
+
+static const struct file_operations signing_keys_ops = {
+	.open = open_signing_keys,
+	.write = write_signing_keys,
+	.release = release_signing_keys,
+	.llseek = generic_file_llseek,
+};
+
+int sgx_policy_fs(void)
+{
+	int retn = -1;
+
+	sgx_fs = securityfs_create_dir("sgx", NULL);
+	if(IS_ERR(sgx_fs)) {
+		retn = PTR_ERR(sgx_fs);
+		goto err;
+	}
+
+	launch_keys = securityfs_create_file("launch_keys", S_IWUSR | S_IRUSR,
+					     sgx_fs, NULL, &launch_keys_ops);
+	if (IS_ERR(launch_keys)) {
+		retn = PTR_ERR(launch_keys);
+		goto err;
+	}
+
+	provision_keys = securityfs_create_file("provisioning_keys",
+						S_IWUSR | S_IRUSR,
+						sgx_fs, NULL,
+						&provision_keys_ops);
+	if (IS_ERR(provision_keys)) {
+		retn = PTR_ERR(provision_keys);
+		goto err;
+	}
+
+	signing_keys = securityfs_create_file("signing_keys",
+					      S_IWUSR | S_IRUSR,
+					      sgx_fs, NULL,
+					      &signing_keys_ops);
+	if (IS_ERR(signing_keys)) {
+		retn = PTR_ERR(signing_keys);
+		goto err;
+	}
+
+	return 0;
+
+ err:
+	securityfs_remove(launch_keys);
+	securityfs_remove(provision_keys);
+	securityfs_remove(signing_keys);
+	securityfs_remove(sgx_fs);
+	return retn;
+}
+
+void sgx_policy_fs_remove(void)
+{
+	struct list_key *kp, *kp_tmp;
+
+	mutex_lock(&launch_key_list_mutex);
+	list_for_each_entry_safe(kp, kp_tmp, &launch_key_list, list) {
+		list_del(&kp->list);
+		kfree(kp);
+	}
+	mutex_unlock(&launch_key_list_mutex);
+
+	mutex_lock(&provision_key_list_mutex);
+	list_for_each_entry_safe(kp, kp_tmp, &provision_key_list, list) {
+		list_del(&kp->list);
+		kfree(kp);
+	}
+	mutex_unlock(&provision_key_list_mutex);
+
+	mutex_lock(&signing_key_list_mutex);
+	list_for_each_entry_safe(kp, kp_tmp, &signing_key_list, list) {
+		list_del(&kp->list);
+		kfree(kp);
+	}
+	mutex_unlock(&signing_key_list_mutex);
+
+	securityfs_remove(launch_keys);
+	securityfs_remove(provision_keys);
+	securityfs_remove(signing_keys);
+	securityfs_remove(sgx_fs);
+}
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 07adb35c260b..c5a9df27702c 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -189,6 +189,8 @@ static void sgx_update_lepubkeyhash_msrs(u64 *lepubkeyhash, bool enforce)
  * @token:		a pointer an EINITTOKEN (optional)
  * @secs:		a pointer a SECS
  * @lepubkeyhash:	the desired value for IA32_SGXLEPUBKEYHASHx MSRs
+ * @launch_signer:	a pointer to a function returning possible
+ *			launch signers
  *
  * Execute ENCLS[EINIT], writing the IA32_SGXLEPUBKEYHASHx MSRs according
  * to @lepubkeyhash (if possible and necessary).
@@ -198,13 +200,30 @@ static void sgx_update_lepubkeyhash_msrs(u64 *lepubkeyhash, bool enforce)
  *   -errno or SGX error on failure
  */
 int sgx_einit(struct sgx_sigstruct *sigstruct, struct sgx_einittoken *token,
-	      struct sgx_epc_page *secs, u64 *lepubkeyhash)
+	      struct sgx_epc_page *secs, u64 *lepubkeyhash,
+	      uint8_t * (*launch_signer)(uint8_t *))
 {
 	int ret;
+	uint8_t *signer;
+
+	if (launch_signer) {
+		signer = (*launch_signer)(NULL);
+		while (signer) {
+			pr_debug("%s: Trying signer: %*phN\n", __FILE__, 32,
+				 signer);
+			preempt_disable();
+			sgx_update_lepubkeyhash_msrs((u64 *) signer, true);
+			ret = __einit(sigstruct, token, sgx_epc_addr(secs));
+			preempt_enable();
+			if (!ret)
+				return ret;
+			signer = (*launch_signer)(signer);
+		}
+		return ret;
+	}
 
-	if (!boot_cpu_has(X86_FEATURE_SGX_LC))
-		return __einit(sigstruct, token, sgx_epc_addr(secs));
-
+	pr_debug("%s: Setting LC register for EINIT to: %*phN.\n", __FILE__,
+		 32, lepubkeyhash);
 	preempt_disable();
 	sgx_update_lepubkeyhash_msrs(lepubkeyhash, false);
 	ret = __einit(sigstruct, token, sgx_epc_addr(secs));
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index 8a1dff1e5e8a..50fc9ee9d556 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -85,6 +85,7 @@ struct sgx_epc_page *sgx_alloc_page(void *owner, bool reclaim);
 int __sgx_free_page(struct sgx_epc_page *page);
 void sgx_free_page(struct sgx_epc_page *page);
 int sgx_einit(struct sgx_sigstruct *sigstruct, struct sgx_einittoken *token,
-	      struct sgx_epc_page *secs, u64 *lepubkeyhash);
+	      struct sgx_epc_page *secs, u64 *lepubkeyhash,
+	      uint8_t *(*get_signer)(uint8_t *));
 
 #endif /* _X86_SGX_H */

--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="jarkko-master-SFLC.patch.asc"

-----BEGIN PGP SIGNATURE-----

iQEcBAABAgAGBQJct1mVAAoJEP1SNsFLeja67mYIAKWtG2bydNO9J9aMYBHegc/b
0uMms4rP6o5YRDoOVKMMyP5etoTQ2jRv1RUEukghnvHyMdEaad2JXcASiWmzrXTy
lQXQlb8ejIc6C2PpCPmxB9pCV8ZtSTkoCsWgc4KvgjVtCJVbamx40CqvBoibcf+9
/nFKuqhXho163cT9PdKTWuxB5vgpaMUhtediEa2NhiTp6vfsCv9VZmWTf5OpTrIc
h4ENGcHR6kJGnmbCTJlwzPgmZA2yK929MkFlOObhkexTG5xxTZlRxaveQX0QToz8
uzZ44c6a5IckNeD9yykyuC1vXdgV1tYlVJYGWhBZYMFwH2YkGsws7hlKfu51Tqw=
=8RH8
-----END PGP SIGNATURE-----

--SLDf9lqlvOQaIe6s--
