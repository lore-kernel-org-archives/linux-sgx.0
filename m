Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 483392F619A;
	Wed, 10 Dec 2025 15:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765380784; cv=none; b=j0yGZGOg5t1iCCIw59Ot0rV4clMhEi13TsFzPi8SgwI93nUgxA8JIiOPfCdjaNloiUTpSPSRufWMnkDWi2W7gozobdzCxzIiQ2TqC2rZZnH/oWnDgBhvV+UsA2Srb8ylL2XwIeCLxM0asbAoU2kBQN7HNCCEdB8xlAqQzlkzCM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765380784; c=relaxed/simple;
	bh=1EcFtAqW2Qmrm3D2+u6ooTWME4t6u4tm4dV+AdPu/c8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R47x3I6nzZmPlFksfe+7UrZBVwgXczVSege4tz7IhtsEyuMZ9pSdH9ua60F9uXm41uzWnVNOCaFc+zYmEMDDwKzz2oa1MxXONuyTpyBJS+lhXibsL9SW0eCjOMywgSFA7bhGrM0QDYWeA5v1ZHX5lbK8YU88yvzR3x63AQWtyMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AMsdzHAT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AMsdzHAT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85681C116B1;
	Wed, 10 Dec 2025 15:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765380784;
	bh=1EcFtAqW2Qmrm3D2+u6ooTWME4t6u4tm4dV+AdPu/c8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AMsdzHATc/MU4Bc4KqiY9ZggPVVRtbp3BMaBQal3EiCVBUG5bW2PrAqi6a3qMMDwK
	 S0NPSXOkf21JV9lyxBAY77hb3kO0VpBIui4dUy5vRjZQ70GiN4h349vZK8a44j4CUZ
	 bosP+Y3Q7DJ5t0/RgE1ExVJOQxcId75f7GlOTtmj5W8mGkexNXbuVaLgCncWdQviyJ
	 OcocZm2L73bm9vS45MEHxHtLizjzNA/M04yrpsNBqrDy+kktQZHlGe6CSZrynOGaYR
	 lmsp0jZQPG2yUMC5Ngb2pNEWJ8pLpx4X/RaPy49iHrL7fnqUeCPPWdIoLODmQwUgr6
	 1Xu7Iho5UOe6Q==
Date: Wed, 10 Dec 2025 17:32:59 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
	linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/sgx: Use goto to remove redundant if check in
 sgx_encl_init
Message-ID: <aTmSq5Px4P6vEUCb@kernel.org>
References: <20251210130035.545132-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251210130035.545132-1-thorsten.blum@linux.dev>

On Wed, Dec 10, 2025 at 02:00:35PM +0100, Thorsten Blum wrote:
> Immediately break out of both loops when 'ret != SGX_UNMASKED_EVENT'
> instead of checking for the same condition again in the outer loop.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  arch/x86/kernel/cpu/sgx/ioctl.c | 10 +++-------
>  1 file changed, 3 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
> index 9322a9287dc7..c1e9841685e8 100644
> --- a/arch/x86/kernel/cpu/sgx/ioctl.c
> +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
> @@ -521,15 +521,10 @@ static int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct *sigstruct,
>  
>  			preempt_enable();
>  
> -			if (ret == SGX_UNMASKED_EVENT)
> -				continue;
> -			else
> -				break;
> +			if (ret != SGX_UNMASKED_EVENT)
> +				goto skip_loop;
>  		}
>  
> -		if (ret != SGX_UNMASKED_EVENT)
> -			break;
> -
>  		msleep_interruptible(SGX_EINIT_SLEEP_TIME);
>  
>  		if (signal_pending(current)) {
> @@ -538,6 +533,7 @@ static int sgx_encl_init(struct sgx_encl *encl, struct sgx_sigstruct *sigstruct,
>  		}
>  	}
>  
> +skip_loop:
>  	if (encls_faulted(ret)) {
>  		if (encls_failed(ret))
>  			ENCLS_WARN(ret, "EINIT");
> -- 
> Thorsten Blum <thorsten.blum@linux.dev>
> GPG: 1D60 735E 8AEF 3BE4 73B6  9D84 7336 78FD 8DFE EAD4
> 

I don't think moving code around is very useful.

BR, Jarkko
