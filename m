Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36A352AE90;
	Thu,  8 May 2025 15:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746719146; cv=none; b=MrDvpUzvzGCp0euAF1XLLQqeL2uCf7T8mX4X2O2cjA1hke+vOW/DVO2lVSFP6L047JRTN66wlqeG1i2Qa0o2zDhL1P7SLW8Km4rDKumwVYEzlZR1RLnbhZkjkna3uBKJ6wmcrb6BQ0bFWE/y/1T+YHPGdl3gXLL++bWQPnk4188=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746719146; c=relaxed/simple;
	bh=4/xAAucO399OMDbuDtobmbBeZtiw3MEPUpXKrbgfXv4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Pb5pjO+iKk6fIPFWGxkPhRYHFiqyEKD+gcHZi7aUWYMHTqcphzHhm+2iyV+mCt0TnxjBvZU+R1syoEuIr77FmcuJDVXO86TmLrgx7ruRvfvMEL4CVA072+FgRPxAcepNCmFrsLZ5g3tj5tJhZWoLPwgXWFPD2Tlu6M9OuwQPQnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SPFRW0NC; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SPFRW0NC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746719144; x=1778255144;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=4/xAAucO399OMDbuDtobmbBeZtiw3MEPUpXKrbgfXv4=;
  b=SPFRW0NC3eWvXpuii/45Ex+uphpctMMeTcczDTIb/pAM+XJ2h7hVjrQq
   ZP7Sqk7ChV8w6ybjnvT8EVJub7PYACP5sOLT4fcY9XVcSjN06bN32SCth
   lDyqaXN4EPOLBKS5hTezY5mbGqU0BQjgrQWpRaKtl55DM0j7OGPf+1qvf
   iyMlUsxNm5dDbBUvSROd5wKwYrGOOZ+Osusmb5+cGZznE9YeqHqJBCXwp
   TKHoyWhSeW7DXF/E1yEBOVvUKbJXdFamlavK6QVsghrXKz4TA6B1Mpeqc
   5y8dc6fpJXHQIlIPSeRXHz2E3c+aOBRzAGuw66IfQMtcrDhTOUxSeGIGB
   w==;
X-CSE-ConnectionGUID: aovHzt/0QN+QIZBZY03nkg==
X-CSE-MsgGUID: KgtOO9AJTF64QjdampIfEA==
X-IronPort-AV: E=McAfee;i="6700,10204,11427"; a="48421852"
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="48421852"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:45:43 -0700
X-CSE-ConnectionGUID: XaJ07bE+QVCYQdChYWjkgg==
X-CSE-MsgGUID: u9toyS7PR/+WAG6Q5XF0Qw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,272,1739865600"; 
   d="scan'208";a="137264981"
Received: from iweiny-desk3.amr.corp.intel.com (HELO [10.124.222.250]) ([10.124.222.250])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2025 08:45:42 -0700
Message-ID: <21752778-b6c8-42aa-8be6-db93a30a570c@intel.com>
Date: Thu, 8 May 2025 08:45:39 -0700
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/1] x86/sgx: Enable automatic SVN updates for SGX
 enclaves
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: "jarkko@kernel.org" <jarkko@kernel.org>,
 "seanjc@google.com" <seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>,
 "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "x86@kernel.org" <x86@kernel.org>, "Mallick, Asit K"
 <asit.k.mallick@intel.com>,
 "Scarlata, Vincent R" <vincent.r.scarlata@intel.com>,
 "Cai, Chong" <chongc@google.com>, "Aktas, Erdem" <erdemaktas@google.com>,
 "Annapurve, Vishal" <vannapurve@google.com>,
 "dionnaglaze@google.com" <dionnaglaze@google.com>,
 "bondarn@google.com" <bondarn@google.com>,
 "Raynor, Scott" <scott.raynor@intel.com>
References: <20250507111542.709858-1-elena.reshetova@intel.com>
 <20250507111542.709858-2-elena.reshetova@intel.com>
 <023ab74f-82b7-41fc-ab20-0c0089f1f348@intel.com>
 <DM8PR11MB5750FBF44109B8CAD5574922E78BA@DM8PR11MB5750.namprd11.prod.outlook.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <DM8PR11MB5750FBF44109B8CAD5574922E78BA@DM8PR11MB5750.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 5/8/25 07:07, Reshetova, Elena wrote:
...
>> Actually, I think I wrote changelogs for this once upon a time. Could
>> you please go dig those up and use them?
> 
> Could you please suggest where can I find them? Was it for the previous
> submission done by Cathy? 

Yes. There were also some long discussions on an Intel internal mailing
list. I'll send you the details.

>>> https://cdrdv2.intel.com/v1/dl/getContent/648682?explicitVersion=true
>>
>> These become stale almost immediately. Please also cite the document title.
> 
> Sure, I can add the title, but I dont have another link. 

Right, Intel doesn't provide long-term stable links. Also, the
"explicitVersion" should be able to be removed.

>> Gah, how did this get squished back down to a single patch? It was
>> multiple patches before. There are multiple logical things going on here
>> and they need to be broken out.
> 
> Yes, but the code actually did get smaller, so it didn’t feel
> like it is worth breaking this into different patches. 
> But I will follow your suggestion.

It's not really about the size. It's about making it as reviewable as
possible and minimizing the time a reviewer needs to spend on it. Even
for small things.

>>> +static bool sgx_has_eupdatesvn;
>>
>> We have CPUID "caches" of sorts. Why open code this?
> 
> You mean X86_FEATURE_*? 

Yes.

> SGX CPUID is only defined in SGX code currently (btw, I am not sure
> why they are made special) so it doesn’t support this.

It's only used in SGX code and each subleaf is only used once, at init
time. There's really no reason to add any caching of any parts of it for
a single init-time use.

> Is this a past decision that you want to change? 

*This* patch changes things. It moves the one user from a single
init-time use to a runtime user. It adds a global variable. It's not
about *me* wanting change. It's about this patch changing the status quo.

I don't really care about the #define. That's not the question. The
question is whether we want the a scattered X86_FEATURE bit for
'sgx_has_eupdatesvn' or not.

>>> +static atomic_t sgx_usage_count;
>>
>> Is 32 bits enough for sgx_usage_count? What goes boom when it overflows?
> 
> I can increase the value easily, but even with current number we are talking
> about 2^32 enclaves, i dont think this is realistic to happen in practice. 

I don't mean to be pedantic, but is it 2^32? I thought we had signed
ints underneath atomic_t and we allow negative atomic_t values. Are you
suggesting that since we're just using a counter that the overflows into
the negative space are OK and it doesn't matter until it wraps all the
way back around to 0?

Assuming that you actually mean 2^32... It is it about 2^32 enclaves? Or
2^32 *opens*? Those are very, very different things.

Also, this is kinda the second question that I asked that hasn't really
been answered directly. I really asked it for a good reason, and I'd
really prefer that it be answered, even if you disagree with the premise.

I really want to know what goes boom when it overflows, so I'll go into
detail why it matters.

If it's just that an extra EUPDATESVN gets run and some random SGX user
might see a random #GP, that's not so bad. But if it's kernel crash or
use-after-free, that _is_ bad.

Is 4 bytes (maybe even 0 with the alignment of other things in practice)
worth it to take the problem from "not realistic" to "utterly  impossible".

sizeof(struct file) == 240, so I guess it would take almost 1TB of
'struct file' to overflow the counter, plus the overhead of 2^32 'struct
sgx_encl's. I'd call that "stupid" but not impossible on a bit modern
machine.

But with a atomic64_t, you literally can't overflow it with 'struct
file' in a 64-bit address space because the address space fills up
before the counter overflows. It's in "utterly impossible" territory.

I'll admit, I was rushing through the review and didn't spell all of
that out my first pass around. Yeah, it's a little bit overkill to
explain this for the type of one variable. But, I'm hoping that with all
of that logic laid out, you will consider answering my question this time.

I'd also very much appreciate if you could directly answer my questions
in future reviews, even if they appear silly. It'll make this all go faster.

...
>> 	if (ret == SGX_NO_UPDATE)
>> 		return 0;
>>
>> 	if (ret) {
>> 		ENCLS_WARN(ret, "EUPDATESVN");
>> 		return ret;
>> 	}
>>
>> 	pr_info("SVN updated successfully\n");
>> 	return 0;
>>
>> Oh, and do we expect SGX_INSUFFICIENT_ENTROPY all the time? I thought it
>> was supposed to be horribly rare. Shouldn't we warn on it?
> 
> The entropy comes from RDSEED in this case, not RDRAND.
> This is not a horribly rare but very realistic failure. 

Fair enough. If you want to keep it this way, could you run an
experiment and see how realistic it is? Surely, if it's very realistic,
you should be able to show it on real hardware quite easily.

We had a loooooooong discussion about this not so long ago. I believe
older CPUs were much more likely to be able to observe RDSEED failures.
But, even on those CPUs, repeated failures were pretty darn rare. New
CPUs are less likely to observe a single RDSEED failures. They are very
unlikely to see repeated failures.

So really want to know if this is needed in _practice_. Sure,
theoretically, the architecture allows CPUs to fail RDSEED all the time.
But do the CPUs with EUPDATESVN also have RDSEED implementations that
fail easily?
