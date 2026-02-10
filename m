Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BAFE481DD;
	Tue, 10 Feb 2026 04:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770699181; cv=none; b=Q3sTtSOUKUf/8vUGszqNd+6qGdhu/KllZsEti8zv/FF2yRlVItTLhv45hjhHMaUACEIsI3CWFbExFuO+jUn3h45rX5I2mRWtsLBIxcUkR5LBCY0EbZJx895wyVd5LmBnaP08O6E8ze/SnWdb9Zlkw1zq+7Cp8jBHg+xfEYhLyjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770699181; c=relaxed/simple;
	bh=dKW9S/3ebS83sHVJwxQBzBRwuxhi2vVbZ6VLySVRoOE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VhoT5kJ5QpCfI/xcSNIsmPIzTUbMpO5fwf4sPW1q+UjMJKYxR4s1FHTBViTFJLM+0kPmkNfS1z3J2/EKHdUv+AaVl9Re0S57MzIuwd7oCFK88m1zdwGdL1rwt4ClOuRHnsk6rT64bovap/NBJDg/BEwtqZHCaBVqttQ+QxgIDHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=fail (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=U3YJJY9V reason="signature verification failed"; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="U3YJJY9V"
Received: from [172.27.2.41] (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 61A4psgr3160871
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Mon, 9 Feb 2026 20:52:05 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 61A4psgr3160871
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026012301; t=1770699127;
	bh=g6Bj9LqRZNb1Yp1MwzoKZ+DxFnZS60EAUBqk+I/vrKA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=U3YJJY9VPXOQ8GoHouAoNKsb/wnuYIFZ5qXGKGfKdPBr7nLC+uNK+/acw+eMXOysa
	 GHXgPIfej78y8lFjARzluEBFtc8yihuq6sJvIHwss9+wY7BHgTlV7gXydNMQ2R5nrw
	 pPvxe1a+abPE5I7+W/ey+zW6IjRJ2Km9kE+hySRH+LoyTesdmy4Nfw3deVicsVnepZ
	 XvLtSXstteO46AYNEk8SXCcdIAhyKFQdO+gOnVfJ2q/A+SnA60IZ0XN60wwQI/CoED
	 PNHvXpkE3sTrUZ5B8kjdNuYwUxKhaMLmk2VaLeJdLWhh5yAShx2aRteOzQ0xfipOda
	 0cBLpjgso0O+A==
Message-ID: <e31817cb-c102-485c-8844-d81c39eac442@zytor.com>
Date: Mon, 9 Feb 2026 20:51:45 -0800
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
Content-Language: en-US, sv-SE
From: "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <f3412cc3e8f66d1853cc9d572c0f2fab076872b1.camel@xry111.site>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026-02-09 19:11, Xi Ruoyao wrote:
> On Mon, 2026-02-02 at 19:57 -0800, H. Peter Anvin wrote:
>> That hack dates back from before the signal frame extension. It is no
>> longer necessary.
> 
> Unfortunately at least it seems libgcc unwinder does not handle the
> signal frame extension properly.  The code reads:
> 
>   fde = _Unwind_Find_FDE (context->ra + _Unwind_IsSignalFrame (context) - 1, 
>                           &context->bases);
>   if (fde == NULL)
>     {    
> #ifdef MD_FALLBACK_FRAME_STATE_FOR
>       /* Couldn't find frame unwind info for this function.  Try a
>          target-specific fallback mechanism.  This will necessarily
>          not provide a personality routine or LSDA.  */
>       return MD_FALLBACK_FRAME_STATE_FOR (context, fs); 
> #else
>       return _URC_END_OF_STACK;
> #endif
>     }    
> 
>   fs->pc = context->bases.func;
> 
>   cie = get_cie (fde);
>   insn = extract_cie_info (cie, context, fs); 
> 
> Thus, it indeed attempts to avoid subtracting 1 for a signal frame, but
> ... _Unwind_IsSignalFrame (context) actually extracts a flag in context
> which will only be raised up by extract_cie_info.
> 
> Or am I missing something here?
> 

Well, it looks like this might be a non-manifest bug on x86 *IN THIS CASE*,
because the fallback handler looks explicitly for the byte sequences:

	popl %eax
	movl $__NR_ia32_sigreturn, %eax
	int $0x80

	movl $__NR_ia32_rt_sigreturn, %eax
	int $0x80

	movq $__NR_x64_rt_sigreturn, %rax	/* !!!! */
	syscall

... so the vdso patchset is still OK.

Hard-coding a reliance on movq in the 64-bit sequence some serious brain damage...

Could you file a gcc bug on this?

	-hpa

