Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794573926;
	b=iy+a7ii5zmJ23uLA70uRwulDd/qZQyWpS0yZbV3e26RYUQsGSFjbnqoFWcxrEU66GEly
	 rcJOMSvgid+d3OuUh3Vf6ey/vxNLq9EIy8BhV8K2sob6yuXFkT9N/helpusJSaCskRtp6
	 ELCMmh0fMx4ApTeJdVLO4ZMSlQl0/yPSmBk9tLHJ5NId6GAPpZtgRSgDROUrCIAaVA4M8
	 5KxSvfJMWFaQsJb2rUSjAX3STtHj5CnIyaD8kM1itddmzjmXEVdIR9X5e62F1k/aU6QDf
	 J3A5utDShOQwsK18jWCXsGaanaHlExpfgbIOs4Vn9TZ+0T5zbARwhB1TuaVDR4U7trg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794573926;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:X-Developer-Signature:
	 X-Developer-Key:Content-Transfer-Encoding;
	bh=1Om/c4rRG79VfBPapCBvLJEytmGc3tVeAOxAHopmSTY=;
	b=XVrQU/jKJRmVTqjeRIoX+Km5yqAe4268gWcDAnnJLoFhb6PdZ3I2in1OwdOGtEHuSO/w
	 vDtEeOdiC9IPxUfpMxs0JgoudY6d7DG6AkRk6Z9oajyQuhVWPLnssy1IIty+Edi78CXQc
	 ElsvYkbF/e6jc/yuUSdJKUSE7wFI5u4jW+Wd1YVQRJRnDWj3gFFf6YV5fswUX3ICUMTMp
	 JxIS3aZBnQ27bijGU9UU5oaaUVLVmKn1E5SUAXHII1Q4ovL7q2bGnMEogudv9Nlw1jcad
	 tuPgnPhJ4I8UEN8v9ctrlXk1UXd9Jc+13IIw7M0Gf+/VzYAR5dhqxW9fYrHiSidu9wg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bF0f6xG5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E6F8606A88F;
	Fri, 13 Nov 2026 12:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bF0f6xG5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9F311F000C7;
	Fri, 13 Nov 2026 12:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794573925;
	bh=1Om/c4rRG79VfBPapCBvLJEytmGc3tVeAOxAHopmSTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bF0f6xG5MmvtJ6RNtexvU5RfUMH9HGcjIj/DPK1vk00k6DL/1bar1i1O3TA0zHNOk
	 p6+vAH8Jy9uTgBi3EFLiivxCDHBKgFlEAODQ4YZYPWgMdqra7OE9ZxF9UEHvtvFRuD
	 +X6R7HrUBmIDnmVU31JH548A82V1pXCrXc0I/T1sBcTY/NchMYq6VtIxINgWj5JEez
	 v+QZ78i5yMnMVx/LMUzdJjUudRMVyLhWOAZM5vY1jwjRroZ0OIzF7mqmJ2NWWoRBiu
	 dPqpesZj++MJkpkZ+UGLkHN4lqZqNP2OBtCFtCl/ezSGaENjzbVNwitMq7xCb69zOE
	 7YXVqwTy/1uHw==
From: Thorsten Blum <blum@kernel.org>
To: Jarkko Sakkinen <jarkko@kernel.org>,
	Kai Huang <kai.huang@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org
Cc: linux-sgx@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Thorsten Blum <blum@kernel.org>
Subject: [PATCH RESEND v2 1/3] x86/sgx: Remove unused TCS definitions
Date: Fri, 13 Nov 2026 13:44:50 +0100
Message-ID: <20261113124448.70586-6-blum@kernel.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261113124448.70586-5-blum@kernel.org>
References: <20261113124448.70586-5-blum@kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Post: <mailto:linux-sgx@vger.kernel.org>
List-Help: <mailto:linux-sgx+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sgx+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2598; i=blum@kernel.org; h=from:subject; bh=j1Cg73sUSknkBaxqEaUUOsQH4V5Ks4UDJ0nWU7jSUZM=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFnf2dyzJu5cOXn6/Aef3P4d5zpuc/rUMqkqy9jA7GP51 046a3+43FHKwiDGxSArpsjyYNaPGb6lNZWbTCJ2wsxhZQIZwsDFKQATETnK8N/JpUJ343Pv/FQ+ RiOrdJZfuwOMfkRE/zvY+2r+1yUOJbaMDG8O8De4LbjHK8iw4ozBo78HqqzP/jkyfzPzwbbC3sZ Fr7gA
X-Developer-Key: i=blum@kernel.org; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit

The TCS structure was added with commit 70d3b8ddcd20 ("x86/sgx: Add SGX
architectural data structures"), but has never had an in-tree user.
Remove the unused TCS structure and its corresponding definitions.

Acked-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Thorsten Blum <blum@kernel.org>
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
