Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 871E6485CF5
	for <linux-sgx@vger.kernel.org>; Wed, 29 Jul 2026 12:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785329814; cv=none; b=abUuPPZflHw8QOosKA/zlW1DL/C5tCLpPS054X4KX7PxkIyuEm1bMvZRUA08UmZRmKAbpYKIbZ2de4h7R7Qbo5OjTHQyYdy5rDgs1F2Bha3lqQRnBpJj2FNqEWi7LoA2ES5qLN3qA/gJtcF6BeDHDxwMqt6TIq8b1TjRpziX7rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785329814; c=relaxed/simple;
	bh=r1r5RMvUpP2QwBaIKnPNvyCXSThO4qyv5+GIAJtLBDM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UL2ZMK21pRJ72zCGk86L8LILmQoSMvLfHTrUJ4XOi2p/Jv6F7AzBdpCc6qrJTPbMDmA+D5amnff3CqmYOOWSTwt/mfq+sH+fPLuvpco+7aVMNhuvKCPYzDV6BCY4E4fKWXsT6tqdAXlyL+hLy+8LkflAZAxC8pZiHFzKlxB9GvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QSZyoxG4; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QSZyoxG4"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785329806;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=1YLhVzCtofM0cHoSioXYUY6DI1SEZxy97dMuiptO6iU=;
	b=QSZyoxG4NfquVCDg5lbud8rweJLPAsWEqFbTifVZXX9n8N2cGnHyobyE+Tcd10gGbzUW81
	0CRW7mlbXp34MLxMIpQMalJVLtL5o/YN2vcuLNgcyXL8HeUKczaNozMMxIsOLYg84lwV7p
	tX/qpV4s6SAD+6mg8i2yCuYiNVx9zfg=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Jarkko Sakkinen <jarkko@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org,
	linux-sgx@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Thorsten Blum <thorsten.blum@linux.dev>
Subject: [PATCH v2 0/3] x86/sgx: Remove unused definitions and reuse launch token size
Date: Wed, 29 Jul 2026 14:56:25 +0200
Message-ID: <20260729125624.514697-5-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=700; i=thorsten.blum@linux.dev; h=from:subject; bh=r1r5RMvUpP2QwBaIKnPNvyCXSThO4qyv5+GIAJtLBDM=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFmZPypk47Q9+xdKc/2OzXBY27r3ZbZ7/LQr7GcZ7uof+ 9S4MZCno5SFQYyLQVZMkeXBrB8zfEtrKjeZROyEmcPKBDKEgYtTACaScZrhf9RRR2Wtqj7dmlmM IixTTixov7r/ikKrXO1v9RKBu4Lb8xgZtvD2H03pY13KZqLrEXZi2YE8KTH5ipV6PYse6e5gUlX iBgA=
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Remove SGX definitions that have never had in-tree users and reuse
SGX_LAUNCH_TOKEN_SIZE when validating the launch token in
__sgx_virt_einit().

Changes in v2:
- Adjust commit message 3/3 as suggested by Kai
- v1: https://lore.kernel.org/r/20260711100053.739588-5-thorsten.blum@linux.dev/

Thorsten Blum (3):
  x86/sgx: Remove unused TCS definitions
  x86/sgx: Remove unused size and count definitions
  x86/sgx: Use SGX_LAUNCH_TOKEN_SIZE in __sgx_virt_einit()

 arch/x86/include/asm/sgx.h     | 59 ----------------------------------
 arch/x86/kernel/cpu/sgx/virt.c |  3 +-
 2 files changed, 1 insertion(+), 61 deletions(-)


base-commit: 2d3090a8aeb596a26935db0955d46c9a5db5c6ce
