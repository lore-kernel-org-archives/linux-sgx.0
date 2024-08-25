Received: from smtpbgjp3.qq.com (smtpbgjp3.qq.com [54.92.39.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F6DB4A05;
	Sun, 25 Aug 2024 10:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.92.39.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724582316; cv=none; b=b8TZmwV63jIDhQ11uRKi9NTDg3DOstdp+swNLyrIiBsOqwhAjQl++LgE+daRV6lrlKT0nybYr8i3dQUK/l5ddo0+VU/8hcxpjLEcCN+S0ayeeieoJJd/MA8UPTkES7gwKXbtnBjko2hRWP10ZLJcNjBxuFNr9m7ibz36UsBd9RY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724582316; c=relaxed/simple;
	bh=wnw4Th0gtom97ddXHh+Gf5dg4t+IF93vrd9p9kzTy6M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GLLojnccgM5bdElqJXgmrNTtUN4KiesPcwFpvDSArc9K6rFQc/TBZqqM0Yca+nMf71+4EIF1eMNzlba7jM0vurAO52lGxL5t1bMcv3PdW3LKnKmF/EGi29+5pzFRrhtPd1ssXfKv53wk9rYMt3YAEt/wwnT71O/WYSK7CLYhRLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=Kv8lzOJV; arc=none smtp.client-ip=54.92.39.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="Kv8lzOJV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1724582298;
	bh=iTE2tmTgf2oWJdV4bHoTHXa2KQoZBh4qmjsj1QNutpU=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=Kv8lzOJVd05uaTCuGiIJoEcbQc6JHDHwMYqf9oQ8ql3I3fJwM2N6TV9WS9aVlQ4qG
	 SNiW7U1K2ut4kGB3cis8o7jCT+pbe6r7QOr099MkdMqtGW6r/ZFIFru22NNCOjh893
	 xsaGF7HqK8GjO4kqk56RlTFhjQLpu0fHou8kh+bg=
X-QQ-mid: bizesmtp78t1724582268trdari28
X-QQ-Originating-IP: JXktttf0Po9xMg9XcMCtqxU3/0n34XTuzzTq2cKQWLw=
Received: from [10.20.53.89] ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Sun, 25 Aug 2024 18:37:45 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 12879635373824337421
Message-ID: <98F3D161C5A382FC+3062fe22-24a9-42e7-9ae4-83c5047c7ec0@uniontech.com>
Date: Sun, 25 Aug 2024 18:37:45 +0800
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] x86/cpu: Adjust the error message when BIOS does not
 support SGX
To: "Huang, Kai" <kai.huang@intel.com>, "seanjc@google.com"
 <seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "hpa@zytor.com" <hpa@zytor.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
 "mingo@redhat.com" <mingo@redhat.com>,
 "xiangzelong@uniontech.com" <xiangzelong@uniontech.com>
Cc: "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
 "jarkko@kernel.org" <jarkko@kernel.org>, "x86@kernel.org" <x86@kernel.org>,
 "bp@suse.de" <bp@suse.de>,
 "guanwentao@uniontech.com" <guanwentao@uniontech.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
 "haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>,
 "wubo@uniontech.com" <wubo@uniontech.com>
References: <2FA59E9E3461354C+20240825081741.3890887-1-wangyuli@uniontech.com>
 <8cc1f0a0a4cb03007d52c040c05bf77f2fa16d6d.camel@intel.com>
From: WangYuli <wangyuli@uniontech.com>
Autocrypt: addr=wangyuli@uniontech.com; keydata=
 xjMEZoEsiBYJKwYBBAHaRw8BAQdAyDPzcbPnchbIhweThfNK1tg1imM+5kgDBJSKP+nX39DN
 IVdhbmdZdWxpIDx3YW5neXVsaUB1bmlvbnRlY2guY29tPsKJBBMWCAAxFiEEa1GMzYeuKPkg
 qDuvxdofMEb0C+4FAmaBLIgCGwMECwkIBwUVCAkKCwUWAgMBAAAKCRDF2h8wRvQL7g0UAQCH
 3mrGM0HzOaARhBeA/Q3AIVfhS010a0MZmPTRGVfPbwD/SrncJwwPAL4GiLPEC4XssV6FPUAY
 0rA68eNNI9cJLArOOARmgSyJEgorBgEEAZdVAQUBAQdA88W4CTLDD9fKwW9PB5yurCNdWNS7
 VTL0dvPDofBTjFYDAQgHwngEGBYIACAWIQRrUYzNh64o+SCoO6/F2h8wRvQL7gUCZoEsiQIb
 DAAKCRDF2h8wRvQL7sKvAP4mBvm7Zn1OUjFViwkma8IGRGosXAvMUFyOHVcl1RTgFQEAuJkU
 o9ERi7qS/hbUdUgtitI89efbY0TVetgDsyeQiwU=
In-Reply-To: <8cc1f0a0a4cb03007d52c040c05bf77f2fa16d6d.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:uniontech.com:qybglogicsvrgz:qybglogicsvrgz8a-1


On 2024/8/25 16:49, Huang, Kai wrote:
> Hi Yuli,
>
> When Thomas pointed out the "Signed-off-by chain is invalid" in v2:
>
> https://lore.kernel.org/all/87zfpx4a0q.ffs@tglx/T/#mdc19b00c10177f3add9deaf505211bf8b3ec7110
>
> I think it meant you either need to have a Co-developed-by for Zelong Xiang,
> or you should remove his/her SoB.  The reason is the patch is from you, but
> not Zelong.
>
> The SoB chain needs to reflect the chronological history of this patch.

I get it now.

It's easy for this aspect to be overlooked or compromised when a patch 
is passed around among different developers.

Your rigorous approach is truly admirable.

>    E.g.,
> the SoB chain:
>
> 	From: You
> 	Co-developed-by: Zelong
> 	Signed-off-by: Zelong
> 	Signed-off-by: You
>
> .. means the patch was originally generated by you, but Zelong also
> participated in developing this patch before you finally signed off it.
>
> For this one line code change patch, it doesn't make a lot sense to have
> multiple developers, so I think you can just remove Zelong's SoB.

Since the goal is to ensure the SoB chain is as authentic as 
possible,there's no need to delete it unless the chain is unreasonably long.

I'll send a patch-v4 to fix it.


Thanks

-- 
WangYuli

