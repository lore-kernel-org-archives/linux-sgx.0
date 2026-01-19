Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 510302DB7BE;
	Mon, 19 Jan 2026 22:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.136
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768861785; cv=none; b=ZIXTprMSU9Vrwd/ldo2TkjHqGnxbBJjuadfTvzzZ02spW3ZTdUlDqiLTgLoNF3jsd3NM8V94BgX/X2T2qEXGB2i0dYvYe0OWZE1IUGqJ5oPe/9OEoE4RAiwy8MQ8OkLl3h0KmMVkIPYYcUqU9OUJy7FQJJMqFGcE6qO28sIOE7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768861785; c=relaxed/simple;
	bh=mTv5S8f6H3K6ojcpZaSM0b3e4ATUZeI5Q5DyMWx0FZo=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=N7qQc0JAiv1PHa+X6vxtRDkgabNTkl/MqLMlNkAudMfVGRcCd8MasHrBnTAKHvyPo31Ql/PsFXSxiFXhQcrFwMRz2hmq6rlTAB50BtnoIUCcL4CY+jVTfED5QxhlUSIJIUuKDyvR61nP+wNVo/vbokqvVw95uOUWLmJyM/Qm6xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com; spf=pass smtp.mailfrom=zytor.com; dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b=Fr7A6y8+; arc=none smtp.client-ip=198.137.202.136
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zytor.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zytor.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zytor.com header.i=@zytor.com header.b="Fr7A6y8+"
Received: from ehlo.thunderbird.net (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 60JMTFJw3189103
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Mon, 19 Jan 2026 14:29:16 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 60JMTFJw3189103
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025122301; t=1768861756;
	bh=zWXmI92viypvEb35l8s1gN/2VGst9NR3NfCqmxtYpTk=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:From;
	b=Fr7A6y8+ROBYauvkaJwGkFYZL/9Yso0MH5RHzEIABoruJIksWt8hT+7l+Q7mL+WcV
	 U03dMoTUYWcr6/yKvhJZ5IpAYJu+CzE7hFi+nwFCA3YCKg8Rx489nuyG7xfpYz+EbA
	 mCcgIVAX13OeSnKRD5hHW/JPNQGAFsfU11fjkcsPaSRY5FcZtp3ldnmpmpSYS3qvyo
	 rxmQ8JoDYrUpnP1gz38zyjbdkLYwnck1nz4PJbdJKPDfRlTkly5+mrmyU2eGklVkJg
	 ZXP9MQNdONq1o/soww9V5kYHKKFieIj6wDq9wPMURLf4jxqMX5ogX1lE3/JSRZmWHJ
	 RsMeOSyHWXObA==
Date: Mon, 19 Jan 2026 14:29:09 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
To: Lukas Bulwahn <lbulwahn@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>
CC: Jarkko Sakkinen <jarkko@kernel.org>, Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        linux-sgx@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lukas Bulwahn <lukas.bulwahn@redhat.com>
Subject: Re: [PATCH] MAINTAINERS: adjust file entry in INTEL SGX
User-Agent: K-9 Mail for Android
In-Reply-To: <20260119093835.114554-1-lukas.bulwahn@redhat.com>
References: <20260119093835.114554-1-lukas.bulwahn@redhat.com>
Message-ID: <FAB42E78-0D04-4B5D-84CE-E76C6D5D6743@zytor.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On January 19, 2026 1:38:35 AM PST, Lukas Bulwahn <lbulwahn@redhat=2Ecom> w=
rote:
>From: Lukas Bulwahn <lukas=2Ebulwahn@redhat=2Ecom>
>
>Commit 693c819fedcd ("x86/entry/vdso: Refactor the vdso build") moves the
>vdso sources into common, vdso32, and vdso64 subdirectories, but misses t=
o
>adjust the file entry in the INTEL SGX section of the MAINTAINERS file=2E
>
>Adjust the file entry in accordance with the file movement of the commit
>above=2E
>
>Signed-off-by: Lukas Bulwahn <lukas=2Ebulwahn@redhat=2Ecom>
>---
> MAINTAINERS | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>
>diff --git a/MAINTAINERS b/MAINTAINERS
>index 14a06f856b81=2E=2E68f5fec91f96 100644
>--- a/MAINTAINERS
>+++ b/MAINTAINERS
>@@ -13105,7 +13105,7 @@ S:	Supported
> Q:	https://patchwork=2Ekernel=2Eorg/project/intel-sgx/list/
> T:	git git://git=2Ekernel=2Eorg/pub/scm/linux/kernel/git/tip/tip=2Egit x=
86/sgx
> F:	Documentation/arch/x86/sgx=2Erst
>-F:	arch/x86/entry/vdso/vsgx=2ES
>+F:	arch/x86/entry/vdso/vdso64/vsgx=2ES
> F:	arch/x86/include/asm/sgx=2Eh
> F:	arch/x86/include/uapi/asm/sgx=2Eh
> F:	arch/x86/kernel/cpu/sgx/*

This should be added to tip:x86/entry=2E

Acked-by: H=2E Peter Anvin (Intel) <hpa@zytor=2Ecom>
