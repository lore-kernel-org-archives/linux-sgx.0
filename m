Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=65.109.113.108
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794543338;
	b=AgB2IoDe4Jo+h888BhYeUQyMcZQyR+Zx+rEzHlfWkeaR39A/xFQOTTkeuWm0A26P5oKH
	 UKnMjw2K/eNKWPyN3pHCrpHGDiG56cXTPBEOv+Ng1mINcpr4uuqIb//hrC8ZH1YZdy9c7
	 rVV3FUCvedq/WzntLClnw4ZcM7Vgb7VZJJmDaSdi+uBeg1YmJaXciAHOGcd5wiuEyIkPr
	 Amx8pA6Lt61gbGr690v1Dlmz7Ia6bzxJ7bGyCrPhsmt8fgdjwO1ClAuhh4GBsb08FKZz/
	 TpCZCsza2ENiwzdcUtoE9GXiQP/1rdBzVvpyPHlQJwa1CPOVH/1GBAalcxUF4YDZclw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794543338;
	h=DMARC-Filter:Received:X-Virus-Scanned:Received:DKIM-Signature:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=//lKXFbkokNqziUfCV8iUKA3qHrzbho2r1lEbcoPji8=;
	b=QxkiIDGXrFWHSYkmDleBUOUbYOSwg4RWmiQAIEYVMjK+ICzUrzqEgzrr5vlxCeGjcdVd
	 06Zf1Q0Uib/i4eeoMnTsNlaTykV4FhtJ5pL4TokBiIfLTiWlYdAiAln9LyBKijOQWfykr
	 nwjtPDbSlNpTSjs7ysagzefDS1Y9GnwcgWWftgdWgZgYgDEz5MRkZBV/yldw0HwMBLJIC
	 sBTk9BPMd5sDXqOoxLHToP0RDSpYUitGPVDT76hDpfCvPmUJI1UzYHaEmKG6rbCvppCQ+
	 DAqqGXP2AiOXnTWISlT1uJttL8c6+ydgP0GH7TNakD7EK5CJjGsZJ6OmWzitRGxnYYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=alien8.de;
	spf=pass smtp.mailfrom=alien8.de;
	dkim=pass header.d=alien8.de header.i=@alien8.de header.a=rsa-sha256 header.s=alien8 header.b=izbh86xN;
	arc=none smtp.remote-ip=65.109.113.108
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1EE9606A323;
	Fri, 13 Nov 2026 04:15:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F1EE9606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.a=rsa-sha256 header.s=alien8 header.b=izbh86xN
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id BFA6940E0218;
	Fri, 13 Nov 2026 04:15:35 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id vcZHcrsSL2UQ; Fri, 13 Nov 2026 04:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1794543331; bh=//lKXFbkokNqziUfCV8iUKA3qHrzbho2r1lEbcoPji8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=izbh86xNYurQZUs33IjsgrdQ2xkFL3P1t8SW9THXglpb6BK8tW6nLxAT8a45WZqgn
	 S1uiV0jybx0yFGxQ3YtpGLsesmd0G3ZWKvF8JoR+GF8g43IUhwfwmYgATAwvL37TVH
	 JnOolI2PLsZjcN2Ql1S/QWjkP7aTXPuZ2/WOiK1+OM3DU2+c7CLMwiCVCimd47o6SR
	 CiURa9JWXhkwYAvSmwpt6j/x8esHS/YDcR5IDi1E0A8WKiN9ccmmVR5qqTurX3UD2U
	 UxhkmDAjFQBmNYWJwEjAZinsRBcp3ppjoObQo3tHjseSRSlDVaRzOylzccN0V9Jc1n
	 WlNWaUAMio2brvmoqSr70rJpA9BNQwW0XZFJ2ayD5SCRF60UaKBabyt9Ag5k5ALLUu
	 77gsVtEfAmvXc9l/dioT4Twd3GJGG/nZT5DAOHULiUiz/KvEcsUKXvct6KCN3cfQfG
	 h/FlsnSVIncOxtqlYcZm/5xuEja47KTVUTX/Y6Ai8SbFhpiSUujff/h7cVdEugn0RN
	 9jJ9Vi0vvs3suLxXh2YYMJJoZ0YN3hI4q/QTyvBFsT+uHWEJ3AsSMG6ovjVYMLtZJw
	 ygGlv/WMrVtebyiYh1GsJF6m/phhVdKhANxRxTM/5v94WD3eNY62mu9gpVvcHP6Pkz
	 1xVdkOdp7ZI+fhFQlCNCDAuw=
Received: from stx.tnic (unknown [209.52.143.85])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 0ACE240E0184;
	Fri, 13 Nov 2026 04:15:19 +0000 (UTC)
Date: Thu, 12 Nov 2026 20:15:16 -0800
From: Borislav Petkov <bp@alien8.de>
To: Yuanhe Shu <xiangzao@linux.alibaba.com>
Cc: jarkko@kernel.org, dave.hansen@linux.intel.com, tglx@kernel.org,
	mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
	linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org, challvy.tee@gmail.com
Subject: Re: [PATCH v2] x86/crash: Disable SGX in the kdump kernel
Message-ID: <20261113041516.GAavaO1CiqZ3otjh3I@fat_crate.local>
References: <20261113035019.3747461-1-xiangzao@linux.alibaba.com>
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Post: <mailto:linux-sgx@vger.kernel.org>
List-Help: <mailto:linux-sgx+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sgx+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261113035019.3747461-1-xiangzao@linux.alibaba.com>

On Fri, Nov 13, 2026 at 11:50:19AM +0800, Yuanhe Shu wrote:
> Clear X86_FEATURE_SGX from an x86 early handler for elfcorehdr=, which

First of all this cmdline param naming is maximally unintuitive and why does
it even exist in the first place?

In case some user decides at kdump load time to disable sgx?

When do distros normally load kdump kernels? During boot?

So it is probably a script doing that.

So no user is even going to pay attention to this param or even know of its
existence.

And how does an init script know that the kdump kernel should not dump EPC
mem?

Do you catch my drift here?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
