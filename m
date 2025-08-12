Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A390B305E2A;
	Tue, 12 Aug 2025 16:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755015542; cv=none; b=XObWUkroBX0mej2XQJgOCmDKuRHUGhqID2n5s2UdFbczkaOf/x/nowFmgYrmr08fcppsfWf3hC4HCktWYGV3K8Do8aX16Y/gz0n45wiNOThHdMxetkPCLGDtWW3YbhEVV9JYpOLuS3VZyhLIBQZe6aubj5CDU5T0IfuO/B8O8Jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755015542; c=relaxed/simple;
	bh=RnLFRGP8JhhduSMLjd9k2KVXS7ul+QAtGIz4AwwoBKQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L/88HOtd0CAsZGsLO1ESLMa0oZqKb2uwfw6pe/rV5uU9WlWjPw1rj2rLvNyHqXRlyORyS/Y2tOETOCZpV6BYB4hWg0QqE9CeR9b9onusRIONOFcB2Pf/nexzywH7Ai6z9BoDjlW+kxZasSc3uxXv82hVkAniW/amEPmkVaR1BQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AVJqixeS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AVJqixeS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F265C4CEF6;
	Tue, 12 Aug 2025 16:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755015542;
	bh=RnLFRGP8JhhduSMLjd9k2KVXS7ul+QAtGIz4AwwoBKQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AVJqixeS9abPEXnG3Dt9p3ZelZC0KqBtfdIlnYVaktoHEMpSZYbY4j7JtAhM64Tni
	 vnVVhqzR4kKek54/4fyZ4eybxvq695e5m7yVu4X+MSXvCWRd3LNPZPg7Ck3REqAMz+
	 d/9lkp7PsvE/ZQgtZ09RtehCJCjVlzkrCUgK09qVXH1zDELB69crV4btZz+fgPmMlM
	 mPhQyeadVcoJ96FxnFgArqyKlpEX08i9a8ezTL/rKSAMcI1Wrk70dTxOFkRsqonTb9
	 Z/heSBDJvG6t0sPN7A2gnKcf8xClA8TK4T/CFppmLBWRj6dsmF3hrHqtk+DQPlvSDH
	 Bnl0A+dqwj3zw==
Date: Tue, 12 Aug 2025 19:18:58 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: "Hansen, Dave" <dave.hansen@intel.com>,
	"seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>,
	"mingo@kernel.org" <mingo@kernel.org>,
	"linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>,
	"Mallick, Asit K" <asit.k.mallick@intel.com>,
	"Scarlata, Vincent R" <vincent.r.scarlata@intel.com>,
	"Cai, Chong" <chongc@google.com>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"Annapurve, Vishal" <vannapurve@google.com>,
	"Bondarevska, Nataliia" <bondarn@google.com>,
	"Raynor, Scott" <scott.raynor@intel.com>
Subject: Re: [PATCH v11 0/5] Enable automatic SVN updates for SGX enclaves
Message-ID: <aJtpcjlcgJFX7cKw@kernel.org>
References: <20250806081344.404004-1-elena.reshetova@intel.com>
 <aJci8Zt9iSb3LurZ@kernel.org>
 <DM8PR11MB5750EE0009D46F6CB44845BDE728A@DM8PR11MB5750.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM8PR11MB5750EE0009D46F6CB44845BDE728A@DM8PR11MB5750.namprd11.prod.outlook.com>

On Mon, Aug 11, 2025 at 07:21:15AM +0000, Reshetova, Elena wrote:
> > >
> > 
> > LGTM
> > 
> > Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
> > 
> > BR, Jarkko
> 
> Thank you very much for your review, Jarkko!

np :-)

BR, Jarkko
