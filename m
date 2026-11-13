Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794573922;
	b=okoVZ16ej5sGMsw6cJPFJgOIYWMNyF+i6hhfWbCjxfRR9YQF0HWrKyg9/XDI/ddGjQV8
	 f+qoq8Y+j7mqoapkRklwttXyVNOtI0TaMp7kTGaMv3vt25/TQFxBpa9w75R2ly4k/aQcf
	 bCSQPzQOFbnKeZ3UIEbJl8YNhrOT+eYMACnZLdRXu9WOVzxluKB3Kg40bT5adFp1WGReH
	 ao5RxSdLPHoDrrEKMomghoTVHAXpXs4F0vgdxs5IQ33BzgnDaBqED/4g8OEUqZjkS8Axv
	 z9/O1Eg9aAbsn3I/gZ7TBtanNHcHyW8gNilwRaY7IMkYQjaTDkWnyClIGl646KCdYMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794573922;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:X-Developer-Signature:X-Developer-Key:
	 Content-Transfer-Encoding;
	bh=StfimioWjvVPXYjFy+9Yc79OyOR0BzyILDGtzeIcoEc=;
	b=vh2y+nfojPLoGaDkE9fd1dlFtJfzpNpf68W4E57IccbMTvpSDL32F+YV/O1yYn2rtjgU
	 M6P+4mAmUc2j+Ld02tGmWaI6pjt5/FKRqcU5QpmVWX32TCcC4iWUjfXu3tvnePo2jpVBD
	 liUppPd0G8oISK/445cKZ8nO8H1dKGZ2L3l/Yr0U1JdZoxkooTi1PvF0oyhGOFEgRUGPd
	 5/VZ3tVdzz8HvdW532aC+hOkt1DwDU2yWh7pqEs8Zrxl3E/RLqGn4147S7sSNpizuQ7WL
	 Lt92HOGgk7tEBpengw7NxnhaK0Vigt0J7NkNd5rfVQjf/JUAcYkB1QNaRP54a6bGFYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OZ2VjQb7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 277AD606A323;
	Fri, 13 Nov 2026 12:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OZ2VjQb7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDE9C1F000C4;
	Fri, 13 Nov 2026 12:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794573921;
	bh=StfimioWjvVPXYjFy+9Yc79OyOR0BzyILDGtzeIcoEc=;
	h=From:To:Cc:Subject:Date;
	b=OZ2VjQb76fkQy+eCyFR/83yQHPtXM4CHT+vlGVkWHEvyvzQumkkAfH53ITFiiCSlZ
	 yvB84UyfM7dKcHXwZMDICCsI/abNve3cEhdkiStYfYjg3fhurkTo/SU2aXEmuI8XPH
	 bpWEO98g+4b/7tnwKjEsPNWKjH6Aj1ch/j2Iv+ggp5hYmBvADKMj7wDYyr0x886lpu
	 6j8ihOboGhP1vGd+L6u0iB2A3mR3pg3Via5IQgzEVepcbILtsjpgTvcZCSMZbPZe+P
	 nf3QURNCyqx5tng82BgcfyhhMXMMF8mLz+wFtowOTrJs7U37F6whgjUnvaVGHOdVr6
	 e3tPtt+3NtIYg==
From: Thorsten Blum <blum@kernel.org>
To: Jarkko Sakkinen <jarkko@kernel.org>,
	Kai Huang <kai.huang@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org
Cc: linux-sgx@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Thorsten Blum <blum@kernel.org>
Subject: [PATCH RESEND v2 0/3] x86/sgx: Remove unused definitions and reuse launch token size
Date: Fri, 13 Nov 2026 13:44:49 +0100
Message-ID: <20261113124448.70586-5-blum@kernel.org>
X-Mailer: git-send-email 2.56.1
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Post: <mailto:linux-sgx@vger.kernel.org>
List-Help: <mailto:linux-sgx+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sgx+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=641; i=blum@kernel.org; h=from:subject; bh=9dF9afxvdXRrPrLvKh+QsdDnwLa6XoR83auXHs8jeL8=; b=owGbwMvMwCUWt7pQ4caZUj3G02pJDFnf2RyWbtre+eD+6u7P34TjuKpKXqWuvJv7ec6W3TsNF 894u6owuaOUhUGMi0FWTJHlwawfM3xLayo3mUTshJnDygQyhIGLUwAmoqvNyPBGl4d3Jf+c7WHr v28+qMP8+NzkAzzKZexNNkyrKtoTKn4y/OGuTJ7umKWV8D7/4brPlhlOP4W8LRfeWt57xuH1ivr nrcwA
X-Developer-Key: i=blum@kernel.org; a=openpgp; fpr=1D60735E8AEF3BE473B69D84733678FD8DFEEAD4
Content-Transfer-Encoding: 8bit

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
