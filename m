Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD48A12C544;
	Fri, 28 Mar 2025 12:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743166773; cv=none; b=uzj43RTvXm4Y1XAcGHegNbgG6DC/Ej3duXuu4b/OsKn9dGTwZ5VJ9/ixnQ4v1RwIm1OQLU0lX6Ezj7/7265VhZdm/g3sWh1k5SIWB+IM4tnCOhRiNOu24TLRl5VLTSuUABdsdDF54vrANGXbUVJRnjjywvN6Gj9P+9rGZtqY5aY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743166773; c=relaxed/simple;
	bh=UB/fDJ/QqOa7MrXsTYyagNN5cqeuOIX+1agyXmikbSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VdDUe1s795qatoCdJGOKOs25GLt+ga2K2EKwDAvJK0b9NsNz9vrtJi/ykLK/bEZOGLjn4YPABIHWSIVsFAIwIhFJIo+iu00u+OHEuTFX1nLD+aEvtyLHgj7APqUNCOkkOqk1hzgzsAYKErtUCRbW0uxQUt1VdluMj0vo4XnZ06Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=S+0U2bAv; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="S+0U2bAv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743166772; x=1774702772;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UB/fDJ/QqOa7MrXsTYyagNN5cqeuOIX+1agyXmikbSk=;
  b=S+0U2bAvDIBPFKwUfaIHkrLvy2kr5sTIXqkB/eA7NJ4aN0mayde7v/lP
   nTg6b84PC2WqN7EFfghEQGAmVLTSYTWg9gS189Y3jIL+vO8qvKwn0z7qb
   qS0dHCYNFVSMvVBqJuHF+4bvTf0tan91co26luWlX5Ulck7TbadWPs+sV
   A+anBs6VYOvDYTJslEsTP9Pp35LOwxOi54UyimtO4XuatIpKFgbNOKw9g
   ZBH4/NFY/S06DFdmc+Kgd8MEa0LxuwAA5XY5nO9XbVjIdyBtaTqt2TiG3
   C22+BOXwdXUTTshBCdMJLBFp2/8k545P05kpnLrSSefgcgbQcVPKXpzRV
   A==;
X-CSE-ConnectionGUID: mk0ogi2/Tbab4PN8XFTajg==
X-CSE-MsgGUID: KaOsQXsiQRmboku9BskkAA==
X-IronPort-AV: E=McAfee;i="6700,10204,11387"; a="44633109"
X-IronPort-AV: E=Sophos;i="6.14,283,1736841600"; 
   d="scan'208";a="44633109"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2025 05:59:32 -0700
X-CSE-ConnectionGUID: Zee61CzZRwqCcyUNFVcdhQ==
X-CSE-MsgGUID: igUVKwlDS+yC9OSiQui1mg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,283,1736841600"; 
   d="scan'208";a="125341420"
Received: from lfiedoro-mobl.ger.corp.intel.com (HELO eresheto-mobl3.ger.corp.intel.com) ([10.245.246.104])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2025 05:59:25 -0700
From: Elena Reshetova <elena.reshetova@intel.com>
To: dave.hansen@intel.com
Cc: jarkko@kernel.org,
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
Subject: [PATCH v2 2/2] x86/sgx: Implement EUPDATESVN and opportunistically call it during first EPC page alloc
Date: Fri, 28 Mar 2025 14:57:41 +0200
Message-ID: <20250328125859.73803-3-elena.reshetova@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250328125859.73803-1-elena.reshetova@intel.com>
References: <20250328125859.73803-1-elena.reshetova@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

SGX architecture introduced a new instruction called EUPDATESVN
to Ice Lake. It allows updating security SVN version, given that EPC
is completely empty. The latter is required for security reasons
in order to reason that enclave security posture is as secure as the
security SVN version of the TCB that created it.

Additionally it is important to ensure that while ENCLS[EUPDATESVN]
runs, no concurrent page creation happens in EPC, because it might
result in #GP delivered to the creator. Legacy SW might not be prepared
to handle such unexpected #GPs and therefore this patch introduces
a locking mechanism to ensure no concurrent EPC allocations can happen.

It is also ensured that ENCLS[EUPDATESVN] is not called when running
in a VM since it does not have a meaning in this context (microcode
updates application is limited to the host OS) and will create
unnecessary load.

This patch is based on previous submision by Cathy Zhang
https://lore.kernel.org/all/20220520103904.1216-1-cathy.zhang@intel.com/

Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
---
 arch/x86/include/asm/sgx.h      | 41 +++++++++++++--------
 arch/x86/kernel/cpu/sgx/encls.h |  6 ++++
 arch/x86/kernel/cpu/sgx/main.c  | 63 ++++++++++++++++++++++++++++++++-
 arch/x86/kernel/cpu/sgx/sgx.h   |  1 +
 4 files changed, 95 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
index 6a0069761508..5caf5c31ebc6 100644
--- a/arch/x86/include/asm/sgx.h
+++ b/arch/x86/include/asm/sgx.h
@@ -26,23 +26,26 @@
 #define SGX_CPUID_EPC_SECTION	0x1
 /* The bitmask for the EPC section type. */
 #define SGX_CPUID_EPC_MASK	GENMASK(3, 0)
+/* EUPDATESVN presence indication */
+#define SGX_CPUID_EUPDATESVN	BIT(10)
 
 enum sgx_encls_function {
-	ECREATE	= 0x00,
-	EADD	= 0x01,
-	EINIT	= 0x02,
-	EREMOVE	= 0x03,
-	EDGBRD	= 0x04,
-	EDGBWR	= 0x05,
-	EEXTEND	= 0x06,
-	ELDU	= 0x08,
-	EBLOCK	= 0x09,
-	EPA	= 0x0A,
-	EWB	= 0x0B,
-	ETRACK	= 0x0C,
-	EAUG	= 0x0D,
-	EMODPR	= 0x0E,
-	EMODT	= 0x0F,
+	ECREATE		= 0x00,
+	EADD		= 0x01,
+	EINIT		= 0x02,
+	EREMOVE		= 0x03,
+	EDGBRD		= 0x04,
+	EDGBWR		= 0x05,
+	EEXTEND		= 0x06,
+	ELDU		= 0x08,
+	EBLOCK		= 0x09,
+	EPA		= 0x0A,
+	EWB		= 0x0B,
+	ETRACK		= 0x0C,
+	EAUG		= 0x0D,
+	EMODPR		= 0x0E,
+	EMODT		= 0x0F,
+	EUPDATESVN	= 0x18,
 };
 
 /**
@@ -73,6 +76,11 @@ enum sgx_encls_function {
  *				public key does not match IA32_SGXLEPUBKEYHASH.
  * %SGX_PAGE_NOT_MODIFIABLE:	The EPC page cannot be modified because it
  *				is in the PENDING or MODIFIED state.
+ * %SGX_INSUFFICIENT_ENTROPY:	Insufficient entropy in RNG.
+ * %SGX_EPC_NOT_READY:		EPC is not ready for SVN update.
+ * %SGX_NO_UPDATE:		EUPDATESVN was successful, but CPUSVN was not
+ *				updated because current SVN was not newer than
+ *				CPUSVN.
  * %SGX_UNMASKED_EVENT:		An unmasked event, e.g. INTR, was received
  */
 enum sgx_return_code {
@@ -81,6 +89,9 @@ enum sgx_return_code {
 	SGX_CHILD_PRESENT		= 13,
 	SGX_INVALID_EINITTOKEN		= 16,
 	SGX_PAGE_NOT_MODIFIABLE		= 20,
+	SGX_INSUFFICIENT_ENTROPY	= 29,
+	SGX_EPC_NOT_READY		= 30,
+	SGX_NO_UPDATE			= 31,
 	SGX_UNMASKED_EVENT		= 128,
 };
 
diff --git a/arch/x86/kernel/cpu/sgx/encls.h b/arch/x86/kernel/cpu/sgx/encls.h
index 99004b02e2ed..3d83c76dc91f 100644
--- a/arch/x86/kernel/cpu/sgx/encls.h
+++ b/arch/x86/kernel/cpu/sgx/encls.h
@@ -233,4 +233,10 @@ static inline int __eaug(struct sgx_pageinfo *pginfo, void *addr)
 	return __encls_2(EAUG, pginfo, addr);
 }
 
+/* Update CPUSVN at runtime. */
+static inline int __eupdatesvn(void)
+{
+	return __encls_ret_1(EUPDATESVN, "");
+}
+
 #endif /* _X86_ENCLS_H */
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index b61d3bad0446..24563110811d 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -32,6 +32,11 @@ static DEFINE_XARRAY(sgx_epc_address_space);
 static LIST_HEAD(sgx_active_page_list);
 static DEFINE_SPINLOCK(sgx_reclaimer_lock);
 
+/* This lock is held to prevent new EPC pages from being created
+ * during the execution of ENCLS[EUPDATESVN].
+ */
+static DEFINE_SPINLOCK(sgx_epc_eupdatesvn_lock);
+
 static atomic_long_t sgx_nr_used_pages = ATOMIC_LONG_INIT(0);
 static unsigned long sgx_nr_total_pages;
 
@@ -457,7 +462,17 @@ static struct sgx_epc_page *__sgx_alloc_epc_page_from_node(int nid)
 	page->flags = 0;
 
 	spin_unlock(&node->lock);
-	atomic_long_inc(&sgx_nr_used_pages);
+
+	if (!atomic_long_inc_not_zero(&sgx_nr_used_pages)) {
+		spin_lock(&sgx_epc_eupdatesvn_lock);
+		/* Only call sgx_updatesvn() once the first enclave's
+		 * page is allocated from EPC
+		 */
+		if (atomic_long_read(&sgx_nr_used_pages) == 0)
+			sgx_updatesvn();
+		atomic_long_inc(&sgx_nr_used_pages);
+		spin_unlock(&sgx_epc_eupdatesvn_lock);
+	}
 
 	return page;
 }
@@ -970,3 +985,49 @@ static int __init sgx_init(void)
 }
 
 device_initcall(sgx_init);
+
+/**
+ * sgx_updatesvn() - Issue ENCLS[EUPDATESVN]
+ * If EPC is ready, this instruction will update CPUSVN to the currently
+ * loaded microcode update SVN and generate new cryptographic assets.
+ */
+void sgx_updatesvn(void)
+{
+	int retry = 10;
+	int ret;
+
+	lockdep_assert_held(&sgx_epc_eupdatesvn_lock);
+
+	if (!(cpuid_eax(SGX_CPUID) & SGX_CPUID_EUPDATESVN))
+		return;
+
+	/* Do not execute ENCLS[EUPDATESVN] if running in a VM since
+	 * microcode updates are only meaningful to be applied on the host.
+	 */
+	if (boot_cpu_has(X86_FEATURE_HYPERVISOR))
+		return;
+
+	do {
+		ret = __eupdatesvn();
+		if (ret != SGX_INSUFFICIENT_ENTROPY)
+			break;
+
+	} while (--retry);
+
+	switch (ret) {
+	case 0:
+		pr_info("EUPDATESVN: success\n");
+		break;
+	case SGX_EPC_NOT_READY:
+	case SGX_INSUFFICIENT_ENTROPY:
+	case SGX_EPC_PAGE_CONFLICT:
+		pr_err("EUPDATESVN: error %d\n", ret);
+		break;
+	case SGX_NO_UPDATE:
+		break;
+	default:
+		pr_err("EUPDATESVN: unknown error %d\n", ret);
+		break;
+	}
+
+}
diff --git a/arch/x86/kernel/cpu/sgx/sgx.h b/arch/x86/kernel/cpu/sgx/sgx.h
index d2dad21259a8..12ae49e78959 100644
--- a/arch/x86/kernel/cpu/sgx/sgx.h
+++ b/arch/x86/kernel/cpu/sgx/sgx.h
@@ -103,5 +103,6 @@ static inline int __init sgx_vepc_init(void)
 #endif
 
 void sgx_update_lepubkeyhash(u64 *lepubkeyhash);
+void sgx_updatesvn(void);
 
 #endif /* _X86_SGX_H */
-- 
2.45.2

