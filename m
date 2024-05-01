Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F1D12E1F8
	for <linux-sgx@vger.kernel.org>; Wed,  1 May 2024 13:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714570022; cv=none; b=qTAlnTQCka1VWPnjYkcVQBRvhBRcOjqjP9WfiPV0wIImXgxVNvvAxTEDIC62CI99gwOyHbfA2O7knvj5ioylMidYNyp9jirqH73gPSZGLsLLUXXGwapNunzHKWRBdmMOjQjWuXhbnqhAjliN62WuuXC2378LhGg1YoqBz47OQP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714570022; c=relaxed/simple;
	bh=ehw6SAG+kbHsliF4OQ8Xm50055J6yx3+DlaZFnM29tg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lbcFPOdnPxlHQRAjhhFA/aBs5PSk/beujFLB0tJ/aG7CJsnEz4LUGPpfom3ovoGaHbkAkOO3TEISmN/uwgmbV5TC7SuPq4PNaR1TLCUH7Vjayxf+hO8kHva/QGBdRSZ6wUCshZtlEYNONVeTTS78oh3CpGXBS6jSQE8s9FTgQJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uTNPffqV; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uTNPffqV"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-de57643041bso11247887276.0
        for <linux-sgx@vger.kernel.org>; Wed, 01 May 2024 06:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714570019; x=1715174819; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6DBcVje7sQJG8s2uu2fApbOLUVVFcT0/1pZS1Vx+f9Y=;
        b=uTNPffqVlUqLjz+4jQmUnI5a0s4/9svKkZ7q3Xq9K4igc+YHeaqeK0fL+B55w91y6B
         Ws0eQFfS7SutYbDXBRzID+gUIKuRL9pQjQ9uCDf52iQLC5EoxTcofh3DGKsfZENz8Kqd
         ynpzjhOsyW7G1MWnMADNHCQ02mwVaxZ6qm7EFcgTs6SCsLvawFiHjVKx6/omS5TNXCx4
         nlzgLixhCgvllAHX067FwE2iVs1riNyLNT7R8Sow1HE5fl4Vm1dbDYCdIPGS29H9g7/u
         cxh2tbc/Gl3qn/BMWHz+kxJDx68QhRb6ZMdQjW6KKxvI9ZudKygzgHDzOaujEEU4Wu3r
         fteQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714570019; x=1715174819;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6DBcVje7sQJG8s2uu2fApbOLUVVFcT0/1pZS1Vx+f9Y=;
        b=NDlNfHuJ6QMwUS3nkYOySmrIcpwCNZqHZ7wb63T4Vo2ai9XEsHjLtPfdaOJ5tx93vh
         ZosyrwLYITINJxTYJiU9Yj70cT45+Yb58kgL1K5G3bXa9cU+bFdoIlmtLxrbCM11nrMO
         +n43S1efgIyvpuOkCxLo5ZgVZAku+6g7uQDf46UJcuT9qNtwpvaIK0ADg1GjhEfJtnPf
         s/lci2V7F1cPgQCWkT1/aR7UkEu0ZWGB9OQ0dvAILjfl3CvyQiATnl7Rp1QZMYAlS15d
         s1PKQKOyJlPsQIctL2bnzr1o7lJCp4NfF9rNGrkxbeLxSY89JmrIow5+ngXMvJ0T6jzX
         4twA==
X-Forwarded-Encrypted: i=1; AJvYcCVRwEz1ZPFeWIT3kgpdeZ+7z7xjqV4NX+YWy8VffVOZ/kohbikgbpPlF2TMxNx/YwHxZrogw3+4cMbt0uthZaxrFZqhnaM9KXep
X-Gm-Message-State: AOJu0YwF6aeMLtKk+hRaJwBBAox7tr0FhHabz74LjpVijuIXjfhGBemb
	VegKHed1V5jl637qjAfH6Md4dJGoQSCkhWLEL5MNYK0hmlc7slJuJmb4Ue9uCkiuYdMoS62AmQP
	/iQ==
X-Google-Smtp-Source: AGHT+IEJWGpbrUgjXt0agMfxl6uH0KA2xXXQIskrVStdJjQn0+KbWAVgSKalUCRrBzWfmm3VN3uGF/mvoZE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:74d1:0:b0:de5:9ebb:bfc9 with SMTP id
 p200-20020a2574d1000000b00de59ebbbfc9mr716769ybc.9.1714570019532; Wed, 01 May
 2024 06:26:59 -0700 (PDT)
Date: Wed, 1 May 2024 06:26:58 -0700
In-Reply-To: <20240430235057.1351993-5-edliaw@google.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240430235057.1351993-1-edliaw@google.com> <20240430235057.1351993-5-edliaw@google.com>
Message-ID: <ZjJDIlQCkzIjP189@google.com>
Subject: Re: [PATCH v1 04/10] selftests/kvm: Define _GNU_SOURCE
From: Sean Christopherson <seanjc@google.com>
To: Edward Liaw <edliaw@google.com>
Cc: shuah@kernel.org, Mark Brown <broonie@kernel.org>, Jaroslav Kysela <perex@perex.cz>, 
	Takashi Iwai <tiwai@suse.com>, Jiri Kosina <jikos@kernel.org>, 
	Benjamin Tissoires <bentiss@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Bongsu Jeon <bongsu.jeon@samsung.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Alexandre Belloni <alexandre.belloni@bootlin.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Muhammad Usama Anjum <usama.anjum@collabora.com>, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, kernel-team@android.com, 
	linux-sound@vger.kernel.org, linux-input@vger.kernel.org, kvm@vger.kernel.org, 
	netdev@vger.kernel.org, linux-rtc@vger.kernel.org, linux-sgx@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Apr 30, 2024, Edward Liaw wrote:
> 809216233555 ("selftests/harness: remove use of LINE_MAX") introduced
> asprintf into kselftest_harness.h, which is a GNU extension and needs
> _GNU_SOURCE to either be defined prior to including headers or with the
> -D_GNU_SOURCE flag passed to the compiler.
> 
> Fixes: 809216233555 ("selftests/harness: remove use of LINE_MAX")
> Signed-off-by: Edward Liaw <edliaw@google.com>
> ---
>  tools/testing/selftests/kvm/x86_64/fix_hypercall_test.c | 2 ++
>  1 file changed, 2 insertions(+)

Regardless of where this series ends up going, this patch can be dropped as I
already have a fix applied for all KVM selftests[*].

Thanks!

[*] https://lore.kernel.org/all/20240423190308.2883084-1-seanjc@google.com
