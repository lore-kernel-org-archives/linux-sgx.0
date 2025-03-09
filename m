Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD1DB748F
	for <linux-sgx@vger.kernel.org>; Sun,  9 Mar 2025 16:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741539530; cv=none; b=PaLpuXX6CSvw6aqHJGJd977V1zWKTHdxN93Lpp+n6E53qs4fR1z1x9/kkllskTfPcUwCzQpwzZn9ZoTwx/6m+AAAuwqMJwe4BFGahiYXkiOzFyaFxGgtZwpwQlkn9w/2GFr/ynFHWLy0/5wXHbmA5pNKyPWgk90piVCZ9MUfC9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741539530; c=relaxed/simple;
	bh=TtTC3sPH9mDrhQIWDYBQcZnCSbdL9fbHK3QSbmgGkZs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-type; b=deDwY3hRlvekW1WgCJ08gaBjBA8RCwSSJI5BQZWZsT8IhMxze8bRg5Fgsy5dcyIrQsXKxDPHJwPHQu0H3/gjluDGVw7Z9cFbObFrrlDb3fVT8uTbbL57X4HZoK5aAsEYfBte/bL04qlGb0EsF6VGrDBUTaH8t4Dohp3vEE94Owc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SNE5VnqT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SNE5VnqT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741539525;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=anNRQiHQudvzJgBPZQvmHdv1qiVW34xAmZEDk1+gVUM=;
	b=SNE5VnqTwOdOG7buA8dFjeZFtSwG5nw4Uznx/hRWVzyE6an/o0HUuf13sm1LUHXD2DuzNY
	34gaLvpAoOxtfWvmAg7tpDk0fxhypFtEikV1f3G0xdbX3ETs7Mzw5FW5R+2qCSIA+pwpWI
	N0FzKa0cs+b+MYe88Gp5wmi8mWZegUU=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-45-7Gsgk12pNIinxuX8kdvrLQ-1; Sun,
 09 Mar 2025 12:58:41 -0400
X-MC-Unique: 7Gsgk12pNIinxuX8kdvrLQ-1
X-Mimecast-MFC-AGG-ID: 7Gsgk12pNIinxuX8kdvrLQ_1741539516
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A7D8819560A3;
	Sun,  9 Mar 2025 16:58:35 +0000 (UTC)
Received: from rules.brq.redhat.com (unknown [10.45.242.4])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 47D3E18001E9;
	Sun,  9 Mar 2025 16:58:30 +0000 (UTC)
From: Vladis Dronov <vdronov@redhat.com>
To: linux-sgx@vger.kernel.org,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-kernel@vger.kernel.org,
	Vladis Dronov <vdronov@redhat.com>
Subject: [PATCH] x86/sgx: Warn explicitly if X86_FEATURE_SGX_LC is not enabled
Date: Sun,  9 Mar 2025 17:58:06 +0100
Message-ID: <20250309165805.8996-2-vdronov@redhat.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

A kernel requires X86_FEATURE_SGX_LC to be able to create SGX enclaves.
There is quite a number of hardware which has X86_FEATURE_SGX but not
X86_FEATURE_SGX_LC. A kernel running on such a hardware does not create
/dev/sgx* devices silently. Explicitly warn if X86_FEATURE_SGX_LC is not
enabled to properly nofity a user about this condition.

The X86_FEATURE_SGX_LC is a CPU feature that enables LE hash MSRs to be
writable when running native enclaves, i.e. using a custom root key rather
than the Intel proprietary key for enclave signing.

Signed-off-by: Vladis Dronov <vdronov@redhat.com>
---

an out-of-commit-message note:

I've hit this issue myself and have spent some time researching where are
my /dev/sgx* devices on an SGX-enabled hardware, so this is a bit personal.

Links related:
https://github.com/intel/linux-sgx/issues/837
https://patchwork.kernel.org/project/platform-driver-x86/patch/20180827185507.17087-3-jarkko.sakkinen@linux.intel.com/

 arch/x86/kernel/cpu/sgx/driver.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx/driver.c
index 22b65a5f5ec6..df4fbfaa6616 100644
--- a/arch/x86/kernel/cpu/sgx/driver.c
+++ b/arch/x86/kernel/cpu/sgx/driver.c
@@ -150,8 +150,10 @@ int __init sgx_drv_init(void)
 	u64 xfrm_mask;
 	int ret;
 
-	if (!cpu_feature_enabled(X86_FEATURE_SGX_LC))
+	if (!cpu_feature_enabled(X86_FEATURE_SGX_LC)) {
+		pr_err("SGX disabled: SGX launch control is not available.\n");
 		return -ENODEV;
+	}
 
 	cpuid_count(SGX_CPUID, 0, &eax, &ebx, &ecx, &edx);
 
-- 
2.48.1

