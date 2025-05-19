Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8059266B6A;
	Mon, 19 May 2025 07:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747639594; cv=none; b=JLSiO7EOSawIKIceUVoZHK0HX5rjE16MRuAgx7g0HiqtDFg/HDyYPLTFG3WgyGvX7A77L70vnjsoMfJjUMcDUwelhFoPpQ3v75tF4g0sTKYjeBhrqbRq0nmVC3S7IOV96RQQt32QextrNsq1h2/dofFW+b8EKEVgG6Md6zB1zzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747639594; c=relaxed/simple;
	bh=m3Yfm7d4CuBcDXfqagsYSfXhRGtFaVlavC8qo14M5S8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iRzEx3LlSDemUwVVv7CPN4YTnPq697lvX2LOCP4wiBViPFUnESHlM4UlnCdUFibY8+rNbRyMMNTWGdnsp/B2nLgDR0T3ju1B4pknb7rIl53fH/Cymw8qpeByDvtgCM/yw+YX1ArSGpk+DAdpVcvMCJQZG52F0BtRIbBrTBtvoNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZSKrforK; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZSKrforK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747639593; x=1779175593;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=m3Yfm7d4CuBcDXfqagsYSfXhRGtFaVlavC8qo14M5S8=;
  b=ZSKrforK5AfSJh7qj8aRkLafcvSMYB0m8tph8BWiPhzZyfInNSgPRJiO
   PQBCYsfaEOy+lKpHW5eGynVf8tvBzgL/4ENDWqC94EXor03LCw+/LSpC0
   qZq4q+IONZ0CTUbtsi9kjOa2iyGd/X+mlnhd4epMKsJ5DrYlxTPd/LGaJ
   Rq80QoupAFVteReIDK+9UShDQGTnBh70F6ozvQGAliOv4wlNZODgemxd2
   0EiumyKnmuk89m3iCjSHWA+aj08VuhxqZWFNVh455LabY8fQO2AVb5SS+
   rN1AOa2//CziBtk82vYV5zU74f169nJAS8FK2fJt+buA+DwP4FJarqjVL
   A==;
X-CSE-ConnectionGUID: LPejelZgRdOmd+1ZxaxuJA==
X-CSE-MsgGUID: VNgKt0kmRS+FVT1EkHGOFg==
X-IronPort-AV: E=McAfee;i="6700,10204,11437"; a="49591594"
X-IronPort-AV: E=Sophos;i="6.15,300,1739865600"; 
   d="scan'208";a="49591594"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 00:26:32 -0700
X-CSE-ConnectionGUID: M/htiRM6TpK3HcZqmhv8EQ==
X-CSE-MsgGUID: d/aq45R3Q/SsMzrkMpzuNA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,300,1739865600"; 
   d="scan'208";a="139029725"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO eresheto-mobl3.ger.corp.intel.com) ([10.245.244.195])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 00:26:27 -0700
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
Subject: [PATCH v5 1/5] x86/sgx: Introduce a counter to count the sgx_(vepc_)open()
Date: Mon, 19 May 2025 10:24:27 +0300
Message-ID: <20250519072603.328429-2-elena.reshetova@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250519072603.328429-1-elena.reshetova@intel.com>
References: <20250519072603.328429-1-elena.reshetova@intel.com>
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
 arch/x86/kernel/cpu/sgx/driver.c |  1 +
 arch/x86/kernel/cpu/sgx/encl.c   |  1 +
 arch/x86/kernel/cpu/sgx/main.c   | 14 ++++++++++++++
 arch/x86/kernel/cpu/sgx/sgx.h    |  3 +++
 arch/x86/kernel/cpu/sgx/virt.c   |  2 ++
 5 files changed, 21 insertions(+)

diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx/driver.c
index 7f8d1e11dbee..b5ffe104af4c 100644
--- a/arch/x86/kernel/cpu/sgx/driver.c
+++ b/arch/x86/kernel/cpu/sgx/driver.c
@@ -19,6 +19,7 @@ static int sgx_open(struct inode *inode, struct file *file)
 	struct sgx_encl *encl;
 	int ret;
 
+	sgx_inc_usage_count();
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
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 8ce352fc72ac..80d565e6f2ad 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -914,6 +914,20 @@ int sgx_set_attribute(unsigned long *allowed_attributes,
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
index 7aaa3652e31d..83de0907f32c 100644
--- a/arch/x86/kernel/cpu/sgx/virt.c
+++ b/arch/x86/kernel/cpu/sgx/virt.c
@@ -255,6 +255,7 @@ static int sgx_vepc_release(struct inode *inode, struct file *file)
 	xa_destroy(&vepc->page_array);
 	kfree(vepc);
 
+	sgx_dec_usage_count();
 	return 0;
 }
 
@@ -262,6 +263,7 @@ static int sgx_vepc_open(struct inode *inode, struct file *file)
 {
 	struct sgx_vepc *vepc;
 
+	sgx_inc_usage_count();
 	vepc = kzalloc(sizeof(struct sgx_vepc), GFP_KERNEL);
 	if (!vepc)
 		return -ENOMEM;
-- 
2.45.2

