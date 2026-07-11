Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 361863559F2
	for <linux-sgx@vger.kernel.org>; Sat, 11 Jul 2026 10:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783764091; cv=none; b=IFXhqDl9/3bsPrjcpmGnThk65cYPJe5orDYu8rMAMJKUoBhvwAzpNgZ7e5P/D9COMg+DSukw8oQdee7Nu5uN9m6iB4OOJncdDzEGo9cg+uVxIaqPCbEwHJMakAXeTpbG3UKfbL7HR+uajthtpuRI7oV81NNMKrXw8H0P7E3C/sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783764091; c=relaxed/simple;
	bh=B+6Y10Trvk8acY7NDnA0MY3/oImcKRHw6KEWI97Wyy0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Z0rJYgI8TDuVHd0u4Vx9AnvVV33eEWGV3d0rwYNa8VSmp7nP2RdP/ZVOoRHkazULlju2Pipk5/PAI8/LMGHLd9pkGsJDZeJ2b+U/+q1ln7Chm6yRs60Uz8aCeOvm6oAsGuaOV0Jt6DKJPkXlpoHBR6YszbT1bApV8pqYb+g6POk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WgxcnF6H; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WgxcnF6H"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783764078;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Su8+RfZeiQIpiEQQg7exQn1BNK5taGXVt9UZNLGa14A=;
	b=WgxcnF6HSVWpix4AOulUIxU9btxh6O8gOUuQ6EfDAvr6yGQ7ZWCmODuXi7iS4rjV43//vx
	h7xvGb0ssjQ/2GVaHdsaNV+iW3nR9RgqHPdjyVwprufkdfMfInHOPu/R0yKDvfmkNzt2D/
	Oq/ebjxC1zuTa13o+JPTAuarHxjCRO0=
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
Subject: [PATCH 0/3] x86/sgx: Remove unused definitions and reuse launch token size
Date: Sat, 11 Jul 2026 12:00:54 +0200
Message-ID: <20260711100053.739588-5-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=551; i=thorsten.blum@linux.dev; h=from:subject; bh=B+6Y10Trvk8acY7NDnA0MY3/oImcKRHw6KEWI97Wyy0=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFlBImFsrY0ytk++Wy701Hu4cfONw5NXL1B3OtDpbBj29 HXfyeR/HaUsDGJcDLJiiiwPZv2Y4VtaU7nJJGInzBxWJpAhDFycAjARpb+MDD2RHz9arXu+5L2j yC6XKPuLQvcVqh6d7XyZrVvSp/in4BfD//K5s1V1NpSxxxgEOS+9OHfCuSkWRvUSMVU8E6ZVlQb y8wAA
X-Developer-Key: i=thorsten.blum@linux.dev; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Remove SGX definitions that have never had in-tree users and reuse
SGX_LAUNCH_TOKEN_SIZE when validating the launch token in
__sgx_virt_einit().

Thorsten Blum (3):
  x86/sgx: Remove unused TCS definitions
  x86/sgx: Remove unused size and count definitions
  x86/sgx: Use SGX_LAUNCH_TOKEN_SIZE in __sgx_virt_einit()

 arch/x86/include/asm/sgx.h     | 59 ----------------------------------
 arch/x86/kernel/cpu/sgx/virt.c |  3 +-
 2 files changed, 1 insertion(+), 61 deletions(-)


base-commit: 2d3090a8aeb596a26935db0955d46c9a5db5c6ce
