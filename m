Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F9EA189F20;
	Thu, 27 Mar 2025 21:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743110359; cv=none; b=s7Snygb4RcImLc+NOdNe3598/PmJ+eD5eWzzlY3Lqjrfht1znHlYhWAKg2gJAkqI0dC69n8JBByLo/C9CrthzFMevKYaid2BTAAT/o9urNvdMgcDGzAj2xcp2J1Yzaw3KKiftH5ZyhPuHnAsh51iuIl9Yp04Oifio9Ru+UPJ+f8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743110359; c=relaxed/simple;
	bh=2mP76JkvssJxcOdXIJ22ei/P0IoIyBjMEWJKZRk/IOc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SvNo1aCEfwszzZTVHYMNskdO7DgTlp9Qo5an4jAwf98VGYnjfNLuZbpT0N1QxumURGEdI/M23V7G/+c+3ViMJ/GC43dlDqMLXML28L3Vu5IzEJbbWi0dq74vt8ryq9rrLYRdal3JE3/8k11CGGNfwpK5mGUtmlQsZZManquhVcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gXfENONr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gXfENONr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8824EC4CEDD;
	Thu, 27 Mar 2025 21:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743110359;
	bh=2mP76JkvssJxcOdXIJ22ei/P0IoIyBjMEWJKZRk/IOc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gXfENONrRJObPzbG/pC9yMNgImfh+f98KdlzPFp/H+y2qQ17k2DoUf+/t9HXCme+7
	 HyWKmZixoA/utwqIVD7YUJO14HxoeS8uQfgs2QdHzuts+j5lsBkdIlEHdMhIyIzcIb
	 9kd95wjnih3NsubEQjI63YhWPSuScfK0JjxRuclLAkq6+FPJ6LMWXgb+/i84nNDBH1
	 czxMuWKj5CC52HANzfMbpTzwiPJggMDUXXS3X15L7Ja2Aj5UGg3L32yATnWGZESZlf
	 XJAmlnPOh78kQv3xEOzSYV0iRnBykagvyF30rR1uH4/0J99Lc04G/jk5LCbA8tybbZ
	 fPlFLgzox0GXw==
Date: Thu, 27 Mar 2025 23:19:14 +0200
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
	"Zhang, Cathy" <cathy.zhang@intel.com>
Subject: Re: [PATCH 4/4] x86/sgx: Implement ENCLS[EUPDATESVN] and
 opportunistically call it during first EPC page alloc
Message-ID: <Z-XA0oy_r9VBJPHI@kernel.org>
References: <20250321123938.802763-1-elena.reshetova@intel.com>
 <20250321123938.802763-5-elena.reshetova@intel.com>
 <Z983ZaTaWNqFUpYS@kernel.org>
 <DM8PR11MB575000AEB9CC3A318651AAABE7A42@DM8PR11MB5750.namprd11.prod.outlook.com>
 <Z-RfcpSBAybk-KjG@kernel.org>
 <DM8PR11MB5750FE25D4C8EC2297952845E7A12@DM8PR11MB5750.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM8PR11MB5750FE25D4C8EC2297952845E7A12@DM8PR11MB5750.namprd11.prod.outlook.com>

On Thu, Mar 27, 2025 at 03:42:30PM +0000, Reshetova, Elena wrote:
> > > > > +	case SGX_NO_UPDATE:
> > > > > +		pr_debug("EUPDATESVN was successful, but CPUSVN was not
> > > > updated, "
> > > > > +			"because current SVN was not newer than
> > > > CPUSVN.\n");
> > > > > +		break;
> > > > > +	case SGX_EPC_NOT_READY:
> > > > > +		pr_debug("EPC is not ready for SVN update.");
> > > > > +		break;
> > > > > +	case SGX_INSUFFICIENT_ENTROPY:
> > > > > +		pr_debug("CPUSVN update is failed due to Insufficient
> > > > entropy in RNG, "
> > > > > +			"please try it later.\n");
> > > > > +		break;
> > > > > +	case SGX_EPC_PAGE_CONFLICT:
> > > > > +		pr_debug("CPUSVN update is failed due to concurrency
> > > > violation, please "
> > > > > +			"stop running any other ENCLS leaf and try it
> > > > later.\n");
> > > > > +		break;
> > > > > +	default:
> > > > > +		break;
> > > >
> > > > Remove pr_debug() statements.
> > >
> > > This I am not sure it is good idea. I think it would be useful for system
> > > admins to have a way to see that update either happened or not.
> > > It is true that you can find this out by requesting a new SGX attestation
> > > quote (and see if newer SVN is used), but it is not the faster way.
> > 
> > Maybe pr_debug() is them wrong level if they are meant for sysadmins?
> > 
> > I mean these should not happen in normal behavior like ever? As
> > pr_debug() I don't really grab this.
> 
> SGX_NO_UPDATE will absolutely happen normally all the time. 
> Since EUPDATESVN is executed every time EPC is empty, this is the
> most common code you will get back (because microcode updates are rare). 
> Others yes, that would indicate some error condition. 
> So, what is the pr_level that you would suggest? 

Right, got it. That changes my conclusions:

So I'd reformulate it like:

	switch (ret) {
	case 0:
		pr_info("EUPDATESVN: success\n);	
		break;
	case SGX_EPC_NOT_READY:
	case SGX_INSUFFICIENT_ENTROPY:
	case SGX_EPC_PAGE_CONFLICT:
		pr_err("EUPDATESVN: error %d\n", ret);
		/* TODO: block/teardown driver? */
		break;
	case SGX_NO_UPDATE:
		break;
	default:
		pr_err("EUPDATESVN: unknown error %d\n", ret);
		/* TODO: block/teardown driver? */
		break;
	}

Since when this is executed EPC usage is zero error cases should block
or teardown SGX driver, presuming that they are because of either
incorrect driver state or spurious error code.

If this happens, we definitely do not want service, right?

I'm not sure of all error codes how serious they are, or are all of them
consequence of incorrectly working driver.

BR, Jarkko
