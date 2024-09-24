Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA3181487DC;
	Tue, 24 Sep 2024 09:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727171854; cv=none; b=FGDv7nHeIPeWp1lniPpZyQo3wVhzKBqj8LWJ7zJpvSZl70b53AXtXyD6eORtS9UwVdpAWpuj5wTzK2Pu5VtOEs6QnNkMruaaXo4cE4U13SbbMMurMFOlPnU/lsW+nbuahXELxn+FrO4ewdvRGpMb0y6unQNaUhITjhn8D/wq2gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727171854; c=relaxed/simple;
	bh=d6X/vkqw0omI3x47kRhNTlk9MtkoF4oiboZt+CaGUqA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=gaUG7lcfSRleIb1oRN3/cAUl4bUIvKRW1hhB+8DV72pqGaJtRw3qsNxtZLgtpMYcv2Wk6ki6iJzt4LfD0l1lpzDj9hm7nNwY4PgteNh3OYhuXSsQhDaRiqno6v7SDH1XOgH1cAiOItyORAz25eJFdfvdnGjeGFFfiy79WvoAo5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MYXKkrKK; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MYXKkrKK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727171853; x=1758707853;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=d6X/vkqw0omI3x47kRhNTlk9MtkoF4oiboZt+CaGUqA=;
  b=MYXKkrKKuMnQblkBKOKBvsXo0/M2lP8RLSatMIT3O0UGgFKr2tYSebTw
   RNeqXWdOOI/wbzitKaG+JiYcINqUzwGY0MTettRu+tRtqBfZ3+GMPsDAY
   n1/ytEEi50Z8/RDwNnUC8rj4+PAaqFcxJc4sgw8O/HwCBhWnlKEdO9xcu
   ij0/13xeXdGT/WzTRWoqST9iD8FX1IiGMrsacAaq2KYkXY426RkHymC/Z
   1C++dmgzbnPWna4vJ8XCQ4OUSzkCwHTdhw0PB3DVt80oMIbP7rr2xLL4X
   VmzK8wIpOFvyQ+gGPreTc8Xl64ISEF+yBRGmM3nVVKvBiF8ooKJddOaMd
   g==;
X-CSE-ConnectionGUID: 4rImAtRPS6Ofcq30wJABCA==
X-CSE-MsgGUID: wqnEd7/yQTKV2GIH93AZcg==
X-IronPort-AV: E=McAfee;i="6700,10204,11204"; a="30041613"
X-IronPort-AV: E=Sophos;i="6.10,254,1719903600"; 
   d="scan'208";a="30041613"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2024 02:57:31 -0700
X-CSE-ConnectionGUID: 9RlE9oOeRGG4t/CNkhkLOg==
X-CSE-MsgGUID: XwNF+c8tTJ2659l/WdvgJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,254,1719903600"; 
   d="scan'208";a="76143100"
Received: from mehlow-prequal01.jf.intel.com ([10.54.102.156])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2024 02:57:31 -0700
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
Subject: [PATCH v6 0/3] x86/sgx: Fix two data races in EAUG/EREMOVE flows
Date: Tue, 24 Sep 2024 02:49:11 -0700
Message-Id: <20240924094914.3873462-1-dmitrii.kuvaiskii@intel.com>
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

v5 -> v6:
- No changes in code itself
- Added "Reviewed-by" line for reviews of Jarkko Sakkinen and Kai Huang
- Added "Fixes" tag as per suggestion from Kai Huang [8] 

v4 -> v5:
- Improved commit message and code comments in the first (preparatory)
  patch per suggestions from Jarkko Sakkinen [3][4] and Kai Huang [5]
- Reworked the second patch (that fixes the first bug) as suggested by
  Kai Huang [6]; the suggested rework is a cleaner fix
- Added fix for a similar race (for SGX_IOC_ENCLAVE_MODIFY_TYPES ioctl)
  to the third patch (that fixes the second bug) as suggested by Kai
  Huang [7]

v3 -> v4:
- Added a preparatory patch to split the SGX_ENCL_PAGE_BEING_RECLAIMED
  flag into two: SGX_ENCL_PAGE_BUSY and SGX_ENCL_PAGE_PCMD_BUSY
  (split suggested by Dave Hansen [2])
- No changes in the second patch (that fixes the first bug)
- Trivial changes in the third patch (that fixes the second bug), now
  that we have a preparatory patch; plus expanded a comment (as
  suggested by Dave Hansen)

v2 -> v3:
- No changes in code itself
- Improved commit message of the first patch (text suggested by Dave
  Hansen); kept the CPU1 vs CPU2 diagram (as all reviewers liked it)
- No changes in the commit message of the second patch

v1 -> v2:
- No changes in code itself
- Expanded cover letter
- Added CPU1 vs CPU2 race scenarios in commit messages

[1] https://github.com/gramineproject/gramine/pull/1513
[2] https://lore.kernel.org/all/1d405428-3847-4862-b146-dd57711c881e@intel.com/
[3] https://lore.kernel.org/all/D2RQXM679U0X.1XY6BWHSFTRFZ@kernel.org/
[4] https://lore.kernel.org/all/D2RQYS2CVEWL.3IU1P67NT0D5Y@kernel.org/
[5] https://lore.kernel.org/all/35441491-99cf-403b-9e64-9d7b0453e59e@intel.com/
[6] https://lore.kernel.org/all/016c34af-399b-480e-a99c-eaf3e397d33a@intel.com/
[7] https://lore.kernel.org/all/6645526a-7c56-4f98-be8c-8c8090d8f043@intel.com/
[8] https://lore.kernel.org/all/c9ae406e8751b2969322be83ea5afba08e0d6e13.camel@intel.com/

v1: https://lore.kernel.org/all/20240429104330.3636113-3-dmitrii.kuvaiskii@intel.com/
v2: https://lore.kernel.org/all/20240515131240.1304824-1-dmitrii.kuvaiskii@intel.com/
v3: https://lore.kernel.org/all/20240517110631.3441817-1-dmitrii.kuvaiskii@intel.com/
v4: https://lore.kernel.org/all/20240705074524.443713-1-dmitrii.kuvaiskii@intel.com/
v5: https://lore.kernel.org/all/20240821100215.4119457-1-dmitrii.kuvaiskii@intel.com/

Dmitrii Kuvaiskii (3):
  x86/sgx: Split SGX_ENCL_PAGE_BEING_RECLAIMED into two flags
  x86/sgx: Resolve EAUG race where losing thread returns SIGBUS
  x86/sgx: Resolve EREMOVE page vs EAUG page data race

 arch/x86/kernel/cpu/sgx/encl.c  | 52 ++++++++++++++++++---------------
 arch/x86/kernel/cpu/sgx/encl.h  | 11 +++++--
 arch/x86/kernel/cpu/sgx/ioctl.c | 17 +++++++++++
 arch/x86/kernel/cpu/sgx/main.c  |  4 +--
 4 files changed, 56 insertions(+), 28 deletions(-)

-- 
2.43.0

