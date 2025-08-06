Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A06921CFEF;
	Wed,  6 Aug 2025 08:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754468052; cv=none; b=n85iWu7RQ9JxNmHC/QLtuJFS6HkriMD2Ugnyz5tTFnBESqLFAiCOix3eXmoTtB2XK47DTWf4nSC9FfwNK8LKkoRcfyZgdaS62kTwiZ6RUYt4MdTR9ZhBxmeLLct5gwwnda5bzKeD0w2Gli3HMwqs9p4NtcW25ohSkop7VUqsm5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754468052; c=relaxed/simple;
	bh=xAgcVzPGMizjBmMHVeIIS14F+79ugFsiTAhfGR0IMHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dHqfMkQQ7RuanVoMxcXw5lUaZumIwXSAG8csvNym2FZj8sU4vOZv9Qh5NE7ezhniXXhwlU8qN5W6daqFKVmoyK8N0T4gv0TI7Z5DxwM9IAWxJz08d+jeuWGAiGrdFvU2b83iUtpdzc5QMjgxouG1nqy1XkU2Rk2H26AxGd1taTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MPc67Cyr; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MPc67Cyr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754468050; x=1786004050;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xAgcVzPGMizjBmMHVeIIS14F+79ugFsiTAhfGR0IMHk=;
  b=MPc67CyrwZcKiQIOiTcLbhiRmSZhdjQi9CNpv4Ul3JR1bI1Q1D+03Y54
   s8SC097HmZCDm4IP6ysz9FnFltJUbC31p1EK8dXNijBIiu0cjLJMKbpg5
   4PpEgle8UY7CwTj+5b+J9mWnYxp7Byvfod+f8VzA18fNc+87cpC6SbflS
   0j930zbBzxVEkIxTIG6kSklBy5AFbVF4XJT3dlSTAaRHuqwNvsPCPfK0p
   uZcHvJcOaG5aLAo/BDu0FlQjUZvZ7aDxqVj0cOyNQg3V68RItwW6cAt+r
   hHUS1JpHftSBAoesrswh31UyLPpXdbXKM9XauiyJlbzCa4D0UVoBbg6pM
   g==;
X-CSE-ConnectionGUID: ATnsr2KkRKm5ARAYP6EGNA==
X-CSE-MsgGUID: fDJoS2aKSaKtjtm5uInQJg==
X-IronPort-AV: E=McAfee;i="6800,10657,11513"; a="56853632"
X-IronPort-AV: E=Sophos;i="6.17,268,1747724400"; 
   d="scan'208";a="56853632"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2025 01:14:10 -0700
X-CSE-ConnectionGUID: 7ghzxRoHQv2UhgWCby6oBg==
X-CSE-MsgGUID: PP3+hXJWTquXNTAhqjkN8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,268,1747724400"; 
   d="scan'208";a="169168417"
Received: from sschumil-mobl2.ger.corp.intel.com (HELO eresheto-mobl3.ger.corp.intel.com) ([10.245.244.125])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2025 01:14:04 -0700
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
Subject: [PATCH v11 1/5] x86/sgx: Introduce functions to count the sgx_(vepc_)open()
Date: Wed,  6 Aug 2025 11:11:52 +0300
Message-ID: <20250806081344.404004-2-elena.reshetova@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250806081344.404004-1-elena.reshetova@intel.com>
References: <20250806081344.404004-1-elena.reshetova@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently SGX does not have a global counter to count the
active users from userspace or hypervisor. Define placeholder
functions sgx_inc/dec_usage_count() that are used to increment
and decrement such a counter. Also, wire the call sites for
these functions. For the latter, in order to introduce the
counting of active sgx users on top of clean functions that
allocate vepc structures, covert existing sgx_(vepc_)open() to
__sgx_(vepc_)open().

The definition of the counter itself and the actual implementation
of these two functions comes next. The counter will be used by
the driver that would be attempting to call EUPDATESVN SGX instruction
only when incrementing from zero.

Note: the sgx_inc_usage_count() prototype is defined to return
int for the cleanliness of the follow-up patches despite always
returning zero in this patch. When the EUPDATESVN SGX instruction
will be enabled in the follow-up patch, the sgx_inc_usage_count()
will start to return the actual return code.

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

