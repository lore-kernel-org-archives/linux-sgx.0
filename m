Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EFD0247284;
	Fri,  1 Aug 2025 11:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754047607; cv=none; b=uXie1xdLzaIvZ8YrSNopREemR9Cs3I6SU1+wLWsbEKl8kO2JwntgSN6YEzo77oqsTwJH7GE0k2UnIpV7JR+xJZeMp69AClNSyBSByO5qa0mmJziKSptCJH7LopqNkL+C5gNTdSjZgbvwQRIl4RaBi187tSLHaLDgCQIKZha0hKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754047607; c=relaxed/simple;
	bh=6ux6r9Jb73C0F6i2a4AA6aMrix7MkXzGYxiWJ2H8wrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f0TrNj/27XwvXI9SVw4Unm/52sOjxvFd/awkfOyIYroA0PoT28IwFS5nE9195Fk70UNk820iCTWF5X/N62QDDZkLKlJIwn4xlGXO8Gi1w/IRMXB5/HulDl5LeN5zEAXix01UbQzrqI6px3JUTDMfJEkf3C3ST7N+kuzXKzCW3n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PPPTj2MA; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PPPTj2MA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754047606; x=1785583606;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6ux6r9Jb73C0F6i2a4AA6aMrix7MkXzGYxiWJ2H8wrQ=;
  b=PPPTj2MAwbJPai5Mt6yRmMF4/ij2gtzFQ3wg2J9Nhgg0VVNMzRXebsar
   6Gk1FgQ1Euq/+jJ6m89+JYhBp+QX8Tcil03S7YUnSNKm9C9q8t7oyeSFy
   rQd/qLFUWseF96gRKyw/q93FW3bNiT3XRZfnWljDbVoNPyAN4IRxoVNt4
   8bV7xh3yVv9MK9TolUS0Aob4FQPFwSTOSggL9r5T2eqe6LzlOPhWUHIlJ
   BvS3FLmEoic4RLqm8ZecU2n9bMawcJP6CZjHoINaYaz10JS/e1t3AMIOb
   yKrS/CIUu3VTHzzh+JbYhKkKDiL1UM28l1koVO8uzkwAOfphwVeVQkv9x
   w==;
X-CSE-ConnectionGUID: wK4+vKgLQHqJFTjipkMyfw==
X-CSE-MsgGUID: Z3w782rIQ3K80JIXtiXr3w==
X-IronPort-AV: E=McAfee;i="6800,10657,11508"; a="59014770"
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="59014770"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2025 04:26:46 -0700
X-CSE-ConnectionGUID: GEFEW/23QnawindgU4pkLA==
X-CSE-MsgGUID: +QTx+dImR4KB/gnTyMVz7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="167727090"
Received: from sschumil-mobl2.ger.corp.intel.com (HELO eresheto-mobl3.ger.corp.intel.com) ([10.245.244.159])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2025 04:26:42 -0700
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
Subject: [PATCH v10 2/6] x86/sgx: Introduce functions to count the sgx_(vepc_)open()
Date: Fri,  1 Aug 2025 14:25:17 +0300
Message-ID: <20250801112619.1117549-3-elena.reshetova@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250801112619.1117549-1-elena.reshetova@intel.com>
References: <20250801112619.1117549-1-elena.reshetova@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently SGX does not have a global counter to count the
active users from userspace or hypervisor. Define placeholder
functions sgx_inc/dec_usage_count that are used to increment
and decrement such a counter. Also, wire the call sites for
these functions.

The definition of the counter itself and the actual implementation
of these two functions comes next. The counter will be used by
the driver that would be attempting to call EUPDATESVN SGX instruction
only when incrementing from zero.

Note: the sgx_inc_usage_count prototype is defined to return
int for the cleanliness of the follow-up patches. When the
EUPDATESVN SGX instruction will be enabled in the follow-up patch,
the sgx_inc_usage_count will start to return int.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
---
 arch/x86/kernel/cpu/sgx/driver.c | 19 ++++++++++++++++++-
 arch/x86/kernel/cpu/sgx/encl.c   |  1 +
 arch/x86/kernel/cpu/sgx/main.c   | 10 ++++++++++
 arch/x86/kernel/cpu/sgx/sgx.h    |  3 +++
 arch/x86/kernel/cpu/sgx/virt.c   | 20 +++++++++++++++++++-
 5 files changed, 51 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx/driver.c
index 9aa48f455c54..79d6020dfe9c 100644
--- a/arch/x86/kernel/cpu/sgx/driver.c
+++ b/arch/x86/kernel/cpu/sgx/driver.c
@@ -41,6 +41,23 @@ static int __sgx_open(struct inode *inode, struct file *file)
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
@@ -126,7 +143,7 @@ static long sgx_compat_ioctl(struct file *filep, unsigned int cmd,
 
 static const struct file_operations sgx_encl_fops = {
 	.owner			= THIS_MODULE,
-	.open			= __sgx_open,
+	.open			= sgx_open,
 	.release		= sgx_release,
 	.unlocked_ioctl		= sgx_ioctl,
 #ifdef CONFIG_COMPAT
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
index d8fdf7f39215..b649c0610019 100644
--- a/arch/x86/kernel/cpu/sgx/virt.c
+++ b/arch/x86/kernel/cpu/sgx/virt.c
@@ -255,6 +255,7 @@ static int sgx_vepc_release(struct inode *inode, struct file *file)
 	xa_destroy(&vepc->page_array);
 	kfree(vepc);
 
+	sgx_dec_usage_count();
 	return 0;
 }
 
@@ -273,6 +274,23 @@ static int __sgx_vepc_open(struct inode *inode, struct file *file)
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
@@ -291,7 +309,7 @@ static long sgx_vepc_ioctl(struct file *file,
 
 static const struct file_operations sgx_vepc_fops = {
 	.owner		= THIS_MODULE,
-	.open		= __sgx_vepc_open,
+	.open		= sgx_vepc_open,
 	.unlocked_ioctl	= sgx_vepc_ioctl,
 	.compat_ioctl	= sgx_vepc_ioctl,
 	.release	= sgx_vepc_release,
-- 
2.45.2

