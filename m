Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.156
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795546470;
	b=s0Q8EpJMmJ/MCMDMVDNEauBgy/SMRLi2Thxtb1fGLXWN9kPdSTcV5d7B3DIZ1K5dmj1G
	 RkmBffyUi8ny1hkqRkGNYVjq5yvWW0IvBo9l+KwV3S6TRNQEBwWwJxbiVi3VFPHGlcRaE
	 ttLdyGDTtYjEB/lviYTchAgz4ERv6QWAAFDVFf0cH5lLg2zkgtfeHPabbmtxY0dqUAS3o
	 NOVIIvn0aqr6IPVRUaQw2laLRn1JyxiwrS9rvZHJpInEYFvDZ4eJPFfmLS7fIQpJJiBCs
	 puq1su6cSx9SxXkbdahjo+zIy7grbbucv6Z+chZSvNlliLiriw85F2PyTfMaZnhSs5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795546470;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:X-ThreadId:Date:From:To:Cc:Message-Id:In-Reply-To:
	 References:Subject:Content-Type:Content-Transfer-Encoding;
	bh=zzADWq2A9f6U6Ncm9LM291Imr7Nwrsax19gq4eW/i1s=;
	b=T/eKBv5C60C3bm3EnJ4HlqigdFGHgzK5J5CbHYaJKU/0NHbex5PP+1aM+tvz54auATzc
	 XhgK2YU1yZmTC8qgD9hSZN6jntu8oX9ElJ6Q9sUkyDKM2+Tgxau82hhqk0Fa1eDAF+fen
	 eH1iSPpxVrXX4zSQU61l+zy7LXQ3on/Cd/3SUO4zVTMWs8T9W5uEjG+yMqJOZp79uyXZ9
	 ZwExlH+TkZF6g/HQksmPV16aKGkmyrYMa0rmH9UPtidh6I496gAS90vifbzKTg2lN411S
	 P7U0Kc9zOLihsY1lZsS4amkuYZarVCJdzwKX0qA/WVa0t5gZM4/SAXBakVlRE6f/xzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arndb.de;
	spf=pass smtp.mailfrom=arndb.de;
	dkim=pass header.d=arndb.de header.i=@arndb.de header.a=rsa-sha256 header.s=fm2 header.b=P5z384dP;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=TwUQQDp6;
	arc=none smtp.remote-ip=103.168.172.156
Received: from fhigh-a5-smtp.messagingengine.com (fhigh-a5-smtp.messagingengine.com [103.168.172.156])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A34A3606A326
	for <linux-sgx@vger.kernel.org>; Tue, 24 Nov 2026 18:54:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A34A3606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=arndb.de header.i=@arndb.de header.a=rsa-sha256 header.s=fm2 header.b=P5z384dP;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=TwUQQDp6
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfhigh.phl.internal (Postfix) with ESMTP id C01BA14002FC
	for <linux-sgx@vger.kernel.org>; Tue, 24 Nov 2026 13:54:28 -0500 (EST)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Tue, 24 Nov 2026 13:54:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1795546464;
	 x=1795632864; bh=zzADWq2A9f6U6Ncm9LM291Imr7Nwrsax19gq4eW/i1s=; b=
	P5z384dPQqGFwInJesEbTB65u8U9LssEE55f2UhY+p9oT6kb3Nx7iJaixV+JMWDH
	eO6YnseMxm9y/4d7b+FZEw4tYJYR5toelfZHwhAffCYgtl/rQH+seASNmtnaXM1C
	6BAyKz/OlpMgNylFT4Niz5A+I5ynHX2N3a0glbxo3S4a7XEwxuqxK5UCRXAFcs0F
	xV8IU7k0ZxKT2IoUCoqb2W4CuqSzWdEyd3J52PUNEXYf0tRTBIDaUp0MEAehqyst
	QSLiOH5VP9JuuRYRVDcqAkYs+PGRBxP7Bi8AiZrLdzd5QdyCvpkbS2Iz10kKJVU/
	fTiO5c5UxwJT3I0trCQYjA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1795546464; x=
	1795632864; bh=zzADWq2A9f6U6Ncm9LM291Imr7Nwrsax19gq4eW/i1s=; b=T
	wUQQDp6GuCGoVRbzbe4mjcc0rfiDoEIs4kIRSNf1PiE/EMGexvPkY3ABGFJ61s7o
	IYE/uqY0DHB74tHCsb7YJYkPKNs+r1GqjbyhW3JAUrezkSy2IbqsKYITGA+Oo4AW
	q2lA1S0nj4E1X9C7+Kwk7TVsTmSCeUdYnJhf3UoHSuegVbv/KSVWwZreSC7ESrxp
	mDVpYnBzFs6N7MAtHbBm/QCO7favrihtH9VIjdnbhet/Z2Sjni79/LSlW+ECIqvB
	C87LAxToVuwDTV/r0KFx0TwWvRzbnmjlHKN2gI7vxcDyO5O79vIctIKDqACyI6PE
	eVnransWpokq86L0lm6nA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=arndb.de a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1795546464; d=arndb.de;
	mf=PGFybmRAYXJuZGIuZGU+;
	rt=PGxpbnV4LXNneEB2Z2VyLmtlcm5lbC5vcmc+;
	s=fm2:rsa-sha256:aOKepJjl5uR4g0xF99vUwNYZXyOAqn8ovxl/JWee2lDpmIw
	tZIzcM2M1+kIpTHTAYw/2KBLc4NIhk2aimN2MRkNBAyvw8pj+lEWMLO5fg2BcFDR
	TDx9YKnP8LWVXD9RhEUPn8z//UXT8XvHn/c+6M9bA1pxz+zC1sJml1bp2zogYSCu
	W2xa3JyEfRSezDYNM+1g5aMdI+8tXbcXfsyMHIWSKVYpz8ZdeDY0bcAGCAog8Ji+
	9lFwMkH7lRYEAF115K1dgPdh/R7UQ+DBtBlxzzkBcQaqcCvEBo7RlrmS+kCsoLq/
	DrIWZrX7rtQwSKMsydUhQ+HaNqQHKaK5FX10SNQ==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:LzM4tAbzweW+mDyb/1r3509G6pq6a3/4tE8KTO1Vt/k=:zzADWq2A9f6U6Ncm9LM291Imr7Nwrsax19gq4eW/i1s=;
X-ME-Sender: <xms:Xd0Fa-BlhsDL-CMEXAS3woexowWSp7UW8kuiF7G0LDj0VNXO3AjE3Q>
    <xme:Xd0FazV0z76SGmdOUEhbwIvoG8NcyrYYbIy53wUavHgI_H7DRJPKil5s-MwJCCMr5
    cvoSzBYHaNFd3ID4YKzkwnBAEjI8Gpmt9cn_mzAbMr8heuCX2pZd7c>
X-ME-Proxy-Cause: dmFkZTFB9quJ1NFTduPcxf7Gn9pbvDkjKWpuhMkQ+EAYdW2AbKBk1t0S0hk5VWorL2Agm2
    qtwRbXPvAVWfQY87E83MZi85KNWfq/pZQeTFC4XHsqylC5T1d9SBYYxS8rX5VpocJ8KoA2
    JsYSa0JBaSxxKoH8VW2EBRFGYhljDkmX53R3tsjyNlgO2T+lQiasOpg7wlmJxpq/uNj5TE
    voeb3CS3OW5nBhpFVlF+xRWPVD48Ymva4XRjaibVBPt1FhO1M6VWA+hVJOEdMSkpxstG0/
    KzW44t0G59GU17b3vslVNsBIj2SUcGEF9hrUsK4g5Yvx4dSrucLSvw8FAQD4oCZe+P3rc8
    w/Oerwzd1swLwlK0jroqDEmm4tm16oz4sCOOWAkBSMgxW03jchlQ7JvJdzo0Y49fIM3PX1
    3VdCFZDvojnPfwvWebrRIlKxBGRa7yp4Se5DS3FQOC7TXS+hz0LuFaEl1ePM1sJZ5JqeJJ
    E98Bzz69DHBeU8MPGs8Mbvn02/p+83Rt9TlGnKroxU0HzJkuU+t0Hv+2oj0HuQh5PDsrD8
    b3CjxQkEhw9scEsELAoR2/3pc3arbhQlEBkF+XsbJ8v788vzxs67tu+YvwZWy7T/t4XFEH
    nZkIMZPhd5BdkO9rUn0lIccJaVJFhR4VYCvxq6CkKFELBYG+zlhfrsHxJWOg
X-ME-Proxy: <xmx:Xt0Fa2QwHhu5LKxUiyUpm8UWp-sik77xk3DomaXJfZr3RFC3-nTExA>
    <xmx:Xt0Fa2KHuYbMnACoyAMkCZ6Fs8y1gbQ08LDFY1aXsZ2Y1mGH1VmMVg>
    <xmx:Xt0Fa59Qv4OdpIxNkjEFbcegFlrR0ThVW4mSvoBsBY4QaC60nuO2_A>
    <xmx:Xt0Fa9JR30qqgJvbVK6aj3_uIDx5vgTp2fUiKqJhK4PbQ5RxjDg2IQ>
    <xmx:YN0Fa29a6Rd9dbHKKRBlDFuIHXroTLNtUsLtWdgVxS6EkhX9WOSW2I1p>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 1964B32A0099; Tue, 24 Nov 2026 13:54:21 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Post: <mailto:linux-sgx@vger.kernel.org>
List-Help: <mailto:linux-sgx+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sgx+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-ThreadId: ADzkAynZlS63
Date: Tue, 24 Nov 2026 19:54:00 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Lorenzo Stoakes" <ljs@kernel.org>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Juergen Gross" <jgross@suse.com>,
 "Stefano Stabellini" <sstabellini@kernel.org>,
 "Oleksandr Tyshchenko" <oleksandr_tyshchenko@epam.com>,
 "Madhavan Srinivasan" <maddy@linux.ibm.com>,
 "Nicholas Piggin" <npiggin@gmail.com>,
 "Michael Ellerman" <mpe@ellerman.id.au>,
 "Christophe Leroy" <chleroy@kernel.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 "Shrikanth Hegde" <sshegde@linux.ibm.com>,
 "Haiyang Zhang" <haiyangz@microsoft.com>, "Wei Liu" <wei.liu@kernel.org>,
 "Dexuan Cui" <decui@microsoft.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 "Jason Wang" <jasowangio@gmail.com>,
 =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
 "Xuan Zhuo" <xuanzhuo@linux.alibaba.com>,
 "Jarkko Sakkinen" <jarkko@kernel.org>,
 "Dave Hansen" <dave.hansen@linux.intel.com>,
 "Thomas Gleixner" <tglx@kernel.org>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, "Jan Kara" <jack@suse.com>,
 "Paul Moore" <paul@paul-moore.com>,
 "Stephen Smalley" <stephen.smalley.work@gmail.com>,
 =?UTF-8?Q?Ondrej_Mosn=C3=A1=C4=8Dek?= <omosnacek@gmail.com>,
 "Joel Stanley" <joel@jms.id.au>,
 "Andrew Jeffery" <andrew@codeconstruct.com.au>,
 "Ryan Chen" <ryan_chen@aspeedtech.com>,
 "'billy_tsai@aspeedtech.com'" <billy_tsai@aspeedtech.com>,
 "Bjorn Andersson" <andersson@kernel.org>,
 "Konrad Dybcio" <konradybcio@kernel.org>, "Abel Vesa" <abelvesa@kernel.org>,
 "Jens Wiklander" <jenswi@kernel.org>, "Sumit Garg" <sumit.garg@kernel.org>,
 "Scott Branden" <scott.branden@broadcom.com>,
 "Broadcom internal kernel review list" <bcm-kernel-feedback-list@broadcom.com>,
 "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 "Richard Cochran" <richardcochran@gmail.com>,
 "David Woodhouse" <dwmw2@infradead.org>,
 "Andrew Lunn" <andrew+netdev@lunn.ch>,
 "David S . Miller" <davem@davemloft.net>,
 "Eric Dumazet" <edumazet@kernel.org>, "Jakub Kicinski" <kuba@kernel.org>,
 "Paolo Abeni" <pabeni@redhat.com>
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
 linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev,
 linux-sgx@vger.kernel.org, selinux@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-aspeed@lists.ozlabs.org,
 linux-arm-msm@vger.kernel.org, op-tee@lists.trustedfirmware.org,
 Netdev <netdev@vger.kernel.org>, linux-mm@kvack.org,
 "Jens Wiklander" <jens.wiklander@oss.qualcomm.com>
Message-Id: <9a87f9a4-4299-4a9f-97db-578d7687a848@app.fastmail.com>
In-Reply-To: <20261124-late-2026-mmap_prepare-v2-10-0b0d99d655f9@kernel.org>
References: <20261124-late-2026-mmap_prepare-v2-0-0b0d99d655f9@kernel.org>
 <20261124-late-2026-mmap_prepare-v2-10-0b0d99d655f9@kernel.org>
Subject: Re: [PATCH v2 10/13] tee: convert shm mmap hook to mmap_prepare
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Tue, Nov 24, 2026, at 15:02, Lorenzo Stoakes (ARM) wrote:
> Move from the deprecated mmap hook to the new mmap_prepare hook, using the
> PFN remap mmap action to map the shared memory.
>
> Reviewed-by: Jens Wiklander <jens.wiklander@oss.qualcomm.com>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>
