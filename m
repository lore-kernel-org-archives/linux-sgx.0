Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=203.29.241.158
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794201522;
	b=1YyVEocVKtZcIQv364h8tVwqE4ow/M8lZyoKzD6xIT888kgisOr6eICiARnr8faysbkj
	 RwfsbUxAcYgVrwk8ATRHYEAY+jvh3nqANGvubgf7HtQ+gbnILPylvAO5Eef/hfmQMrYDy
	 0Zvsi+BnnffhzSMwDoaIdxE+JJjwZ0lRM2EvTeJh/nhS2bnVpvHjPPbSVMWEIQVzr0dDa
	 tE9TvuhgGvdg8p2iJxz2iBpGch7G4EQNwMHY45o3P29vMmbjOrAlSwpiBI1Qk1Xl0JBWw
	 h5JJjQojQE/YQRMpv9ZSCtrsGVAiMXxcNzVc7Cwc1B696eWYGheN5glgZQkNNWvLj3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794201522;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Subject:From:To:Cc:
	 Date:In-Reply-To:References:Content-Type:Content-Transfer-Encoding:
	 User-Agent:MIME-Version;
	bh=inbRv9rqETpvmrvWY+hsNFNboYN1tmYS0qnuK2Kr/gs=;
	b=tDn48CiI5PRkq/8ViaiBOYxAanfdSG3BPz/sPJ9Ed3qwVv8G9rujpj+c5F6ahtg8jHzs
	 A3jioTrhdC1NdpX/En+t8CJnpSEitw8GBZ+lkAlg1ttS7vu77hjeTmFJjVQDp/RgZ9JxI
	 +ndllnKrtFEPR8XXOud8gq8j76UksUevPBpR/hyLYF/O4NPE76lmcOGX6U4T743Kxg6cW
	 KV6YPrXp4PnGcCXZaXYd86/NSeC0Mvg6ACCyeoyfWSS7DVL5JbDMqmQSwlf0ugjJbMGmu
	 AhrRFJY/1DSwoyfHj3g1wESfEDPHvGYUTHExt1GETEAV+bkRf51jZ99spVTWbF+zWAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=codeconstruct.com.au;
	spf=pass smtp.mailfrom=codeconstruct.com.au;
	dkim=pass header.d=codeconstruct.com.au header.i=@codeconstruct.com.au header.a=rsa-sha256 header.s=2022a header.b=egf84Gcq;
	arc=none smtp.remote-ip=203.29.241.158
Received: from codeconstruct.com.au (pi.codeconstruct.com.au [203.29.241.158])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1135E606A321;
	Mon,  9 Nov 2026 05:18:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1135E606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codeconstruct.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codeconstruct.com.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codeconstruct.com.au header.i=@codeconstruct.com.au header.a=rsa-sha256 header.s=2022a header.b=egf84Gcq
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=codeconstruct.com.au; s=2022a; t=1794201519;
	bh=inbRv9rqETpvmrvWY+hsNFNboYN1tmYS0qnuK2Kr/gs=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=egf84Gcqai+t2RbzRcp/hsSqUjhQHhjh3vyzhBpm8hV2KWxqDFJxnPUahIU113EcT
	 BgLm6wqU/Euo4rhk1oHtIX3Z9zvOL05mtWbK6K/L7+70zAOa6b9LxPeqiMFkTfAyXR
	 sJ6r+I/RKBuOwB8hQ4kh0KzVB0J735kCbnMQRQlA7QvM+MYWUHFrMnQcdvVsUlq4qL
	 OrhgI7yGlCRf9GdwPQCvkWPbpW6LqMolW9oQ7mrzBne/qL9+nOjj/aqp3F164dsqk2
	 7rLero/HB4L0DSs1r+ug01+7VgG2RcG87tSeq7M4AqhpAUCMcl+W2qQMRVuMpXb4J2
	 kfa7LW520ih5Q==
Received: from [192.168.68.117] (unknown [180.150.112.139])
	by mail.codeconstruct.com.au (Postfix) with ESMTPSA id 083566E9E9;
	Mon,  9 Nov 2026 13:18:31 +0800 (AWST)
Message-ID: <4848c58f3152233477c4fa4786de2a49c9261c9c.camel@codeconstruct.com.au>
Subject: Re: [PATCH 09/14] soc: aspeed: convert LPC and P2A control mmap
 hooks to mmap_prepare
From: Andrew Jeffery <andrew@codeconstruct.com.au>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Juergen Gross
 <jgross@suse.com>,  Stefano Stabellini <sstabellini@kernel.org>, Oleksandr
 Tyshchenko <oleksandr_tyshchenko@epam.com>, Madhavan Srinivasan	
 <maddy@linux.ibm.com>, Nicholas Piggin <npiggin@gmail.com>, Michael
 Ellerman	 <mpe@ellerman.id.au>, "Christophe Leroy (CS GROUP)"
 <chleroy@kernel.org>,  "Ritesh Harjani (IBM)"	 <ritesh.list@gmail.com>,
 Shrikanth Hegde <sshegde@linux.ibm.com>, Haiyang Zhang	
 <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, Dexuan Cui	
 <decui@microsoft.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang	
 <jasowangio@gmail.com>, Eugenio =?ISO-8859-1?Q?P=E9rez?=
 <eperezma@redhat.com>,  Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Jarkko
 Sakkinen <jarkko@kernel.org>, Dave Hansen	 <dave.hansen@linux.intel.com>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar	 <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, x86@kernel.org, "H. Peter Anvin"
 <hpa@zytor.com>, Jan Kara <jack@suse.com>, Paul Moore
 <paul@paul-moore.com>, Stephen Smalley <stephen.smalley.work@gmail.com>,
 Ondrej =?UTF-8?Q?Mosn=C3=A1=C4=8Dek?=	 <omosnacek@gmail.com>, Joel Stanley
 <joel@jms.id.au>, Ryan Chen	 <ryan_chen@aspeedtech.com>, Billy Tsai
 <billy_tsai@aspeedtech.com>, Bjorn Andersson <andersson@kernel.org>, Konrad
 Dybcio <konradybcio@kernel.org>, Abel Vesa	 <abelvesa@kernel.org>, Jens
 Wiklander <jenswi@kernel.org>, Sumit Garg	 <sumit.garg@kernel.org>, Scott
 Branden <scott.branden@broadcom.com>,  Broadcom internal kernel review list
	 <bcm-kernel-feedback-list@broadcom.com>, Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Richard Cochran
 <richardcochran@gmail.com>, David Woodhouse	 <dwmw2@infradead.org>, Andrew
 Lunn <andrew+netdev@lunn.ch>, "David S. Miller"	 <davem@davemloft.net>,
 Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski	 <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
 linux-hyperv@vger.kernel.org, 	virtualization@lists.linux.dev,
 linux-sgx@vger.kernel.org, 	selinux@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, 	linux-aspeed@lists.ozlabs.org,
 linux-arm-msm@vger.kernel.org, 	op-tee@lists.trustedfirmware.org,
 netdev@vger.kernel.org
Date: Mon, 09 Nov 2026 15:48:30 +1030
In-Reply-To: <20261105-late-2026-mmap_prepare-v1-9-c56aadfbab8a@kernel.org>
References: <20261105-late-2026-mmap_prepare-v1-0-c56aadfbab8a@kernel.org>
	 <20261105-late-2026-mmap_prepare-v1-9-c56aadfbab8a@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Post: <mailto:linux-sgx@vger.kernel.org>
List-Help: <mailto:linux-sgx+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sgx+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Thu, 2026-11-05 at 21:05 +0000, Lorenzo Stoakes (ARM) wrote:
> Move from the deprecated mmap hook to the new mmap_prepare hook for both
> the LPC control and P2A control drivers.
>=20
> Both remap a range of their reserved memory region, so use the PFN remap
> mmap action to do so, retaining the -EAGAIN error on failure via the acti=
on
> error override.
>=20
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Acked-by: Andrew Jeffery <andrew@codeconstruct.com.au>
