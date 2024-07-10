Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B6C95F876;
	Wed, 10 Jul 2024 15:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720624509; cv=none; b=F8dmVVAHyXOQBFuu8Nj3aMDZ912GMAvAGnTfO4bC9hH7yUZFvXgDQKTmYlu1xv+xBYUKSbnfrKv5/aWTzvk1kX/QJ5IQXn/QSFWnZr6d5pJtz++CCW+CZ74Ls/m97Er1cqJAUei0ElyP/jSy42VL7g96QQql55Jwg45yO3pNJsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720624509; c=relaxed/simple;
	bh=XNvLVakjrsrGH7feZEiDVixq9xnBJRkQVc8Z6YE/axE=;
	h=Content-Type:To:Cc:Subject:References:Date:MIME-Version:From:
	 Message-ID:In-Reply-To; b=cQqEjYcW2t2WpjTCr67YvR9MNwwTBHE4c5XU85FdUu8K7yydjmVo+I9628W9HJ8VEfyQIM27QC2Pw/NL5i4W24yeqySJU6Ddtrfe8bdUMjz9UuyvNfqlaurtK0TyODTtIla+4LDcPuUStjrOiUAAYUqdr/H8HRE9MOFW3TzYmBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RSV/sQab; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RSV/sQab"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720624508; x=1752160508;
  h=to:cc:subject:references:date:mime-version:
   content-transfer-encoding:from:message-id:in-reply-to;
  bh=XNvLVakjrsrGH7feZEiDVixq9xnBJRkQVc8Z6YE/axE=;
  b=RSV/sQabnBS/UQ6/kJA3iLkeH2vt5mJ67Zdy4h+FRU92kJzcsx81lIbm
   aSD7tDjgSHqvi611qhUwt52mCNAR5L94QblwLN1R0BwLWWYpLFSgtAkzL
   3d4OvyIf4ejCWh6WQmbDPZXNW+w1SlyGMkNWrQs7q0Vjn8YfpYeonGESG
   VCNWQqwtB5z7d04QrUmb0cUPAJeH1CoznbVA7X4bRXFV5VOreQm/MoAkO
   HOxEkDLU7xUAWhqj3T0f8/L69H2I8SRtMGpG7zEKbRutYIK4T2/so0rPm
   cfGls8hHmoNJwQBz1uqE5ECBaBWq9jxaYoxE+OOjz9oD1WJshgIankkeM
   A==;
X-CSE-ConnectionGUID: C7VfLItPRrC0f8M0ZsUS/A==
X-CSE-MsgGUID: L827ZDRZR72HpvH6+JMCdg==
X-IronPort-AV: E=McAfee;i="6700,10204,11129"; a="29348876"
X-IronPort-AV: E=Sophos;i="6.09,198,1716274800"; 
   d="scan'208";a="29348876"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2024 08:15:07 -0700
X-CSE-ConnectionGUID: vvt6Lvg3SHK+0sdEAduMcw==
X-CSE-MsgGUID: pfDhorXdRZGpSKlrlepxEQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,198,1716274800"; 
   d="scan'208";a="53195241"
Received: from hhuan26-mobl.amr.corp.intel.com ([10.246.119.97])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/AES256-SHA; 10 Jul 2024 08:15:06 -0700
Content-Type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To: dave.hansen@linux.intel.com, jarkko@kernel.org, kai.huang@intel.com,
 reinette.chatre@intel.com, linux-sgx@vger.kernel.org,
 linux-kernel@vger.kernel.org, "Dmitrii Kuvaiskii"
 <dmitrii.kuvaiskii@intel.com>
Cc: mona.vij@intel.com, kailun.qin@intel.com, stable@vger.kernel.org
Subject: Re: [PATCH v4 1/3] x86/sgx: Split SGX_ENCL_PAGE_BEING_RECLAIMED into
 two flags
References: <20240705074524.443713-1-dmitrii.kuvaiskii@intel.com>
 <20240705074524.443713-2-dmitrii.kuvaiskii@intel.com>
Date: Wed, 10 Jul 2024 10:15:02 -0500
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Haitao Huang" <haitao.huang@linux.intel.com>
Organization: Intel
Message-ID: <op.2qo8ncfwwjvjmi@hhuan26-mobl.amr.corp.intel.com>
In-Reply-To: <20240705074524.443713-2-dmitrii.kuvaiskii@intel.com>
User-Agent: Opera Mail/1.0 (Win32)

On Fri, 05 Jul 2024 02:45:22 -0500, Dmitrii Kuvaiskii  
<dmitrii.kuvaiskii@intel.com> wrote:

> SGX_ENCL_PAGE_BEING_RECLAIMED flag is set when the enclave page is being
> reclaimed (moved to the backing store). This flag however has two
> logical meanings:
>
> 1. Don't attempt to load the enclave page (the page is busy).
> 2. Don't attempt to remove the PCMD page corresponding to this enclave
>    page (the PCMD page is busy).
>
> To reflect these two meanings, split SGX_ENCL_PAGE_BEING_RECLAIMED into
> two flags: SGX_ENCL_PAGE_BUSY and SGX_ENCL_PAGE_PCMD_BUSY. Currently,
> both flags are set only when the enclave page is being reclaimed. A
> future commit will introduce a new case when the enclave page is being
> removed; this new case will set only the SGX_ENCL_PAGE_BUSY flag.
>
LGTM.
Reviewed-by: Haitao Huang <haitao.huang@linux.intel.com>
Thanks
Haitao
