Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D69B207A3A
	for <linux-sgx@vger.kernel.org>; Mon, 29 Sep 2025 17:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759165974; cv=none; b=qy32JfdCuQOBPFw3qwBJ3rsUuZySZHXx/4YLqgBxmC4Do92eeWTEzgt6e3zpuzhql4Pd5UHJo4mrubNJ2GbDMi7O2R1pgQ1W3SypGIV1Ya3eqzqcnmROs0cgEasWQSLBIlf1NvOQ8dd+M6HuJF3lb7QIRfFwM57q6Trpw6CmMbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759165974; c=relaxed/simple;
	bh=RxzJ3V59Wq07N2UF1FootK0iy/AYJKV6am0zJXLq4y4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S5TWy/NuhhFGmzra5SACxLX7qu6CC3Y9QVBynFOiYowg4LccRAUTH5YoZM2MHdlw2o7BAiRUH8bycsncOhQHWG3kDe2AIqgVzaFNDWMstgXxE/C9DjY3tl8CiGwrZ1TK++YtsLvUxUZvfUZAq+fWDZFJmWdEhRAtvp7IUocngo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dtU1xdUl; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dtU1xdUl"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-46e3f213b59so4915e9.0
        for <linux-sgx@vger.kernel.org>; Mon, 29 Sep 2025 10:12:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759165970; x=1759770770; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RxzJ3V59Wq07N2UF1FootK0iy/AYJKV6am0zJXLq4y4=;
        b=dtU1xdUltyL7pGD4bKGs56FN4f4h4h3MnkFXdsGFEtZIO5PhL1mhMQneU9iDInO4+Q
         MnH82suSoIi8iYcau/70gLprx3FYLt9gYrIf8VK6ZmxnwaYk79DB/F2vl9iwLUfNXeMw
         OjjB5LpOEERmgNc/vOXzsVtWQkrO8r5dkkSdHnrCCg10x56TVOSiOgYivBbTNu+wXuD6
         kvzHCJeBbCXD9JphahS45cmOpcXAaTFspYRF7D6ivw5CzkfYGmvjA1jaNZFDZqIHDmKc
         4M3L18cnM0A2IsREKCtrUyRVXRQZN0KOXVXIUWa/rFwPuQnwqT6X0OVpPeLlXSbg6/fs
         f4rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759165970; x=1759770770;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RxzJ3V59Wq07N2UF1FootK0iy/AYJKV6am0zJXLq4y4=;
        b=BTgOwHA+ikcWsiVUa9SisVOtUCU8L4uYvzt+FgUD3EsTiwnNGDT8huhFrn1phbeMr+
         f2dpyO885DGYutRj+BBO9Zk0e8A2J/OgWrti9JQJP4Wtggc/nK7whJfrNIJdUYS+9Zwi
         18UGjdtl1CBcBZETpIVJi0zdBvT8menaxZX7gh6ZYZswRvMa9AjhlkTspYePREoeEZmm
         i3yJR6ruLcK+V5sObdsvGOYEHXaun1TKF996d9jQHoZ9z6qWA7dBINjd9vC1G+rVsBOY
         8JZTg2zPkOIIbO6MnDEV0M9Z/lA1A5txAVj0vcX3nA/gZWz5Sa5ovkfuvz8w14An6Dfm
         rxlQ==
X-Forwarded-Encrypted: i=1; AJvYcCVZ58KRi3uslfr892gKwGckO0cOis/7+KhfrKkv9OPF8fZxuq7/tU2w53cKikgmsruyxzT5njQsa54=@vger.kernel.org
X-Gm-Message-State: AOJu0YyFO+K5eQ/uTJTjef8OiJgL3FARsiOLjq2WWNOaeuPF4wF8h4pn
	F4oekRO6/lip/K68SM8kWJlPyclKJunq3Vfo6bUO/679WqZ1oqRKx+STZ1hML6OvURISIHOiPRc
	wYtoFv6GbxvguFGLw9aXm3PHEviJagZGPm8hHvZfZ
X-Gm-Gg: ASbGncujhZRKNqLvnOd3uLt/xtDPsqMZeRi/5trTM0WVZd01lTq+4ZxiGAH7yDnIZGl
	mGsaRvkIMFuNEZGb1aygjTd7mREoAcN0n3z5mnaz2N73nPTHoEGKuM16i2JBi/CA3yE2OdZ8jzq
	PicokUkbWBGpwVagsO+cWeXy4+MxSagDmOQVs2ror37Ca1sDSd5NOQzGHFV7fkmDPUSFO6VfXVE
	BK1cYthPmbT2B2lpYj5MkY8M0tI91stjIdYDBO+3HeqPuwWMTwCcUI=
X-Google-Smtp-Source: AGHT+IHuXk7tF9uyvP66Y90iG/J00lH10kBj+6dab2+LuAQqHLajcGPj7GtkYecbTtF2P7ExU+uwVoqwqJXRsCKEXnM=
X-Received: by 2002:a05:600c:b96:b0:45f:2db6:5202 with SMTP id
 5b1f17b1804b1-46e59d575abmr127225e9.3.1759165970340; Mon, 29 Sep 2025
 10:12:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250818071304.1717183-1-elena.reshetova@intel.com>
 <287a2652-bce6-4084-b9b5-c8feb24a2940@intel.com> <CAGtprH8rPg30gsrhJ9=44uaePqf-Ay=R+O_+D8isH8TzM4uQXQ@mail.gmail.com>
 <DM8PR11MB5750C11091D7D90B60FE7853E71BA@DM8PR11MB5750.namprd11.prod.outlook.com>
In-Reply-To: <DM8PR11MB5750C11091D7D90B60FE7853E71BA@DM8PR11MB5750.namprd11.prod.outlook.com>
From: Nataliia Bondarevska <bondarn@google.com>
Date: Mon, 29 Sep 2025 10:12:38 -0700
X-Gm-Features: AS18NWCPRPmMCeBb-Zmpa-uN-Xth9-St2ynSE-WMaV_w5mb5bSlDTu7VsGJHWDI
Message-ID: <CAFbLv2dbF4=vEvuqKFweRR5P6qtm+E7U29=f2ByM552j6fd9Vw@mail.gmail.com>
Subject: Re: [PATCH v15 0/5] Enable automatic SVN updates for SGX enclaves
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: "Annapurve, Vishal" <vannapurve@google.com>, "Hansen, Dave" <dave.hansen@intel.com>, 
	"jarkko@kernel.org" <jarkko@kernel.org>, "seanjc@google.com" <seanjc@google.com>, 
	"Huang, Kai" <kai.huang@intel.com>, "mingo@kernel.org" <mingo@kernel.org>, 
	"linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, 
	"Mallick, Asit K" <asit.k.mallick@intel.com>, 
	"Scarlata, Vincent R" <vincent.r.scarlata@intel.com>, "Cai, Chong" <chongc@google.com>, 
	"Aktas, Erdem" <erdemaktas@google.com>, "Raynor, Scott" <scott.raynor@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Tested-by: Nataliia Bondarevska <bondarn@google.com>

On Mon, Sep 29, 2025 at 12:18=E2=80=AFAM Reshetova, Elena
<elena.reshetova@intel.com> wrote:
>
>
> > On Fri, Sep 5, 2025 at 12:37=E2=80=AFPM Dave Hansen <dave.hansen@intel.=
com> wrote:
> > >
> > > On 8/18/25 00:11, Elena Reshetova wrote:
> > > > Testing
> > > > -------
> > > >
> > > > Tested on EMR machine using kernel 6.17.0_rc1 & sgx selftests.
> > > > Also tested on a Kaby Lake machine without EUPDATESVN support.
> > > > If Google folks in CC can test on their side, it would be greatly
> > > > appreciated.
> > >
> > > Yeah, lots of @google.com addresses on Cc, but there's a dearth of ta=
gs
> > > from those addresses.
> >
> > Apologies for the delay on this one, Elena. We will get back on this
> > early next week.
>
> Hi Vishal,
>
> Do you have an update on this?
>
> Best Regards,
> Elena.
