Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0512018A93F;
	Fri, 11 Jul 2025 16:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752252841; cv=none; b=tg2MTWNBIiJ1f32k8oa1DhSepztLGp0oBUIy5nvaYLk6T0dGRfURWjCbnYaeECOA+qY75L4ejsNDtLvZu3nkrCaMZEVoo9CMzRYYcuswTQ31m9meZxqAmpWRaLLgLtSa0SWVl/ZZNcne88F+wo9yDv4UpA98mQDyZBk/+/p3y08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752252841; c=relaxed/simple;
	bh=QvKBgyb3p3TEAGFvOWbDNtNy2IXZ42X3NFk6SdztgYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iN15qZ127gCYkjvBEevRnlgYgiROquPdGbjH0J6+VDpUSfTHZhznIcmDfrsTxrIVqeM7ToDBm+4a9c3d6DSshpqcPaMLQO5tbxRcBd7BPpuT8BafqXtP+ye8WrRWksdtbVt4X9blDnoGNwR2YtDIbsZkuSgwO+u/8fk8YrVFTqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ehsKYFxQ; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ehsKYFxQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752252840; x=1783788840;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QvKBgyb3p3TEAGFvOWbDNtNy2IXZ42X3NFk6SdztgYw=;
  b=ehsKYFxQcHsGsM8EQ5LNcicts7pzoLcPv0TVDVaLAEoPL/8i7LEwTw+6
   bK/md7CMoFEOnN6lA3clNUMj6EsaphivWIo/xQPAN2vZ7A3NUSlBRJemL
   YWct/gov3mK+7afSChzecilO76r1qy6bjrwJcn9Kzw3Hu/OlmZDOW0bjl
   +g/6cNpiDvEkmpgf9P8vO9K5S+pWpi5Tsz7eZOdGuXcn1HBmL5UB3iHB5
   Y4M4IidfoFAuj+ZfrRdzBrZRVHUse/63NF07d45oG8cgOOk4q8EAVY+sb
   uceUcmFkBqm2KQE2qPkDOyWbt19vcKRoy4kx9VpqYref3aVMJUgLn85VB
   A==;
X-CSE-ConnectionGUID: U3gobOW9TUSRPTUo3MSYBQ==
X-CSE-MsgGUID: ude2z7mFQuulk9MJOSI5Pw==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="53665438"
X-IronPort-AV: E=Sophos;i="6.16,304,1744095600"; 
   d="scan'208";a="53665438"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 09:52:41 -0700
X-CSE-ConnectionGUID: nnanUOyjSlWgX4mMMn86TQ==
X-CSE-MsgGUID: wTP7K8KRQQWzPRmtTNY6ug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,304,1744095600"; 
   d="scan'208";a="187387773"
Received: from lfiedoro-mobl.ger.corp.intel.com (HELO eresheto-mobl3.ger.corp.intel.com) ([10.245.245.49])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2025 09:52:36 -0700
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
Subject: [PATCH v7 1/5] x86/sgx: Introduce a counter to count the sgx_(vepc_)open()
Date: Fri, 11 Jul 2025 19:50:30 +0300
Message-ID: <20250711165212.1354943-2-elena.reshetova@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250711165212.1354943-1-elena.reshetova@intel.com>
References: <20250711165212.1354943-1-elena.reshetova@intel.com>
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

