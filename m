Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 727F62F39BC
	for <linux-sgx@vger.kernel.org>; Mon, 22 Sep 2025 13:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758547155; cv=none; b=CeVEM6fLxm4ywMRN7pHWTahJ/WsktEtafgwbFSC+z0OWC5cAqTwWns/Ua/1zsW5k5++MknD/3yjAGTtt8bTcIR7VabDyufHDsrjsg0F+GUfcP6SeQMK2n5FMxd+N7ZZYkOZUVZPc7Wy2zRY0FKStq9h38aZjplfvSA1QHSdDX/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758547155; c=relaxed/simple;
	bh=Qlj6gaE9A3b/2DQd1Cft33Y3zpGVy37xNiChJRZHnFI=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=bF4u37vJuyWeEX8LcETy50ebOSfgdsSxD6xMDXpuaykS24+5aBTT0Rtn2RCndPOv5guTfDrqQM1E/N0C4QfSXoYGn6eBvv68EhJtuXcxqz/ct0scZrgTyTREaZZ9YWUGBj2YS35vf2ZxHjFWzFS/j4iqCIgQQBU1SFUf1ICZC3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XdpMsSRN; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XdpMsSRN"
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758547151;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zlmjGFwPRx/6689gSNpnlgqIexE5fznTKNN/tGQTJOs=;
	b=XdpMsSRNcLzC5z0tZLLNTX0TumZKf2Z9vVqzFbGzojmX3dApClYyjhmijC6lC1uGW+/fby
	SO0aglr9HnOfI+bDjje/ng1mZAyn6zGWBHfL6TzPuxK5ij4t9RddjMmCWq1+42DGvu6j44
	Mhz6F1WJ+HLWmL04ti36z36c9sBqQvc=
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81\))
Subject: Re: [PATCH] x86/sgx: Replace kmalloc() + copy_from_user() with
 memdup_user()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Thorsten Blum <thorsten.blum@linux.dev>
In-Reply-To: <202509211747.1edb60f-lkp@intel.com>
Date: Mon, 22 Sep 2025 15:18:32 +0200
Cc: oe-lkp@lists.linux.dev,
 lkp@intel.com,
 linux-sgx@vger.kernel.org,
 Jarkko Sakkinen <jarkko@kernel.org>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>,
 x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <9A7F15AA-836C-457B-BFD9-B37497B16A27@linux.dev>
References: <202509211747.1edb60f-lkp@intel.com>
To: kernel test robot <oliver.sang@intel.com>
X-Migadu-Flow: FLOW_OUT

On 21. Sep 2025, at 11:59, kernel test robot wrote:
>=20
> kernel test robot noticed =
"kernel-selftests.sgx.test_sgx.enclave.tcs_entry.fail" on:
>=20
> commit: c407010c166bcf30f9400bf0a4a4ec81c0149b81 ("[PATCH] x86/sgx: =
Replace kmalloc() + copy_from_user() with memdup_user()")
> url: =
https://github.com/intel-lab-lkp/linux/commits/Thorsten-Blum/x86-sgx-Repla=
ce-kmalloc-copy_from_user-with-memdup_user/20250909-041627
> base: https://git.kernel.org/cgit/linux/kernel/git/tip/tip.git =
ed16618c380c32c68c06186d0ccbb0d5e0586e59
> patch link: =
https://lore.kernel.org/all/20250908201229.440105-2-thorsten.blum@linux.de=
v/
> patch subject: [PATCH] x86/sgx: Replace kmalloc() + copy_from_user() =
with memdup_user()
>=20
> in testcase: kernel-selftests
> version: kernel-selftests-x86_64-79e8447ec662-1_20250914
> with following parameters:
>=20
> group: sgx
>=20
>=20
>=20
> config: x86_64-rhel-9.4-kselftests
> compiler: gcc-14
> test machine: 16 threads 1 sockets Intel(R) Xeon(R) E-2278G CPU @ =
3.40GHz (Coffee Lake-E) with 32G memory
>=20
> (please refer to attached dmesg/kmsg for entire log/backtrace)
>=20
>=20
>=20
> If you fix the issue in a separate patch/commit (i.e. not just a new =
version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <oliver.sang@intel.com>
> | Closes: =
https://lore.kernel.org/oe-lkp/202509211747.1edb60f-lkp@intel.com
>=20
>=20
> besides, we also observed below tests failed on this commit while =
passing
> without this patch.
>=20
> =
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> tbox_group/testcase/rootfs/kconfig/compiler/group:
>  =
lkp-cfl-e1/kernel-selftests/debian-13-x86_64-20250902.cgz/x86_64-rhel-9.4-=
kselftests/gcc-14/sgx
>=20
> ed16618c380c32c6 c407010c166bcf30f9400bf0a4a
> ---------------- ---------------------------
>       fail:runs  %reproduction    fail:runs
>           |             |             |
>           :6          100%           6:6     =
kernel-selftests.sgx.test_sgx.enclave.clobbered_vdso.fail
>           :6          100%           6:6     =
kernel-selftests.sgx.test_sgx.enclave.clobbered_vdso_and_user_function.fai=
l
>           :6          100%           6:6     =
kernel-selftests.sgx.test_sgx.enclave.pte_permissions.fail
>           :6          100%           6:6     =
kernel-selftests.sgx.test_sgx.enclave.tcs_entry.fail
>           :6          100%           6:6     =
kernel-selftests.sgx.test_sgx.enclave.unclobbered_vdso.fail
>           :6          100%           6:6     =
kernel-selftests.sgx.test_sgx.enclave.unclobbered_vdso_oversubscribed.fail=

>           :6          100%           6:6     =
kernel-selftests.sgx.test_sgx.fail
>=20
>=20
>=20
> # #  RUN           enclave.tcs_entry ...
> # SGX_IOC_ENCLAVE_CREATE failed: Input/output error
> # # main.c:231:tcs_entry:0x0000000000000000 0x0000000000002000 0x03
> # # main.c:231:tcs_entry:0x0000000000002000 0x0000000000002000 0x05
> # # main.c:231:tcs_entry:0x0000000000004000 0x0000000000007000 0x03
> # # main.c:231:tcs_entry:0x000000000000b000 0x0000000000001000 0x03
> # # main.c:246:tcs_entry:Failed to initialize the test enclave.
> # # main.c:578:tcs_entry:Expected 0 (0) !=3D =
setup_test_encl(ENCL_HEAP_SIZE_DEFAULT, &self->encl, _metadata) (0)
> # # tcs_entry: Test terminated by assertion
> # #          FAIL  enclave.tcs_entry
> # not ok 6 enclave.tcs_entry
>=20
>=20
>=20
> The kernel config and materials to reproduce are available at:
> =
https://download.01.org/0day-ci/archive/20250921/202509211747.1edb60f-lkp@=
intel.com

Can someone explain why this test is failing?

After some digging into SGX, I think it's the different allocators
kmalloc() vs. kmem_buckets_alloc_track_caller(), but I'm not exactly
sure why it fails.

Perhaps we should add a comment for anyone else trying to replace this?

Thanks,
Thorsten

