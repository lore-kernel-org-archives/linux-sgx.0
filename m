Received: from out-187.mta0.migadu.com (out-187.mta0.migadu.com [91.218.175.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9287618EFEC
	for <linux-sgx@vger.kernel.org>; Mon, 28 Oct 2024 22:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730155696; cv=none; b=snF+u4YKszZGnCvOBL4hn/0Vlm7wDCPTpk7PAYxQc5usDxhZNlqnn5D+mNuSYXmit43EfVb0O1W85e4FOidcVrnHm7CiRoqFJ4mCYxV2LX8jTm5jWEdK9ze5iFgOc6n42wJrIffLl8IG6X5NdPw2N3xur2qEX1cA0cCTgfMZVeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730155696; c=relaxed/simple;
	bh=pmlG57dgokv8C/W9ZqCyP/IDa+L22xXuqAQ89gdBPLI=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=rOP0q5nShgxLw2xW+uK1GxLnTzjPpYH9gCLtKLQg5Rsg+zk8v6592CB17J67ZAYdB2S2W6EGz85xu3ev1m4FHSwMjM+PM9n41/av4VtrpX4GSgjVBZD4mhwPHlZUCRioubykZ5jRpoLi4ih1WpkQOGTk1WPuCSdXDXV2opa8ukw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=LdUkDwb3; arc=none smtp.client-ip=91.218.175.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="LdUkDwb3"
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730155692;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EDtLDtjXgNW64zonKXdumRRA5gIQqyPzaPz1kD7YML4=;
	b=LdUkDwb3jCcD5zD5qJ5BnIaCOu8ZApxzik+BoBs7O1cn2eQinsgfB/i8DIBPHVd/ZjpHqi
	tr2MAj8HmjVVqdN54d5uxXIAhFn+ST6wkzynbxCkErLhb028JUaJ7Yr4vYAG4j1old9uhH
	f3YJLmQ3WzATDD7ckIeTSg+VC+ivDuA=
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51.11.1\))
Subject: Re: [RESEND PATCH] x86/sgx: Use vmalloc_array() instead of vmalloc()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Thorsten Blum <thorsten.blum@linux.dev>
In-Reply-To: <cd663aa6-28a1-4c03-9258-511285316c0f@intel.com>
Date: Mon, 28 Oct 2024 23:47:58 +0100
Cc: Jarkko Sakkinen <jarkko@kernel.org>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>,
 x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>,
 linux-sgx@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <393CAEF9-A79E-4399-B0F2-FA3BCAD46290@linux.dev>
References: <20241026113248.129659-1-thorsten.blum@linux.dev>
 <cd663aa6-28a1-4c03-9258-511285316c0f@intel.com>
To: "Huang, Kai" <kai.huang@intel.com>
X-Migadu-Flow: FLOW_OUT

On 28. Oct 2024, at 23:29, Huang, Kai wrote:
> On 27/10/2024 12:32 am, Thorsten Blum wrote:
>> Use vmalloc_array() instead of vmalloc() to calculate the number of
>> bytes to allocate.
>=20
> This says nothing about _why_.  Is it because we want to take =
advantage of the multiplication overflow check inside the =
vmalloc_array()?
>=20
> I don't know whether it is implied we should always use =
vmalloc_array() for array allocation like this, i.e., when we see =
vmalloc() is used for array allocation in the kernel we can just write a =
patch to replace it with vmalloc_array() and send to upstream.

It's discouraged to use open-coded arithmetic in allocator arguments:

=
https://www.kernel.org/doc/html/latest/process/deprecated.html#open-coded-=
arithmetic-in-allocator-arguments

Happy to add this, but I assumed it's obvious.
