Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1BF23A9AE
	for <linux-sgx@vger.kernel.org>; Wed, 10 Dec 2025 15:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765381737; cv=none; b=oXQoSP/ggsCiq7nXMRCPx9d0Zqao40ztrtGI6sgpcwqr/u8mvbhYAED+eXTVY4MRe4FnKIfbhbVuHaP6s3+YAtTnHTPhInWpy3c2EbKY0IEM9JdBaiVRvv13HZaUAEStsmDF/ftgP6N6Rvxr5voC4iDDHWXQteXPDwMIqVEyIdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765381737; c=relaxed/simple;
	bh=I8pGY7uzM1bKEYtDArmBLBtQqtLnX40OIsWGpYckGhU=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=nS31SKuMl8yLWkDOifksQ+awvxV41sXM03iJWjzMLTDBRdmNC9OIDEtZYj76Lqxo80/DJWlYIyRdONVL6IJeZ9fJAg40iyeoL8F1bLO9KUmj/7ZIACZMgLssonclwC4vFd2Du+1GcR+ozzeuAi+Vs40ixkGbSwC4cV/jQSbUGCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Enr000sz; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Enr000sz"
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765381723;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CmSmsy9of/FsvpRFX//F0lS8YsK2NLUj1UdR3A2yZ1k=;
	b=Enr000sz8Cp0gCHry3D2ddxeOyQ4Bmq/qUQPHuLEoerJA4p3U2UfmrUhYpEhz22Go3hfcd
	KIIGbpFBwVgVwVpreHTCUFEEOFw2vTk1DHbH6hHnLtryORqJyuiRg6knDbOG++9YzTvBaS
	IgHZ9AKh0b+YdiuAic9j0OOnX32+FrY=
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
In-Reply-To: <aTmSq5Px4P6vEUCb@kernel.org>
Date: Wed, 10 Dec 2025 16:48:08 +0100
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
 Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>,
 x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>,
 linux-sgx@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <9651D503-F2D9-4FE0-9593-8D204360C258@linux.dev>
References: <20251210130035.545132-1-thorsten.blum@linux.dev>
 <aTmSq5Px4P6vEUCb@kernel.org>
To: Jarkko Sakkinen <jarkko@kernel.org>
X-Migadu-Flow: FLOW_OUT

On 10. Dec 2025, at 16:32, Jarkko Sakkinen wrote:
> On Wed, Dec 10, 2025 at 02:00:35PM +0100, Thorsten Blum wrote:
>> Immediately break out of both loops when 'ret != SGX_UNMASKED_EVENT'
>> instead of checking for the same condition again in the outer loop.
>> 
>> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
>> ---
>> [...]
> 
> I don't think moving code around is very useful.

The patch doesn't actually move any code around, but it removes up to 50
(SGX_EINIT_SLEEP_COUNT) duplicate and therefore unnecessary if checks in
the outer for loop.

Thanks,
Thorsten

