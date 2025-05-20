Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0635022DA0D;
	Tue, 20 May 2025 19:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747770920; cv=none; b=UGCNoEciDroXcXjjyzdLJWJW3mvTfN9ha8avj77EB3JrbP3lOpAXhYey9VMJHGN/WYhNyOj4MDMlJk2tp0CcUJJRsX0AH2lg1RQapJGUhZ19ERDnhqgLgvsgvy2OKnePZyD9XCdW7iKThCVIaWP4DlLNGPWEI3g2ND/TybGRN7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747770920; c=relaxed/simple;
	bh=ZNSZ0lf1NtFAeFpBiDde6SrjLyr3Y8FHLGwvbVWFeqk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W7ictcUS3Aqyb4ELviE8GjfjqOcr7ObUggLLoHybwqD/sH/6thI35TpVsKcst/tu6HnXavfa9mehQdAvjeL32a3Lt/+dC/Iwp97o0asUhz6wfLeW5EryApMxFult15RmCCi9CoPQzAwjZ1w+6UuZYm+58M94FKsgkX0tRr/um+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tB8dLcXb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tB8dLcXb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBEC3C4CEE9;
	Tue, 20 May 2025 19:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747770919;
	bh=ZNSZ0lf1NtFAeFpBiDde6SrjLyr3Y8FHLGwvbVWFeqk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tB8dLcXbWS9dWq+3X8kN3s/W7Hd0YRg5oYqf5pLgRW/fppQlc+W/E761DUmj+Zrnz
	 4TPle1CeLTiIHtxbZnfUSBq9G7qWgiSxIaZp+Oiyw8MBULLEAQtoNvwSxoHwvoBqNp
	 14hG/JXiXOfXOdb0lY9v//K8Yx4RcO/lTxi0e8nb/R0N/HBwLU1yKxk49DrW+WUHta
	 TlHuUk+maZUlQH5/Z/NF8hIvp0/UfcXquvIb+ZvoOgzjuEnZ1L6YkHd3oOb892iBVH
	 DV7d0mBZFpt3cymJzSpvZ4Mopdgotebk1VnX4RT8v/7VIuLPx/lQEbVyP8EU95upgc
	 yGrJRn/8s5oXw==
Date: Tue, 20 May 2025 22:55:15 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: "Hansen, Dave" <dave.hansen@intel.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>,
	"linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>,
	"Mallick, Asit K" <asit.k.mallick@intel.com>,
	"Scarlata, Vincent R" <vincent.r.scarlata@intel.com>,
	"Cai, Chong" <chongc@google.com>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"Annapurve, Vishal" <vannapurve@google.com>,
	"dionnaglaze@google.com" <dionnaglaze@google.com>,
	"bondarn@google.com" <bondarn@google.com>,
	"Raynor, Scott" <scott.raynor@intel.com>
Subject: Re: [PATCH v5 1/5] x86/sgx: Introduce a counter to count the
 sgx_(vepc_)open()
Message-ID: <aCzeA8wf--o988-j@kernel.org>
References: <20250519072603.328429-1-elena.reshetova@intel.com>
 <20250519072603.328429-2-elena.reshetova@intel.com>
 <aCtor7AxyLAk3rlB@kernel.org>
 <DM8PR11MB57502D692F699DB8D8FCFCBEE79FA@DM8PR11MB5750.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM8PR11MB57502D692F699DB8D8FCFCBEE79FA@DM8PR11MB5750.namprd11.prod.outlook.com>

On Tue, May 20, 2025 at 06:25:04AM +0000, Reshetova, Elena wrote:
> > Maybe just use raw atomic_inc() and atomic_dec() at the sites?
> > 
> > IMHO, it makes only sense to wrap, when it makes sense to wrap.
> 
> You mean for this patch or overall? For overall we discussed in v4
> why we would like to raise it to atomic64.
> Or do I misunderstand your comment?

So I was thinking whether we want wrappers but I guess we can keep
them.

> 
> Best Regards,
> Elena.

BR, Jarkko
