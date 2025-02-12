Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 320A6202C23;
	Wed, 12 Feb 2025 21:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739395510; cv=none; b=cZeBG1CVUswRvc8k51OTJjy2vre1mHdF6XlDdYRZfgP/UfxbfhFqV5ZFloco/IdCLePxhm//fWeyMARN+FLBEXKTW83HQHyDT7Zejxz8b/n71GlFrzZEs3/JVUoUrnQYRe7GMa+QjWu9gVyv4KmF8ZG2J/iaVatyTOU2xgqGoUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739395510; c=relaxed/simple;
	bh=Mzi7QQnZdKicD04qd9DyYxXy0btE7+XlZGLov5JbUtg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ifV97LGk4hBmlCrUeNMasxQeqTKKBqHgDDCxEJvd6ShzghZ9e7JllC7MsQQw7R8Euhw43CL9YkKWEUz4ZzHDqb8mb4eV669U260c+GxSZ8l4CDtcgaZoHyAaXTickLQXbPI5H7ZVYU34GoTSBR8w5BzYAXpvxmzF5rNRXLD/kJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VABRKGHm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VABRKGHm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 181BDC4CEDF;
	Wed, 12 Feb 2025 21:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739395509;
	bh=Mzi7QQnZdKicD04qd9DyYxXy0btE7+XlZGLov5JbUtg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VABRKGHmZqwjTPNGbKY4Ng79xbRhgqjB5Y+n1+IySz1OxtZHS1c0DVtbnUI65LKj9
	 1WTL3ipYfHMhRG1rV4X87P9HRlGrRsrDEWtgVu6xiguEu4WZW/iXQDFH+yhP3Q35sr
	 qPqQ+azr4wx9w92+6v/nJQusKrD7hAIxYZpYdDL3ONrB3v6jUzK8004GROlSR01LBP
	 5wbGBDbHya934lnI3577s1p0nL8gWYMZ0WjRmnRe1yKTHluJ9XGArADR1F6Fy3bGhk
	 QpVcx+7ZOWCPlUgLFouZdreUjMywqUhGy7tyCSNB0J5sdCx4PxDgGBJu+qS2F0m3+h
	 TJ1FNCDkRMsCw==
Date: Wed, 12 Feb 2025 23:25:04 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: "Huang, Kai" <kai.huang@intel.com>,
	Andrew Zaborowski <andrew.zaborowski@intel.com>, x86@kernel.org,
	linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
	"H . Peter Anvin" <hpa@zytor.com>, balrogg@gmail.com
Subject: Re: [PATCH] x86: sgx: Don't track poisoned pages for reclaiming
Message-ID: <Z60RsC1h94UdsjRb@kernel.org>
References: <20250211150150.519006-1-andrew.zaborowski@intel.com>
 <3bd497be-54d7-43b8-a392-4bf82bf64679@intel.com>
 <Z6u7PEQKb-L8X4e6@kernel.org>
 <4a1c8b84-d8ee-414a-bd6d-a8633302dab4@intel.com>
 <7ed9b288-69a2-446c-9f7f-50ef6bc56673@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7ed9b288-69a2-446c-9f7f-50ef6bc56673@intel.com>

On Tue, Feb 11, 2025 at 03:31:54PM -0800, Dave Hansen wrote:
> On 2/11/25 13:18, Huang, Kai wrote:
> >>> This requires low-level SGX implementation knowledge to fully
> >>> understand. Both what "ETRACK, EBLOCK and EWB" are in the first place,
> >>> how they are involved in reclaim and also why EREMOVE doesn't lead to
> >>> the same fate.
> >>
> >> Does it? [I'll dig up Intel SDM to check this]
> >>
> > I just did. 🙂
> > 
> > It seems EREMOVE only reads and updates the EPCM entry for the target
> > EPC page but won't actually access that EPC page.
> 
> Actually, now that I think about it even more, why would ETRACK or
> EBLOCK access the page itself? They seem superficially like they'd be
> metadata-only too.

Did a sanity check to SDM.

I think you're correct, and also there's zero rational reason them use
anything but EPCM (no legit reason to access payload itself).

BR, Jarkko
