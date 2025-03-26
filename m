Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E86D1F4736;
	Wed, 26 Mar 2025 20:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743019749; cv=none; b=nWbkbS574CN/rBqWEEamyM94LSh3SXX1QZwugGvJAcy7tZ7MZT5/R0YubCN6w+oJj4vf8olFoyTiMF4pS1032dUnZTM+qo6STeyukvw6SPZXuSeXK5hlZ9vHp76Bv0O+hb49C8eNujhvzo8wMXFMWkqP5UxQaiKws1Kt6UNGcYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743019749; c=relaxed/simple;
	bh=bc3DKkJ/3ho9CogsZhj5BhBJLmQCTRULVqyGxLmmRs8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I6E0o5k/YB3NBx59ht2k4UDmLxDJXXNCcEp8Y5yu6EVUk9XzXnNhuyZbTnjcyUIncxVl8BO8+A8iyMSlP12v2qYRCKqOu+WTnfKdA5msMuM8zRtPJK5NI2jspxTFuObUiJeV2SJ5nYxmYpZAZnSWXv0ig2/oUbsAFhpix31cNUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KTS0sTLn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KTS0sTLn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20AB1C4CEE2;
	Wed, 26 Mar 2025 20:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743019749;
	bh=bc3DKkJ/3ho9CogsZhj5BhBJLmQCTRULVqyGxLmmRs8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KTS0sTLnOS5ScYgfJtL6Uo3VKHyQd16srCfN7E/U7T47f3vEt3CaoUCiFIrh3QwmK
	 W5uTuGM4Ux6ctIrMc58SIxWEXAenmlPOXyTXzE+BpF5oFO9ljmOTPbAP6ZL//Rf/Ay
	 D3WHpcaCImc2/mPrbpsYrwlHAp8WrcpKopYRyENBbSNPy7sRgknL1Bs3AAWFkk0kj6
	 KX8hO2xFTTYdHjiYEhOrJp5jvCHaqlXchGFI7Bi5bx0xmd+kykeOF/Vj3g4nEnsKgL
	 HO8LdlbLbPll3opT4GUKY/OzUancYV2x3dBV0tW4DAe6tNRUeb6auoNkZfiOdOoxma
	 zdCSGbEtujSXQ==
Date: Wed, 26 Mar 2025 22:09:06 +0200
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
Subject: Re: [PATCH 3/4] x86/sgx: Define error codes for ENCLS[EUPDATESVN]
Message-ID: <Z-Re4gqcCh0GSvKC@kernel.org>
References: <20250321123938.802763-1-elena.reshetova@intel.com>
 <20250321123938.802763-4-elena.reshetova@intel.com>
 <Z98wDd_eMCFE40Z7@kernel.org>
 <DM8PR11MB575028B19C9C23E6EF31357FE7A42@DM8PR11MB5750.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM8PR11MB575028B19C9C23E6EF31357FE7A42@DM8PR11MB5750.namprd11.prod.outlook.com>

On Mon, Mar 24, 2025 at 12:21:14PM +0000, Reshetova, Elena wrote:
> 
> 
> > On Fri, Mar 21, 2025 at 02:34:42PM +0200, Elena Reshetova wrote:
> > > Add error codes for ENCLS[EUPDATESVN], then SGX CPUSVN update
> > > process can know the execution state of EUPDATESVN.
> > >
> > 
> > Enumerate the error codes. 
> 
> You mean in the commit message or? 

I'm not really sure how kernel uses them.

> 
> 
> > Do we need all of the three added?
> 
> Yes, we do. They are all valid error codes that can be received as a result of
> execution of EUPDATESVN. 
> 
> Best Regards,
> Elena.

BR, Jarkko
