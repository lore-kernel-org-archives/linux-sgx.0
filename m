Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B50E01E50B;
	Tue, 20 May 2025 19:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747771043; cv=none; b=MykexRCRjI790f0cJboajHdDS232aUiCMuKm9LIq9KI3/WBwg3wgPMBVFrfH0lN0DlN+DLxn62Hl+QYZk9g6leVEH4b67gZUt6p2rzKXOw3n0wri4HoSQw+4JwdrbyWEvJWJDbuXJTaMRPBid/zcPdMRBZuSHTISSMRtM7BWzQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747771043; c=relaxed/simple;
	bh=9NAwuPJidDyhslNqwWUSFdEId/9pFB/ji/HVTk0Xu4M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UF9+Cva5WodUNkUdldY8FkUk08H19w2fWO8joLqZaCDGzFcXyPcAmKm21G8XQjCGiusxvC89kUCvgojzE8Shoe0biZdPmf2d1EO65ZCUjeMK6yWMGB0M1jRDvNwXoqCnjiBaGkndhIqLtWQspVQN53Ju/tGkeE8nyUSh5vQmqow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZsQzqIU2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZsQzqIU2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE23EC4CEE9;
	Tue, 20 May 2025 19:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747771043;
	bh=9NAwuPJidDyhslNqwWUSFdEId/9pFB/ji/HVTk0Xu4M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZsQzqIU2DMvYHmk5qyGiUZ3IxfDYJJ1Cbof48RrjYHAYe3PY3Bt0ZFqYr+B3WJ5rQ
	 ClDsFcYRDvFmUeietTmgn/zjq0/vARD/yzvJdhN7gNwQG/laMITdsZeK7vPHHF5dKR
	 eXqE/+zzim8GzRd8jx3c1EeFSjYkx1eLcnGabNIl0OsD6qzWvsKVLLdHSOMC7t7b3R
	 QtvFKIGfoMgnyZ2hNkmTXCYdImip3XpXKUyW7lFDqNWPWxSBAw/mX1qRe6yv0xbyIG
	 9eIrqEzeTjOWeJbVEqwyCtA7a3Fk0ARVqrpocuQc9wY8tIsj3Pt4eXIhxDnSygYNgb
	 QaHjSNaJgDZMw==
Date: Tue, 20 May 2025 22:57:19 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: "Hansen, Dave" <dave.hansen@intel.com>,
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
Subject: Re: [PATCH v5 4/5] x86/sgx: Implement ENCLS[EUPDATESVN]
Message-ID: <aCzen_zuw41a4qAK@kernel.org>
References: <20250519072603.328429-1-elena.reshetova@intel.com>
 <20250519072603.328429-5-elena.reshetova@intel.com>
 <aCt3XZ0m40wuA9bU@kernel.org>
 <DM8PR11MB57509295C87F7FB54B773107E79FA@DM8PR11MB5750.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM8PR11MB57509295C87F7FB54B773107E79FA@DM8PR11MB5750.namprd11.prod.outlook.com>

On Tue, May 20, 2025 at 06:31:46AM +0000, Reshetova, Elena wrote:

BTW, please keep the line which tells who responded.

>  > +/**
> > > + * sgx_updatesvn() - Attempt to call ENCLS[EUPDATESVN]
> > > + * If EPC is empty, this instruction attempts to update CPUSVN to the
> > > + * currently loaded microcode update SVN and generate new
> > > + * cryptographic assets.sgx_updatesvn() Most of the time, there will
> > 
> > Is there something wrong here in the text? It looks malformed.
> 
> Yes, sorry, looks like copy-paste error I missed in the comment. 
> Will fix. 
> 
> > 
> > > + * be no update and that's OK.
> > > + *
> > > + * Return:
> > > + * 0: Success, not supported or run out of entropy
> > > + */
> > > +static int sgx_update_svn(void)
> > > +{
> > > +	int ret;
> > > +
> > > +	/*
> > > +	 * If EUPDATESVN is not available, it is ok to
> > > +	 * silently skip it to comply with legacy behavior.
> > > +	 */
> > > +	if (!X86_FEATURE_SGX_EUPDATESVN)
> > > +		return 0;
> > > +
> > > +	for (int i = 0; i < RDRAND_RETRY_LOOPS; i++) {
> > > +		ret = __eupdatesvn();
> > > +
> > > +		/* Stop on success or unexpected errors: */
> > > +		if (ret != SGX_INSUFFICIENT_ENTROPY)
> > > +			break;
> > > +	}
> > > +
> > > +	/*
> > > +	 * SVN either was up-to-date or SVN update failed due
> > > +	 * to lack of entropy. In both cases, we want to return
> > > +	 * 0 in order not to break sgx_(vepc_)open. We dont expect
> > > +	 * SGX_INSUFFICIENT_ENTROPY error unless underlying RDSEED
> > > +	 * is under heavy pressure.
> > > +	 */
> > > +	if ((ret == SGX_NO_UPDATE) || (ret == SGX_INSUFFICIENT_ENTROPY))
> > 
> > 	if (ret == SGX_NO_UPDATE || ret == SGX_INSUFFICIENT_ENTROPY)
> 
> Ok, but I will have to change this anyhow since we seems to trend that we want
> to return -EBUSY when SGX_INSUFFICIENT_ENTROPY and do not
> proceed with open() call. 
> 
> > 
> > > +		return 0;
> > > +
> > > +	if (!ret) {
> > > +		/*
> > > +		 * SVN successfully updated.
> > > +		 * Let users know when the update was successful.
> > > +		 */
> > 
> > This comment is like as useless as an inline comment can ever possibly
> > be. Please, remove it.
> 
> It is actually not quite so useless because this is the rare case we know
> the EUPDATESVN actually executed and hence the pr_info also below.
> Without this, there will be no way for sysadmin to trace whenever CPU
> SVN was upgraded or not (Sean mentioned that this is already pretty
> opaque to users). 
> 
> > 
> > > +		pr_info("SVN updated successfully\n");
> > 
> > Let's not add this either in the scope of this patch set.
> 
> See above. 
> 
> > 
> > > +		return 0;
> > > +	}
> > 
> > Since you parse error codes already, I don't understand why deal with
> > the success case in the middle of doing that.
> > 
> > More consistent would be (not also the use of unlikely()):
> > 
> > 	if (ret == SGX_NO_UPDATE || ret == SGX_INSUFFICIENT_ENTROPY)
> > 		return 0;
> > 
> > 	/*
> > 	 * EUPDATESVN was called when EPC is empty, all other error
> > 	 * codes are unexpected.
> > 	 */
> > 	if (unlikely(ret)) {
> > 		ENCLS_WARN(ret, "EUPDATESVN");
> > 		return ret;
> > 	}
> > 
> > 	return 0;
> > }
> > 
> > This is how I would rewrite the tail of this function.
> 
> I think everyone already re-wrote this function at least once and no one is
> happy with the version from previous person )) 
> Let me try another version again, taking into account changes in return codes
> discussed in this thread also. 

unlikely() is both (minor) optimization and documents that it is not expected
branch so it obviously makes sense here.

> 
> Best Regards,
> Elena.

BR, Jarkko
