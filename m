Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF941E1A3D;
	Fri, 14 Nov 2025 21:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763154606; cv=none; b=oL9IIAMd/dnWhPvnx8ZXed5DY+4gNXJ5UPqNw44hSBSiRQYTD0qYW4ZYuHIYDsfbfNEwlFiVwlm4fwZptgw4MhA+Fqb50hRQqaGQ3PfOtUSc94oLikztV8BUCCep88Z6kUArSVkbvToQ/5TOXr7EyVh0ccAi4qKMlvI+lkrbtXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763154606; c=relaxed/simple;
	bh=QYc9Dp9s7QOHAPWLzKnON1Ede21oUaDHaYnAhovtQyM=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=c90WgWRjOg3bAm3KLGfVv+YbGVX1B0LzSVjjd1zD/l0YPE8AUNPkaQrtFMYIJ/KRSxgDIsmEvoqwzXDhPdLCg2ivGxf9OX92fwISB1+ozgiP72WzIwPsEUr5zZd4VbjOuCLf80Plo8DJcF/pZNF7+Nws6HMoImYYBPsB3Tu+OkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=fail (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=nIOokMcL reason="signature verification failed"; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="nIOokMcL"
Received: from [172.27.2.41] (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 5AEL8xhk2436810
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Fri, 14 Nov 2025 13:08:59 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 5AEL8xhk2436810
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025102301; t=1763154542;
	bh=n2ue0i9Kn3tpKl7Mfn0W4IHLdPAlAjgfywYY9MFn3/w=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=nIOokMcL0nZVqs1kMOROePbzmN64KK9utodHI0BbQCAJYs0XDAh9jBT2gqtFuD3zM
	 Ai8zZ2wKaYwKWOLYjL16VqdC8RSTLXVZl1GvZ1Sc1xxHarPwcr9p3uQqa7MErjF41Z
	 1QNxXRXMtC0j1COezcBvSwdVlckIYcz9r3JMl7q3j7knmORqgvY9X0quSsTEu5ZV7X
	 kpVcuWxqnPVHbDK/iMNAsaSCdtmeYz0cqk0/FA+ytQzOvjMXUeeq4NP6ZLDu4PtW7K
	 ng4DxBUJF24K/23Ny8bXMFYjE/XaVNqwJh3qgms0qVJjz8Gehbuj02WFT1AiWs9AjA
	 u7oYTaR6IA3HA==
Message-ID: <c0f19f86-043b-470a-9196-06323974ac54@zytor.com>
Date: Fri, 14 Nov 2025 13:08:58 -0800
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 7/9] x86/vdso: abstract out vdso system call internals
From: "H. Peter Anvin" <hpa@zytor.com>
To: Uros Bizjak <ubizjak@gmail.com>,
        Alexey Makhalov <alexey.makhalov@broadcom.com>
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
        Thomas Huth <thuth@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-sgx@vger.kernel.org, x86@kernel.org
References: <20251112043730.992152-1-hpa@zytor.com>
 <20251112043730.992152-8-hpa@zytor.com>
 <CAFULd4aMOueG5y3K7F57ryLtt-JUhE-yfsDODC=5+bgjF_gtSw@mail.gmail.com>
 <d5531acf-cd79-428d-80d1-eb7562cf3922@zytor.com>
 <CAFULd4bfxaSy0kkVjfjqgHe=3iT-QcGAhbK9WFepPmZu7=ocjw@mail.gmail.com>
 <B00D1422-204D-4ACE-AE00-94ACEA7430F7@zytor.com>
Content-Language: en-US, sv-SE
In-Reply-To: <B00D1422-204D-4ACE-AE00-94ACEA7430F7@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2025-11-13 20:40, H. Peter Anvin wrote:
> 
> For 64 bits, if you need frame pointer support *and* frob %rsp, using:
> 
> xchg %[arg],%%rbp
> <stuff>
> xchg %[arg],%%rbp
> 
> ... is probably easiest, with %[arg] in a register.
> 

Incidentally, ORC is one thing, but if you need DWARF information to be
correct for user space, it is definitely "fun".  With the xchg hack for 64
bits it is just a matter of using .cfi_def_cfa_register to change the frame
pointer around, but in the 32-bit case the best I could come up with was:

	.cfi_remember_state
	push %ebp
	.cfi_escape 0x0f,3,0x74,0,0x06	// CFA address in *%esp
	mov %eax, %ebp
	mov $syscall_no, %eax
	int $0x80
	pop %ebp
	.cfi_restore_state

Note that in both cases you need to *NOT* put in any of these CFI directives
when compiling without frame pointers (in which case you need to let gcc take
care of it if you want any hope of getting the CFI correct.)

	-hpa

