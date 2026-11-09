Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794215686;
	b=dMJCr/lJjwYRCAbjuw9XQP2CqgTjnrJnJMUFnqwPKCPkDj53hjtb2giZf1xxGzydhaA1
	 8GVU4fPpkSiJhalcbmL49L9Ja9Qcd/5OdUQRIBgiM06D1VbQlGf9S9xR5n5Q23A2SaM9U
	 7A7yy9WPRabv4/PaT1nY6wf+ZXkCxtL0isKOfVc/gyGuud6yeulInb1KtUZigXenbsVSq
	 QhAqem/jt9g7yVzo6JZJ/wDoWSSJ9X1m3nfSSfxG9gvM8ItjWxFa5Vpn7lm2NPSmpGazf
	 TTRFKKC3OWiaUVQ7hr2KKFZRO8+adc0WkEqmna5kAETQ1+mu3OduGQ9yPyTP9HDB2DQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794215686;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:X-Authority-Analysis:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=dvY4KBfiISm+CQm5KIDUrtb6uzBgUaP0PFQaZpqv52w=;
	b=SGaEpHWJ566/tqi3YOcAM5YxtNLuUdT/K4tV0HuyUXIn68NLlgKZIQgLs/jcqVjbAMUK
	 I/ud42ZWJU9moNLC2e6gEyD5j1fxh+dwQNXrmtcbJ2rYp+G65EvyGjm8VRHmuyGNox+W9
	 qr4jgD3G1fsd90hdDPr8t4UQ+GAVuxuF+Jp33eoZtejn1JsMbRzevKluB2LHC6Uh5eM4z
	 xiWia3PA7RDAdomn1Jj5ushZYPJGBgWI8flXIgm9dSuZKt1kXF0V8fvEYSSZAtd6Lht8o
	 p+CHSMK3UA6W10oVq5CWmG+L9dtFRWisFj3ZbFwqJagdk7d9fVafE9hKgVpZ3bw/rIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=CVfpLeBo;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=ZRuWLWCd;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBC07606A32A
	for <linux-sgx@vger.kernel.org>; Mon,  9 Nov 2026 09:14:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CBC07606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=CVfpLeBo;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=ZRuWLWCd
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A96AaZI2008237
	for <linux-sgx@vger.kernel.org>; Mon, 9 Nov 2026 09:14:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=dvY4KBfiISm+CQm5KIDUrtb6
	uzBgUaP0PFQaZpqv52w=; b=CVfpLeBo3svBArcIsMoE8xRGgAiB5mlup0YLE+WU
	miqzZlFGvtGNDDsox8E4acOXK3gFfIwXz4N9NuUoFgsvQYzB36fLfpJjeTRHqc6s
	uy0gSyaVcClNbyTOzA2q8KZ6eX3yeJTqJ/ms2Qw2AhTUM6hxMMbK1fitbXikNI1A
	3N1EEpVY6+IW/Gl778ykaY1gR/3PEmrnDIUD2fTp/fa3Hmb8ffAS6UIbg308OCav
	3+Nx4dhrSnt3yHskSXih/XRxBQbXscbe0NIynFJkTP78h6opo1QkdQ+HiyPEGFcV
	CwIq9i7JbhtLjvjXIsVC9XTOcHDqrOSl9f6bgU8BbCtJVA==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hsw5k5e0c-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-sgx@vger.kernel.org>; Mon, 09 Nov 2026 09:14:44 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-93f37c94ceeso134965085a.1
        for <linux-sgx@vger.kernel.org>; Mon, 09 Nov 2026 01:14:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794215684; x=1794820484; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dvY4KBfiISm+CQm5KIDUrtb6uzBgUaP0PFQaZpqv52w=;
        b=ZRuWLWCdtN65wuVlWtWaew5IbZJQV+xs/PnELoRFpgR+THgXzTvZHHOS6lp+q9i/63
         vG1RLNwSZy/EKgkhLioQy9BvJu6DTvuI72ZPuG8/ZNGhIX27xfpTPHxjQspokzT+CS4w
         mq2ipsL1uBiZh1A8Udd+SM9ptm9xaw9Aazb85UGx3wPDnivcG0l55rJLyxme0XB0pV1N
         ZQoZ1fCQPdtCa7a1K3weoQ5WiLHJL7xD2cFw93ILwjd1phhIsepjgI/zHFTyWW8S7+94
         YChlXmlDmtQB/vMWu+nkqRbdYGmnJ5OOssgzpkC1RENEguS4LhadiD01PH1aMyZUHojQ
         QMhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794215684; x=1794820484;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dvY4KBfiISm+CQm5KIDUrtb6uzBgUaP0PFQaZpqv52w=;
        b=buBSkkKX58XSqlXSI+GC66e2dfk2U2oX+TuBhN/jcZ7w8yKGkQZ5bFmrcwoMLr8qwd
         Cd/QJGJHeD13KBsSJ8OBXYpqqe3xNJ8LChcH8Yau41VLDuzwr43UFn4EK+iSXpm8hUGJ
         XPQej/xcwMJD8C97Y1cgyULKIkDkLrtUp2MGJc2f14JziCKUU7MjsY8Wi9q+62rVvitM
         dSnBXwy2+ptVTvlKqPq3WfFwgodlEqY0b3aYry8cNNrjaFTKVkqPwHLRxFNC+v/jIKDv
         q5FHKilvccPj8APlkYsjYrXuJw1V5gRscMZqzQNWg1UnTYS634bQv7qDwDYibCX+hbYN
         g/IQ==
X-Forwarded-Encrypted: i=1; AL+hErGYzMO+kxICDGveoWrPppxeMLQ6oo1TdSX1y/8bQBbX6lQ93sMV1uDnxMvvpoMZ5HX+7ohofn+luAo=@vger.kernel.org
X-Gm-Message-State: APuU4Z/TRW2MkAGKlvBBimioi1ONcrsd7ElixlJiCAc4WstazHcu50xV
	SJrZr3O5KuRjSMfVCyb7tWIDrxyIYa6TCkfc4CpBt2FvSKLx+FEtpOtftol9CkanRM1ZajYwKXv
	ajz2Ci5KiPV7ytb5EoGrvKR/Vwi3IkUQbLf2jkJEBsYBUqmrzmLh03Uo6JFGh4A4=
X-Gm-Gg: AYBFou2+GHqNHSORcjpb96h0skhr29QNBA/0/CjAxjbhPev7fdnaGxw7eGSAmXcnadf
	A5ntytkguQui7RvhkWVxTPrhVG6tpKCrn8Hh/BuaOvYl03vxzPjW9XjUH2OZqgLsNUWhaVYa3DK
	j13du4Ayb00wm8cCHqGSaw/CyhkSi3DHQymjEM8NCLIsIZ7q6XbHYib4/8QfDYELbhrlzpdZsNj
	MsO+CFjLU62gA/Yor7aFxMVlsH800OlvXRd06RZRTQQPp2QSygzi0pIT27o/Jo7VIZ0zboUFTms
	XQoQiqbSmKyn7TmNKnkLZs/S8w8UecWP5g8wBP6vBnd4hT+d3Lem7NdBCd5RQgPXkDN1p+SXcuq
	WgOb0I1p5H2HNksB2CA/RswA3B1bmizJeyhsh+mlMMM+/QmgttNxl6upr4/5aH90=
X-Received: by 2002:a05:620a:1a16:b0:93c:65e3:df81 with SMTP id af79cd13be357-94604d2c6e2mr886329985a.13.1794215683669;
        Mon, 09 Nov 2026 01:14:43 -0800 (PST)
X-Received: by 2002:a05:620a:1a16:b0:93c:65e3:df81 with SMTP id af79cd13be357-94604d2c6e2mr886320985a.13.1794215682798;
        Mon, 09 Nov 2026 01:14:42 -0800 (PST)
Received: from oss.qualcomm.com ([188.27.161.77])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b795024730sm161196965e9.4.2026.11.09.01.14.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 01:14:42 -0800 (PST)
Date: Mon, 9 Nov 2026 11:14:38 +0200
From: Abel Vesa <abel.vesa@oss.qualcomm.com>
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
        Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Jan Kara <jack@suse.com>,
        Paul Moore <paul@paul-moore.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Ondrej =?utf-8?B?TW9zbsOhxI1law==?= <omosnacek@gmail.com>,
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
Subject: Re: [PATCH 10/14] soc: qcom: rmtfs_mem: convert mmap hook to
 mmap_prepare
Message-ID: <tr3hhmd6gqvvzrngazyovx7jfbw6k45yjw2mipqu3aegsy5oda@7qromidf5btb>
References: <20261105-late-2026-mmap_prepare-v1-0-c56aadfbab8a@kernel.org>
 <20261105-late-2026-mmap_prepare-v1-10-c56aadfbab8a@kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Post: <mailto:linux-sgx@vger.kernel.org>
List-Help: <mailto:linux-sgx+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sgx+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261105-late-2026-mmap_prepare-v1-10-c56aadfbab8a@kernel.org>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA5MDAzNiBTYWx0ZWRfX6EGlxb56qWXz
 QmAKGTnjJLW4dXGYzBDtr0nCpbSX/8vW20mD9UgdQbIXKTeSdrO//1lim+dN1iYluekQInX+6WE
 Fm7xDxH4T6py0bMgQND63ZxfVAzq6t1GIliRZP9ScuzYDQwLG/rXT/RNhK9EMxCanhEw06MJNIA
 6CMNZfLBgVMIMjWOaZ8uW+Xy9MVr9imqIHTQliL6H43f+lLDbNYHmqUjD3mPlZtUat8Hc9bFntq
 IOWbxiBpubs+PycCy0NZkoWBLinJ1C+TEYe9kWGL16NKIRGbqjlOL55yOZwaav0r4RxQ/Skivgq
 9dW76RmpuK5jEpBBJBC+F3gASJRwEh+zb/39B+zfoBxMIOCLOyW8s1HjTb8k5dAWKJQrmqc/qdq
 8Iac/L2D3p84PE+gqNP89Bgweo6+mnpXP+bwykDhEg4VRfLcswpjkhaNwY5Uo4Zq6hpxFKfOkrq
 jsekhpmVxt+yJHKp6QA==
X-Proofpoint-ORIG-GUID: Hy7cnB7Enm6kwh0wnAUD__2wHGXfEUG2
X-Proofpoint-GUID: Hy7cnB7Enm6kwh0wnAUD__2wHGXfEUG2
X-Authority-Analysis: v=2.4 cv=G/aJgNk5 c=1 sm=1 tr=0 ts=6af18f04 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=asF+/XNaGoxFafzDDLC1GQ==:17
 a=kj9zAlcOel0A:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=2UNkV1bVvYdQOko7pskA:9 a=CjuIK1q_8ugA:10
 a=QtEvL3ry9E0A:10 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA5MDAzNiBTYWx0ZWRfX/47GIzVGz2Wq
 +pVumQ3CqPFfWrQFTeg8aL4Du6dE0x7lyFWQ+v12486K3IYOIYJUIXnHjXVT+kcJoM3QtDTaPlW
 K522MtDrRvSTCPdjwERJi7/Yp55Y2CI=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-09_03,2026-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 spamscore=0 phishscore=0 clxscore=1011
 bulkscore=0 adultscore=0 malwarescore=0 impostorscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611090036

On 26-11-05 21:05:41, Lorenzo Stoakes (ARM) wrote:
> Move from the deprecated mmap hook to the new mmap_prepare hook, using the
> PFN remap mmap action to map the region.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

LGTM, so:

Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
