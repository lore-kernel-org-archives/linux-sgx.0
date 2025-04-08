Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CC38C148;
	Tue,  8 Apr 2025 06:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744094562; cv=none; b=KPv40glGNRIIlLnogNTc/ysEayDN0y+Q08gdpKAnTnP8tBqNxuw181YyVdqayVfCclqbcPltlCjP4tdizZOvOAz6d0wmTcsdn0J7XLSwuOvXs1f/qj9ME+NEY/7ZAF8yEkGnagFGajWQgNHqo+C8yScCT1aldyz3A/AQOauq4/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744094562; c=relaxed/simple;
	bh=1Vhu0wfmIY+DGA0FtYUOOlyZYCf9Vidu0y+bP9vgBZA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZStPiBPxudVz4D95Oob1DvMmMl15vcIl0I9AImOIpaIYd97hBCN0PJz7zlxUtht2NDszx/tYbUIMd27TMV6koCXRdj2JsAeMn3PoqWTl6YFoqKkK5cPXMuE8zkBsXCEs8oLHjSn2aaeezW5BIKWY9X72+69kaPgs9DIQiYsisx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MqdwWBzx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MqdwWBzx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44357C4CEE5;
	Tue,  8 Apr 2025 06:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744094559;
	bh=1Vhu0wfmIY+DGA0FtYUOOlyZYCf9Vidu0y+bP9vgBZA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MqdwWBzxn/CUMPKxFPyrquZESR3XNRs8Mc+zUOStArk160RCGFD1KQm/GNTZ066kV
	 7SxSuUyqrDCAJe96oE1wxnm8FJhiDTMg1Ea1oBsij2GdHXbF/O5m0zOhwIqE8ClCtF
	 FM/nH0h7yxTT1M8UseaX0sVxCRL/4cr/uHaZrmgKjC8wNZpk8HtozpGGGB/XOiAITO
	 ZZDmDvWwVQ41PMZm1aWANL1+zLrGuE3DJn0ZDKeG/mbjFMEiUOgNt22gr8nak7/eNa
	 omecUq9XCgrwKZI0XNx97JnosYiG21E3zbpisDzkx5w+sMdexkOOwB+PggyW/fungl
	 LewJZh2i87WIw==
Date: Tue, 8 Apr 2025 09:42:35 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: "Reshetova, Elena" <elena.reshetova@intel.com>,
	"Hansen, Dave" <dave.hansen@intel.com>,
	"linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"Scarlata, Vincent R" <vincent.r.scarlata@intel.com>,
	"x86@kernel.org" <x86@kernel.org>,
	"Annapurve, Vishal" <vannapurve@google.com>,
	"bondarn@google.com" <bondarn@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Mallick, Asit K" <asit.k.mallick@intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"Cai, Chong" <chongc@google.com>,
	"Raynor, Scott" <scott.raynor@intel.com>,
	"dionnaglaze@google.com" <dionnaglaze@google.com>
Subject: Re: [PATCH v2 2/2] x86/sgx: Implement EUPDATESVN and
 opportunistically call it during first EPC page alloc
Message-ID: <Z_TFW_0D90wK8BdM@kernel.org>
References: <Z-rU_JXWn0vCdBr_@kernel.org>
 <DM8PR11MB5750A46718F899A43C52A984E7AC2@DM8PR11MB5750.namprd11.prod.outlook.com>
 <Z-v4WfcLhmXbYvaa@kernel.org>
 <DM8PR11MB575087BDAFA223EDCE9EC69EE7AF2@DM8PR11MB5750.namprd11.prod.outlook.com>
 <Z-7dqQCiu5fWZ9a9@kernel.org>
 <DM8PR11MB5750131ED71BFF175E3E329CE7A92@DM8PR11MB5750.namprd11.prod.outlook.com>
 <Z--OuMuWx8jUdSU1@kernel.org>
 <DM8PR11MB575046992BEACCD83164043CE7AA2@DM8PR11MB5750.namprd11.prod.outlook.com>
 <a0a803275d317f88afdd757afa30e84a26b05656.camel@intel.com>
 <Z_TEzsYnCxXoEhi0@kernel.org>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Z_TEzsYnCxXoEhi0@kernel.org>

On Tue, Apr 08, 2025 at 09:40:14AM +0300, Jarkko Sakkinen wrote:
> On Tue, Apr 08, 2025 at 12:06:32AM +0000, Huang, Kai wrote:
> > On Mon, 2025-04-07 at 08:23 +0000, Reshetova, Elena wrote:
> > > > On Fri, Apr 04, 2025 at 06:53:17AM +0000, Reshetova, Elena wrote:
> > > > > > On Wed, Apr 02, 2025 at 01:11:25PM +0000, Reshetova, Elena wrote:
> > > > > > > > > current SGX kernel code does not handle such errors in any other
> > > > way
> > > > > > > > > than notifying that operation failed for other ENCLS leaves. So, I don't
> > > > > > > > > see why ENCLS[EUPDATESVN] should be different from existing
> > > > > > behaviour?
> > > > > > > > 
> > > > > > > > While not disagreeing fully (it depends on call site), in some
> > > > > > > > situations it is more difficult to take more preventive actions.
> > > > > > > > 
> > > > > > > > This is a situation where we know that there are *zero* EPC pages in
> > > > > > > > traffic so it is relatively easy to stop the madness, isn't it?
> > > > > > > > 
> > > > > > > > I guess the best action would be make sgx_alloc_epc_page() return
> > > > > > > > consistently -ENOMEM, if the unexpected happens.
> > > > > > > 
> > > > > > > But this would be very misleading imo. We do have memory, even page
> > > > > > > allocation might function as normal in EPC, the only thing that is broken
> > > > > > > can be EUPDATESVN functionality. Returning -ENOMEM in this case
> > > > seems
> > > > > > > wrong.
> > > > > > 
> > > > > > This makes it not misleading at all:
> > > > > > 
> > > > > > 	pr_err("EUPDATESVN: unknown error %d\n", ret);
> > > > > > 
> > > > > > Since hardware should never return this, it indicates a kernel bug.
> > > > > 
> > > > > OK, so you propose in this case to print the above message, sgx_updatesvn
> > > > > returning an error, and then NULL from __sgx_alloc_epc_page_from_node
> > > > and
> > > > > the __sgx_alloc_epc_page returning -ENOMEM after an iteration over
> > > > > a whole set of numa nodes given that we will keep getting the unknown
> > > > error
> > > > > on each node upon trying to do an allocation from each one?
> > > > 
> > > > I'd disable ioctl's in this case and return -ENOMEM. It's a cheap sanity
> > > > check. Should not ever happen, but if e.g., a new kernel patch breaks
> > > > anything, it could help catching issues.
> > > > 
> > > > We are talking here about situation that is never expected to happen so I
> > > > don't think it is too heavy hammer here. Here it makes sense because not
> > > > much effort is required to implement the counter-measures.
> > > 
> > > OK, but does it really make sense to explicitly disable ioctls? 
> > > Note that everything *in practice* will be disabled simply because not a single page
> > > anymore can be allocated from EPC since we are getting -ENOMEM on EPC
> > > page allocation. Also, note that any approach we chose should be symmetrical
> > > to SGX virtualization side also, which doesn´t use ioctls at all. Simply returning
> > > -ENOMEM for page allocation in EPC seems like a correct symmetrical solution
> > > that would work for both nativel enclaves and EPC pages allocated for VMs.
> > > And nothing would  be able to proceed creating/managing enclaves at this point. 
> > > 
> > 
> > Right, failing ioctls() doesn't cover SGX virtualization.  If we ever want to
> > fail, we should fail the EPC allocation.
> 
> "I guess the best action would be make sgx_alloc_epc_page() return
>  consistently -ENOMEM, if the unexpected happens." -me
> 
> > 
> > Btw, for the unknown error, and any other errors which should not happen,
> > couldn't we use the ENCLS_WARN()?  AFAICT there are already cases that we are
> > using ENCLS_WARN() for those "impossible-to-happen-errors".

Sorry forgot to response this. I don't have anything against this but at
minimum disabling allocation should be combined with it (in case kernel
command-line does not have oops_on_warn or whatever the option was
called).

> > 
> > E.g., in __sgx_encl_extend():
> > 
> > 	        ret = __eextend(sgx_get_epc_virt_addr(encl->secs.epc_page),
> >                                 sgx_get_epc_virt_addr(epc_page) + offset);
> >                 if (ret) {
> >                         if (encls_failed(ret))
> >                                 ENCLS_WARN(ret, "EEXTEND");
> >    
> >                         return -EIO;
> >                 }
> 
> BR, Jarkko
> 

BR, Jarkko
