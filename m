Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19214248880;
	Sat, 13 Dec 2025 19:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765653083; cv=none; b=t70+9bmgYPHN257A0lE8X5NdWW7ZoZIDuUV0tzJ9Nsopb95dqhqXgP2DDu8v06i29lWP7VnobIAcXnVYqFauVP8pm1Koe7Ogb0N0MjlbRoBSlOyNC7n1mnPj3Wrk7Wdl9ZsBqbSqLqyZaaAucXabmGFBMAzlQEvgBY0/Zn8+L30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765653083; c=relaxed/simple;
	bh=qrHhay9liGzDmEwQ5n5J0H60m9dfrCS892O9sMzOF9Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bWv0Jufc/tT2SlpG8a34MII+KNx+M3c1aBT813DEkMYc3WJbWRzzB+6uAupew7/Yz++SK2WmozKzL9/poJ1Va79zoAK2Gv4ZIZmi9vqEqQT1dSlzEL1CG5K1OtEMPxMvAqAtnTVD/qU2sGRym/KsTLVm61mRfbPB3zw4oC5r0II=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=df0dSnap; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="df0dSnap"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E314C4CEF7;
	Sat, 13 Dec 2025 19:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765653082;
	bh=qrHhay9liGzDmEwQ5n5J0H60m9dfrCS892O9sMzOF9Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=df0dSnapQaLrzjMvsGvS9BrXeSV3rl9IjlGEkI1+hhcj9CO7o6wV+vIxlV5wUi3ZS
	 GcUq2aWoWLy0n6a39QPP9OY78FheLzGPDQDpR4OFG3rxW8OTIT8WiJEU93WowlXUyB
	 0aX1NaiZOuZPuBqdm4empJdABo9iMmXWcyp5H+m6I65rGRDvXUyz+i0VU4FprupghI
	 ksrhK7J0pMR/l5D+pHFCiZPA3y7mqFrVkQYmIaj1UDSwSFHn7e5/YmuSKHKi3gXRA0
	 tANhf4aFOkkrpYenVKWzkYeowD4Z7yfZllYRiVode7sVgCzBno5YKgRBdE3p6eTkA8
	 zmpP+5d8xCmVA==
Date: Sat, 13 Dec 2025 21:11:18 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
	linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/sgx: Use goto to remove redundant if check in
 sgx_encl_init
Message-ID: <aT26Vva7f9ZdVEn8@kernel.org>
References: <20251210130035.545132-1-thorsten.blum@linux.dev>
 <aTmSq5Px4P6vEUCb@kernel.org>
 <9651D503-F2D9-4FE0-9593-8D204360C258@linux.dev>
 <aTsjqDtWoIO_p60j@kernel.org>
 <aTsmYkI3ThbsfpIH@kernel.org>
 <4A07D996-F409-4796-B02C-E8D39335B599@linux.dev>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A07D996-F409-4796-B02C-E8D39335B599@linux.dev>

On Fri, Dec 12, 2025 at 10:05:00PM +0100, Thorsten Blum wrote:
> On 11. Dec 2025, at 21:15, Jarkko Sakkinen wrote:
> > On Thu, Dec 11, 2025 at 10:03:56PM +0200, Jarkko Sakkinen wrote:
> >> On Wed, Dec 10, 2025 at 04:48:08PM +0100, Thorsten Blum wrote:
> >>> On 10. Dec 2025, at 16:32, Jarkko Sakkinen wrote:
> >>>> On Wed, Dec 10, 2025 at 02:00:35PM +0100, Thorsten Blum wrote:
> >>>>> Immediately break out of both loops when 'ret != SGX_UNMASKED_EVENT'
> >>>>> instead of checking for the same condition again in the outer loop.
> >>>>> 
> >>>>> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> >>>>> ---
> >>>>> [...]
> >>>> 
> >>>> I don't think moving code around is very useful.
> >>> 
> >>> The patch doesn't actually move any code around, but it removes up to 50
> >>> (SGX_EINIT_SLEEP_COUNT) duplicate and therefore unnecessary if checks in
> >>> the outer for loop.
> >> 
> >> Temporary change for generating disassembly:
> >> [...]
> > 
> > It pretty much does what I said i.e., shuffles a new location for a code block.
> 
> GCC emits a much larger diff; however, discussing the patch based solely
> on the disassembled code probably isn't very meaningful.

It does close the "does nothing useful" claim. It really does nothing 
useful.


> 
> Thanks,
> Thorsten
> 
> 

BR, Jarkko
