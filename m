Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.215.169
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793920457;
	b=Zf384UsGasuvszKwtEmlrdo9nk11r7fks3ClCkxheF+bm00PL6m6YQM+LXfxotK0XHbz
	 vBqx7lPKtZvJ7Y16uFI2gnpeSJGyWMbQYaDX87ovfcPNHSVQDwEASnXdlrppR6/05DmLi
	 GhT3yrhA2Ok2ZeDP2S5QLklnL54ysUoMaNzPgOKd9d5E25T3mfB/D40L/9kI/YFezvvIm
	 pE6D9sSNHrBlcuifZyrBJXpM4PsK53Ck8fs9bZhyDRLdFYyQ+0ZYk5BZ/XQsGUTsBJv8Y
	 A1fLiWfga/lQUvYTHm5UrJsEsIYP8SZiZAa2VnCAANb5wMP0C+mpj+AAUvY9hVxVHzQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793920457;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=mGiD8zQqMuzCkGXAZBtgumh8HlT9rNPiWNa35MXqkeQ=;
	b=EpbNRLaN0ZADgDAUG373WTRB5x5Be9QT0fx2i/qzYBy9T+ao8zlAmatqZZUMjuVP5NC3
	 6ts3R0shwVtWa51QRrlusZ2p0/fWgHsyjv9zCCXNoLpEvdpwcWiAylmkX5rs3cqvb6ik4
	 hWSvN37xvGwiCBhMU8pVUPKbcG+TGeHxFQHuhq0ColRrnyVsfQXAHETxJSb/0ItLNGQjv
	 DxLICW5QS2XQvYAZHAsymF2K9BkDIujn+hhq2sFCjUaBJKhLcK2N/ePkTXvQSS6g0FlXR
	 izm4u1IUFjk+dHX02mDUUwswtl+ysjCIz1rN38oEVcLdigQOhIDZ4FMfzNp9ZT4LfFw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=paul-moore.com;
	spf=pass smtp.mailfrom=paul-moore.com;
	dkim=pass header.d=paul-moore.com header.i=@paul-moore.com header.a=rsa-sha256 header.s=google header.b=IU6i1Fwv;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.215.169
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42F59606A32C
	for <linux-sgx@vger.kernel.org>; Thu,  5 Nov 2026 23:14:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 42F59606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=paul-moore.com header.i=@paul-moore.com header.a=rsa-sha256 header.s=google header.b=IU6i1Fwv
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-cc1bc88a20eso19463a12.3
        for <linux-sgx@vger.kernel.org>; Thu, 05 Nov 2026 15:14:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793920456; cv=none;
        d=google.com; s=arc-20260327;
        b=fRAHz0o1nKtWjT+IYLz3hDjlghDQQOPalUopRH8vTffwle5vS9pPWZNX0E9RLchylQ
         kMRuQMZoG0nab4wyfdL+eJlGvU5RUf7k4nxj+z8t994OuH74z1DjIPFYN96qb+Ks5dIR
         S98M24fthoo9YmGUINAyHAJqfwsEa8PWwBk4RDFnKXfYD31WW3eWs+cLCHuUq7Rvm5t7
         YhJ11Lv+GK0V3JvRZcRDkLlzOahN3CfcOqE7M95gchzGh8FIeinV9qFgNDeGq7oq1EqQ
         JwGFiRgF7oOimQr9gD0y384IJvUtNfz7FeYeaDFKVQka4aX/QMvLmof5DTrM2BR1SsBR
         LCXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mGiD8zQqMuzCkGXAZBtgumh8HlT9rNPiWNa35MXqkeQ=;
        fh=zvfj50O+u2LmAogq7hBlZx/dEeynLBuLBj/9rPnEQoc=;
        b=UOUwFPEEwO2CUvu6SMb6Hz+a2PUX91arzXJK9VmWaLgUqSzqzPZSQIAzQcQgZ2uhNp
         ZF82wOwZtJ+EDMD/AILVfbRW9DbjpOKMO7NsxtopJ+An4eKuNYJGqguechCNlXO2yR1j
         eoYtN+bXQLQwMUpVQzTpkEMVUmxu98J0HJ1n+QpLspeGYhGmtGwXKoHfzlOXULcUxqnq
         54edlEZaAPfwuMqdnmYvrHM4CcaaT2p2cZqtzofTQNKRbz/6YCI6GuAAorvaxNp7s8JR
         dMbcUzH2WymN1iIm94FS5qEh/VuDqaTCCqcuMRCTrRy5rD3lDnJmYFfXn/2seA9rb9h0
         QB/w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1793920456; x=1794525256; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mGiD8zQqMuzCkGXAZBtgumh8HlT9rNPiWNa35MXqkeQ=;
        b=IU6i1Fwv/0w/cks1e2nfs6t6sk022zL/8GvQwys2lPo33xKyfU4+rlcYd/DQAZEHG/
         pOKIazGTVuNB5nr366kMh62Z8mKuK+0wykvjpk6nMnF62dQEPqXhVYv3AiAUQh2yheQg
         Wv57SCnVaPWXfP0Spf5ZrgQ+6Qros/0dGKzT5Ct8KPvTnGxmERS9srU07KlGSKT3u7rc
         WSDGWK1HJ7ZHGpFoQ0kLcdKEj3NsCe6oNqECA6Dmye2YgKsYtmlI/U8g/CwAwltsgKHy
         7lk6f9CpVk0uzXD9qAsG8lDByv90XfisBUHNR3hzhw22DDDhGO8biMGoTBxSg1pPVUNx
         pPJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793920456; x=1794525256;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mGiD8zQqMuzCkGXAZBtgumh8HlT9rNPiWNa35MXqkeQ=;
        b=0Ktm+LLuVg+qhpomVtEp4O/qkd1KghAMkniwFuNBGi9ecgNjb8xuiK5uySl2Z/3SUQ
         ciXQ5jw9XgSM1aA1+zcAT90oAB9tdtb4nac95/QhuV18iq7mUxnOe8sCKYsqtZs/MqyR
         WuVc9Cteet+fptyMiTvWl+SoFf4jZ7BuPo9B4RAJWh3sEd3JxdIT6AzkNTOW/Q1Vwrlb
         Di4JjWS9qfyVUPy2fJhQ4yUdOGmKKyTTkGF0SHd44QnUua37gPipyUn9Hc8nhFLElldH
         Vt3H2TI1cFXyFaLzdJsrFMVK64DuWFYc9GJKgnOmxixdBgyEz25A55uiqrpRpNc4lSxL
         t5vg==
X-Forwarded-Encrypted: i=1; AKwUvBwDmBYGTsQpGSgfo4AGpCmBVq9KxhQEG2xKjffPonBqu1lfXpInsUs/NUAYD9gY6t7ZMQ1g/9IoI/U=@vger.kernel.org
X-Gm-Message-State: APuU4Z9howpIPIffyQY091cm7fDDm9LTcwxIwQaWZTPpAJsH+8mUejar
	fBAKxTTo5wE75gnsCc22iRK7WIiG6hOkR2bO21tu3t2kmpCNrO3SMqBbzLVcnCDrtkfVcm0Wk6s
	AqgwexSyhmHQXrSjajQkA/95UyVIk2iLM9zsW+U1Y
X-Gm-Gg: AYBFou2Tz+L+iaxAZT0s0ERQ7jOvTRCbmzF5nurP/hS7UQQ4jSB/Yf0LAzaoonaltd9
	aQZ6sxbzrfQgjDCBwnqe6lyeH9R+wojhTtyMA6FgRMHyknqyHkdznGfpi/j34IMQO0O3jozLaOc
	nJAZpwIkZPAsv2NLvIpLRLeAkVqqLdJNs6GmI+Y+wLi3xhyu1YVrs9CCFHyCxRfTz63+RJXu2Pt
	IXUzwA/G9O3EE73Xe41c+mykoSHcdJSan9kCUya/CsRhwx0593iJnw6ACvVafkeiRWIgqPtCdU6
	K1l19QnDIUbnQ/0QWlRyrhmvJK6fRElYnWZxYw+29PtNmdixYDDVPUtbEtWWgzN3P3hz5UFOMz0
	ZsQttxa/k3dcz5SRS77qqqPCsYCs833KBgpAVKGelji1gWH+YJZgTku6SM2+7/r0wXl/k
X-Received: by 2002:a17:90b:48cf:b0:3ad:a462:f07f with SMTP id
 98e67ed59e1d1-3b0db6e8ca3mr534231a91.45.1793920456567; Thu, 05 Nov 2026
 15:14:16 -0800 (PST)
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Post: <mailto:linux-sgx@vger.kernel.org>
List-Help: <mailto:linux-sgx+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sgx+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261105-late-2026-mmap_prepare-v1-0-c56aadfbab8a@kernel.org> <20261105-late-2026-mmap_prepare-v1-7-c56aadfbab8a@kernel.org>
In-Reply-To: <20261105-late-2026-mmap_prepare-v1-7-c56aadfbab8a@kernel.org>
From: Paul Moore <paul@paul-moore.com>
Date: Thu, 5 Nov 2026 18:14:04 -0500
X-Gm-Features: AclHuK-Yq9Ya_gmjsTlhf760be1vg51BQVbAOtNinoyo6VpZvAmG2k73A1wV2Mc
Message-ID: <CAHC9VhQcmX09Do8BmY-HYJEWKiw7Tf-ZB=EEr9K6t5dBzk0SSQ@mail.gmail.com>
Subject: Re: [PATCH 07/14] selinuxfs: convert mmap hooks to mmap_prepare
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Juergen Gross <jgross@suse.com>, Stefano Stabellini <sstabellini@kernel.org>, 
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Shrikanth Hegde <sshegde@linux.ibm.com>, Haiyang Zhang <haiyangz@microsoft.com>, 
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowangio@gmail.com>, 
	=?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Jan Kara <jack@suse.com>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>, 
	Joel Stanley <joel@jms.id.au>, Andrew Jeffery <andrew@codeconstruct.com.au>, 
	Ryan Chen <ryan_chen@aspeedtech.com>, Billy Tsai <billy_tsai@aspeedtech.com>, 
	Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	Abel Vesa <abelvesa@kernel.org>, Jens Wiklander <jenswi@kernel.org>, 
	Sumit Garg <sumit.garg@kernel.org>, Scott Branden <scott.branden@broadcom.com>, 
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Richard Cochran <richardcochran@gmail.com>, 
	David Woodhouse <dwmw2@infradead.org>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, xen-devel@lists.xenproject.org, 
	linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	virtualization@lists.linux.dev, linux-sgx@vger.kernel.org, 
	selinux@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-aspeed@lists.ozlabs.org, linux-arm-msm@vger.kernel.org, 
	op-tee@lists.trustedfirmware.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 5, 2026 at 4:07=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.or=
g> wrote:
>
> Move from the deprecated mmap hook to the new mmap_prepare hook for the
> policy and status files.
>
> The policy file only sets VMA flags and operations. The status file remap=
s
> a single page, so use the PFN remap mmap action to do so.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  security/selinux/selinuxfs.c | 24 +++++++++++-------------
>  1 file changed, 11 insertions(+), 13 deletions(-)

See my comment in the cover letter.  I'd prefer to take this via the
SELinux tree so it can be included in all of our SELinux testing for
v7.5, but if this has to go through a single tree with the rest of the
changes, here is my ACK.

Acked-by: Paul Moore <paul@paul-moore.com>

--=20
paul-moore.com
