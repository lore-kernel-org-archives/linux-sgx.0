Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D57279782;
	Mon, 18 Aug 2025 07:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755501211; cv=none; b=ofww3uMrX+Gt3hXi6uUMBhNLICur4cEbUGbaa30GKVH7meyHtxz5MR4JB5Iqf9XSZglxK+e2o2pSPOGzzyhqL/WM2xRR3MfD99tr4hfeyxc/pRFsukhQbORhNs7UqkkyJVnw+jIYWSZv6DT4sPtvR8ekpcIglgOL5+e0xqGJqRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755501211; c=relaxed/simple;
	bh=sx6hlBHBeNHTb6+Vae9NAlYaBET/EXtzzpTp0PmsiCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dGjq1GT4x3Wnz6XN57IdVR5WPxz3hdLDjE+FgA3Wj8fh0h4lJMdV8t5KoaMQzKcI9p55hWTJZqr4FhtOOGDtzloiFaAHnmLjkqQft6ErVwAbH0k88iesR2vkX0666FGalzVW7eA/TQSQ24NKd83khE697D6PBPKBSJ6BAQpCuWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Zs+l9XPh; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Zs+l9XPh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755501209; x=1787037209;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sx6hlBHBeNHTb6+Vae9NAlYaBET/EXtzzpTp0PmsiCU=;
  b=Zs+l9XPhNyW2ikADZhGcXD1KuGOuRZ3vgGYbf55ADpu7HW/B85g2WYQI
   j4Ckaa0qfRcwS3Egd9yZaj1Z7iGVXvx0kgfn57XphIlByetMNOda75nqk
   QZLoR6TL0zhv5WL6CtMxNzmDmj09tHtthIxqwkIsyHt3VoMxW1KNeqb5N
   GJG6X7IKX6NPcj1TrZybqRVcq/jN9nrQxQgm8QrdEYcFrDq9pqzg0GIer
   uMCTZ9n6dUQm0cvKxliHft9gYnKTezRyfSybuDa0XNABaRXuqblmHH4vk
   4DhIG9rvqA7qk1U4POg7PimWruudmQTkpz0BJPbcjNr1nPjl4+kAUkv8o
   g==;
X-CSE-ConnectionGUID: gYJSM+8LQjmGdeNxFjIyUg==
X-CSE-MsgGUID: k+Qo4xxmRiucdyLUboAUoQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11524"; a="68809299"
X-IronPort-AV: E=Sophos;i="6.17,293,1747724400"; 
   d="scan'208";a="68809299"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2025 00:13:29 -0700
X-CSE-ConnectionGUID: 0KEK78AkQrmW1CmlBCob0A==
X-CSE-MsgGUID: x+xFw4DsTY2N/i2fFIJCvQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,293,1747724400"; 
   d="scan'208";a="167421408"
Received: from opintica-mobl1 (HELO eresheto-mobl3.ger.corp.intel.com) ([10.245.245.174])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2025 00:13:23 -0700
From: Elena Reshetova <elena.reshetova@intel.com>
To: dave.hansen@intel.com
Cc: jarkko@kernel.org,
	seanjc@google.com,
	kai.huang@intel.com,
	mingo@kernel.org,
	linux-sgx@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	asit.k.mallick@intel.com,
	vincent.r.scarlata@intel.com,
	chongc@google.com,
	erdemaktas@google.com,
	vannapurve@google.com,
	bondarn@google.com,
	scott.raynor@intel.com,
	Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH v15 1/5] x86/sgx: Introduce functions to count the sgx_(vepc_)open()
Date: Mon, 18 Aug 2025 10:11:19 +0300
Message-ID: <20250818071304.1717183-2-elena.reshetova@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250818071304.1717183-1-elena.reshetova@intel.com>
References: <20250818071304.1717183-1-elena.reshetova@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, when SGX is compromised and the microcode update fix is applied,
the machine needs to be rebooted to invalidate old SGX crypto-assets and
make SGX be in an updated safe state. It's not friendly for the cloud.

To avoid having to reboot, a new ENCLS[EUPDATESVN] is introduced to update
SGX environment at runtime. This process needs to be done when there's no
SGX users to make sure no compromised enclaves can survive from the update
and allow the system to regenerate crypto-assets.

For now there's no counter to track the active SGX users of host enclave
and virtual EPC. Introduce such counter mechanism so that the EUPDATESVN
can be done only when there's no SGX users.

Define placeholder functions sgx_inc/dec_usage_count() that are used to
increment and decrement such a counter. Also, wire the call sites for
these functions. Encapsulate the current sgx_(vepc_)open() to
__sgx_(vepc_)open() to make the new sgx_(vepc_)open() easy to read.

The definition of the counter itself and the actual implementation of
sgx_inc/dec_usage_count() functions come next.

Note: The EUPDATESVN, which may fail, will be done in
sgx_inc_usage_count(). Make it return 'int' to make subsequent patches
which implement EUPDATESVN easier to review. For now it always returns
success.

Suggested-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
---
 arch/x86/kernel/cpu/sgx/driver.c | 19 ++++++++++++++++++-
 arch/x86/kernel/cpu/sgx/encl.c   |  1 +
 arch/x86/kernel/cpu/sgx/main.c   | 10 ++++++++++
 arch/x86/kernel/cpu/sgx/sgx.h    |  3 +++
 arch/x86/kernel/cpu/sgx/virt.c   | 20 +++++++++++++++++++-
 5 files changed, 51 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx/driver.c
index 7f8d1e11dbee..79d6020dfe9c 100644
--- a/arch/x86/kernel/cpu/sgx/driver.c
+++ b/arch/x86/kernel/cpu/sgx/driver.c
@@ -14,7 +14,7 @@ u64 sgx_attributes_reserved_mask;
 u64 sgx_xfrm_reserved_mask = ~0x3;
 u32 sgx_misc_reserved_mask;
 
-static int sgx_open(struct inode *inode, struct file *file)
+static int __sgx_open(struct inode *inode, struct file *file)
 {
 	struct sgx_encl *encl;
 	int ret;
@@ -41,6 +41,23 @@ static int sgx_open(struct inode *inode, struct file *file)
 	return 0;
 }
 
+static int sgx_open(struct inode *inode, struct file *file)
+{
+	int ret;
+
+	ret = sgx_inc_usage_count();
+	if (ret)
+		return ret;
+
+	ret = __sgx_open(inode, file);
+	if (ret) {
+		sgx_dec_usage_count();
+		return ret;
+	}
+
+	return 0;
+}
+
 static int sgx_release(struct inode *inode, struct file *file)
 {
 	struct sgx_encl *encl = file->private_data;
diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 308dbbae6c6e..cf149b9f4916 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -765,6 +765,7 @@ void sgx_encl_release(struct kref *ref)
 	WARN_ON_ONCE(encl->secs.epc_page);
 
 	kfree(encl);
+	sgx_dec_usage_count();
 }
 
 /*
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 2de01b379aa3..3a5cbd1c170e 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -917,6 +917,16 @@ int sgx_set_attribute(unsigned long *allowed_attributes,
 }
 EXPORT_SYMBOL_GPL(sgx_set_attribute);
 
+int sgx_inc_usage_count(void)
+{
+	return 0;
+}
+
+void sgx_dec_usage_count(void)
+{
+	return;
+}
+
 static int __init sgx_init(void)
 {
 	int ret;
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
index 7aaa3652e31d..b649c0610019 100644
--- a/arch/x86/kernel/cpu/sgx/virt.c
+++ b/arch/x86/kernel/cpu/sgx/virt.c
@@ -255,10 +255,11 @@ static int sgx_vepc_release(struct inode *inode, struct file *file)
 	xa_destroy(&vepc->page_array);
 	kfree(vepc);
 
+	sgx_dec_usage_count();
 	return 0;
 }
 
-static int sgx_vepc_open(struct inode *inode, struct file *file)
+static int __sgx_vepc_open(struct inode *inode, struct file *file)
 {
 	struct sgx_vepc *vepc;
 
@@ -273,6 +274,23 @@ static int sgx_vepc_open(struct inode *inode, struct file *file)
 	return 0;
 }
 
+static int sgx_vepc_open(struct inode *inode, struct file *file)
+{
+	int ret;
+
+	ret = sgx_inc_usage_count();
+	if (ret)
+		return ret;
+
+	ret =  __sgx_vepc_open(inode, file);
+	if (ret) {
+		sgx_dec_usage_count();
+		return ret;
+	}
+
+	return 0;
+}
+
 static long sgx_vepc_ioctl(struct file *file,
 			   unsigned int cmd, unsigned long arg)
 {
-- 
2.45.2

