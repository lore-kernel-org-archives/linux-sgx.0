Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD1535CBC9;
	Wed, 12 Nov 2025 21:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762982770; cv=none; b=bG5zmyxH1HBnkjsu/vxuMwN+1igxF83N6v1v2Glxl7/nY9NmU8gJw89DpK7+Bsg+LVvXxRYv4XnTgyGI13bCyHYUsUVTxgnI66TcRoe2q/77NfCCbGV4dIdHX8MqnWQTmQwEeuFPNx0vg98bK/kL+KEI+dlFWuk+QNuGulpMpZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762982770; c=relaxed/simple;
	bh=SioGFd0C7lxIkSMsxeKFwmjfLz0wr4SniCII2cKk08c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tSwOrHQiUSE3zx8wV9kOXW/8Prjeeus5XHtNpYfEW3v1pGehQ5TWqpcQmYAF1v8G57sgMBemvlmJovhpvUsHklS76n+NVqaNYNLwNgYkftxqL6NrBm2labcVJADX6V7DYPoZiTcHs/Ow+PaMmsDU4+e5Cq5sqsgp9UJLAnPndHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=fail (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=l4sYpKrF reason="signature verification failed"; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="l4sYpKrF"
Received: from [172.27.2.41] (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 5ACLPBM51004081
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Wed, 12 Nov 2025 13:25:12 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 5ACLPBM51004081
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025102301; t=1762982714;
	bh=8N8ijlsC6KhiWuu4QbjeYznaUps6aMGSWXMdwdxDAxw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=l4sYpKrFCrAsnPAUyghmeRvLc4mPQ58O8qoEOPAzhg8jBuxPwak/5xDhgQWN78fys
	 QSjKjYsvalXcxtnp9HzBoEO9qWXhDIdwf/mwzIQAdam4tfqTBiqVbrOwIPxfHQoLAw
	 b47MS7R2RlNPoDYTPCOFO35llNJHDLZ32JwpBzoo/VDXeoj8K6OPCRL4/0wrcjT7KN
	 MdFFSLf5wVH/PLLOFkI8gZtVJTzqi6kqtcDUYAveaXx2MXgCBoAwdEOCse1XChFlwr
	 q6x51Xhio24ZjGTMigtf82gbuTS5LTfHI4ZHCnNNQzanQco9yEzECdXehZ6JdLUc3a
	 knoLwc6mpTVhg==
Message-ID: <d5531acf-cd79-428d-80d1-eb7562cf3922@zytor.com>
Date: Wed, 12 Nov 2025 13:25:11 -0800
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 7/9] x86/vdso: abstract out vdso system call internals
To: Uros Bizjak <ubizjak@gmail.com>
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
Content-Language: en-US, sv-SE
From: "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <CAFULd4aMOueG5y3K7F57ryLtt-JUhE-yfsDODC=5+bgjF_gtSw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2025-11-12 02:31, Uros Bizjak wrote:
> 
> Unfortunately, %ebp is still special with -fno-omit-frame-pointer, so
> using "ebp" as _sys_arg6 on 32-bit targets will result in:
> 
> error: bp cannot be used in ‘asm’ here
> 
> Please see how %ebp register is handled in
> arch/x86/include/asm/vmware.h, vmware_hypercall_hb_out() and
> vmware_hypercall_hb_in().
> 

#ifdef CONFIG_X86_64
#define VMW_BP_CONSTRAINT "r"
#else
#define VMW_BP_CONSTRAINT "m"
#endif

        asm_inline volatile (
                UNWIND_HINT_SAVE
                "push %%" _ASM_BP "\n\t"
                UNWIND_HINT_UNDEFINED
                "mov %[in6], %%" _ASM_BP "\n\t"
                "rep outsb\n\t"
                "pop %%" _ASM_BP "\n\t"
                UNWIND_HINT_RESTORE
                : "=a" (out0), "=b" (*out1)
                : "a" (VMWARE_HYPERVISOR_MAGIC),
                  "b" (cmd),
                  "c" (in2),
                  "d" (in3 | VMWARE_HYPERVISOR_PORT_HB),
                  "S" (in4),
                  "D" (in5),
                  [in6] VMW_BP_CONSTRAINT (in6)
                : "cc", "memory");
        return out0;

That code is actually incorrect, in at least two ways:


1. It should be conditioned on frame pointers enabled, not x86-64 vs i386.
2. The compiler is perfectly within its right to emit an %esp-relative
   reference for the "m"-constrained [in6]. This is particularly likely
   when *not* compiled with frame pointers, see #1.

A better sequence might be:

	pushl %[in6]
	push %ebp
	mov 4(%esp),%ebp
	<stuff>
	pop %ebp
	pop %[junk]

Then %[in6] can even safely be a "g" constraint (hence pushl).

	-hpa

