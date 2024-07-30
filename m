Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C22A1898F7
	for <linux-sgx@vger.kernel.org>; Tue, 30 Jul 2024 17:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722362189; cv=none; b=uXIIR4OJ8dnDVkGdOGMEyLYgBXW0DaUahyHHiqB+t4pQMtjsgHD0GxaRhK1m7yRDr1jnZchyQgjTqQCnSMO0NG7tfrr1uuaZT1BbZnX6vvJFJlUVCIv98fWIjiHRxN9Q3eUYFfOHrPH/Z6roHRATSjsYdsQZ8g0pXcgIm1LX8HQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722362189; c=relaxed/simple;
	bh=clDX0AH3ie6CE5gZaYN6ZgnTNNR7wl4EUFnpUsuWZys=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=osNh/zYYIkhrWxBXi7OXP/l31Iu1qikAM6KYGY4BtKGVwo7W6mf3ZLYQD0mtu4r7zWK8l7dtpwPG8GfK3kBt8qPrLqHnwBB4b5UkPe4hMa6Jk2S21wV1Zt9WhtxmbrgNPqANzI5KuD6I+8NZ4pqPuuJlr9/dPqWP6/wcy5/RUuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hEnz6Yl2; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hEnz6Yl2"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-70d1c8d98baso4290192b3a.3
        for <linux-sgx@vger.kernel.org>; Tue, 30 Jul 2024 10:56:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1722362187; x=1722966987; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=O5ReJS5eOTONFkIUkRNY9RePjsldHTBCrkbHRHcbRgw=;
        b=hEnz6Yl20dkdSgHJh0F+5SwajICOQ654X1a5qc2ehqpVrrhgpnvM3bfXt8GZnH1k2Z
         AoFH2XQ1L6mD38etj0yoU5OmuWsFIwvGn2Ogj6I6FQmzadOlEiXjCTgaYW+1s3dtyiM8
         Owqi8yH9qBuXT6MypwunPcij5l1yHSYt3B9XtVmlaKP8XdHQ6FRKhFH5Tiamt5WBEPzN
         cakf6wEEv/JVZozcLuRElVSrWkJBLXrMpzo01+nh/hjfSXWcKrDZi32wAyMRu20eAfOg
         TL0ufL6ZCR2LB4eC5lzzoUj1dpR2fVCnoEM17yFPYNWIRh9B4WLlL771njUSL7qhenKU
         xj3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722362187; x=1722966987;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O5ReJS5eOTONFkIUkRNY9RePjsldHTBCrkbHRHcbRgw=;
        b=G02TDv66KTSVjwKtX4nKYuQ+3XMhVJzMHBt98kE65SdFAM7toWY9ojdK0l+vuTAKyl
         sKP52whjXzUZgAg+AJEcboow7j5lwQlTVpqDl5dG+tajvFZUJeQABnIFBrv14FV51ekq
         mSVYAk9I6bZjzIen++rQpEpEuoq+A4xwqIwORgnyMw5v5uPhZPoKd75i9dWOHLbkNfXJ
         u4IHgcV4sI4T6TZGL+TT2p+8E8SKG+MoEmB42UAff5cn8a0g0AT8S8yEeh+MT0xMRp15
         WF1299SjpViOoJpDrdvZV+MzdS5+0e/kmdpT3Gub+omWjPLEliBD8rpT1EY6UCqlrIbB
         pJPw==
X-Forwarded-Encrypted: i=1; AJvYcCX8fAOqONhNzsEWmMtLtc4K4cmZu3W2eI/Ceac2CAyAcepS8cvAE5ORH3FLaYXSzoaEEmTGtpVsuwGBuSQccgKH0XrDqCKoiXKa
X-Gm-Message-State: AOJu0Yyi1pedwOTi3Jqk5L+kFXh6fUKJkzOF1mT6XJlUcz7/Aha+TwF/
	6OOe2WO5X8ep+tCbs42mst43ATD/S/X7uVPCjYxm2gHUyKtQ57SYTWa0JuutdzRA+hQ+bvf1MB/
	Uug==
X-Google-Smtp-Source: AGHT+IH02dj9QFhhIx2HroQS9I0Z6Bdlq6Qv1jCSUT6NHJQk9HXORWjNuBwTt/8b7GSNIi1JUbPLl4OME8g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a62:e314:0:b0:70e:9e1e:e6ed with SMTP id
 d2e1a72fcca58-70ecea216d6mr30142b3a.2.1722362187070; Tue, 30 Jul 2024
 10:56:27 -0700 (PDT)
Date: Tue, 30 Jul 2024 10:56:25 -0700
In-Reply-To: <a56bc12f6c60107c935db31d7330d28980ac4d5a.camel@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <D345627B0A699F37+20240730024931.1026933-1-wangyuli@uniontech.com> <a56bc12f6c60107c935db31d7330d28980ac4d5a.camel@intel.com>
Message-ID: <ZqkpSX8xfbny7L0e@google.com>
Subject: Re: [PATCH] x86/cpufeatures: SGX: Adjust the error message when BIOS
 does not support SGX
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: "bp@alien8.de" <bp@alien8.de>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "hpa@zytor.com" <hpa@zytor.com>, 
	"wangyuli@uniontech.com" <wangyuli@uniontech.com>, "tglx@linutronix.de" <tglx@linutronix.de>, 
	"mingo@redhat.com" <mingo@redhat.com>, "xiangzelong@uniontech.com" <xiangzelong@uniontech.com>, 
	"baimingcong@uniontech.com" <baimingcong@uniontech.com>, 
	"linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>, "jarkko@kernel.org" <jarkko@kernel.org>, 
	"x86@kernel.org" <x86@kernel.org>, "guanwentao@uniontech.com" <guanwentao@uniontech.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"haitao.huang@linux.intel.com" <haitao.huang@linux.intel.com>, "wubo@uniontech.com" <wubo@uniontech.com>
Content-Type: text/plain; charset="us-ascii"

On Tue, Jul 30, 2024, Kai Huang wrote:
> On Tue, 2024-07-30 at 10:49 +0800, WangYuli wrote:
> > When SGX is not supported by the BIOS, we still output the error
> > 'SGX disabled by BIOS', which can be confusing since there might not be
> > an SGX-related option in the BIOS settings.
> 
> +linux-sgx list, Jarkko, Haitao.
> 
> This message is only printed when SGX is reported in CPUID but is not
> enabled in the FEAT_CTL MSR.  I can only recall this can happen when the
> BIOS actually provides an option for the user to turn on/off SGX, in
> which case the current message is correct.

FWIW, this could easily happen with a virtual machine, e.g. running an old QEMU
with `-cpu host`.

