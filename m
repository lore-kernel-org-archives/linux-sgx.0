Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B7E26158B;
	Tue, 10 Feb 2026 05:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770701110; cv=none; b=PW5U8lpZdTJ1RpgrmX7+Wqrdnl0PVYFZekpBIx59nOTr3rzl9ncKQIjRTpG7L9NLIC2GsNxAsndljxbaE8e+opPQL0gL75TPKV/V40qXynnfTmV6nsgd6dqJIWQ27/nH7nP2euyzLiMDjjmJirEFOxgUgYw6gzErqn/dVITRUuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770701110; c=relaxed/simple;
	bh=GB6DDv+UtPLC7v+OyazWs5tgmDfcUU+2bVadIafRy0I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cY6+UpiOkqKgx69DYWbup0fUqiQgifHzqGawn2SQTzVwPTiMh29mnznJx/5ejDU/ePvCvXRiZNf0kM+C83n2ksfmNHCkF2+InNFKFblXZyaJzotc5d/P1JMfoDlEVz8GU1r/p802WdZ5hXihhhICQWQzDZTR8+Ks4HY0MHpFVWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=fail (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=EibEAGw9 reason="signature verification failed"; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="EibEAGw9"
Received: from [172.27.2.41] (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 61A5O5Yu3174215
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Mon, 9 Feb 2026 21:24:13 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 61A5O5Yu3174215
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026012301; t=1770701056;
	bh=5/7rWnoJfr6/wTynS68F9CWZaEm5ASoXcAvL5grOGVE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=EibEAGw93EXIJD+1pMGDkuldPftoy7RwajBcKhpSj8h3jZo0/9gZ6mzqiCUfco+SF
	 6dG4SvGlu8xLZvLVwzTnaRtHOKPHqYWXb4DMTQr0VpBB+EAVUAsccAh7n4ZYTdEKvb
	 hvvyeQjfW93yf2iSwjnIvw0Jf4jkG6gjZZFwslwjglHAD5WQnW+o43mAM6T5K3KH3w
	 5u0Mf8oFyei98M8K03AptZSC4xJEw1+Sb3KN4GAGQBQR8r0ACuA8iDyoHvSbkRVfEW
	 9trAdUc9rAWd8cMspGvRzqo1aGNEFOe9g9mVX52R5SyW3CKpZ3ilMvuLSgR+DQVsYs
	 d4GXySsi1RuTg==
Message-ID: <663cc342-4740-49df-8744-3142f3738dd5@zytor.com>
Date: Mon, 9 Feb 2026 21:24:00 -0800
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
 <e31817cb-c102-485c-8844-d81c39eac442@zytor.com>
 <32ec2da7ad9b0c65f41b7c3e14fb6d8e1a5c1865.camel@xry111.site>
Content-Language: en-US, sv-SE
From: "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <32ec2da7ad9b0c65f41b7c3e14fb6d8e1a5c1865.camel@xry111.site>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026-02-09 20:56, Xi Ruoyao wrote:
>>
>> Well, it looks like this might be a non-manifest bug on x86 *IN THIS CASE*,
> 
> But only if after the patch _Unwind_Find_FDE returns NULL here (instead
> of a FDE of another function).  I've not verified it on x86.  If glibc
> tests (specifically misc/tst-sigcontext-get_pc) work fine things should
> be fine.
> 

The x86 vdso should be fine because of the alignment padding, but we should
probably add an explicit pad before just in case.

What a mess.

	-hpa

