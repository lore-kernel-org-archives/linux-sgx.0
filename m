Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E03A26FA50
	for <linux-sgx@vger.kernel.org>; Wed, 10 Dec 2025 12:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765371454; cv=none; b=ruR50vLNVLdTirVhXyal3JzKeKvZf/MBN8Oj2XqkOgF0TwyQgPnS62SU7kLFBQyhGva19mp6QlKLUH730bUBIWT4yCe6TwZ3JAqLssYPqUmTLbEh8hZ3w1j4DkroINAXYZZcwTstKaNxbUjR/t+Kz4lbuZ6mWePWelAiyL4VO5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765371454; c=relaxed/simple;
	bh=2r29At9nitiMvCeKQmx53ZdDbiUek3S9jZFryGAQszg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ke+Vtim9C+7BVzqdo3Gv8Heyf6PKckuYBxQU1mQ0jB2ERX7IAF0BEWZ/8yMWYpxFumgJNNJAqoztoh++NzNRs4U4yhsCzyoPaTOj1OKF+N/vY6TE5b7rd18LAPXZ7shdT+KP8DCMkjAWUXghqhbEtGXOfXBVQEouoT8mK9PbSPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SCgxC+TB; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SCgxC+TB"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765371439;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=xkVpQH/4aRNdXE9IQXgb3FreHOrgcW0hY0dp2hrvymk=;
	b=SCgxC+TBwy9/DtoYNzP+VR+dZerSPSmI4pdnIDZZAmjKO+RgV90Z3Tyh3a39HljKIOqV+s
	MAnDaL80SOgdFjOjbn63EmyLFid8np7jaZkhS/6wjaYPQ1FeVOtJCFILocTVrUzv214pSp
	Bu4gDEJ/fYTwM2dDJ7fIVxPkEXzsp2c=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Jarkko Sakkinen <jarkko@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-sgx@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] x86/sgx: Remove unmatched quote in __sgx_encl_extend function comment
Date: Wed, 10 Dec 2025 13:56:28 +0100
Message-ID: <20251210125628.544916-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

There is no opening quote. Remove the unmatched closing quote.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 arch/x86/kernel/cpu/sgx/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
index 66f1efa16fbb..9322a9287dc7 100644
--- a/arch/x86/kernel/cpu/sgx/ioctl.c
+++ b/arch/x86/kernel/cpu/sgx/ioctl.c
@@ -242,7 +242,7 @@ static int __sgx_encl_add_page(struct sgx_encl *encl,
 /*
  * If the caller requires measurement of the page as a proof for the content,
  * use EEXTEND to add a measurement for 256 bytes of the page. Repeat this
- * operation until the entire page is measured."
+ * operation until the entire page is measured.
  */
 static int __sgx_encl_extend(struct sgx_encl *encl,
 			     struct sgx_epc_page *epc_page)
-- 
Thorsten Blum <thorsten.blum@linux.dev>
GPG: 1D60 735E 8AEF 3BE4 73B6  9D84 7336 78FD 8DFE EAD4

