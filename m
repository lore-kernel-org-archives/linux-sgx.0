Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F47B13A244;
	Sat, 11 Jul 2026 18:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783794127; cv=none; b=MGfWWq7xxM0kJwjzeKEQy1xWIUGxnw7pzkBbUv8ZQqPP+tD46VkQEzZVmxVzblDM/3LcMn4xSBBowQOP9L8X174SVqy2Q/scl32iiuMgoe+0u8VDKnvFbn1yZM3E3HEl6+lC0tj70Gmp/iH+reN6+ZwwW7KFX5lV6Tse9hZFU48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783794127; c=relaxed/simple;
	bh=2ko3QoNC5CBc3/QOeJk7E1fZ/H/9FXGdfp3JEcbLV6E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n4y6x2qBTN7qeNOX2Vy1Wf+XUHNAxZaymEEKVqXt6BD6WxV+ASbV73z3XMD0ZuOWqceBvd+As7HktmkDuRPJ7wocsZD7irXwt4Jxpz85HJqbwLIjf5uAIUUVkNnV7EoO8cOE2lqgNvj2N/2jLQneiPUyZ1T8r8c0pPmTOw6Uyl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FhSYeydH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FhSYeydH"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0CD691F000E9;
	Sat, 11 Jul 2026 18:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783794125;
	bh=/fb/VJe9zLVfQ8Nb5EAowyU3BezRlVdoOD+TtYisOrg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FhSYeydHKHKXC30IW7Qdi0CQ3ysggOuNFWOILYYKjz+E0yagRPiQFsG0zoN+T3qtd
	 YAmgM8NMyFGd5pOG3IgqxKaepkRKLacPClg8mvqbe/uotBmvoiuiqUZNh0QJlUI06k
	 6Q0IClxdC6viVyOla4YDqrBDT4oy/hXwFjLa1IeTZ0/kvecaDjV1JBU4KD1v+MPjXq
	 rab5TJ1mafSDolQQyYiGQlG3liq8BqsZcyggzkEKx5FdWahrh02TGH//2AzoAxHo8o
	 UP9+pjOEgMWL4DOYbx1ob8A6+kiIiG5uHFveLaMVhm57J90dpgA5+SJqxXSVGZX3N6
	 VWfDXCwQJTfYw==
Date: Sat, 11 Jul 2026 21:22:01 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org, linux-sgx@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] x86/sgx: Remove unused TCS definitions
Message-ID: <alKJya_l4SzvtGBa@kernel.org>
References: <20260711100053.739588-5-thorsten.blum@linux.dev>
 <20260711100053.739588-6-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260711100053.739588-6-thorsten.blum@linux.dev>

On Sat, Jul 11, 2026 at 12:00:55PM +0200, Thorsten Blum wrote:
> The TCS structure was added with commit 70d3b8ddcd20 ("x86/sgx: Add SGX
> architectural data structures"), but has never had an in-tree user.
> Remove the unused TCS structure and its corresponding definitions.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  arch/x86/include/asm/sgx.h | 50 --------------------------------------
>  1 file changed, 50 deletions(-)
> 
> diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
> index 04958459a7ca..fe106c55a593 100644
> --- a/arch/x86/include/asm/sgx.h
> +++ b/arch/x86/include/asm/sgx.h
> @@ -193,56 +193,6 @@ struct sgx_secs {
>  	u8  reserved4[3834];
>  } __packed;
>  
> -/**
> - * enum sgx_tcs_flags - execution flags for TCS
> - * @SGX_TCS_DBGOPTIN:	If enabled allows single-stepping and breakpoints
> - *			inside an enclave. It is cleared by EADD but can
> - *			be set later with EDBGWR.
> - */
> -enum sgx_tcs_flags {
> -	SGX_TCS_DBGOPTIN	= 0x01,
> -};
> -
> -#define SGX_TCS_RESERVED_MASK	GENMASK_ULL(63, 1)
> -#define SGX_TCS_RESERVED_SIZE	4024
> -
> -/**
> - * struct sgx_tcs - Thread Control Structure (TCS)
> - * @state:		used to mark an entered TCS
> - * @flags:		execution flags (cleared by EADD)
> - * @ssa_offset:		SSA stack offset relative to the enclave base
> - * @ssa_index:		the current SSA frame index (cleard by EADD)
> - * @nr_ssa_frames:	the number of frame in the SSA stack
> - * @entry_offset:	entry point offset relative to the enclave base
> - * @exit_addr:		address outside the enclave to exit on an exception or
> - *			interrupt
> - * @fs_offset:		offset relative to the enclave base to become FS
> - *			segment inside the enclave
> - * @gs_offset:		offset relative to the enclave base to become GS
> - *			segment inside the enclave
> - * @fs_limit:		size to become a new FS-limit (only 32-bit enclaves)
> - * @gs_limit:		size to become a new GS-limit (only 32-bit enclaves)
> - *
> - * Thread Control Structure (TCS) is an enclave page visible in its address
> - * space that defines an entry point inside the enclave. A thread enters inside
> - * an enclave by supplying address of TCS to ENCLU(EENTER). A TCS can be entered
> - * by only one thread at a time.
> - */
> -struct sgx_tcs {
> -	u64 state;
> -	u64 flags;
> -	u64 ssa_offset;
> -	u32 ssa_index;
> -	u32 nr_ssa_frames;
> -	u64 entry_offset;
> -	u64 exit_addr;
> -	u64 fs_offset;
> -	u64 gs_offset;
> -	u32 fs_limit;
> -	u32 gs_limit;
> -	u8  reserved[SGX_TCS_RESERVED_SIZE];
> -} __packed;
> -
>  /**
>   * struct sgx_pageinfo - an enclave page descriptor
>   * @addr:	address of the enclave page


Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko
