Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B5462E1C63
	for <linux-sgx@vger.kernel.org>; Thu, 13 Nov 2025 22:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763073728; cv=none; b=Ufm66qXVpiRvgdVbCzh10G703k1K/jRuGZA69EBRwP9MavufPQOemmHOIzdkZpadiUcHAGk8ahWm46fcWdvBHsatSN8if9wyNpETgIsnOfCo24rsHWNybe+x2Toakj3ufIwY+o1yZG6zEC7FUaez0Q1TcJ89AnXuE8zuvdtr7Ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763073728; c=relaxed/simple;
	bh=yC20q6O7bjBSvyd0NckYXzSL+AsZaSz6zrxXWEAGX54=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hrfDIdqZbXfR1mMxmjQt+2kyfD0Z5g2I6/NiEQE8IDy0jEwhkZNMBee9ntNhlnVKI8omb/gTF/BGnNUm/OD+TY2sBt7BfQ/ZtWVZ1Q1bQxQ/x4RNHzkRSr5t0cZlmHbYFmyXo7Rch4TfeCCjeAC5Z10+hHy3AgYjFim3ZKGg08w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H2r6MRhr; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H2r6MRhr"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-594476f218fso1049917e87.1
        for <linux-sgx@vger.kernel.org>; Thu, 13 Nov 2025 14:42:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763073722; x=1763678522; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iORugXgswwslqtIFyyyu+POzNmV64LtVZTcIC4QKuug=;
        b=H2r6MRhrfYlvST9JoGFwzqqemd0E5RomUgN3LQ+1Ftqs5edX9v06Iq23LDDRKRAFqK
         TU6Ats9xRPi1nAs7xlAT18O88NhgjNYET0D5agY9ZFEFh+B0u7aAraVH5xDT+UU1SBsL
         mtSgNUcryWA6K7EwU490ZyNOAZW0XqRejAvbNr+/siIkEiqevfhUkyfrYBYGUo6N4+py
         Mc+gUpwfZPed+V6ySsZBm636QTPlZGDaOPwFKR3Hy5EYJthi/KpM99Fo/8SUIq6EeFPr
         YoMj4++WvpfViYn++RzNDx3LCSP5kh43s4vypV7CDNYtvgUm4KN6GNUXFz76kNFK+KNY
         +lZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763073722; x=1763678522;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iORugXgswwslqtIFyyyu+POzNmV64LtVZTcIC4QKuug=;
        b=w/7QREJvpc+83+SJKmbPUST9lJWGxKD/UzlDsHfUHefWdXPv3i7Nou9OM0GsdKDTCL
         YKIi4qH31N3Y1WCJTir4L4+vTs+EVpXyY7tilPsGSMcagPoPtj035m2F02NgFDTg6XwD
         EVb1QrakfWsH/8twYjRrocHHau0Bopo9ub6yCrnTUWsAxUeObt7eLkAcgRkJLq0sb+fx
         NBl3CakAS8RV2lkRNUXtabgSCEs8uAgTGCxQnDfKtILodoBWck+tGMq5A/vr9OjLqqRh
         FOZ9PFEksksuc7f9IAB70R+b3Ke6P+z03Cym4krp/B9aBZP2AQ1rreM/NuH7cJHuXHYW
         0fwQ==
X-Forwarded-Encrypted: i=1; AJvYcCU7RhQ4nR2cKxW6gdNWXa2joCU1qIi2JGcBdOASNU39UkpWTAaZwGPvgDwNCsFtbnUNYdxayXBmp3E=@vger.kernel.org
X-Gm-Message-State: AOJu0YyBaHDfes5URMaHzPIKTyKQIll0nvQkMJ5rpPTaHcjOvFrrg/aj
	EbtIMGpvSRbp1Nj7dMRD9tzXh0pbg9x0HHwaBcNQ0foLI9kIiWWhJeethlc6THm25Hkip8idshR
	UrHEHzA3QemZyz+8wtrN/9WXCxD7Bsg==
X-Gm-Gg: ASbGnctu1oFDPvKSxEIZfLQRtMavRhHHE390RmTv1d/aVWEhtiEvoEw5QlY2kKTHxim
	mXWaAjJgzGFm6oSZWaeZKKPQ59lBiyshJhXdFYogf35Fo471aGGv1zHgiTJK6sq3QYhnuZE9tjN
	FK6+mOaCEd0VuUbXLQMdj6AwpYrpSi+UBQukjgsZRiu8Sc6Kkmfoz+XBSTXxTp7/ezt0AsI28oz
	Y/wdknEpiiKyNLBakkUhN4y1Y7WvMPKoJKWffWjxGWzPnJ3rHmV5IWXnZYtYFzUCmgzZcEwb992
	CkeROChqqg==
X-Google-Smtp-Source: AGHT+IFCToYdqZbl71EqpS0eC8le9ob/knb9SdPrT08DySzFeHSRTMktnUkZr5EKTLoqo4bD7c+slGVSwPhPlJCTrzI=
X-Received: by 2002:a05:6512:4028:b0:594:3340:1b77 with SMTP id
 2adb3069b0e04-5958419572emr314261e87.1.1763073722004; Thu, 13 Nov 2025
 14:42:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251112202258.1310754-1-hpa@zytor.com> <20251112202258.1310754-3-hpa@zytor.com>
 <CAMzpN2iwrzKzhif7WXsoQi=4OdBENZMV14Hm2a5ePukywNgh1w@mail.gmail.com> <1cd27f96-9f29-4607-90d8-c98593eacfbb@zytor.com>
In-Reply-To: <1cd27f96-9f29-4607-90d8-c98593eacfbb@zytor.com>
From: Brian Gerst <brgerst@gmail.com>
Date: Thu, 13 Nov 2025 17:41:50 -0500
X-Gm-Features: AWmQ_blr3u4Fuh8i0XUra4JykNFO4ZmM9cHhbLUDXWn1GELeMIldMfvLmrHMFh0
Message-ID: <CAMzpN2gC1NWFu5XG49cCrktTUZbDBbng71RjpALMxzSOmPrQPg@mail.gmail.com>
Subject: Re: [PATCH v3 2/9] x86/entry/vdso: refactor the vdso build
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, "Theodore Ts'o" <tytso@mit.edu>, 
	=?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>, 
	Xin Li <xin@zytor.com>, Andrew Cooper <andrew.cooper3@citrix.com>, 
	Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ardb@kernel.org>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, 
	James Morse <james.morse@arm.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Kees Cook <kees@kernel.org>, Nam Cao <namcao@linutronix.de>, 
	Oleg Nesterov <oleg@redhat.com>, Perry Yuan <perry.yuan@amd.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Thomas Huth <thuth@redhat.com>, Uros Bizjak <ubizjak@gmail.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-sgx@vger.kernel.org, 
	x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 13, 2025 at 4:12=E2=80=AFPM H. Peter Anvin <hpa@zytor.com> wrot=
e:
>
> On 2025-11-13 10:38, Brian Gerst wrote:
> >
> > Some of these changes (like moving vdso2c) can be split out into
> > smaller patches.
> >
>
> Sure, but is it worth the extra work?
>
>         -hpa
>

The vdso2c move would be a clean patch on its own.  The rest would
probably need too many intermediate steps to be worth the effort, but
it does make it harder to compare the new and old code.  Not a
dealbreaker though.
