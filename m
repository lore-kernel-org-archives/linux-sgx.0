Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36E1035CBBC;
	Fri, 14 Nov 2025 04:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763095764; cv=none; b=aRL+CEFeA5qhuRBHZds+j2SYIWT/Qu2SSBIVxqrQNKiwwGqFKShBmlgtbJTU2OSZBgrk9bImOZrADBoYCG9Tv01KDT/nbWKPw7qTYkvbo7xBTeLtFJqBAJ6DMOx+lwPWNl0Vvi/vmee3NKGd5wrX/56tj56g5ilW1bl1+SmVOjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763095764; c=relaxed/simple;
	bh=Gyah0Z8XwRLy7PTxhhXgQEoBGaJ96p2rTq81ghjrBoQ=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=gTQl7/RdPD5LK+ZoFzTXmTPmr7JRKbvRv8wHDQjSQimZcAnAZhRUxODRGv2pSX2/rUjBtprxSsWDyJPybshpb9i9ADz21k6JKSyt5r2s5jKfqd6wIly4fShNzZ25VX8Am7nE3KJzhfSuZkdt1fCJ2s6GX73K2uB8pzoGkpZhV18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=fail (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=mcKduUbP reason="signature verification failed"; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="mcKduUbP"
Received: from ehlo.thunderbird.net (sfsymphony1.static.monkeybrains.net [208.90.214.66])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 5AE4mVO61925023
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Thu, 13 Nov 2025 20:48:32 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 5AE4mVO61925023
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025102301; t=1763095714;
	bh=K5YWWAVRgN8FQz6Otg8fg4nQaM9D7J06Mu/UbfQ9S4M=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=mcKduUbPOrPu5vaYqEtPHe1BtcZXeJxdyIR7a9GI7ZeS8ygpDymkCX77Tj2qFAQMP
	 6woF4ACuH/huhgocvVOu9Nz4kk9xQaHRNR8vOc1TdB/caNNuLpACwE1ELrFrInIGwm
	 MouOk338h7AJquCSfTGQF2J5lcGIwwgYk4G881hOsnjgiQRrYGCiHruN6B3/K318IA
	 IzBRq/67YGzpfsWpw9SbYErKwB3Ym7gA7MNVhX/wIvctECR/SjKqWpUe3rOJNFG/oI
	 ZQ9jdQbP1gl56CMw9ysfHI9u5WtR6lzi4gFZPr1FRRN2C/4ieQUJkZdEXYyu+mNdSA
	 tASa90L+h0omQ==
Date: Thu, 13 Nov 2025 20:48:31 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
To: Uros Bizjak <ubizjak@gmail.com>,
        Alexey Makhalov <alexey.makhalov@broadcom.com>
CC: "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        =?ISO-8859-1?Q?Thomas_Wei=DFschuh?= <thomas.weissschuh@linutronix.de>,
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
Subject: Re: [PATCH v2 7/9] x86/vdso: abstract out vdso system call internals
User-Agent: K-9 Mail for Android
In-Reply-To: <CAFULd4bfxaSy0kkVjfjqgHe=3iT-QcGAhbK9WFepPmZu7=ocjw@mail.gmail.com>
References: <20251112043730.992152-1-hpa@zytor.com> <20251112043730.992152-8-hpa@zytor.com> <CAFULd4aMOueG5y3K7F57ryLtt-JUhE-yfsDODC=5+bgjF_gtSw@mail.gmail.com> <d5531acf-cd79-428d-80d1-eb7562cf3922@zytor.com> <CAFULd4bfxaSy0kkVjfjqgHe=3iT-QcGAhbK9WFepPmZu7=ocjw@mail.gmail.com>
Message-ID: <6585D209-A4D7-4201-8E4C-F28DC97AED3F@zytor.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On November 12, 2025 11:15:08 PM PST, Uros Bizjak <ubizjak@gmail=2Ecom> wro=
te:
>On Wed, Nov 12, 2025 at 10:25=E2=80=AFPM H=2E Peter Anvin <hpa@zytor=2Eco=
m> wrote:
>>
>> On 2025-11-12 02:31, Uros Bizjak wrote:
>> >
>> > Unfortunately, %ebp is still special with -fno-omit-frame-pointer, so
>> > using "ebp" as _sys_arg6 on 32-bit targets will result in:
>> >
>> > error: bp cannot be used in =E2=80=98asm=E2=80=99 here
>> >
>> > Please see how %ebp register is handled in
>> > arch/x86/include/asm/vmware=2Eh, vmware_hypercall_hb_out() and
>> > vmware_hypercall_hb_in()=2E
>> >
>>
>> #ifdef CONFIG_X86_64
>> #define VMW_BP_CONSTRAINT "r"
>> #else
>> #define VMW_BP_CONSTRAINT "m"
>> #endif
>>
>>         asm_inline volatile (
>>                 UNWIND_HINT_SAVE
>>                 "push %%" _ASM_BP "\n\t"
>>                 UNWIND_HINT_UNDEFINED
>>                 "mov %[in6], %%" _ASM_BP "\n\t"
>>                 "rep outsb\n\t"
>>                 "pop %%" _ASM_BP "\n\t"
>>                 UNWIND_HINT_RESTORE
>>                 : "=3Da" (out0), "=3Db" (*out1)
>>                 : "a" (VMWARE_HYPERVISOR_MAGIC),
>>                   "b" (cmd),
>>                   "c" (in2),
>>                   "d" (in3 | VMWARE_HYPERVISOR_PORT_HB),
>>                   "S" (in4),
>>                   "D" (in5),
>>                   [in6] VMW_BP_CONSTRAINT (in6)
>>                 : "cc", "memory");
>>         return out0;
>>
>> That code is actually incorrect, in at least two ways:
>>
>>
>> 1=2E It should be conditioned on frame pointers enabled, not x86-64 vs =
i386=2E
>> 2=2E The compiler is perfectly within its right to emit an %esp-relativ=
e
>>    reference for the "m"-constrained [in6]=2E This is particularly like=
ly
>>    when *not* compiled with frame pointers, see #1=2E
>>
>> A better sequence might be:
>>
>>         pushl %[in6]
>>         push %ebp
>>         mov 4(%esp),%ebp
>>         <stuff>
>>         pop %ebp
>>         pop %[junk]
>>
>> Then %[in6] can even safely be a "g" constraint (hence pushl)=2E
>
>If we want to also handle x86_64, the above code (including push)
>needs to be 64-bit, with "rme" constraint for the pushed value=2E
>
>I have CC'd the author of the above code, he might be interested in
>the above discussion=2E
>
>Uros=2E
>

Note: for the specific case of VDSO_SYSCALL6 the %eax value is always a co=
nstant, so:

push %%ebp
mov %%eax,%%ebp
mov %[sysnr],%%eax /* "i" constraint */
<syscall sequence>
pop %%ebp

=2E=2E=2E would be easiest=2E
