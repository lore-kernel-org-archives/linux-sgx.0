Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795500524;
	b=BzYxMTTawaOvtUrOneEGe6o9gDFSQpNvsLK2b7d6+idy3jy5tUY/Iv8hZhKSdRC/iC3K
	 9JACI5TAnszWE4PcUROhp3wq37RklT0YVoOmh7uiaFNdxLREDcva7+ppC6b5DBONL0/My
	 xkkES+/fFleUIc4RBDfIjOHmeTuzQ/BMYV1CwRX4foQ9pXjfLsgFXwQq9ntPkznucr8EB
	 /gnURgoP4z9qo2bcArs9N0Akin556AwMrNUw9mNPvu9VQ7GjPKVVeI2W+Sa9h3mHtJ+u7
	 qDFuBX6IeOYOQxyAfvH/S27Kbf1Aiaw25BiIfeNqmH1GpepuEhO4o7VPqvf1qV+Aetw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795500524;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:X-Authority-Analysis:
	 X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=dvY4KBfiISm+CQm5KIDUrtb6uzBgUaP0PFQaZpqv52w=;
	b=2M5rwZCkMRhXC+uMWuz5/gB9MfYJpcTP4gcQ98w1Z/Rba7AeINBusArAs4MPCowa1Xv5
	 Xqz8eJMl6vCrl2LNWQ0DksHn73OJzA/gXevz0e1aX9LbfRKdAtRbeJaMfwhWTs9GMCh2C
	 5519v7LhrSrnNr0Uq5V93hv+RFqBhZLRHL52xi7IGJDQN5y4k3gsYg6TqbWgpmp8phzTe
	 GOJH3qXFk/8jpw221IGGVpHb1eYe4Cgxnbd9K60crVVeA5uDHYqm4ZvF9mB2bypegy5EG
	 gOVFJPHuYIX+cbeuiCRCTCSSKDUmDmNuSTr+C8dZ79acQ2njFWLArDROSPFgaCx7b5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Mu+lZvdL;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=ZGO29w+k;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EADEE606A321
	for <linux-sgx@vger.kernel.org>; Tue, 24 Nov 2026 06:08:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EADEE606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Mu+lZvdL;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=ZGO29w+k
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AO2kG293701759
	for <linux-sgx@vger.kernel.org>; Tue, 24 Nov 2026 06:08:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=dvY4KBfiISm+CQm5KIDUrtb6
	uzBgUaP0PFQaZpqv52w=; b=Mu+lZvdLXuWGpOkRTkHFjM/i3/zxBEn62CaGxwiM
	4QAwVoT9XEi4yAVQyTS/Hdf4oK6g4Bc9UAYdPk+DRdycbrtCTJCG8mMPRAhd8Itr
	YJhqFMUPxIvAUoO28f/gr9kwh8uoUQMFVNIJ4mHntvWYoUNjLLZJkNIL9C5NO8j5
	4wzwAtnHxt9pAGjuHvdm/dL4ZGq7SYRNZIslZ6b/jAPWSWpvoexho/kIjWyCe8Go
	XEM9WzZZfx7YDi8VBJiRGkruQKiQYtAWiuR5g/M2YJX70BEeqYi1vnUAfiYQx25H
	1Q6Q3rvSf1diwPrHavfw3ko6BktLi1o93wWElVUR6hp2Ww==
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com [209.85.219.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4j50ky0ywf-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-sgx@vger.kernel.org>; Tue, 24 Nov 2026 06:08:35 +0000 (GMT)
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-9210a12765eso33428416d6.0
        for <linux-sgx@vger.kernel.org>; Mon, 23 Nov 2026 22:08:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1795500515; x=1796105315; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dvY4KBfiISm+CQm5KIDUrtb6uzBgUaP0PFQaZpqv52w=;
        b=ZGO29w+kZqFi0IoremOsMtN9bKkizaQT53H8YWFQDHShgC+v74I6+QopxA9VOzR3ag
         vpo8bEUIF8O5RsZIAg/OLAqOKRB/bKTx8+cSCgApxKM12o3xffG44Tb8wjTZkSkRmxCp
         wij9c01WUZzaDr5rVDD1SJT+iGxhVY2DGrilMJockekBI3nIm+ySQCHW9FAgGT1TCkED
         cBg+mmrXK3wzCDdfn6tJ9MkKWiw3B/ZXVhgrV+oDdRaYRTIjpBAkDMZ/VMsXJhU+E1Kt
         SQ9c84H9SufIQJjJDyuIlA/LWh9gOMXMRnrjdxZtJ49QfcTz5Lm9KRTSNNNdk8bu9nwV
         oZOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795500515; x=1796105315;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dvY4KBfiISm+CQm5KIDUrtb6uzBgUaP0PFQaZpqv52w=;
        b=qD+T8Ko2t+nZyk4KBaKjNU7sYvA6wTidygJjFEeTQwKgaxyJo5odJQI8MRLx7AZ9Vk
         uOszRAj5Kj/EAILpbxMeoVh4bsXGFzbp/2H8hvS/0HtzAnxBLJQYlwe9l8GXOwpf9+7B
         i+4ktykthS9pXwmwCWTjYHES9QquTrCZKz2r92K0Xi72OBAcagyxUWtkqwni3MLIUif2
         sQ0dRbzBD/9AYgePjye4ma3kFOJyhf4bpedx6hLrltiZdnrEQbyCVUnA9S3JY1iXdTz+
         Gxgad7Q3j6c4KiVPk2pev5VJDBFs0REvBAalfD1r/PQxV/X5HAdsTUx9Yhm0COyyhgzW
         kJnQ==
X-Forwarded-Encrypted: i=1; AL+hErHtLASY+k33+n5IjWRGkG0x52LzjusnHNpZpHkod3iBLye/it1TGgxzXNhp23hzPSMZA1hOAolPoDg=@vger.kernel.org
X-Gm-Message-State: APuU4Z8v+X0HK4VGFz6lU/oFVH5QbOIrDFLK6dVWbJmyT2IlEcXcoD6v
	pwl+CE5rRUaYAsXi5kNGHUvS27f8jY5WgSuQTvXCIdQbAZyiJjV/aYRYupnlsaCM8S5s/LlYSh/
	RvzD5KfmOhdwn3hS93ODyQfUcV+59kV0ctK+qY0GTyxia/zTIsEQ0EBbITW85N5k=
X-Gm-Gg: AZFdTZeQSzxY9uMxSpOeeaylJfaOAmdiRkG0quY5d2En1OyWEdIbekKwxJtvSW8yG5j
	zUYE+8S7fK9Sk23BNLetBjZ6ZKCQAFuua3Dy9/3rw9sQ0MSqhtE4EeQ4XPoxc0vgtxo1Awz7ih1
	hkD2QBoT0JJHvCwhBx6JZZT1niXmatpDKCCSAFbeIGoCME9Z6Gm3cGvEXjKqvPMc7efNxZYdnj7
	EcB8/R3n7SgRpmG31ya+tyvvaiLVciL/ktXD1yrUcQMIR2wYEwWd2T/ia51movNOUqA+wVZn20u
	tKBuDgNU92klvRf2GIXrlsQr09RurnDcqX3lcjDFVKnmaLOm4i6RzPDx7jZGu9Slj/rlx4zHqke
	MyOEGrwHuhsx+7AApD1ACmbJJOHSPWvy8q/Zd8/1DdlYPb+a5xviSPsx/opNs55U=
X-Received: by 2002:a05:620a:3185:b0:93e:94a4:a97d with SMTP id af79cd13be357-949ba683204mr2433057885a.0.1795500514633;
        Mon, 23 Nov 2026 22:08:34 -0800 (PST)
X-Received: by 2002:a05:620a:3185:b0:93e:94a4:a97d with SMTP id af79cd13be357-949ba683204mr2433050285a.0.1795500514001;
        Mon, 23 Nov 2026 22:08:34 -0800 (PST)
Received: from oss.qualcomm.com ([188.27.161.77])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ad644140b5sm23005124f8f.17.2026.11.23.22.08.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 22:08:33 -0800 (PST)
Date: Tue, 24 Nov 2026 08:08:29 +0200
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
Message-ID: <7zkdydihgjnqxerwzbebrcryry37hcqc47dpzqmoxdgc7qt3i6@uanst4lmvvkn>
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
X-Authority-Analysis: v=2.4 cv=Y+ptIReN c=1 sm=1 tr=0 ts=6b0529e3 cx=c_pps
 a=oc9J++0uMp73DTRD5QyR2A==:117 a=asF+/XNaGoxFafzDDLC1GQ==:17
 a=kj9zAlcOel0A:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=2UNkV1bVvYdQOko7pskA:9 a=CjuIK1q_8ugA:10
 a=QtEvL3ry9E0A:10 a=iYH6xdkBrDN1Jqds4HTS:22
X-Proofpoint-GUID: pMFAbrPgChRxym4sKaVgFXK4DkdPNrkY
X-Proofpoint-ORIG-GUID: pMFAbrPgChRxym4sKaVgFXK4DkdPNrkY
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI0MDAyNCBTYWx0ZWRfXy31e7nGdrbP6
 l1TIbTMjGFg+jhXOgbRJz1oJpBYp17CVLnC88hd+MloMab30Du7yyLyx5V7CRN2zw9ZQPy2ZN6Z
 oA8sYrHxd8tihIGYZkeU5NRAmDeKez4=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI0MDAyNCBTYWx0ZWRfX6fBFbokRyYKc
 nfQAlBzatJbIsbSPgmZagwR6jGq/FQ1TYZccODAqr2KcMZcNg7j2I0lYbfC9Nb1zT6UwemW0TbY
 rvt+rHYC3qEBLYOcmz29Zv7ai8xrwF04xsTDF0FLW1KTsqU7rL5y5aM46JHiB/jtuOBZdkcot0w
 MQODRLRjeafPbNHG1LandvmQ0jZxAbLw2S/+SOoSFtmBp4V64orTBtu0e/1ZLJAbd0nrSAl6ORB
 TYLs6HIuTQn+USIawxv/Rm4p31VgoiAVD/FrVP7GneYVHf1DL02wqV7HMNBjCuw+qo1rbRbNWAT
 CnMbuVEUu/zF8Ds0MA/jAZblwiEhSGsskjQhlJaoPhLMuCDcR44MRqIszyAHrKfsneNi/1n8f4I
 Vv+OSRD/cuZCuct8/xcOWV4zKJ7E8adFqA9wXkc24VCBeD7qBey0+bYPfkSC/kvRsyovO76ev2F
 DbRLfGhOCalf15cMKqQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-24_01,2026-11-23_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1015 malwarescore=0 adultscore=0 spamscore=0
 lowpriorityscore=0 bulkscore=0 suspectscore=0 impostorscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611240024

On 26-11-05 21:05:41, Lorenzo Stoakes (ARM) wrote:
> Move from the deprecated mmap hook to the new mmap_prepare hook, using the
> PFN remap mmap action to map the region.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

LGTM, so:

Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
