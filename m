Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A125E190684;
	Fri,  9 Aug 2024 09:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723196618; cv=none; b=EnzN1hCD9D2XI2LVVVX7gfgYq2ARGYS4YgmnrtaiqdJn1M2kv/5Sj0Es5GHF6lztLTOca7i4yiTzL4ZaX2cijznP+Y4K+88/+esHP1GE51QxAcWQhTOXIrk1PH6gqROvKvYS/RTD99IYNjr9T4XFSOeq68ooNERxFuRGDd+ZME4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723196618; c=relaxed/simple;
	bh=jSzPM+D//4KGm9m9/EKlgHWU7mMnonAm4fu/0+KnY7g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ifDGWSij6G6bi3VKmL8YbLXezZKtcIMYckGipklJumSf0kyi6tBJXRYy611uZhHdBOOV/EfF4AU5cgC61jbAPqqUuxNJwK/j108CCqaXyqtXU7dxtlv421Sp251QarFK0oTF55tzRsO4W8VTgT8Dk1qtKdb0tBD76a4ARXcJ6fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CUk8mkuC; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CUk8mkuC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723196617; x=1754732617;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jSzPM+D//4KGm9m9/EKlgHWU7mMnonAm4fu/0+KnY7g=;
  b=CUk8mkuCQaQQrwcEzHwJY3E+I/WQ+hxKaZpMoC0GvqFY8K1JCfpdcYzr
   LHlMeIA7CLSJ7R05sCSM/tfVr9Ty8SYwKD6g4k1To7pkTeuje+5cylMLl
   j/xmkxQa9QnYX7sMIz8uZnxEIeZzowDrSc1IkgZ88igjDuDu0pyVwISvA
   59/wdSiFIXTKW0IwgNjpmEKSv4oujVCwPk6Y0ePbEfUEhqPwAxB97UMvl
   EZI07QYF/4c3xfehU0H6/H79Il7W/rtcARFyZv7Mo2rPH2RviRa6kWa0/
   eEMaMIkXZXbzTstFeArHIZi3D01HpSn2HLmnFaX35vZU72avnLHOr0fMu
   g==;
X-CSE-ConnectionGUID: ruJ5032VQRmzLmPzFgMYLQ==
X-CSE-MsgGUID: xJgBeIqzReyGPepGVjSiIA==
X-IronPort-AV: E=McAfee;i="6700,10204,11158"; a="21505248"
X-IronPort-AV: E=Sophos;i="6.09,275,1716274800"; 
   d="scan'208";a="21505248"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2024 02:43:36 -0700
X-CSE-ConnectionGUID: uZSbRtSjTtO5r2F/DXiGxA==
X-CSE-MsgGUID: HqvFyYYqRqWKTs9vvAoqgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,275,1716274800"; 
   d="scan'208";a="57395096"
Received: from mehlow-prequal01.jf.intel.com ([10.54.102.156])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2024 02:43:36 -0700
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
Date: Fri,  9 Aug 2024 02:35:20 -0700
Message-Id: <20240809093520.954552-1-dmitrii.kuvaiskii@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <6645526a-7c56-4f98-be8c-8c8090d8f043@intel.com>
References: <6645526a-7c56-4f98-be8c-8c8090d8f043@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Organization: Intel Deutschland GmbH - Registered Address: Am Campeon 10, 85579 Neubiberg, Germany
Content-Transfer-Encoding: 8bit

On Thu, Jul 25, 2024 at 01:21:56PM +1200, Huang, Kai wrote:
>
> > Two enclave threads may try to add and remove the same enclave page
> > simultaneously (e.g., if the SGX runtime supports both lazy allocation
> > and MADV_DONTNEED semantics). Consider some enclave page added to the
> > enclave. User space decides to temporarily remove this page (e.g.,
> > emulating the MADV_DONTNEED semantics) on CPU1. At the same time, user
> > space performs a memory access on the same page on CPU2, which results
> > in a #PF and ultimately in sgx_vma_fault(). Scenario proceeds as
> > follows:
> >
> >   [ ... skipped ... ]
> >
> > Here, CPU1 removed the page. However CPU2 installed the PTE entry on the
> > same page. This enclave page becomes perpetually inaccessible (until
> > another SGX_IOC_ENCLAVE_REMOVE_PAGES ioctl). This is because the page is
> > marked accessible in the PTE entry but is not EAUGed, and any subsequent
> > access to this page raises a fault: with the kernel believing there to
> > be a valid VMA, the unlikely error code X86_PF_SGX encountered by code
> > path do_user_addr_fault() -> access_error() causes the SGX driver's
> > sgx_vma_fault() to be skipped and user space receives a SIGSEGV instead.
> > The userspace SIGSEGV handler cannot perform EACCEPT because the page
> > was not EAUGed. Thus, the user space is stuck with the inaccessible
> > page.
>
> Reading the code, it seems the ioctl(sgx_ioc_enclave_modify_types) also zaps
> EPC mapping when converting a normal page to TSC.  Thus IIUC it should also
> suffer this issue?

Technically yes, sgx_enclave_modify_types() has a similar code path and
can be patched in a similar way.

Practically though, I can't imagine an SGX program or framework to allow a
scenario when CPU1 modifies the type of the enclave page from REG to TCS
and at the same time CPU2 performs a memory access on the same page. This
would be clearly a bug in the SGX program/framework. For example, Gramine
always follows the path of: create a new REG enclave page, modify it to
TCS, only then start using it; i.e., there is never a point in time at
which the REG page is allocated and ready to be converted to a TCS page,
and some other thread/CPU accesses it in-between these steps.

TLDR: I can add similar handling to sgx_enclave_modify_types() if
reviewers insist, but I don't see how this data race can ever be
triggered by benign real-world SGX applications.

--
Dmitrii Kuvaiskii
