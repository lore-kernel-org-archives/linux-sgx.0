Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E4FC25A349
	for <linux-sgx@vger.kernel.org>; Wed,  9 Apr 2025 17:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744219044; cv=none; b=teD7rbGxTTWVs5T0INodsZu01qt06Zr85kl5LXGylwyIFgqpkCEe6AZsSTHSTs9jMqvEpGHPRna5ihbBcre9QFGZmeL11tqIKrj/hO6NjkmRonx4nQik7TT5FWUvQ8ExCh7SZVd3W3VS8QdDZ83uvI1bxi7nTgnsLFDB+i+RJv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744219044; c=relaxed/simple;
	bh=pWkUYx8Z7d+7TbYa6z0EEqFa/z5ytSu6rcNh90+Adeo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=r1oBlpzpNaEERdK561Wl2/TGzswP8ULXj7sctKc7sjwO12aFg3rLfWeG9TX43M5ppYiCtaBk5AXOdS4G0BEMs7svJeJlxYFNpcbs39HvCTuJmx4rf3tMTCiwIt4HEmXcFFVQDGtjN5O8zU17sp/7sLO1F6ZXbYPKjPwjhgm0ueY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=V8aYPQes; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V8aYPQes"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744219042;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pWkUYx8Z7d+7TbYa6z0EEqFa/z5ytSu6rcNh90+Adeo=;
	b=V8aYPQesjZVroyWbdw6FUR8sQJcgW/XojK5pUS4O9LwXddO5NdcGcdf2RyULs7N74FrFBH
	m2uAuHFVs5fiMCfxs/rg5frLIIFW2Q/mz9bX95OkG3qn3Crg4KhXgh0+3Ad6d8jaN5mFJj
	Bzoh9WV2JHN9y/XZxFgZcVXINcpiivY=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-526-TXgu_dvdNWyNHc8CbNDRgg-1; Wed, 09 Apr 2025 13:17:21 -0400
X-MC-Unique: TXgu_dvdNWyNHc8CbNDRgg-1
X-Mimecast-MFC-AGG-ID: TXgu_dvdNWyNHc8CbNDRgg_1744219040
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-549b1b371fdso2970469e87.0
        for <linux-sgx@vger.kernel.org>; Wed, 09 Apr 2025 10:17:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744219039; x=1744823839;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pWkUYx8Z7d+7TbYa6z0EEqFa/z5ytSu6rcNh90+Adeo=;
        b=npzYlpyGP9qa9FBa4D48YHEqWi59WlkSQlNLYG6k16GuZYpueqS1KmPePMWcmyToFM
         eGp1ZUi4EN7nmM8b8y2d+lk9hf+LgtdpkKJdc+fIB76mU3wwaGOvndcqLH/wRPjutNzT
         Evpiy1rBLfy9/FqsL/SYEba5JeDfuh6JWJ9W2f3USp0SakMW9eE5ndcitpnVdXCZrWNh
         oExdPvBKSA/4eV5HYMaECxgvdjJ2F/2Z7EsfNM6t8TDhNdjXhvpJSD+MNhuoDGqmgTqK
         sOWOOCScBlDFEyH0tuWkpce0PWj/YYxh+0VT5LRQjteN5ZUGsz0fvKYOBgUScJXHZBib
         NwRQ==
X-Gm-Message-State: AOJu0YxmfHfa3R1DJZyIFjiulp7+IIT2bKVx38qNMsKscQzNmxwpi6dd
	+CBaGU/siZYqFALtUwBl97IyzB38XthEG22H5KRWZEeAAC4w22F/qVqCH2vaTEsKfwwK+BaCyL2
	8JrOgDshpLKTtv7nb/xzthi9NN9qb8cjUL6ys9FgGIGQFxiSYKnZ6NCI/47VJ8tY2cLBG4xMaVx
	fVvnZUUsmyvwwUZ5+VkF+G7bmiuTshpfQUrQ1EaVlNuqY=
X-Gm-Gg: ASbGncv/edOKrsvP80NVqcyY8RJGpD4PmtpYCGn+KDUb/E5G4V3Wxx+u4DmG+Sgresf
	5gs4PfOuzQilpYNC6ZLddN/89Zn73H8bieOOerTVtfm88Xi5rBbxHyuVdFUr159eR8aSLHg==
X-Received: by 2002:a05:6512:12c3:b0:549:8fb5:f0ca with SMTP id 2adb3069b0e04-54c43704490mr1164462e87.2.1744219039267;
        Wed, 09 Apr 2025 10:17:19 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF2Wo66N3+O53fWWkX9HJh7ijQ9WgsK77lEWNRBj4Og7eVn/S5CEJrJ/K9qYVOyzEZssKlNhqDXx7uyE7nsGWc=
X-Received: by 2002:a05:6512:12c3:b0:549:8fb5:f0ca with SMTP id
 2adb3069b0e04-54c43704490mr1164455e87.2.1744219038953; Wed, 09 Apr 2025
 10:17:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250409165510.23066-1-vdronov@redhat.com> <2172b969-1e0b-4fbb-8242-27518e9f6951@intel.com>
In-Reply-To: <2172b969-1e0b-4fbb-8242-27518e9f6951@intel.com>
From: Vladis Dronov <vdronov@redhat.com>
Date: Wed, 9 Apr 2025 19:17:07 +0200
X-Gm-Features: ATxdqUEvHkwpK_2uGrq1S0cFZrksvMW6yIhqBWZFrI-YD4l1tQoblAZr4YQJGs4
Message-ID: <CAMusb+Q4O4A9Ay7Sdz5LEe0g1fw_w6j2xgC9HOBYhhOk8i0XWQ@mail.gmail.com>
Subject: Re: [PATCH] selftests/sgx: Fix an enclave built with extended instructions
To: Dave Hansen <dave.hansen@intel.com>
Cc: linux-sgx@vger.kernel.org, Jarkko Sakkinen <jarkko@kernel.org>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Wdq6wpgeD9Ikmt_pIMIlIKhuogKj31TFLFSBEI6bZqs_1744219040
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 9, 2025 at 7:07=E2=80=AFPM Dave Hansen <dave.hansen@intel.com> =
wrote:
>
> On 4/9/25 09:55, Vladis Dronov wrote:
> ...
> > Fix this by adding "-mno-avx" to ENCL_CFLAGS in Makefile. Add some comm=
ents
> > about this to code locations where enclave's xfrm field is set.
> >
> > Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
> > Signed-off-by: Vladis Dronov <vdronov@redhat.com>
>
> First of all, this looks fine to me:
>
> Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
>
> The code comments are fine. I'm much less picky about selftests.
>
> I'm also open to other solutions here. We could, for instance, set
> xfrm=3D7 to allow AVX2 instructions (which are generated by
> "--with-arch_64=3Dx86-64-v3") or use some compiler flags other than
> "-mno-avx".
>
> But "-mno-avx" does seem good to me.
>

Thank you for the ACK, Dave.

I've tested an enclave with xfrm=3D7 and it errors out at the AVX512
instruction (namely, vmovdqa64) in the same way. So if there is a
compiler built with "--with-arch_64=3Dx86-64-v4" in some future, we
would get into the exact same situation.

So I believe a solution when we disable extended instruction sets
in an enclave as one covering all future cases.

