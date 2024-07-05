Received: from meesny.iki.fi (meesny.iki.fi [195.140.195.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E6751474CE;
	Fri,  5 Jul 2024 09:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=195.140.195.201
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720170202; cv=pass; b=PXvdbJTngx7ADnCfX3/zD/zjkhiHYUKAOztXGH86e3eW2gvoMG1+iaoYFZh/wOgyg5xapuXNEFN+YWA6szigJmfccJ0Yt19z8nhbP3eiegoxicNSiYH5CGM/OjNkkbsOpwWFSnQg5XXj43yo6nTkrr6kin3HVs9naKpfewlcgv8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720170202; c=relaxed/simple;
	bh=8+MPIa+QFHPojOhG4/PGXoi1NyXjFwgbs1AXRxKS0wY=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=HoabqRHsq8o9O5/WCaAhIJZVXJp061hMRrW1aFMdN0OJdzyJVdY8zfwa8YONkFTBB6AC7zYNf2RroUwRBYiy4AZlMlITlyolY5Az3kUIuoYUts+HGQ9VpalpN2ZA8GwR0LROrkn8aeat6PFRD+JAVG0RUxItVtQBdIJXT0FI9aI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi; spf=pass smtp.mailfrom=iki.fi; dkim=pass (1024-bit key) header.d=iki.fi header.i=@iki.fi header.b=uWteXpQn; arc=pass smtp.client-ip=195.140.195.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iki.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=iki.fi header.i=@iki.fi header.b="uWteXpQn"
Received: from localhost (83-245-197-232.elisa-laajakaista.fi [83.245.197.232])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: sakkinen)
	by meesny.iki.fi (Postfix) with ESMTPSA id 4WFnc341WyzyV4;
	Fri,  5 Jul 2024 12:03:15 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=meesny;
	t=1720170195;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NRIxFmX0HciWT3BKUxdDL60Eb2XNEjrelJv/a0Vvjik=;
	b=uWteXpQnrzHA6P+W1eJKNT+ShroPCR3xpFCSBn2nzz+KdSnoNqCQJTlEVVQW0XoJihHGuc
	0rKkipYAgVmNPC07DxR3YTdjtug709wxYlLSX5QF+6WJjPQrRaz1Zt7pWENMP2CLfw8Jwq
	4jQQJ2UNVfg/Jksc6KQ/5Yj5PUVKA0c=
ARC-Seal: i=1; s=meesny; d=iki.fi; t=1720170195; a=rsa-sha256; cv=none;
	b=Kgelw//WEm3nAyguMYWtLc/hFBxO5DBMKkwQHqprb77WrmhERKTUBq40TrqYEifCxbPpK8
	RtKehDbyvMJZew3UxsHQ+s6zPGCeh1FVyf+yZf3u9gbKeIZOl3aBiSw0iwSHEsP3+doKKm
	oIyumwlIFPJqxsojmGIVNnKc+LmKvZw=
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=sakkinen smtp.mailfrom=jarkko.sakkinen@iki.fi
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
	s=meesny; t=1720170195;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NRIxFmX0HciWT3BKUxdDL60Eb2XNEjrelJv/a0Vvjik=;
	b=OiDA3IDYx3viKr2IYnrNQrZHUUxFHEpRcHg1g+BuWFfANO3Caj84bRnz9HwvhYkgRcLuci
	0is0UD21aaKL6AsPvHfUmwAtjnqU9QwDD53QXoziICP1WYY8MvYL28665YyEDI8DVFY/Ev
	s68hK/aOXOd5q6oSfMCEC7U9Ol3Dr3E=
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 05 Jul 2024 12:03:15 +0300
Message-Id: <D2HHFYB7GY0D.4VKDG5GEMUS2@iki.fi>
Cc: <mona.vij@intel.com>, <kailun.qin@intel.com>
Subject: Re: [PATCH v4 0/3] x86/sgx: Fix two data races in EAUG/EREMOVE
 flows
From: "Jarkko Sakkinen" <jarkko.sakkinen@iki.fi>
To: "Dmitrii Kuvaiskii" <dmitrii.kuvaiskii@intel.com>,
 <dave.hansen@linux.intel.com>, <jarkko@kernel.org>, <kai.huang@intel.com>,
 <haitao.huang@linux.intel.com>, <reinette.chatre@intel.com>,
 <linux-sgx@vger.kernel.org>, <linux-kernel@vger.kernel.org>
X-Mailer: aerc 0.17.0
References: <20240705074524.443713-1-dmitrii.kuvaiskii@intel.com>
In-Reply-To: <20240705074524.443713-1-dmitrii.kuvaiskii@intel.com>

On Fri Jul 5, 2024 at 10:45 AM EEST, Dmitrii Kuvaiskii wrote:
> SGX runtimes such as Gramine may implement EDMM-based lazy allocation of
> enclave pages and may support MADV_DONTNEED semantics [1]. The former
> implies #PF-based page allocation, and the latter implies the usage of
> SGX_IOC_ENCLAVE_REMOVE_PAGES ioctl.
>
> EDMM-based lazy allocation and MADV_DONTNEED semantics provide
> significant performance improvement for some workloads that run on
> Gramine. For example, a Java workload with a 16GB enclave size has
> approx. 57x improvement in total runtime. Thus, we consider it important
> to permit these optimizations in Gramine. However, we observed hangs of
> applications (Node.js, PyTorch, R, iperf, Blender, Nginx) when run on
> Gramine with EDMM, lazy allocation and MADV_DONTNEED features enabled.
>
> We wrote a trivial stress test to reproduce the hangs observed in
> real-world applications. The test stresses #PF-based page allocation and
> SGX_IOC_ENCLAVE_REMOVE_PAGES flows in the SGX driver:
>
> /* repeatedly touch different enclave pages at random and mix with
>  * madvise(MADV_DONTNEED) to stress EAUG/EREMOVE flows */
> static void* thread_func(void* arg) {
>     size_t num_pages =3D 0xA000 / page_size;
>     for (int i =3D 0; i < 5000; i++) {
>         size_t page =3D get_random_ulong() % num_pages;
>         char data =3D READ_ONCE(((char*)arg)[page * page_size]);
>
>         page =3D get_random_ulong() % num_pages;
>         madvise(arg + page * page_size, page_size, MADV_DONTNEED);
>     }
> }
>
> addr =3D mmap(NULL, 0xA000, PROT_READ | PROT_WRITE, MAP_ANONYMOUS, -1, 0)=
;
> pthread_t threads[16];
> for (int i =3D 0; i < 16; i++)
>     pthread_create(&threads[i], NULL, thread_func, addr);
>
> This test uncovers two data races in the SGX driver. The remaining
> patches describe and fix these races.
>
> I performed several stress tests to verify that there are no other data
> races (at least with the test program above):
>
> - On Icelake server with 128GB of PRM, without madvise(). This stresses
>   the first data race. A Gramine SGX test suite running in the
>   background for additional stressing. Result: 1,000 runs without hangs
>   (result without the first bug fix: hangs every time).
> - On Icelake server with 128GB of PRM, with madvise(). This stresses the
>   second data race. A Gramine SGX test suite running in the background
>   for additional stressing. Result: 1,000 runs without hangs (result
>   with the first bug fix but without the second bug fix: hangs approx.
>   once in 50 runs).
> - On Icelake server with 4GB of PRM, with madvise(). This additionally
>   stresses the enclave page swapping flows. Two Gramine SGX test suites
>   running in the background for additional stressing of swapping (I
>   observe 100% CPU utilization from ksgxd which confirms that swapping
>   happens). Result: 1,000 runs without hangs.
>
> v3 -> v4:
> - Added a preparatory patch to split the SGX_ENCL_PAGE_BEING_RECLAIMED
>   flag into two: SGX_ENCL_PAGE_BUSY and SGX_ENCL_PAGE_PCMD_BUSY
>   (split suggested by Dave Hansen [2])
> - No changes in the second patch (that fixes the first bug)
> - Trivial changes in the third patch (that fixes the second bug), now
>   that we have a preparatory patch; plus expanded a comment (as
>   suggested by Dave Hansen)
>
> v2 -> v3:
> - No changes in code itself
> - Improved commit message of the first patch (text suggested by Dave
>   Hansen); kept the CPU1 vs CPU2 diagram (as all reviewers liked it)
> - No changes in the commit message of the second patch
>
> v1 -> v2:
> - No changes in code itself
> - Expanded cover letter
> - Added CPU1 vs CPU2 race scenarios in commit messages
>
> [1] https://github.com/gramineproject/gramine/pull/1513
> [2] https://lore.kernel.org/all/1d405428-3847-4862-b146-dd57711c881e@inte=
l.com/
>
> v1: https://lore.kernel.org/all/20240429104330.3636113-3-dmitrii.kuvaiski=
i@intel.com/
> v2: https://lore.kernel.org/all/20240515131240.1304824-1-dmitrii.kuvaiski=
i@intel.com/
> v3: https://lore.kernel.org/all/20240517110631.3441817-1-dmitrii.kuvaiski=
i@intel.com/
>
> Dmitrii Kuvaiskii (3):
>   x86/sgx: Split SGX_ENCL_PAGE_BEING_RECLAIMED into two flags
>   x86/sgx: Resolve EAUG race where losing thread returns SIGBUS
>   x86/sgx: Resolve EREMOVE page vs EAUG page data race
>
>  arch/x86/kernel/cpu/sgx/encl.c  | 23 ++++++++++++-----------
>  arch/x86/kernel/cpu/sgx/encl.h  | 10 ++++++++--
>  arch/x86/kernel/cpu/sgx/ioctl.c |  7 +++++++
>  arch/x86/kernel/cpu/sgx/main.c  |  4 ++--
>  4 files changed, 29 insertions(+), 15 deletions(-)

Piling this to my TODO folder, on holiday up until week 31.

Happened to see this as I'm doing some last bit release stuff for 6.10
(unrelated to SGX).

BR, Jarkko
