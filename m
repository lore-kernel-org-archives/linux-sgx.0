Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 894582FD684
	for <linux-sgx@vger.kernel.org>; Thu, 13 Nov 2025 15:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763046574; cv=none; b=dHdcUDpazmDjHi6rO7t9oDHz0XQ0mKyncA9CB0FiBlSz9Ap+TAEShlqTbrMqJ2tauwk181AIzenjJDiBgvTrteI+Jl9fvXTekaLRSd0aavs1kgPzQq166FxwK4O2YSZFtoSEpAyXCO4LWvWh4P7EXxrkzZVYe7rrSMiky5v4jWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763046574; c=relaxed/simple;
	bh=h6UlhZ4Ba7cJzydqwOO0750ALHLQFMT8ZapUHDdYcxU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DhEMGrWWgKW+b6m/nBUarfuplfKo6w3uBNF+OiZJAvHJtLjgIsQ88N8W0L1YxEKx6L4nuyJ2OcT9R+Sw+oXBkC234gzkT4XtICtq3rk49QEJcDBrDiZg+cXLMckDOxG/suSPLmZWs+8SWWtsu/9iZ82R05Z0VwriecT3wR3gyo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YX2x49H0; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YX2x49H0"
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-7aac981b333so842398b3a.2
        for <linux-sgx@vger.kernel.org>; Thu, 13 Nov 2025 07:09:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763046572; x=1763651372; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Osoqj+KfH9e9c7HCxCwaBxJ5YlsbXGetX83a8Y9Q07I=;
        b=YX2x49H0DPrnV67Wo26zr2ojc3glG79zlz9zw4iPfuW8S5tx7KXV9Q8wQH1Rjk6WcD
         KgkZ47K02voRDAHbRAeKQ7K52+lH7l6Ap8iddE8JBunxkvR3TTUKGEYKmmCTMUlpWzDB
         o5EdvdjAfm86HaZ2BViipe7APJhDnJOZYlqfa04U5RXOieqp0GL3HUtDPrYfOg+LH+e2
         RdqaPnkbJMRdJItPFuZsVjeqdl5z0pFj93TxQE0Pg+Qf8L7V4GyYH0SzWC0f2fjrMAcH
         VY8ZwT+UxABl+o5B0FmNBj/hRYkp79BFlagrXSq8UM9T9a7KyLtBajZqgqrdSeLBdsJX
         WpTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763046572; x=1763651372;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Osoqj+KfH9e9c7HCxCwaBxJ5YlsbXGetX83a8Y9Q07I=;
        b=a+K8R2fH+9Vu8hP1OM99GmI8ypbC3/Wx4EoC6/45dP3rGBgueK+VmHcEs2Ge/BlECW
         u4ls3aoyLlj59+HuLisf1QXXkxMotrt4odGLHaEPxbGEPsuHrKXUGYSJtHYyqu1p9Ext
         ccK3Zhy49vtQO+dnXAkRPve7dRpB4gtJZMszKSejSXQXCanp+Cp3Izxs1g4LVExPCA59
         YQBVEJFShyXB56ECJ1I+73BIBR7YsZJ+e3OAfyoXj6V+kHARTW/FuE+rMbI5eLshZzuW
         FvjXh1d6xT2GtI5FVSPeiQCQ7f6JsJO6fZ9U7wTTGlYY9VNhjeSlScF5SMDjsrSxUWLH
         IVkw==
X-Forwarded-Encrypted: i=1; AJvYcCVx1hRFURsactwFYMOyS1gFCA5OCbBsakYTJ1oMGTU2fp337yO9AfMrGW2FT9iiu+Sb6XKqeZ6bo0A=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy04LbPUYVBRo4CS1XEF4S+DGHqHLaFQX7VIDOxF5TKYHKPUR6b
	SFhYtSWKYwZz839Q+PhdEaoZZq2MeNJ5l3cQSA4TfP20DTU/hRIrtr9jbciza8yMkPixAqyEFxf
	FnYECKQ==
X-Google-Smtp-Source: AGHT+IEuoZ5TTwctwMh+n68VMy6MVwQhHq00IHTFircxz33TSH4UlAXeNZUVuLlkrF78tTLU5wAyIUNjY3k=
X-Received: from pjpy13.prod.google.com ([2002:a17:90a:a40d:b0:33b:51fe:1a73])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4a83:b0:340:c179:3666
 with SMTP id 98e67ed59e1d1-343dddd8c7cmr8237657a91.8.1763046571703; Thu, 13
 Nov 2025 07:09:31 -0800 (PST)
Date: Thu, 13 Nov 2025 07:09:30 -0800
In-Reply-To: <9adc3a5437cf7d9af99642a0df837bbd0237bb58.camel@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251112160708.1343355-1-seanjc@google.com> <20251112160708.1343355-3-seanjc@google.com>
 <9adc3a5437cf7d9af99642a0df837bbd0237bb58.camel@intel.com>
Message-ID: <aRX0iB7gYS_GgGOV@google.com>
Subject: Re: [PATCH 2/5] x86/sgx: Add kernel-doc descriptions for params
 passed to vDSO user handler
From: Sean Christopherson <seanjc@google.com>
To: Kai Huang <kai.huang@intel.com>
Cc: "tglx@linutronix.de" <tglx@linutronix.de>, "x86@kernel.org" <x86@kernel.org>, 
	"mingo@redhat.com" <mingo@redhat.com>, "jarkko@kernel.org" <jarkko@kernel.org>, "bp@alien8.de" <bp@alien8.de>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, 
	"linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>, "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 13, 2025, Kai Huang wrote:
> On Wed, 2025-11-12 at 08:07 -0800, Sean Christopherson wrote:
> > Add kernel-doc markup for the register parameters passed by the vDSO blob
> > to the user handler to suppress build warnings, e.g.
> > 
> >   WARNING: arch/x86/include/uapi/asm/sgx.h:157 function parameter 'r8' not
> >            described in 'sgx_enclave_user_handler_t'
> > 
> > Call out that except for RSP, the registers are undefined on asynchronous
> > exits as far as the vDSO ABI is concerned.  E.g. the vDSO's exception
> > handler clobbers RDX, RDI, and RSI, and the kernel doesn't guarantee that
> > R8 or R9 will be zero (the synthetic value loaded by the CPU).
> 
> Perhaps a nit:
> 
> I am not that familiar with this part, but AFAICT the kernel always sets
> RDI/RSI/RDX to exception vector/error code/addr before invoking the user
> handler, after the vDSO's exception handler clobbers them.
> 
> Since you are adding description to them, should we somehow call this out in
> the comment, if I didn't miss anything?

I don't think we want to commit to that as ABI for the vDSO interface, which is
why I documented the values as being "undefined".  Maybe were already stuck with
that ABI, e.g. if some funky userspace is looking at the register params instead
of its run structure, but IMO we should at least discourage relying on the values.

E.g. if the kernel ever changed its exception fixup to use different registers,
then RDI/RSI/RDX might not hold the same values.  In hindsight, we probably should
have scrambled those registers after propagating the exception information to the
run structure.
