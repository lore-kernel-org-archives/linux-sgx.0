Received: from smtpbgbr1.qq.com (smtpbgbr1.qq.com [54.207.19.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 140E874418;
	Sun, 25 Aug 2024 10:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.207.19.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724582870; cv=none; b=OqIhCfsUD7dXNXykT6qhVSTgtF42eguovk0B+g+p3YqAEj35c52coiCEM1qKzEKN+F3CLqrlmnzvhLB+d0FkSLM13UMjU25tAVJIjLP/35NeAzyj06Uw90shjWwclISTWx0mZib7oBkQzcOi+nYOkonKSU/jQLP4zhCLzKPqw9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724582870; c=relaxed/simple;
	bh=Hs8txYmClETIj7VMTgAg1LNHS+Qu1hpFkNh6v3fOqAA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oRCemKZzRYf4sLgsroREfMK/s/MWgD/JMgmYfxcfB0/+hElu9p7sAq2kzvRqFSkutwZgk9bOpVBi4/yze4cxPigA31dVGMC3CCLENSjrxkFeG12YXMHn9U2Vuhs0/ybRXx+mBZbmfHTe30iCS3bfGwNg2bO/SSYzm3AFHKZHVwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=op6AZPm7; arc=none smtp.client-ip=54.207.19.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="op6AZPm7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1724582858;
	bh=y5hcrGzatXkseHAxtnxhYe1zmrLtFaJr9NEoUCcFrs4=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=op6AZPm7sFn9k6HzZRtJ7diWwWiFHZqsNljBRTiGiNIA42BK7rQgmt6o4p6MCM+Ey
	 Wv1Hb/LRJ/lc6myCVri8sl75fTjmcUaHmbK8vgv4RXtaUICXcK8aiTdmvds9k9BtAV
	 czR6YjX9wsRPsTOuDMz0F63erW2DSrikFs1zW1bs=
X-QQ-mid: bizesmtp91t1724582818tp36isx7
X-QQ-Originating-IP: gHw6+VBjdY/Q7DpBogLWxNCSHvAyDOUcTgMJHuHh8f8=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sun, 25 Aug 2024 18:46:55 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 18098951403119421999
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
Subject: [PATCH v4] x86/cpu: Adjust the error message when BIOS does not support SGX
Date: Sun, 25 Aug 2024 18:46:53 +0800
Message-ID: <F8D977CB368423F3+20240825104653.1294624-1-wangyuli@uniontech.com>
X-Mailer: git-send-email 2.43.4
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:uniontech.com:qybglogicsvrgz:qybglogicsvrgz8a-1

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
Co-developed-by: Zelong Xiang <xiangzelong@uniontech.com>
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

