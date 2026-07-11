Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2DB12517A5;
	Sat, 11 Jul 2026 18:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783794196; cv=none; b=QaLHSbvayxd0sOWmfoubu+Mjb+upHxTgvCpb7PnCD9Tikabsc1Qg1IIenbSkHoL+l2ym0hQaIpczicXvWfFgTju7sCtFIpcIu84i38oNkwYMksFaPSMFdN8GaPIeaGwf594ATZvGZX+uCSyrVgrQD0O/bUxVp/Ef14Yboy1cv/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783794196; c=relaxed/simple;
	bh=TjWuL67NY6+MyQXFPQa8+WMwqqrZQC+yf2yEpKJwDLU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dwJZkOyaxGt38+Cw2299Bu1SrzQSwk5BD/0nYeNOGtiSGB+Qy6AdspvgqUG1unIYJ/EdFounIeOtZ0bOHab/f3XeCJexsIXeRKbKAtb5DE7t9iyDbLo0yZACeH2IgV7eB2f2Dv6vi+X0mzTa61/0bGeoLgneXFwyh4eR4dKCUho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EM4IONHa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EM4IONHa"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 3835F1F000E9;
	Sat, 11 Jul 2026 18:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783794194;
	bh=aj5/rQXlSwTxI+DOhLTt/8LkLdIf/q5Qaz6nmi9xa2w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EM4IONHa3C3ciT2wMzdHQ0/h7TTERyLyDBH4wQy5lE0gp0IOrgrvxzmVh0AB5BO5w
	 d5HqUHqRA/iEdAmhY8FQ+rCLX8ySV7MQvvca/LpKb6KiWJB0Uf3fIHebGqiLFo7M/M
	 kiz06aE2rfg8lQboR1wzwKeNR+5Fxal/LGk6Ly6HV2DV39teJgn+VXWw/rxP9qrBk1
	 zfFgf/8+skgS+ZFZqx5G8KFoKyG00di4St5Efy1XNU24ZSHzpSvpn9vNqbDQA8qzll
	 eGRPxmlB8L8hsLtf77pcFjf0bDgTXObLh9SR1N5bY4eqA8xD7/WIaSy01Q8x4OXxIP
	 MMpwz0Uhqb7hQ==
Date: Sat, 11 Jul 2026 21:23:11 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org, linux-sgx@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] x86/sgx: Use SGX_LAUNCH_TOKEN_SIZE in
 __sgx_virt_einit()
Message-ID: <alKKDyngXOKqvPtQ@kernel.org>
References: <20260711100053.739588-5-thorsten.blum@linux.dev>
 <20260711100053.739588-8-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260711100053.739588-8-thorsten.blum@linux.dev>

On Sat, Jul 11, 2026 at 12:00:57PM +0200, Thorsten Blum wrote:
> Both sgx_ioc_enclave_init() and __sgx_virt_einit() use the same 304-byte
> launch token. Use SGX_LAUNCH_TOKEN_SIZE in __sgx_virt_einit() instead of
> maintaining a second local definition, ensuring the token initialization
> and validation paths use the same size.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  arch/x86/kernel/cpu/sgx/virt.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/virt.c
> index db6806c40483..fa9173a9384a 100644
> --- a/arch/x86/kernel/cpu/sgx/virt.c
> +++ b/arch/x86/kernel/cpu/sgx/virt.c
> @@ -394,9 +394,8 @@ static int __sgx_virt_einit(void __user *sigstruct, void __user *token,
>  	 * All other checks deferred to ENCLS itself.  Also see comment
>  	 * for @secs in sgx_virt_ecreate().
>  	 */
> -#define SGX_EINITTOKEN_SIZE	304
>  	if (WARN_ON_ONCE(!access_ok(sigstruct, sizeof(struct sgx_sigstruct)) ||
> -			 !access_ok(token, SGX_EINITTOKEN_SIZE) ||
> +			 !access_ok(token, SGX_LAUNCH_TOKEN_SIZE) ||
>  			 !access_ok(secs, PAGE_SIZE)))
>  		return -EINVAL;
>  

true:

❯ git grep LAUNCH_TOKEN_SIZE
arch/x86/include/asm/sgx.h:#define SGX_LAUNCH_TOKEN_SIZE 304
arch/x86/kernel/cpu/sgx/ioctl.c:        memset(token, 0, SGX_LAUNCH_TOKEN_SIZE);

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko
