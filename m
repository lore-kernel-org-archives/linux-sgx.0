Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A5542566F7;
	Tue, 24 Jun 2025 20:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750798024; cv=none; b=ZjyxqhhbY/22Q9lrlU74TBzioujoPQ6/LBbYyLuJNPeAAsFYHVB7g1pccRQlrx+4SfTk9ropc9qExQKPsieb/Ja7kZdK1AWzB3yvm7u0oOgiyaMQ8b6ow/z5/pH9w7bzdEA7dNv5dAxVMTdpaJSB48PTzev3xM2m5BVcxl7SvYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750798024; c=relaxed/simple;
	bh=5aiMymTKRKEzGrxhcmcmNuJMI4pOhF6Hz3pj02mwmPg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UCNIJwglHAQeFr/0PIGDvfj9BAJrpAsSL505VGxh2ulFHE1Ceyn3K1jJO88bWMwznwPj3UoGDhk2v7YYMKzLtrSXymEOMK172TsI+91nk9PjOzAQL6D9AWV/DAnTPMI5VdQWy/XQ1LgejWIMakDHWTsu6miZpBnMFD2rtyQAsdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UmkyQRNl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UmkyQRNl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78420C4CEE3;
	Tue, 24 Jun 2025 20:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750798023;
	bh=5aiMymTKRKEzGrxhcmcmNuJMI4pOhF6Hz3pj02mwmPg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UmkyQRNl0D+CeKuASF21e86Sm1f89M5d9nzHVQI8zk/dKJiYSNxWi2DfY2Zje2Ur9
	 yJ1kzKD/zZzDabQ8NiPFOWxrDAMLbaMP+sh7Aj8yBio3EwV2iwUpTc62agLH/BErfU
	 wQsu7eOalkCXOvc/M1gD35Oc91i8QOa+JGzpdXAjHYHq0lB44v9TBIHtGKWf1UVxW7
	 xHn2Ef4+HlNJ7MwnTF+/traim82ZAR0QAfaawmvHL6vN5MFkklHGxNyVys2hsc9/xF
	 QkmZKrnd+PtuDWVeMWty2Cnqa6D36SZ5IrEWf/6V0u1MjVdB9m9eGqJfvHgM/RHLuI
	 aouhcwEZ+h33A==
Date: Tue, 24 Jun 2025 23:47:00 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Uros Bizjak <ubizjak@gmail.com>, linux-sgx@vger.kernel.org,
	x86@kernel.org, linux-kernel@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86/sgx: Use ENCLS mnemonic in <kernel/cpu/sgx/encls.h>
Message-ID: <aFsOxH_PNAgT-4P2@kernel.org>
References: <20250616085716.158942-1-ubizjak@gmail.com>
 <aFF_UwJ2XlFQSZOi@kernel.org>
 <26b8939e-796a-4581-a41c-42e3582326bd@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <26b8939e-796a-4581-a41c-42e3582326bd@intel.com>

On Tue, Jun 17, 2025 at 08:01:28AM -0700, Dave Hansen wrote:
> On 6/17/25 07:44, Jarkko Sakkinen wrote:
> > I don't really see how this is that useful. That said, f a bug fix or
> > feature used encls mnemonic, I'd had no problems with acking it.
> 
> It's not _that_ useful.
> 
> But old assemblers that we still want to use *NEVER* have support for
> newfanlged instructions, so we always add new instructions with ".byte".
> Then, a few years down the road when we've moved to just old assemblers
> instead of super old assemblers, we move to the real instruction names.
> 
> This is all business as usual.

OK, I'm fine with this reasoning as it is neither by any means distruptive
change either:

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko
