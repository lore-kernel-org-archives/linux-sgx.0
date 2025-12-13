Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50FB71494A8;
	Sat, 13 Dec 2025 19:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765653282; cv=none; b=qLMiX3mCU/faU56Jd/tfX/nTN5pxl3+ca6AObQFy3wOF7EMz6d0xYCIyVHrIMkuT+/g2vCd9j0m2In5BER+WlaHnG4iK0Bz0/DjQy006FGXcFAYl8yQhSrlJwuFJq2vmJHvQrHDHBf+/zStjzyFN/eODPcLWiGP31jlbg0Jw1BU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765653282; c=relaxed/simple;
	bh=vwDo5QIjMb/ONKR2adSwxVGAyNZY9wvYXptTXLCJ3u8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jWktpzJtTAHINeLpToREMWsW2ubiNkPz2K1j0qImmmSSV3hunJ2EL9qA3TUA86ef8pnOOv+i6Nh9BLtAdZnC4MM/+mtXhN6qWTYnzHYqXt6lfWfyrUq5F+QySj1KWqiUJGLBwtuqk/imdgmQOnvxsbQJeiGwjLUVq+fvaH8l88Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f96dfLA3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f96dfLA3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BA1FC4CEF7;
	Sat, 13 Dec 2025 19:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765653281;
	bh=vwDo5QIjMb/ONKR2adSwxVGAyNZY9wvYXptTXLCJ3u8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f96dfLA3djI4M9lPVEkwjvHAxXlTsF09+KCltf53AlzixMv0nZZNujMYMW/mHMmuz
	 mi1VqgTKyOz4BbJ55pKEGuYnl1FuSBo7Cfrpp1VJw8RT6cPfCJKaeDATQ54DPkb0k0
	 XKnACU/UOay8RW9RtEWuzSW01wULKBCsnYqLPcO1372qwYEYShHz+t238U2kzXvglI
	 vUg+ifIot9mJbsqyBZqXbwJzkXpoAZVjONJ/gzq3kzWeD4mrHy6RYJByg6Bc/UVF8r
	 oNrUIkmEZrvUu0ZmoeydMkj5Rtow/10YB5VLWYwMrAUO2rF6raVUNeuFOUknM6tgON
	 OmK6vPegC+JIg==
Date: Sat, 13 Dec 2025 21:14:37 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
	linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/sgx: Use goto to remove redundant if check in
 sgx_encl_init
Message-ID: <aT27Hc9gTo4wKcW1@kernel.org>
References: <20251210130035.545132-1-thorsten.blum@linux.dev>
 <aTmSq5Px4P6vEUCb@kernel.org>
 <9651D503-F2D9-4FE0-9593-8D204360C258@linux.dev>
 <aTsjqDtWoIO_p60j@kernel.org>
 <aTsmYkI3ThbsfpIH@kernel.org>
 <4A07D996-F409-4796-B02C-E8D39335B599@linux.dev>
 <aT26Vva7f9ZdVEn8@kernel.org>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aT26Vva7f9ZdVEn8@kernel.org>

On Sat, Dec 13, 2025 at 09:11:23PM +0200, Jarkko Sakkinen wrote:
> On Fri, Dec 12, 2025 at 10:05:00PM +0100, Thorsten Blum wrote:
> > On 11. Dec 2025, at 21:15, Jarkko Sakkinen wrote:
> > > On Thu, Dec 11, 2025 at 10:03:56PM +0200, Jarkko Sakkinen wrote:
> > >> On Wed, Dec 10, 2025 at 04:48:08PM +0100, Thorsten Blum wrote:
> > >>> On 10. Dec 2025, at 16:32, Jarkko Sakkinen wrote:
> > >>>> On Wed, Dec 10, 2025 at 02:00:35PM +0100, Thorsten Blum wrote:
> > >>>>> Immediately break out of both loops when 'ret != SGX_UNMASKED_EVENT'
> > >>>>> instead of checking for the same condition again in the outer loop.
> > >>>>> 
> > >>>>> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> > >>>>> ---
> > >>>>> [...]
> > >>>> 
> > >>>> I don't think moving code around is very useful.
> > >>> 
> > >>> The patch doesn't actually move any code around, but it removes up to 50
> > >>> (SGX_EINIT_SLEEP_COUNT) duplicate and therefore unnecessary if checks in
> > >>> the outer for loop.
> > >> 
> > >> Temporary change for generating disassembly:
> > >> [...]
> > > 
> > > It pretty much does what I said i.e., shuffles a new location for a code block.
> > 
> > GCC emits a much larger diff; however, discussing the patch based solely
> > on the disassembled code probably isn't very meaningful.
> 
> It does close the "does nothing useful" claim. It really does nothing 
> useful.

So it's a debate whether saving a single check with more convoluted 
branching is a better or worse idea. I don't know. Thus, I cannot 
accept this patch.


BR, Jarkko
