Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=65.109.113.108
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794550743;
	b=eQzyAPW2wD2b59DgYCd/4bpzUOG5DGrpjNL8AoIzbfPE3+l5Flw1IZRk0Tm1OiON5HUq
	 aLtEam8nvzsxT4RWbT/gfcSZamfI5lZnzGpuMVvsa6eL1SiOGURA8YLiZ3K0aFoDx2O20
	 Q8LYGTYP2hbI/diLcBmyWiUYjDDPdDEAjKXvqhjAjqkOEY4qVr1L+NhRS2Vm9HqfbC6ZK
	 u9+kUKar9YzSy+6teVBTd9dCT+GsSjCkvQG+LV83eGNHDzdzxhIib6TLhFbUSz15vc9Yb
	 S4LwvtEMC6dyhh5iKoEI0TZBC2yIlcuYqBB+zbpLPYjE3akZWmzzv9PUDa2Sjxy7+aA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794550743;
	h=DMARC-Filter:Received:X-Virus-Scanned:Received:DKIM-Signature:
	 Received:Date:From:To:CC:Subject:User-Agent:In-Reply-To:References:
	 Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=gPM9xW3HCUFDBCdeg2Fdt7LDLtrkk4BbVgNADER2L98=;
	b=rjBFTjOfZCBgE8iUKdwVZkqLC7cmBGVDcXYQeIsjC6I4cLB5Azbb4GCtmRko+ZfeQ0Ea
	 BuqnZzqCelOHctcD9op5MmtR9ulNvmjt2enpmMIvBfXYFK6+W1YRFqZJeIHQCtaJy+myg
	 qURq6H+7iWfu6eqgJmDdcHZjR8nLSdensOUhVUgv16Hxc9ZKIbix0wA73nSHGgMcrEXzo
	 4L4E5FU2kFEKVR0F/532T48O+oxWDwin3IkamiUVtnO7dVyQPctAT4WUbNfZDzmXMbGew
	 PUvPZamhqIvTq41Kg/GvFnCUg0UCIfaXxGKE8LxG45GOhhAC95/1NuHQHgrAa/fS3TA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=alien8.de;
	spf=pass smtp.mailfrom=alien8.de;
	dkim=pass header.d=alien8.de header.i=@alien8.de header.a=rsa-sha256 header.s=alien8 header.b=NsnfPiMv;
	arc=none smtp.remote-ip=65.109.113.108
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55503606A31C;
	Fri, 13 Nov 2026 06:19:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 55503606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.a=rsa-sha256 header.s=alien8 header.b=NsnfPiMv
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 43F8F40E0218;
	Fri, 13 Nov 2026 06:19:00 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id pjC1BT2I1lNC; Fri, 13 Nov 2026 06:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1794550737; bh=gPM9xW3HCUFDBCdeg2Fdt7LDLtrkk4BbVgNADER2L98=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=NsnfPiMvMcVzCWYFFmgJICLutuTwIGLmlcr/AAYmo+UyGe7rENiPn6qvefdkZkhKQ
	 i0qN8fTwDp1VUL5p/mF7NmT2LQV0x4qqzK8bF3FPznb4jSXPTu/exZ6YfGXYHHdkUW
	 H59QcHeLOSlKtjwZ5GbnD3CHW7YH2mpIJZMJT36ZOX8eCe7xKFIGR7tg+1+sak4K3M
	 AAmwC8871YGH8UZ96QjWIH6TOra0wSw0Rv68WIA5gzDe/KVdzRLD1sVUDF8UzJy4bh
	 8U825zBRkwgCJohHUy8DH4ItTmxlywzgXzT2fg6m/ATJ+YmqKYnwTB/PK3Bi9lEVPE
	 pZbPZc4odnlz9WwnNBotsPbcT1h7t/62S8CDkGd9DeMOeOXH1cx/hcWMzmcD8j21Ko
	 bIVLer2hNEqcyUs63swVu3xruesfH1xwLc0JdhFsVeRPkfRMU2CPOKeFrzHlQEriGo
	 4JM65Ma97h1JIfOBpYl/3ix4fgTrtHGTxyNvh2QHjwn/6H0kjKwCvLYjNxZHeOwrYn
	 nyYm0if8r7kzICXTYi61/JRn6qaXpdQopkLw3smss4zCt3Lbw1fDUJKY4siNtvLiam
	 SDzdvamyljXR1Mo+XqKN2kZpnXuvQ8km+b4whMKsc2hyNAWDnBrI7v9VXkxSq/ulge
	 b40LPZ9GrEHOUhufRFwY3l50=
Received: from ehlo.thunderbird.net (unknown [209.52.143.85])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 7CEFC40E015B;
	Fri, 13 Nov 2026 06:18:45 +0000 (UTC)
Date: Fri, 13 Nov 2026 06:18:34 +0000
From: Borislav Petkov <bp@alien8.de>
To: Yuanhe Shu <xiangzao@linux.alibaba.com>
CC: dave.hansen@linux.intel.com, jarkko@kernel.org, tglx@kernel.org,
 mingo@redhat.com, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
 linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
 kexec@lists.infradead.org, challvy.tee@gmail.com, xiangzao@linux.alibaba.com
Subject: Re: [PATCH v2] x86/crash: Disable SGX in the kdump kernel
User-Agent: K-9 Mail for Android
In-Reply-To: <20261113055734.3976582-1-xiangzao@linux.alibaba.com>
References: <20261113035019.3747461-1-xiangzao@linux.alibaba.com> <20261113041516.GAavaO1CiqZ3otjh3I@fat_crate.local> <20261113055734.3976582-1-xiangzao@linux.alibaba.com>
Message-ID: <0E3109CB-AE2B-475D-95AF-BD5465748ED9@alien8.de>
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Post: <mailto:linux-sgx@vger.kernel.org>
List-Help: <mailto:linux-sgx+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sgx+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On November 13, 2026 5:57:34 AM UTC, Yuanhe Shu <xiangzao@linux=2Ealibaba=
=2Ecom> wrote:
>On 11/13/26 04:15, Borislav Petkov wrote:
>> First of all this cmdline param naming is maximally unintuitive and why=
 does
>> it even exist in the first place?
>
>Thanks for the review=2E
>
>elfcorehdr=3D is passed by kexec, so every capture kernel boots with it
>on the command line=2E  We use it to detect the capture kernel, the same
>way is_kdump_kernel() does: that helper checks
>elfcorehdr_addr !=3D ELFCORE_ADDR_MAX, and this parameter is what sets
>the address=2E
>
>It also keeps the disable logic in kdump-specific code in the x86
>path, as suggested in the v1 review=2E
>
>We looked at two places: adding an is_kdump_kernel() check in
>setup_arch(), and this handler=2E  We chose the latter to keep the
>disable logic in kdump code rather than the generic boot path=2E  As an
>early parameter, it clears SGX before alternatives are patched=2E
>
>--
>Yuanhe

I don't think you even read my mail=2E

NAK=2E
--=20
Small device=2E Typos and formatting crap
