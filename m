Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A95A67260F;
	Tue,  3 Feb 2026 03:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770091159; cv=none; b=RmDoP5+gtfDsmmob+4wlTNxe6gOCg2dtJYwacnMKF61NiB6gDB2rTErQu6BGqHVr/cuJL1O232C/z4Zpl5WQelNQOvj7j/F1sBViepnxtpggud+9RdoWH2nny6Ad8awpcS2F0lZElbFffffClU0bGzkqfurlHIIFNFYeLRC2+Ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770091159; c=relaxed/simple;
	bh=EvR04w18FWEna12Arvx70srWFCf3rb3bUqa2iD97Yjk=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=Cw6Fl0UBCH5iAzgUMgyaUoodpjndSBeYECdWsCoaU3WxufX7WTY3v8JCQWs5TaW4WSsR5U0sNrjBNPUY6+9GtlDx06uoK+oID03DazNgnJgNDEMYBqC9xzDyz8eMBL/GpsJQDhbijzShi4g/T5g2V5UiPd0mN3eka179wrnWRmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=fail (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=NIQKq/zu reason="signature verification failed"; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="NIQKq/zu"
Received: from ehlo.thunderbird.net (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 6133vk3W3170984
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Mon, 2 Feb 2026 19:57:47 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 6133vk3W3170984
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026012301; t=1770091070;
	bh=kYNk1uESj2SdlyhEUgCh4uBoF2hsXCsmavJNLvewoyg=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=NIQKq/zu2+acVlOXWh6sSfEQ8JkbE+NqM13UYjoCRqOtnwEXlB/i9XR0vM71yA+q2
	 yo6IE2xbl2AIGaxb4uCbdtgdzHjbjINGCySSmvT2BPogG3MWulce6FQSOv9JoTPcGI
	 hS8NDD2tk0UcT+Lxf/Vd/1Nf+zhNNu+vuh2vs7626ZsBpsiK3SjI8WMXXh6UdHHjBW
	 AL8W7E1fn0ou3GTzdQmIZVOEL06kICoWYk6oVjhQduLuxPl2IuNsthZlnNrm6kFEtY
	 YC/VqQy2lD2fd/IchD2/NZHlYEzNbhZVJff5Ac7J9ZF+Mt+h3VfEJkcC4whVjLQBfG
	 KclzhxHP7IGwQ==
Date: Mon, 02 Feb 2026 19:57:42 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
To: Jens Remus <jremus@linux.ibm.com>
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
        Thomas Huth <thuth@redhat.com>, Uros Bizjak <ubizjak@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-sgx@vger.kernel.org, x86@kernel.org,
        Indu Bhagat <indu.bhagat@oracle.com>,
        Claudiu Zissulescu-Ianculescu <claudiu.zissulescu-ianculescu@oracle.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v4=2E1_06/10=5D_x86/entry/vdso32?=
 =?US-ASCII?Q?=3A_remove_open-coded_DWARF_in_sigreturn=2ES?=
User-Agent: K-9 Mail for Android
In-Reply-To: <223707e2-3231-4037-bd1f-490ddf6aeeb6@linux.ibm.com>
References: <vdso-cleanup-patch-4.1@zytor.com> <20260106211856.560186-6-hpa@zytor.com> <223707e2-3231-4037-bd1f-490ddf6aeeb6@linux.ibm.com>
Message-ID: <B4C09939-9216-457E-8C93-052521FFE96F@zytor.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On February 2, 2026 9:02:48 AM PST, Jens Remus <jremus@linux=2Eibm=2Ecom> w=
rote:
>Hello Peter!
>
>On 1/6/2026 10:18 PM, H=2E Peter Anvin wrote:
>> The vdso32 sigreturn=2ES contains open-coded DWARF bytecode, which
>> includes a hack for gdb to not try to step back to a previous call
>> instruction when backtracing from a signal handler=2E
>>=20
>> Neither of those are necessary anymore: the backtracing issue is
>> handled by "=2Ecfi_entry simple" and "=2Ecfi_signal_frame", both of whi=
ch
>> have been supported for a very long time now, which allows the
>> remaining frame to be built using regular =2Ecfi annotations=2E
>
>Hopefully Glibc developers will do something similar for x86-64
>__restore_rt() in Glibc sysdeps/unix/sysv/linux/x86_64/libc_sigaction=2Ec=
=2E
>
>>=20
>> Add a few more register offsets to the signal frame just for good
>> measure=2E
>>=20
>> Replace the nop on fallthrough of the system call (which should never,
>> ever happen) with a ud2a trap=2E
>> diff --git a/arch/x86/entry/vdso/vdso32/sigreturn=2ES b/arch/x86/entry/=
vdso/vdso32/sigreturn=2ES
>
>>  	=2Etext
>>  	=2Eglobl __kernel_sigreturn
>>  	=2Etype __kernel_sigreturn,@function
>> -	nop /* this guy is needed for =2ELSTARTFDEDLSI1 below (watch for HACK=
) */
>>  	ALIGN
>>  __kernel_sigreturn:
>> -=2ELSTART_sigreturn:
>> -	popl %eax		/* XXX does this mean it needs unwind info? */
>> +	STARTPROC_SIGNAL_FRAME IA32_SIGFRAME_sigcontext
>> +	popl %eax
>> +	CFI_ADJUST_CFA_OFFSET -4
>>  	movl $__NR_sigreturn, %eax
>>  	int $0x80
>> -=2ELEND_sigreturn:
>
>=2E=2E=2E
>
>>  	=2Eglobl __kernel_rt_sigreturn
>>  	=2Etype __kernel_rt_sigreturn,@function
>>  	ALIGN
>>  __kernel_rt_sigreturn:
>> -=2ELSTART_rt_sigreturn:
>> +	STARTPROC_SIGNAL_FRAME IA32_RT_SIGFRAME_sigcontext
>>  	movl $__NR_rt_sigreturn, %eax
>>  	int $0x80
>> -=2ELEND_rt_sigreturn:
>
>=2E=2E=2E
>
>> -	=2Esection =2Eeh_frame,"a",@progbits
>> -=2ELSTARTFRAMEDLSI1:
>> -	=2Elong =2ELENDCIEDLSI1-=2ELSTARTCIEDLSI1
>> -=2ELSTARTCIEDLSI1:
>> -	=2Elong 0			/* CIE ID */
>> -	=2Ebyte 1			/* Version number */
>> -	=2Estring "zRS"		/* NUL-terminated augmentation string */
>
>Note that the "S" in "zRS" is the signal frame indication=2E
>
>> -	=2Euleb128 1		/* Code alignment factor */
>> -	=2Esleb128 -4		/* Data alignment factor */
>> -	=2Ebyte 8			/* Return address register column */
>> -	=2Euleb128 1		/* Augmentation value length */
>> -	=2Ebyte 0x1b		/* DW_EH_PE_pcrel|DW_EH_PE_sdata4=2E */
>> -	=2Ebyte 0			/* DW_CFA_nop */
>> -	=2Ealign 4
>> -=2ELENDCIEDLSI1:
>> -	=2Elong =2ELENDFDEDLSI1-=2ELSTARTFDEDLSI1 /* Length FDE */
>> -=2ELSTARTFDEDLSI1:
>> -	=2Elong =2ELSTARTFDEDLSI1-=2ELSTARTFRAMEDLSI1 /* CIE pointer */
>> -	/* HACK: The dwarf2 unwind routines will subtract 1 from the
>> -	   return address to get an address in the middle of the
>> -	   presumed call instruction=2E  Since we didn't get here via
>> -	   a call, we need to include the nop before the real start
>> -	   to make up for it=2E  */
>> -	=2Elong =2ELSTART_sigreturn-1-=2E	/* PC-relative start address */
>
>Your version does no longer have this nop nor does the FDE start one
>byte earlier=2E  Isn't that required for unwinders any longer?
>See excerpt from dumped DWARF and disassembly for __kernel_sigreturn()
>below=2E
>
>> -	=2Elong =2ELEND_sigreturn-=2ELSTART_sigreturn+1
>> -	=2Euleb128 0			/* Augmentation */
>=2E=2E=2E
>
>> -	=2Ealign 4
>> -=2ELENDFDEDLSI1:
>> -
>> -	=2Elong =2ELENDFDEDLSI2-=2ELSTARTFDEDLSI2 /* Length FDE */
>> -=2ELSTARTFDEDLSI2:
>> -	=2Elong =2ELSTARTFDEDLSI2-=2ELSTARTFRAMEDLSI1 /* CIE pointer */
>> -	/* HACK: See above wrt unwind library assumptions=2E  */
>> -	=2Elong =2ELSTART_rt_sigreturn-1-=2E	/* PC-relative start address */
>
>Ditto=2E
>
>> -	=2Elong =2ELEND_rt_sigreturn-=2ELSTART_rt_sigreturn+1
>> -	=2Euleb128 0			/* Augmentation */
>
>Excerpt from dump of DWARF and disassembly with your patch:
>
>$ objdump -d -Wf arch/x86/entry/vdso/vdso32/vdso32=2Eso=2Edbg
>=2E=2E=2E
>000001cc 0000003c 00000000 CIE   <-- CIE for __kernel_sigreturn
>  Version:               1
>  Augmentation:          "zRS"
>  Code alignment factor: 1
>  Data alignment factor: -4
>  Return address column: 8
>  Augmentation data:     1b
>  DW_CFA_def_cfa: r4 (esp) ofs 4
>  DW_CFA_offset_extended_sf: r8 (eip) at cfa+56
>  DW_CFA_offset_extended_sf: r0 (eax) at cfa+44
>  DW_CFA_offset_extended_sf: r3 (ebx) at cfa+32
>  DW_CFA_offset_extended_sf: r1 (ecx) at cfa+40
>  DW_CFA_offset_extended_sf: r2 (edx) at cfa+36
>  DW_CFA_offset_extended_sf: r4 (esp) at cfa+28
>  DW_CFA_offset_extended_sf: r5 (ebp) at cfa+24
>  DW_CFA_offset_extended_sf: r6 (esi) at cfa+20
>  DW_CFA_offset_extended_sf: r7 (edi) at cfa+16
>  DW_CFA_offset_extended_sf: r40 (es) at cfa+8
>  DW_CFA_offset_extended_sf: r41 (cs) at cfa+60
>  DW_CFA_offset_extended_sf: r42 (ss) at cfa+72
>  DW_CFA_offset_extended_sf: r43 (ds) at cfa+12
>  DW_CFA_offset_extended_sf: r9 (eflags) at cfa+64
>  DW_CFA_nop
>
>0000020c 00000010 00000044 FDE cie=3D000001cc pc=3D00001a40=2E=2E00001a4a=
   <-- FDE for __kernel_sigreturn
>  DW_CFA_advance_loc: 1 to 00001a41
>  DW_CFA_def_cfa_offset: 0
>
>[ The FDE covers the range [1a40=2E=2E1a4a[=2E  Previously it would have
>started one byte earlier (at the nop), so that the range would have
>been [1a3f=2E=2E1a4a[=2E  This is/was required for unwinders that always
>subtract one from the unwound return address, so that it points into
>the instruction that invoked the function (e=2Eg=2E call) instead of behi=
nd
>it, in case it was invoked by a non-returning function=2E  Such an
>unwinder would now lookup IP=3D1a3f as belonging to int80_landing_pad (an=
d
>use the DWARF rules applicable to its last instruction) instead of
>__kernel_sigreturn (and its rules)=2E  Likewise for __kernel_rt_sigreturn=
=2E ]
>
>=2E=2E=2E
>00001a3c <int80_landing_pad>:
>    1a3c:       5d                      pop    %ebp
>    1a3d:       5a                      pop    %edx
>    1a3e:       59                      pop    %ecx
>    1a3f:       c3                      ret
>
>00001a40 <__kernel_sigreturn>:
>    1a40:       58                      pop    %eax
>    1a41:       b8 77 00 00 00          mov    $0x77,%eax
>    1a46:       cd 80                   int    $0x80
>
>00001a48 <vdso32_sigreturn_landing_pad>:
>    1a48:       0f 0b                   ud2
>    1a4a:       8d b6 00 00 00 00       lea    0x0(%esi),%esi
>
>
>Excerpt without your patch:
>
>$ objdump -d -Wf arch/x86/entry/vdso/vdso32/vdso32=2Eso=2Edbg
>=2E=2E=2E
>000001cc 00000010 00000000 CIE  <-- CIE for __kernel_sigreturn and __kern=
el_rt_sigreturn
>  Version:               1
>  Augmentation:          "zRS"
>  Code alignment factor: 1
>  Data alignment factor: -4
>  Return address column: 8
>  Augmentation data:     1b
>  DW_CFA_nop
>  DW_CFA_nop
>
>000001e0 00000068 00000018 FDE cie=3D000001cc pc=3D00001a6f=2E=2E00001a78=
  <-- FDE for __kernel_sigreturn
>  DW_CFA_def_cfa_expression (DW_OP_breg4 (esp): 32; DW_OP_deref)
>  DW_CFA_expression: r0 (eax) (DW_OP_breg4 (esp): 48)
>  DW_CFA_expression: r1 (ecx) (DW_OP_breg4 (esp): 44)
>  DW_CFA_expression: r2 (edx) (DW_OP_breg4 (esp): 40)
>  DW_CFA_expression: r3 (ebx) (DW_OP_breg4 (esp): 36)
>  DW_CFA_expression: r5 (ebp) (DW_OP_breg4 (esp): 28)
>  DW_CFA_expression: r6 (esi) (DW_OP_breg4 (esp): 24)
>  DW_CFA_expression: r7 (edi) (DW_OP_breg4 (esp): 20)
>  DW_CFA_expression: r8 (eip) (DW_OP_breg4 (esp): 60)
>  DW_CFA_advance_loc: 2 to 00001a71
>  DW_CFA_def_cfa_expression (DW_OP_breg4 (esp): 28; DW_OP_deref)
>  DW_CFA_expression: r0 (eax) (DW_OP_breg4 (esp): 44)
>  DW_CFA_expression: r1 (ecx) (DW_OP_breg4 (esp): 40)
>  DW_CFA_expression: r2 (edx) (DW_OP_breg4 (esp): 36)
>  DW_CFA_expression: r3 (ebx) (DW_OP_breg4 (esp): 32)
>  DW_CFA_expression: r5 (ebp) (DW_OP_breg4 (esp): 24)
>  DW_CFA_expression: r6 (esi) (DW_OP_breg4 (esp): 20)
>  DW_CFA_expression: r7 (edi) (DW_OP_breg4 (esp): 16)
>  DW_CFA_expression: r8 (eip) (DW_OP_breg4 (esp): 56)
>
>
>[ See how the FDE for __kernel_sigreturn covers the range [1a6f=2E=2E1a78=
[=2E
>An unwinder that always subtracts one from the return address would
>lookup IP=3D1a6f as belonging to __kernel_sigreturn (and use the DWARF
>rules applicable to the nop preceeding its symbol)=2E  Likewise for
>__kernel_rt_sigreturn=2E  Or is that no longer true?  ]
>
>=2E=2E=2E
>00001a5c <int80_landing_pad>:
>    1a5c:       5d                      pop    %ebp
>    1a5d:       5a                      pop    %edx
>    1a5e:       59                      pop    %ecx
>    1a5f:       c3                      ret
>    1a60:       90                      nop
>    1a61:       8d b4 26 00 00 00 00    lea    0x0(%esi,%eiz,1),%esi
>    1a68:       2e 8d b4 26 00 00 00    lea    %cs:0x0(%esi,%eiz,1),%esi
>    1a6f:       00
>
>00001a70 <__kernel_sigreturn>:
>    1a70:       58                      pop    %eax
>    1a71:       b8 77 00 00 00          mov    $0x77,%eax
>    1a76:       cd 80                   int    $0x80
>
>Thanks and regards,
>Jens

That hack dates back from before the signal frame extension=2E It is no lo=
nger necessary=2E
