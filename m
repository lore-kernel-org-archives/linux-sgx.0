Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34893200DD;
	Fri, 17 May 2024 11:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715944495; cv=none; b=Eboowt7TDe7a9g1bVHZOIzS5b70UVHA3oYNm/AY3I4B2/d4Xm7lj2FPagI5R/b+e75y3w4f9jX/8dEo1Ut+LghuOZHfnZ31sgLr9lY3XVPYaGlhUkHYNNvfzbOp0cabh5K4rN7QCV/gnSeFaeFZIx2wNY0gYmf+FbclIQFKvk6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715944495; c=relaxed/simple;
	bh=zHBiwgBwI9p6Yh7J+Nq4X1m3JqYe0I65Qo5yh4G6VNU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=b1yq4cItO2I0rUj6z36H1FlzuO+LFQAq0oAyKnciFAP6Bs/Jh8a+FLu9kI+XHpRu4hgRRdyHAeBkjbP2zVF5oPYT4N7gscZDYEjMe+VAygXz8xowDG4EX6V1BrUjLc33Ms8PLLooy6rlpwZ53sHDcSYbHeBn82ZceIXvvu72i8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bSUBJh8A; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bSUBJh8A"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715944493; x=1747480493;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=zHBiwgBwI9p6Yh7J+Nq4X1m3JqYe0I65Qo5yh4G6VNU=;
  b=bSUBJh8A4WPqIPsWOG1m7YIpcXF0Fi6G2k1ILUzu5KPcSh6rESiIlruH
   c4PAwv/JFO2KbAfrh3a9Z8nt30eB4frMQ1F+WLIhHz6Ek4kbOpWEhzrXM
   p0ykwDCwVfDGtk1T42tK/JnZe/rFIVMLvjGnqCgVfBu9susYVT1WrVB2U
   599ftL+wLtrdYKAIv5cvnubiqfpI/1QJkdMVgMfkKpli2WrcW3yuipvvo
   uxTmMLqGpKh+vx8wr/3bjgKGDLlPuJG7/ta+5P+ulNsjNsAV5eAqehd8j
   UYswU5okIcc02lxnXVB4SnN/mLSwoVGxFhjPndNHKYSJ0NH/g1xVlE1kd
   A==;
X-CSE-ConnectionGUID: Gba/Pq+LSTaqFIspPSM7wg==
X-CSE-MsgGUID: hV2ZOtNkTfqRZc6zPe+vYw==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="23529049"
X-IronPort-AV: E=Sophos;i="6.08,167,1712646000"; 
   d="scan'208";a="23529049"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2024 04:14:52 -0700
X-CSE-ConnectionGUID: Lvwk0yrGQyOgmsh6VeHWfw==
X-CSE-MsgGUID: U9fACi/rScGmmmrWSpV6fw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,167,1712646000"; 
   d="scan'208";a="36276847"
Received: from mehlow-prequal01.jf.intel.com ([10.54.102.156])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 May 2024 04:14:52 -0700
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
Subject: [PATCH v3 0/2] x86/sgx: Fix two data races in EAUG/EREMOVE flows
Date: Fri, 17 May 2024 04:06:29 -0700
Message-Id: <20240517110631.3441817-1-dmitrii.kuvaiskii@intel.com>
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

v2 -> v3:
- No changes in code itself
- Improved commit message of the first patch (text suggested by Dave
  Hansen); kept the CPU1 vs CPU2 diagram (as all reviewers liked it)
- No changes in the commit message of the second patch

v1 -> v2:
- No changes in code itself
- Expanded cover letter
- Added CPU1 vs CPU2 race scenarios in commit messages

v1: https://lore.kernel.org/all/20240429104330.3636113-3-dmitrii.kuvaiskii@intel.com/
v2: https://lore.kernel.org/all/20240515131240.1304824-1-dmitrii.kuvaiskii@intel.com/

Dmitrii Kuvaiskii (2):
  x86/sgx: Resolve EAUG race where losing thread returns SIGBUS
  x86/sgx: Resolve EREMOVE page vs EAUG page data race

 arch/x86/kernel/cpu/sgx/encl.c  | 10 +++++++---
 arch/x86/kernel/cpu/sgx/encl.h  |  3 +++
 arch/x86/kernel/cpu/sgx/ioctl.c |  1 +
 3 files changed, 11 insertions(+), 3 deletions(-)

-- 
2.34.1

