Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 467AF25C80D;
	Thu, 14 Aug 2025 07:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755157030; cv=none; b=VvMuqyrjR2rL1adARzRPFq5DaBjynYUR7WuYel1+Mn1lWPe5eeycbXT7YXPmcwUemLsdsxZnK2hNh4Knl7hgxWrieFTUYaEv/xZcvDfT1oMeA4+u0WoTzYASIOJzkKKAMnxQkB4ZwNZRV5sa4/a0vWOE4r44bQ5YCOZQjuAGw1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755157030; c=relaxed/simple;
	bh=sx6hlBHBeNHTb6+Vae9NAlYaBET/EXtzzpTp0PmsiCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rBMkpsC0r1IlnLbYUrxjsV+W3ur7ALaAFQqe6bxt97SkgVCEYT1hORCyB12r54JJLhhdHpUoPOjEHfVTmagAezpnps5+g/kDCj9WU8/IBjC1/T3MeYhmognqcokdF69SrhXIKZ3qmExX6MP6Dmd0oGcHlnnU0UFqd5jsKBoNbKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=KX6e2ou2; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="KX6e2ou2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755157029; x=1786693029;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sx6hlBHBeNHTb6+Vae9NAlYaBET/EXtzzpTp0PmsiCU=;
  b=KX6e2ou23M+VNEX1O3619uoOwZI11sdAQVkcHXaKkRjrKMkQr1AD1gLm
   kwISGZ6/+n15B0cVTSUEfYsgDloROhddv8urQouGCKTNkhFHNSWk7yWaW
   CsiJR3jjVwNk/Qgh4ySS5LN58/0ktpaWBm8B20MviRcBDMIdcdLU41GeI
   6WsjgubMxqGBRgOVaDhC51teTmyXqM9lgRy6PYMgjpiXUC8TrDINHt3/e
   5ffOlOeXeUxeqdAi6sDw6FBs0kDI15QXYuu2Gw45tyKeKIN7iW8VqL82z
   bczcb8Bj/8hrQITh9FLEsJKWvlpFeZxXvMOqfAz9ZuS+/gpUX1Z0iODtx
   Q==;
X-CSE-ConnectionGUID: 7OcNNH2PSVqsyZicK54FAA==
X-CSE-MsgGUID: xX36joOMQXCr3SiB/cdlGA==
X-IronPort-AV: E=McAfee;i="6800,10657,11520"; a="82899352"
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="82899352"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 00:37:08 -0700
X-CSE-ConnectionGUID: 6tnd4XOCT/q+mDWt83MPpA==
X-CSE-MsgGUID: Q2XpgmLqTcOaga7/t0pb9g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,287,1747724400"; 
   d="scan'208";a="171927363"
Received: from foboril-desk.ger.corp.intel.com (HELO eresheto-mobl3.ger.corp.intel.com) ([10.245.244.138])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Aug 2025 00:37:04 -0700
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
Subject: [PATCH v14 1/5] x86/sgx: Introduce functions to count the sgx_(vepc_)open()
Date: Thu, 14 Aug 2025 10:34:21 +0300
Message-ID: <20250814073640.1507050-2-elena.reshetova@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250814073640.1507050-1-elena.reshetova@intel.com>
References: <20250814073640.1507050-1-elena.reshetova@intel.com>
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

