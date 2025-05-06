Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231D01388
	for <linux-sgx@vger.kernel.org>; Tue,  6 May 2025 20:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746563540; cv=none; b=E6XXUaFlJS2feKWjcGZWpYND8yjRJSOnDKHjjfAjBlTCQzP31S2qI7fvSx8owaoULHQQlGzC1hntSJ21aYXyjHYe4+WZA1uLl8zn8wGHgQlXmrTUzhD3/63oQ2khCFFCb8CehnocGEACaZZ0VstyczPcjuhpCJo9PIWBB5QUSWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746563540; c=relaxed/simple;
	bh=tUwZYD4lRH6VdaApuK/2dwXWp/zrHR11uMrefDN0O3Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eiqIMg/TlZhADGGRAWnOk+5duUuNqcRm9vfUGP4gWuVIucQw6bbKatwH4nnl8MKj2kKlE56RSFmn+mvPlUVe63mVKUF2uDZ7bn2ULN/Guevyd8NJc4AcUt1MSGp/Vu9sL12k5AQZilo+Zu+AhzSuvh6mO5o2xIUghQtAXP1IPxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SfBrWKc9; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SfBrWKc9"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-43cf3192d8bso2035e9.1
        for <linux-sgx@vger.kernel.org>; Tue, 06 May 2025 13:32:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1746563536; x=1747168336; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tUwZYD4lRH6VdaApuK/2dwXWp/zrHR11uMrefDN0O3Y=;
        b=SfBrWKc9iPmKY6XP1L8ogUg33N64Koqp5Py1cxrP6bOlBSz/ZADRxnBtC51elFdc0W
         0EX8si1V/sQtgawv8y36UxJTYSdMBJxqBqV7U0Jk+JpaFQs79iKU0fidSe/umS/dpSCd
         On3szway9QXpiRR5nri+T6ilYxpwfDlM3TbRPMtqRK6RL0tSPkFKA/+gMrsYQ0eT+IrI
         zf6Wgyd90BkaulD/ZQKEKnb06sS6VseyHOQh1M6iVC0r4m2MArlXLQeF/+jiqSgeOJTg
         8olsa8UT2L9qUyKiYJqF1IjnBtaAR8fkgR+4iTTYlVHCmYroRdhh24YQ9OTgeN/zfcA+
         2hfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746563536; x=1747168336;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tUwZYD4lRH6VdaApuK/2dwXWp/zrHR11uMrefDN0O3Y=;
        b=rD8tndZm2eA7N050nJEOl7pvvGt7kpqV6Rx04K5sQ8pe8nwGZcvF/RUpTQLo1M9syo
         SAVU3mNEwK/J4DjTzBukqbOiwBK66vCx8g430znYTaiHoxZCyKfcQJI1KfRtYq9EBGEL
         iZLLwcs7D8odCbWI6JKdEtLUEUxgxmsQVA35cS4EQKyWi/vBMOPALBKB8CinfTsQMCJF
         F8p/S7UoblyhVebtGZoFdw4mnixB/EfnZANHxwPd6HNFLwHnSp11kVhzV7tmSbGSxUNp
         bLAdgCuS674px3SGbKtj6foxal2muziJqDKRM2fMF2tLUKgfIMkot0pMFwc7KBIksSGv
         VpXg==
X-Forwarded-Encrypted: i=1; AJvYcCUcthx9cfcumIrbZsJQLxa9oB29BKr08rwbVTFTVQfl16k5Om7iMIGW2vrluO6TXGdkGeSHgKbnGSs=@vger.kernel.org
X-Gm-Message-State: AOJu0YycnTCpevZQdl6SBPNLHfCflyvTMsbqi5uaUBuXWLQ6rcjRqCfO
	z0UvjA6a5VlrFXQhW0KhYhJstmeAjeCXEXTaxFXiipP04nnGH8LZhuEwyx7Q96EuleFrzwuthp6
	cx8zEFlctv7/FhH6MWukkK1N2V/MJPTV+Rke0
X-Gm-Gg: ASbGncvRreDrHss/qQYlu3k/y4KnLMnWO9P1xWm90GAYtL3gOZr+6LP0qeYmOq6I/AJ
	Km+bCmiOEPHjrmdMDB812YeA85VvoyDacVIcHOWlKesZjPCA/LxB+gJAvqB0vjqxQMx7zGytqE8
	A8Py9r6YH6fJF7TyVQnVKa1pouQlVbrDId
X-Google-Smtp-Source: AGHT+IEViL4DDYdA9BRkFbLcDJrhDyd8AMVyi7Ajmkopmwi+B3g8ozJx81yXwm52KwpCCBwGQVYxLaUMmnJgtUMdspA=
X-Received: by 2002:a05:600c:5249:b0:43d:5b3a:18cc with SMTP id
 5b1f17b1804b1-441d446ece1mr211865e9.2.1746563536279; Tue, 06 May 2025
 13:32:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <0d7d6b9a-e7bd-4225-8f08-05bd9473a894@intel.com>
 <aAviqeAdGn-w1GpK@google.com> <fbd2acdb-35dc-4e8c-9bd9-e84264f88648@intel.com>
 <aAv445Sr71NUJP1X@google.com> <db1fd062-5a66-4942-82e2-c889dd645a7b@intel.com>
 <aAwFhaqQDLXoqbmv@google.com> <4b4ecaa1-2ace-43bf-b71b-0de78bcf113c@intel.com>
 <DM8PR11MB5750B39557F5062038D0E551E7802@DM8PR11MB5750.namprd11.prod.outlook.com>
 <8db47bc1-445b-49db-b932-96aff0eb58a9@intel.com> <DM8PR11MB5750200DFF8CF40E3539B688E7832@DM8PR11MB5750.namprd11.prod.outlook.com>
 <aBI-xQzatja2Y9dh@kernel.org> <DM8PR11MB575014811E4007EA00F5B3E6E78D2@DM8PR11MB5750.namprd11.prod.outlook.com>
 <d16ecae1c1b4b6f06565dfe9c47849dcaeb0782c.camel@kernel.org>
In-Reply-To: <d16ecae1c1b4b6f06565dfe9c47849dcaeb0782c.camel@kernel.org>
From: Nataliia Bondarevska <bondarn@google.com>
Date: Tue, 6 May 2025 13:32:03 -0700
X-Gm-Features: ATxdqUE61e7i1k-WDCodhkqZGzBoZRAAXfLn7Q4KHv08wJ97xsX3tgACyJjBU2g
Message-ID: <CAFbLv2cEgABB3jmL7_6_ZyA8-q+8u7C5f-fcoQf8acYytiB3mA@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] x86/sgx: Implement EUPDATESVN and
 opportunistically call it during first EPC page alloc
To: Jarkko Sakkinen <jarkko@kernel.org>
Cc: "Reshetova, Elena" <elena.reshetova@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>, 
	Sean Christopherson <seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>, 
	"linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>, 
	"Scarlata, Vincent R" <vincent.r.scarlata@intel.com>, "x86@kernel.org" <x86@kernel.org>, 
	"Annapurve, Vishal" <vannapurve@google.com>, "Cai, Chong" <chongc@google.com>, 
	"Mallick, Asit K" <asit.k.mallick@intel.com>, "Aktas, Erdem" <erdemaktas@google.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"dionnaglaze@google.com" <dionnaglaze@google.com>, "Raynor, Scott" <scott.raynor@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Tested-by: Nataliia Bondarevska <bondarn@google.com>




On Fri, May 2, 2025 at 1:56=E2=80=AFAM Jarkko Sakkinen <jarkko@kernel.org> =
wrote:
>
> On Fri, 2025-05-02 at 07:22 +0000, Reshetova, Elena wrote:
> >
> > >
> > > On Wed, Apr 30, 2025 at 06:53:32AM +0000, Reshetova, Elena wrote:
> > > > 2. Switch to Sean's approach to execute EUPDATESVN during the
> > > sgx_open().
> > > > Btw, Sean do you agree that we don't gain much doing it second
> > > > time during
> > > > release() given the microcode flow?
> > > > I would rather leave only one invocation of eupdatesvn during
> > > sgx_inc_usage_count().
> > > >
> > > > Proc: No new uABI. More predictable on svn change compared to
> > > > option 1.
> > >
> > > > Cons: Two explicit paths to hook: sgx_open() and sgx_vepc_open().
> > >
> > > Why this is a con?
> >
> > Well, just from the pov of not having a single path to enable.
> > Are you ok with option 2?
> >
>
> Yep, as SGX is anyway very much run-time managed feature and these
> hooks fit better on how it is used.
>
> > Best Regards,
> > Elena.
>
> BR, Jarkko
>
