Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 705AE1B1513;
	Thu, 29 Aug 2024 15:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724944692; cv=none; b=hKWyaErbyOSWtl/x21UuNFc8QCuT8wnQGaKyCHN0mhHfkBXNc4O+KWRUtF6jURk23Mekx2wamXyDiuNDkNnA5t8ukNHqsjk58tnuk28Biy8qTCUavQyw5yhDKV38lYO965WLqictwki3iisSGDZbImN8gNoNWAG53H8uTOPEZVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724944692; c=relaxed/simple;
	bh=ZHToJQgtxYpOzm/EEY6t44DYuFgoJT8DPD7E9uLr8eQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r0PITrvYapAWVvlfvSS9ZVN2HSGLWXhzWHtfmO4NKmoRAC34uP6YmgYc/e8w/954riJhX1ukE3+yYaOYfQFtg0Eyw6FZ/5ZbEK0xsGKzk+zJEAho4HlbWaLZtsi9jGwpnP8mUzGPW2KmLZ7hmigzJje5qNjobmFbx4RH+KJvCAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=V7N3GV+E; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="V7N3GV+E"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724944691; x=1756480691;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ZHToJQgtxYpOzm/EEY6t44DYuFgoJT8DPD7E9uLr8eQ=;
  b=V7N3GV+ELc5tpSC6oeO5r/gIz64y7J2aMfqTSSAwY9Q2vM30smjomi+K
   MMTcQgHc68qNnfvUmPwOBK6C7Ny/Dh+eXaEiC9iBcQsDzqU/b1O9py11S
   cxyFCQAaSoVa7rpVZ0eWlxkNp7hmo7NGRD63eiR4tQXSUu5gu77GR1Im5
   NP1mBn/0DIju5s0QyHb3lw3OL+em67j/1/pJvunpXE8DLDnNVUJeVhrha
   28SzweWfOTWsQqVI/w6YPc8wO8SW5HYoSqO/V2uBnFPtjqF7rxWxz4C+Y
   e85YWTYCG5nMGVnTz9Z+kZ0ov2KabYmiyg2245srlc0viad3n+ZTqVT6C
   A==;
X-CSE-ConnectionGUID: UsCEKvgVTnKqGSZB7kpFyw==
X-CSE-MsgGUID: Xv2ufnejQZaJhZEF4ySadg==
X-IronPort-AV: E=McAfee;i="6700,10204,11179"; a="41053122"
X-IronPort-AV: E=Sophos;i="6.10,185,1719903600"; 
   d="scan'208";a="41053122"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2024 08:18:10 -0700
X-CSE-ConnectionGUID: GhudT9hHSPW/RRNvBRcbkA==
X-CSE-MsgGUID: 8dwgPF14R46vsYE7nUuLuw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,185,1719903600"; 
   d="scan'208";a="94349706"
Received: from tfalcon-desk.amr.corp.intel.com (HELO [10.124.220.59]) ([10.124.220.59])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2024 08:18:10 -0700
Message-ID: <f2b0ffc7-f8f8-4ebc-99da-9139c372bd09@intel.com>
Date: Thu, 29 Aug 2024 08:17:53 -0700
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/sgx: Fix deadloop in __sgx_alloc_epc_page()
To: Aaron Lu <aaron.lu@intel.com>, Jarkko Sakkinen <jarkko@kernel.org>,
 Dave Hansen <dave.hansen@linux.intel.com>
Cc: x86@kernel.org, linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
 Zhimin Luo <zhimin.luo@intel.com>
References: <20240829023800.1671210-1-aaron.lu@intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <20240829023800.1671210-1-aaron.lu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Generally, I think it's a bad idea to refer to function names in
subjects.  This, for instance would be much more informative:

	x86/sgx: Fix deadlock in SGX NUMA node search

On 8/28/24 19:38, Aaron Lu wrote:
> When current node doesn't have a EPC section configured by firmware and
> all other EPC sections memory are used up, CPU can stuck inside the
> while loop in __sgx_alloc_epc_page() forever and soft lockup will happen.
> Note how nid_of_current will never equal to nid in that while loop because
> nid_of_current is not set in sgx_numa_mask.
> 
> Also worth mentioning is that it's perfectly fine for firmware to not
> seup an EPC section on a node. Setting an EPC section on each node can
> be good for performance but that's not a requirement functionality wise.

The changelog is a little rough, but I think Kai gave some good
suggestions.  The other thing you can do is dump the text in chatgpt (or
whatever) and have it fix your grammar.  It actually does a pretty
decent job.

Also, you didn't say _how_ you fixed this.  That needs to be in here.
Something along the lines of:

	Rework the loop to start and end on *a* node that has SGX
	memory.  This avoids the deadlock looking for the current SGX-
	lacking node to show up in the loop when it never will.

The code looks fine, so feel free to add:

Acked-by: Dave Hansen <dave.hansen@linux.intel.com>

Also, I do think we should probably add some kind of sanity warning to
the SGX code in another patch.  If a node on an SGX system has CPUs and
memory, it's very likely it will also have some EPC.  It can be
something soft like a pr_info(), but I think it would be nice to have.
