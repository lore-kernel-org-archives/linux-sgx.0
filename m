Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AEC420B80B;
	Thu, 15 May 2025 15:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747323479; cv=none; b=oyQmq4s95koK5pQGCcYpaXASlZgEBlABeYIFYDN3QX+S/0negza+jAejazIf+BcwLBjitLc/p5FWhfuq8/CMTy+YXgZZNM949j43qoz8vE/d8HVCfq9om7yadsdFpdSXhNbF0ssW2OlL9kGcHE0uJWABvZ7DkR5BO2o2DK0b2Eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747323479; c=relaxed/simple;
	bh=dSkCpg/z3AQ4gx2+ruT4iP+42ZujybsMW+0OdzI72JU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Grv/RqXPl5GAtlzVJuObnMUrQ4e8+uTd6kic5bBfbdhHgsA68Rw1fq8w6+5/NC/JV92EgRtq5/rx11BKwLzMxtfBV+g+9ybkNS+1tWyGsSw9cfyg7xkSVStxWENBXIToE5Ctrx4nKEclENOz0VDHnyqhYYagFlGERNWn8YohsyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dfywr1O4; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dfywr1O4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747323478; x=1778859478;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=dSkCpg/z3AQ4gx2+ruT4iP+42ZujybsMW+0OdzI72JU=;
  b=dfywr1O499dJ9ofLOEgiZxexhYi4rH30sc6QtthvE8euaxbXbXGpFf0K
   N+8wx2AcFmMsYJ+fFsacjFZRaiMqVx5ZPCAe1hobG3JK2YrDBT6G2y4m8
   /PtRpL/9M+dJyn7zJ1D6k0M/hHyDj7vYJrIVFrQWtbUPFH33mBRk9hTof
   WaSaIKNo0HbWhfvOU12memaaXSlvyKhWUD9O75XR6GnalTOjPoZra74NT
   UzdD+niWJ/rnwymxV1c8LDeKxtIufSUnyaOcE0cbiXFW3IJq1Qs8jKpBe
   +PbqSIaBUsylppTgqOwbxxOLflrP396KFaQYpv1G+8L3LUrxZkBvX8U5t
   A==;
X-CSE-ConnectionGUID: 6fUz27HYSaKKWLGjvBDofg==
X-CSE-MsgGUID: i7Ex4NIiRZmMrW1qtVRF6g==
X-IronPort-AV: E=McAfee;i="6700,10204,11434"; a="49253742"
X-IronPort-AV: E=Sophos;i="6.15,291,1739865600"; 
   d="scan'208";a="49253742"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2025 08:37:57 -0700
X-CSE-ConnectionGUID: FpAD40fMT12afszuGd6diQ==
X-CSE-MsgGUID: zJTpBJ9aRGG8bfMvutHl1Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,291,1739865600"; 
   d="scan'208";a="161697886"
Received: from vverma7-desk1.amr.corp.intel.com (HELO [10.125.109.45]) ([10.125.109.45])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2025 08:37:56 -0700
Message-ID: <e2b65d4d-0d82-470d-9d9d-09ebc77621f7@intel.com>
Date: Thu, 15 May 2025 08:37:53 -0700
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
 <21752778-b6c8-42aa-8be6-db93a30a570c@intel.com>
 <DM8PR11MB5750FA8798AF68845D81717FE797A@DM8PR11MB5750.namprd11.prod.outlook.com>
 <DM8PR11MB5750202F36E2AA2443FB5762E791A@DM8PR11MB5750.namprd11.prod.outlook.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <DM8PR11MB5750202F36E2AA2443FB5762E791A@DM8PR11MB5750.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/14/25 00:32, Reshetova, Elena wrote:
>> This was the recent discussion I am aware we had on this matter:
>> https://lkml.org/lkml/2024/2/5/1595
>> The measurements were done for older platform (skylake), but I am not
>> aware of any architectural changes since that time to improve this.
> And to make it more concrete, I made some simple tests based
> on program for stress testing rdrand/rdseed that was discussed in that
> threat earlier: https://lkml.org/lkml/2024/2/6/746 
> Using this stress testing and enough threads, I can make EUPDATESVN fail
> reliably and quite easily even with 10 time retry loop by kernel. So,
> given this, what should be the correct behaviour be here? WARN_ON
> is not justified imo. But should we return an error to userspace and
> block open()? 

No, we can't block open. Just silently fail the EUPDATESVN for now.

We can have a separate bikeshedding session about how to warn about the
failure (or not).

I can also hear Sean screaming from across the room that silent failure
is going to be really nasty to debug. Once we settle on this set, we can
have another discussion on an explicit update ABI so that folks who
truly control their environment can stop all the guests and explicitly
run EUPDATESVN at a nice convenient time. *THAT* interface can punt
retries out to userspace and warn for sure.

But, one thing at a time, please. This set will cover *normal* users:
those who don't know exactly where each SGX user is and what their
lifetimes are. Oh, and normal users also aren't under RDSEED attacks.
