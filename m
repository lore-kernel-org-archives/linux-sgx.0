Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 543AB26BDAB;
	Tue, 11 Feb 2025 16:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739291158; cv=none; b=AbTsKmawtDLixBBpznpWkLqkVySNXfXaEfpge4H/cklmGbEGjq+YSpPX7JwCXjhDLdna7IB4hIAQ4VykPxC0YCaUhECYHsYninFInTPTRDG7CV5e01ZhLfGp3RA0GfKlZ6caa6pU3qy8hpyPrljJi+f8eBRqpt41CsTqDd+j+ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739291158; c=relaxed/simple;
	bh=oBGUu9jQm6TIDxxkb/ycjYyMbUkFDjQ5vwic9RQo/QI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Un8FlwNM/NxbpGhRlkhk5jkTpNRUMoXdOGnz8js00zMkqkUcqR7Hc1vHrLLO3DHh1LSQn3daxV3yhxbM7Pm5IXn/kW5uWyCH5NSSahXtCKpxE+aIcQYK0/UF84rzobOuw/3EQ9baOSm+iwRifGt/BMBMVXRHfb81H6dQlFtyfJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IP9tetTL; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IP9tetTL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739291156; x=1770827156;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=oBGUu9jQm6TIDxxkb/ycjYyMbUkFDjQ5vwic9RQo/QI=;
  b=IP9tetTL8tDjdLvmBmmkV2lp6o+OY0uFphX0Upbcex1573PYEvdsBhN6
   dUgEfCRtDtcrM7ZlV3uafQ78HGa9cILmp4ybEMFjv+GGrPlvYIWvbstXA
   LfFaNOvpKive+qBYH8dtptj1OimM6qP9eByUJbTXSI7WPEX1ScGUs80un
   RahfvZKe6XU2tJTsjYK82riEWTnHZPIXYuCQapbza6aWD7y48yw5mCa2W
   aTQ7Rr/Dc6mloXYuZKaYWgaiHFwjPvwSso4LX2CLLPwJoRyKpLm8u6+q1
   sOTqldsl37Xc9hgStvW1Kgujt8/UyZcr73U0hCC4m5Bs6VLuZ3dHrIF2j
   w==;
X-CSE-ConnectionGUID: uAvwvx0BSBSn1vzl33m1DA==
X-CSE-MsgGUID: w4P1c4RRTrWFxmOh3BRNtQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11342"; a="43678270"
X-IronPort-AV: E=Sophos;i="6.13,278,1732608000"; 
   d="scan'208";a="43678270"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2025 08:25:56 -0800
X-CSE-ConnectionGUID: AS9HNS0jRNSb76EUgf+KUA==
X-CSE-MsgGUID: b7eRMtOcQjC+PAV2c+YTZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="149741400"
Received: from vverma7-desk1.amr.corp.intel.com (HELO [10.125.108.10]) ([10.125.108.10])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2025 08:25:55 -0800
Message-ID: <3bd497be-54d7-43b8-a392-4bf82bf64679@intel.com>
Date: Tue, 11 Feb 2025 08:25:58 -0800
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86: sgx: Don't track poisoned pages for reclaiming
To: Andrew Zaborowski <andrew.zaborowski@intel.com>, x86@kernel.org,
 linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Tony Luck
 <tony.luck@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
 Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
 "H . Peter Anvin" <hpa@zytor.com>, balrogg@gmail.com
References: <20250211150150.519006-1-andrew.zaborowski@intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 xsFNBE6HMP0BEADIMA3XYkQfF3dwHlj58Yjsc4E5y5G67cfbt8dvaUq2fx1lR0K9h1bOI6fC
 oAiUXvGAOxPDsB/P6UEOISPpLl5IuYsSwAeZGkdQ5g6m1xq7AlDJQZddhr/1DC/nMVa/2BoY
 2UnKuZuSBu7lgOE193+7Uks3416N2hTkyKUSNkduyoZ9F5twiBhxPJwPtn/wnch6n5RsoXsb
 ygOEDxLEsSk/7eyFycjE+btUtAWZtx+HseyaGfqkZK0Z9bT1lsaHecmB203xShwCPT49Blxz
 VOab8668QpaEOdLGhtvrVYVK7x4skyT3nGWcgDCl5/Vp3TWA4K+IofwvXzX2ON/Mj7aQwf5W
 iC+3nWC7q0uxKwwsddJ0Nu+dpA/UORQWa1NiAftEoSpk5+nUUi0WE+5DRm0H+TXKBWMGNCFn
 c6+EKg5zQaa8KqymHcOrSXNPmzJuXvDQ8uj2J8XuzCZfK4uy1+YdIr0yyEMI7mdh4KX50LO1
 pmowEqDh7dLShTOif/7UtQYrzYq9cPnjU2ZW4qd5Qz2joSGTG9eCXLz5PRe5SqHxv6ljk8mb
 ApNuY7bOXO/A7T2j5RwXIlcmssqIjBcxsRRoIbpCwWWGjkYjzYCjgsNFL6rt4OL11OUF37wL
 QcTl7fbCGv53KfKPdYD5hcbguLKi/aCccJK18ZwNjFhqr4MliQARAQABzUVEYXZpZCBDaHJp
 c3RvcGhlciBIYW5zZW4gKEludGVsIFdvcmsgQWRkcmVzcykgPGRhdmUuaGFuc2VuQGludGVs
 LmNvbT7CwXgEEwECACIFAlQ+9J0CGwMGCwkIBwMCBhUIAgkKCwQWAgMBAh4BAheAAAoJEGg1
 lTBwyZKwLZUP/0dnbhDc229u2u6WtK1s1cSd9WsflGXGagkR6liJ4um3XCfYWDHvIdkHYC1t
 MNcVHFBwmQkawxsYvgO8kXT3SaFZe4ISfB4K4CL2qp4JO+nJdlFUbZI7cz/Td9z8nHjMcWYF
 IQuTsWOLs/LBMTs+ANumibtw6UkiGVD3dfHJAOPNApjVr+M0P/lVmTeP8w0uVcd2syiaU5jB
 aht9CYATn+ytFGWZnBEEQFnqcibIaOrmoBLu2b3fKJEd8Jp7NHDSIdrvrMjYynmc6sZKUqH2
 I1qOevaa8jUg7wlLJAWGfIqnu85kkqrVOkbNbk4TPub7VOqA6qG5GCNEIv6ZY7HLYd/vAkVY
 E8Plzq/NwLAuOWxvGrOl7OPuwVeR4hBDfcrNb990MFPpjGgACzAZyjdmYoMu8j3/MAEW4P0z
 F5+EYJAOZ+z212y1pchNNauehORXgjrNKsZwxwKpPY9qb84E3O9KYpwfATsqOoQ6tTgr+1BR
 CCwP712H+E9U5HJ0iibN/CDZFVPL1bRerHziuwuQuvE0qWg0+0SChFe9oq0KAwEkVs6ZDMB2
 P16MieEEQ6StQRlvy2YBv80L1TMl3T90Bo1UUn6ARXEpcbFE0/aORH/jEXcRteb+vuik5UGY
 5TsyLYdPur3TXm7XDBdmmyQVJjnJKYK9AQxj95KlXLVO38lczsFNBFRjzmoBEACyAxbvUEhd
 GDGNg0JhDdezyTdN8C9BFsdxyTLnSH31NRiyp1QtuxvcqGZjb2trDVuCbIzRrgMZLVgo3upr
 MIOx1CXEgmn23Zhh0EpdVHM8IKx9Z7V0r+rrpRWFE8/wQZngKYVi49PGoZj50ZEifEJ5qn/H
 Nsp2+Y+bTUjDdgWMATg9DiFMyv8fvoqgNsNyrrZTnSgoLzdxr89FGHZCoSoAK8gfgFHuO54B
 lI8QOfPDG9WDPJ66HCodjTlBEr/Cwq6GruxS5i2Y33YVqxvFvDa1tUtl+iJ2SWKS9kCai2DR
 3BwVONJEYSDQaven/EHMlY1q8Vln3lGPsS11vSUK3QcNJjmrgYxH5KsVsf6PNRj9mp8Z1kIG
 qjRx08+nnyStWC0gZH6NrYyS9rpqH3j+hA2WcI7De51L4Rv9pFwzp161mvtc6eC/GxaiUGuH
 BNAVP0PY0fqvIC68p3rLIAW3f97uv4ce2RSQ7LbsPsimOeCo/5vgS6YQsj83E+AipPr09Caj
 0hloj+hFoqiticNpmsxdWKoOsV0PftcQvBCCYuhKbZV9s5hjt9qn8CE86A5g5KqDf83Fxqm/
 vXKgHNFHE5zgXGZnrmaf6resQzbvJHO0Fb0CcIohzrpPaL3YepcLDoCCgElGMGQjdCcSQ+Ci
 FCRl0Bvyj1YZUql+ZkptgGjikQARAQABwsFfBBgBAgAJBQJUY85qAhsMAAoJEGg1lTBwyZKw
 l4IQAIKHs/9po4spZDFyfDjunimEhVHqlUt7ggR1Hsl/tkvTSze8pI1P6dGp2XW6AnH1iayn
 yRcoyT0ZJ+Zmm4xAH1zqKjWplzqdb/dO28qk0bPso8+1oPO8oDhLm1+tY+cOvufXkBTm+whm
 +AyNTjaCRt6aSMnA/QHVGSJ8grrTJCoACVNhnXg/R0g90g8iV8Q+IBZyDkG0tBThaDdw1B2l
 asInUTeb9EiVfL/Zjdg5VWiF9LL7iS+9hTeVdR09vThQ/DhVbCNxVk+DtyBHsjOKifrVsYep
 WpRGBIAu3bK8eXtyvrw1igWTNs2wazJ71+0z2jMzbclKAyRHKU9JdN6Hkkgr2nPb561yjcB8
 sIq1pFXKyO+nKy6SZYxOvHxCcjk2fkw6UmPU6/j/nQlj2lfOAgNVKuDLothIxzi8pndB8Jju
 KktE5HJqUUMXePkAYIxEQ0mMc8Po7tuXdejgPMwgP7x65xtfEqI0RuzbUioFltsp1jUaRwQZ
 MTsCeQDdjpgHsj+P2ZDeEKCbma4m6Ez/YWs4+zDm1X8uZDkZcfQlD9NldbKDJEXLIjYWo1PH
 hYepSffIWPyvBMBTW2W5FRjJ4vLRrJSUoEfJuPQ3vW9Y73foyo/qFoURHO48AinGPZ7PC7TF
 vUaNOTjKedrqHkaOcqB185ahG2had0xnFsDPlx5y
In-Reply-To: <20250211150150.519006-1-andrew.zaborowski@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

I don't expect everyone to know the rules of every little part of the
kernel. But, it's really easy to see a pattern with:

	git log arch/x86/kernel/cpu/sgx/

That usually works for every little nook and cranny of the kernel and
will show you what the subject rules are.

Could you do that for this patch for v2, please?

Also, this isn't about _tracking_ pages per se. It's avoiding SGX page
reclaim, don't you think?

On 2/11/25 07:01, Andrew Zaborowski wrote:
> Pages used by an enclave only get page->poison set in

Could we please call these "epc_page" instead of "page"?

> arch_memory_failure() but stay on sgx_active_page_list.
> page->poison is not checked in the reclaimer logic meaning that a page could be
> reclaimed and go through ETRACK, EBLOCK and EWB.  This can lead to the
> firmware receiving and MCE in one of those operations and going into
> "unbreakable shutdown" and triggering a kernel panic on remaining cores.

This requires low-level SGX implementation knowledge to fully
understand. Both what "ETRACK, EBLOCK and EWB" are in the first place,
how they are involved in reclaim and also why EREMOVE doesn't lead to
the same fate.

Can it be written in a more approachable way?

During SGX reclaim, the CPU actually touches the SGX data page,
encrypting and writing its contents out to normal memory. These "EWB"
writeback operations are implemented in what are effectively big,
complicated chunks of microcode. Any machine checks encountered during
this writeback operation are usually fatal to the entire system.

If an epc_page has poison, reclaiming it is highly likely to bring the
whole system down. The SGX reclaim code does not currently check for poison.

--

> Remove the affected page from sgx_active_page_list but don't add it
> immediately to &node->sgx_poison_page_list to keep most of the current
> semantics.

What semantics are being kept? Are they important?

> Tested with CONFIG_PROVE_LOCKING as suggested by Tony Luck.

"I tested it with lockdep and it didn't blow up" is definitely better
than "I booted this and it didn't blow up" or not testing it at all.

But even better would be demonstrating in the changelog that the locking
rules were understood and respected in this patch.

> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index 671c26513..7076464d4 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -719,6 +719,8 @@ int arch_memory_failure(unsigned long pfn, int flags)
>  		goto out;
>  	}
>  
> +	sgx_unmark_page_reclaimable(page);
> +
>  	/*
>  	 * TBD: Add additional plumbing to enable pre-emptive
>  	 * action for asynchronous poison notification. Until

I'll 100% buy that this is the most expeditious fix.

But is it the _best_ one?

In the end, this patch has the semantics of avoiding SGX reclaim on
poisoned pages. Wouldn't it be most straightforward to implement that in
the SGX *reclaim* code?


