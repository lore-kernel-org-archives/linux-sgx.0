Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42AFB267391;
	Mon, 19 May 2025 07:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747639615; cv=none; b=oYQ2LEMndiezdjPByFSvmb/dX8tO2DWh5zVjiF2NRPuYnOQjmBfYMItHpZaqblZQwMaLcD5Zw20JHttz7Kq7d0z6EFQ6grn+cXRtWh62D9k1bjS1t4BqG5/c1Oh+bbEatjWcZnussL7TnDMd7taT/dQSKElEj2m1MoF7yI/R8zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747639615; c=relaxed/simple;
	bh=jBDQDjF2WV16Je5dIF0ttMaK0Ais3hiuqsAK13xa99E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YVFRH+6MvzyMzTCV+7zz8soAQE/9NaFvVfaVpKuAuOi/0Axa46MYCc0bfrWT6xyy3Huh0hpTQJm6QVs1fBVQHRpmjnhrghYGU4+gPJmee5hDGvUOSVCqJSE1D8VtAvCw82cTm+UfqauvaygHMpVAz6nEAeubNJyyy8XO02x6teg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f87s1JCP; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f87s1JCP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747639614; x=1779175614;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jBDQDjF2WV16Je5dIF0ttMaK0Ais3hiuqsAK13xa99E=;
  b=f87s1JCPJInDShPQjH4gAtpIAKdu5q5SgAidjYEm9JzZnp+Csgo+O7Ti
   No+akwT0cWhcp+oI5MID2XdnYTaQilLyR3ZlsFkIa93Z98D6YqZ9fPpg3
   CmRY6U+8iW2CXjW9qtuJ6SSmz3UQWsLk9m4JoOBTDgEBraY+sJUGxBYkc
   30HueOs8hOJ4g16kCz8GRl7pnmCE29YShxmkmsHnfN2zdiak0D+CUAh+D
   BmxeGp4i3dbpXEIjwISXnejSXUA6EHBHtyISv7W4xEOs5KouZyLT8v/QH
   CubaHA79fnMlbAYd5tNsdaX3AREgcujdvI2FQbtSqlcmKos91TK+Y20Dj
   g==;
X-CSE-ConnectionGUID: LyL0Cs9gQrm6aM8rJtB6oQ==
X-CSE-MsgGUID: gTuFG634TKSSijb0sE6eng==
X-IronPort-AV: E=McAfee;i="6700,10204,11437"; a="49591616"
X-IronPort-AV: E=Sophos;i="6.15,300,1739865600"; 
   d="scan'208";a="49591616"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 00:26:54 -0700
X-CSE-ConnectionGUID: o3QhuCBrTW+lkmXrGrpwmg==
X-CSE-MsgGUID: yDl+W5hCQwSUwYl7jpCqPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,300,1739865600"; 
   d="scan'208";a="139029803"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO eresheto-mobl3.ger.corp.intel.com) ([10.245.244.195])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 00:26:49 -0700
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
Subject: [PATCH v5 5/5] x86/sgx: Enable automatic SVN updates for SGX enclaves
Date: Mon, 19 May 2025 10:24:31 +0300
Message-ID: <20250519072603.328429-6-elena.reshetova@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250519072603.328429-1-elena.reshetova@intel.com>
References: <20250519072603.328429-1-elena.reshetova@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

SGX enclaves have an attestation mechanism.  An enclave might,
for instance, need to attest to its state before it is given
a special decryption key.  Since SGX must trust the CPU microcode,
attestation incorporates the microcode versions of all processors
on the system and is affected by microcode updates. This enables
deployment decisions based on the microcode version.
For example, an enclave might be denied a decryption key if it
runs on a system that has old microcode without a specific mitigation.

Unfortunately, this attestation metric (called CPUSVN) is only a snapshot.
When the kernel first uses SGX (successfully executes any ENCLS instruction),
SGX inspects all CPUs in the system and incorporates a record of their
microcode versions into CPUSVN. CPUSVN is only automatically updated at reboot.
This means that, although the microcode has been updated, enclaves can never
attest to this fact. Enclaves are stuck attesting to the old version until
a reboot.

The SGX architecture has an alternative to these reboots: the ENCLS[EUPDATESVN]
instruction [1]. It allows another snapshot to be taken to update CPUSVN
after a runtime microcode update without a reboot.

Whenever a microcode update affects SGX, the SGX attestation architecture
assumes that all running enclaves and cryptographic assets (like internal
SGX encryption keys) have been compromised. To mitigate the impact of this
presumed compromise, EUPDATESVN success requires that all SGX memory to be
marked as “unused” and its contents destroyed. This requirement ensures
that no compromised enclave can survive the EUPDATESVN procedure and provides
an opportunity to generate new cryptographic assets.

Attempt to execute EUPDATESVN on the first open of sgx_(vepc)open().
If EUPDATESVN fails with any other error code than SGX_INSUFFICIENT_ENTROPY,
this is considered unexpected and the open() returns an error. This
should not happen in practice. On contrary SGX_INSUFFICIENT_ENTROPY might
happen due to a pressure on the system DRNG (RDSEED) and therefore
the open() is not blocked to allow normal enclave operation.

[1] Runtime Microcode Updates with Intel Software Guard Extensions,
https://cdrdv2.intel.com/v1/dl/getContent/648682

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
---
 arch/x86/kernel/cpu/sgx/driver.c | 23 +++++++++++++-------
 arch/x86/kernel/cpu/sgx/main.c   | 36 ++++++++++++++++++++++++++++++--
 arch/x86/kernel/cpu/sgx/virt.c   | 16 +++++++++++---
 3 files changed, 63 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx/driver.c
index b5ffe104af4c..bde06b6755f2 100644
--- a/arch/x86/kernel/cpu/sgx/driver.c
+++ b/arch/x86/kernel/cpu/sgx/driver.c
@@ -19,10 +19,15 @@ static int sgx_open(struct inode *inode, struct file *file)
 	struct sgx_encl *encl;
 	int ret;
 
-	sgx_inc_usage_count();
+	ret = sgx_inc_usage_count();
+	if (ret)
+		return -EBUSY;
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
@@ -32,14 +37,18 @@ static int sgx_open(struct inode *inode, struct file *file)
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
+		kfree(encl);
+err_usage_count:
+		sgx_dec_usage_count();
+		return ret;
 }
 
 static int sgx_release(struct inode *inode, struct file *file)
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index fd71e2ddca59..d58e0c46cbf9 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -917,6 +917,8 @@ EXPORT_SYMBOL_GPL(sgx_set_attribute);
 
 /* Counter to count the active SGX users */
 static atomic64_t sgx_usage_count;
+/* Mutex to ensure EUPDATESVN is called when EPC is empty */
+static DEFINE_MUTEX(sgx_svn_lock);
 
 /**
  * sgx_updatesvn() - Attempt to call ENCLS[EUPDATESVN]
@@ -976,8 +978,38 @@ static int sgx_update_svn(void)
 
 int sgx_inc_usage_count(void)
 {
-	atomic64_inc(&sgx_usage_count);
-	return 0;
+	int ret;
+
+	/*
+	 * Increments from non-zero indicate EPC other
+	 * active EPC users and EUPDATESVN is not attempted.
+	 */
+	if (atomic64_inc_not_zero(&sgx_usage_count))
+		return 0;
+
+	/*
+	 * Ensure no other concurrent threads can start
+	 * touching EPC while EUPDATESVN is running.
+	 */
+	guard(mutex)(&sgx_svn_lock);
+
+	if (atomic64_inc_not_zero(&sgx_usage_count))
+		return 0;
+
+	/*
+	 * Attempt to call EUPDATESVN since EPC must be
+	 * empty at this point.
+	 */
+	ret = sgx_update_svn();
+
+	/*
+	 * If EUPDATESVN failed with a non-expected error
+	 * code, return failure to sgx_(vepc_)open and
+	 * do not increment the sgx_usage_count.
+	 */
+	if (!ret)
+		atomic64_inc(&sgx_usage_count);
+	return ret;
 }
 
 void sgx_dec_usage_count(void)
diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/virt.c
index 83de0907f32c..e6e29c09c3b9 100644
--- a/arch/x86/kernel/cpu/sgx/virt.c
+++ b/arch/x86/kernel/cpu/sgx/virt.c
@@ -262,17 +262,27 @@ static int sgx_vepc_release(struct inode *inode, struct file *file)
 static int sgx_vepc_open(struct inode *inode, struct file *file)
 {
 	struct sgx_vepc *vepc;
+	int ret;
+
+	ret = sgx_inc_usage_count();
+	if (ret)
+		return -EBUSY;
 
-	sgx_inc_usage_count();
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
+		sgx_dec_usage_count();
+		return ret;
 }
 
 static long sgx_vepc_ioctl(struct file *file,
-- 
2.45.2

