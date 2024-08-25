Received: from smtpbguseast3.qq.com (smtpbguseast3.qq.com [54.243.244.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A332D6F2F8;
	Sun, 25 Aug 2024 08:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.243.244.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724573927; cv=none; b=mBt1T1dQ0zGeMGqFcjo2zfFtFl17bTJguKAOfPcPyJd3sXvQKgZA1QguFbaIMTiiB4SJTaFJV0SLwIjPN/YdaeTzkl/lHN9cK0eeXzkuLOpIwM5SP3VHoEVmMrkL4akDZgrw25MDDfteaPR4xQUWaH7UvSW5ZNzusd85+HduUs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724573927; c=relaxed/simple;
	bh=PptGPdsSiCxQygWbPxjtc8rFKK839L3jUNBstFDR5ps=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SL9GXVRM+NUpy2ZQ09xSoUJeOG4LevNp3xZd8SCPJE+LxTDnf0aM3PHjkmDtI+DCf6/mgnTK/qKbCs4MkqXfZNbzAQNLlCI0VXFpbOlBh9qvm4Q2j3GSqdDKgMG+OuZGqXtVfDDUqkaFgLWPhS0hw9I2Dd0Q2Ve6HouF642DErU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=de6NWhhs; arc=none smtp.client-ip=54.243.244.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="de6NWhhs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1724573914;
	bh=FpY/AOVbICm4AfOKvhjlskWc6vstiHFw82BA0qUrDLE=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=de6NWhhsNgviI2aJXgINB0i/eRW/KsKJ7z8LD1I1rVsZZppw9YVWipFg6LWwVob95
	 qAgolLpvYWUQAR1ATD1uRxKAEA0OmULNI0TXKvAfsxvEooFL+RJuZIC2JRwkTwwrTB
	 FwgCX57BF1TImCWBynDlXXmbsPC9JG3iSrRwzgk0=
X-QQ-mid: bizesmtpsz14t1724573873t7wkdx
X-QQ-Originating-IP: FbvOgYpWR+t2y1aEU38HPmN+G7PdIf74VUwR0lU0jCk=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sun, 25 Aug 2024 16:17:51 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 14574832690500442864
From: WangYuli <wangyuli@uniontech.com>
To: tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	wangyuli@uniontech.com,
	seanjc@google.com,
	xiangzelong@uniontech.com
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	wubo@uniontech.com,
	guanwentao@uniontech.com,
	linux-sgx@vger.kernel.org,
	jarkko@kernel.org,
	haitao.huang@linux.intel.com,
	sean.j.christopherson@intel.com,
	kai.huang@intel.com,
	bp@suse.de
Subject: [PATCH v3] x86/cpu: Adjust the error message when BIOS does not support SGX
Date: Sun, 25 Aug 2024 16:17:41 +0800
Message-ID: <2FA59E9E3461354C+20240825081741.3890887-1-wangyuli@uniontech.com>
X-Mailer: git-send-email 2.43.4
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz8a-1

When SGX is not supported by the BIOS, the kernel log still output
the error 'SGX disabled by BIOS', which can be confusing since
there might not be an SGX-related option in the BIOS settings.

As a kernel, it's difficult to distinguish between the BIOS not
supporting SGX and the BIOS supporting SGX but it's disabled.

Therefore, update the error message to
'SGX disabled or unsupported by BIOS' to make it easier for those
reading kernel logs to understand what's happening.

Reported-by: Bo Wu <wubo@uniontech.com>
Closes: https://github.com/linuxdeepin/developer-center/issues/10032
Acked-by: Kai Huang <kai.huang@intel.com>
Link: https://lore.kernel.org/all/a30f7700c7817b3e7e2f2bdb37d5c10a318b2c3b.camel@intel.com/
Signed-off-by: Zelong Xiang <xiangzelong@uniontech.com>
Signed-off-by: WangYuli <wangyuli@uniontech.com>
---
 arch/x86/kernel/cpu/feat_ctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/feat_ctl.c b/arch/x86/kernel/cpu/feat_ctl.c
index 1640ae76548f..4a4118784c13 100644
--- a/arch/x86/kernel/cpu/feat_ctl.c
+++ b/arch/x86/kernel/cpu/feat_ctl.c
@@ -188,7 +188,7 @@ void init_ia32_feat_ctl(struct cpuinfo_x86 *c)
 update_sgx:
 	if (!(msr & FEAT_CTL_SGX_ENABLED)) {
 		if (enable_sgx_kvm || enable_sgx_driver)
-			pr_err_once("SGX disabled by BIOS.\n");
+			pr_err_once("SGX disabled or unsupported by BIOS.\n");
 		clear_cpu_cap(c, X86_FEATURE_SGX);
 		return;
 	}
-- 
2.43.4

