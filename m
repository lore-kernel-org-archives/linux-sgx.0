Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A942C204C07;
	Tue,  1 Apr 2025 14:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743517790; cv=none; b=YXVelDyXxAaBnF09tha8a43F759pvXivHxyqcABSu6F0H8MN4RNFnqsNL/GLLq7QlXXM62ZAdXL0zrkrSbUD2nIZjI+IfRhfQlgYFPtrs0Lwagongmg1/QRJtH4Rn448OYUgLblVak5cWxycy0I0C5+fkXCh0P+9f91upode2iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743517790; c=relaxed/simple;
	bh=wlVU2YfmrjlqjXVg8SNfnOgR3nDw1BUVMZSLmdeVvLE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=llUrSlAobK948Y/KLz8qgjPzVZCUmJWf3XD5zLhdKsJkAVhTI8IZI+5/b0b4tLsHSN8wELUFgsU0WfKhsm1T44IhgbrMLvYqownGRrjWlmL4PkoO5q6/iwrXgViM3fMUGS5GGhZdd6dI5lYw/PIzzWeKKJVHo/RK4SoPPQ3l0bI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TcbfB/eu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TcbfB/eu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B483C4CEE4;
	Tue,  1 Apr 2025 14:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743517790;
	bh=wlVU2YfmrjlqjXVg8SNfnOgR3nDw1BUVMZSLmdeVvLE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TcbfB/euuGlDXhcWN+svUyB7Q0cFXHTXFYtFI5nljZSHT7GYQ5eZf18bm6Q+IEUHe
	 B9QfPPIvzdv9mOXDru8RZ5FoLkY9D/MQleFAHlZpcP+kAqDsRBIEbTc0UXbIPThwBu
	 xXyoo2EDdLcW1JKhDUJVRhaemFJIj8g0iEcxzVeUI5Ez7XQIavG/tVoeKmovJ/c2zj
	 9ZSF/8cGD+d/ms4RdbXKcNov6B+1SvpT5eO0rIT4l5KGohwX9qYf+Qeu+hjQEt4a0z
	 ljpTynY+TrF/ruJ0XZps47jdt2vGOpH/PJc9BjYc6RXVvHKkCYg6B17kci2m+ViZCu
	 CA3mS1nTEUWBA==
Date: Tue, 1 Apr 2025 17:29:45 +0300
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
Message-ID: <Z-v4WfcLhmXbYvaa@kernel.org>
References: <20250328125859.73803-1-elena.reshetova@intel.com>
 <20250328125859.73803-3-elena.reshetova@intel.com>
 <Z-bhczXA6aHdCYHq@kernel.org>
 <Z-blOQ94ymUsDwPn@kernel.org>
 <DM8PR11MB5750C88DFC518EB77B0D613FE7AD2@DM8PR11MB5750.namprd11.prod.outlook.com>
 <Z-rU_JXWn0vCdBr_@kernel.org>
 <DM8PR11MB5750A46718F899A43C52A984E7AC2@DM8PR11MB5750.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM8PR11MB5750A46718F899A43C52A984E7AC2@DM8PR11MB5750.namprd11.prod.outlook.com>

On Tue, Apr 01, 2025 at 09:35:33AM +0000, Reshetova, Elena wrote:
> > > None of these exceptional conditions are fatal or present an
> > > immediate danger to the system security. So, allowing the re-tries
> > > seems logical in this case. In case re-tries also fail, the system
> > > admin will have an option of gracefully shutting down all enclaves
> > > and doing either a full reboot (if SVN is the only concern) or other
> > > necessary actions like taking the physical node out of use, etc.
> > >
> > > Does this sound reasonable?
> > 
> > Uknown error I don't think would hold that premise.
> 
> True, unknown is an unknown ))
> But unknown errors should not happen (per SGX spec), and the

Thus if for some reason unknown error code would be returned something
would be horribly wrong (e.g. bad emulation of the opcode or who knows
what) and thus it would make sense disable the driver if this happens.

Or maybe even BUG_ON() in this situation?

> current SGX kernel code does not handle such errors in any other way
> than notifying that operation failed for other ENCLS leaves. So, I don't
> see why ENCLS[EUPDATESVN] should be different from existing behaviour?

While not disagreeing fully (it depends on call site), in some
situations it is more difficult to take more preventive actions.

This is a situation where we know that there are *zero* EPC pages in
traffic so it is relatively easy to stop the madness, isn't it?

I guess the best action would be make sgx_alloc_epc_page() return
consistently -ENOMEM, if the unexpected happens.

/* <- this
 * Do not execute ENCLS[EUPDATESVN] if running in a VM since
 * microcode updates are only meaningful to be applied on the host.
 */

According to https://www.kernel.org/doc/Documentation/kernel-doc-nano-HOWTO.txt

> 
> Best Regards,
> Elena.
> 
> 

BR, Jarkko
