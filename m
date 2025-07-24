Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF48274664;
	Thu, 24 Jul 2025 08:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753344224; cv=none; b=rV4hbZw4ty8ywYsZVnskoX6us1H3on2V4UZRE+M8IWBfC77H0HdSDwAgqUkY26s8yvZGhkUk7yOnVw0kkfS56hUhkCbRB21sGjz+t0X+IOCwgXwv1rbOYbWl7gOg8DleH6DD0fOEitS2FoDKkDC4O4JrZX0SHBZ7ikP8r7697S8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753344224; c=relaxed/simple;
	bh=nrpTmKiY9LjE5O/dGaCI3ZrBmAYWPMJ4nZKKlcacg20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GQWdkP2GMN5k+/YvLFKmFSdZOxqRssrflUdrnWXXy1PownYSh9+0c3AsqQ1wH1w3eQdKpbmXCfsEgB/sMBhXkc6tf5WsfiILEu7qi5PyLsUDfdBjweYgiEhcWVv/fsc70yziwrrsw7DDUd9TnDBGStDRlik6eCkdEpTGSMNdHqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RQZipo9+; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RQZipo9+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753344223; x=1784880223;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nrpTmKiY9LjE5O/dGaCI3ZrBmAYWPMJ4nZKKlcacg20=;
  b=RQZipo9+XnDD592T73YF4GHqXKkjN5Vo1zds/V6EZinfyS/BlHker/0z
   a0wfB48TRpGUQOtKITS9uXZyuXqzIA13jicMEKMNIwFaKJH2hdCDacB9D
   dxaECi9B8xkFHIUpq4NEMCO5raj8LtUb5tJwMWTMiUgxwSQK7iBBfNcdk
   MmlvjZNxRJKomoneJ26XSXhi5Gpob1nms+2l80m9AC94p94+YuU5Ge+oH
   UUsTeHM8mFeQRUWKxqGYV24TmyLTX/Y1WtN8oLbo1boYM9t/A2NtMm5xz
   xmceuOAy4kmEcDhmfVclsP/ijNStWB60andgD8Lk1cXbSkOzRRosC86+7
   g==;
X-CSE-ConnectionGUID: zOOjRczlRJKElUoOa9j+Vw==
X-CSE-MsgGUID: jrIaxs2iSNqNcUN/9x40+g==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="66991938"
X-IronPort-AV: E=Sophos;i="6.16,336,1744095600"; 
   d="scan'208";a="66991938"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 01:03:42 -0700
X-CSE-ConnectionGUID: 44SY9nM5TdSmtyD5BHdvdA==
X-CSE-MsgGUID: zRhE1ct+TfynUdQEm3gW3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,336,1744095600"; 
   d="scan'208";a="160341348"
Received: from savramon-mobl1 (HELO eresheto-mobl3.ger.corp.intel.com) ([10.245.244.60])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 01:03:37 -0700
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
Subject: [PATCH v9 2/6] x86/sgx: Introduce a counter to count the sgx_(vepc_)open()
Date: Thu, 24 Jul 2025 11:02:11 +0300
Message-ID: <20250724080313.605676-3-elena.reshetova@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250724080313.605676-1-elena.reshetova@intel.com>
References: <20250724080313.605676-1-elena.reshetova@intel.com>
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

Note: the sgx_inc_usage_count prototype is defined to return
int for the cleanliness of the follow-up patches. When the
EUPDATESVN SGX instruction will be enabled in the follow-up patch,
the sgx_inc_usage_count will start to return int.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
---
 arch/x86/kernel/cpu/sgx/driver.c | 19 ++++++++++++++++++-
 arch/x86/kernel/cpu/sgx/encl.c   |  1 +
 arch/x86/kernel/cpu/sgx/main.c   | 13 +++++++++++++
 arch/x86/kernel/cpu/sgx/sgx.h    |  3 +++
 arch/x86/kernel/cpu/sgx/virt.c   | 21 ++++++++++++++++++++-
 5 files changed, 55 insertions(+), 2 deletions(-)

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
index 2de01b379aa3..ccb81a649d1b 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -917,6 +917,19 @@ int sgx_set_attribute(unsigned long *allowed_attributes,
 }
 EXPORT_SYMBOL_GPL(sgx_set_attribute);
 
+/* Counter to count the active SGX users */
+static int __maybe_unused sgx_usage_count;
+
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
index d8fdf7f39215..d6bff258d761 100644
--- a/arch/x86/kernel/cpu/sgx/virt.c
+++ b/arch/x86/kernel/cpu/sgx/virt.c
@@ -255,6 +255,7 @@ static int sgx_vepc_release(struct inode *inode, struct file *file)
 	xa_destroy(&vepc->page_array);
 	kfree(vepc);
 
+	sgx_dec_usage_count();
 	return 0;
 }
 
@@ -265,6 +266,7 @@ static int __sgx_vepc_open(struct inode *inode, struct file *file)
 	vepc = kzalloc(sizeof(struct sgx_vepc), GFP_KERNEL);
 	if (!vepc)
 		return -ENOMEM;
+
 	mutex_init(&vepc->lock);
 	xa_init(&vepc->page_array);
 
@@ -273,6 +275,23 @@ static int __sgx_vepc_open(struct inode *inode, struct file *file)
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
@@ -291,7 +310,7 @@ static long sgx_vepc_ioctl(struct file *file,
 
 static const struct file_operations sgx_vepc_fops = {
 	.owner		= THIS_MODULE,
-	.open		= __sgx_vepc_open,
+	.open		= sgx_vepc_open,
 	.unlocked_ioctl	= sgx_vepc_ioctl,
 	.compat_ioctl	= sgx_vepc_ioctl,
 	.release	= sgx_vepc_release,
-- 
2.45.2

