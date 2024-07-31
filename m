Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92BFF18044;
	Wed, 31 Jul 2024 19:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722455369; cv=none; b=nh5+1jC2UAGegceIfm+sVdspSY98iNJLYBGUK/KTbBQ2ir0Qa1SKQ3Cz59jOsX/+qzqbhAP0CLw89YFU9MmvDfjuG7uyGjVeiecmQ9tNvTIYssjQc8ZvRDaH3uBP8lNp59/Gktm38M+3G7pjI8Uz/YrCw2xlZc7MJWpCcAR88yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722455369; c=relaxed/simple;
	bh=9OIJQf1Vo2Zgm2lXwUO3v0n7h0wbf2yvDoyIUZH40E8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=d46mXFmTBZr95nJNHijKq2aatubGd+XhjGfR7EBgNUVP/h+7GJOqbvI0VvlVYE1Ok2B3pqFT34oyNM+2ymFz3HSPi9faGBHB1zItb0Tj4nAOIuF3fZUsYblflPoqcdv7K+YMgO5TSHUVifwqO28G+6GdWqKtCRyLZ9TzVqThHiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=uWpqsSHx; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=AQU0Kb06; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="uWpqsSHx";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="AQU0Kb06"
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1722455365;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mKGWpfNeiy6ZIL3ItuS4pR1aXovCHXyZTiygwKozo50=;
	b=uWpqsSHx0M5aXg0JmzQTfGeG+Fv2SgCQ/EaOsdV7saAUEAUz26OJD1ZBWDBf99LHchBip/
	8g/gvNHA9mW4XrvtSomfItC/QVFTVR3h/Ah0fGvseGEY1jJlV3hdcKAtkfOQHzf9nDPdbh
	y5QMf5/zKPQq9tKr3rLpdKyZbJf7xtKgxTHnNJ2Ah0vYsbjL+Fs9g+ChVhGN3EG8cKa8Ha
	gQ4XNVj4ZtBk6rb0hnCjfo11ppTK6rE6Pp033p+kWLRdBUS68rVGE8NdRUUh2x9j/HJpiu
	O/ebepUC5aiz820QDddNHEo9BiUnAfySfKYnODVPe5IeKB2/jqvCfRsPo8ZGfg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1722455365;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mKGWpfNeiy6ZIL3ItuS4pR1aXovCHXyZTiygwKozo50=;
	b=AQU0Kb06pGL0FVW0OXacd86rNFzk6ddsIsys2lvzwIKp5zt6ZdObDcIVc20jcG9iJwjwxE
	j2nhDiA9BdRM6/BA==
To: WangYuli <wangyuli@uniontech.com>, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, wangyuli@uniontech.com,
 seanjc@google.com, xiangzelong@uniontech.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, wubo@uniontech.com,
 guanwentao@uniontech.com, baimingcong@uniontech.com,
 linux-sgx@vger.kernel.org, jarkko@kernel.org,
 haitao.huang@linux.intel.com, Kai Huang <kai.huang@intel.com>
Subject: Re: [PATCH v2] x86/cpu: Adjust the error message when BIOS does not
 support SGX
In-Reply-To: <D3C34BA892161BCF+20240731153056.303909-1-wangyuli@uniontech.com>
References: <D3C34BA892161BCF+20240731153056.303909-1-wangyuli@uniontech.com>
Date: Wed, 31 Jul 2024 21:49:25 +0200
Message-ID: <87zfpx4a0q.ffs@tglx>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Wed, Jul 31 2024 at 23:30, wangyuli@uniontech.com wrote:
> When SGX is not supported by the BIOS, the kernel log still output
> the error 'SGX disabled by BIOS', which can be confusing since
> there might not be an SGX-related option in the BIOS settings.
>
> As a kernel, it's difficult to distinguish between the BIOS not
> supporting SGX and the BIOS supporting SGX but it's disabled.
>
> Therefore, update the error message to
> 'SGX disabled or unsupported by BIOS' to make it easier for those
> reading kernel logs to understand what's happening.
>
> Reported-by: Bo Wu <wubo@uniontech.com>
> Link: https://github.com/linuxdeepin/developer-center/issues/10032
> Reviewed-by: Kai Huang <kai.huang@intel.com>
> Link: https://lore.kernel.org/all/a30f7700c7817b3e7e2f2bdb37d5c10a318b2c3b.camel@intel.com/
> Signed-off-by: Zelong Xiang <xiangzelong@uniontech.com>
> Signed-off-by: WangYuli <wangyuli@uniontech.com>

This Signed-off-by chain is invalid. See:

https://www.kernel.org/doc/html/latest/process/submitting-patches.html#sign-your-work-the-developer-s-certificate-of-origin

Thanks,

        tglx
