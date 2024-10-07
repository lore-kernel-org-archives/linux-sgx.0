Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13C6F17D896;
	Mon,  7 Oct 2024 23:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728343791; cv=none; b=hz7eW976iuIo8lszQiYV/bTEEYCKq7Z2lafCB/lhw6d9bqYHYMH9q5xDkc+4ddeRtcvyXRAXuGoyP5UKluK8YH2/a9JqNJZ1p5LIWNc/w4yr+zbtCcJa6AoErh726I63HM6+QpAUwQBSHs6/EuzhpZaeN3necEA+IH7mBI+YOY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728343791; c=relaxed/simple;
	bh=7mzxuOL+b4BUFxOHCCRk0/eEc+Jp/OAnV1nSCguoXRQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TCcNJUsNihDhOZL+L4DAV67x05IfFj1D+FaFoTkwPAHJFxURAAT7koaeF9CdlnRo9EIMPLNrzyoLPQNKWFH4K8Q0rzokGczJ1eOw+ppREnqAV0zD6NQFfi5Xz8aQvcYS279t7g1LGiPbTNk6yV5oGsGJFLj4xBfgYAHAgpxM3Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gb5ehjPe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gb5ehjPe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72069C4CEC6;
	Mon,  7 Oct 2024 23:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728343790;
	bh=7mzxuOL+b4BUFxOHCCRk0/eEc+Jp/OAnV1nSCguoXRQ=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=Gb5ehjPeLUSifVSXmwN0REMsm1ANSNBNsbD11M9RlUPR5lj4jTzB7wCIFFvVu3DOz
	 uYp2MQSHcWahhW7iWBy/tO8JkuCaPr/3n0TAnrIem3wIRLib2FoZTRfiMtpZfDPJOT
	 dU3dsV2xqbtp/w3YZAC4NaNqoese/JfNfLDCf6Dl9W9CgIsq/BuFATAySRTfgQmeKY
	 6fnnYxwFBvsB4/tRTTcWZjzBaNY8xaKozfOY5XkDYTAltkjFOOqOJNW71QZSgWG/Hw
	 mHWy5qPWsFHF6T9MfCoo1q+Qyzdrh2HfK+y2d+njINYEeA1MEHnaAZIq72U/eCWCRi
	 02n8HC0M2f5wg==
Message-ID: <1157733c66ceabb848ce79c2ae6bd226c1a00dcd.camel@kernel.org>
Subject: Re: [PATCH] x86/sgx: Use vmalloc_array() instead of vmalloc()
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Thorsten Blum <thorsten.blum@linux.dev>, Dave Hansen
 <dave.hansen@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo
 Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 08 Oct 2024 02:29:46 +0300
In-Reply-To: <20240929105644.38797-1-thorsten.blum@linux.dev>
References: <20240929105644.38797-1-thorsten.blum@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 (3.52.4-1.fc40) 
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Sun, 2024-09-29 at 12:56 +0200, Thorsten Blum wrote:
> Use vmalloc_array() instead of vmalloc() to calculate the number of
> bytes to allocate.
>=20
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
> =C2=A0arch/x86/kernel/cpu/sgx/main.c | 2 +-
> =C2=A01 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/arch/x86/kernel/cpu/sgx/main.c
> b/arch/x86/kernel/cpu/sgx/main.c
> index 9ace84486499..1a59e5956f4b 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -630,7 +630,7 @@ static bool __init sgx_setup_epc_section(u64
> phys_addr, u64 size,
> =C2=A0	if (!section->virt_addr)
> =C2=A0		return false;
> =C2=A0
> -	section->pages =3D vmalloc(nr_pages * sizeof(struct
> sgx_epc_page));
> +	section->pages =3D vmalloc_array(nr_pages, sizeof(struct
> sgx_epc_page));
> =C2=A0	if (!section->pages) {
> =C2=A0		memunmap(section->virt_addr);
> =C2=A0		return false;

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko
