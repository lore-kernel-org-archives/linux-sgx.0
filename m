Received: from smtpbg151.qq.com (smtpbg151.qq.com [18.169.211.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF88B17C79;
	Wed, 31 Jul 2024 03:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.169.211.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722398339; cv=none; b=B/7XYG3jHMJEcuBA0ZJqWeTP71Rf14pWU4Zq5pe1pi1fGAL0b+mfYosBNUeEwdLDi8aESvJ19MQiZbniYa2TcBOW2HN+VHuu+CIjnfQLfCFiKEAaDoHq2L2IW5EpyAywsVGUR8gOc0sxJ7hO3b3NmKRF8CQSUmyL3w9QmpEit7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722398339; c=relaxed/simple;
	bh=ougaziKjpP9vYBdQ/eQQ9PSKfCAVex/UZXujKrhWLvQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WM4UMkYAqe1tPq5tdl4wHV3Y0iXOKqUkrv6/7w6RpPT+GjRk4bjNszQ0rh7pXsdPMTzsNqn0cUilO3ZTpOg7v/mevSgn8ue6Z3Pb1s/MzigVLl/sjAI4KBOGBU1bfixTpmkp7JpqG8s6AX3YY5pYXrCxuhbnsZ1J8Jn0WGxlLw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; arc=none smtp.client-ip=18.169.211.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
X-QQ-mid: bizesmtpsz10t1722398318tzbd49
X-QQ-Originating-IP: zaN2RZXjY5yumKHQpNgBOt3RUlbALZrG/vIACwMTkBk=
Received: from [10.20.53.89] ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 31 Jul 2024 11:58:36 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 6473966221935116780
Message-ID: <49F442796158E773+c51253ff-8051-4c25-9c95-e5305d13628b@uniontech.com>
Date: Wed, 31 Jul 2024 11:58:35 +0800
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/cpufeatures: SGX: Adjust the error message when BIOS
 does not support SGX
To: "Huang, Kai" <kai.huang@intel.com>, "seanjc@google.com"
 <seanjc@google.com>
Cc: "baimingcong@uniontech.com" <baimingcong@uniontech.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
 "bp@alien8.de" <bp@alien8.de>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "jarkko@kernel.org" <jarkko@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
 "tglx@linutronix.de" <tglx@linutronix.de>, "x86@kernel.org"
 <x86@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
 "xiangzelong@uniontech.com" <xiangzelong@uniontech.com>,
 "wubo@uniontech.com" <wubo@uniontech.com>,
 "guanwentao@uniontech.com" <guanwentao@uniontech.com>,
 "haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>
References: <D345627B0A699F37+20240730024931.1026933-1-wangyuli@uniontech.com>
 <a56bc12f6c60107c935db31d7330d28980ac4d5a.camel@intel.com>
 <ZqkpSX8xfbny7L0e@google.com>
 <9b1b4ef92b8d70bf8072fbbd07f70f82335b9040.camel@intel.com>
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
In-Reply-To: <9b1b4ef92b8d70bf8072fbbd07f70f82335b9040.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz8a-1

On 2024/7/31 06:48, Huang, Kai wrote:

>> FWIW, this could easily happen with a virtual machine, e.g. running an old QEMU
>> with `-cpu host`.
>>
> Hmm.. it appears so, if the old Qemu doesn't have SGX support.  Thanks.
>
> Perhaps "SGX disabled or unsupported by BIOS." or "SGX not enabled by
> BIOS" is slightly better than the current "SGX disabled by BIOS", but I
> am not sure whether it is worth patching.

Of course, most kernel developers are incredibly busy and are reluctant 
to spend their time

on those little changes.


However, the user base of Linux is gradually shifting from 
'professionals' to 'general users'.

As I mentioned in the commit msg. I hope to make kernel logs clearer and 
more understandable,

reducing confusion for those who are unfamiliar with the codebase.


It's important that any change in upstream can potentially impact 
countless users.


Sincerely,

-- 
WangYuli

