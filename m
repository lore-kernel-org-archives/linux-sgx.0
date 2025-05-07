Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523171EB2F;
	Wed,  7 May 2025 11:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746616569; cv=none; b=C/tQ1QTBiwxjPR1T1QFkftqSXMuLxeFdepuw3Wb9fLsKKXHiMPT7WoqvlqcDi5FZkHgzj/AVaOpuzykBGuxjOFkKoE+JVBmr+uvdB8qn54xmmzMjXaWeYlsGDv+f/fzAW8RPrONlIhOjTSCCX5PIaLbk7/IwDodpVlQO8J1+qO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746616569; c=relaxed/simple;
	bh=J6gTG3oPmT4DFdI0qqYRNpf3i0gDCx22v2ClTR4WLlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WfD+7yy6tzKoWZyb2CVT+qkpLzMrass5p8jYaIjOHxhFnVcTTmCu9pkqbhxDpDGveeqMzVfMdLSi6isfECt6GUZlV/EqcHzWwxOnnErbeZ+lj3GhT2xoVzBX/SpWXNd8SMSqCgny9lwHrqjGufsIZZkY37X/lmtpLTNwOX0DNn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=V/ldB6Li; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="V/ldB6Li"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746616567; x=1778152567;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=J6gTG3oPmT4DFdI0qqYRNpf3i0gDCx22v2ClTR4WLlk=;
  b=V/ldB6LinXnlzwE478cJ/mfuN/UFlR+VwIGk9LMpc4UNiST8d178mAAZ
   UunsJp/Ynkm4YcaZFSJnWsHPza0W2qkhyEEBjlqwNG4/SINMaL8ldLV5/
   YZDeGuvxeP6Z2n6GGrPZWD8A0l3qc7nxQ/HySnm4/A5VumiYRgbswfHo1
   occ1W2IPV7XWnEgow7ebkptPFerapqt6YvjRxcsIawbK5D/CNqkjU182g
   Ls6b8sOnHjA7OHk0UykbSnXXJQb82SwA7DmEaH2dhQU4pi661lVmZdtE0
   4lxVuFDlWIYl64B9W2XvCAooydDZfCleDkUgayb+xIkeHAPBCPY8aCyEz
   Q==;
X-CSE-ConnectionGUID: +5q92N6vSje6mdupbI4bAw==
X-CSE-MsgGUID: oX80uzLxQ3u0YiTqJgigJw==
X-IronPort-AV: E=McAfee;i="6700,10204,11425"; a="59327518"
X-IronPort-AV: E=Sophos;i="6.15,269,1739865600"; 
   d="scan'208";a="59327518"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2025 04:16:07 -0700
X-CSE-ConnectionGUID: W7l3Qdh1SeWZE7DnQOJVIA==
X-CSE-MsgGUID: 0sWnfHa6R222SaJaS2oHYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,269,1739865600"; 
   d="scan'208";a="135637647"
Received: from smoticic-mobl1.ger.corp.intel.com (HELO eresheto-mobl3.ger.corp.intel.com) ([10.245.245.23])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2025 04:16:02 -0700
From: Elena Reshetova <elena.reshetova@intel.com>
To: dave.hansen@intel.com
Cc: jarkko@kernel.org,
	seanjc@google.com,
	kai.huang@intel.com,
	linux-sgx@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	asit.k.mallick@intel.com,
	vincent.r.scarlata@intel.com,
	chongc@google.com,
	erdemaktas@google.com,
	vannapurve@google.com,
	dionnaglaze@google.com,
	bondarn@google.com,
	scott.raynor@intel.com,
	Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH v4 1/1] x86/sgx: Enable automatic SVN updates for SGX enclaves
Date: Wed,  7 May 2025 14:14:00 +0300
Message-ID: <20250507111542.709858-2-elena.reshetova@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250507111542.709858-1-elena.reshetova@intel.com>
References: <20250507111542.709858-1-elena.reshetova@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In case an SGX vulnerability is discovered and TCB recovery
for SGX is triggered, Intel specifies a process that must be
followed for a given vulnerability. Steps to mitigate can vary
based on vulnerability type, affected components, etc.
In some cases, a vulnerability can be mitigated via a runtime
recovery flow by shutting down all running SGX enclaves,
clearing enclave page cache (EPC), applying a microcode patch
that does not require a reboot (via late microcode loading) and
restarting all SGX enclaves.

Even when the above-described runtime recovery flow to mitigate the
SGX vulnerability is followed, the SGX attestation evidence will
still reflect the security SVN version being equal to the previous
state of security SVN (containing vulnerability) that created
and managed the enclave until the runtime recovery event. This
limitation currently can be only overcome via a platform reboot,
which negates all the benefits from the rebootless late microcode
loading and not required in this case for functional or security
purposes.

SGX architecture introduced a new instruction called ENCLS[EUPDATESVN]
to Ice Lake [1]. It allows updating security SVN version, given that EPC
is completely empty. The latter is required for security reasons
in order to reason that enclave security posture is as secure as the
security SVN version of the TCB that created it.

Additionally it is important to ensure that while ENCLS[EUPDATESVN]
runs, no concurrent page creation happens in EPC, because it might
result in #GP delivered to the creator. Legacy SW might not be prepared
to handle such unexpected #GPs and therefore this patch introduces
a locking mechanism in sgx_(vepc_)open to ensure no concurrent EPC
allocations can happen.

Implement ENCLS[EUPDATESVN] and enable kernel to opportunistically
call it during sgx_(vepc_)open().
The patch is loosely based on previous submission by Cathy Zhang [2].

[1]
https://cdrdv2.intel.com/v1/dl/getContent/648682?explicitVersion=true
[2]
https://lore.kernel.org/all/20220520103904.1216-1-cathy.zhang@intel.com/

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
---
 arch/x86/include/asm/sgx.h       | 42 ++++++++++++-------
 arch/x86/kernel/cpu/sgx/driver.c |  4 ++
 arch/x86/kernel/cpu/sgx/encl.c   |  1 +
 arch/x86/kernel/cpu/sgx/encls.h  |  5 +++
 arch/x86/kernel/cpu/sgx/main.c   | 70 ++++++++++++++++++++++++++++++++
 arch/x86/kernel/cpu/sgx/sgx.h    |  3 ++
 arch/x86/kernel/cpu/sgx/virt.c   |  6 +++
 7 files changed, 116 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
index 6a0069761508..8ac026ef6365 100644
--- a/arch/x86/include/asm/sgx.h
+++ b/arch/x86/include/asm/sgx.h
@@ -27,22 +27,26 @@
 /* The bitmask for the EPC section type. */
 #define SGX_CPUID_EPC_MASK	GENMASK(3, 0)
 
+/* EUPDATESVN support in CPUID.0x12.0.EAX */
+#define SGX_CPUID_EUPDATESVN	BIT(10)
+
 enum sgx_encls_function {
-	ECREATE	= 0x00,
-	EADD	= 0x01,
-	EINIT	= 0x02,
-	EREMOVE	= 0x03,
-	EDGBRD	= 0x04,
-	EDGBWR	= 0x05,
-	EEXTEND	= 0x06,
-	ELDU	= 0x08,
-	EBLOCK	= 0x09,
-	EPA	= 0x0A,
-	EWB	= 0x0B,
-	ETRACK	= 0x0C,
-	EAUG	= 0x0D,
-	EMODPR	= 0x0E,
-	EMODT	= 0x0F,
+	ECREATE		= 0x00,
+	EADD		= 0x01,
+	EINIT		= 0x02,
+	EREMOVE		= 0x03,
+	EDGBRD		= 0x04,
+	EDGBWR		= 0x05,
+	EEXTEND		= 0x06,
+	ELDU		= 0x08,
+	EBLOCK		= 0x09,
+	EPA			= 0x0A,
+	EWB			= 0x0B,
+	ETRACK		= 0x0C,
+	EAUG		= 0x0D,
+	EMODPR		= 0x0E,
+	EMODT		= 0x0F,
+	EUPDATESVN	= 0x18,
 };
 
 /**
@@ -73,6 +77,11 @@ enum sgx_encls_function {
  *				public key does not match IA32_SGXLEPUBKEYHASH.
  * %SGX_PAGE_NOT_MODIFIABLE:	The EPC page cannot be modified because it
  *				is in the PENDING or MODIFIED state.
+ * %SGX_INSUFFICIENT_ENTROPY:	Insufficient entropy in RNG.
+ * %SGX_EPC_NOT_READY:			EPC is not ready for SVN update.
+ * %SGX_NO_UPDATE:		EUPDATESVN was successful, but CPUSVN was not
+ *				updated because current SVN was not newer than
+ *				CPUSVN.
  * %SGX_UNMASKED_EVENT:		An unmasked event, e.g. INTR, was received
  */
 enum sgx_return_code {
@@ -81,6 +90,9 @@ enum sgx_return_code {
 	SGX_CHILD_PRESENT		= 13,
 	SGX_INVALID_EINITTOKEN		= 16,
 	SGX_PAGE_NOT_MODIFIABLE		= 20,
+	SGX_INSUFFICIENT_ENTROPY	= 29,
+	SGX_EPC_NOT_READY			= 30,
+	SGX_NO_UPDATE				= 31,
 	SGX_UNMASKED_EVENT		= 128,
 };
 
diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx/driver.c
index 7f8d1e11dbee..669e44d61f9f 100644
--- a/arch/x86/kernel/cpu/sgx/driver.c
+++ b/arch/x86/kernel/cpu/sgx/driver.c
@@ -19,6 +19,10 @@ static int sgx_open(struct inode *inode, struct file *file)
 	struct sgx_encl *encl;
 	int ret;
 
+	ret = sgx_inc_usage_count();
+	if (ret)
+		return ret;
+
 	encl = kzalloc(sizeof(*encl), GFP_KERNEL);
 	if (!encl)
 		return -ENOMEM;
diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 279148e72459..3b54889ae4a4 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -765,6 +765,7 @@ void sgx_encl_release(struct kref *ref)
 	WARN_ON_ONCE(encl->secs.epc_page);
 
 	kfree(encl);
+	sgx_dec_usage_count();
 }
 
 /*
diff --git a/arch/x86/kernel/cpu/sgx/encls.h b/arch/x86/kernel/cpu/sgx/encls.h
index 99004b02e2ed..788acf8ec563 100644
--- a/arch/x86/kernel/cpu/sgx/encls.h
+++ b/arch/x86/kernel/cpu/sgx/encls.h
@@ -233,4 +233,9 @@ static inline int __eaug(struct sgx_pageinfo *pginfo, void *addr)
 	return __encls_2(EAUG, pginfo, addr);
 }
 
+/* Update CPUSVN at runtime. */
+static inline int __eupdatesvn(void)
+{
+	return __encls_ret_1(EUPDATESVN, "");
+}
 #endif /* _X86_ENCLS_H */
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 8ce352fc72ac..2872567cd22b 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -15,6 +15,7 @@
 #include <linux/sysfs.h>
 #include <linux/vmalloc.h>
 #include <asm/sgx.h>
+#include <asm/archrandom.h>
 #include "driver.h"
 #include "encl.h"
 #include "encls.h"
@@ -914,6 +915,73 @@ int sgx_set_attribute(unsigned long *allowed_attributes,
 }
 EXPORT_SYMBOL_GPL(sgx_set_attribute);
 
+static bool sgx_has_eupdatesvn;
+static atomic_t sgx_usage_count;
+static DEFINE_MUTEX(sgx_svn_lock);
+
+/**
+ * sgx_updatesvn() - Issue ENCLS[EUPDATESVN]
+ * If EPC is empty, this instruction will update CPUSVN to the currently
+ * loaded microcode update SVN and generate new cryptographic assets.
+ *
+ * Return:
+ * 0: Success or not supported
+ * errno on error
+ */
+static int sgx_update_svn(void)
+{
+	int retry = RDRAND_RETRY_LOOPS;
+	int ret;
+
+	if (!sgx_has_eupdatesvn)
+		return 0;
+
+	do {
+		ret = __eupdatesvn();
+	} while (ret == SGX_INSUFFICIENT_ENTROPY && --retry);
+
+	if (!ret || ret == SGX_NO_UPDATE) {
+		/*
+		 * SVN successfully updated, or it was already up-to-date.
+		 * Let users know when the update was successful.
+		 */
+		if (!ret)
+			pr_info("SVN updated successfully\n");
+		return 0;
+	}
+
+	/*
+	 * EUPDATESVN was called when EPC is empty, all other error
+	 * codes are unexcepted except running out of entropy.
+	 */
+	if (ret != SGX_INSUFFICIENT_ENTROPY)
+		ENCLS_WARN(ret, "EUPDATESVN");
+	return ret;
+}
+
+int sgx_inc_usage_count(void)
+{
+	int ret;
+
+	if (atomic_inc_not_zero(&sgx_usage_count))
+		return 0;
+
+	guard(mutex)(&sgx_svn_lock);
+
+	if (atomic_inc_not_zero(&sgx_usage_count))
+		return 0;
+
+	ret = sgx_update_svn();
+	if (!ret)
+		atomic_inc(&sgx_usage_count);
+	return ret;
+}
+
+void sgx_dec_usage_count(void)
+{
+	atomic_dec(&sgx_usage_count);
+}
+
 static int __init sgx_init(void)
 {
 	int ret;
@@ -947,6 +1015,8 @@ static int __init sgx_init(void)
 	if (sgx_vepc_init() && ret)
 		goto err_provision;
 
+	sgx_has_eupdatesvn = (cpuid_eax(SGX_CPUID) & SGX_CPUID_EUPDATESVN);
+
 	return 0;
 
 err_provision:
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index d2dad21259a8..f5940393d9bd 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -102,6 +102,9 @@ static inline int __init sgx_vepc_init(void)
 }
 #endif
 
+int sgx_inc_usage_count(void);
+void sgx_dec_usage_count(void);
+
 void sgx_update_lepubkeyhash(u64 *lepubkeyhash);
 
 #endif /* _X86_SGX_H */
diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/virt.c
index 7aaa3652e31d..e548de340c2e 100644
--- a/arch/x86/kernel/cpu/sgx/virt.c
+++ b/arch/x86/kernel/cpu/sgx/virt.c
@@ -255,12 +255,18 @@ static int sgx_vepc_release(struct inode *inode, struct file *file)
 	xa_destroy(&vepc->page_array);
 	kfree(vepc);
 
+	sgx_dec_usage_count();
 	return 0;
 }
 
 static int sgx_vepc_open(struct inode *inode, struct file *file)
 {
 	struct sgx_vepc *vepc;
+	int ret;
+
+	ret = sgx_inc_usage_count();
+	if (ret)
+		return ret;
 
 	vepc = kzalloc(sizeof(struct sgx_vepc), GFP_KERNEL);
 	if (!vepc)
-- 
2.45.2

