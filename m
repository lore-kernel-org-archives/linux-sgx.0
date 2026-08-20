Received: from mout.web.de (mout.web.de [212.227.15.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C181DED5B;
	Thu, 20 Aug 2026 12:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787229060; cv=none; b=me6PpomOQPKyDwVPDfRAmk4IjnvCgEVJme8+E80e8Rl0sk/rNF5vZFubbe2ZEb8dDsQMeyIa7bh9Y0AAS9NIzRXd54IWKvUB7JaQkry9QXF3urwXcA6v326XxplqkeOAReaZMVwqF/HWVfOT2bkfdb/LNpWgAe+kJ6R0zgX0b4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787229060; c=relaxed/simple;
	bh=cjSxDJuBeklwHY253l7JGUnkmRFx77qWr23Qi1M3U2M=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=cjd3Ze/kkh1F0gZxpthK3Pl6ctbAToM/yup15F7vtweAg9rcXeFPl25p58Iv+Eb4A3YCWwFTc0DzeLyZfh6gAEkPe5K4dlF+huFMWBBX9fVtcJDr/31CNIzkGxbS33P98PjHLtav8MnAu7XEVdJLootj0KbAN/qewqm/CZn55dI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=f1eXf5UR; arc=none smtp.client-ip=212.227.15.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="f1eXf5UR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1787229009; x=1787833809; i=markus.elfring@web.de;
	bh=cjSxDJuBeklwHY253l7JGUnkmRFx77qWr23Qi1M3U2M=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=f1eXf5URWcE7FZMhoyaGM19JLec7AnGUNWUgDGwQgKsyTRLblLr3+XbSxxZ/xh+Q
	 ZM9WkjNi3xpooXzPEOlNd9BYY1KYv92Wzsk8uaGxz1GeD0FPAJWzldnVO8c0s/ep1
	 Wc+RLI20pH5x6G5+5ZAihH8HiO8Yn7dqb31Mrx0F9KQS7Zgtq127nGi1nn2fad+Qn
	 514u8C5zb41Vuc0iQCozsEIEWG3iJ39yuOiACA5+LKScZClIAREPxybvMuM9cBodl
	 0kZkufq2FZZT9b0s+k88nAQ1cF0HA5cqn1+ZRcBLeVYGw2shHkVpboCyh1Dm9pw6T
	 6q6Im7QCXR550XvaSg==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from client.hidden.invalid by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MeDMR-1wMJyo2cjP-00m7Sc; Thu, 20
 Aug 2026 14:30:09 +0200
Message-ID: <e4b8aa85-40ee-4a37-b0e7-d5540455a088@web.de>
Date: Thu, 20 Aug 2026 14:30:06 +0200
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Ruoyu Wang <ruoyuw560@gmail.com>, linux-sgx@vger.kernel.org,
 x86@kernel.org, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Jarkko Sakkinen <jarkko@kernel.org>,
 Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>
References: <20260814134020.1386599-1-ruoyuw560@gmail.com>
Subject: Re: [PATCH] x86/sgx: Drop enclave reference on MMU notifier
 registration failure
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20260814134020.1386599-1-ruoyuw560@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:UhNQphGCZyAn5hNtr6c38iLUdNoqff6GlOskPBsZwgslM+I9XQX
 nDP+v0GttSJAkp7pi14O08dGcWJw7ibwo+NOwiL7hzWUYjV9YXzDWVweBjTNhQgxTJ9jOba
 ewihiTGc20DA5rM1Lybgo7k0VlOy4B50n2QhGgW+fe6gtKSXZtZIwwlxGFt7pQIM+1A/WA6
 7T6pvz+tueuVuG7Z7Y5Mg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:6hzzeXR9crs=;1rQYb1sjOb3puPWBrTcubjqZuUi
 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
 H9ZrkTwXIsFR++1iQ==

=E2=80=A6
> Drop the enclave reference before freeing the unpublished encl_mm. This
> balances the acquisition without changing the successful registration
> and teardown paths.
=E2=80=A6

How do you think about to increase the application of scope-based resource=
 management
also for an improved implementation of a function like sgx_encl_mm_add()?

Regards,
Markus
