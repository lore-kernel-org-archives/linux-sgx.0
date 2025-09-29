Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7665A23506F
	for <linux-sgx@vger.kernel.org>; Mon, 29 Sep 2025 21:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759183137; cv=none; b=bdK36n15j/zIPM/dxBbx4n75Y1nKjVpTVVfC51Y6HUavByVKFRgI7TsZ2W8hOq7xWcyLFxZbiwuikd4zUlEMg0ux6wDvP9JK3lYyXhm+DadQPV5ruxH6A0kotddalz+pYi3N4HPNie0pE82soMwqGs5VPpeQpdwZAaOYQjDzWZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759183137; c=relaxed/simple;
	bh=q4FK/NSG9nQ8r/bpfA1CBLPqHIAI4E4vJzmK5B7ksTo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mDt5tQOSkgvek2QDatbWGLXFMSUkrQx5LXObIp5tCGK43bAOf7uLHyYWIwrldH7/tZwGmk7BAN7fHm1GPtf9a4FxNGOpWNMw8hKPgW8Hq3mPoBBBMcLM7Pt7Xzp6EVxgOCkpQJM4PlTcNFcZT+EuABA4ECcR5h1yafIbVqFMGZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jhfSN1xh; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jhfSN1xh"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-46e3f213b59so24595e9.0
        for <linux-sgx@vger.kernel.org>; Mon, 29 Sep 2025 14:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759183134; x=1759787934; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pdeq67xeIPmtmxBxDhYojMol52xhKKS2cbY0wrzvOac=;
        b=jhfSN1xhRiRbqRqRZgYLE8D7zzvf8KKuSn0ZN3kFq9nQDk0R5t6zdd4NisK6prOVaT
         Qy1U+1R1VBpO9UzzUYr+xJYmeUIESpxVHDNA91v8Hm4dcYvU7MEaExoasiN6S4DclL/Q
         7V7F2l9bBEarhf/EmES75xWSz+xRsrihxGtduEKqo1PMlctI9BxJsxhTSOBveOkx0hZn
         Y2a2A9Tfe6IVMhyJSYtsYpTeQ756b0xwpEFiQWDUhEK04JJ+lI2jvpAe/9QXyWheUsuM
         /RDpkZfmOO8TSOs7i/5y6DBKCLcWmgh7POx6tfVFmkKHh5p14Ybcb45Z0xRuV29Jx4ez
         p7bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759183134; x=1759787934;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pdeq67xeIPmtmxBxDhYojMol52xhKKS2cbY0wrzvOac=;
        b=tHFDhU4SPHcuIcjPbVKQe8BtZsKU5QcHur6zLilGFmYsQYCBs1A1OqJHYeqT0hhGre
         Jwo/cKXHJjvd4pPpybWhcL6P5BAy6Y0rX22q41ick07YGzdRkkuN7x7BTvYqKw18Lji6
         maGWzmKrRotMrLnDmaOI5n7ihbSDGxvnxlaNqBQtXrKym+0F0a+svWebFrjOndeB/iMM
         NPb6IZpwNh8FY9mBAG0OJfHT2rcLKPvh485t3A7cmPY/ONgb/If14mKiyLzHJq6MPsf+
         uG0nrLoxSa2aIbGfVESDIOohF1+cSqFQXY3/aC9NU9/3Iv+G+fpkIoVzZkrsmlek7Kg9
         5rtQ==
X-Forwarded-Encrypted: i=1; AJvYcCWyV0ALgfmRCgEJsDPB5UrLcJPNlBVmim8apkuknRHsIDqC+/iHGNs4FKHhngQUKJiklLPfJG0S0z4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxqWmgd2QeMhIRjMrK1mKyru9qfXVVjeXplQKtDKPFUhxwN/Jq3
	ZQJN4VGqvsbY2NqCBhQ6Bx4v+P2OkMUhTGtHWPazjBhk7p79HJJ3g6dPSEjQOFOdYBZexP6AMSd
	+mzAG7hQL8pGjGQSrNFUclydIaUR7+iFhfbiu/u/Q
X-Gm-Gg: ASbGncsn9fSpcjdNrIC9eofNNy/arucpK3JDnsmibz1cWXJMQhuhl5cE4yPWHCFr7SW
	SBGwUuy9qa8Rg6HBQHZ8CuJ1KHyzpgEiucCNBmNbsQ5igaeyAC16Fpoor0XsSh+1FtnznTKK/9M
	D8/MrQcxy+fYRrYXyp3GZo8ljI2CHPwtqawlp9PhwgIHL7S5Le2APE80oglCFkkz11niWkvB++v
	5LOFKvu8qFcHQ5ff7+7jUIunq+QcDtnfTQN4ZjqoF3WHIX7Qv4OYmM=
X-Google-Smtp-Source: AGHT+IFXcwzbjwILzCqwDQQB0F+JEcQeyuh0yJiu68lbqwviX44Us3z4jaFKkzhm1YHo6jcbvxvwcJCyWwoQVLfRAco=
X-Received: by 2002:a05:600c:c051:b0:45f:2db6:5202 with SMTP id
 5b1f17b1804b1-46e5ab15c8fmr215205e9.3.1759183133595; Mon, 29 Sep 2025
 14:58:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250818071304.1717183-1-elena.reshetova@intel.com>
 <287a2652-bce6-4084-b9b5-c8feb24a2940@intel.com> <CAGtprH8rPg30gsrhJ9=44uaePqf-Ay=R+O_+D8isH8TzM4uQXQ@mail.gmail.com>
 <DM8PR11MB5750C11091D7D90B60FE7853E71BA@DM8PR11MB5750.namprd11.prod.outlook.com>
 <CAFbLv2dbF4=vEvuqKFweRR5P6qtm+E7U29=f2ByM552j6fd9Vw@mail.gmail.com>
 <266dd7f9-89b3-4297-a179-9fe57345abb7@intel.com> <CAFbLv2fPwV6u8HX=zKntVLwKeBsbEu62J49uC0kL237HDRiUfQ@mail.gmail.com>
 <1881634c-7a19-4570-b7de-54ce50e76675@intel.com>
In-Reply-To: <1881634c-7a19-4570-b7de-54ce50e76675@intel.com>
From: Nataliia Bondarevska <bondarn@google.com>
Date: Mon, 29 Sep 2025 14:58:41 -0700
X-Gm-Features: AS18NWDvcpXpR1o_PsbPt2yxJqMY7S_U0YL_A6ck6-LOV6zPnOiOYmDMoEhhGGg
Message-ID: <CAFbLv2dmUdqm-VZBi+cSEhpXUpJ=ZsnCn9k=Qfk9sZAtY82gbg@mail.gmail.com>
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

On Mon, Sep 29, 2025 at 1:50=E2=80=AFPM Dave Hansen <dave.hansen@intel.com>=
 wrote:
>
> On 9/29/25 13:33, Nataliia Bondarevska wrote:
> >> Could someone please spend a few minutes to explain what this tag mean=
s?
> > My apologies; I've clarified the details of the testing below.
> >
> > The verification was performed on a SPR machine. The objective was to
> > confirm the successful, runtime update of the CPUSVN using a targeted
> > microcode package.
> > Steps Taken:
> >  - identified a microcode package version, designed to update CPUSVN
> >    number on the machine;
> >  - initiated a dynamic load of the package during OS runtime;
> >  - confirmed the CPUSVN was upgraded post-load.
>
> OK, so you're basically saying it managed to update the SVN on real
> hardware. You also had to go run an enclave or at least open /dev/sgx,
> right?
>

To confirm the CPUSVN update, I did run an enclave to retrieve the
attestation report and compare cpusvn values generated before and
after microcode load + the custom logs I incorporated into the
sgx_update_svn execution helped me to confirm the expected logic.

> Also, does this tag mean, "I tested this in my company's environment and
> this ABI is sufficient for us until the end of time?" Because there was
> also some feedback on earlier work that this series as-is was going to
> be insufficient.

The test was performed on a SPR machine using the kernel version
deployed across Google's TDX production fleet.
Yes, this ABI is sufficient enough for us.
