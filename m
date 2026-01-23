Received: from mail-dl1-f65.google.com (mail-dl1-f65.google.com [74.125.82.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B06E2777E0
	for <linux-sgx@vger.kernel.org>; Fri, 23 Jan 2026 06:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769149411; cv=pass; b=rddM+e+SJ0cmi+6gjTsp4eAMZKBJuA2N7sn5R0Zp/AyswkrMDYaeFAMmEvdAESF3EXua6kUJRjI1LuqF9no+3GaE0t7Msw5P17zIZ0HIrtfsU6OB0v140huoo2ECkiufns2yLmlf5YtGi8Ykbp6+RmjizkmFpLL568HneLHoerw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769149411; c=relaxed/simple;
	bh=zhxgaciYhXpYZclEyoj76XiDHlN7ymumRTT0uPccOBQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UUNvzIQ3OiqckpktNtBfCwXU4hhB5Vc0Ac5T2+jIoAHlLtTd0hwzQyrvcoPsxln33foNo3udcRB5WiibomFwHfpxDdQK/vJNHh7NShP8UExzq3CfhVnV2Hggc8IwHlieFZkSS2ZEMpxTDzBkBlsneUR1NY6o5ichMlZIAmQxQrc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LGndG7mE; arc=pass smtp.client-ip=74.125.82.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LGndG7mE"
Received: by mail-dl1-f65.google.com with SMTP id a92af1059eb24-12460a7caa2so2645773c88.1
        for <linux-sgx@vger.kernel.org>; Thu, 22 Jan 2026 22:23:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769149404; cv=none;
        d=google.com; s=arc-20240605;
        b=DxLZX7FuJol0F0RMr8iTeCT2CNBBMOKKrYqxe7iBG5RMmQ9Y451j3StnHuy/tWBCtj
         xAZSa+prtlY3wiaoAnKb+x6ke73AvVJFXmxSlu9+MF2qyFiznfekDjdBFAt2RSDE0SAW
         NppyFMImwT0fSMAF/OIsygjCGHikBOfMAvnR5i+0UWo2XhX8SGb7NTENQXvZSuIbhQ3T
         GodoqaLSSVQqzhc6lzycAj1eSbAsdDu4JO5em2dNylnWU831pQ/rkO4e5o/WLD+dnqxJ
         HbwoITuFU9zAzDiUY6LgagooMItBvv0PBwG4HPubNqHbxludfa3Yo4i4fAEOGyTVRk9T
         fS5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=zhxgaciYhXpYZclEyoj76XiDHlN7ymumRTT0uPccOBQ=;
        fh=uGZb/9E+ypTWYjJcj5ZzBkLFz+OEDROZpxwYJVQqyCc=;
        b=X90P1uMb7rqrgHIpTJXgxoN4WcckhWfQ5/hK6NIVP8AveRCyFW2yMrqR9fBdYojcwv
         bWmORqcPfCcFHPbOrR4jox2pHChqR92NO2i2nclqd0rq5Fb29WMEs4jofdzdIAN5C4Zu
         ZzLlTjuImJnRnRvGuGZZaHdjkwjwGQJLpk+kYj3t1R+MWw8tmc9bFwxItzA0y1osPzKm
         RBWUM8zwJ0hxWIZ/E9k7jX8b5ZMO+yAKPldJwvBCG8JKzJTyVlKtPVsflVH1akCYV+bV
         +t31MJTKVtspD5qdJv5TMXGx08y4B7V7kcQz6IgWwvTaC+KSEawcx7IXk2z7GyOLw528
         D9Kg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769149404; x=1769754204; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zhxgaciYhXpYZclEyoj76XiDHlN7ymumRTT0uPccOBQ=;
        b=LGndG7mEL3m4gzJ7DUwLEiB1dRp5z7oLfDWfWKvX/nPQBvUFWBKgK8fGontC0xXe9J
         4gQ94pDFYa+4I0RozA5q3qGFj4N/xUw9paLM2ZSFvioSSM5D/q0cayCZDLBkikfrW6Vw
         ddfnCW3YOOLHaptYsMFhpe/AZtOTZjToMDf1vP+veWuKDflReJ+TCkmjWw35+2IAssD0
         fYI9Z0ijTJhVe4r9mS18ro/PSBCkwF6OFgEUyszMuUJ4Bob2ZjSKP/GHSnQREi2Ukv5I
         eQ2ezzzut1StOqU4FJQhkKoxMn8qusYFTTwKv9PiiTkwT8JnybvWlnKym+1D+6ksZKDQ
         PLZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769149404; x=1769754204;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zhxgaciYhXpYZclEyoj76XiDHlN7ymumRTT0uPccOBQ=;
        b=I+yYBMbMRnBqdOk3Eaf0/PvMjAgAnU4b01lGdTpc2ahvavd/8j5csP/vN4+Ip/7NQZ
         9/fKoEeinDkjhIRTWYvDJvPEgrxXqPT9rg2y6uaXxyNCzVAW4hOpQpsQ5RmKXk2agIQW
         Q77yENZKmoGpiR2wF7x0igVpJknUpop1jJLbZz+BJVtYJMIG+m0WCqVcJjjTBN+PkQ9G
         oweWkU/syJ9smTn6BXgXyLlGprjWVhdZwAb3fSXEGiR6Tzh7u4OrlwsYAVZSXIZJFLji
         +GOEF85jIpgchxpcqxVrCHH7oT945Uwhellai537lDwUlr2YPfSxiIqaFJJNcqy4Q8HQ
         FSdQ==
X-Forwarded-Encrypted: i=1; AJvYcCW8kJqBYKsm/fZH0w7g6mgOkRwGQK39LKmctCJsmodqOAXX7oQ+/ZIpHZWfgpotyBsoFID/9/iCXHY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwYmT36dam46yvgieY4zTcD3wjN+6qVP9oTBzhcv2cMaSnpAcwB
	Gfu4TPiR7yL18AQq4WJShbg8WGPbBJF/EPSHdev+cc7siPIor64K4S1qYkGnZZppvYlGO9fN5YY
	/1mZb/bLmIBIflfWO1b5H346SNsKyZrE=
X-Gm-Gg: AZuq6aLj4Cwpd3qQf2wmojyio8GXRFpBGZ+jeOtdqLp/kyCP7UiQ96qbn/TE3kiOskr
	YBuvLBQ2eUXqHPwOZVf7hzGx6lB6Fub05rpKJOvX06fqApGiAt3V4G+Xk0/rw98J6sSjChNOfMB
	mimQPJqH//iVBEwZdL1rdVGtuk+cpdaJfCpAFnYgLrecCiLQlqBiKG4gK8X5ywG6ul5WEuFnx3L
	tRi4LJeJ5hjnJrgOuZjM2j7QcBzn10sCPmWs1v+Cv+PW2qm4rWxX3mjoam4HT7stj6H/U7w7AaC
	D5/nqmeT
X-Received: by 2002:a05:7301:4e0b:b0:2a4:3593:c7c5 with SMTP id
 5a478bee46e88-2b73995a3abmr797133eec.5.1769149404505; Thu, 22 Jan 2026
 22:23:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260122133633.79792-1-tianwentong2000@gmail.com> <5961c2655b49a7d384140c33d6897e53f89cb5fe.camel@intel.com>
In-Reply-To: <5961c2655b49a7d384140c33d6897e53f89cb5fe.camel@intel.com>
From: TwT pupupu <tianwentong2000@gmail.com>
Date: Fri, 23 Jan 2026 14:23:13 +0800
X-Gm-Features: AZwV_QgqsSas1GY0YO7VHpwDp1Q8NmEsEQKa1FNvxIJomShoSzfv2IK9DYrJyu0
Message-ID: <CAGPELS7JdxTY5hthmTyU_yDxdG7xR2k0hoA1ZqV_Lj+8LEkO2w@mail.gmail.com>
Subject: Re: [PATCH v2] x86/sgx: use vm_flags_t for vm_prot_bits
To: "Huang, Kai" <kai.huang@intel.com>
Cc: "jarkko@kernel.org" <jarkko@kernel.org>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, 
	"linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"mingo@redhat.com" <mingo@redhat.com>, "tglx@kernel.org" <tglx@kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "bp@alien8.de" <bp@alien8.de>, 
	"x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Sorry about that, I'll make sure to reply to the list.
On Thu, Jan 23, 2026 at 4:57 AM Huang, Kai <kai.huang@intel.com> wrote:
> Hmm I was actually just pointing out, but not suggesting, since I am not
> sure (honestly).
Sorry for the misunderstanding.
> With vm_flags_t I think "theoretically" it could stop being integer type
> someday. But I guess the advantage is when someone does that that can
> trigger build error here (so that we can be aware) which perhaps isn't a
> bad thing?
You're right, the build error would be a useful early warning if
vm_flags_t ever becomes incompatible. I'm fine either way, let me know
if you'd prefer keeping
unsigned long and I'll send a v3.
