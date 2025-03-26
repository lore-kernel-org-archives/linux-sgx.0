Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E6812566D0;
	Wed, 26 Mar 2025 19:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743018232; cv=none; b=jgXJa8rW+Ute9JK8H/jVWsM4UQIEoG+d/UQoZotZuN2/DYlbP6uy96JIcxkP9ovpBoZXlZiF7kLqeaSOFF1OHlJ8Ga4w+hq2HNDgBO9G5iTutO1IvHiY3lDbWStxOnFuokP3fVmTloM/9p8lAjHsDv/P4Wg16elc7M8vxssEWtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743018232; c=relaxed/simple;
	bh=LilCrq6gFnjk7WcOa6HyB4QAzegZU8PDndDSyDEdMkM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EP3oQT0GXmf9m3g796/R/OagzCCKWLeH6e413oR7pT4DVP6NJdm7fl5fG9dC7CzH2T1ZrbeH0AHTCjYxN7ArMlXIsuAFsF921nXeLf2cOh5mfEqsMLtSuPAP4asw0n8vJnzQXOJuC+mYW3/4kn7SWpcnxuIUJnYii1DatPRpe+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hJABBfyp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hJABBfyp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E59BC4CEE2;
	Wed, 26 Mar 2025 19:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743018231;
	bh=LilCrq6gFnjk7WcOa6HyB4QAzegZU8PDndDSyDEdMkM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hJABBfypFBAMyG2hDWr0QuqqiSXOCwiLkYieEvYnTtGP9iemVgb0BFv4h+Nll1Dfq
	 C+m4gHe5zrRmML/RuUIBaryctXxD0VceBVPiKEAyKY/Ko+Ho9efasJxhxM/QCjthYg
	 tyQjTMOEqjmdAbauw9PBBxpvYG+kuR/ZeoJttgc8EjPeLjlTuPEXBUtpRLZgZvjh2c
	 ujWRK6X+UGpHUVhmoCQUqRHo9a8HSpzroNmHn19pXH679f72i2gIvlNSi3ew5PC8pJ
	 fYl4IFKVxSiEBo8Kf8cnbFxkQfYg2EIYwxe0S1IY3e8JiMvWMlJBUUQR1GOeY56bkq
	 lg3lKFgEwQnZQ==
Date: Wed, 26 Mar 2025 21:43:47 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: "Hansen, Dave" <dave.hansen@intel.com>,
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
	"Raynor, Scott" <scott.raynor@intel.com>,
	"Shutemov, Kirill" <kirill.shutemov@intel.com>
Subject: Re: [PATCH 1/4] x86/sgx: Add total number of EPC pages
Message-ID: <Z-RY8-bL2snpRKTB@kernel.org>
References: <20250321123938.802763-1-elena.reshetova@intel.com>
 <20250321123938.802763-2-elena.reshetova@intel.com>
 <Z98yki-gH4ewlpbP@kernel.org>
 <DM8PR11MB57508A3681C614C9B185B04EE7A42@DM8PR11MB5750.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM8PR11MB57508A3681C614C9B185B04EE7A42@DM8PR11MB5750.namprd11.prod.outlook.com>

On Mon, Mar 24, 2025 at 12:12:41PM +0000, Reshetova, Elena wrote:
> > On Fri, Mar 21, 2025 at 02:34:40PM +0200, Elena Reshetova wrote:
> > > In order to successfully execute ENCLS[EUPDATESVN], EPC must be empty.
> > > SGX already has a variable sgx_nr_free_pages that tracks free
> > > EPC pages. Add a new variable, sgx_nr_total_pages, that will keep
> > > track of total number of EPC pages. It will be used in subsequent
> > > patch to change the sgx_nr_free_pages into sgx_nr_used_pages and
> > > allow an easy check for an empty EPC.
> > 
> > First off, remove "in subsequent patch".
> 
> Ok
> 
> > 
> > What does "change sgx_nr_free_pages into sgx_nr_used_pages" mean?
> 
> As you can see from patch 2/4, I had to turn around the meaning of the
> existing sgx_nr_free_pages atomic counter not to count the # of free pages
> in EPC, but to count the # of used EPC pages (hence the change of name
> to sgx_nr_used_pages). The reason for doing this is only apparent in patch

Why you *absolutely* need to invert the meaning and cannot make
this work by any means otherwise?

I doubt highly doubt this could not be done other way around.

BR, Jarkko 
