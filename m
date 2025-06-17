Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA7B2E54A3;
	Tue, 17 Jun 2025 14:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750171479; cv=none; b=k5Joo7eq9k0h3A/3GOClDeuRAdXt9N6RGi+A/GxJgdGvVMEOnKrf19aW/doKs+A1iK05Kg14JpKFUMdaBW7kdUfBfongu9Zw5p5yl+ljcb02DvkjJgsfba+bgobzT7S9z+MDVnWj9cTWiZ+c2P9BtK1EOhvsLsdkPngXeklD1aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750171479; c=relaxed/simple;
	bh=r+1sIvSIxYaTR9LID7Lz+1ggjxbL3RpmshgYY0QT/Yg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YtHGo7uIGvskAK06D7MRmk7OUsjQE+nbQ4AcQAsNMR32pFzpUues+forNB6e+JjB/cFwU6yB5nBunn1D/FydKQ/D8WPJea1VnZlhA0ykRZgNgSBQY2FhKnBdzAeS3jls5CCZivV6KwvuJnJpkxliCSRDmZlk118H0m4WcqLGsRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A/Oo6HDv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A/Oo6HDv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F6C0C4CEE3;
	Tue, 17 Jun 2025 14:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750171478;
	bh=r+1sIvSIxYaTR9LID7Lz+1ggjxbL3RpmshgYY0QT/Yg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=A/Oo6HDvYzO27Nuyc8XzyehNuqOvA/l80Yn5mh/xvg5wFQH6bgZVWXg3nDbKI5cIE
	 gpjYE5m37eOqNb1gjt9ho/Xs+ouXdDbZhoZAMaz898sKyORFKPRAyq3j21UmfTOX28
	 YHnmS+n9E0XvI68fZ2KipIpQJ6SDRqUZYfyi72+rpqsM7ORs/k2YdkxyjyUwLoaNyk
	 QgNNbc3nwhmYfu1ishW5ZsbeoEp9aKiS7XreLlcVE1wvSZi0X2v4TqsjwslkcBkrUv
	 SZAjlq/uwGh68kphB9DPqNg1YAS4F9b/UOhjHF8pitf+yCoGzzvaY2yDaI6ZXjrSoh
	 xOX24kjZMdKpw==
Date: Tue, 17 Jun 2025 17:44:35 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Uros Bizjak <ubizjak@gmail.com>
Cc: linux-sgx@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86/sgx: Use ENCLS mnemonic in <kernel/cpu/sgx/encls.h>
Message-ID: <aFF_UwJ2XlFQSZOi@kernel.org>
References: <20250616085716.158942-1-ubizjak@gmail.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250616085716.158942-1-ubizjak@gmail.com>

On Mon, Jun 16, 2025 at 10:56:30AM +0200, Uros Bizjak wrote:
> Current minimum required version of binutils is 2.30,
> which supports ENCLS instruction mnemonic.
> 
> Replace the byte-wise specification of ENCLS with
> this proper mnemonic.
> 
> No functional change intended.
> 
> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> Cc: Jarkko Sakkinen <jarkko@kernel.org>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> ---
>  arch/x86/kernel/cpu/sgx/encls.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/encls.h b/arch/x86/kernel/cpu/sgx/encls.h
> index 99004b02e2ed..42a088a337c5 100644
> --- a/arch/x86/kernel/cpu/sgx/encls.h
> +++ b/arch/x86/kernel/cpu/sgx/encls.h
> @@ -68,7 +68,7 @@ static inline bool encls_failed(int ret)
>  	({							\
>  	int ret;						\
>  	asm volatile(						\
> -	"1: .byte 0x0f, 0x01, 0xcf;\n\t"			\
> +	"1: encls\n"						\
>  	"2:\n"							\
>  	_ASM_EXTABLE_TYPE(1b, 2b, EX_TYPE_FAULT_SGX)		\
>  	: "=a"(ret)						\
> @@ -111,8 +111,8 @@ static inline bool encls_failed(int ret)
>  	({							\
>  	int ret;						\
>  	asm volatile(						\
> -	"1: .byte 0x0f, 0x01, 0xcf;\n\t"			\
> -	"   xor %%eax,%%eax;\n"					\
> +	"1: encls\n\t"						\
> +	"xor %%eax,%%eax\n"					\
>  	"2:\n"							\
>  	_ASM_EXTABLE_TYPE(1b, 2b, EX_TYPE_FAULT_SGX)		\
>  	: "=a"(ret), "=b"(rbx_out)				\
> -- 
> 2.49.0
> 

I don't really see how this is that useful. That said, f a bug fix or
feature used encls mnemonic, I'd had no problems with acking it.

BR, Jarkko
