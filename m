Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65FBB1C3BEA
	for <linux-sgx@vger.kernel.org>; Fri, 13 Dec 2024 10:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734087241; cv=none; b=T8x+PDu3mOrlrDKMiICs5YrFbmZObwDG/cPWBW6UGaRPKm/zp3KW05A2SWhkdvDzEhPDXJJSBNR3IM0mdqp3ixCd0aPNvegKdzK/m4O7yaFJmENPg4FyB4m8ozeY19rGdvn6MoXEL4EtgzdGZvSLkMjTXnNke4BgQdbIuiY2PiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734087241; c=relaxed/simple;
	bh=okqpacIbcOlbR8x92errleYPqAKmSIoPXXz7pzDyyqI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=etblaX05esxryPciLprhdsuSXROltkUlDsZS3vefTua1vGT86+3iFEDjTC4Wa/Be3c/YV0M4isKd1NJP2KdDUplXzRyqPTuqoZ29YpS2RLDArtPIvTjn2y19udhj81nnYM6Jd4WRkgZoVM8MpDDi7RKxv39cekysEFSOgNR8/Pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LsRap7bg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LsRap7bg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734087238;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tZP36RlbgyjCPid9qIB9xpaONyqLFu9PuB4d/BcSVyY=;
	b=LsRap7bgoSHcgHTV4oLkKdWtl2Ym8iIwWt5OOyJOBnobwgAMey7ZYnyy4am7/9W6nI1ucV
	55wsvAENP7WLm7W/IXpeedhuu6RsTWjZ0vLpFo71ZVrZ9WYCBkUaCdN+cJcRsLSJZxfpiT
	RwQBpK3pp0hK3TJ/fxV+/bvXYim3ajI=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-474-NNJx07asNmeXcmaswDWwKQ-1; Fri, 13 Dec 2024 05:53:57 -0500
X-MC-Unique: NNJx07asNmeXcmaswDWwKQ-1
X-Mimecast-MFC-AGG-ID: NNJx07asNmeXcmaswDWwKQ
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-aa676465b44so43625966b.2
        for <linux-sgx@vger.kernel.org>; Fri, 13 Dec 2024 02:53:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734087236; x=1734692036;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tZP36RlbgyjCPid9qIB9xpaONyqLFu9PuB4d/BcSVyY=;
        b=phbb467WBzAX1H14QYR3CQGtVtj9CW1IMp9Bdi+NQ7x1i8rY48o4q/9CCtqwMPW0gp
         ZxCT1tgy6MymUWre8hdCcy/Q8jlxaPKxuX2/abVJo6mcxa2XEyG0jatUgTUqZ/VmBiUf
         xiXufCgF0VROG98GSDPDH/uSiN0IuMw2NcwFED1m/8v0YnRfDj6FPUqt+0QNW96XtLed
         CX5JPUzjbsrGkKGmmemR31K9II+N2gyAl2WQ0gnWqDNq5FmSl5gqwUhuy703N2UeGKpn
         iKRfXOsEoR/YJ7l941h+GZel90M70ddOfDgnkjlVFQ2ssGcfCz/v62wFn0XyR3oQGzxV
         Ycsg==
X-Forwarded-Encrypted: i=1; AJvYcCU7FB5PlhV0+LNK/GkDLBwndMXwttT4XvEufa0bxO7cQJ+h6ZnfQH1eokpZ83KzhFP4jsMvH3HdxVk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyGIHF6wzuTclB9YXv4XrGjl0M4s5o57/EP0usNjmsj8f0E/WLl
	RHLLCn5b8qnjW2ls7+tOBq2Dkc7eBGRwgy4O9l3FC8bzvjcJlQk9N3qpQe3y6ObY1eaQcDxznBn
	ERxGg2XSn6JKa6tVv+W4/0B8Ua+NX8xUkXXuOw0Xv7deOxvWl6KSKCwuOHA==
X-Gm-Gg: ASbGncsRrlDHFNsqgfQrlMzfz1DMzKCmHpIvmxWrb3ICbdGiu+cCvkDaCO+PINE4VLg
	HrH/uw7/D5sDNFLcFX+Wxduq3xjYKcpk0ybKqOqTKhlh8LZTulVuLsD0Kw/tE8Siod2qJNsMlpc
	HsSDyQXRe3RnQ9ccs6lcIv0oqEE1IeXocK+dFDazFXslPsTfDPsX0+kiVHizsnUM0FK/omwcZt/
	S+o8SbyAxkbDD0gvEFq1RppWxwn9JQSaK/F8wChVFTSEbuT++0=
X-Received: by 2002:a17:907:7853:b0:aa6:762e:8c20 with SMTP id a640c23a62f3a-aab77e96883mr225244966b.43.1734087236006;
        Fri, 13 Dec 2024 02:53:56 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHpmtuh+bOXDCMGt5rVmLOBisZQNKYOnKYDf15tmo1bduSNwY/0Lm8b87Kpa+9sghGVqcOKLg==
X-Received: by 2002:a17:907:7853:b0:aa6:762e:8c20 with SMTP id a640c23a62f3a-aab77e96883mr225242366b.43.1734087235662;
        Fri, 13 Dec 2024 02:53:55 -0800 (PST)
Received: from fedora (g2.ign.cz. [91.219.240.8])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa69f639f59sm513076066b.193.2024.12.13.02.53.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2024 02:53:55 -0800 (PST)
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, Jarkko
 Sakkinen <jarkko@kernel.org>
Cc: kvm@vger.kernel.org, linux-sgx@vger.kernel.org,
 linux-kernel@vger.kernel.org, Maxim Levitsky <mlevitsk@redhat.com>, Hou
 Wenlong <houwenlong.hwl@antgroup.com>, Xiaoyao Li <xiaoyao.li@intel.com>,
 Kechen Lu <kechenl@nvidia.com>, Oliver Upton <oliver.upton@linux.dev>,
 Binbin Wu <binbin.wu@linux.intel.com>, Yang Weijiang
 <weijiang.yang@intel.com>, Robert Hoo <robert.hoo.linux@gmail.com>
Subject: Re: [PATCH v3 01/57] KVM: x86: Use feature_bit() to clear
 CONSTANT_TSC when emulating CPUID
In-Reply-To: <20241128013424.4096668-2-seanjc@google.com>
References: <20241128013424.4096668-1-seanjc@google.com>
 <20241128013424.4096668-2-seanjc@google.com>
Date: Fri, 13 Dec 2024 11:53:54 +0100
Message-ID: <87ed2bsvjx.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: sBdBhlGvSv_ysMk8N57db8w8tn2PrdSUUwy6rm-jd_c_1734087236
X-Mimecast-Originator: redhat.com
Content-Type: text/plain

Sean Christopherson <seanjc@google.com> writes:

> When clearing CONSTANT_TSC during CPUID emulation due to a Hyper-V quirk,
> use feature_bit() instead of SF() to ensure the bit is actually cleared.
> SF() evaluates to zero if the _host_ doesn't support the feature.  I.e.
> KVM could keep the bit set if userspace advertised CONSTANT_TSC despite
> it not being supported in hardware.

FWIW, I would strongly discourage such setups, all sorts of weird hangs
will likely be observed with Windows guests if TSC rate actually
changes.

>
> Note, translating from a scattered feature to a the hardware version is
> done by __feature_translate(), not SF().  The sole purpose of SF() is to
> check kernel support for the scattered feature, *before* translation.
>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  arch/x86/kvm/cpuid.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 097bdc022d0f..776f24408fa3 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -1630,7 +1630,7 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
>  				*ebx &= ~(F(RTM) | F(HLE));
>  		} else if (function == 0x80000007) {
>  			if (kvm_hv_invtsc_suppressed(vcpu))
> -				*edx &= ~SF(CONSTANT_TSC);
> +				*edx &= ~feature_bit(CONSTANT_TSC);
>  		}
>  	} else {
>  		*eax = *ebx = *ecx = *edx = 0;

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

