Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CC211C57A5;
	Tue, 27 Aug 2024 18:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724782911; cv=none; b=IYqwpixo90fjXv87WYPyoqggoucVmKUh+GezFhtTST3AYB6C+4jjkk0dLqBvU/H6en45nBEmvmVqhsrUu9cmd+5+aWYQsDIVvnnnOr5Q7UvbRR4KzbWdaEMVLhmL0GPQWCUq75kv8hTIuj+On7WD86nvmOl8xnrsz8WxdwZwhgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724782911; c=relaxed/simple;
	bh=PvGLi6GQ+NXl/8ldAF2LH6jGtMg/X2BT0prTRbzqHEw=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:Cc:Subject:From:
	 References:In-Reply-To; b=t6U1f+tzh45d5i8vt1FtlBjCMja8mk69ZgclyI7+1uR+LEzxCfOC0FYGqE4zmTx8FmfA7Or6Tef9G4XxEGVA5PiZuz7OUGTJwzZA2wDpo08YBMoMF46WV4lp/gZ/uliMXF+JLrxlvQW9BWA7W8grzFmFbS4XbdXp9OumahmThX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UJ55VvBD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UJ55VvBD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42D8FC4AF64;
	Tue, 27 Aug 2024 18:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724782910;
	bh=PvGLi6GQ+NXl/8ldAF2LH6jGtMg/X2BT0prTRbzqHEw=;
	h=Date:To:Cc:Subject:From:References:In-Reply-To:From;
	b=UJ55VvBDoEWA3HFm6hPAlLA1cVPnv1yleKlByVGVCbPo67TT8DaHPe913Oy00Ibi7
	 CfFmBq7opX91ET4gU7ciky6N9Lm0SHQEzAAcjCQj0IdYewPXcmSkHgx2WGIACXStjE
	 9Wn5zeGXbNZOnOGCflE3w6k6qlxZIQzfSlMOGhqk4RWMt6mXJzR5Gy0hrL21c+p9LN
	 KnbZNCoKs+UD6epnUtj8cKIkbxOn1GWMtKa474RivQ+4N/m1g2oicmo5tQjHCjwhF1
	 PLHVu/g9MYbVUgkyyyfKNzy5ghR7KU2pilk65Df/1QsRNbDNaPMCJG/4sjWwJAgtAy
	 CtPqJEj1lVKOQ==
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 27 Aug 2024 21:21:47 +0300
Message-Id: <D3QWIH0LVC3D.1J26DP9D7R49T@kernel.org>
To: "Kai Huang" <kai.huang@intel.com>, <dave.hansen@intel.com>,
 <tglx@linutronix.de>, <bp@alien8.de>, <mingo@redhat.com>, <hpa@zytor.com>
Cc: <x86@kernel.org>, <linux-sgx@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/sgx: Fix a W=1 build warning in function comment
From: "Jarkko Sakkinen" <jarkko@kernel.org>
X-Mailer: aerc 0.17.0
References: <20240825080649.145250-1-kai.huang@intel.com>
In-Reply-To: <20240825080649.145250-1-kai.huang@intel.com>

On Sun Aug 25, 2024 at 11:06 AM EEST, Kai Huang wrote:
> Building the SGX code with W=3D1 generates below warning:
>
>   arch/x86/kernel/cpu/sgx/main.c:741: warning: Function parameter or stru=
ct member 'low' not described in 'sgx_calc_section_metric'
>   arch/x86/kernel/cpu/sgx/main.c:741: warning: Function parameter or stru=
ct member 'high' not described in 'sgx_calc_section_metric'
>   ...
>
> The function sgx_calc_section_metric() is a simple helper which is only
> used in sgx/main.c.  There's no need to use k-doc style comment for it.
>
> Downgrade to normal comment to silence this warning.
>
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/mai=
n.c
> index 27892e57c4ef..1a000acd933a 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -732,7 +732,7 @@ int arch_memory_failure(unsigned long pfn, int flags)
>  	return 0;
>  }
> =20
> -/**
> +/*
>   * A section metric is concatenated in a way that @low bits 12-31 define=
 the
>   * bits 12-31 of the metric and @high bits 0-19 define the bits 32-51 of=
 the
>   * metric.
>
> base-commit: e77f8f275278886d05ce6dfe9e3bc854e7bf0713

Agreed, that has went there probably by plain mistake. Do not think it
has been intentional...

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko
