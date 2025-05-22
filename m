Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4741428313D;
	Thu, 22 May 2025 09:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747905784; cv=none; b=tyMVvGTNIsDQ6W2kAhC4xrGl8FAECSDQnrjyBml3lT5Pr3ca1KsB0MKn14xRWcwhaP1SLW5oskPHuz2TL6oIAbPlQhs7NHgzs4iOlcQtnOaPtvh3mdyd4j/aRtRwfwbp9YMujdH+aeIXRln+Kv9Ao09rgUdX8CudZ5v9IS3CHA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747905784; c=relaxed/simple;
	bh=gXFPrPtwKLZsTD5Ey5rNSMwyikfjnKecvf8r8P40cfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vy9OOgKBKCXI5lY6+nGJ6p+vvbOjSVtV4ZjCYHdHfShaXninEo84iM2NRPdZJFPmdnqZx3mE5LmWfP+kQ+oAGSOK79za+Y6fL3rPhrny9IR/xNBVSQBZ59OMpF8yZyHsmiyAoVnYbm6kUQKz9U6rO3+22gOr2jz60MnwNTUlkpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W6zU02os; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W6zU02os"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747905782; x=1779441782;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=gXFPrPtwKLZsTD5Ey5rNSMwyikfjnKecvf8r8P40cfU=;
  b=W6zU02oszcn9ExMtScXcsBsmAPZL6sp+VignjIFQQxyfpiNIr6nIqTzh
   bJggTaGTmguYVnIHGx7DgM1rqPNSp7MOgzpYjwu/Q13uDy8JOvWcbU9Cr
   Q6etnCa3M0+nUtOuAfSNfDefoA+AtTtfVIc4EnG2DlcPu135OVdbZnNKY
   AY0/aNq1bN7noQ7U77vQ9Vbh9fxrAYQwV6j9yyuuhdifO+xvkQT1aUhEh
   Vm8VJWEVxutsSrxWjHJqowvzbLXquF0EAJ7rfJfNv7Uc1u5T+CL1p3ySi
   WBVvVXG0Otam9mqS0ogvUr9b2yYFeRSVsrHfbKZW1Hm9qx5Xi3hDaZxpW
   g==;
X-CSE-ConnectionGUID: j23rcIddTruO++yuN/kcbQ==
X-CSE-MsgGUID: DrZ3cioqTWq3QGUX0KgNmw==
X-IronPort-AV: E=McAfee;i="6700,10204,11440"; a="72445625"
X-IronPort-AV: E=Sophos;i="6.15,305,1739865600"; 
   d="scan'208";a="72445625"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2025 02:23:02 -0700
X-CSE-ConnectionGUID: sxKsu8cIRWGZHiDA9wEkxg==
X-CSE-MsgGUID: 2ViRFOWoRx61IS8j9fdeBw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,305,1739865600"; 
   d="scan'208";a="145661947"
Received: from oandoniu-mobl3.ger.corp.intel.com (HELO eresheto-mobl3.ger.corp.intel.com) ([10.245.245.170])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2025 02:22:56 -0700
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
	dionnaglaze@google.com,
	bondarn@google.com,
	scott.raynor@intel.com,
	Elena Reshetova <elena.reshetova@intel.com>
Subject: [PATCH v6 1/5] x86/sgx: Introduce a counter to count the sgx_(vepc_)open()
Date: Thu, 22 May 2025 12:21:34 +0300
Message-ID: <20250522092237.7895-2-elena.reshetova@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250522092237.7895-1-elena.reshetova@intel.com>
References: <20250522092237.7895-1-elena.reshetova@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently SGX does not have a global counter to count the
active users from userspace or hypervisor. Implement such a counter,
sgx_usage_count. It will be used by the driver when attempting
to call EUPDATESVN SGX instruction.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
---
 arch/x86/kernel/cpu/sgx/driver.c | 22 ++++++++++++++++------
 arch/x86/kernel/cpu/sgx/encl.c   |  1 +
 arch/x86/kernel/cpu/sgx/main.c   | 14 ++++++++++++++
 arch/x86/kernel/cpu/sgx/sgx.h    |  3 +++
 arch/x86/kernel/cpu/sgx/virt.c   | 16 ++++++++++++++--
 5 files changed, 48 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx/driver.c
index 7f8d1e11dbee..a2994a74bdff 100644
--- a/arch/x86/kernel/cpu/sgx/driver.c
+++ b/arch/x86/kernel/cpu/sgx/driver.c
@@ -19,9 +19,15 @@ static int sgx_open(struct inode *inode, struct file *file)
 	struct sgx_encl *encl;
 	int ret;
 
+	ret = sgx_inc_usage_count();
+	if (ret)
+		return ret;
+
 	encl = kzalloc(sizeof(*encl), GFP_KERNEL);
-	if (!encl)
-		return -ENOMEM;
+	if (!encl) {
+		ret = -ENOMEM;
+		goto err_usage_count;
+	}
 
 	kref_init(&encl->refcount);
 	xa_init(&encl->page_array);
@@ -31,14 +37,18 @@ static int sgx_open(struct inode *inode, struct file *file)
 	spin_lock_init(&encl->mm_lock);
 
 	ret = init_srcu_struct(&encl->srcu);
-	if (ret) {
-		kfree(encl);
-		return ret;
-	}
+	if (ret)
+		goto err_encl;
 
 	file->private_data = encl;
 
 	return 0;
+
+err_encl:
+	kfree(encl);
+err_usage_count:
+	sgx_dec_usage_count();
+	return ret;
 }
 
 static int sgx_release(struct inode *inode, struct file *file)
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
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 2de01b379aa3..a018b01b8736 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -917,6 +917,20 @@ int sgx_set_attribute(unsigned long *allowed_attributes,
 }
 EXPORT_SYMBOL_GPL(sgx_set_attribute);
 
+/* Counter to count the active SGX users */
+static atomic64_t sgx_usage_count;
+
+int sgx_inc_usage_count(void)
+{
+	atomic64_inc(&sgx_usage_count);
+	return 0;
+}
+
+void sgx_dec_usage_count(void)
+{
+	atomic64_dec(&sgx_usage_count);
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
index 7aaa3652e31d..6ce908ed51c9 100644
--- a/arch/x86/kernel/cpu/sgx/virt.c
+++ b/arch/x86/kernel/cpu/sgx/virt.c
@@ -255,22 +255,34 @@ static int sgx_vepc_release(struct inode *inode, struct file *file)
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
-	if (!vepc)
-		return -ENOMEM;
+	if (!vepc) {
+		ret = -ENOMEM;
+		goto err_usage_count;
+	}
 	mutex_init(&vepc->lock);
 	xa_init(&vepc->page_array);
 
 	file->private_data = vepc;
 
 	return 0;
+
+err_usage_count:
+	sgx_dec_usage_count();
+	return ret;
 }
 
 static long sgx_vepc_ioctl(struct file *file,
-- 
2.45.2

