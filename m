Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2438E4D599;
	Mon, 12 Aug 2024 08:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723452024; cv=none; b=RE4R7z6e1pgfl0EnYvvRzBAdtb1xW/04QlsrK+JD5Xkuz2lr0n9kz2EA9jHdhJ3QmRKP9L9SikBqpGr/i/PMpSYyWVaIBTwGzU65b919G9TqPM3h9qqB2FTSOgcS2iwtDNmm7FTSZNQ68rjchuohpLDBc7Qe+51kdLUzw9lihUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723452024; c=relaxed/simple;
	bh=XGG8unNJdo137wh16BkBQ7L7NU8nK3Nb5MbGuKRbMH8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GW8deSRPuQdB2zlpIKFrkzOF/qrNqgKuO65hkpocgoxlo796XVfBvodaeVFwt4q1Ocf1r2mnkOMuUVb/OY97eDO1MxgQrf+8OWEBDRWwyqb5FYxGOYGwzpvMX6s6YghL5JmQQyGZpwyhXOXVX3gUZAgNowuD/WCMIknmbNROt5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QdnWj+bK; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QdnWj+bK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723452022; x=1754988022;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=XGG8unNJdo137wh16BkBQ7L7NU8nK3Nb5MbGuKRbMH8=;
  b=QdnWj+bK4JZGcQ8JVsCC9CGi1Ss4xHNURtq0OrfB2uTwJfO7BzR/AxKW
   H8sLqkDKBtR8u09+Z+uLs5FtiTHDD9PVtARimF35zG8VRSEd4TM/WI47v
   jA1tqP9Q7rCQV5YDRaI2FatVwgV/mZGm4ZZpVkNCHWKipqmG/Dk3XMrLm
   QUMcGeyX4exaf0ZDaSFdJ4eZ44ky45vh5TWOAKgnibcHNNsAumEBk3hzq
   p7gt+n8uYLIHzqbfSVPr9dfaRjlgtrpwLGdeEhShGuF9WY+IPNsHeekLE
   H/MgmttaYlC/LwdRSQJrth7PBJYlEMEM0Nhc/zb6eQv5rIteQaWm4QxFX
   w==;
X-CSE-ConnectionGUID: QdVMN4I0TxKdnHXI/8jaow==
X-CSE-MsgGUID: W6w/hWzfTsqgF+rpE3RBEA==
X-IronPort-AV: E=McAfee;i="6700,10204,11161"; a="21694058"
X-IronPort-AV: E=Sophos;i="6.09,282,1716274800"; 
   d="scan'208";a="21694058"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 01:40:21 -0700
X-CSE-ConnectionGUID: bJLHTNlvQGWc2LkHuBpeOQ==
X-CSE-MsgGUID: V/dL+im2RvOeq9UTlC1TiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,282,1716274800"; 
   d="scan'208";a="58096158"
Received: from mehlow-prequal01.jf.intel.com ([10.54.102.156])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 01:40:21 -0700
From: Dmitrii Kuvaiskii <dmitrii.kuvaiskii@intel.com>
To: kai.huang@intel.com
Cc: dave.hansen@linux.intel.com,
	dmitrii.kuvaiskii@intel.com,
	haitao.huang@linux.intel.com,
	jarkko@kernel.org,
	kailun.qin@intel.com,
	linux-kernel@vger.kernel.org,
	linux-sgx@vger.kernel.org,
	mona.vij@intel.com,
	reinette.chatre@intel.com,
	stable@vger.kernel.org
Subject: Re: [PATCH v4 3/3] x86/sgx: Resolve EREMOVE page vs EAUG page data race
Date: Mon, 12 Aug 2024 01:32:07 -0700
Message-Id: <20240812083207.3173402-1-dmitrii.kuvaiskii@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <8ab0f2d8aaf80e263796e18010e0fa0a4f0686a3.camel@intel.com>
References: <8ab0f2d8aaf80e263796e18010e0fa0a4f0686a3.camel@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Organization: Intel Deutschland GmbH - Registered Address: Am Campeon 10, 85579 Neubiberg, Germany
Content-Transfer-Encoding: 8bit

On Fri, Aug 09, 2024 at 11:19:22AM +0000, Huang, Kai wrote:

> > TLDR: I can add similar handling to sgx_enclave_modify_types() if
> > reviewers insist, but I don't see how this data race can ever be
> > triggered by benign real-world SGX applications.
>
> So as mentioned above, I intend to suggest to also apply the BUSY flag here.  
> And we can have a consist rule in the kernel:
>
> If an enclave page is under certainly operation by the kernel with the mapping
> removed, other threads trying to access that page are temporarily blocked and
> should retry.

I agree with your assessment on the consequences of such bug in
sgx_enclave_modify_types(). To my understanding, this bug can only affect
the SGX enclave (i.e. the userspace) -- either the SGX enclave will hang
or will be terminated.

Anyway, I will apply the BUSY flag also in sgx_enclave_modify_types() in
the next iteration of this patch series.

--
Dmitrii Kuvaiskii
