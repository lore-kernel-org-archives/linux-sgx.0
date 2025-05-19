Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB0D1E1A3B;
	Mon, 19 May 2025 12:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747659107; cv=none; b=B24sMa0sIqfR/BWCUSmIeHC6iRS0hWUcuP6I2QYldFeZkNl63p9ATsO97Pjqwqwcw0s9+DEYhzpXJmUYW9jy7juI6Z2lofbzNmD+1klAut3AnN4e1ojsEvTKzD+W+TaObX81+dIdDnoyFU5QXTXrg7jOWTjFhswq6Llxzug9BeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747659107; c=relaxed/simple;
	bh=mzzzruDQgEOQ2CruLB6tT4vqA3MySrj9ZLu9bop9JIo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oZhqYkAZsJUAI70Aezf4LUV3fvMQj9d34c5FWHrKeytYVDBpsFaLMzBF0084hHFKF/UiA9j1CwoZ0aAo8QFv/ASgAvW3j0wssFl07u19pEIPnmlYhZ/roEA8VrEpCYO25f6aaSi02GqHK2s/zcHkpGtiVz9SatFwrPmpRG7Igm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rqiHjRFi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rqiHjRFi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B74FCC4CEE4;
	Mon, 19 May 2025 12:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747659106;
	bh=mzzzruDQgEOQ2CruLB6tT4vqA3MySrj9ZLu9bop9JIo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rqiHjRFiZegscLIQbrVYUUR0xeVODuKlIM6M7yEuAXT5em0X5ulmfkxvUtkjXjvlv
	 +xzoYY3HWKIPGWl86ouxSLSyJzroBzQYiwiVoc/nThbzaNYXIR6Wm05uJuAD/ZARuA
	 RC7XsvY22JJm58lVAaGPUV/m/3FZzV9vAIghwuP4fwITco+GyZCqS4hXh1g2YcvFVk
	 hL1WX/f37XWCtxFpuNNVVY7x/uRbGG0cxPca+X8w3t4aqzfHQbZTzFmzbzyJK92brv
	 v8IIOlXBlEp7HXBdjC1zuPt3sp+eoSW7ta9EdIuwN7VuqQUkIouUpYrVWCc8r4699v
	 2j3XMf1Odks4w==
Date: Mon, 19 May 2025 14:51:39 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: "Hansen, Dave" <dave.hansen@intel.com>,
	"jarkko@kernel.org" <jarkko@kernel.org>,
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
Subject: Re: [PATCH v5 5/5] x86/sgx: Enable automatic SVN updates for SGX
 enclaves
Message-ID: <aCspW0MweLoODLC8@gmail.com>
References: <20250519072603.328429-1-elena.reshetova@intel.com>
 <20250519072603.328429-6-elena.reshetova@intel.com>
 <aCrlFfl2lAzzHOA8@gmail.com>
 <DM8PR11MB57504A6B41329214262E16E2E79CA@DM8PR11MB5750.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM8PR11MB57504A6B41329214262E16E2E79CA@DM8PR11MB5750.namprd11.prod.outlook.com>


* Reshetova, Elena <elena.reshetova@intel.com> wrote:

>  
> > * Elena Reshetova <elena.reshetova@intel.com> wrote:
> > 
> > > @@ -19,10 +19,15 @@ static int sgx_open(struct inode *inode, struct file
> > *file)
> > >  	struct sgx_encl *encl;
> > >  	int ret;
> > >
> > > +	ret = sgx_inc_usage_count();
> > > +	if (ret)
> > > +		return -EBUSY;
> > 
> > So if sgx_inc_usage_count() returns nonzero, it's in use already and we
> > return -EBUSY, right?
> 
> I guess my selection of error code here was wrong. 
> The intended logic is if sgx_inc_usage_count() returns nonzero,
> the *incrementing of counter failed* (due to failed EUPDATESVN)
> and we want to stop and report error.
>   
> > 
> > But:
> > 
> > >  int sgx_inc_usage_count(void)
> > >  {
> > > +	int ret;
> > > +
> > > +	/*
> > > +	 * Increments from non-zero indicate EPC other
> > > +	 * active EPC users and EUPDATESVN is not attempted.
> > > +	 */
> > > +	if (atomic64_inc_not_zero(&sgx_usage_count))
> > > +		return 0;
> > 
> > If sgx_usage_count is 1 here (ie. it's busy), this will return *zero*,
> > and sgx_open() will not run into the -EBUSY condition and will continue
> > assuming it has claimed the usage count, while it hasn't ...
> 
> Yes, meaning is different, see above. 

So that's rather convoluted:

	atomic64_inc_not_zero():   returns 1 on successful increase, 0 on failure
        sgx_inc_usage_count():     returns 0 on successful increase, 1 on failure
        sgx_open():                returns 0 on successful increase, -EBUSY on failure

Could we at least standardize sgx_inc_usage_count() on -EBUSY in the 
failure case, so it's a more obvious pattern:

+       ret = sgx_inc_usage_count();
+       if (ret < 0)
+               return ret;

Thanks,

	Ingo
