Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C4FC19AD90;
	Fri,  7 Jun 2024 17:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717782939; cv=none; b=k0Aed2Mo/67tuaBz9OUOEAEBXIGo5UJ74Oh9g9uYtt65oe7C+WadW7CnBElglxKK7vnzx5N/RTdKj9vZ/DNH5SiVGYTiMgt4Nq6EjkMeOkSJ76vYn7ShyLnGorYzZow47jOGrU+EqSw8z15CXlFdCRylgtj7R1Qojnp93uCxBlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717782939; c=relaxed/simple;
	bh=9pY0lakFOJQMli3EsSUnKuQMKYfcQqGOb4o+kPooLL8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E1xmIObCWe/sAYQ81oh5U0YcNSIvQerUC1mqus001TcOhc7T/zhwkkXvNWc6OFAvMaWssRNH+/B3J3z3rl4ggKIaxdNWHEdp3wa/UWWvmAn8ska0bsm/mxyfC9OcMtrzSZtT1dFpYSnxrV7Wh55GFjFKl2MRtHZdNLR9vrOnSJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OFzDW8cs; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OFzDW8cs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717782938; x=1749318938;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9pY0lakFOJQMli3EsSUnKuQMKYfcQqGOb4o+kPooLL8=;
  b=OFzDW8csi+R2LLymnh+qi9vK6d/EdniXqoKNhY56yZavbqgVdPkOv18O
   l88pqtFuC2iwV3Ko8J9Vvggx1DQMcUH8xBWdBXzMSRF298Mqw8ADpAOTr
   xnBwZyipZOd531OoOCfOfdX13NdZbDS4ntp0KvRr+GMJGTt0Jec8qZ206
   HbRRwrA9QeB8zwnNgRltBLCxtl71KvcpwphCiuBqFUA1eR3fMPblgS7IY
   1Xb36o4ONVHvoQ9mkr/vyAqKT+F2Lp6CDFe5ZPN7WE+tF/NrBwt7n5o2z
   dMykbEfbrjGzylRIHywyk7i2PeIcFNyM03ADdmKp2KH/ufXrhz9BhBKYX
   g==;
X-CSE-ConnectionGUID: quC/DEBaS6CxxzqdFYYxuA==
X-CSE-MsgGUID: GoPI3i91R9SISJXLhK5BVg==
X-IronPort-AV: E=McAfee;i="6600,9927,11096"; a="14357840"
X-IronPort-AV: E=Sophos;i="6.08,221,1712646000"; 
   d="scan'208";a="14357840"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2024 10:55:38 -0700
X-CSE-ConnectionGUID: yRJ/o2lLRbyqJ4NPFMy+6g==
X-CSE-MsgGUID: 6fQUVGT8SzGNU2eGYa4iDA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,221,1712646000"; 
   d="scan'208";a="38517697"
Received: from mehlow-prequal01.jf.intel.com ([10.54.102.156])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2024 10:55:37 -0700
From: Dmitrii Kuvaiskii <dmitrii.kuvaiskii@intel.com>
To: dave.hansen@intel.com
Cc: dave.hansen@linux.intel.com,
	dmitrii.kuvaiskii@intel.com,
	haitao.huang@linux.intel.com,
	jarkko@kernel.org,
	kai.huang@intel.com,
	kailun.qin@intel.com,
	linux-kernel@vger.kernel.org,
	linux-sgx@vger.kernel.org,
	mona.vij@intel.com,
	reinette.chatre@intel.com
Subject: Re: [PATCH v3 0/2] x86/sgx: Fix two data races in EAUG/EREMOVE flows
Date: Fri,  7 Jun 2024 10:47:18 -0700
Message-Id: <20240607174718.751068-1-dmitrii.kuvaiskii@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <2dd91299-650a-4e0e-97f4-0d4e472db9a0@intel.com>
References: <2dd91299-650a-4e0e-97f4-0d4e472db9a0@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Organization: Intel Deutschland GmbH - Registered Address: Am Campeon 10, 85579 Neubiberg, Germany
Content-Transfer-Encoding: 8bit

On Tue, May 28, 2024 at 09:01:10AM -0700, Dave Hansen wrote:
> On 5/17/24 04:06, Dmitrii Kuvaiskii wrote:
> > We wrote a trivial stress test to reproduce the hangs observed in
> > real-world applications. The test stresses #PF-based page allocation and
> > SGX_IOC_ENCLAVE_REMOVE_PAGES flows in the SGX driver:
>
> This seems like something we'd want in the kernel SGX selftests.

I looked at tools/testing/selftests/sgx/ and I observe several
complications:

1. The stress test requires creation of several threads (at least two,
   ideally more). However, current SGX selftests are single-threaded.
   Adding the scaffolding to add multi-threading support to SGX selftests
   seems like a non-trivial task.

2. Catching the data race would require a for loop with some threshold.
   - First, there are no such looping tests in current SGX selftests. Is
     it normal to add such a test?
   - Second, what would be the threshold to loop for? I.e., after how many
     iterations should we consider the data race not manifesting, and
     report success?
   - Third, the data race may hang the test. Is this something that is
     allowed in selftests? (I mean the test can have only two outcomes --
     either it hangs, meaning the data race was not fixed, or it runs to
     completion. There is no result that we could EXCEPT or ASSERT on.)

Do we still want to add such a selftest? Or could we maybe piggy-back on
Gramine CI (that will include the test I mentioned in the cover letter)?

--
Dmitrii Kuvaiskii
