Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.168.131
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795505877;
	b=G6wDYH0R84r28HWjWGbTdg7iI3BS5+UxCBzmh1MuEtT3eV6MYC813GRE8q3hibLhg9qc
	 yzb0G3z4A3IU+cThbP6Pwsu8uSUIGf5rsiToGw7LMUyuPSeprybJiHNemyfNwuppEtkX3
	 qlLiwN27LNX/WJsK5gtw0F6RXsdQTPvcg5jGDPnzah+IGuAH8xGYlARf09STZxE2NGDBf
	 SLW8ahjdQ7KNeC+9X8q/hpHLe6VG0KHkg9rp1CRGEX+iKIQIYJ3ZUv5WdmpQDkwxtbxKh
	 PT9kb2h3mkdQALc6EQsCXUjHl5MV9PNo/WkL0ay8cQatLjHeSjzfH3zasBRJqqrdahA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795505877;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:MIME-Version:
	 References:In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:
	 Cc:Content-Type:Content-Transfer-Encoding:X-Authority-Analysis:
	 X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=WLDBCseQttjsh+YgjaRZ95arQzmquJXtwPce4pg+uuw=;
	b=c7ZKU4oQh+ep2VLxYkp4jv7a4in+bMD+FKN0Mc3nF5WjQ3VJvK9NvwlYxRi62kgfvrzj
	 rg4DyiNY2n/1nUrCKBqnLE2wQQMNSCUXf77WX8C08x2ZuLBkN9fPxjDeCWzR85W3EPAnP
	 k7SoNXkWoTOUMNZt/OWguZ/TlTVNSpH+aJdQTAcf8rlELVtxsmJWiBpwb8Wjrmeq4qwXw
	 MJwdn/rLI4e/w6/WfVJNp9KqAxeyRW6phdvH2y/8HjyXgDML9JtNj4jKMoTl1aRahBElx
	 oC1h+7ZuMnFzG4WKfzZYtizDJ/2kdmGk6SwZz8OkKfTrHoS/LSy29MGAWoY/JLQT7jg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=jB2OhFnb;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=S1+Iax5U;
	arc=pass header.oldest-pass=0 smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7C1C606A33A
	for <linux-sgx@vger.kernel.org>; Tue, 24 Nov 2026 07:37:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B7C1C606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=jB2OhFnb;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=S1+Iax5U
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AO2k1VK3701099
	for <linux-sgx@vger.kernel.org>; Tue, 24 Nov 2026 07:37:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	WLDBCseQttjsh+YgjaRZ95arQzmquJXtwPce4pg+uuw=; b=jB2OhFnb5kcQJfBh
	9PooZCIYHGNUVjDcGwumXONQT2rphRiM+HKb+Z5rBcfoZ9URBb6HmUCKyU398p1z
	0DE3n1unAJCPGSKA9qHqDKxoWrwnFiNfWRaB4F0mZuQ+gIyw7qVkk0rFFWIT+hr0
	xlGvD+nbKD4m1GM6eRm0zn5N+zABS6NWAAQ4zM+xLUUTfkXPLcKrmGNQSuaj6NVk
	LSMFCUkYtOrVzKgsE9JjRJp/p/+NgBxqv/l5UGfpSyCfsEnsySH6HhHWtAFvnFTH
	QiJHfUK8nig+0y+RvbrdRu8nHxWlPz45JWmVSfVxj87VvZ9rM/3qatNGi8g/YvkN
	LVZ85g==
Received: from mail-yx1-f72.google.com (mail-yx1-f72.google.com [74.125.224.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4j50ky1aek-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-sgx@vger.kernel.org>; Tue, 24 Nov 2026 07:37:56 +0000 (GMT)
Received: by mail-yx1-f72.google.com with SMTP id 956f58d0204a3-6798fd97f3aso7047027d50.1
        for <linux-sgx@vger.kernel.org>; Mon, 23 Nov 2026 23:37:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795505875; cv=none;
        d=google.com; s=arc-20260327;
        b=EBsdZfBJ/Rojyfl6OlbcrBZ8PWC0EPLnZrARK01afZ1NX4ZBQ4Q3oZ7EuaOPL4SZkS
         eL+r7tj5hSCS2f2cHgdddaIEeEjPbNhDLwr4opASsc3RNNr2Yhq4i+1aVQrzGX71gsK6
         E1md6VwkDPEbLn6uNPYCKY47U7iUcAColseMjWZP0qDQ8A3qm3FYfd6c/QrgDoPaHxLM
         TZ6/uuAjM/qbADOLOmgAaWW8OJb+s6KyA4xSDoeDm0evUwtEp9HZESQ7dMgLYCm+Nr6S
         Ml1y+UGWn3Eav77OTawGHlTE3DaUlqyWlxku71kSiEW515ReUkxpEWoRryfpybOy/zIa
         Bqdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WLDBCseQttjsh+YgjaRZ95arQzmquJXtwPce4pg+uuw=;
        fh=JFsVeYTU7uuiOQUyC6GXPhw3kdI0xQHv2/PWpAT4lxk=;
        b=DVPeYkYTPRcxv7OG+luOlkApUhdQF07IExS41pzPs+rfHB6nx1o+OcF6dBsSykwfEm
         uo9Kz8OmYsgaVcK63zawbg3afqzf+9uWsnAwxV7rW5bZc9XoaaWL4ZAH81dQDXcG4O2r
         KxnwzxyJM6yY+RF+yfD/6yF4pUArVPSeTl6u6v9M7ay2mEJ/Ev5O3DX++fif5mvsfx3I
         itiULRwMN/VAq8fb02fjrHbAbTp+DeC2XtRmjnBesnKrdSj0eWPRPPA7ncZTHwDeH/SB
         BJmo2hC5LRzyOcTerwQewwV1vELGqW/NI2GA4LF5sdV7R1L6H6TjaMALTROdK19qOpFP
         aR7Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1795505875; x=1796110675; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WLDBCseQttjsh+YgjaRZ95arQzmquJXtwPce4pg+uuw=;
        b=S1+Iax5UjwdrBfjmC61+6GR7Ef9vLvndZMhbV6RF5f5jjGfM0fKOFIGSb9cZxbE499
         ufQ0Iw9iW/MkroytuRNTzxKljpJElsFF8w9uRLGP7Avq+RZTb57Ul1XAJRZ5qQA1kqxg
         7jbG878tFdG6DzFw+/37L1jhd6FV1aCc7/cXrp+cfOfsQhmbgR+jpkWB2+0CyWhWN8/h
         yrF5TtN9QZy1tEKAfvOEpPuv5AnxPa6u6OCgoeLhGxjDwK43OfnV/PUQdhSEXPtDxnYS
         FFlkC6lp8vy68Kr1OCdhQERS5xVbG1XGyggIdSHRH/KZmZy1PSroQztV131DD4SIsduA
         xQvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795505875; x=1796110675;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WLDBCseQttjsh+YgjaRZ95arQzmquJXtwPce4pg+uuw=;
        b=VC+znNDR1Cxnkmt3tdiC2vSlMUq9MWdUugIuf0W8LJ7Pwap0tbEZwTE2QbdIGRZ7tT
         DkIgnWBQYBeHowBN37txyEO6vrHP6dk8VcC4rfcIfe4kbygW2vnlsAcoxfCNfLu2weSx
         aZY7kfr3yh+iAZoP/4od/CijhXIOqaLdNTUQX+drGG5ilL2Z1BHR5mnkfhlg4/LLQdi2
         MUymePdnrrg0qBscY7WgU5bjbwC7/XjaGp5vt9tkFoShegHl4hxLh13g0asuSk6F8qaj
         O4jPdLEM3Ln9gIEDSFuUcHMDCaeBVRjAFKHTlprYl9F+AWBjGu5lEnOjli4yRglsFtFO
         OyvQ==
X-Forwarded-Encrypted: i=1; AL+hErHqsSU7G7zzN7mXrN0HX7gmqOcMZs1LVcrD7qMEH076OFjoFvw9HU1SnFLzNnmOI48N5F/j750cK1k=@vger.kernel.org
X-Gm-Message-State: APuU4Z/gxx0xo6vwC7QSTu4hgUqgnCw4iw+YqFhQPpa7dSQgZKQrEnET
	4XzO94fzI8iZ40sVZkK6oWRsuUTnYZJ8IPInRKkxb8OJQPHxwDbP2tJh9CUMT7ztCRgSOcIERRm
	UmoF4w2cxBR46ksoWMx0FQYY7ANLvuYNNSowFwHnfRW6w/BPSDjQrrJx1uSgRyxbRGnB98I+LFf
	jcwHhKGHy3g7Jbecz3zz5+I1Ro1huorjDf4Ib8Cw==
X-Gm-Gg: AZFdTZf43xCpBoz2t0A41II3Ve9SnVzdVtikjEvpqch5p3GUH534Ll56mC4+6Zrg9b2
	ecolxCan2g0wxGH2s9ekfICC90DFZlt/PDIWoD2YqH6z5DGaTnXGAvPqUoMpoEAcg3a27FVK3xT
	Z+OIznVxsATVgDgcT0iuN9kWOPDK03hnLXEwiGPT88k8Qupuxs6LiKJPiISy7V9QGqNzYarhfQl
	OqaPDvstTyCUtYw83Lpc4u8Hkg/jzjUQBASwfkS
X-Received: by 2002:a05:690e:450d:10b0:677:cbfc:be28 with SMTP id 956f58d0204a3-67df447c2b9mr2926905d50.75.1795505874994;
        Mon, 23 Nov 2026 23:37:54 -0800 (PST)
X-Received: by 2002:a05:690e:450d:10b0:677:cbfc:be28 with SMTP id
 956f58d0204a3-67df447c2b9mr2926857d50.75.1795505874551; Mon, 23 Nov 2026
 23:37:54 -0800 (PST)
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Post: <mailto:linux-sgx@vger.kernel.org>
List-Help: <mailto:linux-sgx+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sgx+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261105-late-2026-mmap_prepare-v1-0-c56aadfbab8a@kernel.org> <20261105-late-2026-mmap_prepare-v1-11-c56aadfbab8a@kernel.org>
In-Reply-To: <20261105-late-2026-mmap_prepare-v1-11-c56aadfbab8a@kernel.org>
From: Jens Wiklander <jens.wiklander@oss.qualcomm.com>
Date: Tue, 24 Nov 2026 08:37:43 +0100
X-Gm-Features: Aa3M54q5vxZ2pH5GHxV6_gcu1Tnc83EBXhtYw1pJ9H77Fl7U3CQoqAKpEumRrbk
Message-ID: <CAGgiveX=Z5gS7iJWBanyysVUStDRbgTnVktQwJySXw_-xL+sUA@mail.gmail.com>
Subject: Re: [PATCH 11/14] tee: convert shm mmap hook to mmap_prepare
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        Shrikanth Hegde <sshegde@linux.ibm.com>,
        Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowangio@gmail.com>,
        =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Jan Kara <jack@suse.com>,
        Paul Moore <paul@paul-moore.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>,
        Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@codeconstruct.com.au>,
        Ryan Chen <ryan_chen@aspeedtech.com>,
        Billy Tsai <billy_tsai@aspeedtech.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abelvesa@kernel.org>, Jens Wiklander <jenswi@kernel.org>,
        Sumit Garg <sumit.garg@kernel.org>,
        Scott Branden <scott.branden@broadcom.com>,
        Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Richard Cochran <richardcochran@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Andrew Lunn <andrew+netdev@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org, linux-hyperv@vger.kernel.org,
        virtualization@lists.linux.dev, linux-sgx@vger.kernel.org,
        selinux@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-arm-msm@vger.kernel.org,
        op-tee@lists.trustedfirmware.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Authority-Analysis: v=2.4 cv=Y+ptIReN c=1 sm=1 tr=0 ts=6b053ed4 cx=c_pps
 a=VEzVgl358Dq0xwHDEbsOzA==:117 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10
 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22
 a=_K5XuSEh1TEqbUxoQ0s3:22 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8
 a=97S62Xg_vF6B0O42EdoA:9 a=QEXdDO2ut3YA:10 a=uujmmnXaIg8lM0-o0HFK:22
X-Proofpoint-GUID: KcN4DkW2MnI6ZrdCFfpiWkjsjY8klLIb
X-Proofpoint-ORIG-GUID: KcN4DkW2MnI6ZrdCFfpiWkjsjY8klLIb
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI0MDAzMCBTYWx0ZWRfX8AGigx7rLWXs
 waa8RCPrp0SsAP0tE2A5VZ6WfcT0fh1PZFKTL3TQgKhxi1pR/7KfFen1v4Yd4Wrl1kK15zmNZ98
 DjumUH35hlgBonnRKh0wBMGMOfR7nHY=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI0MDAzMCBTYWx0ZWRfX7uxhVueIdEJB
 F1WCYpZ0beFpXDgO4lU3ezQ8AY6zrfh9W41PPle/Kv3UPNuf6YdkFmTrZOehW5mM8vHCD4SCqWn
 a38866T17vlB7L2iR7kaLmGZvz2m3rB1tWKqHKOs/9mF/fhbgVZjrWBwLgc1u6iKqb2hgIlIEYH
 YZNoTnUyvwORxYMm9Vp5GAQPWPBrb6uX9uOPOwNEtUH/kvObwzKjpfMRSd9eB1vyaf+Kj+xOysA
 croZoItXzRJwn+8gKvoMU9pdQkkXKmRT569vNrJGfSwuDgMLYQfH7Mi9xb5l1U1j6WPK10aLhBA
 /4WYb71Ow1/7m+u757luCKQr5r0+Nq7sNTvYaD9QmGFmOUFjoD7SDrfAOMRmuhKQgzm+ee2skp7
 9ilt642z1tXbUwHiVJKPutD8doGT2Gna/3xNG+SMxYGLZcZuCrDCXSP381dGsyucj5eGzvVG0g8
 Y39nasuxRtOXEc9idPQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-24_01,2026-11-23_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1011 malwarescore=0 adultscore=0 spamscore=0
 lowpriorityscore=0 bulkscore=0 suspectscore=0 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611240030

On Thu, Nov 5, 2026 at 10:08=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
>
> Move from the deprecated mmap hook to the new mmap_prepare hook, using th=
e
> PFN remap mmap action to map the shared memory.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  drivers/tee/tee_shm.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)

Reviewed-by: Jens Wiklander <jens.wiklander@oss.qualcomm.com>

Thanks,
Jens

>
> diff --git a/drivers/tee/tee_shm.c b/drivers/tee/tee_shm.c
> index daa4af1e089e..8fcbf0232aeb 100644
> --- a/drivers/tee/tee_shm.c
> +++ b/drivers/tee/tee_shm.c
> @@ -567,10 +567,9 @@ static int tee_shm_fop_release(struct inode *inode, =
struct file *filp)
>         return 0;
>  }
>
> -static int tee_shm_fop_mmap(struct file *filp, struct vm_area_struct *vm=
a)
> +static int tee_shm_fop_mmap_prepare(struct vm_area_desc *desc)
>  {
> -       struct tee_shm *shm =3D filp->private_data;
> -       size_t size =3D vma->vm_end - vma->vm_start;
> +       struct tee_shm *shm =3D desc->file->private_data;
>
>         /* Refuse sharing shared memory provided by application */
>         if (shm->flags & TEE_SHM_USER_MAPPED)
> @@ -580,17 +579,18 @@ static int tee_shm_fop_mmap(struct file *filp, stru=
ct vm_area_struct *vma)
>                 return -EINVAL;
>
>         /* check for overflowing the buffer's size */
> -       if (vma->vm_pgoff + vma_pages(vma) > shm->size >> PAGE_SHIFT)
> +       if (desc->pgoff + vma_desc_pages(desc) > shm->size >> PAGE_SHIFT)
>                 return -EINVAL;
>
> -       return remap_pfn_range(vma, vma->vm_start, shm->paddr >> PAGE_SHI=
FT,
> -                              size, vma->vm_page_prot);
> +       mmap_action_remap_full(desc, shm->paddr >> PAGE_SHIFT);
> +
> +       return 0;
>  }
>
>  static const struct file_operations tee_shm_fops =3D {
>         .owner =3D THIS_MODULE,
>         .release =3D tee_shm_fop_release,
> -       .mmap =3D tee_shm_fop_mmap,
> +       .mmap_prepare =3D tee_shm_fop_mmap_prepare,
>  };
>
>  /**
>
> --
> 2.56.0
>
