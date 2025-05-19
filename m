Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7636084A3E;
	Mon, 19 May 2025 17:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747675687; cv=none; b=Zhlu+ltRBLsTiRIZ1Hr9Mn5hx2MfcsA+WbRuG13saw8+ARX5Yavp2n2t5Z9cjIHqXxF98XxzlNV4fjzd7KQv+PVeTh3MEygR6kGnEO89K0Tf9pJlZbRoNqZzYJ8dXF+2wz8tw3OfSHwMOarm9Njhl+inw89p46y1rPe+FnsgBjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747675687; c=relaxed/simple;
	bh=+Ys6aNLqrwrdpJxv4Yrl70V7sWQOXzTZi2wZkGsDagQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sTMiAqevFoH/MllepQRWp4JSKDobY040VKjNJi1WGBabdvtt7n3cr47VGHccr8L6wC93uTfyIy6wTcuQoO7akjfaX69NRkOygJMgNvf0EGf1ag1UiSahNzXFUtX0M1bmile3iF3VYQnwGX5GmStQsHK29+De8eU/PV/8K3fwfbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=t0tPIOxM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="t0tPIOxM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9919C4CEE4;
	Mon, 19 May 2025 17:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747675687;
	bh=+Ys6aNLqrwrdpJxv4Yrl70V7sWQOXzTZi2wZkGsDagQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=t0tPIOxMmux94dwQVZ3+7YwFRrDW/GQiIsJ2ZeQCI+w3eUvvuMT8SxpnnTETZyPwS
	 yPifBHFtm+tkytOgC3rMNxBqc+W2wo8vyxcUl2EFmBSFy1Wd52SKR+ZPxz4gT7A2lv
	 dzWJIeNn8iyI9Qb1Log2+lWoJC0OTe+w6r6JfWNfswpFZIB5YK/58KT+9yYefY4Zq+
	 m6cKDkXDXDulwUt1/5KrN01buTI2rI9aKcyHPBRMehMC52y1wLJV3Q58PqI2OhGX80
	 WP4Ug57cuWTI8WE5PbcmqdS9pVVMm+X1Qm8FainOsbpCVskSdpV2q6tvH4y2TqJFYh
	 PpCJXJ3+BK4Ag==
Date: Mon, 19 May 2025 20:28:03 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: "Huang, Kai" <kai.huang@intel.com>,
	"Hansen, Dave" <dave.hansen@intel.com>,
	"Raynor, Scott" <scott.raynor@intel.com>,
	"linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"Scarlata, Vincent R" <vincent.r.scarlata@intel.com>,
	"x86@kernel.org" <x86@kernel.org>,
	"Annapurve, Vishal" <vannapurve@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"Mallick, Asit K" <asit.k.mallick@intel.com>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"Cai, Chong" <chongc@google.com>,
	"bondarn@google.com" <bondarn@google.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"dionnaglaze@google.com" <dionnaglaze@google.com>
Subject: Re: [PATCH v5 1/5] x86/sgx: Introduce a counter to count the
 sgx_(vepc_)open()
Message-ID: <aCtqI_akUp2CYXIj@kernel.org>
References: <20250519072603.328429-1-elena.reshetova@intel.com>
 <20250519072603.328429-2-elena.reshetova@intel.com>
 <c955515c5469dae17faa13ebda28459d7c998bb9.camel@intel.com>
 <DM8PR11MB5750A29C0878480F6F19E39BE79CA@DM8PR11MB5750.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM8PR11MB5750A29C0878480F6F19E39BE79CA@DM8PR11MB5750.namprd11.prod.outlook.com>

On Mon, May 19, 2025 at 11:47:32AM +0000, Reshetova, Elena wrote:
> > On Mon, 2025-05-19 at 10:24 +0300, Elena Reshetova wrote:
> > > Currently SGX does not have a global counter to count the
> > > active users from userspace or hypervisor. Implement such a counter,
> > > sgx_usage_count. It will be used by the driver when attempting
> > > to call EUPDATESVN SGX instruction.
> > >
> > > Suggested-by: Sean Christopherson <seanjc@google.com>
> > > Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
> > > ---
> > >  arch/x86/kernel/cpu/sgx/driver.c |  1 +
> > >  arch/x86/kernel/cpu/sgx/encl.c   |  1 +
> > >  arch/x86/kernel/cpu/sgx/main.c   | 14 ++++++++++++++
> > >  arch/x86/kernel/cpu/sgx/sgx.h    |  3 +++
> > >  arch/x86/kernel/cpu/sgx/virt.c   |  2 ++
> > >  5 files changed, 21 insertions(+)
> > >
> > > diff --git a/arch/x86/kernel/cpu/sgx/driver.c
> > b/arch/x86/kernel/cpu/sgx/driver.c
> > > index 7f8d1e11dbee..b5ffe104af4c 100644
> > > --- a/arch/x86/kernel/cpu/sgx/driver.c
> > > +++ b/arch/x86/kernel/cpu/sgx/driver.c
> > > @@ -19,6 +19,7 @@ static int sgx_open(struct inode *inode, struct file *file)
> > >  	struct sgx_encl *encl;
> > >  	int ret;
> > >
> > > +	sgx_inc_usage_count();
> > 
> > This should be done at the end of sgx_open() where the open cannot fail,
> > since
> > sgx_release() is not called if sgx_open() failed AFAICT.
> 
> 
> Could you please elaborate a bit more on this? 
> In case sgx_inc_usage_count fails, we dont allocate resources yet, so what is 
> wrong? 

It's fine to do (or even perhaps advicable) to do right at the get go,
before doing anything else, because it is "keep alive counter". I.e.,
I think the call is at the right place.

And now there is a proper rollback procedure, as my previous review
comments have been adressed.

> 
> Best Regards,
> Elena.


BR, Jarkko
