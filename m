Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 623F51552E3;
	Fri,  4 Apr 2025 07:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743752893; cv=none; b=c019kRx8GQ3Wfiip1ijgIAA66UYLE6eQnqgdOfmgjbD4Q2x2KJ4t3q1XAW+gfGvoPaK3YnaQzs7bC2vFzUeabNesK2imog0JbiiRBmAuirHJ3C0foly1ZFgy3y6sPmZJAvzJkElz+RADXs70H2+Cgi+dWt+iY2oSijrOsMNCyng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743752893; c=relaxed/simple;
	bh=CWgn0iuDB61o8APfrFwOk0rOr7NMFOnhrduS8Ub4R/4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GXHQtT4v7IEkX1ukmvpHIJTTtYSHh8UjSO0ijgZABUSyZ6En8up/Eo39Jf26JR2C7Svl/3plF1MXDs3764cn9RAH3ZfwBm4zxt0LU8kh3M8tgivYXcb7oaW8hZJic+f6IEZIQ+lc5uhPhw4I3jhrylsNNoUgC9pSiMlrRHBuKLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EdzSo6AR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EdzSo6AR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57793C4CEDD;
	Fri,  4 Apr 2025 07:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743752892;
	bh=CWgn0iuDB61o8APfrFwOk0rOr7NMFOnhrduS8Ub4R/4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EdzSo6ARK1UfzhsxiPzjjCufTuaMzJ/BY7wMw7xL80+y7Pv7zoZpg9rTeI61T8hJD
	 L6spvadDV+Z86S2YeB/zmbgelCx/RxW7P0D3izF3MS7vvSYWMr44sf71moHQWXWR+E
	 D8OffDtA26EpHHJNm6lKMvE8OkD6wLw8UW+CPy8mlsZNpzmP4TYJeyp17fyYxhe5IY
	 tm+C+tT2GJGhvEn/lW1Qg6W3DvO/U70VtCbwYUskDPeT//F7syTFUgzAEqVGcIsIGA
	 h+6BO29HF3v6TsthlBgJOVZZpZS6YoA/I36syp2pZwxKbGE7woxmphMAfDN0G2HDPU
	 1KmoAz22MGZbQ==
Date: Fri, 4 Apr 2025 10:48:08 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: "Annapurve, Vishal" <vannapurve@google.com>,
	"Hansen, Dave" <dave.hansen@intel.com>,
	"linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>,
	"Mallick, Asit K" <asit.k.mallick@intel.com>,
	"Scarlata, Vincent R" <vincent.r.scarlata@intel.com>,
	"Cai, Chong" <chongc@google.com>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"dionnaglaze@google.com" <dionnaglaze@google.com>,
	"bondarn@google.com" <bondarn@google.com>,
	"Raynor, Scott" <scott.raynor@intel.com>
Subject: Re: [PATCH v2 2/2] x86/sgx: Implement EUPDATESVN and
 opportunistically call it during first EPC page alloc
Message-ID: <Z--OuMuWx8jUdSU1@kernel.org>
References: <20250328125859.73803-3-elena.reshetova@intel.com>
 <Z-bhczXA6aHdCYHq@kernel.org>
 <Z-blOQ94ymUsDwPn@kernel.org>
 <DM8PR11MB5750C88DFC518EB77B0D613FE7AD2@DM8PR11MB5750.namprd11.prod.outlook.com>
 <Z-rU_JXWn0vCdBr_@kernel.org>
 <DM8PR11MB5750A46718F899A43C52A984E7AC2@DM8PR11MB5750.namprd11.prod.outlook.com>
 <Z-v4WfcLhmXbYvaa@kernel.org>
 <DM8PR11MB575087BDAFA223EDCE9EC69EE7AF2@DM8PR11MB5750.namprd11.prod.outlook.com>
 <Z-7dqQCiu5fWZ9a9@kernel.org>
 <DM8PR11MB5750131ED71BFF175E3E329CE7A92@DM8PR11MB5750.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM8PR11MB5750131ED71BFF175E3E329CE7A92@DM8PR11MB5750.namprd11.prod.outlook.com>

On Fri, Apr 04, 2025 at 06:53:17AM +0000, Reshetova, Elena wrote:
> > On Wed, Apr 02, 2025 at 01:11:25PM +0000, Reshetova, Elena wrote:
> > > > > current SGX kernel code does not handle such errors in any other way
> > > > > than notifying that operation failed for other ENCLS leaves. So, I don't
> > > > > see why ENCLS[EUPDATESVN] should be different from existing
> > behaviour?
> > > >
> > > > While not disagreeing fully (it depends on call site), in some
> > > > situations it is more difficult to take more preventive actions.
> > > >
> > > > This is a situation where we know that there are *zero* EPC pages in
> > > > traffic so it is relatively easy to stop the madness, isn't it?
> > > >
> > > > I guess the best action would be make sgx_alloc_epc_page() return
> > > > consistently -ENOMEM, if the unexpected happens.
> > >
> > > But this would be very misleading imo. We do have memory, even page
> > > allocation might function as normal in EPC, the only thing that is broken
> > > can be EUPDATESVN functionality. Returning -ENOMEM in this case seems
> > > wrong.
> > 
> > This makes it not misleading at all:
> > 
> > 	pr_err("EUPDATESVN: unknown error %d\n", ret);
> > 
> > Since hardware should never return this, it indicates a kernel bug.
> 
> OK, so you propose in this case to print the above message, sgx_updatesvn
> returning an error, and then NULL from __sgx_alloc_epc_page_from_node and
> the __sgx_alloc_epc_page returning -ENOMEM after an iteration over
> a whole set of numa nodes given that we will keep getting the unknown error
> on each node upon trying to do an allocation from each one?

I'd disable ioctl's in this case and return -ENOMEM. It's a cheap sanity
check. Should not ever happen, but if e.g., a new kernel patch breaks
anything, it could help catching issues.

We are talking here about situation that is never expected to happen so I
don't think it is too heavy hammer here. Here it makes sense because not
much effort is required to implement the counter-measures.

> 
> Best Regards,
> Elena. 
> 
> 
> 

BR, Jarkko
