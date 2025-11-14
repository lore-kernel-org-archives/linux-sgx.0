Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC43F2C1581;
	Fri, 14 Nov 2025 04:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763095301; cv=none; b=tujpEKtqbaqWzFHMBTU68bfQTA9OPrNX90DXk7ObpAQjIVC0x6akm2V97pA9BOTuCsNZ7SG5+YxFfTCOJofsEgpxYnalsOKDOx3J0MkkQGvRZCRtupw7Y3OwYC3IkVX40yczpghmNe6BoZAi6DdekPbicHU9gdRKrdh105ynOHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763095301; c=relaxed/simple;
	bh=g/hh8TRj9wStMKmDn34TuTPE67+b3Uf34EKuZLfVArg=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=i1MnTdbHUroq/t8bc0U4EBU7GZc7sjof7H0fqnynSW3tLygwj14UmuSoksY15scN2wfOrQBWNMb8pMkmRFSms6huZjY6weBm+lPqqb2qDpNIy3pZ3MbYuYPWfXChDSe9uJ+f0ogT7d8Z2g8J9vuDfNdgKgkuaJthFP5Hp9mi24k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=fail (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=K9SDNwe0 reason="signature verification failed"; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="K9SDNwe0"
Received: from ehlo.thunderbird.net (sfsymphony1.static.monkeybrains.net [208.90.214.66])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 5AE4ed9U1921817
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Thu, 13 Nov 2025 20:40:40 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 5AE4ed9U1921817
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025102301; t=1763095241;
	bh=97ZI1DV37mgHB4KO9c/1pz2K9royVseEBh1e0LpLLFY=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=K9SDNwe0uGJQ2fMWwnT4JB22olsFwwuaIMoDVSofKYVvzJBQh0AjCIjlGAiTONRFk
	 pjaXbCJqqa1MzalVsK/xAH0VsE7Wub3xLGOn9jhvIJ521q/yFQ+DeRPGZ2N1RbEURc
	 /h3oMUwbjuOjC41rjTLUVMjf6P3PBtFTIr0Oc560y2SJUIyjTfJWidv3nTgPjcoU4Z
	 5EXa5R7UPU7lV9QJq+OVRjEwSDjd93twS2BLsApC7ksEzsvw+MkWLkh5O544nTs+F7
	 XGxUGP2jHOkcU+eSxsnHCkLkoT0ts0zBCZTZydTumVY6+rDtqLqMOoHhf9XlDIC4Za
	 4BFNvVnh8j//Q==
Date: Thu, 13 Nov 2025 20:40:39 -0800
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
Message-ID: <B00D1422-204D-4ACE-AE00-94ACEA7430F7@zytor.com>
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

For 64 bits, if you need frame pointer support *and* frob %rsp, using:

xchg %[arg],%%rbp
<stuff>
xchg %[arg],%%rbp

=2E=2E=2E is probably easiest, with %[arg] in a register=2E
