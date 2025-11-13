Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C88C31E0EB;
	Thu, 13 Nov 2025 21:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763068481; cv=none; b=jFF04yZ5tufy7TGo3pXY3hywbsZ0QWy+sOfXsgVggGC71EpqK3dtjukQDN9qZTdduy8jLWG5RZZKHL+GnbOKtdVf7UkI+Q84TSd+dWiH7I0Zcvwg9n0oeNbV+6ydxjamU85LPmmEF6L1g3RFqTy/5Wl7ixopGMvQYbqbSDzGeYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763068481; c=relaxed/simple;
	bh=/LmkyGxMiNvcYubl/RC/m0L8QqVUV97rydHFNeSCcBQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Vi4AQctk1tAkhQMgrnJLWmCCRFXQZYAoS8mi4/bClOAi32iNmagKiNghEobrxy9NAG2kKnbXeTNZ6bllyLVLhX90EfUWR+AyhGKRcEpQZRNr7eh23tPlUXEu61YPxo7BMiGNRfeI5oIo5nUO6ekcmW2ayHf4Zf7QNu9hucP0Ahw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=fail (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=pBkKChWS reason="signature verification failed"; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="pBkKChWS"
Received: from [172.27.2.41] (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 5ADLDpwL1691494
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Thu, 13 Nov 2025 13:13:53 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 5ADLDpwL1691494
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025102301; t=1763068435;
	bh=tXNla8kRg5U9BgGDpPsw8RPi94o0olG3pxIf2ldSmU8=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=pBkKChWSgNJMKR+i/pkxDjqmbIVJOygmGugU+3jfoNeDoTJ3qFSJzeZpMPu0jMRoQ
	 IWaU9Y6Ai9Uk4swArRd+AgCW+5VVdZA1dyR2fHn70aEDTBq7Uz8Fbkw2Zb32kNwaxX
	 MM12m8nVM+RZFpMajqzofPuwCVB9Jlvb1dAY1N9FO+0StBEeX5T/S8BY50kHfCyCUb
	 JLAEqK20Lp5Vey5KIO7oCiQlJxVaLEf56OchxTA7qFeqAVvB/3WNONi1nRBrqUyKOk
	 VlnTdVXRwEHLGWxXjLHvfL8lAe7fHgiiR3CxvhQIK0dE5XTKT7l03VpeBQEMwYzH5e
	 eWxewkfUZVoTA==
Message-ID: <b2d39a78-a66c-4846-b07a-b7cd5a85d00b@zytor.com>
Date: Thu, 13 Nov 2025 13:13:50 -0800
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/9] x86/entry/vdso: include GNU_PROPERTY and GNU_STACK
 PHDRs
To: Andrew Cooper <andrew.cooper3@citrix.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
        Xin Li <xin@zytor.com>, Andy Lutomirski <luto@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Brian Gerst <brgerst@gmail.com>,
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
 <20251112202258.1310754-7-hpa@zytor.com>
 <55128481-71e2-489e-a669-25b60dabb407@citrix.com>
Content-Language: en-US, sv-SE
From: "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <55128481-71e2-489e-a669-25b60dabb407@citrix.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2025-11-13 11:09, Andrew Cooper wrote:
> 
> Almost all of these hunks look to be whitespace changes only.  Was that
> intentional?  It certainly makes it harder to read.
> 

It is intentional; although it adds to the patch it tidies up the file itself.

>>  	.altinstructions	: { *(.altinstructions) }	:text
>>  	.altinstr_replacement	: { *(.altinstr_replacement) }	:text
>> @@ -87,15 +84,23 @@ SECTIONS
>>   * Very old versions of ld do not recognize this name token; use the constant.
>>   */
>>  #define PT_GNU_EH_FRAME	0x6474e550
>> +#define PT_GNU_STACK	0x6474e551
>> +#define PT_GNU_PROPERTY	0x6474e553
>>  
>>  /*
>>   * We must supply the ELF program headers explicitly to get just one
>>   * PT_LOAD segment, and set the flags explicitly to make segments read-only.
>> - */
>> +*/
> 
> This looks like it wants undoing too.

OK, fair.

> That said, I do strongly agree with the reasoning behind this patch.

Thanks.

	-hpa

