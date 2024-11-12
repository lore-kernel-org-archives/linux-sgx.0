Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2F3419F13C
	for <linux-sgx@vger.kernel.org>; Tue, 12 Nov 2024 18:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731436021; cv=none; b=WPMNEC3pF+sAZgLmszxp9nmnMtXZBa0jqev8iZQQOGEsk/DbJNIpv+VTiHXZQ8QcvQK5k0hheFtrnCVeGc2uD2MwGJ6JGESGLD8b86Y7AD1MsMIxHeV3b+VxxLHLscTnAobk/LthFXanCk3gTc8P6zUWHfAOpnhL2P1Qo9hkdD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731436021; c=relaxed/simple;
	bh=9498p1+urEAuPHih0wEAFcDXt6dCjovBzzWUH1DOo8M=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=p679i8DzSDbvSMDwaRK27gwK6eaPiuCLvGw5ieh7f3TRURFrRKQzaec2rVCvj7H2MAYck1cA0XEQssdUCSUaXMA+86dvAQpph2JKDZZYYq5Lv+uJBeY5yDFkzVcw2c/M3ZJuaR1r0jKhgVnFVujuGraqp4XLeeoZ4QOFZ3jtHYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=l23m6QS9; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="l23m6QS9"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731436018;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=/aKwH3SjQpUM+jWWtGaYjbeNEaozxwArdhfwrNTEqiw=;
	b=l23m6QS9SJOnqP44AaTd1zI5Ofp3P8emiuuZpxfnjV0p2eYdOkOb/GnHFv7MBXmOhbUvjC
	ZEReMsj6Fua2jZoSsRvaWBMoYXmSS3B6Y+FBcumsn+5LUt5ntjX31xylVrW26/S6w12k2g
	b+OjyqKsM+6sa0QM/fl4IBOslZ46hfA=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Jarkko Sakkinen <jarkko@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	Kai Huang <kai.huang@intel.com>,
	linux-sgx@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RESEND PATCH] x86/sgx: Use vmalloc_array() instead of vmalloc()
Date: Tue, 12 Nov 2024 19:26:34 +0100
Message-ID: <20241112182633.172944-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Use vmalloc_array() instead of vmalloc() to calculate the number of
bytes to allocate.

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Acked-by: Kai Huang <kai.huang@intel.com>
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 arch/x86/kernel/cpu/sgx/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 9ace84486499..1a59e5956f4b 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -630,7 +630,7 @@ static bool __init sgx_setup_epc_section(u64 phys_addr, u64 size,
 	if (!section->virt_addr)
 		return false;
 
-	section->pages = vmalloc(nr_pages * sizeof(struct sgx_epc_page));
+	section->pages = vmalloc_array(nr_pages, sizeof(struct sgx_epc_page));
 	if (!section->pages) {
 		memunmap(section->virt_addr);
 		return false;
-- 
2.47.0

