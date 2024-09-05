Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B8B5193422;
	Thu,  5 Sep 2024 08:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725523818; cv=none; b=sbNRogOlhTImtl3lBZjsJo25E5GjmxkANreKYqtt31IuE0nS/RikTX/AiA18RZauoRGcBjdcW0sCUB0wP1GG4smgNrqjbNuVnWmZH4quEtZOdvZAEOucvvAkjqB/9I+/p9VhI6e+1e0XmO4l7riOxCrZaKvd7V/2RS1pkzOjkrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725523818; c=relaxed/simple;
	bh=7QGzJXWTmaf+a9+vpBXbIQ2fIM99UtgFtfkgrqtxLak=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=A/4EijeOdq5atmqntYry3EgCLEjP43ONgocxQFKNHqVqw5yx0itg3ygEKFYN9nbU5OLadQAh0/u0UucdCW9zjN5/6Q7OIa5AuWdiw0UBGnWKFqA3xHi2ne7WXBEWd5sEUSPm8n1OakXxYDXpGeVpFv3ZWaNWrLDxuLULP6VsAec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mof1y1fm; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mof1y1fm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725523818; x=1757059818;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=7QGzJXWTmaf+a9+vpBXbIQ2fIM99UtgFtfkgrqtxLak=;
  b=mof1y1fmyWmNd0x6Gx6dcXLKXlJD+oZwJ89CTteIzRido5z1ZxEDvTKp
   AtS/U740w+Fr86lgzZf2ayRMad6OI/7l73k+wEpMbgxl0Sl4/fcXxsXoj
   UdOsP5j9oqxThnpL0kaEViDmaJLJcY+AgM/YvnFLa848beaqyGpebahW8
   h1LRxUwDp5s1NVw04bbDexS6xjtuhpHt9rQphqWRB6a+mU/mLYHziYT3i
   cPJltYuxGFCMoanYeeVsd7cHKlkImtVKfLPBKX2lfXek5KRPdrBhmdPV0
   yM5aGoJ3omqWgxhh+ncMMcWTTGjZMEtlU5LE8MMoyK/ZEsdOye+J0Jv7d
   A==;
X-CSE-ConnectionGUID: 5jyfh0z5TpimWLhPSxGb3A==
X-CSE-MsgGUID: xrFzaidSQRuPA9+pQNbV1w==
X-IronPort-AV: E=McAfee;i="6700,10204,11185"; a="24176505"
X-IronPort-AV: E=Sophos;i="6.10,204,1719903600"; 
   d="scan'208";a="24176505"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2024 01:10:17 -0700
X-CSE-ConnectionGUID: KI6JQhziSES21zgzFN+8NA==
X-CSE-MsgGUID: aNkTIrHqRD22d36F/xlIag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,204,1719903600"; 
   d="scan'208";a="65528390"
Received: from ziqianlu-desk2.sh.intel.com ([10.239.159.54])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2024 01:10:15 -0700
From: Aaron Lu <aaron.lu@intel.com>
To: Jarkko Sakkinen <jarkko@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Kai Huang <kai.huang@intel.com>
Cc: "Molina Sabido, Gerardo" <gerardo.molina.sabido@intel.com>,
	Zhimin Luo <zhimin.luo@intel.com>,
	linux-sgx@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH v2 0/2] SGX NUMA fix
Date: Thu,  5 Sep 2024 16:08:53 +0800
Message-ID: <20240905080855.1699814-1-aaron.lu@intel.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

A soft lockup issue was found during some SGX testing and it turned
out to be a problem in SGX code related to NUMA, please see patch1/2
for details.

While Dave reviewed v1 of patch1/2, he suggested dumping an info when
a node has both CPUs and memory but no EPC section, so that's patch2/2.

Comments are welcome, thanks.

v2:
- Enhance changelog for patch1/2 according to Kai, Dave and Jarkko's
  suggestions;
- Fix Reported-by tag, it should be Gerardo. Sorry for the mistake.
- Collect review tags.
- Add patch2/2.

Aaron Lu (2):
  x86/sgx: Fix deadlock in SGX NUMA node search
  x86/sgx: Log information when a node lacks an EPC section

 arch/x86/kernel/cpu/sgx/main.c | 34 +++++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 13 deletions(-)

-- 
2.45.2

