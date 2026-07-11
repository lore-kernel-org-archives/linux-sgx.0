Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3022F30EF64
	for <linux-sgx@vger.kernel.org>; Sat, 11 Jul 2026 10:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783764084; cv=none; b=BfJb97e3cnEGfmJL+L2M/cUTWG1FNLAea/cTdQKdXAdBmhn0KqpG3ns4FLQQYo4nO1mlq3xYi+epxoi3AvoNhjjOvDVx/07+uEG74E6Uc75rSi8eRNghdg/5UbSpnHsktMYDRPPv3eWlBblctOrVHHxZFBr0FyphmqTIBrf0K58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783764084; c=relaxed/simple;
	bh=B/7vjjGQ846mvBrqjPHXSmexP863zQRhj+GS0fit7qs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OCt25Y/7i0JFHLeBLrs9BOYhSqCmXtq72KbJAIukGBff3xKuIDYjAes+80CbRy4WT7G/fNn2M654i1WS+VGvKMAs19USopejKKUTqIXt+hVuk4p3Fx/EMOrZCsXjoF5yT9S1LIYG8eBIncyW5kWnWvZF5seXH1yL/dfXo7LS6HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=wGiCh9gu; arc=none smtp.client-ip=91.218.175.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="wGiCh9gu"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783764079;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PdwuQWYTp04Iu5vMRYQmp4uQKNb0dMqdO+c1bic/th4=;
	b=wGiCh9guRTiOBsDIvggNZoS2HtlDYpE1AZn5HyFXIcqIxGNZMTwdLAI1H6G0AIKQ50jWGS
	J2Ybh1QotzGIgz7f96gf8uGtfcbDeIhvfOx/WKM2Y/KDPrL4GQidqXW5d39XcyK77QhgYb
	uIaWeD7jxM7r7ajUkKTVGOlUFK+C75M=
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
	Thorsten Blum <thorsten.blum@linux.dev>
Subject: [PATCH 1/3] x86/sgx: Remove unused TCS definitions
Date: Sat, 11 Jul 2026 12:00:55 +0200
Message-ID: <20260711100053.739588-6-thorsten.blum@linux.dev>
In-Reply-To: <20260711100053.739588-5-thorsten.blum@linux.dev>
References: <20260711100053.739588-5-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2513; i=thorsten.blum@linux.dev; h=from:subject; bh=B/7vjjGQ846mvBrqjPHXSmexP863zQRhj+GS0fit7qs=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFlBImE3568IE9t55adxk++y83J9d1Z/ln/popCnob574 rnFOhNXdZSyMIhxMciKKbI8mPVjhm9pTeUmk4idMHNYmUCGMHBxCsBE3O4y/PeKttt/IvNsxPr9 8/m8k5ymSAtr7S248bK551XLy1yV/lqGf6ZqK59vm55e+PRORM2PjscLjbXlslyeHOpq6Gacnp6 gzAoA
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The TCS structure was added with commit 70d3b8ddcd20 ("x86/sgx: Add SGX
architectural data structures"), but has never had an in-tree user.
Remove the unused TCS structure and its corresponding definitions.

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
