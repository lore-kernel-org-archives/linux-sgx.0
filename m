Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A510728B510
	for <linux-sgx@vger.kernel.org>; Thu, 24 Apr 2025 17:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745515191; cv=none; b=J6RhjtCXnB9KBaA2IRLbbGHearn5kG9mEURBpBaopyrQwSI57ETSmtoB7yoRlZpi+DK9XQrwndh2w7duxs3SUj+DhmMoq11rALrFA1UrYwURqAqqpzDNhRr2aJK7EcjqpEC1TCFyye7+NOHsjJOj0f1k3QJMkrddlvwUtxbc64s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745515191; c=relaxed/simple;
	bh=JVBnOQ9xAjAhJk4tb6qYtQR9ClPu0ADEpQ8AVHwSdFA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=BoPouCn5y+pk/Y9s/h5/j/u2SUHIRG997vqlgVMpKGoeFrquWggOx/LI39gXvew2Bn+TTmblzo+OWAhXeuCMXyR7Czn/nuHM/xeOzQ4Paqf0DhYNV9AhPbCNF0KzD8drAywqltrJMbsWv1+epBHckRJp+jObhR81piSigG4G/4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Aefb8nBV; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Aefb8nBV"
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b16f5365310so117008a12.1
        for <linux-sgx@vger.kernel.org>; Thu, 24 Apr 2025 10:19:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745515189; x=1746119989; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=zS7mLx09ed02H6nWW+H10gzfXoHG9CX0nooepJ8lNJM=;
        b=Aefb8nBV+bSSsdkhke2zvufh+BxL2tRZ06B2a7n9wxUN3uUjrpJAN7PHeXWlOF1K+b
         YBVPp79l3CAnSEH0AAMUOUVJTqGzE+whKg5vS+KHKtktqiCxuYExVaINcFdc19R1t6kn
         tyQkDzVxO5RpVxZK43Lij1kwh5muEf4SVQ3Ocn5LJXvMUFgUgrnFbLJEzsPJu5gl6FIo
         sZLDu0Ccsmy9RpUg5sldBvbRgOdIo/Tzvd29SbY1gIHw+GbZfpmNTfjVYzLtCmHoMtzE
         yDuOzhb9qAoLFLOKdDNXMLUseQPV9lkzvjYkrmouByEGnJczG069Dr9TY4iqwTK5O81M
         1dag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745515189; x=1746119989;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zS7mLx09ed02H6nWW+H10gzfXoHG9CX0nooepJ8lNJM=;
        b=j9TBZj5iyTyWHiz+wk2C9Xuew2aRXhR2l2AfRJ1GBvFfYRgvCZICXg10iZKJ8t8XMg
         hMMMpekqexsG/2aLDGicjvDc5wbPyr1ZgHESlM7kiP6bt9QkKSwz4wjsU33BL8IUy2dZ
         TfI1aIzQzwHbPFaaFIGhv1FymiDud4hHV4KFYXZ9mod7zrtvQ6goywlKOS2oNjNHmYX8
         efVzfizgNewRzofG49bvXUFiPtkpUuwCXefXXs5JZqgG/asBtezPTO3f1gUS8DfDyE5C
         seXrhI0VWrDclURGk5Ae4jgU8GhuoCZWkTHXtOPk8G1z2QvpDU7vZtvd5jUvlt7Zfpyv
         KEog==
X-Forwarded-Encrypted: i=1; AJvYcCWIF9s/GEmTeRGt5gtSDES/VGHI3boAPr+ptpbxSalPX55gTs3bYJPf3TXAuaxC74cwUzXXmZSdS4k=@vger.kernel.org
X-Gm-Message-State: AOJu0YyUaw8+UbDKoztW5/nccgaJL3jd3jUgcoW3B4OoYvF2QSN76zFF
	F5zNNllrnPX3wIGH7LoG88O7fQyuwGSp7QzzZhilYFNLZvqEwgbEeGPqKQ8F3k5JVREBUO7b29A
	fdw==
X-Google-Smtp-Source: AGHT+IFqfzV489qEdKPM2O9o/56y2nwngmw5PlV3K25e1femb8zjlBkssXel189bbTlNQyL8vwxpsQ5rK6A=
X-Received: from pjh8.prod.google.com ([2002:a17:90b:3f88:b0:308:64ce:7274])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5830:b0:2ee:f677:aa14
 with SMTP id 98e67ed59e1d1-309f552ae9dmr680098a91.13.1745515188862; Thu, 24
 Apr 2025 10:19:48 -0700 (PDT)
Date: Thu, 24 Apr 2025 10:19:47 -0700
In-Reply-To: <DM8PR11MB5750D373790399E324B98A18E7852@DM8PR11MB5750.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250415115213.291449-1-elena.reshetova@intel.com>
 <20250415115213.291449-3-elena.reshetova@intel.com> <aAJn8tgubjT5t7DB@google.com>
 <f5cb3c37589791b2004a100ca3ea3deb9e1ae708.camel@intel.com>
 <aAefmNVRFc3me6QQ@google.com> <DM8PR11MB5750B37305B3B1FAE4F42D3AE7852@DM8PR11MB5750.namprd11.prod.outlook.com>
 <aAo_2MPGOkOciNuM@google.com> <DM8PR11MB5750D373790399E324B98A18E7852@DM8PR11MB5750.namprd11.prod.outlook.com>
Message-ID: <aApgOqHvsYNd-yht@google.com>
Subject: Re: [PATCH v3 2/2] x86/sgx: Implement EUPDATESVN and
 opportunistically call it during first EPC page alloc
From: Sean Christopherson <seanjc@google.com>
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: "jarkko@kernel.org" <jarkko@kernel.org>, Kai Huang <kai.huang@intel.com>, 
	Dave Hansen <dave.hansen@intel.com>, 
	"linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>, 
	Vincent R Scarlata <vincent.r.scarlata@intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	Vishal Annapurve <vannapurve@google.com>, Chong Cai <chongc@google.com>, 
	Asit K Mallick <asit.k.mallick@intel.com>, Erdem Aktas <erdemaktas@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "bondarn@google.com" <bondarn@google.com>, 
	"dionnaglaze@google.com" <dionnaglaze@google.com>, Scott Raynor <scott.raynor@intel.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Apr 24, 2025, Elena Reshetova wrote:
> > On Thu, Apr 24, 2025, Elena Reshetova wrote:
> > +void sgx_dec_usage_count(void)
> > +{
> > +	if (atomic_dec_return(&sgx_usage_count))
> > +		return;
> > +
> > +	guard(mutex)(&sgx_svn_lock);
> > +
> > +	if (atomic_read(&sgx_usage_count))
> > +		return;
> > +
> > +	sgx_update_svn();
> 
> Why do we want to try to execute this on release also?  I would think that
> doing this in sgx_inc_usage_count() is enough.

I assume an actual SVN update takes some amount of time?

If that's correct, then doing the work upon destroying the last enclave is desirable,
as it's less likely to introduce delay that negatively affects userspace.  Userspace
generally won't care about a 10us delay when destroying a process, but a 10us delay
to launch an enclave could be quite problematic, e.g. in the TDX use case where
enclaves may be launched on-demand in response to a guest attestation request.

If the update time is tiny, then I agree that hooking release would probably do
more harm than good.
