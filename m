Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C58D188A3A
	for <linux-sgx@vger.kernel.org>; Fri, 12 Dec 2025 21:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765573512; cv=none; b=RBzrJjPR1ihBuAozYo4qz4bRZYhfC+Uq3UkUYOJrZKkvRP+q9+jlqmV2jBZcbv1NCVC5hjCCg0rV0wsCWPkk1adSPPD6fGBuGfvwi/8HTZHPofpVjTPZQb45+vzhWLcJbr/3bjnOc6SjKUV9GUExBcINkg64ouOubovPjKPFsSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765573512; c=relaxed/simple;
	bh=hMRGAQyfylzv/kLjoaiH2FGFS5PrqWh/x2aIYspox8c=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=SSh6tDUlLWeGV69H9z6/VkNOon58c4Wu5CxgH92WEgL2l6fZasShhRs2QE0Jd+6QDQMS7K1GKz/gaytxTCAiE7Hw+2/q6HSbKukKGI+7A46yRR5IP4/Mj66nyPoHJwFg9/V2eLzKa+UYHo8C9cAJE8yV6do5HnHCykKELOzJCwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gBgWpL+J; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gBgWpL+J"
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765573503;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hMRGAQyfylzv/kLjoaiH2FGFS5PrqWh/x2aIYspox8c=;
	b=gBgWpL+J4/3wb1NvsW3E9M2LSyt2IAsHcC8IVeOF3y19LquUMFpmLDHB/8WDvuCbUkhmw4
	0g6Aw8OAWi+LZmbpJnL5U3PMVccpDsjC+KgzTK+MDfAGvny0eWsCY4m0dRvU8Oa65rtWGk
	H3UGySgPpjflNHITrF5/hKVhgdvs0bQ=
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81\))
Subject: Re: [PATCH] x86/sgx: Use goto to remove redundant if check in
 sgx_encl_init
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Thorsten Blum <thorsten.blum@linux.dev>
In-Reply-To: <aTsmYkI3ThbsfpIH@kernel.org>
Date: Fri, 12 Dec 2025 22:05:00 +0100
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
 Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>,
 x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>,
 linux-sgx@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <4A07D996-F409-4796-B02C-E8D39335B599@linux.dev>
References: <20251210130035.545132-1-thorsten.blum@linux.dev>
 <aTmSq5Px4P6vEUCb@kernel.org>
 <9651D503-F2D9-4FE0-9593-8D204360C258@linux.dev>
 <aTsjqDtWoIO_p60j@kernel.org> <aTsmYkI3ThbsfpIH@kernel.org>
To: Jarkko Sakkinen <jarkko@kernel.org>
X-Migadu-Flow: FLOW_OUT

On 11. Dec 2025, at 21:15, Jarkko Sakkinen wrote:
> On Thu, Dec 11, 2025 at 10:03:56PM +0200, Jarkko Sakkinen wrote:
>> On Wed, Dec 10, 2025 at 04:48:08PM +0100, Thorsten Blum wrote:
>>> On 10. Dec 2025, at 16:32, Jarkko Sakkinen wrote:
>>>> On Wed, Dec 10, 2025 at 02:00:35PM +0100, Thorsten Blum wrote:
>>>>> Immediately break out of both loops when 'ret !=3D =
SGX_UNMASKED_EVENT'
>>>>> instead of checking for the same condition again in the outer =
loop.
>>>>>=20
>>>>> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
>>>>> ---
>>>>> [...]
>>>>=20
>>>> I don't think moving code around is very useful.
>>>=20
>>> The patch doesn't actually move any code around, but it removes up =
to 50
>>> (SGX_EINIT_SLEEP_COUNT) duplicate and therefore unnecessary if =
checks in
>>> the outer for loop.
>>=20
>> Temporary change for generating disassembly:
>> [...]
>=20
> It pretty much does what I said i.e., shuffles a new location for a =
code block.

GCC emits a much larger diff; however, discussing the patch based solely
on the disassembled code probably isn't very meaningful.

Thanks,
Thorsten

