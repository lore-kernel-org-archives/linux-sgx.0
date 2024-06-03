Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7D01CD38;
	Mon,  3 Jun 2024 18:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717440176; cv=none; b=sn8zkehPlqwXyE0wx7z13zTnsf3xPdyI39JvIN1rHnFF+QjomfQl7ahrQlyCdySjoCP8UKnzveR1DyqgbqGTXsMhyhZyAVMFEikqMEWJeya4c6Y/Hw9WbrzHiztTTdZdw6T1zBiKBAu1RuZa5uPJhm1P2JA+KYzlHTXrxv2JuTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717440176; c=relaxed/simple;
	bh=XU3+4aIaGjfIeWdhjY6gqQJdX7eZNihH6RIm/Asfw6Y=;
	h=Content-Type:To:Cc:Subject:References:Date:MIME-Version:From:
	 Message-ID:In-Reply-To; b=YCpFR2qtkg/1O9ZYmb6ZeGoyMUKF2/iYCAcg4xSn7ryR4l3mhfGdDoPNmjUWgorSPdx7Y1lAdMpuysHsukPqdo5s7QkYTvoDjpI0RXyDimyBgT2AT5MzD+9sTWqBopJkHZRDOfbxiOt1gvLrl003628EMlPKAvQWluga7Co5X4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=J6VjL6Ws; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="J6VjL6Ws"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717440175; x=1748976175;
  h=to:cc:subject:references:date:mime-version:
   content-transfer-encoding:from:message-id:in-reply-to;
  bh=XU3+4aIaGjfIeWdhjY6gqQJdX7eZNihH6RIm/Asfw6Y=;
  b=J6VjL6WsI+scU62zfrO/ByNwKqDV4KtBe9buJVwxd5z3bkHAaLv7OPBk
   S1iS8rzSQkblHtH0i+oWDAqH3roKKadNDTeUshNhdXjgJR1jIV4IiVEL9
   u7juZ8qUGONnHMa+dsPJYSZRtdTGMi6cMbLM3va9v4NxZvORoF0TdwQGL
   L2e+UdySI/0HDsFdCX89VF8p665p7in3G8CY7NS/hObSadFhzsTLG3PCD
   nYh1NRqC17bIxe6V0fx85W1uKjqTQDxwFkd1veTrrkrI4ND+C6U92mR/N
   V35X4oA1HyXxEXlo5zI3ZDq9tFr7kh+R9v7UKCBGnH7vEU2wkueR2kXj5
   w==;
X-CSE-ConnectionGUID: WKVKnG3TTnu2zIeDznSl+w==
X-CSE-MsgGUID: E5myC96OQN2i0miwGWAtUw==
X-IronPort-AV: E=McAfee;i="6600,9927,11092"; a="13759907"
X-IronPort-AV: E=Sophos;i="6.08,212,1712646000"; 
   d="scan'208";a="13759907"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2024 11:42:54 -0700
X-CSE-ConnectionGUID: AiZY5W62Rzisjdj9sJ4hJQ==
X-CSE-MsgGUID: FW+UUMl7TzmrUi3mo8BR/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,212,1712646000"; 
   d="scan'208";a="74450737"
Received: from hhuan26-mobl.amr.corp.intel.com ([10.92.17.168])
  by smtpauth.intel.com with ESMTP/TLS/AES256-SHA; 03 Jun 2024 11:42:52 -0700
Content-Type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To: "Dmitrii Kuvaiskii" <dmitrii.kuvaiskii@intel.com>,
 dave.hansen@linux.intel.com, jarkko@kernel.org, kai.huang@intel.com,
 reinette.chatre@intel.com, linux-sgx@vger.kernel.org,
 linux-kernel@vger.kernel.org, "Dave Hansen" <dave.hansen@intel.com>
Cc: mona.vij@intel.com, kailun.qin@intel.com, stable@vger.kernel.org
Subject: Re: [PATCH v3 2/2] x86/sgx: Resolve EREMOVE page vs EAUG page data
 race
References: <20240517110631.3441817-1-dmitrii.kuvaiskii@intel.com>
 <20240517110631.3441817-3-dmitrii.kuvaiskii@intel.com>
 <01bb6519-680e-45bf-b8bd-34763658aa17@intel.com>
Date: Mon, 03 Jun 2024 13:42:49 -0500
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Haitao Huang" <haitao.huang@linux.intel.com>
Organization: Intel
Message-ID: <op.2oszlnlowjvjmi@hhuan26-mobl.amr.corp.intel.com>
In-Reply-To: <01bb6519-680e-45bf-b8bd-34763658aa17@intel.com>
User-Agent: Opera Mail/1.0 (Win32)

On Tue, 28 May 2024 11:23:13 -0500, Dave Hansen <dave.hansen@intel.com>  
wrote:

> On 5/17/24 04:06, Dmitrii Kuvaiskii wrote:
> ...
>
> First, why is SGX so special here?  How is the SGX problem different
> than what the core mm code does?
>
>> --- a/arch/x86/kernel/cpu/sgx/encl.h
>> +++ b/arch/x86/kernel/cpu/sgx/encl.h
>> @@ -25,6 +25,9 @@
>>  /* 'desc' bit marking that the page is being reclaimed. */
>>  #define SGX_ENCL_PAGE_BEING_RECLAIMED	BIT(3)
>>
>> +/* 'desc' bit marking that the page is being removed. */
>> +#define SGX_ENCL_PAGE_BEING_REMOVED	BIT(2)
>
> Second, convince me that this _needs_ a new bit.  Why can't we just have
> a bit that effectively means "return EBUSY if you see this bit when
> handling a fault".
>

IIUC, reclaimer_writing_to_pcmd() also uses SGX_ENCL_PAGE_BEING_RECLAIMED  
to check if a page is about being reclaimed in order to prevent its VA  
slot fro being freed. So I think we do need separate bit for EREMOVE which  
does not write to VA slot?

BR
Haitao
