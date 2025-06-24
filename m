Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06BB92405E8;
	Tue, 24 Jun 2025 20:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750798154; cv=none; b=ALKrAxq3urEO8SJJqIo+XNZgDu43mIkiUHtS+eCA50ktRH4P4mx26vPvrOkyJk7Mr2eotqdebsQQtNt0HfxSxMjBojWC9MdeSMgkTMZuWfFb9qQM4dkV8r1c8CJNU8hFR//B7i3wQuocKdzetj+xCQnv/UCEWe7HDRwNR4FrRaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750798154; c=relaxed/simple;
	bh=/MeZzCqvNf5iCVyBWZYcYqw1EBXz30cZFHkScqGwm2s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AAHDuYRMDn5D/6FrUy2VVql9aFyJOQU7KFsfydSNUHQhuc+IHuCEhMdlpwOpjMuN9iWFRQNCuYI7Xxgc54mQfzWtxfntENfS2eK53P64LNhkeg/NYuGIahROk01Ldbpz7a+MyawVsAWRfeoMEY04CtbcFKW/Fb3V2yMGa+ZXNyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KYwPpSL1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KYwPpSL1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0454FC4CEE3;
	Tue, 24 Jun 2025 20:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750798153;
	bh=/MeZzCqvNf5iCVyBWZYcYqw1EBXz30cZFHkScqGwm2s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KYwPpSL1ZpC7Bx/J4XZHgteUt1XowcNszkyIjVTyofAamBhk/gOu9KuJpD5yiv32E
	 GeASb6cXu0QDUzpaIHkv1iBC2y1unaErKcy09IfQEclzEZco8xEdBaBXHCdSG139Dd
	 xjkZfHQx8aUjAOa5kJ96VJvVlRCcoWNBF7gMTLElbjrOeWRfmN6CliTEaeTrgPW1ue
	 erAo0I0XlVniFNBsiPeULh7ZcfPJ0vtiwoGo3JFRMLnyT+AJ+/RnYrCoVw/8zqKwUI
	 N0DukNGEy5wvpvljU29+7+qSkp4GJ3PsG/iMIab944SxoPq0PoFF2WcP/9FA+KhZw1
	 MP0vlggaW7FTQ==
Date: Tue, 24 Jun 2025 23:49:09 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Uros Bizjak <ubizjak@gmail.com>
Cc: Dave Hansen <dave.hansen@intel.com>, linux-sgx@vger.kernel.org,
	x86@kernel.org, linux-kernel@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86/sgx: Use ENCLS mnemonic in <kernel/cpu/sgx/encls.h>
Message-ID: <aFsPRSrr79t8FHtr@kernel.org>
References: <20250616085716.158942-1-ubizjak@gmail.com>
 <aFF_UwJ2XlFQSZOi@kernel.org>
 <26b8939e-796a-4581-a41c-42e3582326bd@intel.com>
 <CAFULd4YzC1xe0mVmJhWAk=sxhsctpZUxQGyRKccW-VF7OhkjKg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFULd4YzC1xe0mVmJhWAk=sxhsctpZUxQGyRKccW-VF7OhkjKg@mail.gmail.com>

On Tue, Jun 17, 2025 at 06:20:49PM +0200, Uros Bizjak wrote:
> On Tue, Jun 17, 2025 at 5:01 PM Dave Hansen <dave.hansen@intel.com> wrote:
> >
> > On 6/17/25 07:44, Jarkko Sakkinen wrote:
> > > I don't really see how this is that useful. That said, f a bug fix or
> > > feature used encls mnemonic, I'd had no problems with acking it.
> >
> > It's not _that_ useful.
> >
> > But old assemblers that we still want to use *NEVER* have support for
> > newfanlged instructions, so we always add new instructions with ".byte".
> > Then, a few years down the road when we've moved to just old assemblers
> > instead of super old assemblers, we move to the real instruction names.
> 
> That, and the code becomes self-documenting. You don't have to scratch
> your head what the .byte stream represents when reading assembly.

I hear you but I doubt that here looking into the code in detail and
not being aware of ENCLS opcode would be unlikely :-)

That said, I'm cool with applying the patch to tip.

> 
> Uros.

BR, Jarkko
