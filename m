Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E363F13DBA0;
	Thu, 27 Mar 2025 21:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743110509; cv=none; b=TAosOzhlehWOoIIW6m38Hz8OMlAQHBBRbQaf1vr3fKGWjliyukPRQgSg3sGfS1era8ppWe2+b/H2NPaxQ9GtsdDZO9r14Eba42Q8h1NqsP2q61y6trNY48AU12MkO2wm5BTimECEc2GMP26900YWJ8/ccP4Uou+f29ll+ns86CE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743110509; c=relaxed/simple;
	bh=3ec24B7nKFDLR7A3SrqfnMmlotczUJnajMJt7qycTOw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=plvQ6YOAqgiRw7ow2NSxKcgWhiMj8f08ULbeGkywL3t0RMZ2phS2vd2GixhDvzubGk8vH5vlXlgh+2SG66qUe5xqIlw/6rgGH0uOeQPuCN2JJVXYAUijV/FfelMIV3ittLe6rWvrqfB173gHv7YZwGmVJn/J+1lR14FrxORGpOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n7RTbVCK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n7RTbVCK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D13D3C4CEDD;
	Thu, 27 Mar 2025 21:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743110508;
	bh=3ec24B7nKFDLR7A3SrqfnMmlotczUJnajMJt7qycTOw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=n7RTbVCKgx6WOWBPpn4FBWSLsbXaxa8cGsHXLKTwm4IvdfJlcFbIPlf+dJgv1jN0u
	 +N9zO4vTln0wyWk8CWdHYjCBtn68XgctIs7pb0sa8Zs1r0G3ci6t4YbnxAJ+cL0GXR
	 EYUjmGtxMDBdzhPX5wh8wqtGDyYIEYnfrrQGpQ3S0ey+KMPAcB5YRRECnSupZNjTrS
	 KmO411J7IMKRV385m6YqX8Sce6jJCjTzhUK3Zfc+zor6rLlNk4WrTc6TFumo80a5iH
	 CzdMqVTbJU1lZEOhXJlLBqPSNs0NN/jPDb7QvLeIiyEt9BntXzqBb09LvH0CS4A1Ku
	 JQ3QsVERKID9w==
Date: Thu, 27 Mar 2025 23:21:44 +0200
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
	"Raynor, Scott" <scott.raynor@intel.com>
Subject: Re: [PATCH 2/4] x86/sgx: Change counter sgx_nr_free_pages ->
 sgx_nr_used_pages
Message-ID: <Z-XBaJ3egJDetauP@kernel.org>
References: <20250321123938.802763-1-elena.reshetova@intel.com>
 <20250321123938.802763-3-elena.reshetova@intel.com>
 <Z981ciAqpknQ3hRF@kernel.org>
 <DM8PR11MB5750B9CBBB7A51CE3A0F006AE7A42@DM8PR11MB5750.namprd11.prod.outlook.com>
 <Z-RecEZhXshD6yma@kernel.org>
 <DM8PR11MB575001F32AD2F55043EAA670E7A12@DM8PR11MB5750.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DM8PR11MB575001F32AD2F55043EAA670E7A12@DM8PR11MB5750.namprd11.prod.outlook.com>

On Thu, Mar 27, 2025 at 03:31:31PM +0000, Reshetova, Elena wrote:
> > On Mon, Mar 24, 2025 at 12:19:37PM +0000, Reshetova, Elena wrote:
> > >
> > > > On Fri, Mar 21, 2025 at 02:34:41PM +0200, Elena Reshetova wrote:
> > > > > sgx_nr_free_pages is an atomic that is used to keep track of
> > > > > free EPC pages and detect whenever page reclaiming should start.
> > > > > Since successful execution of ENCLS[EUPDATESVN] requires empty
> > > > > EPC and a fast way of checking for this, change this variable
> > > > > around to indicate number of used pages instead. The subsequent
> > > > > patch that introduces ENCLS[EUPDATESVN] will take use of this change.
> > > >
> > > > s/subsequent patch//
> > >
> > > Ok
> > >
> > > >
> > > > You should rather express how EUPDATESVN trigger will depend on the
> > > > state of sgx_nr_used_pages and sgx_nr_free_pages.
> > >
> > > How about this explanation:
> > >
> > > "By counting the # of used pages instead of #of free pages, it allows the
> > > EPC page allocation path execute without a need to take the lock in all
> > > but a single case when the first page is being allocated in EPC. This is
> > > achieved via a fast check in atomic_long_inc_not_zero."
> > 
> > Yep, whole a lot more sense.
> > 
> > >
> > > Also, if you think that it is hard to interpret the patch 2/4 without 4/4
> > > I can also squeeze them together and then it becomes right away clear
> > > why the change was done.
> > >
> > >
> > > >
> > > > >
> > > > > No functional changes intended.
> > > >
> > > > Not really understanding how I should interpret this sentence.
> > >
> > > Just as usual: this patch itself doesn’t bring any functional changes
> > > to the way as current SGX code works. I only needed this change to
> > > implement patch 4/4 in more lockless way.
> > >
> > > >
> > > > The commit message does not mention sgx_nr_used_pages, and neiher it
> > > > makes a case why implementing the feature based on sgx_nr_free_pages
> > is
> > > > not possible.
> > >
> > > It is possible to implement it, in fact I did exactly this in the beginning
> > instead,
> > > but as mentioned previously this would have resulted in taking a lock for
> > each
> > > case the page is being allocated.
> > 
> > Have you benchmarked this (memory barrier vs putting the whole thing
> > inside spinlock)?
> > 
> > I have doubts that this would even show in margins given how much e.g.,
> > ELDU takes.
> 
> No, I haven’t benchmarked this. The reason to choose this approach
> (vs. the other one I showed in email now) was purely logical - less
> locks and better code.

You need to have hard data to to turn things around like this.
Otherwise, let's not do this.

EPC allocation is always combined with heave-weight opcode so
this really does not serve any purpose.

> 
> Best Regards,
> Elena.

BR, Jarkko
