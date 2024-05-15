Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E01A614AB4;
	Wed, 15 May 2024 13:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715779272; cv=none; b=ZrbiikPG3G0HKzhGwFc/yNiN+sczoo6/5KWV598fOWctAICro8yGEcQ6FQ06ijc5+jS7RJIYVZiJTAMzCGG7wwBOLxX4EqEhSyx7jQWZ7xaE45vJkPlzuf5GamhNe5WPnCxsCIBp6KYs8KxYn1u4A8UWD/5B5jWrwy0CDhUigCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715779272; c=relaxed/simple;
	bh=5Ag5vL9wO2ldtZ+Du1UJaAu+pkltrp0z0Af+UtXoOHk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=nvjxcl5WIdMhKYo7fYWV114/A8GrZfCa3MY58L/FNTFpzCISoXV+MjpVDTI4nqwKtZnR/07mhO7n79YMmYyxM5uST7SDHcdjwn1Yj04f0YCYz2PIsqC9i0P0RokFTr3N+Aekvbz1mYYd4dCIebXEj1LLtaeLOhHXbfGdQ9fODw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Wc6wZbSZ; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Wc6wZbSZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715779272; x=1747315272;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=5Ag5vL9wO2ldtZ+Du1UJaAu+pkltrp0z0Af+UtXoOHk=;
  b=Wc6wZbSZTmxv3WopMcv8G8AhYUzoLgswL+WChpc9wfFm83yQD5NxIQpR
   sdc/+u1K0wlBKKtfsuKwASUXtcYD732YKpKNMhkLm8IMQXO4/k9wMFo5J
   /VJ1fbSEwexDwZ2n6bJBJBWRikLMJ2/1y6KufvaKrfRDbqAe5dAXLQNS+
   bPfnK5mJlyOaVT3g30Yb8irwldfnx0TY5H9cSr+/RcUx1l5USf7K84Ppr
   VL1mcTQThICU+RPtulyPT0OJAwQuSaZ2CpuNOobF6ebluA0PJibPbTcjO
   zBz8sk5SuEEARKkd08vAXdL0+N+/7JM4MlOCJRXATZaUMegSJwOVMEXjq
   g==;
X-CSE-ConnectionGUID: 7YO6rwSsTBCRPh03dschyA==
X-CSE-MsgGUID: pMUwoIpiSbK+8laS51Lu7Q==
X-IronPort-AV: E=McAfee;i="6600,9927,11073"; a="15648212"
X-IronPort-AV: E=Sophos;i="6.08,161,1712646000"; 
   d="scan'208";a="15648212"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 06:21:03 -0700
X-CSE-ConnectionGUID: lHsRm4bTQTywl6OdW4LCCQ==
X-CSE-MsgGUID: RwgNCU6ZQ2G0Zz9hNDjskQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,161,1712646000"; 
   d="scan'208";a="68510852"
Received: from mehlow-prequal01.jf.intel.com ([10.54.102.156])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 06:21:02 -0700
From: Dmitrii Kuvaiskii <dmitrii.kuvaiskii@intel.com>
To: dave.hansen@linux.intel.com,
	jarkko@kernel.org,
	kai.huang@intel.com,
	haitao.huang@linux.intel.com,
	reinette.chatre@intel.com,
	linux-sgx@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: mona.vij@intel.com,
	kailun.qin@intel.com
Subject: [PATCH v2 0/2] x86/sgx: Fix two data races in EAUG/EREMOVE flows
Date: Wed, 15 May 2024 06:12:38 -0700
Message-Id: <20240515131240.1304824-1-dmitrii.kuvaiskii@intel.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Organization: Intel Deutschland GmbH - Registered Address: Am Campeon 10, 85579 Neubiberg, Germany
Content-Transfer-Encoding: 8bit

SGX runtimes such as Gramine may implement EDMM-based lazy allocation of
enclave pages and may support MADV_DONTNEED semantics [1]. The former
implies #PF-based page allocation, and the latter implies the usage of
SGX_IOC_ENCLAVE_REMOVE_PAGES ioctl.

EDMM-based lazy allocation and MADV_DONTNEED semantics provide
significant performance improvement for some workloads that run on
Gramine. For example, a Java workload with a 16GB enclave size has
approx. 57x improvement in total runtime. Thus, we consider it important
to permit these optimizations in Gramine. However, we observed hangs of
applications (Node.js, PyTorch, R, iperf, Blender, Nginx) when run on
Gramine with EDMM, lazy allocation and MADV_DONTNEED features enabled.

We wrote a trivial stress test to reproduce the hangs observed in
real-world applications. The test stresses #PF-based page allocation and
SGX_IOC_ENCLAVE_REMOVE_PAGES flows in the SGX driver:

/* repeatedly touch different enclave pages at random and mix with
 * madvise(MADV_DONTNEED) to stress EAUG/EREMOVE flows */
static void* thread_func(void* arg) {
    size_t num_pages = 0xA000 / page_size;
    for (int i = 0; i < 5000; i++) {
        size_t page = get_random_ulong() % num_pages;
        char data = READ_ONCE(((char*)arg)[page * page_size]);

        page = get_random_ulong() % num_pages;
        madvise(arg + page * page_size, page_size, MADV_DONTNEED);
    }
}

addr = mmap(NULL, 0xA000, PROT_READ | PROT_WRITE, MAP_ANONYMOUS, -1, 0);
pthread_t threads[16];
for (int i = 0; i < 16; i++)
    pthread_create(&threads[i], NULL, thread_func, addr);

This test uncovers two data races in the SGX driver. The remaining
patches describe and fix these races.

I performed several stress tests to verify that there are no other data
races (at least with the test program above):

- On Icelake server with 128GB of PRM, without madvise(). This stresses
  the first data race. A Gramine SGX test suite running in the
  background for additional stressing. Result: 1,000 runs without hangs
  (result without the first bug fix: hangs every time).
- On Icelake server with 128GB of PRM, with madvise(). This stresses the
  second data race. A Gramine SGX test suite running in the background
  for additional stressing. Result: 1,000 runs without hangs (result
  with the first bug fix but without the second bug fix: hangs approx.
  once in 50 runs).
- On Icelake server with 4GB of PRM, with madvise(). This additionally
  stresses the enclave page swapping flows. Two Gramine SGX test suites
  running in the background for additional stressing of swapping (I
  observe 100% CPU utilization from ksgxd which confirms that swapping
  happens). Result: 1,000 runs without hangs.

[1] https://github.com/gramineproject/gramine/pull/1513

v1 -> v2:
- No changes in code itself
- Expanded cover letter
- Added CPU1 vs CPU2 race scenarios in commit messages

v1: https://lore.kernel.org/all/20240429104330.3636113-3-dmitrii.kuvaiskii@intel.com/

Dmitrii Kuvaiskii (2):
  x86/sgx: Resolve EAUG race where losing thread returns SIGBUS
  x86/sgx: Resolve EREMOVE page vs EAUG page data race

 arch/x86/kernel/cpu/sgx/encl.c  | 10 +++++++---
 arch/x86/kernel/cpu/sgx/encl.h  |  3 +++
 arch/x86/kernel/cpu/sgx/ioctl.c |  1 +
 3 files changed, 11 insertions(+), 3 deletions(-)

-- 
2.34.1

