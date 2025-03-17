Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AD641C8606;
	Mon, 17 Mar 2025 16:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742229556; cv=none; b=R0ReXA2L09JwMss+TMktcCPqtSMv1UzZ1FPMM+cIP5FSpHMucfC+nNYwtwGIRT23SnEZrdOj9YxSoK97zbedMMSZX3wd7PErhSUeAZ7TM9cbe3TBnGNWCujjXGw53tPWGEXd/wBkMk70loCcTfGaYUn+3ycqKJdxXa2IFxYTpEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742229556; c=relaxed/simple;
	bh=XXCcsdAwzytddqhAwA49fnKFVQdrLseq3HIEZ7iGWFo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KkZinwQEeQk4HKRMNXFzlD+wtGJbX/4sHTzT7v96EnVxTYyk26AzmLoTwkV4ec/QHrqcWOEhlap0FNjL/YuJDczx/qZjMyDc1k0IhowJamy1e5YIixHds70+6IzWzRhmO9DWIIs/Sq794YRa0a3yVIt7zTJKN8LFWPwov4G2/40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cpt4YwFF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cpt4YwFF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CCADC4CEE3;
	Mon, 17 Mar 2025 16:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742229555;
	bh=XXCcsdAwzytddqhAwA49fnKFVQdrLseq3HIEZ7iGWFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cpt4YwFFGqPkumGE7Oq3HiiVKPh+Mb/E4+gL4mVY/wgD4eft1ni9YHjPe87Mo0EYl
	 ak3gF+so5i6TNDfDfD2k7D+NRWdMMN/EnWXYI3VQYy9ig27u3Bd3fTWmjz8qNdk7uB
	 ceujpl2yp3Ft71RxTC57lvT4qZV+yYqTH6VnxCLgwxuzy/FY2eTJW8mQJmPjwGFFMp
	 Uqif/tGwt3KY0aKWKlvVtLdVzLYj/4i/TqID7bwPZRK7S0Az9KkY1gFuVU6aOLrTJd
	 ovJqOCtRLh1m95Al1IHBZgHVir2YnHYeybbHjSW6EL8QDY+SxC/QS6e2R5SspFZiyp
	 MYRnfBx1LTy+g==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Vladis Dronov <vdronov@redhat.com>,
	Ingo Molnar <mingo@kernel.org>,
	Kai Huang <kai.huang@intel.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Andy Lutomirski <luto@kernel.org>,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	linux-sgx@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 5/8] x86/sgx: Warn explicitly if X86_FEATURE_SGX_LC is not enabled
Date: Mon, 17 Mar 2025 12:38:59 -0400
Message-Id: <20250317163902.1893378-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250317163902.1893378-1-sashal@kernel.org>
References: <20250317163902.1893378-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.83
Content-Transfer-Encoding: 8bit

From: Vladis Dronov <vdronov@redhat.com>

[ Upstream commit 65be5c95d08eedda570a6c888a12384c77fe7614 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/sgx/driver.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx/driver.c
index 262f5fb18d74d..c453953d5a33f 100644
--- a/arch/x86/kernel/cpu/sgx/driver.c
+++ b/arch/x86/kernel/cpu/sgx/driver.c
@@ -150,13 +150,15 @@ int __init sgx_drv_init(void)
 	u64 xfrm_mask;
 	int ret;
 
-	if (!cpu_feature_enabled(X86_FEATURE_SGX_LC))
+	if (!cpu_feature_enabled(X86_FEATURE_SGX_LC)) {
+		pr_info("SGX disabled: SGX launch control CPU feature is not available, /dev/sgx_enclave disabled.\n");
 		return -ENODEV;
+	}
 
 	cpuid_count(SGX_CPUID, 0, &eax, &ebx, &ecx, &edx);
 
 	if (!(eax & 1))  {
-		pr_err("SGX disabled: SGX1 instruction support not available.\n");
+		pr_info("SGX disabled: SGX1 instruction support not available, /dev/sgx_enclave disabled.\n");
 		return -ENODEV;
 	}
 
@@ -173,8 +175,10 @@ int __init sgx_drv_init(void)
 	}
 
 	ret = misc_register(&sgx_dev_enclave);
-	if (ret)
+	if (ret) {
+		pr_info("SGX disabled: Unable to register the /dev/sgx_enclave driver (%d).\n", ret);
 		return ret;
+	}
 
 	return 0;
 }
-- 
2.39.5

