Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40BF0272908;
	Tue, 11 Feb 2025 23:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739316256; cv=none; b=Lylj3n/DLkHmW8a7IeIDLzAu6+RSUuOUKpLOoKlm1tmDfPGanQuho1uWtdrHlbY7zYGsUOEj1+mtUEaIoFbqBhKg7mRnUBCnsChJ8O0IaGzol2k7B59tv8A20yQM1Jz2963l52XeISjJPbEunZyvLVDqSP8ldbAVTxXiO2bAFdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739316256; c=relaxed/simple;
	bh=yqRVa08HomcNBRp4KY5Wt5KNEotbSND1gTiS2JD1EWY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cm+OM4x0il0GJP+/z2lm/tO+6YU8tC4ivAEOAYhZpjFtWbHdhQy7VWav9a1p4QVgU2yUWPDBYC3UUMcf2H6hb2dcc5KTRvAP6yTGukwvkuw3QDlw8h+sYzl3JA6A4ibYF90NR5+xoJvGM9N2Qpgk2NehngfY4ea/ddPMVomnxlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q0F+yiYP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q0F+yiYP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BB08C4CEDD;
	Tue, 11 Feb 2025 23:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739316253;
	bh=yqRVa08HomcNBRp4KY5Wt5KNEotbSND1gTiS2JD1EWY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q0F+yiYPge33n3g6HOTDXyK3jVFQ13i+HeAsrvH/GcGa0zPhMi58HrRlmcMLC975O
	 3/BAKr03TTu3FuRysrI5A53idp1uC+ky7eSIdzD5oXOeONhpZ9aAAb6RBFI9JV2PEn
	 FIfO1vJ/iecXcsP7sslPuveIFNQr1DB23/1B1tchvagC+1ThUyOsRsvnx6dDhqJbsw
	 imSblwULsBbAtqjEbFuzqoRKeK+IR1scjuEIYBzESd/Lgu84oAByNNloERoxj7babs
	 f5ZBtYhwhQ0Q13IvZ7a6a73vBwv9S1+DLy1oMTLd3S7TzcKT/nbRfM6vdVu0lQYeI3
	 5t25G1qP6v/kQ==
Date: Wed, 12 Feb 2025 01:24:09 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>,
	Andrew Zaborowski <andrew.zaborowski@intel.com>, x86@kernel.org,
	linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
	"H . Peter Anvin" <hpa@zytor.com>, balrogg@gmail.com
Subject: Re: [PATCH] x86: sgx: Don't track poisoned pages for reclaiming
Message-ID: <Z6vcGbMh1tt8HIAt@kernel.org>
References: <20250211150150.519006-1-andrew.zaborowski@intel.com>
 <3bd497be-54d7-43b8-a392-4bf82bf64679@intel.com>
 <Z6u7PEQKb-L8X4e6@kernel.org>
 <4a1c8b84-d8ee-414a-bd6d-a8633302dab4@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4a1c8b84-d8ee-414a-bd6d-a8633302dab4@intel.com>

On Wed, Feb 12, 2025 at 10:18:11AM +1300, Huang, Kai wrote:
> 
> 
> On 12/02/2025 10:03 am, Jarkko Sakkinen wrote:
> > On Tue, Feb 11, 2025 at 08:25:58AM -0800, Dave Hansen wrote:
> > > > arch_memory_failure() but stay on sgx_active_page_list.
> > > > page->poison is not checked in the reclaimer logic meaning that a page could be
> > > > reclaimed and go through ETRACK, EBLOCK and EWB.  This can lead to the
> > > > firmware receiving and MCE in one of those operations and going into
> > > > "unbreakable shutdown" and triggering a kernel panic on remaining cores.
> > > 
> > > This requires low-level SGX implementation knowledge to fully
> > > understand. Both what "ETRACK, EBLOCK and EWB" are in the first place,
> > > how they are involved in reclaim and also why EREMOVE doesn't lead to
> > > the same fate.
> > 
> > Does it? [I'll dig up Intel SDM to check this]
> > 
> 
> I just did. :-)
> 
> It seems EREMOVE only reads and updates the EPCM entry for the target EPC
> page but won't actually access that EPC page.

That was fast, thank you!

This is pretty much also that should be explicitly stated in the commit
message.

BR, Jarkko
