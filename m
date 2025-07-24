Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F8142737E9;
	Thu, 24 Jul 2025 08:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753344220; cv=none; b=JqBIaX9iMrU/gadshmHDZUnHvpV/EN9Pz/WPVQekm/sxAMc0uhaTubJyV7hYzK2ORYYpQfrrx8mnnyYr4W7jT2Y3TVQewR2NuPb3r71Er1FLcTl2UsTyy0CLHEMZfc2a8YLoYccDsZPKSuaMcz8oPHVsZUgcBjab3O9XvLUwGPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753344220; c=relaxed/simple;
	bh=wdt6Kwvm2hqddw/1GaZbZ5bzXAIOICs3gTIo1FllAXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RdDjPzwZ+wwUjg9w/FCBWZN/igxd6ldfsQEqevar6s0AmYnMcrWBxMK5IpoFCwIz1GfLVpFCWcRH/7+R+l5o7ZygChL4P3lvy+8fDh2gVIZd94PiLeNSRHjNzlTqOpBmyTU9zdUfKoWlC3iPdvcW9VM4iSLU1ZoA+YqOv6C6hZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PcmdQ/5u; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PcmdQ/5u"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753344219; x=1784880219;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wdt6Kwvm2hqddw/1GaZbZ5bzXAIOICs3gTIo1FllAXw=;
  b=PcmdQ/5uL7IjtyZ81ZtUOSq3yKM4aJlmv35hsr0prVzspXWGkB2bbFgu
   QLs2eRgVm+VABvaVDTRTXcMxhc8cKY9ZrUfndts5YX5Qh/ChkO1EmcWFq
   yCGQoCI66fBFu/zX7KvonBD1TWn5glyytm6puTbKUrfRFyaeatpltDxmT
   FUVRAvgteJl7MxAfFdJAcpaTnYkNxUFZTeKl1Y4GvZjf75opHm7/z43S2
   mFT3FCIuqIFuO/Dz+nXp8EqvU/+tFsCiVRHX/vfAkDVW7xYlwrOuVkMOJ
   XT8GTnRghz/5EMUdTEnKYXroIBIcTLVve/AcM+ZldDxaMrSgev4QEdntX
   w==;
X-CSE-ConnectionGUID: MOOsqXJvTk2ReziL9u9ong==
X-CSE-MsgGUID: 6tU1AHDMTYy3foYbKgL9mw==
X-IronPort-AV: E=McAfee;i="6800,10657,11501"; a="66991920"
X-IronPort-AV: E=Sophos;i="6.16,336,1744095600"; 
   d="scan'208";a="66991920"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 01:03:37 -0700
X-CSE-ConnectionGUID: POF8fgXkQj+6g2jC3NSdDA==
X-CSE-MsgGUID: wv07hMlKSj605vW1mddfig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,336,1744095600"; 
   d="scan'208";a="160341088"
Received: from savramon-mobl1 (HELO eresheto-mobl3.ger.corp.intel.com) ([10.245.244.60])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2025 01:03:32 -0700
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
Subject: [PATCH v9 1/6] x86/sgx: Convert sgx_(vepc_)open to __sgx_(vepc_)open
Date: Thu, 24 Jul 2025 11:02:10 +0300
Message-ID: <20250724080313.605676-2-elena.reshetova@intel.com>
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

