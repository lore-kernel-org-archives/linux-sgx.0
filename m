Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBB7919F40B;
	Sat, 15 Nov 2025 05:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763186084; cv=none; b=BVr5+mNTn2OU9WHzaVEYy8ktrmGBo5ae/aG79C8KwTRQab4Hmr3zzcXCiiPQi4TJEAnxbBK1U47hlme2Um1YPjaSoAAPa4kL/IAFbkegXt7CuFh37L9UT3sBFKgQmMpVnNjdme7k4jr02uWGp0D/SRVbmzGT9AG3kMha8uS8VQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763186084; c=relaxed/simple;
	bh=Fs+ZFa5NbkQ2Xok/03u0bg3TPI9WV+FgS3LJMMgay0g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pCtHkTCLBZCA0UeCK0YJ0pNAmuIAH4gqa9X+qtZ3SZv0EoeZN9U+1Y8yWr2G7ZTYYNtkBVUT39hOEABd7KTvRCOtlJLhWTKR4y1yox3CVHqcjLV4nkUDkb3CemyEq/c8XqezK1mcIncTMnVpOfJubcPIi91eWstmWeAwJMcATpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UpRPfHXO; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UpRPfHXO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=t5MR5pU6opR0lpMBzoM49l8pSZu0DxuotbEUzGztUFc=; b=UpRPfHXODvKn7WJU2Ragqqb1dF
	gDRjU0FUZYoneXLgs+stPFScMU28PfFHmL9NpC3uakcKCSECYfr+Lgei8uXbXeuA9zBdAGvLvBfoA
	CMp+keque8UIlorRHMdlSxNDu28VJayZtnAGThdc7YH1ViZK0xr0znhmx/6Zih2OKj0Z/LxcApgSq
	Dbsq02F6PnK69zzmO3Te1G1l4kdNlv2LYijxoe9kP2BhoWUYPXysVF9aKx7exTPhfxfJmgIGjwauS
	bn9P5v8ZbT+ngMxJGizZUYxASDeXeLh4e+096FfJGsDR17t2x8bhp/CQ4Lbuz/KWlGaxzf2LsmQ9i
	794MZp9g==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vK9FB-0000000DWRG-1K4H;
	Sat, 15 Nov 2025 05:54:41 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	linux-sgx@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH] x86/sgx: fix enum kernel-doc notation
Date: Fri, 14 Nov 2025 21:54:40 -0800
Message-ID: <20251115055440.3700056-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.51.1
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use "@name" instead of "%name" to describe members of an enum. This
prevents a kernel-doc warning:

WARNING: arch/x86/include/uapi/asm/sgx.h:17 Enum value
 'SGX_PAGE_MEASURE' not described in enum 'sgx_page_flags'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: linux-sgx@vger.kernel.org
Cc: x86@kernel.org
---
 arch/x86/include/uapi/asm/sgx.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20251114.orig/arch/x86/include/uapi/asm/sgx.h
+++ linux-next-20251114/arch/x86/include/uapi/asm/sgx.h
@@ -10,7 +10,7 @@
 
 /**
  * enum sgx_page_flags - page control flags
- * %SGX_PAGE_MEASURE:	Measure the page contents with a sequence of
+ * @SGX_PAGE_MEASURE:	Measure the page contents with a sequence of
  *			ENCLS[EEXTEND] operations.
  */
 enum sgx_page_flags {
