Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15748157A5A;
	Mon, 31 Mar 2025 17:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743443203; cv=none; b=moMywVngvg3mnXgf2RiNgwe7WH61xqQ3P+dppEhTlAqJEmobZVB19ApSrjlArbfbG25kXlnmhuAJ9634XUIHfJ+YZxCTbeHRTAcopoYOVZtNm4divr6YR/5kD1hKM8O+mfmmugxPN1w4nvNr9Cf1eBvVAOPOY3glrhMM9OFIkcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743443203; c=relaxed/simple;
	bh=hz0ih5RSQaFvOri/b2YgUookxzob3UAMF9e951iei0g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y24BpfGKeVRpNlo7aTmznwTMfzjXSsMpKtdwb81KmKeNiv2v3Ly/TRjXq3X+j5uYoY4Xh8ju/WSG2J9Iqw1XalPfJb1L1lBoOZQNza5+MMv8LPvgbtg6QQxokJc3bHFEPfIVyu2S7dKDsVwjYwpGgF4jwLfZu+qzk07SU7O8t7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EzNmX/Th; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EzNmX/Th"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7A5CC4CEE3;
	Mon, 31 Mar 2025 17:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743443201;
	bh=hz0ih5RSQaFvOri/b2YgUookxzob3UAMF9e951iei0g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EzNmX/ThqrXPhR0b5PDKiyvuc1bICvWTVev4ra2QiztbJFpjX7oic5bcPmQbYGAPN
	 fNax9JWvhPFEulbkIlF8I5S2Pti4DRID//9r3HMQVoKzCm/SntDN4gI4NGrHpdpXOH
	 7AMwo4776CyuGGBrMGzv5unEeowSd1z0RPbIBZ0SbgXUwIoNXIa4Z7t67DDDspF1UX
	 pU91/wu/94FCvN4T44boObhSdGXbmEOYPMtqbFvrqe9v0UDuwVWOFgej4G+GkMg8ao
	 RKAX10IaeGvbTGgOhqI2b5PhnIBWQEnvUe22laEeN1hJgqGUCFutDAmR3RC1LgfGV3
	 21aseYmJ19YUQ==
Date: Mon, 31 Mar 2025 20:46:36 +0300
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
Subject: Re: [PATCH v2 2/2] x86/sgx: Implement EUPDATESVN and
 opportunistically call it during first EPC page alloc
Message-ID: <Z-rU_JXWn0vCdBr_@kernel.org>
References: <20250328125859.73803-1-elena.reshetova@intel.com>
 <20250328125859.73803-3-elena.reshetova@intel.com>
 <Z-bhczXA6aHdCYHq@kernel.org>
 <Z-blOQ94ymUsDwPn@kernel.org>
 <DM8PR11MB5750C88DFC518EB77B0D613FE7AD2@DM8PR11MB5750.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM8PR11MB5750C88DFC518EB77B0D613FE7AD2@DM8PR11MB5750.namprd11.prod.outlook.com>

On Mon, Mar 31, 2025 at 07:26:45AM +0000, Reshetova, Elena wrote:
> > > > +	default:
> > > > +		pr_err("EUPDATESVN: unknown error %d\n", ret);
> > > > +		break;
> > > > +	}
> > >
> > > Overall, I think you're right in that "inversion" does make sense,
> > > now that other stuff is better aligned.
> > >
> > > At least when there is spurious error, I think ioctl's should stop
> > > responding and driver should not do anything useful anymore. I.e.,
> > > it should go out-of-service.
> > >
> > > I don't think the driver should tear-down, just stop servicing
> > > VM's and responding ioctl's.
> > >
> > > Possibly thish should be also right action for other errors than
> > > "insufficient entropy" but I'm open for comments for this.
> > 
> > Or actually actually I take one step back with my suggestions
> > because this really should be a question for which I don't have
> > the definitive answer.
> > 
> > The current code works like this: if anything that we don't
> > like happens, we re-iterate.
> > 
> > Should some of the "exceptional conditions" have a different
> > recovery or not?
> 
> None of these exceptional conditions are fatal or present an
> immediate danger to the system security. So, allowing the re-tries
> seems logical in this case. In case re-tries also fail, the system
> admin will have an option of gracefully shutting down all enclaves
> and doing either a full reboot (if SVN is the only concern) or other
> necessary actions like taking the physical node out of use, etc. 
> 
> Does this sound reasonable? 

Uknown error I don't think would hold that premise.

> 
> Best Regards,
> Elena.
> 

BR, Jarkko
> 
