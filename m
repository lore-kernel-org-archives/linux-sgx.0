Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D2302F94A5;
	Tue, 17 Jun 2025 16:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177265; cv=none; b=LZ81R0ATxgL8P1rYNreVRHgFB0AFrfiqHACUVG5vJ0h8ApHagXpMys360y31PIa6c8f5i7eVMeIoKRnqFvoITEoiZ9fbCS56kXE3SkgWvQyZKYhiP6yn97wadAP6emRzvps5uW5Pwd12aznQD/1dCJFhmyL/+0rtMiHOMu3aoFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177265; c=relaxed/simple;
	bh=+0EiuodKDjQRXvKmnKZvg2BPcSQjv+ftIpd/mBBfX5Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lnn7lAGpk2Qo4mswvMoWfuQzk3Vo8otIknhpJcl8wgmJBvAJN8QGJ+SMjJCQTZiJsjtlV8l+YiCVh8hj/Cbvkm/p1b58L75FNE1CntJ5s3ZV15cqTdP8fE/QTeVOthZCVk7UTuhL/q6EXiEbx1/HtvKDWHjK1XylwZqszdr32D8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KZ9QONYY; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KZ9QONYY"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-54e98f73850so5632762e87.1;
        Tue, 17 Jun 2025 09:21:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750177262; x=1750782062; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+0EiuodKDjQRXvKmnKZvg2BPcSQjv+ftIpd/mBBfX5Y=;
        b=KZ9QONYYqo3XWngH09LTo8CzLHphXlOOxpydfoZ3ldJpy6WQyzy1X5hyqOb1abgUZM
         76xsrMFKUu1dh6ZoIr9dWB+XCpDzPHmqWlkAwAqK6C8x6/Cq4r3yudYNX+aa7cTwW+d2
         3lmWOm+Iq+mHhK+WscbZIRpaNaZi8rUeIu75j0KrNvfOKt8yDTs+dhV8yruMrp4tOl1V
         vkzfTYQGoACGUNbc+Gq2YBD2+RnjjfDDLt0mVDBXNzbPnbcwd/Q3g3U+OQ0KxHAHH2QG
         Ob3zUHIRt8e9G5JDwADwhtukesk/VVzn+DCz/MnT9/+4h3KzhlUZkW8QgnS1zAOiKjk7
         0ihw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750177262; x=1750782062;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+0EiuodKDjQRXvKmnKZvg2BPcSQjv+ftIpd/mBBfX5Y=;
        b=QhmbLAz/sPEncr3HuYIxKEGzvIkKWdDbOmr3z8jokQO/sMdOU3JLYHPUWqyV6EM2lv
         SmATPIGSAcRNAad5Lg62lETYmsbxDpfgZhezSx0c+Q4P1M2XpzkDeDGHUyItW6J7FdJA
         ztN5OBRRRRwOPIDhgLMhayh9/rOoD/UjJCyac9aSpMt77Szni2gZjMDeQyHDfF0MYLpc
         x8Pje9i9e+q+Q7Oz4QenJoXf9Wi2o1MzosRvB7iOGLZEjhuYXxgg592mXoWwGQKWVhZT
         gNEoLk71cKjW5ywCNfJO9cIf2gb74Yu/brmnVCpd79M3QbnzuGcg3s4GXALR0k47u5X6
         jwRQ==
X-Forwarded-Encrypted: i=1; AJvYcCWN87DixxNUiRzDa1qkTOQl+HuCsbNr0m0dhs2SHRY1vfPtZW/X7Vhy6Xr/jqsARLCXHWFL/sMqmDR322A=@vger.kernel.org, AJvYcCXdAwYqrA0OHi+d/WLRgC7xaXcIN2K8z52+hhvRyPHbszOJUzGJRV1qdcqE7AHS3T/AcOBG3zFgvoxX@vger.kernel.org
X-Gm-Message-State: AOJu0YwYkC86htlrpJ7NEVrGWorhtgAQ6I/NvK5FhGL3vbYMO2Ik7jNM
	a+WUjrLHLlpIBnOm3BEUAb99R3p+kizSpKzzLTsZUmvKRDXHCfpI6EmCjE/LiacE5IL410dqZXP
	tEGEkOnCFYLo4/9seDF11vqvyZseMiRcAJkZ4
X-Gm-Gg: ASbGncvfnUcaviMm61hQJvJoQjf+BgxAnl6XBVTrcqbY7f9K4MEmw+XE/wN/xkvJtBH
	Ft0zIji3YN0s4o0fKRHaEy8sujsKJE/TWrRM99kl6S+jnDnkl/jYzjVfY/7tfQiZ84IYh3DbvBI
	8N2J+/K15aAJOWx9Q06br+dSPRTbzEiN0J2lDenT+4288=
X-Google-Smtp-Source: AGHT+IG7kHn9wUASuEcAGOhvKtnrgjD7mWSbEvFbsJd8/yns37+K9r/fTfUXYJJ/xsadGrc4iYFuZmtHhigig7Rgln8=
X-Received: by 2002:a05:6512:e9d:b0:553:35ad:2f2d with SMTP id
 2adb3069b0e04-553b6ea582amr3508106e87.18.1750177261784; Tue, 17 Jun 2025
 09:21:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250616085716.158942-1-ubizjak@gmail.com> <aFF_UwJ2XlFQSZOi@kernel.org>
 <26b8939e-796a-4581-a41c-42e3582326bd@intel.com>
In-Reply-To: <26b8939e-796a-4581-a41c-42e3582326bd@intel.com>
From: Uros Bizjak <ubizjak@gmail.com>
Date: Tue, 17 Jun 2025 18:20:49 +0200
X-Gm-Features: AX0GCFsaTkmgLY1QIqNbjCnp1LLkhTXDjUbXGOfS6PB_sPpWoSZ6_PXBBrayjys
Message-ID: <CAFULd4YzC1xe0mVmJhWAk=sxhsctpZUxQGyRKccW-VF7OhkjKg@mail.gmail.com>
Subject: Re: [PATCH] x86/sgx: Use ENCLS mnemonic in <kernel/cpu/sgx/encls.h>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>, linux-sgx@vger.kernel.org, x86@kernel.org, 
	linux-kernel@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>, 
	"H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 17, 2025 at 5:01=E2=80=AFPM Dave Hansen <dave.hansen@intel.com>=
 wrote:
>
> On 6/17/25 07:44, Jarkko Sakkinen wrote:
> > I don't really see how this is that useful. That said, f a bug fix or
> > feature used encls mnemonic, I'd had no problems with acking it.
>
> It's not _that_ useful.
>
> But old assemblers that we still want to use *NEVER* have support for
> newfanlged instructions, so we always add new instructions with ".byte".
> Then, a few years down the road when we've moved to just old assemblers
> instead of super old assemblers, we move to the real instruction names.

That, and the code becomes self-documenting. You don't have to scratch
your head what the .byte stream represents when reading assembly.

Uros.
