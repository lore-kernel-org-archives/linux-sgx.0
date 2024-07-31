Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7707E1CA8D;
	Wed, 31 Jul 2024 15:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.254.200.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722439912; cv=none; b=g5A96V6RVgYE9GgObHnEw64swzXCE+Vg9/CxSLk8RQM7Gr1WLE20hlefbWb6n+fc/OxUh3GcuSQcc+zPwzWNjng3oiCbbmBZCsPPrkF5+lt0xT1HJigjGGunpnExEeGM5Rx4D0421hnp37jgnv0EILNeaKMaKrfV0QNLpebNzZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722439912; c=relaxed/simple;
	bh=f029rp9Bw1TatYvry41GCf7XcG1/8eD9SZHCSnp8L/w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IUniMQS4DVyIbxUUhJU/VPWU2C8p+5h9GALak5DcKEjjSVjomIYeOSrLQeQAQT3X3sfvyfLGHEtR7xWcRYOojjAE79AELN8aw1842wKUfxDPsVIxRpUp9oExNjhHHUrV6MLrVhYrIjVao5fnd+RQPQ7Ox/QQi2zwciHJ3tQIrDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; arc=none smtp.client-ip=54.254.200.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
X-QQ-mid: bizesmtp83t1722439861tqn73hik
X-QQ-Originating-IP: EhY82gNwHJ5ydRd/lV+B3jh8SxyY16lXrEMGsGuNqTo=
Received: from localhost.localdomain ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 31 Jul 2024 23:30:58 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 13565195655881594934
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
	baimingcong@uniontech.com,
	linux-sgx@vger.kernel.org,
	jarkko@kernel.org,
	haitao.huang@linux.intel.com,
	Kai Huang <kai.huang@intel.com>
Subject: [PATCH v2] x86/cpu: Adjust the error message when BIOS does not support SGX
Date: Wed, 31 Jul 2024 23:30:56 +0800
Message-ID: <D3C34BA892161BCF+20240731153056.303909-1-wangyuli@uniontech.com>
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
Link: https://github.com/linuxdeepin/developer-center/issues/10032
Reviewed-by: Kai Huang <kai.huang@intel.com>
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

