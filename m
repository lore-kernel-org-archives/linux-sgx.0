Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=65.109.113.108
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794613284;
	b=tCF1h2U28VXud5iAl2lPFNM0lL1J34fkXF6l54Qi2vExZSZQ4GNro8QA787vQBauAPbI
	 GTzSrQqGpRKtUDV2yMYdHn5AtR9XA+8DYIlugWqcPT1yzIFH5jeAJkVt63xjt8cL14Dn8
	 BBkYK3Tg40uLwns1Ucv+JGRM81JhuyoVqwTZqgbItSq5F3BIF8dp+nxFCdwJpp/nGRtrj
	 D6pkoR4uuVMdeRIra/J6q7MoTvbmJmIo7fHXdDyE28DQ00RNGRQbj9efAzImGOLedpNuW
	 0fX/pbFFP91Ndszav0K7CToc/V94BMw4ky4hFLbHcRawCS2i4xcfSyfopnE1qzlDPsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794613284;
	h=DMARC-Filter:Received:X-Virus-Scanned:Received:DKIM-Signature:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=vawUs7MMcMW7MP6EcF+lv1BI2DroRtAnMjcWFJQ64lo=;
	b=zzpeZev5mzUTDRGiatJj1OG2w+cmP7qSHEaWwBlh1CeymiYkLUjCHUdhNjP/spZtY8yr
	 skzfeIKUD/pX4MpyUwfjXyH8fcE2RH9dgVe7/ts4unGFfRgRE9gtAJmvoRugPvl05HYf8
	 RAOq+oKMeYGyriBNsMgksDIh3ka9wCf1kDiVrKVPt7GP+OXAhb8Wak9/9SFKMVa8PLl7D
	 i3ECzl31K4LUzDX8oSWYM0rTLwLyAahFg0G9rrK+u0o2rsSR7PuQ6llAMaLvpEjpQ2FR3
	 Lyu/jCWqFPu05j+5IlZfhwkJZFRutqgctPV5Jo8jvY7O6owwMhqwZRRtR6npaFhZ21Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=alien8.de;
	spf=pass smtp.mailfrom=alien8.de;
	dkim=pass header.d=alien8.de header.i=@alien8.de header.a=rsa-sha256 header.s=alien8 header.b=lNj4TfD9;
	arc=none smtp.remote-ip=65.109.113.108
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6B0606A883;
	Fri, 13 Nov 2026 23:41:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3C6B0606A883
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.a=rsa-sha256 header.s=alien8 header.b=lNj4TfD9
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id F2C5340E0218;
	Fri, 13 Nov 2026 23:41:21 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 3fKOEUuvZeim; Fri, 13 Nov 2026 23:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1794613278; bh=vawUs7MMcMW7MP6EcF+lv1BI2DroRtAnMjcWFJQ64lo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lNj4TfD96l4/HOdO/9xox0oSy/ycWuu2Mf5IonUasMbBwAyaxJGP3Z+uTCZPZeA/3
	 D1EtLGWfnxvSfjz4h0RY3mQzpp4gvKtcDUcy6ZYOXAy1GpqBaNTQ8WudtbivxeLyDj
	 SGcMKTwpVyAB8CQIV2uN7X2p6jsOG7yoIkbKtr4YLfQcoQIDJGM3Euzufnuv72l7Tz
	 qtYE7DWNSuHQ2HYwJEKgD+zlaQWOSvyiR3QC91HuYWyT+l7v/0cQhw/rTh4FkIiAYx
	 9yLfW11EzlYbXcSgOoL4XsVISKSwuvZm+svO4c3GHtq3lQ1w8bp/59n7bc7prSVvCv
	 mjDr/IAiRa2RW3AoEw2RMugWwZR3KM7EzvRpiMkoA06raNmVfAvdbvY+KYqEBJ1iMM
	 7/+Le/6BM6NRIfn/QCJvVjAPNue8MPCv0n+voSwjjHKTgQNKpe/d8NKI+Y+yrQqaEZ
	 x478LY8bxWtsXgR9SxzDJCiI4q3YmKJv2OJuotEwp/c9Lj7CTOkmxIdRdJkxq+/G2J
	 PNtmnXsiEhHxhfwFdw18XHu83VkFzOAc+xh5i+N0fmvQEnrPlXOj8QvFpb/vWKKgAc
	 gFxca/d6ludh9Tam1csrcYmKwiRaxGvl/6csTL6Z3EVerM5FL+Gm/N1IJ4DccaaYl/
	 V4xJRXZZNz6lDI/sQEDIy9o8=
Received: from stx.tnic (unknown [209.52.143.85])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 30EA940E015B;
	Fri, 13 Nov 2026 23:41:07 +0000 (UTC)
Date: Fri, 13 Nov 2026 15:41:04 -0800
From: Borislav Petkov <bp@alien8.de>
To: Yuanhe Shu <xiangzao@linux.alibaba.com>
Cc: dave.hansen@linux.intel.com, jarkko@kernel.org, tglx@kernel.org,
	mingo@redhat.com, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
	linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org, challvy.tee@gmail.com
Subject: Re: [PATCH v2] x86/crash: Disable SGX in the kdump kernel
Message-ID: <20261113234104.GDavegEC6UiLEfcfo9@fat_crate.local>
References: <20261113035019.3747461-1-xiangzao@linux.alibaba.com>
 <0E3109CB-AE2B-475D-95AF-BD5465748ED9@alien8.de>
 <20261113082036.52175-1-xiangzao@linux.alibaba.com>
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
In-Reply-To: <20261113082036.52175-1-xiangzao@linux.alibaba.com>

On Fri, Nov 13, 2026 at 04:20:36PM +0800, Yuanhe Shu wrote:
> Sorry, I misunderstood your point - language and my reading
> comprehension got in the way.
> 
> Based on the v1 review and your feedback, my proposed approach is a
> small kdump_disable_features() in the x86 kdump code that checks
> is_kdump_kernel() and clears the cap, called from setup_arch() after
> parse_early_param().  This keeps the disable in x86 kdump code without
> a parameter hook.  Does that work for you?

You should do what Dave told you:

https://lore.kernel.org/all/f20043bc-87a1-4ce3-89aa-49fa1f2ff092@intel.com

and no more.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
