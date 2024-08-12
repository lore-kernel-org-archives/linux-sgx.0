Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6179E55896;
	Mon, 12 Aug 2024 08:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723451115; cv=none; b=PjV+ZTHDJcrRvxqB6wjWYU1Fc6q3hNYpJYd6T0Gja3jFxWnqEipnV0LOMsmWBNq0qw/Ebn3CPms+8SSuCvIHwTYeFf/642AB8CqFw67S/9I3DTcFzEKiS5YCKJOLGT+ytBDH/BNc2v6ozg5oYxpMwKYqQOCLNY20yeu1gWiDmZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723451115; c=relaxed/simple;
	bh=mugA+J7GZZuLR3yGFY61+Z4oaH11ZZMEqoUidBcISxI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A3dEBQYmmrQ4VCEKsAxxK4aoAwvhO6aEnEXTiDVVHTnnpTGdCvWPfB2yF0+bXBtkqtUX1kT1SNIyGCZWIElvCVelzYrVht5C6QyFRjV2amWLdRGqxwxE4IcGGtxS6NkIsgzbapnyqapJi/QGcRD4KmGyU7CHxek5SwaT28vJnZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m1x0GAra; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m1x0GAra"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723451113; x=1754987113;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mugA+J7GZZuLR3yGFY61+Z4oaH11ZZMEqoUidBcISxI=;
  b=m1x0GAraaPz53PLljK1WDDP6/Chka1y6kdP4rHts11Mko3C4qkbyWDPh
   ny9WMRHRKlEUxip5/1lK+r1aDuG0No+q+jCQKc5MsUB8o6MPA3QYNhUBo
   51oep+NpvASP2NZ1/5M76WJOdyPRSdP8J1+WtAFpBz0O3CW3PPEGpCxqt
   ZHOlYQHMMYDdsUGt5HR46EBfG0TxFAzrqeFWbKHXwKVBN/aBBcR0tLEjS
   z4LZYztFD/xLGRO1nfSqm/y3t54i52wvZzFz5NqSn5WpMPsqTbTQecP6q
   vr8kVxPUBO2q5LfnXScv9+ZPVmphBDRZ8+l6Cix2UAlWzBKi90tCx4ImX
   w==;
X-CSE-ConnectionGUID: iUAvUY16QqWD8JN87/uFLA==
X-CSE-MsgGUID: UCK2OJSjQyKcjI5CNrQuUA==
X-IronPort-AV: E=McAfee;i="6700,10204,11161"; a="25413989"
X-IronPort-AV: E=Sophos;i="6.09,282,1716274800"; 
   d="scan'208";a="25413989"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 01:25:13 -0700
X-CSE-ConnectionGUID: VCEER4MoSMGv8FndBCs71w==
X-CSE-MsgGUID: K3ivngewSDyasp3dY08xOg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,282,1716274800"; 
   d="scan'208";a="57842228"
Received: from mehlow-prequal01.jf.intel.com ([10.54.102.156])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 01:25:12 -0700
From: Dmitrii Kuvaiskii <dmitrii.kuvaiskii@intel.com>
To: jarkko@kernel.org
Cc: dave.hansen@linux.intel.com,
	dmitrii.kuvaiskii@intel.com,
	haitao.huang@linux.intel.com,
	kai.huang@intel.com,
	kailun.qin@intel.com,
	linux-kernel@vger.kernel.org,
	linux-sgx@vger.kernel.org,
	mona.vij@intel.com,
	reinette.chatre@intel.com,
	stable@vger.kernel.org
Subject: Re: [PATCH v4 1/3] x86/sgx: Split SGX_ENCL_PAGE_BEING_RECLAIMED into two flags
Date: Mon, 12 Aug 2024 01:16:57 -0700
Message-Id: <20240812081657.3046029-1-dmitrii.kuvaiskii@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <D2RQYS2CVEWL.3IU1P67NT0D5Y@kernel.org>
References: <D2RQYS2CVEWL.3IU1P67NT0D5Y@kernel.org>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Organization: Intel Deutschland GmbH - Registered Address: Am Campeon 10, 85579 Neubiberg, Germany
Content-Transfer-Encoding: 8bit

On Wed, Jul 17, 2024 at 01:37:39PM +0300, Jarkko Sakkinen wrote:
> On Fri Jul 5, 2024 at 10:45 AM EEST, Dmitrii Kuvaiskii wrote:
> > +/*
> > + * 'desc' bit indicating that PCMD page associated with the enclave page is
> > + * busy (e.g. because the enclave page is being reclaimed).
> > + */
> > +#define SGX_ENCL_PAGE_PCMD_BUSY    BIT(3)
>
> What are other situations when this flag is set than being
> reclaimed? The comment says that it is only one use for this
> flag.

Yes, your understanding is correct, currently there is only one situation.

Do you want me to modify the comment somehow?

--
Dmitrii Kuvaiskii
