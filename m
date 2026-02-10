Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91A5481DD;
	Tue, 10 Feb 2026 04:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770699275; cv=none; b=qjwaqfEa9SOLkFMEQlTwAszVnYvtn82tkGlGunJJdRW803u7uSREfwRO0nn5C/cOAdWtjMukcSMou1iOLU/wZfIdVKjGS1qLOmStCO6zAo9Kfjrk/tRa95ifeEuUMHOTzPNUa0CuWWJDyk5WSwLeP9f9bDKY92Gm75D22zAjqAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770699275; c=relaxed/simple;
	bh=LAmk1uUmkdj2pvr32jtxaZ4QFXQMlzs+XnQrEuXx7tU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rjww77NMM32JmzcxAyw67wYVHy6tYiideDSmHlwj+lBisiLN/3oVNXZWN6g/QuCpsWLo8UxW5qEi4hA2Nl8awtLeMVA/xmkNEL2/StURZkMe4a2+xX6xovr42fguBbN/iaXDD4SZcnOVz2TV4QH5kQ1uH/4aH8NLs7xm0zNL5bE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=fail (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=yNvTN0pe reason="signature verification failed"; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="yNvTN0pe"
Received: from [172.27.2.41] (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 61A4rgZ73161123
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Mon, 9 Feb 2026 20:53:46 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 61A4rgZ73161123
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026012301; t=1770699228;
	bh=2bNWrVed5hiVY9k9jymxZoTWwuaSvQ8Ymeerd9cVzBw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=yNvTN0pe26bHPATpWFRmwqoqklz5c582dxuNgT4A/bKgN5pLU0jFAk575K6BAd7+z
	 xjLjpkuwenalssCyfl3PszY8fLDEayQ8hcTTGn+tB/8kkpANRtL2yyfT0pzKn3Qk/Q
	 Oybo3fCBQomkN8XJpiXZRSKFK69skiMIqwSuGPXoIZBFmoMQHX2YBhcbdwfnuv5ORE
	 +eNmfFqsmXqBFZyJkX9HByk17dT4BABUHjI8Yrf6HqPH7iGhASa66yiYG7MiA0BZy2
	 9/8VepqAkbm9byqAFURrIdCJTM2jyWhYHNcFYVz15MkRx4dBdpBG5B3zZ/dEbXygw6
	 ZpOAU1e3xBIBw==
Message-ID: <bbd9ee1e-d604-43d6-9cb5-77e2972807ef@zytor.com>
Date: Mon, 9 Feb 2026 20:53:37 -0800
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4.1 06/10] x86/entry/vdso32: remove open-coded DWARF in
 sigreturn.S
To: Xi Ruoyao <xry111@xry111.site>, Jens Remus <jremus@linux.ibm.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
        Xin Li <xin@zytor.com>, Andrew Cooper <andrew.cooper3@citrix.com>,
        Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Brian Gerst <brgerst@gmail.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, James Morse <james.morse@arm.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>, Kees Cook <kees@kernel.org>,
        Nam Cao <namcao@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Perry Yuan <perry.yuan@amd.com>, Thomas Gleixner <tglx@linutronix.de>,
        Thomas Huth <thuth@redhat.com>, Uros Bizjak <ubizjak@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-sgx@vger.kernel.org, x86@kernel.org,
        Indu Bhagat <indu.bhagat@oracle.com>,
        Claudiu Zissulescu-Ianculescu <claudiu.zissulescu-ianculescu@oracle.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>
References: <vdso-cleanup-patch-4.1@zytor.com>
 <20260106211856.560186-6-hpa@zytor.com>
 <223707e2-3231-4037-bd1f-490ddf6aeeb6@linux.ibm.com>
 <B4C09939-9216-457E-8C93-052521FFE96F@zytor.com>
 <f3412cc3e8f66d1853cc9d572c0f2fab076872b1.camel@xry111.site>
 <29D95765-BD93-451D-8FD8-54250ADE1DEB@zytor.com>
 <0ee773dea213f6efbdac03009ee80f350b17c949.camel@xry111.site>
Content-Language: en-US, sv-SE
From: "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <0ee773dea213f6efbdac03009ee80f350b17c949.camel@xry111.site>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026-02-09 20:45, Xi Ruoyao wrote:
>>
>> Oh, good grief...
>>
>> How does this possibly work on non-x86 platforms?
> 
> On ARM64 the vdso does not have eh_frame_hdr at all, on LoongArch
> eh_frame_hdr is empty (note that an ampty en_frame_hdr is actually buggy
> and I'm trying to fix it), so _Unwind_Find_FDE returns NULL and libgcc
> falls back to MD_FALLBACK_FRAME_STATE_FOR, which handles the sigreturn
> trampoline using some machine-dependant logic.
> 
> On RISC-V things are more theatrical: the sigreturn trampoline happens
> to be at the beginning of the vdso .text section, so after subtracting 1
> from the PC, the result is out of the .text section and so not in any
> FDE.  Thus _Unwind_Find_FDE returns NULL and libgcc again falls back to
> MD_FALLBACK_FRAME_STATE_FOR.
> 
> If the RISC-V sigreturn trampoline was not the first in .text,
> subtracting 1 would cause the PC to be in the FDE of the previous
> function and then _Unwind_Find_FDE would return that FDE, then RISC-V
> would have some big trouble.
> 
> I've not taken a serious look at other architectures yet.
> 

In other words, it is broken on pretty much all architectures and it ends up
using the hacky fallbacks on every single platform...

	-hpa

