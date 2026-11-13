Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=115.124.30.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794541834;
	b=iJO6n6uNfScedLwVXs4dUskvXOLm1MawiJHD4zt3NUuJPlUsTNq2fiKmC1cU+y5kPSK0
	 d0utR6rkeWnVvqtnFC01/EPoSCjE/h+B+cY3BKuo/OPjID24fNSGNifrW5wJoIuw4jzl/
	 eAjzH7D+UvjdGhpV7maDa/1RLlS81bKwHMMdqf4BWJVR137lBsS+ziyYzx/zTSqT8eahC
	 2NTb71Xn3kJbs6qHZH5pGFj2jy53sUK7fv+Pv+PwrpkS/yw2jVBilC3lqPVh2O+guTxOr
	 lzp04jOYh80mSTiHUTT17opsn7zVPzX4Sg8zAnEkdWE5cG5lOhXIaxw3PG0jsuXLK9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794541834;
	h=DMARC-Filter:DKIM-Signature:X-Alimail-AntiSpam:Received:From:To:Cc:
	 Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=I88pmf1i9KwkUDAp+VlFVURLkgncDv2aMPZAk6UPui8=;
	b=nqG7RolbgPys2EToJskCXU7lngUvIWk0hUoM1GUc5a/57yLGpI8X3KVN/dIGuyu8XYFH
	 gGkCFCNZG7LkquG5laLoevtYAd1UWv7yudsOJpskXvyDRbzZXrOm8/YHLBBIFWr+dO199
	 /OD2+AXLxesPKvwsIYgb13lY4gcBWpNLYduqIxUJTv44ao6iX//+7Q/YTciw2srA9KXje
	 ovgqT7Y2WN14MP1I6ivYGmjT6W/514lAXQatHwFSxO04XYfNfy7Nh8Us2NgsPnzMuBHiJ
	 Te9o3Dlc4UIWPQ1SBDFD7q6cucgYlx3truE6s7V36o5Snkt4x8ODJp564FFbIU9fczg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.alibaba.com;
	spf=pass smtp.mailfrom=linux.alibaba.com;
	dkim=pass header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=fR5zRllt;
	arc=none smtp.remote-ip=115.124.30.124
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B31B6606A31C;
	Fri, 13 Nov 2026 03:50:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B31B6606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=fR5zRllt
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794541827; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=I88pmf1i9KwkUDAp+VlFVURLkgncDv2aMPZAk6UPui8=;
	b=fR5zRlltmIF5MgKPIDQqh8jEr3/TFIiKd6JjOutBLv7vw8kQIqV3YMSHsqsNf9b0GcM2t+CXHO42zAiN3Yr9z/C/1t0uqU37kEvPsGyF/TYllFpAST85iO7eJ1jKVXe7jKB2Eqrln0XBbjQU1TNvTHRXHTMAz1q9p9BMVBQBki0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=xiangzao@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0XEdmoxy_1794541819;
Received: from banye.tbsite.net(mailfrom:xiangzao@linux.alibaba.com fp:SMTPD_---0XEdmoxy_1794541819 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 13 Nov 2026 11:50:27 +0800
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
Subject: [PATCH v2] x86/crash: Disable SGX in the kdump kernel
Date: Fri, 13 Nov 2026 11:50:19 +0800
Message-ID: <20261113035019.3747461-1-xiangzao@linux.alibaba.com>
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

Clear X86_FEATURE_SGX from an x86 early handler for elfcorehdr=, which
only the capture kernel receives, so sgx_init() bails out on its
existing capability check and no kdump knowledge leaks into the SGX
code.  Like nosgx, it has to be an early parameter: clearing a feature
after alternatives are patched is too late.

Reported-by: Challvy Tee <challvy.tee@gmail.com>
Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Yuanhe Shu <xiangzao@linux.alibaba.com>
---
v1: https://lore.kernel.org/r/20261111123942.3842771-1-xiangzao@linux.alibaba.com/

- Clear X86_FEATURE_SGX from an x86 elfcorehdr= early handler instead
  of checking is_kdump_kernel() in sgx_init() (Dave Hansen); retitled
  to x86/crash accordingly.

 arch/x86/kernel/crash_dump_64.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/x86/kernel/crash_dump_64.c b/arch/x86/kernel/crash_dump_64.c
index 32d710f7eb84..4a275b969f3c 100644
--- a/arch/x86/kernel/crash_dump_64.c
+++ b/arch/x86/kernel/crash_dump_64.c
@@ -12,6 +12,8 @@
 #include <linux/io.h>
 #include <linux/cc_platform.h>
 
+#include <asm/cpufeature.h>
+
 static ssize_t __copy_oldmem_page(struct iov_iter *iter, unsigned long pfn,
 				  size_t csize, unsigned long offset,
 				  bool encrypted)
@@ -62,3 +64,15 @@ ssize_t elfcorehdr_read(char *buf, size_t count, u64 *ppos)
 	return read_from_oldmem(&iter, count, ppos,
 				cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT));
 }
+
+/*
+ * elfcorehdr= is passed only to the capture kernel.  Turn off the
+ * features it has no use for.
+ */
+static int __init kdump_disable_features(char *arg)
+{
+	/* SGX metadata for a large EPC can exhaust crashkernel memory. */
+	setup_clear_cpu_cap(X86_FEATURE_SGX);
+	return 0;
+}
+early_param("elfcorehdr", kdump_disable_features);
-- 
2.43.7

