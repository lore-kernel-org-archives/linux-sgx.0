Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FEC122B8B3;
	Fri,  2 May 2025 08:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746176173; cv=none; b=grTVuAtHuFkE7aEwaDS4nTMFE9j2Rq13E+Dn4ht5dL3mg472a8YXDQ6bUBQ5As5ZJ7sg+Iwtge3o3G2a9hYDuViW9E8/n8utbtomWIqhYKcc2yVt1VIxcuk4K1qD7OskPpe6CgLvUbEsRJkPB9wFIJyaT6TyFdBDHJXkj/P0E+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746176173; c=relaxed/simple;
	bh=wQFkIFNd8bVErhENe5IAWP9Gau5cLQS57Nc1PotMGEY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gG8dZPEGnBPW8jYrAviyeY6JbTo8HhhIk1pMKWu/KtB/iqegDYIyBfJjyvzrCafBz3kH7KJv8/Fs7Gtu0wyG5yuyrzueUIH5ZdVfM4Glk5yTtKoZUii7MYr0g7JGr5oOK9VmLKL8xyk6k7L+kZ7N+9BcDbCZtSkR38lM653HCiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IVDKu8DQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IVDKu8DQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 830ADC4CEE4;
	Fri,  2 May 2025 08:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746176172;
	bh=wQFkIFNd8bVErhENe5IAWP9Gau5cLQS57Nc1PotMGEY=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=IVDKu8DQdxR8q9n5lZqTV4JO221s6XB2FQh7GdBIofKUieS2tkgJEXRABP6uSwg5W
	 djn5m37F07sWBUkXm9oU73kXt/zlu6NfgMDMPn3iL74t7FOwqguzVSIRwk29A0XZmQ
	 9/VxZ6D84ZeAQiDPzMZfPJYYnuLq5y8V03rrL8lRQDR4jSg15ZbFupcffmFLEdIBJN
	 ITZrGtzxn6FU7K49RFTqC3Fmb/vUT3AW/T7kAuQCQEtCsjFzMkjk9+7GpmqAeRCyIR
	 WhkdExO9AT1AmbdaoElyx2G5C6Mfjcn0LOELuNIMFxxSerGVD4jT1MidmZBWXqfoJU
	 V/2Jic9hz1xgQ==
Message-ID: <d16ecae1c1b4b6f06565dfe9c47849dcaeb0782c.camel@kernel.org>
Subject: Re: [PATCH v3 2/2] x86/sgx: Implement EUPDATESVN and
 opportunistically call it during first EPC page alloc
From: Jarkko Sakkinen <jarkko@kernel.org>
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: "Hansen, Dave" <dave.hansen@intel.com>, Sean Christopherson
 <seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>, 
 "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>, "Scarlata, Vincent
 R" <vincent.r.scarlata@intel.com>, "x86@kernel.org" <x86@kernel.org>, 
 "Annapurve, Vishal" <vannapurve@google.com>, "Cai, Chong"
 <chongc@google.com>, "Mallick, Asit K" <asit.k.mallick@intel.com>,  "Aktas,
 Erdem" <erdemaktas@google.com>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>,  "bondarn@google.com" <bondarn@google.com>,
 "dionnaglaze@google.com" <dionnaglaze@google.com>,  "Raynor, Scott"
 <scott.raynor@intel.com>
Date: Fri, 02 May 2025 11:56:09 +0300
In-Reply-To: <DM8PR11MB575014811E4007EA00F5B3E6E78D2@DM8PR11MB5750.namprd11.prod.outlook.com>
References: <0d7d6b9a-e7bd-4225-8f08-05bd9473a894@intel.com>
	 <aAviqeAdGn-w1GpK@google.com>
	 <fbd2acdb-35dc-4e8c-9bd9-e84264f88648@intel.com>
	 <aAv445Sr71NUJP1X@google.com>
	 <db1fd062-5a66-4942-82e2-c889dd645a7b@intel.com>
	 <aAwFhaqQDLXoqbmv@google.com>
	 <4b4ecaa1-2ace-43bf-b71b-0de78bcf113c@intel.com>
	 <DM8PR11MB5750B39557F5062038D0E551E7802@DM8PR11MB5750.namprd11.prod.outlook.com>
	 <8db47bc1-445b-49db-b932-96aff0eb58a9@intel.com>
	 <DM8PR11MB5750200DFF8CF40E3539B688E7832@DM8PR11MB5750.namprd11.prod.outlook.com>
	 <aBI-xQzatja2Y9dh@kernel.org>
	 <DM8PR11MB575014811E4007EA00F5B3E6E78D2@DM8PR11MB5750.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4-2 
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2025-05-02 at 07:22 +0000, Reshetova, Elena wrote:
>=20
> >=20
> > On Wed, Apr 30, 2025 at 06:53:32AM +0000, Reshetova, Elena wrote:
> > > 2. Switch to Sean's approach to execute EUPDATESVN during the
> > sgx_open().
> > > Btw, Sean do you agree that we don't gain much doing it second
> > > time during
> > > release() given the microcode flow?
> > > I would rather leave only one invocation of eupdatesvn during
> > sgx_inc_usage_count().
> > >=20
> > > Proc: No new uABI. More predictable on svn change compared to
> > > option 1.
> >=20
> > > Cons: Two explicit paths to hook: sgx_open() and sgx_vepc_open().
> >=20
> > Why this is a con?
>=20
> Well, just from the pov of not having a single path to enable.=20
> Are you ok with option 2?=20
>=20

Yep, as SGX is anyway very much run-time managed feature and these
hooks fit better on how it is used.

> Best Regards,
> Elena.

BR, Jarkko

