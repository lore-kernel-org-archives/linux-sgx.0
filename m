Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 925701459FD;
	Fri,  5 Jul 2024 07:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720166054; cv=none; b=u68fj1MeN5xpw+Q5bIlJ5r1nIWpD2NmbVNlSP6wUofTX7cyoBNLJNKVmfsUv1M88zws2bLc+9heiAB+R17Nzewar8RLSLHupkf3TY9JHAS+4+O/lbc+LXs1lEI0MIngjrhApCxmcS7YLrUlJTUXsLicKR3o696sgYubW0QCBJYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720166054; c=relaxed/simple;
	bh=oo2/ZfPMt+FWha77yO+QS7iVUOjjLf4OZJnsxWDnnYo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=q4yFLb0TYIdgXrVyYIkmTNKLh93ezPmblDDe4MIyrfSGaIpv9Vu4DLeu5J23m5paI+7KkZndedLFIxa1ldPQ49oiPVdco7KfKSCBfcT8rQT/4Ma7pZMvD/DwwA9Rx3nLUapAfwbh18GI8RkQlb4LWM9KuQO+o5qBsApdLKbnL44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fWkvueOw; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fWkvueOw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1720166052; x=1751702052;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=oo2/ZfPMt+FWha77yO+QS7iVUOjjLf4OZJnsxWDnnYo=;
  b=fWkvueOw+x468swlAT6vbqjZ8nvTB+RsGy+Pp3iQ/bHgLibj7rR6hvSv
   GoEsqDtTFWF8jAmpAOSC/j5QNIgQyaFXzIBK8IAeAjpVBm48tbXfYwAAR
   zFPJv9l4I65UhMbYlYpYuI2PIxk4J/YIFidPbmRvkXOgWd8nFMwE4iHck
   uARwiRDy89d6EUTTmBUiQhqyE5Yta2qaMpl+qXFhmusuNXtMnHxFT4iIl
   +PyXCtlHBz1jCdcZ0RcAFaHvgIUdf+OczPbBUQ3uIYpiwNSInQzZTn4U0
   v60VEcEaMEPsU2uBrMyXHmNRX3761eBBYt3X+KfJbBHHsZTBjkYKMkiNW
   A==;
X-CSE-ConnectionGUID: XL+s8xEmTAqJEzFgg256GQ==
X-CSE-MsgGUID: PHN5zXkBSFO6PW7OEvVj7A==
X-IronPort-AV: E=McAfee;i="6700,10204,11123"; a="34892873"
X-IronPort-AV: E=Sophos;i="6.09,184,1716274800"; 
   d="scan'208";a="34892873"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2024 00:53:42 -0700
X-CSE-ConnectionGUID: IANxxJSMTfy4900/aewpDA==
X-CSE-MsgGUID: dDsjS/9pRzaAksescHjzvw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,184,1716274800"; 
   d="scan'208";a="46918563"
Received: from mehlow-prequal01.jf.intel.com ([10.54.102.156])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2024 00:53:42 -0700
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
Subject: [PATCH v4 0/3] x86/sgx: Fix two data races in EAUG/EREMOVE flows
Date: Fri,  5 Jul 2024 00:45:21 -0700
Message-Id: <20240705074524.443713-1-dmitrii.kuvaiskii@intel.com>
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

v1: https://lore.kernel.org/all/20240429104330.3636113-3-dmitrii.kuvaiskii@intel.com/
v2: https://lore.kernel.org/all/20240515131240.1304824-1-dmitrii.kuvaiskii@intel.com/
v3: https://lore.kernel.org/all/20240517110631.3441817-1-dmitrii.kuvaiskii@intel.com/

Dmitrii Kuvaiskii (3):
  x86/sgx: Split SGX_ENCL_PAGE_BEING_RECLAIMED into two flags
  x86/sgx: Resolve EAUG race where losing thread returns SIGBUS
  x86/sgx: Resolve EREMOVE page vs EAUG page data race

 arch/x86/kernel/cpu/sgx/encl.c  | 23 ++++++++++++-----------
 arch/x86/kernel/cpu/sgx/encl.h  | 10 ++++++++--
 arch/x86/kernel/cpu/sgx/ioctl.c |  7 +++++++
 arch/x86/kernel/cpu/sgx/main.c  |  4 ++--
 4 files changed, 29 insertions(+), 15 deletions(-)

-- 
2.43.0

