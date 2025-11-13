Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E6C35CBD3;
	Thu, 13 Nov 2025 21:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763068407; cv=none; b=F0S8AiCiTCQQCeZKwc33zBNqysLWLu0Ma3o/QmmzIgOFFx25qYUlYzaf1FLBKLuX7KNQCh3HnO1VFy23rKN4rmWAJuwKug6R++6wuui5fOLDSaT0cUXV8j+WemXO54ZxdCrXfxrCSBDIb9xnLiD6CCIamYFyg0hvtU2WrcIc+CQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763068407; c=relaxed/simple;
	bh=z/t+FPssC7FRytGIeWmJBvEPiSwC0drRCUUDXq3To5I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mMO0YF4svpbm5QAuqiRBkT3b0nejG4QiG/vs778fXc+xr9xK/+Bhs25ns5iuHgSpr3NvVysAxZVHkE4/Lm4+tTWtBi7ZYBO/1gVWZghPON6/fKjvtVyJTMFfj69PEwtdDT9TjsUYasJ+/VR2V106aT0sMFUg9XAqBMlZH93kmqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=fail (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=uSzqUgIp reason="signature verification failed"; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="uSzqUgIp"
Received: from [172.27.2.41] (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 5ADLBtsW1690815
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Thu, 13 Nov 2025 13:11:56 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 5ADLBtsW1690815
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025102301; t=1763068318;
	bh=OrDKRTzj3kKFdy7QAY80nNNT+tK9Pn5aomuJbe41Zn4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=uSzqUgIpXEnb6A+cdUjoYeYdbD+FFTttRbCkD0M8E7Y8b1NlU2nwL/DM9qNpmcrgH
	 fjuV9eV9p0/z/aQE8c5yCzM6YxJgy64uWfY4tLppXr7A6TaR76HXZl9Ghfr0veduMj
	 IPKqtkzJMOe2M0wdP/a7FKbGKnzJwAjWT3SUBMXyjenkaSKP2QKbwLjiDJIQSFblzy
	 +cX02bwPDtVJOqViVQVCUbPaP0W4QVC9IbdCBfOjJ5r5kDQDmjuxK3iQ70Dpbddjfx
	 ldxg88EH40fza71x4Z8ua9NZFkrSfTzOgz1IZNyDkbaZullS2h94G2HS/vUrk14OKP
	 tscMl1fE0gpcg==
Message-ID: <1cd27f96-9f29-4607-90d8-c98593eacfbb@zytor.com>
Date: Thu, 13 Nov 2025 13:11:55 -0800
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/9] x86/entry/vdso: refactor the vdso build
To: Brian Gerst <brgerst@gmail.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
        Xin Li <xin@zytor.com>, Andrew Cooper <andrew.cooper3@citrix.com>,
        Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, James Morse <james.morse@arm.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>, Kees Cook <kees@kernel.org>,
        Nam Cao <namcao@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Perry Yuan <perry.yuan@amd.com>, Thomas Gleixner <tglx@linutronix.de>,
        Thomas Huth <thuth@redhat.com>, Uros Bizjak <ubizjak@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-sgx@vger.kernel.org, x86@kernel.org
References: <20251112202258.1310754-1-hpa@zytor.com>
 <20251112202258.1310754-3-hpa@zytor.com>
 <CAMzpN2iwrzKzhif7WXsoQi=4OdBENZMV14Hm2a5ePukywNgh1w@mail.gmail.com>
Content-Language: en-US, sv-SE
From: "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <CAMzpN2iwrzKzhif7WXsoQi=4OdBENZMV14Hm2a5ePukywNgh1w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2025-11-13 10:38, Brian Gerst wrote:
> 
> Some of these changes (like moving vdso2c) can be split out into
> smaller patches.
> 

Sure, but is it worth the extra work?

	-hpa

