Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD3410E4;
	Tue, 20 May 2025 07:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747725737; cv=none; b=seySCO7b/VEi8Dod943VGs5cMAwjcW9C7MFbP6UB/QWODPFUQssc3Al8sezckycensuH+LAchx5Z2Mk5i+a6R+dNyOHs1w0zGbhRxO7WJJvdArSYnG5zMxQL+pOON1TduNh1+foOjzT4ziZCSPVCYm5jAPS6no87g7G6mQ24Ajw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747725737; c=relaxed/simple;
	bh=y9ewuo/SN3E3xsojCJLeTF8bj32Y1s+k8FhxAKaX+t4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lo4a87h6/xOEJGt92c65Fsl/Pcv7/+DNa8NVlGDorRl7gq4V5t3dmIQT+XXp5D8UXd1LDFqeB4HB9R+u6xQPQyZ1wy4i4EMBgXnwyhrAgvmL2xrd/n/ASZ9dCP6P5jTiHRQ+Clolj2Ql5yeRw7Aivw4qGsP8XiMRvOqG5cybXkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R27upOoK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R27upOoK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88E17C4CEEF;
	Tue, 20 May 2025 07:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747725737;
	bh=y9ewuo/SN3E3xsojCJLeTF8bj32Y1s+k8FhxAKaX+t4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=R27upOoKQwn7OFcVh/nSQ5rFBN/FWS2/qayk5ivzgQaGUmFEUSK3YTU32f9Y4cQWA
	 CoGreB8d3leLKrlX0ogsCTDSIZhq5yOk9VZmFZrFBKFEFIzAqdwB/Pi5e6fYayRNg7
	 Z50sLbdq65zawSeH4Q1DiZLCLBckuKYmkhFMvyrd+lrBprqn82a6gUtohy/TrFZ2WH
	 AmwpFUBbZTanTkamgERUynQht5xgclhw34Xi7YFfs03uUc8Oe+x6/W8CzJT8TXFGex
	 kdTOvlKcFg/dPNbiuo21y7r7yEO2rNRkqkvqgcsjUZZQb1i8quKwwaXaSjBJjqQLaE
	 axBbMH8+5IYow==
Date: Tue, 20 May 2025 09:22:10 +0200
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
Message-ID: <aCwtorq4nJumlaV1@gmail.com>
References: <20250519072603.328429-1-elena.reshetova@intel.com>
 <20250519072603.328429-6-elena.reshetova@intel.com>
 <aCrlFfl2lAzzHOA8@gmail.com>
 <DM8PR11MB57504A6B41329214262E16E2E79CA@DM8PR11MB5750.namprd11.prod.outlook.com>
 <aCspW0MweLoODLC8@gmail.com>
 <DM8PR11MB57508B2C1407546C4D8B501EE79FA@DM8PR11MB5750.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM8PR11MB57508B2C1407546C4D8B501EE79FA@DM8PR11MB5750.namprd11.prod.outlook.com>


* Reshetova, Elena <elena.reshetova@intel.com> wrote:

> > > Yes, meaning is different, see above.
> > 
> > So that's rather convoluted:
> > 
> > 	atomic64_inc_not_zero():   returns 1 on successful increase, 0 on
> > failure
> >         sgx_inc_usage_count():     returns 0 on successful increase, 1 on failure
> >         sgx_open():                returns 0 on successful increase, -EBUSY on failure
> > 
> > Could we at least standardize sgx_inc_usage_count() on -EBUSY in the
> > failure case, so it's a more obvious pattern:
> > 
> > +       ret = sgx_inc_usage_count();
> > +       if (ret < 0)
> > +               return ret;
> > 
> 
> Yes, will rewrite accordingly. Especially since I have to return two different
> error codes into sgx_open() now to indicate different nature of issues with
> running EUDPATESVN: temporal failure due to lack of entropy (-EAGAIN)
> and potentially persistent problem when getting unexpected error codes
> (-EIO).

Makes sense!

Thanks,

	Ingo
