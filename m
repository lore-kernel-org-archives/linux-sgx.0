Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE0A1239E69;
	Fri,  1 Aug 2025 11:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754047603; cv=none; b=fv77WkrvHBpy9cbbJ3sq0bO5a8LFEopg41tMZ25gAlcARJ6v5J2v/rEvXdr/bB/54zxVNpYPTilbfkgKUpnT0aeOoE6KKp0E8fpH1akz649AFS94u9FwkS7NZHljfEXyCwfBw4op3C7Nv7q93vzRBYLt7MzoqCCzpO3NMJoWXEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754047603; c=relaxed/simple;
	bh=wdt6Kwvm2hqddw/1GaZbZ5bzXAIOICs3gTIo1FllAXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JJ3neQMF/sE6t3EyX1HeghTlDeTE1cLLmqXq6SwOFZ5LJ5dHziKa7fg/nGSbnPkON2RyKXZe+t+ZQdN9o8mC9inmAAG3NsgakWLs2gIQB965GlR7BeoLieQVYp+jixsYK+mRzQUlgveja2+9JjLKThqJHKIFTWKiNwWB+t7scbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VGx3N9Ej; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VGx3N9Ej"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754047602; x=1785583602;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wdt6Kwvm2hqddw/1GaZbZ5bzXAIOICs3gTIo1FllAXw=;
  b=VGx3N9EjxI5znjOelLG0STme32Gu1l0Am73tLrsXHYbM0hugukQkJAOH
   OEkpc3aAxJusencOmUeZWJVUPhqV02DJCM7QpkZFNxB5d6Naqy0HSw5q9
   juincEN0waM8EiBD18SMs+iR3QNyQJMVH5gIio3vv8iiGNiI2nj2Ezczt
   E5VspCeKFaf6DjGwAHwn0q3TN0i7FsO25O5gQseocUpMX/LjyYK+C/vlB
   fgczmPsaX/kOWIjkbeXVmHYm2jF1fYecB8UJwjMSghzEpgPpwYe+RDRkZ
   gZWRcyS47SCzZbaXJgNB6cCyPgN20TT1Dl+JAVEiwURMzZKrY97y07wRL
   A==;
X-CSE-ConnectionGUID: vMvImARfRBukgN85yt0rsw==
X-CSE-MsgGUID: 10Rz/vCxTZ+8TgLDWVV/1A==
X-IronPort-AV: E=McAfee;i="6800,10657,11508"; a="59014761"
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="59014761"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2025 04:26:42 -0700
X-CSE-ConnectionGUID: nNffPxKnRWqM7y4eEv9rUw==
X-CSE-MsgGUID: +/NctWkXTPuaYdG57Wzc/Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="167727067"
Received: from sschumil-mobl2.ger.corp.intel.com (HELO eresheto-mobl3.ger.corp.intel.com) ([10.245.244.159])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2025 04:26:37 -0700
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
Subject: [PATCH v10 1/6] x86/sgx: Convert sgx_(vepc_)open to __sgx_(vepc_)open
Date: Fri,  1 Aug 2025 14:25:16 +0300
Message-ID: <20250801112619.1117549-2-elena.reshetova@intel.com>
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

In order to introduce the counting of active sgx users on top
of clean functions that allocate vepc structures, covert existing
sgx_(vepc_)open to __sgx_(vepc_)open. Later patch will introduce the
top level wrappers that manage the usage count.

No functional change intended in this patch.

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
---
 arch/x86/kernel/cpu/sgx/driver.c | 4 ++--
 arch/x86/kernel/cpu/sgx/virt.c   | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx/driver.c
index 7f8d1e11dbee..9aa48f455c54 100644
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
@@ -126,7 +126,7 @@ static long sgx_compat_ioctl(struct file *filep, unsigned int cmd,
 
 static const struct file_operations sgx_encl_fops = {
 	.owner			= THIS_MODULE,
-	.open			= sgx_open,
+	.open			= __sgx_open,
 	.release		= sgx_release,
 	.unlocked_ioctl		= sgx_ioctl,
 #ifdef CONFIG_COMPAT
diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/virt.c
index 7aaa3652e31d..d8fdf7f39215 100644
--- a/arch/x86/kernel/cpu/sgx/virt.c
+++ b/arch/x86/kernel/cpu/sgx/virt.c
@@ -258,7 +258,7 @@ static int sgx_vepc_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static int sgx_vepc_open(struct inode *inode, struct file *file)
+static int __sgx_vepc_open(struct inode *inode, struct file *file)
 {
 	struct sgx_vepc *vepc;
 
@@ -291,7 +291,7 @@ static long sgx_vepc_ioctl(struct file *file,
 
 static const struct file_operations sgx_vepc_fops = {
 	.owner		= THIS_MODULE,
-	.open		= sgx_vepc_open,
+	.open		= __sgx_vepc_open,
 	.unlocked_ioctl	= sgx_vepc_ioctl,
 	.compat_ioctl	= sgx_vepc_ioctl,
 	.release	= sgx_vepc_release,
-- 
2.45.2

