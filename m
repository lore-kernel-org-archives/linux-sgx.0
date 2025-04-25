Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DD1922A4CD;
	Fri, 25 Apr 2025 22:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745618825; cv=none; b=unAGUVEjhDz09d9tjRmn3VSyEUZmIahmj+mTQbrkoRFZrANHaSstPTFZtl2Kw/WY2fIcm80/K3inmXz9rLdfZfXbba97x7tGkoSBfWRacdvq3t8nmueG7FUdymTpnzFlIT9hB//PUyiovn16ecHa/N81gr3tOTcpNXoKS+knbbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745618825; c=relaxed/simple;
	bh=IRNryOau6mozjdCIDY9S41wl6xXJPgmFwujTP95gBeM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aPLKMNCqPeXz4xIzlLboggi91oo8O1Wzwn0buXtIggwhbVd1GxV3Qou65vd/UYF821VDL9WBLSYdSW0MUrOakfAiRT7gcUCeZs5/5K+UYl8CN8Pyh55BKqoprCDZ/+W3WCce+qgoMg1ga0IQYt0YPFzJscXC1Pn8QJmPe5ax7JQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OTuGjEgx; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OTuGjEgx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745618823; x=1777154823;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=IRNryOau6mozjdCIDY9S41wl6xXJPgmFwujTP95gBeM=;
  b=OTuGjEgxfg1SwSakOXGFnFvu5NPuiXu0ypvJENNvM1hpNeo+yAcjqsG2
   4nJjOoHnvrUG9W/JFbodvCmn96hvbpCxVisaI5Fh+cCgRZV8S03BUFndG
   CaqfY/bxUZW/Rt6bWpIJsJFc0ZNQXcCHfxsDPPfBjI5fyddqu6qRxouTU
   tNbodr2YgMSG7ep57jmLyML0roXNrkJVfZAKjQLfQs98w9CduOmZ/IDZy
   iBJGheZ6LgR0qXNdYSVRFqQwOV3lqQZON7mFSfcGLgMdNmRsKnL45gemb
   /jBGFz/G/drAo3/78rGE83h9rfFHuCtoHY0v0lCR2FWsbfa45hNt0FM8R
   w==;
X-CSE-ConnectionGUID: nrJCbXX4QFOenUOjNX8E6g==
X-CSE-MsgGUID: +XjR805IS8GYz+B5dW5gzQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11414"; a="64819125"
X-IronPort-AV: E=Sophos;i="6.15,240,1739865600"; 
   d="scan'208";a="64819125"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2025 15:07:02 -0700
X-CSE-ConnectionGUID: nLXX5gdUTGKCxvrgnbBHOA==
X-CSE-MsgGUID: cZrf9MoISYGORnIlKvEWJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,240,1739865600"; 
   d="scan'208";a="133946281"
Received: from uaeoff-desk2.amr.corp.intel.com (HELO [10.124.222.49]) ([10.124.222.49])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2025 15:07:02 -0700
Message-ID: <4b4ecaa1-2ace-43bf-b71b-0de78bcf113c@intel.com>
Date: Fri, 25 Apr 2025 15:07:00 -0700
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] x86/sgx: Implement EUPDATESVN and
 opportunistically call it during first EPC page alloc
To: Sean Christopherson <seanjc@google.com>
Cc: Elena Reshetova <elena.reshetova@intel.com>,
 "jarkko@kernel.org" <jarkko@kernel.org>, Kai Huang <kai.huang@intel.com>,
 "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
 Vincent Scarlata <vincent.r.scarlata@intel.com>,
 "x86@kernel.org" <x86@kernel.org>, Vishal Annapurve <vannapurve@google.com>,
 Chong Cai <chongc@google.com>, Asit K Mallick <asit.k.mallick@intel.com>,
 Erdem Aktas <erdemaktas@google.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "bondarn@google.com" <bondarn@google.com>,
 "dionnaglaze@google.com" <dionnaglaze@google.com>,
 Scott Raynor <scott.raynor@intel.com>
References: <aAo_2MPGOkOciNuM@google.com>
 <DM8PR11MB5750D373790399E324B98A18E7852@DM8PR11MB5750.namprd11.prod.outlook.com>
 <aApgOqHvsYNd-yht@google.com>
 <DM8PR11MB5750AB0E790096AFF9AFD3AFE7842@DM8PR11MB5750.namprd11.prod.outlook.com>
 <aAutUaQvgEliXPUs@google.com>
 <0d7d6b9a-e7bd-4225-8f08-05bd9473a894@intel.com>
 <aAviqeAdGn-w1GpK@google.com>
 <fbd2acdb-35dc-4e8c-9bd9-e84264f88648@intel.com>
 <aAv445Sr71NUJP1X@google.com>
 <db1fd062-5a66-4942-82e2-c889dd645a7b@intel.com>
 <aAwFhaqQDLXoqbmv@google.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <aAwFhaqQDLXoqbmv@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/25/25 14:58, Sean Christopherson wrote:
> On Fri, Apr 25, 2025, Dave Hansen wrote:
>> On 4/25/25 14:04, Sean Christopherson wrote:
>>> Userspace is going to be waiting on ->release() no matter what.
>> Unless it isn't even involved and it happens automatically.
> With my Google hat on: no thanks.

I'm completely open to the idea of adding transparency so that folks can
tell when the SVN increments. I'm mostly open to having a new ABI to do
it explicitly in addition to doing it implicitly.]

> Coupled with adding latency to launching the 0=>1 enclave, just to
> handle something that happens a few times per year, and I don't see
> any value in automatic updates. Maybe it sounds nice on paper, but
> from my perspective, I see nothing but pain.
I'm not worried about the latency until I see numbers. If the number
show it's horrible, then we either change course or go yell at the folks
who wrote the xucode.
