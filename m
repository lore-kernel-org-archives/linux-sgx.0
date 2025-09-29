Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 395F422A4FE
	for <linux-sgx@vger.kernel.org>; Mon, 29 Sep 2025 20:33:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759178037; cv=none; b=rfLvqjpBUJIHF6C5VILSuG9J4FqfCoW+BtRoBYTz835fOKcFVUy6Pf2DMq/IugCP393dOj2pbxosF1sgc+nf4UCW+m7ucNqO1IHD+401PsGlWMgHNu4Ti/k7t7pYgVuMcdiEblCDp/m3IhplU/NSWObAibxvxLoOHjEOg1LzO2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759178037; c=relaxed/simple;
	bh=zooox9letODSfQhkabg91arQYc8at4FO6VhA79la9PI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PgoFdodRQ+VTwuszex+ep5xeqwvUzOLcrHKUGau4+/FJhrxVa2KJrttuvUwVATDSfpGyN1reqPbMN4koo7QnEMElEjlrA9j+8iQHioA5hUnUS8jempXim5hGejrkZY+8QaG1c1nluGagP68Tnhnz7wo0wHyNcxxH1imFoXU7lmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=J+BMWILZ; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="J+BMWILZ"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-46e2b7eee0dso4415e9.1
        for <linux-sgx@vger.kernel.org>; Mon, 29 Sep 2025 13:33:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759178034; x=1759782834; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zooox9letODSfQhkabg91arQYc8at4FO6VhA79la9PI=;
        b=J+BMWILZeq+cl/M2ogBYtS5qyyYwSWBLnMb6ARV2e0LndUqnz43vFLopt2+fECqZWa
         jrUaXOiVmybpG+8qejZ4CPlPLVDe19r2m6wbvQRoY8vC/OvLv5g23wyJJQ/5CZMMxnob
         LI5g2LCokDhKquDAZHWcqVT0WyPAKoDvkNmMBnPG0A02GxFcud9iQomgMw2rEQEUQfzf
         BjWxcHJzu6Uc6U2F58GnIC+dwx3lZcKRUad3Vhe0T0UFmc+HTZRHC3skW+38WvRBY8ru
         tvetvYz56a8rbgT3BoqtI5wLwWouyiTTOjcAK6NrtxqlFl8c0nhlTlqfjD8a7YWn6TZ/
         J8XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759178034; x=1759782834;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zooox9letODSfQhkabg91arQYc8at4FO6VhA79la9PI=;
        b=hqj3tdgUV8Yhk6Wi4fZHl/7jBC1Fcqf6CCd96OOe4qcnepKvFY4DooJPBBaX5p72fP
         j7fvTproDX2LFy7jIZzlaHzLEInj4XProvxn1ucUcsKUYO5a4xTDSMPoDCdBTWV1+Cyc
         WxezphDY2GwJnG20UBQKa0IHE46ap6kqRT4P/oUsSU1g4KFUSHVWlCplhWzvn8oGnY3e
         6vU6rpHAKzxGwCFPo+tqtpFu3L7nW2oHcPWGdduuoFIiR/onbsGL8qR5G16z9RPNFYq8
         V1j1hobUOrtXE9CUDZyEECoTbHPG3zAgaUXW4LT4EP2+mNKNbiedVkgEglVXSozGpbe0
         hdsg==
X-Forwarded-Encrypted: i=1; AJvYcCXJM5266RERKbf4k98WeIZkycBNAG9DiFC33QHLA1NR5VhU3Z9jDvASTmLlxGB9fp8XjYrSy4kr6aw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxQ0n40aiN0sQlu5sjIFApsTKxEw3p3E5edo/2CBj204TaKBL0Z
	3i2FJ0YQcRbCIWxbMf+JBFY+4dlF5rD/7xbpsTMiMsFM3d1vDYAMsr/60bjxsx7q2A2vmS5p5Lw
	WZySqjoX7Kgp7FpJ7Kd7zwk8PPRgm6oY/LL6SJljn
X-Gm-Gg: ASbGnctdHjK+QcBb1QTZjT/JDARyDPhxGw/H+fCa9AB0MMxIp+g+2uu7QcZkC9DeRv6
	Ftrngu18nWkrEwT7fpEJL026u42Hq70aDAa/P4h9IBXqU1ue+WNzGCI7cZxAuBXj4Pjv3jXD7/T
	AIwFQB92IKSqIsoJ3zGwF1NDIZhJwoJurMmloW/Klv/00ESHmSumZw82Z0NWSPEPnoOvPyDBWBP
	nGtgzYVMqCBce1/LFiUGk18XQ+TwSx8igu/0nJVUmzPQU9EpYtXxFc=
X-Google-Smtp-Source: AGHT+IGJUkOfSqWVDmFZmnG50Vkevh099QmVVU2lqSkkAhKs8Kt0LbWZK60A0sTVrvtkh+1zZJRW7uId3xoPtHHPkS8=
X-Received: by 2002:a05:600c:5599:b0:46e:1b09:1cda with SMTP id
 5b1f17b1804b1-46e5ab1140dmr114385e9.5.1759178034297; Mon, 29 Sep 2025
 13:33:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250818071304.1717183-1-elena.reshetova@intel.com>
 <287a2652-bce6-4084-b9b5-c8feb24a2940@intel.com> <CAGtprH8rPg30gsrhJ9=44uaePqf-Ay=R+O_+D8isH8TzM4uQXQ@mail.gmail.com>
 <DM8PR11MB5750C11091D7D90B60FE7853E71BA@DM8PR11MB5750.namprd11.prod.outlook.com>
 <CAFbLv2dbF4=vEvuqKFweRR5P6qtm+E7U29=f2ByM552j6fd9Vw@mail.gmail.com> <266dd7f9-89b3-4297-a179-9fe57345abb7@intel.com>
In-Reply-To: <266dd7f9-89b3-4297-a179-9fe57345abb7@intel.com>
From: Nataliia Bondarevska <bondarn@google.com>
Date: Mon, 29 Sep 2025 13:33:41 -0700
X-Gm-Features: AS18NWD3JoxsS6rdDIDIHJnxn1QxhAdsjzhFS7E7McIEzE5CohGNlP80llYkVHk
Message-ID: <CAFbLv2fPwV6u8HX=zKntVLwKeBsbEu62J49uC0kL237HDRiUfQ@mail.gmail.com>
Subject: Re: [PATCH v15 0/5] Enable automatic SVN updates for SGX enclaves
To: Dave Hansen <dave.hansen@intel.com>
Cc: "Reshetova, Elena" <elena.reshetova@intel.com>, "Annapurve, Vishal" <vannapurve@google.com>, 
	"jarkko@kernel.org" <jarkko@kernel.org>, "seanjc@google.com" <seanjc@google.com>, 
	"Huang, Kai" <kai.huang@intel.com>, "mingo@kernel.org" <mingo@kernel.org>, 
	"linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, 
	"Mallick, Asit K" <asit.k.mallick@intel.com>, 
	"Scarlata, Vincent R" <vincent.r.scarlata@intel.com>, "Cai, Chong" <chongc@google.com>, 
	"Aktas, Erdem" <erdemaktas@google.com>, "Raynor, Scott" <scott.raynor@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 29, 2025 at 10:35=E2=80=AFAM Dave Hansen <dave.hansen@intel.com=
> wrote:
>
> On 9/29/25 10:12, Nataliia Bondarevska wrote:
> > Tested-by: Nataliia Bondarevska <bondarn@google.com>
>
> First, thanks for testing this.
>
> But I'd really, really appreciate if these tags (top posted and without
> any context trimmed no less) came with at _least_ a few words about what
> was tested. All I've got now is tag from an email address I've never
> seen before which is (apparently) only used for sending Tested-by: tags
> for this feature and nothing else.
>
> Also, by "a dearth of tags", I really did mean *all* the tags:
> Tested-by, Reviewed-by, Acked-by.
>
> Could someone please spend a few minutes to explain what this tag means?

My apologies; I've clarified the details of the testing below.

The verification was performed on a SPR machine. The objective was to
confirm the successful, runtime update of the CPUSVN using a targeted
microcode package.
Steps Taken:
 - identified a microcode package version, designed to update CPUSVN
number on the machine;
 - initiated a dynamic load of the package during OS runtime;
 - confirmed the CPUSVN was upgraded post-load.
