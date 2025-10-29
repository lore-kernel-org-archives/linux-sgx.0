Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDDB12D7DEB;
	Wed, 29 Oct 2025 14:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761748671; cv=none; b=dmkgDHGkrMOxD0gkn73LGBmdwTim1MnjPMOBQJysxeSNTXq4PeX59wHfV08AZuoDdc0J8gVFbaYwW/0qnCzKyGkDufRptxgWLU0knR8OjV15KgQjt7+iY9kTQVJDaHI3ZzSvBbtsokieJM8R9uPAhu35jSVz3D/ApIFz/r2rdd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761748671; c=relaxed/simple;
	bh=M6eQkyRoGDKASEZmAd4hIUYpXaAhuwyswirLGyRxIHg=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=kStpHRHH7L8uotTFiOhyjexuUyDHfT9cljzrM78hOJCwFZajZGvFHIl55rPQ+4IwiHi76JLOZ5plpZ7jClOzbIMS08xcjeFFVSz7+yAjdxs4j2RdU2DcxRi6BF2LjdesGH4mBd/+PsxTC2p8uoS7ECRLgvrkHShHBNsxHKA6YO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=fail (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=JzV5Lfwn reason="signature verification failed"; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="JzV5Lfwn"
Received: from ehlo.thunderbird.net (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 59TEaGje2114125
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Wed, 29 Oct 2025 07:36:17 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 59TEaGje2114125
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025102301; t=1761748578;
	bh=QGcswXRVbhQ1LyEBlNcfoiqv+Nc2O8kRex4L8HOu5WM=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=JzV5LfwnaN3YZoFEcXJk0aEuwVs0R3X1Jp6aHvdg9ZA4jAWacYgpv5erHYC8fGgNz
	 qM8H9VJj1Eu/OZ1kncOGWS8TjnPZ/acfmL6StOoysolsmfax3vxC6ilFAfkGh42AoH
	 jKURrsIkh/da3GgaUpXxxNBWQnDJJlVEx5gb3GcDEl28Z9oM/7Sag9QUUixtWPhZAs
	 NEELTtRrsbxx1GdoudZogM4z2TBbUWVGsqwFz1kMB8I8SMjJPDdhU4NysyIPkjVlFa
	 Nc6LoiVA5GI2RnRf/WVHZ4t884R2kX6+PYN5cKbVg4Fr5OAoyHMxkVcDe3WIrhNb+U
	 3o/zm49rbPppA==
Date: Wed, 29 Oct 2025 07:36:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
To: Brian Gerst <brgerst@gmail.com>
CC: "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        =?ISO-8859-1?Q?Thomas_Wei=DFschuh?= <thomas.weissschuh@linutronix.de>,
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
Subject: Re: [PATCH 3/6] x86/entry/vdso32: remove int80_landing_pad
User-Agent: K-9 Mail for Android
In-Reply-To: <CAMzpN2g1G9Jc6eL4L+Rq3kGvKALt-tuaA3NKUuZ-jJXeaKuPRA@mail.gmail.com>
References: <20251026221208.1938173-1-hpa@zytor.com> <20251026221208.1938173-4-hpa@zytor.com> <CAMzpN2g1G9Jc6eL4L+Rq3kGvKALt-tuaA3NKUuZ-jJXeaKuPRA@mail.gmail.com>
Message-ID: <AC974749-2246-4F2C-96CC-B2CACE054C2E@zytor.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On October 28, 2025 11:54:43 PM PDT, Brian Gerst <brgerst@gmail=2Ecom> wrot=
e:
>On Sun, Oct 26, 2025 at 6:12=E2=80=AFPM H=2E Peter Anvin <hpa@zytor=2Ecom=
> wrote:
>>
>> There is no fundamental reason for the int80_landing_pad symbol=2E If i=
p
>> falls within the vdso, and the vdso is moved, we should change the ip
>> accordingly, regardless of mode or location within the vdso=2E This
>> *currently* can only happen on 32 bits, but there isn't any reason not
>> to do so generically=2E
>>
>> Note that if this is ever possible from a vdso-internal call, then the
>> user space stack will also needed to be adjusted (as well as the
>> shadow stack, if enabled=2E) Fortunately this is not currently the case=
=2E
>>
>> At the moment, we don't even consider other threads when moving the
>> vdso=2E The assumption is that it is only used by process freeze/thaw
>> for migration, where this is not an issue=2E
>>
>> Signed-off-by: H=2E Peter Anvin (Intel) <hpa@zytor=2Ecom>
>> ---
>>  arch/x86/entry/vdso/vdso32/system_call=2ES |  1 -
>>  arch/x86/entry/vdso/vma=2Ec                | 16 ++++++----------
>>  arch/x86/tools/vdso2c=2Ec                  |  1 -
>>  3 files changed, 6 insertions(+), 12 deletions(-)
>>
>> diff --git a/arch/x86/entry/vdso/vdso32/system_call=2ES b/arch/x86/entr=
y/vdso/vdso32/system_call=2ES
>> index 2a15634bbe75=2E=2Ed14eca4403c5 100644
>> --- a/arch/x86/entry/vdso/vdso32/system_call=2ES
>> +++ b/arch/x86/entry/vdso/vdso32/system_call=2ES
>> @@ -62,7 +62,6 @@ __kernel_vsyscall:
>>
>>         /* Enter using int $0x80 */
>>         int     $0x80
>> -SYM_INNER_LABEL(int80_landing_pad, SYM_L_GLOBAL)
>
>This is still needed by do_fast_syscall_32()=2E
>
>
>Brian Gerst
>

Yeah, that was a complete brainfart on my part=2E I'm already reworking th=
e patchset, fixing this and adding more improvements=2E=20
