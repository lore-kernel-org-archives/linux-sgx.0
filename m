Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073E2488773
	for <linux-sgx@vger.kernel.org>; Wed, 29 Jul 2026 12:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785329834; cv=none; b=stSkNArhQWu+qJ0xDP6DE7ZbBu3n85x5L3eHnSm7L3nordC/x+UedDzDsmU5kJVVu0fyUFvf9fUFgv0QIHZz9N5p2rJBnZvdo5PwT8P4ClnO6ai0kdXBEImScY2pWl2uzGWNeXXx0QnOP3itpnmkk3F4Ui4zcP3LgsiuOy48uzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785329834; c=relaxed/simple;
	bh=tE/3wBaWmfJhrTOJl412K6ZCc8lrcqn+JbfOZG7yMww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EWosjs9EbDFqA5B4ufS6qMFS94usffoHgeIAElb5NTqAV092AA8LBGBqYEb0WQdemQMr40gxeDhg3vGmmHdTfzZY8ePVd/CtuUiNIvpMyQ2RiFSoo0ktRpNY15HEEeHt8UeWx8OXJDxm/pNYskerJc7Ui1yBOGV+1u15kUJE7LE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=B62cC5Vc; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="B62cC5Vc"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785329811;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t0zUa/3j4PsfvidPVIQwBKOtar7vHPGtPPo6X0V12Ok=;
	b=B62cC5VcSW5B/il1oRsb6J5VDePq6oa9ZVjLvfu+A19HNRUetKhLps8DEK39hNSUY2Ae6O
	8OSoX2mnnrBJ4ULGwj8G7y2fdbZW7w+eyj2EuugCqc6DLmRQjJmADJXYvUwylViXhu/Xrl
	mH3B477VaVLz/qOjNMVOFMVbFXm5e/0=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Jarkko Sakkinen <jarkko@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org
Cc: linux-sgx@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Kai Huang <kai.huang@intel.com>
Subject: [PATCH v2 1/3] x86/sgx: Remove unused TCS definitions
Date: Wed, 29 Jul 2026 14:56:26 +0200
Message-ID: <20260729125624.514697-6-thorsten.blum@linux.dev>
In-Reply-To: <20260729125624.514697-5-thorsten.blum@linux.dev>
References: <20260729125624.514697-5-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2606; i=thorsten.blum@linux.dev; h=from:subject; bh=tE/3wBaWmfJhrTOJl412K6ZCc8lrcqn+JbfOZG7yMww=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFmZPyp6eRJXm5/15/BecXGhTYFT89Zixag7gjfuebM0b A7VSBDrKGVhEONikBVTZHkw68cM39Kayk0mETth5rAygQxh4OIUgIksecnIcC/il5Gk2x3Tf3dd M8/b7Fg282i44qcG/l38Xhb2i/P/rmD4n6x+cuINk/Zpk11UFlWqzG09GpWbeHXmR+Wgd0Ker21 XMAEA
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The TCS structure was added with commit 70d3b8ddcd20 ("x86/sgx: Add SGX
architectural data structures"), but has never had an in-tree user.
Remove the unused TCS structure and its corresponding definitions.

Acked-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 arch/x86/include/asm/sgx.h | 50 --------------------------------------
 1 file changed, 50 deletions(-)

diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
index 04958459a7ca..fe106c55a593 100644
--- a/arch/x86/include/asm/sgx.h
+++ b/arch/x86/include/asm/sgx.h
@@ -193,56 +193,6 @@ struct sgx_secs {
 	u8  reserved4[3834];
 } __packed;
 
-/**
- * enum sgx_tcs_flags - execution flags for TCS
- * @SGX_TCS_DBGOPTIN:	If enabled allows single-stepping and breakpoints
- *			inside an enclave. It is cleared by EADD but can
- *			be set later with EDBGWR.
- */
-enum sgx_tcs_flags {
-	SGX_TCS_DBGOPTIN	= 0x01,
-};
-
-#define SGX_TCS_RESERVED_MASK	GENMASK_ULL(63, 1)
-#define SGX_TCS_RESERVED_SIZE	4024
-
-/**
- * struct sgx_tcs - Thread Control Structure (TCS)
- * @state:		used to mark an entered TCS
- * @flags:		execution flags (cleared by EADD)
- * @ssa_offset:		SSA stack offset relative to the enclave base
- * @ssa_index:		the current SSA frame index (cleard by EADD)
- * @nr_ssa_frames:	the number of frame in the SSA stack
- * @entry_offset:	entry point offset relative to the enclave base
- * @exit_addr:		address outside the enclave to exit on an exception or
- *			interrupt
- * @fs_offset:		offset relative to the enclave base to become FS
- *			segment inside the enclave
- * @gs_offset:		offset relative to the enclave base to become GS
- *			segment inside the enclave
- * @fs_limit:		size to become a new FS-limit (only 32-bit enclaves)
- * @gs_limit:		size to become a new GS-limit (only 32-bit enclaves)
- *
- * Thread Control Structure (TCS) is an enclave page visible in its address
- * space that defines an entry point inside the enclave. A thread enters inside
- * an enclave by supplying address of TCS to ENCLU(EENTER). A TCS can be entered
- * by only one thread at a time.
- */
-struct sgx_tcs {
-	u64 state;
-	u64 flags;
-	u64 ssa_offset;
-	u32 ssa_index;
-	u32 nr_ssa_frames;
-	u64 entry_offset;
-	u64 exit_addr;
-	u64 fs_offset;
-	u64 gs_offset;
-	u32 fs_limit;
-	u32 gs_limit;
-	u8  reserved[SGX_TCS_RESERVED_SIZE];
-} __packed;
-
 /**
  * struct sgx_pageinfo - an enclave page descriptor
  * @addr:	address of the enclave page
