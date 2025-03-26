Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BE421CD1F;
	Wed, 26 Mar 2025 20:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743019638; cv=none; b=SaWEp5L+ZgxRoiF5XvH7HV7yHRlSp7tvH4Ch5IqbPtF8xhpt9RT5RidntoV7FJeCI891Tsjr2EYEc+E3hb6KaAEWLU8Rwv/Q7AyL4W0nP9FSeb9+Dk/R5ZmCv5c7M/hOqDboH3vEMWfn+UybINRKcxHJFZTfyOgdv6OsNEsh8FE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743019638; c=relaxed/simple;
	bh=dkdZ3vEHDyKADLROiHfl7/jsXqBJ6A27l9gxZgrup+I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k0i9BhcCSHMt29VypJQ8fQeO7HWfXzdapnk+wPc7uXhPF9ID4gkH+OSwMdnZuqi1gDvC7+id/GnJAjNE+BnF2m8dAq7qQbIO7qKsUjko1245OtwxCCcQwARu0MkHxmtG8VYuP6MQNPwphi8H4JBwcUWrk8gQdQarhCMaJLupMb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Yk8Tgp+D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Yk8Tgp+D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 321B6C4CEE2;
	Wed, 26 Mar 2025 20:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743019636;
	bh=dkdZ3vEHDyKADLROiHfl7/jsXqBJ6A27l9gxZgrup+I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Yk8Tgp+D0TAKartaO2I8NjzcWrErOi9D1n9yvUrZnYNvzdro8izuSA+o43dTBq+Uc
	 vV3e25D3G6UsovHm5fFsYfE8NiSYyKr8KQNSo+PMv58wJCJRGReYIpi1PkogISzFOi
	 X5HIbaZ/T1ELyRxUtQT8Idd9UKhCKjJLhQ/sezbYDt9qRLjXLHI47+81G7ShwgtAmt
	 krTkJubC9UDy5zzeuXcAC+hx38VoCOMFQrm+sHspbocFFyDE9TrAFkOS7j++PAUMKW
	 JlZMvtbzlkPPrKZVS/l8sxRfp4UeCLA58VNll6Wp421W3A5ninDbDKMIBfshSXGDvo
	 0SfKPH6Rfoqww==
Date: Wed, 26 Mar 2025 22:07:12 +0200
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
Message-ID: <Z-RecEZhXshD6yma@kernel.org>
References: <20250321123938.802763-1-elena.reshetova@intel.com>
 <20250321123938.802763-3-elena.reshetova@intel.com>
 <Z981ciAqpknQ3hRF@kernel.org>
 <DM8PR11MB5750B9CBBB7A51CE3A0F006AE7A42@DM8PR11MB5750.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DM8PR11MB5750B9CBBB7A51CE3A0F006AE7A42@DM8PR11MB5750.namprd11.prod.outlook.com>

On Mon, Mar 24, 2025 at 12:19:37PM +0000, Reshetova, Elena wrote:
>  
> > On Fri, Mar 21, 2025 at 02:34:41PM +0200, Elena Reshetova wrote:
> > > sgx_nr_free_pages is an atomic that is used to keep track of
> > > free EPC pages and detect whenever page reclaiming should start.
> > > Since successful execution of ENCLS[EUPDATESVN] requires empty
> > > EPC and a fast way of checking for this, change this variable
> > > around to indicate number of used pages instead. The subsequent
> > > patch that introduces ENCLS[EUPDATESVN] will take use of this change.
> > 
> > s/subsequent patch//
> 
> Ok
> 
> > 
> > You should rather express how EUPDATESVN trigger will depend on the
> > state of sgx_nr_used_pages and sgx_nr_free_pages.
> 
> How about this explanation:
> 
> "By counting the # of used pages instead of #of free pages, it allows the
> EPC page allocation path execute without a need to take the lock in all
> but a single case when the first page is being allocated in EPC. This is
> achieved via a fast check in atomic_long_inc_not_zero."

Yep, whole a lot more sense.

> 
> Also, if you think that it is hard to interpret the patch 2/4 without 4/4
> I can also squeeze them together and then it becomes right away clear
> why the change was done. 
> 
> 
> > 
> > >
> > > No functional changes intended.
> > 
> > Not really understanding how I should interpret this sentence.
> 
> Just as usual: this patch itself doesn’t bring any functional changes
> to the way as current SGX code works. I only needed this change to
> implement patch 4/4 in more lockless way. 
> 
> > 
> > The commit message does not mention sgx_nr_used_pages, and neiher it
> > makes a case why implementing the feature based on sgx_nr_free_pages is
> > not possible.
> 
> It is possible to implement it, in fact I did exactly this in the beginning instead,
> but as mentioned previously this would have resulted in taking a lock for each
> case the page is being allocated. 

Have you benchmarked this (memory barrier vs putting the whole thing
inside spinlock)?

I have doubts that this would even show in margins given how much e.g.,
ELDU takes.

> 
> Best Regards,
> Elena.
> 
> 

BR, Jarkko
