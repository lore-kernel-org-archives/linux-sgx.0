Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.101
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794400803;
	b=gEyREl+QKmm9qo4V6AKAcdDvrPswGWOqlZzmBP4u+ikpxVBMyS6shg9CEhEMzwm2UP96
	 mK4zLHhlM58Tp6UnEQ69gQ1gvHCgT0gfP/oFK2GK7Li+x9cK3L7Voj6PH/l9r0Rz240tu
	 O/IDTdCA4zkvAwXNeB2Vu4LurzNGnEIfQWeCQMvmj7OUj+BPcrdFaBY/eGtLjz5Uy56/O
	 dqMI3X5j0eqdGyKKbfVmEpy0MtLnV9gZOO48d2jVTuWqW7ui4vFVn5RW50nFDDmg8jijB
	 82qhHhk32QZQwQL6YKGptDM1KLOd/czVHM+HYhBpsxg/6m/y+pyvzVqqTwLsvtZS5jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794400803;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=edaELw1AlTqC7iqRTi5ns1dhzRr1Rv3VqoRIG0vbW60=;
	b=MhsR8KFRe9hn9D1sRmWossHkFxCByFa3qiKFS/Gv92YEJY3GS8G6t+tuoA0NIxy3oMqt
	 iYL3xsmD/zivZrwyjU78JToO7isk5tXI4fn3b1RgDHJLGhFwIbgVOvgho8x06Qtu6yWQ0
	 v2YnluMn/6Qggi6GiVoPL2V+CXPcLLZMnDj7xii7YR5T3Qr4suXsnlw3OwbHoRQdbfyPy
	 3LudXAa2TeMpZ/RVASwFKrRXUWQmKdutPIY1sI8oY7XANdtNc1DWo1ZG4iv++c2PN+f1P
	 lXoAvu1czSu8jRArSg0T5/1L3mq5TQ1UXiYpoJrohnLvJTmfSSGuU5NqvruttGVyRaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=DrOPq8eJ;
	arc=none smtp.remote-ip=115.124.30.101
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C2F8606A31C;
	Wed, 11 Nov 2026 12:40:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6C2F8606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=DrOPq8eJ
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794400791; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=edaELw1AlTqC7iqRTi5ns1dhzRr1Rv3VqoRIG0vbW60=;
	b=DrOPq8eJBopDVX9sZ1TB21Nwe3BIBi+W6pN5OtyQmZVnclHGiYkNTmNa6rzbTkTFQ8PszAMWIjwiHMmmPfxPVYUzHejfwuQ5ZXbAn61EihYf98pI+7fGKwidgTes+G9yTm+MYcvqx7Q9/L7f6h7CnmYssKR9QCsab6t3WVSJ6AA=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R361e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=xiangzao@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0XEYtvFV_1794400783;
Received: from banye.tbsite.net(mailfrom:xiangzao@linux.alibaba.com fp:SMTPD_---0XEYtvFV_1794400783 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 11 Nov 2026 20:39:50 +0800
From: Yuanhe Shu <xiangzao@linux.alibaba.com>
To: jarkko@kernel.org,
	dave.hansen@linux.intel.com,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	hpa@zytor.com
Cc: x86@kernel.org,
	linux-sgx@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	challvy.tee@gmail.com,
	xiangzao@linux.alibaba.com
Subject: [PATCH] x86/sgx: Skip EPC initialization in the kdump kernel
Date: Wed, 11 Nov 2026 20:39:42 +0800
Message-ID: <20261111123942.3842771-1-xiangzao@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Post: <mailto:linux-sgx@vger.kernel.org>
List-Help: <mailto:linux-sgx+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sgx+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The kdump capture kernel cannot use SGX: EPC memory is e820-reserved,
so it is not part of the crash dump, and no enclave will ever run
during dump capture.  Yet sgx_init() runs unconditionally and pays the
full EPC bookkeeping: sgx_setup_epc_section() allocates one struct
sgx_epc_page (32 bytes) per 4K EPC page, i.e. EPC/128, plus a memremap
of the whole EPC range.

The capture kernel has no memory other than the crashkernel
reservation.  On a VM with 15.5G EPC the bookkeeping alone costs
124 MB of vmalloc - nearly half of the stock crashkernel=256M -
and the cost scales with EPC size, not RAM.

That is enough to break kdump outright: with the default 256M the
capture kernel OOMs in early userspace (udevadm and journald are killed
before the root device is enumerated) and no vmcore is produced, while
512M works.  With this change the same 256M reservation captures a
complete vmcore; SGX initializes as usual on normal boots.

Reported-by: Challvy Tee <challvy.tee@gmail.com>
Signed-off-by: Yuanhe Shu <xiangzao@linux.alibaba.com>
---
 arch/x86/kernel/cpu/sgx/main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 4505f808af5e..5454cd3c976f 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /*  Copyright(c) 2016-20 Intel Corporation. */
 
+#include <linux/crash_dump.h>
 #include <linux/file.h>
 #include <linux/freezer.h>
 #include <linux/highmem.h>
@@ -1027,6 +1028,10 @@ static int __init sgx_init(void)
 	int ret;
 	int i;
 
+	/* The kdump kernel has no use for SGX.  Skip it. */
+	if (is_kdump_kernel())
+		return -ENODEV;
+
 	if (!cpu_feature_enabled(X86_FEATURE_SGX))
 		return -ENODEV;
 
-- 
2.43.7

