Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97701223706;
	Mon, 10 Mar 2025 08:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741596156; cv=none; b=YB2ELOJr1ESfVSx/0vBAvtlGuiWLM1zL8GdbfVM3Q6gnrKq0LUHz43qb8QVDfrx8E5HADn2Hv03CmVeJi6sUpujGErmo7JeTJov3zIMLntdygIhWCepnghj8kNsyh3bvp5Vzpq5IIzQtVmh4GjZTI1vYBWqz7sfxOvGsLO+onQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741596156; c=relaxed/simple;
	bh=ZGGntPjsCyYb/Jm7tB8b/sjMmcPSAq01Cv44HcpGxEg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o8CMq80U+3ydPliA4L1ONiO/FsvMFNeNjSOk2uFYXq3qIJwQhLSi3K5VPJOB5wEmNZmry8Ar4IltPjl6plqYhKH6rg5obtkb9vfTXSCZd13p729anPwTU6LvT7E+h0/00urxEBNr8U5ozS9zm37YHfb5Hh4zfJms336Aq9Vfkuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nSZi0KGd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nSZi0KGd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CE7FC4CEE5;
	Mon, 10 Mar 2025 08:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741596155;
	bh=ZGGntPjsCyYb/Jm7tB8b/sjMmcPSAq01Cv44HcpGxEg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nSZi0KGdMx59+kT/EtfX5i3FYs6DEkLL/1Wxb3sOWbrE/qxah/c7o5lLgpHf46Lov
	 /bQ0QNTjMbJkNtvkYbhtp+vWP0loZZIobFowh85fx24O7UEGDBAuz+P2QBHO/yb9Zz
	 rrumMy23wzIaiPLMcDYOBmGsPoq9G5dao/4YVjGDgaC99UOlLSM8gIV6Qa2fCUB+Sc
	 OMfeNqZeuStXBcPc+f1wilAkOzaU9zcP8S2b4vPij/BA8XlqdBtPUxD4oijGJY2r93
	 sXQzEB+908ptkKBrK9jQgjuKWwgP81OBe64rN3HqrMFqxTjZM+m99b3B3CMEkX55Yq
	 4SyPkYULV+0JA==
Date: Mon, 10 Mar 2025 09:42:29 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "Huang, Kai" <kai.huang@intel.com>
Cc: "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"vdronov@redhat.com" <vdronov@redhat.com>,
	"jarkko@kernel.org" <jarkko@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>,
	"hpa@zytor.com" <hpa@zytor.com>,
	"mingo@redhat.com" <mingo@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>
Subject: [PATCH -v3] x86/sgx: Warn explicitly if X86_FEATURE_SGX_LC is not
 enabled
Message-ID: <Z86l9WiiP_4bFC8q@gmail.com>
References: <20250309172215.21777-2-vdronov@redhat.com>
 <c21c89d29f006945b6be7624599809b36574530e.camel@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c21c89d29f006945b6be7624599809b36574530e.camel@intel.com>


* Huang, Kai <kai.huang@intel.com> wrote:

> On Sun, 2025-03-09 at 18:22 +0100, Vladis Dronov wrote:
> > A kernel requires X86_FEATURE_SGX_LC to be able to create SGX enclaves.
> 
> The kernel requires ...
> 
> > There is quite a number of hardware which has X86_FEATURE_SGX but not
> > X86_FEATURE_SGX_LC. A kernel running on such a hardware does not create
> > /dev/sgx_enclave file silently. Explicitly warn if X86_FEATURE_SGX_LC
> > is not enabled to properly nofity a user about this condition.
> 			     ^
> 			     notify
> 
> And I don't think "notify" is correct because the reality is the 
> kernel only prints some error message so that the user can check and 
> see when it wants.
> 
> How about:
> 
> Explicitly print error message if X86_FEATURE_SGX_LC is not present 
> so that the users can be aware of this condition which results in SGX 
> driver being disabled.
> 
> > 
> > The X86_FEATURE_SGX_LC is a CPU feature that enables LE hash MSRs to be
> > writable when running native enclaves, i.e. using a custom root key rather
> > than the Intel proprietary key for enclave signing.
> 
> Using "root key" can be controversial.  Let's just say "key" instead.
> 
> And the X86_FEATURE_SGX_LC feature itself doesn't automatically enable LE MSRs
> to be writable.  We still need to opt-in in the 'feature control' MSR.

Why would it be controversial?

> How about:
> 
> The X86_FEATURE_SGX_LC, a.k.a. SGX Launch Control, is a CPU feature 
> that enables LE (Launch Enclave) hash MSRs to be writable (with 
> additional opt-in required in the 'feature control' MSR) when running 
> enclaves, i.e., using a custom key rather than the Intel proprietary 
> key for enclave signing.


> > Signed-off-by: Vladis Dronov <vdronov@redhat.com>
> 
> I think this message will be useful for someone who knows SGX in 
> general but doesn't know that Linux SGX driver requires the LE MSRs 
> to be writable, thus requires the CPU supports SGX_LC feature bit.
> 
> With the above addressed, feel free to add:
> 
> Acked-by: Kai Huang <kai.huang@intel.com>

Thanks, I've edited the changelog to be a bit clearer.

I also added an error message when the driver fails to register, and 
made all 3 failure error messages consistent and refer back to the 
/dev/sgx_enclave device node name.

I also included part of this commit message note:

> > an out-of-commit-message note:
> > 
> > I've hit this issue myself and have spent some time researching where is
> > my /dev/sgx_enclave file on an SGX-enabled hardware, so this is a bit
> > personal.
> > 
> > Links related:
> > https://github.com/intel/linux-sgx/issues/837
> > https://patchwork.kernel.org/project/platform-driver-x86/patch/20180827185507.17087-3-jarkko.sakkinen@linux.intel.com/

Because this experience reflects arguably poor usability: people see 
'SGX' in their /proc/cpuinfo file, think that their hardware is 'SGX 
enabled' and are wondering why the hell the /dev/sgx_enclave device 
node is not created, right?

I also Cc:-ed more SGX people.

See the full -v3 patch below.

Is the device node misnamed, should it be /dev/sgx_lc_enclave? Should 
we hide the SGX feature bit from cpuinfo when SGX_LC is not present, so 
that people don't go on a wild goose chase?

Thanks,

	Ingo

======================================>
From: Vladis Dronov <vdronov@redhat.com>
Date: Sun, 9 Mar 2025 18:22:16 +0100
Subject: [PATCH] x86/sgx: Warn explicitly if X86_FEATURE_SGX_LC is not enabled

The kernel requires X86_FEATURE_SGX_LC to be able to create SGX enclaves,
not just X86_FEATURE_SGX.

There is quite a number of hardware which has X86_FEATURE_SGX but not
X86_FEATURE_SGX_LC. A kernel running on such hardware does not create
the /dev/sgx_enclave file and does so silently.

Explicitly warn if X86_FEATURE_SGX_LC is not enabled to properly notify
users that the kernel disabled the SGX driver.

The X86_FEATURE_SGX_LC, a.k.a. SGX Launch Control, is a CPU feature
that enables LE (Launch Enclave) hash MSRs to be writable (with
additional opt-in required in the 'feature control' MSR) when running
enclaves, i.e. using a custom root key rather than the Intel proprietary
key for enclave signing.

I've hit this issue myself and have spent some time researching where
my /dev/sgx_enclave file went on SGX-enabled hardware.

Related links:

  https://github.com/intel/linux-sgx/issues/837
  https://patchwork.kernel.org/project/platform-driver-x86/patch/20180827185507.17087-3-jarkko.sakkinen@linux.intel.com/

[ mingo: Made the error message a bit more verbose, and added other cases
         where the kernel fails to create the /dev/sgx_enclave device node. ]

Signed-off-by: Vladis Dronov <vdronov@redhat.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Kai Huang <kai.huang@intel.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20250309172215.21777-2-vdronov@redhat.com
---
 arch/x86/kernel/cpu/sgx/driver.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx/driver.c
index 22b65a5f5ec6..40c3347ac65d 100644
--- a/arch/x86/kernel/cpu/sgx/driver.c
+++ b/arch/x86/kernel/cpu/sgx/driver.c
@@ -150,13 +150,15 @@ int __init sgx_drv_init(void)
 	u64 xfrm_mask;
 	int ret;
 
-	if (!cpu_feature_enabled(X86_FEATURE_SGX_LC))
+	if (!cpu_feature_enabled(X86_FEATURE_SGX_LC)) {
+		pr_err("SGX disabled: SGX launch control CPU feature is not available, /dev/sgx_enclave disabled.\n");
 		return -ENODEV;
+	}
 
 	cpuid_count(SGX_CPUID, 0, &eax, &ebx, &ecx, &edx);
 
 	if (!(eax & 1))  {
-		pr_err("SGX disabled: SGX1 instruction support not available.\n");
+		pr_err("SGX disabled: SGX1 instruction support not available, /dev/sgx_enclave disabled.\n");
 		return -ENODEV;
 	}
 
@@ -173,8 +175,10 @@ int __init sgx_drv_init(void)
 	}
 
 	ret = misc_register(&sgx_dev_enclave);
-	if (ret)
+	if (ret) {
+		pr_err("SGX disabled: Unable to register the /dev/sgx_enclave driver (%d).\n", ret);
 		return ret;
+	}
 
 	return 0;
 }
