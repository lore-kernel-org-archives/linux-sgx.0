Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27E11D799D;
	Fri,  1 Aug 2025 16:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754067443; cv=none; b=V80jRbwCFkKuM+PjAaAi8SsYzUBoU/ytQPlEaytL3FNECi/EfsyB0dAk4S7YLA5xAkib4uKqDY5zIfmZS16tu0zDs6C0TxN6QS2u9YDlYzcmyQmrI3E+lYo2QOjqhuXYgEVAkm/ZCcBr6UEd7GhOioWKjsr+Wn5NiuyI+lrbPQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754067443; c=relaxed/simple;
	bh=gWrECkBQba7Mb51irv5Aubf/6htm69Ajn4uQkfCbS/c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JuwggjEzB8z6TQwF0+pChc9oFhmcJwz3WiwPNqb16RwD7HkGSyapyDhnKAkeyEfug7j9qy70d3Vn3mpTO1o/stXiVGnBEz/6/XthXvBvfoB/9RlJ9z4NUA4XjxGTSY3desYgdWZRF6TTVYt0/uKLRulFQGb7R0CWTJ8ZJOH5zxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OARbWuqN; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OARbWuqN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754067442; x=1785603442;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=gWrECkBQba7Mb51irv5Aubf/6htm69Ajn4uQkfCbS/c=;
  b=OARbWuqN2tSufbHhlokTwXTqjz+1hCj6dkkdGtwZf80cK50en0fByJwD
   MHRvcE0QCnMKoQ44wQEf8LtVBDdGqDgrb9ySqwvxAuxJKfbc3c54gtCrH
   9B4IQCXFm3HAL8OMGXSAsC8TCaHHQiPLdKfVMv/KByuNKrEeqVmBRpOgK
   HQH+wLcJRxJHyAzvvbhjSNyXo/A/f50kDPSMAcXqseJA0XxvsE+IQZ/pj
   0aGBQUW772WdRAbJ6Ygv/5wi1NrDhoPP/7Pfi7WikdSGjOaC2bz+Cz0tq
   UK1jQXSUqd1Oetilbfj3X870Aa133R4iaD9174/J4DeCYbcHM56FPD97h
   A==;
X-CSE-ConnectionGUID: Fa1LGqgjRc6iQM/koHe1mQ==
X-CSE-MsgGUID: MCDNQMBMQZi+Z3NZgAvYDQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11508"; a="67494526"
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="67494526"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2025 09:57:19 -0700
X-CSE-ConnectionGUID: wRLR/fXXTf6Mbb+XYpi/kQ==
X-CSE-MsgGUID: KX9mFKKaTUKS6W7PWE907g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,255,1747724400"; 
   d="scan'208";a="163986187"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO [10.125.109.249]) ([10.125.109.249])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2025 09:57:19 -0700
Message-ID: <80006246-d0c5-475d-a8c7-bdb5446d9489@intel.com>
Date: Fri, 1 Aug 2025 09:57:18 -0700
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 4/6] x86/sgx: Define error codes for use by
 ENCLS[EUPDATESVN]
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: jarkko@kernel.org, seanjc@google.com, kai.huang@intel.com,
 mingo@kernel.org, linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
 x86@kernel.org, asit.k.mallick@intel.com, vincent.r.scarlata@intel.com,
 chongc@google.com, erdemaktas@google.com, vannapurve@google.com,
 bondarn@google.com, scott.raynor@intel.com
References: <20250801112619.1117549-1-elena.reshetova@intel.com>
 <20250801112619.1117549-5-elena.reshetova@intel.com>
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
In-Reply-To: <20250801112619.1117549-5-elena.reshetova@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/1/25 04:25, Elena Reshetova wrote:
> Add error codes for ENCLS[EUPDATESVN], then SGX CPUSVN update
> process can know the execution state of EUPDATESVN and notify
> userspace.
> 
> Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
> ---
>  arch/x86/include/asm/sgx.h | 37 ++++++++++++++++++++++---------------
>  1 file changed, 22 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
> index 6a0069761508..1abf1461fab6 100644
> --- a/arch/x86/include/asm/sgx.h
> +++ b/arch/x86/include/asm/sgx.h
> @@ -28,21 +28,22 @@
>  #define SGX_CPUID_EPC_MASK	GENMASK(3, 0)
>  
>  enum sgx_encls_function {
> -	ECREATE	= 0x00,
> -	EADD	= 0x01,
> -	EINIT	= 0x02,
> -	EREMOVE	= 0x03,
> -	EDGBRD	= 0x04,
> -	EDGBWR	= 0x05,
> -	EEXTEND	= 0x06,
> -	ELDU	= 0x08,
> -	EBLOCK	= 0x09,
> -	EPA	= 0x0A,
> -	EWB	= 0x0B,
> -	ETRACK	= 0x0C,
> -	EAUG	= 0x0D,
> -	EMODPR	= 0x0E,
> -	EMODT	= 0x0F,
> +	ECREATE		= 0x00,
> +	EADD		= 0x01,
> +	EINIT		= 0x02,
> +	EREMOVE		= 0x03,
> +	EDGBRD		= 0x04,
> +	EDGBWR		= 0x05,
> +	EEXTEND		= 0x06,
> +	ELDU		= 0x08,
> +	EBLOCK		= 0x09,
> +	EPA		= 0x0A,
> +	EWB		= 0x0B,
> +	ETRACK		= 0x0C,
> +	EAUG		= 0x0D,
> +	EMODPR		= 0x0E,
> +	EMODT		= 0x0F,
> +	EUPDATESVN	= 0x18,
>  };

This update is not consistent with the changelog nor the patch subject.

>  /**
> @@ -73,6 +74,10 @@ enum sgx_encls_function {
>   *				public key does not match IA32_SGXLEPUBKEYHASH.
>   * %SGX_PAGE_NOT_MODIFIABLE:	The EPC page cannot be modified because it
>   *				is in the PENDING or MODIFIED state.
> + * %SGX_INSUFFICIENT_ENTROPY:	Insufficient entropy in RNG.
> + * %SGX_NO_UPDATE:		EUPDATESVN was successful, but CPUSVN was not
> + *				updated because current SVN was not newer than
> + *				CPUSVN.

This comment bothers me. This is an *ERROR* code. It means that
EUPDATESVN was *NOT* successful. It failed. It didn't do an update.

Now, it's not a _bad_ error code. It's kinda like read() returning 0.
It's a "no harm no foul" kind of thing. But it's *NOT* success.

Ideally, we find a way to relay this in a very succinct way.
