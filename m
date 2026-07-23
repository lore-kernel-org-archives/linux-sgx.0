Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB954A13AE;
	Thu, 23 Jul 2026 13:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784811844; cv=none; b=ZvxVa3SX1JsQWetsxUmXUQpYQHIe+rKRhOGoYJ1VzlcuH3P7K07lfSxVy4caq8lHhh6qlnkJlZ6suxVFmO05GSXAxYApu0EjEbsuTLwTS6qArABcxmy1IhdhdrXDH7bPCEqoo49j8eSLx4FKpCNiByVlc3fSWzLWovheY5o0St8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784811844; c=relaxed/simple;
	bh=oTAnUBaUEzt4zyDa+niOSvLgNwqzWK3+m/VkQ2R/cvw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nat7Khpq3c0u7Mi0pl243ywBqAiwNdHGvHyxavy1t3F6P0VwG6UnU+oUpPwUoeys189uCPvvKeo0ola7Klk53GZVpcz230/fuW2KyP02eHaWWMCSR5T8V4kPBCZAHJw8zqhry5kOI9if78xbslWHEumbhLrAKXeBDyme3QIFCho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lnPF723r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lnPF723r"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id ED7751F000E9;
	Thu, 23 Jul 2026 13:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784811836;
	bh=/UNnUz4YwAKrVQ/InK94XJgfLNOw/9jcKEV9DpAiR8k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lnPF723r/cXVAeQnCQ9a3K2JYgnHUs3gByTpQqIxNL4cHWsAupOtdq41VAgAEyuFE
	 fp7t1GgVJRDV2PBwOTOArYsbZYTMm8I9Jl7SFt9ZyUfBROFwvlVt2QYYaTK6y9YPD3
	 x6RF/yG++XRuGEdjEVQL7Q7kfrHz+X9VZUOPEUTcxG+m5ceRh86xi6zDVXngVukR3S
	 J0FemnMozLdgQg6SIGG2EupPgkm5pTwsHmvy1Msto5t96j+CokeX6H7LiL68G9qcCK
	 JGTElj4jqL/y3xL/d7NqNwOFdcKTsFQfDz9buixKywyO+DWIupp6H4iRakPcDjhNBP
	 eaTPoT7+SJoQg==
Date: Thu, 23 Jul 2026 16:03:52 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: "Miao, Jun" <jun.miao@intel.com>
Cc: "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
	"Huang, Kai" <kai.huang@intel.com>,
	"linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>,
	"Du, Fan" <fan.du@intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"challvy.tee@gmail.com" <challvy.tee@gmail.com>
Subject: Re: [PATCH v5] x86/sgx: Report RCU-Tasks quiescent state in EPC
 sanitization loop
Message-ID: <amIROIRvs_bmaoh9@kernel.org>
References: <20260703084810.145567-1-jun.miao@intel.com>
 <ak-hG4mo57WiP616@kernel.org>
 <PH7PR11MB84559DCC54D746868A3424D39AC02@PH7PR11MB8455.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH7PR11MB84559DCC54D746868A3424D39AC02@PH7PR11MB8455.namprd11.prod.outlook.com>

On Thu, Jul 23, 2026 at 09:57:33AM +0000, Miao, Jun wrote:
> >You should probably also say why cond_resched() does not trigger
> >rescheduling. E.g., put that and delete the first sentence as it tells nothing
> >and is confusing.
> 
> Hi BR, Jarkko,
> 
> How about I place the explanation as a comment above the code at the v6 version ?
> See the description below.
> 
> Warm regards
> Jun Miao

Yeah, that is exactly kind of reminder that would make sense there.

> 
> >> --- a/arch/x86/kernel/cpu/sgx/main.c
> >> +++ b/arch/x86/kernel/cpu/sgx/main.c
> >> -		cond_resched();
> +               /*
> +                * cond_resched() only schedules when TIF_NEED_RESCHED is set.
> +                * During this boot-time loop that condition may not happen for a
> +                * long time, so report an RCU-Tasks quiescent state explicitly.
> +                */
> 
> >> +		cond_resched_tasks_rcu_qs();
> >>  	}
> >>
> >>  	list_splice(&dirty, dirty_page_list);
> >> --
> >> 2.32.0
> >>
> >
> >

BR, Jarkko
