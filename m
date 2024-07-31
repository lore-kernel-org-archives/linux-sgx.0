Received: from smtpbgsg2.qq.com (smtpbgsg2.qq.com [54.254.200.128])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC0F417C7C;
	Wed, 31 Jul 2024 03:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.254.200.128
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722396169; cv=none; b=MzN5s9BgvDA1rzaLKky7vG7R3LPIxSGbKyTLTGGVYMyOxsbfeHL5zWxP053QasO6xjAmMlpX71j3o9EzDBUhqcjrOit2fWQbKe4fU3qTip+8rERLTaNGSLbcVE3ZO2HLP+vpB0TOuPLA7r5bwmFv52cCD2VaOEA+/7IoUi/X6ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722396169; c=relaxed/simple;
	bh=T8izX+/yGXdwTJfp1aXGvxIT9IaA5SVPOv77vOCYAkk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gVfR62lVpj0TW5Opm1nDuI8OASsPtG17NcUdD8WZgd3misR+evgTBK4/oIbIWmSoKd9LrJnc3/5LyKc9/KvjE50rKlbRru3TxYCF6apoj/jO2yp2c6mwyulYaoRKZeDiA/CXljIPkY1E117GGrSJKapnps5xHDIPvYeLdKBCQxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; arc=none smtp.client-ip=54.254.200.128
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
X-QQ-mid: bizesmtpsz2t1722396148tsc187y
X-QQ-Originating-IP: 6jVb//9MNTYm9+pTLpUuNPc2RR0vlXEgVFqCQe54XpQ=
Received: from [10.20.53.89] ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 31 Jul 2024 11:22:25 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 16900428801888143573
Message-ID: <4453C8E00ABF5220+5cc48da4-637f-437f-abc8-5183399fc414@uniontech.com>
Date: Wed, 31 Jul 2024 11:22:24 +0800
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
 <seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "hpa@zytor.com" <hpa@zytor.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
 "mingo@redhat.com" <mingo@redhat.com>,
 "xiangzelong@uniontech.com" <xiangzelong@uniontech.com>
Cc: "baimingcong@uniontech.com" <baimingcong@uniontech.com>,
 "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
 "jarkko@kernel.org" <jarkko@kernel.org>, "x86@kernel.org" <x86@kernel.org>,
 "guanwentao@uniontech.com" <guanwentao@uniontech.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>,
 "wubo@uniontech.com" <wubo@uniontech.com>
References: <D345627B0A699F37+20240730024931.1026933-1-wangyuli@uniontech.com>
 <a56bc12f6c60107c935db31d7330d28980ac4d5a.camel@intel.com>
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
In-Reply-To: <a56bc12f6c60107c935db31d7330d28980ac4d5a.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtpsz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz8a-1

On 2024/7/30 19:57, Huang, Kai wrote:

> +linux-sgx list, Jarkko, Haitao.
>
> This message is only printed when SGX is reported in CPUID but is not
> enabled in the FEAT_CTL MSR.  I can only recall this can happen when the
> BIOS actually provides an option for the user to turn on/off SGX, in
> which case the current message is correct.
>
> I could be wrong, but I don't recall I have met any machine that doesn't
> have any SGX option in the BIOS but still reports SGX in the CPUID.  Can
> you confirm this is the case?

Sure.

For example, Lenovo ThinkPad T480s that compliance id is TP00092A.

>
> I don't see this is mentioned in the github link below which reports this
> issue.  In fact, it says:
>
> 	非bug，主板bios关闭了SGX，正常内核提醒
>
> .. which is
>
> 	Not bug, the motherboard BIOS disabled SGX, normal kernel
> message
hah, that's a typo.
>
> And the link also shows this issue is "closed".
>
> Please clarify.
-- 
WangYuli
