Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31D841A8407;
	Tue,  8 Apr 2025 15:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744126075; cv=none; b=M/rYf1c2t4rNcCmqdylzaqgXzYMnkS8pdMIZTI/VDDUfpx/R27vrmn8TyyszN0HqOfp5srjoQ1xKcFb34O6CB+rREHt8e3gGRyYtYqTeUtsoWhlzKbYq5i1YLCS3+XZudXi2P1u629K/jROOQALuHkLXZkU/AZdUT4YTDdfRruE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744126075; c=relaxed/simple;
	bh=apOTnBEYnp+4vpAZRy392z3LTawzOMEtmvA5es8uilk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oEV8F/tqRKGtWbVjdicUHFWKiGME6SREhtTr3VJj1gfdCg+0cDK60Qv8QJU8bYKDYm7RcKFaD86bqBKpZrumAtbo2a3TicARqUYQnkLVp0vxDjEl632gmWh2VcyCV2UUFuF/He05ZiMlA0H9Hy+6EVY6jGqBwYuObr78xJ6LAnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OMzn1SAC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OMzn1SAC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22B9DC4CEE5;
	Tue,  8 Apr 2025 15:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744126074;
	bh=apOTnBEYnp+4vpAZRy392z3LTawzOMEtmvA5es8uilk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OMzn1SACfFAvrXiTZAzvCqhJGoA7hyhiDo7mBzfTkR8LkWxVKo+bmCizYohdXapie
	 ZQd9o4Nqkji2MMyd9lEF3pP42n7dTC7RcMjKiuYRj98djJBrSPW/KMbLlk97uuCJax
	 YncWAwtdb+VpE+x5GA1x//XInot/4FXFfmMYwuh3pADIqm7BgVB37QiBZGvtog/stg
	 KtO0iOF71pA91i6mLFxqHjBkhZG7JGUV6YMcXJ3gx/sEray6ZcBYu5qM7YSYZYTkoo
	 8vbjsKVcbHW8hI6EJQY9ivu6fU0q2yRuEPr9wkONgA22mYrFVBQ4R4bM4goW4KoFsx
	 V8fp9Lfncy/JQ==
Date: Tue, 8 Apr 2025 18:27:50 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: "Huang, Kai" <kai.huang@intel.com>,
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
Message-ID: <Z_VAdvT305Rt2h9x@kernel.org>
References: <Z-v4WfcLhmXbYvaa@kernel.org>
 <DM8PR11MB575087BDAFA223EDCE9EC69EE7AF2@DM8PR11MB5750.namprd11.prod.outlook.com>
 <Z-7dqQCiu5fWZ9a9@kernel.org>
 <DM8PR11MB5750131ED71BFF175E3E329CE7A92@DM8PR11MB5750.namprd11.prod.outlook.com>
 <Z--OuMuWx8jUdSU1@kernel.org>
 <DM8PR11MB575046992BEACCD83164043CE7AA2@DM8PR11MB5750.namprd11.prod.outlook.com>
 <a0a803275d317f88afdd757afa30e84a26b05656.camel@intel.com>
 <Z_TEzsYnCxXoEhi0@kernel.org>
 <Z_TFW_0D90wK8BdM@kernel.org>
 <DM8PR11MB5750D5848DC0B3AC0EF00C30E7B52@DM8PR11MB5750.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DM8PR11MB5750D5848DC0B3AC0EF00C30E7B52@DM8PR11MB5750.namprd11.prod.outlook.com>

On Tue, Apr 08, 2025 at 06:54:14AM +0000, Reshetova, Elena wrote:
> > 
> > On Tue, Apr 08, 2025 at 09:40:14AM +0300, Jarkko Sakkinen wrote:
> > > On Tue, Apr 08, 2025 at 12:06:32AM +0000, Huang, Kai wrote:
> > > > On Mon, 2025-04-07 at 08:23 +0000, Reshetova, Elena wrote:
> > > > > > On Fri, Apr 04, 2025 at 06:53:17AM +0000, Reshetova, Elena wrote:
> > > > > > > > On Wed, Apr 02, 2025 at 01:11:25PM +0000, Reshetova, Elena
> > wrote:
> > > > > > > > > > > current SGX kernel code does not handle such errors in any
> > other
> > > > > > way
> > > > > > > > > > > than notifying that operation failed for other ENCLS leaves. So,
> > I don't
> > > > > > > > > > > see why ENCLS[EUPDATESVN] should be different from
> > existing
> > > > > > > > behaviour?
> > > > > > > > > >
> > > > > > > > > > While not disagreeing fully (it depends on call site), in some
> > > > > > > > > > situations it is more difficult to take more preventive actions.
> > > > > > > > > >
> > > > > > > > > > This is a situation where we know that there are *zero* EPC
> > pages in
> > > > > > > > > > traffic so it is relatively easy to stop the madness, isn't it?
> > > > > > > > > >
> > > > > > > > > > I guess the best action would be make sgx_alloc_epc_page()
> > return
> > > > > > > > > > consistently -ENOMEM, if the unexpected happens.
> > > > > > > > >
> > > > > > > > > But this would be very misleading imo. We do have memory,
> > even page
> > > > > > > > > allocation might function as normal in EPC, the only thing that is
> > broken
> > > > > > > > > can be EUPDATESVN functionality. Returning -ENOMEM in this
> > case
> > > > > > seems
> > > > > > > > > wrong.
> > > > > > > >
> > > > > > > > This makes it not misleading at all:
> > > > > > > >
> > > > > > > > 	pr_err("EUPDATESVN: unknown error %d\n", ret);
> > > > > > > >
> > > > > > > > Since hardware should never return this, it indicates a kernel bug.
> > > > > > >
> > > > > > > OK, so you propose in this case to print the above message,
> > sgx_updatesvn
> > > > > > > returning an error, and then NULL from
> > __sgx_alloc_epc_page_from_node
> > > > > > and
> > > > > > > the __sgx_alloc_epc_page returning -ENOMEM after an iteration
> > over
> > > > > > > a whole set of numa nodes given that we will keep getting the
> > unknown
> > > > > > error
> > > > > > > on each node upon trying to do an allocation from each one?
> > > > > >
> > > > > > I'd disable ioctl's in this case and return -ENOMEM. It's a cheap sanity
> > > > > > check. Should not ever happen, but if e.g., a new kernel patch breaks
> > > > > > anything, it could help catching issues.
> > > > > >
> > > > > > We are talking here about situation that is never expected to happen
> > so I
> > > > > > don't think it is too heavy hammer here. Here it makes sense because
> > not
> > > > > > much effort is required to implement the counter-measures.
> > > > >
> > > > > OK, but does it really make sense to explicitly disable ioctls?
> > > > > Note that everything *in practice* will be disabled simply because not a
> > single page
> > > > > anymore can be allocated from EPC since we are getting -ENOMEM on
> > EPC
> > > > > page allocation. Also, note that any approach we chose should be
> > symmetrical
> > > > > to SGX virtualization side also, which doesn´t use ioctls at all. Simply
> > returning
> > > > > -ENOMEM for page allocation in EPC seems like a correct symmetrical
> > solution
> > > > > that would work for both nativel enclaves and EPC pages allocated for
> > VMs.
> > > > > And nothing would  be able to proceed creating/managing enclaves at
> > this point.
> > > > >
> > > >
> > > > Right, failing ioctls() doesn't cover SGX virtualization.  If we ever want to
> > > > fail, we should fail the EPC allocation.
> > >
> > > "I guess the best action would be make sgx_alloc_epc_page() return
> > >  consistently -ENOMEM, if the unexpected happens." -me
> > >
> > > >
> > > > Btw, for the unknown error, and any other errors which should not
> > happen,
> > > > couldn't we use the ENCLS_WARN()?  AFAICT there are already cases that
> > we are
> > > > using ENCLS_WARN() for those "impossible-to-happen-errors".
> 
> Ok, so to summarise the approach I will be sending in the next version:
> 
> In case unknown error returns, issue ENCLS_WARN (uses WARN_ON underneath)
> and return -ENOMEM from EPC page allocation. No other explicit ioctl disabling needed
> since nothing can proceed anyhow if we cannot allocate a page from EPC.
> 
> Does this sound right? 

I think it should be sufficient (not a review tho).

> 
> Best Regards,
> Elena.

BR, Jarkko
