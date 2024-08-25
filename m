Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AFF34A07;
	Sun, 25 Aug 2024 08:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724573222; cv=none; b=ngFVf+EMQoLJNTYs0l14HhqBlS1RehabCWalaoIp5vVZI/ZQSvCEou1D6dJKguW82Q93vnjhg2MRljoeQvY+RkQxYVyQj6Wqr7/3QEGc/RD68+9FHFqbtKm4lPv9kDBGvgmm+rT18VymzA2VNh+iENiCt/P0PqzbX66sigKDeOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724573222; c=relaxed/simple;
	bh=IpbdU6Sj153iuiwOEiq/u1c7UG391ADyxKqOjNTIx/M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GerTjrkKbpLh49BpjwH1qU40gKCr7i1X3N39nioowIxUbKif3zNKlMeh9qZt6PwOlPo/m2sbJaZQfMu89jiEnAcGKFm4myX+GwvP1l7icXLysrJTjYvJryTlcjRzTP97p/Mrcoo9Lqa0pCLl2H93Tzh53DN+iRym50gYOVkPnTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BZklEFrg; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BZklEFrg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724573221; x=1756109221;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=IpbdU6Sj153iuiwOEiq/u1c7UG391ADyxKqOjNTIx/M=;
  b=BZklEFrguSgg6HwhowoFaKWUAbqGd0iAMVlsFXKTaWvUJCRYObMAoJbv
   xkVzWlQ6SZyYfUYz7URLkM7Oh4jdWxoI8JNIRi7ashyBNpXzvkgE5/w37
   PzaiVVxcpeZkpkftmOdyedho85fJaKoc1/EeQZeLIcSSOPsozSUzty8og
   ZtgOXrMBSeU5eep7put1lyVxl5b7cGg1j37AA7TJg6Mlh9BkB1V3gbteL
   YFfHqwywxdI7C6XOi3c73ASQk2AB7U7qqgBVipmySUUDSNvr/v+4fLMns
   XMptJhVluERwH3peAdfV5iVmsJtfAzNysOnGsTy4OVdsHB+rPKYVyIdOR
   w==;
X-CSE-ConnectionGUID: aa7bOARvQO+B2oNuyiPG2w==
X-CSE-MsgGUID: HEu5a+wWSxiGJzn4asamIw==
X-IronPort-AV: E=McAfee;i="6700,10204,11173"; a="34381451"
X-IronPort-AV: E=Sophos;i="6.10,175,1719903600"; 
   d="scan'208";a="34381451"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2024 01:07:00 -0700
X-CSE-ConnectionGUID: 7XwDOKtCRnu8fwnQQ5PfzQ==
X-CSE-MsgGUID: uo/58eKYR16tWvEHNnMiwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,175,1719903600"; 
   d="scan'208";a="62915424"
Received: from daliomra-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.222.196])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2024 01:06:58 -0700
From: Kai Huang <kai.huang@intel.com>
To: dave.hansen@intel.com,
	tglx@linutronix.de,
	bp@alien8.de,
	mingo@redhat.com,
	hpa@zytor.com,
	jarkko@kernel.org
Cc: x86@kernel.org,
	linux-sgx@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] x86/sgx: Fix a W=1 build warning in function comment
Date: Sun, 25 Aug 2024 20:06:49 +1200
Message-ID: <20240825080649.145250-1-kai.huang@intel.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Building the SGX code with W=1 generates below warning:

  arch/x86/kernel/cpu/sgx/main.c:741: warning: Function parameter or struct member 'low' not described in 'sgx_calc_section_metric'
  arch/x86/kernel/cpu/sgx/main.c:741: warning: Function parameter or struct member 'high' not described in 'sgx_calc_section_metric'
  ...

The function sgx_calc_section_metric() is a simple helper which is only
used in sgx/main.c.  There's no need to use k-doc style comment for it.

Downgrade to normal comment to silence this warning.

Signed-off-by: Kai Huang <kai.huang@intel.com>
---
 arch/x86/kernel/cpu/sgx/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 27892e57c4ef..1a000acd933a 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -732,7 +732,7 @@ int arch_memory_failure(unsigned long pfn, int flags)
 	return 0;
 }
 
-/**
+/*
  * A section metric is concatenated in a way that @low bits 12-31 define the
  * bits 12-31 of the metric and @high bits 0-19 define the bits 32-51 of the
  * metric.

base-commit: e77f8f275278886d05ce6dfe9e3bc854e7bf0713
-- 
2.46.0

