Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BC6C6A8D2;
	Mon, 14 Jul 2025 15:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752507475; cv=none; b=SJXMgq0Kjx1OT/gOg854iyqBvVQs+da1ilTJsCj7G6Uy5jpAKYzWIl/L2UNCd1XA79EXXKEUW1Me7ij6vPxgKNJ4L1tEiwin6vVzr3VZclmUSlgyHObghmh9VXa3Jr/cF5K6X3rd+p3qrD8dRCSQf/WWJnhtEz2F5QHMZo53Aec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752507475; c=relaxed/simple;
	bh=0K+u1Qy1DhY50hQkwewgkYfh4QzDBTaZCLEBQjOQcPw=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=Iz/2ouXX+wFh/hkfkEZE6bogp0K4hWtdQvyBxZ2FTHkcIOq5b9c5kuNp6WePpyi0q68Emrsxy5gJTRUYz9SGWzNtMHWwXWASz4YuLuXZo8CSA5y4TtH1uQj1yIZuy9EwGbTs5oLKUb11+tcLu39d+jfWPIjrVhRcHD4wN/DUsFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iHACN7UI; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iHACN7UI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752507474; x=1784043474;
  h=message-id:date:mime-version:subject:from:to:cc:
   references:in-reply-to:content-transfer-encoding;
  bh=0K+u1Qy1DhY50hQkwewgkYfh4QzDBTaZCLEBQjOQcPw=;
  b=iHACN7UI06MBTPhyM1NuqWMhMEycemiI0UazExBEztM0o9PnilPJnCmi
   sMZ6AkHAlC6TeN1GMUd41RtEl5qru3CUWoTYvK/yuTvnbsqg02HpbWDxl
   Vd9pIRql2Z+Xdiy41pEsWvMG3L4eloAh8j1iFWrDqZM4dhyuRBWVYMJGS
   eU8Wux06/tNFOGzBV/vKMrQIdACFUV4VWjuvtSzeZ5p5lyxb2yZceaVBD
   o9t0mxHvra2a3qU1yfU3kIHvnf6LMuBfjPqnEpWSNRjQeV/EV9girMPjq
   YMuUv5dd2v2m1K0EBjm7m4Tq15PcIBl++wPeYlrbhjY4mqvmhZuJIbrCX
   A==;
X-CSE-ConnectionGUID: 0WpNUkmYQ3esFwrmIzqdPg==
X-CSE-MsgGUID: usrBL9TBQICg0Y3o8Km67A==
X-IronPort-AV: E=McAfee;i="6800,10657,11491"; a="54831925"
X-IronPort-AV: E=Sophos;i="6.16,311,1744095600"; 
   d="scan'208";a="54831925"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2025 08:37:53 -0700
X-CSE-ConnectionGUID: MbG7zrlKTOu5SP974B/DCQ==
X-CSE-MsgGUID: ck7x8PG4Q2CG3rhGDHOP7A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,311,1744095600"; 
   d="scan'208";a="187947800"
Received: from dwesterg-mobl1.amr.corp.intel.com (HELO [10.125.111.82]) ([10.125.111.82])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2025 08:37:51 -0700
Message-ID: <c1421f42-4107-4a6a-80f3-c46d915b40a6@intel.com>
Date: Mon, 14 Jul 2025 08:37:50 -0700
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 5/5] x86/sgx: Enable automatic SVN updates for SGX
 enclaves
From: Dave Hansen <dave.hansen@intel.com>
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: "jarkko@kernel.org" <jarkko@kernel.org>,
 "seanjc@google.com" <seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>,
 "mingo@kernel.org" <mingo@kernel.org>,
 "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "x86@kernel.org" <x86@kernel.org>, "Mallick, Asit K"
 <asit.k.mallick@intel.com>,
 "Scarlata, Vincent R" <vincent.r.scarlata@intel.com>,
 "Cai, Chong" <chongc@google.com>, "Aktas, Erdem" <erdemaktas@google.com>,
 "Annapurve, Vishal" <vannapurve@google.com>,
 "dionnaglaze@google.com" <dionnaglaze@google.com>,
 "Bondarevska, Nataliia" <bondarn@google.com>,
 "Raynor, Scott" <scott.raynor@intel.com>
References: <20250711165212.1354943-1-elena.reshetova@intel.com>
 <20250711165212.1354943-6-elena.reshetova@intel.com>
 <461a33d3-f91a-4dd3-bb97-048670530b25@intel.com>
 <DM8PR11MB57503EC8DF105A7D7FF02303E754A@DM8PR11MB5750.namprd11.prod.outlook.com>
 <2cd81800-12ba-460e-ac28-4532d0be1ec9@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <2cd81800-12ba-460e-ac28-4532d0be1ec9@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/14/25 06:54, Dave Hansen wrote:
> On 7/14/25 00:35, Reshetova, Elena wrote:
>> I think you put it: this would require a spinlock in the fast path and
>> *in theory* if we are running many many concurrent enclaves can create 
>> contention
> FWIW, my mental model is that spinlocks that are held for short periods
> of time are pretty much the same cost as an atomic under contention.
> 
> If there are lots of users, the cost of moving the cacheline for the
> atomic or the spinlock dominates everything else. It doesn't matter
> whether that cacheline is an atomic_t or spinlock_t.
> 
> The only difference is that there is _visible_ spinning for a spinlock.

Oh, and I had a brain fart on this one. You've got a mutex, not a spinlock.

But the concept still applies: for small critical sections, the cost of
moving the cacheline dominates the cost of everything else, no matter if
it's a mutex, spinlock or atomic.

Never add complexity unless you're getting actual, real-world
performance out of it. In this case, the only thing you'd _maybe_
improve with added complexity is an open()/close() loop on /dev/sgx,
which is completely unrealistic.
