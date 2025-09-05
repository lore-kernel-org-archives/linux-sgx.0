Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F572E55A
	for <linux-sgx@vger.kernel.org>; Fri,  5 Sep 2025 21:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757107098; cv=none; b=OTa6pwBFg9C2BWVBJLyr+Azhqf6YQ1sEbt9D/VUzsFQoXGllc3dU15qpDx+vB35P7obTu0caVpDhZVsVbSubJiXuLyh0ZsE98P6kb86Ruml7rf87WByfJXKio9M0i7ti7qf9C29rX7lgIh+NIggUNEWTxhfOci/kg4QgvN0xyr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757107098; c=relaxed/simple;
	bh=V/qpY5woUvgQHrdaj3qqGLb87THxgyLrGvJPAhxQ/nk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Jr5bohOMGT9nMB9N0Tb/iGntVDExUIs/HoJCGDVsDjEacwdhe8dWP87WfJKoGB692OMV6+7eVmnZBZAvf3TgCtduTALkQTftW1L8M1ctQmzqDWYjRR+BhWX7oBfiXvVET6nMKofg9/UqRKTbzrISxhHzEpRFKRhv/xOjEflQNPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0UE8du2e; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0UE8du2e"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-24b2d018f92so25625ad.1
        for <linux-sgx@vger.kernel.org>; Fri, 05 Sep 2025 14:18:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757107097; x=1757711897; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V/qpY5woUvgQHrdaj3qqGLb87THxgyLrGvJPAhxQ/nk=;
        b=0UE8du2eQMB2JLuaZUUDbOCEppHLocy6wviB5wi/dgzau0tXcCb+8x4xpqj0QH7tfH
         Il+Df1w8QYjI43ishUMKLNdiVr34qnnTciCJn8Kl10npxFlgc/It7Sy8sOmVqRlAd7Og
         lvqWRBltGtwoQX6lJoGB74vGr4iLOQPaY1EX2MCoXva7W/9I6Drrm4canztfb2mRmhf6
         1B/J9uoskScNZ2ThWwlTHTA3VmhSa/beiZ1FHsEPd5+Q6Wg6YLFdh0XoLA/iHfoHA6uF
         zHeSnPubuc/YZyCQUF+jrXfoMFlj48qDDZXhcukZVCktA8xw+jIyryREFW7iWJCGNjuf
         4/tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757107097; x=1757711897;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V/qpY5woUvgQHrdaj3qqGLb87THxgyLrGvJPAhxQ/nk=;
        b=nL1hSeSq5t58GlWhOXqbekVA3vtBWQLCx+9ItdtLoNJOVyiFfWB01fHB5ugXnOvAJn
         +zKW3mzgerlttta9+MJQHByH+vC0yNLQC014zyIfQnPXe5l7cS+R3yd/ysDE8jnHwkWp
         ohyFlB4mdAjAl27ZjKVXfc05BYJX2m4ajObSgAvidp8pEZ89LgL1Y4TI5HdktOBqVqnr
         LilyK7zAbZ8rjGaW5PDUQTMZg+ifuIYteOvqFX+J3opT6ZR4p/74Av7FSf/k/3Y7AQE4
         DkEszh+xYv2kEqRpkph5DIXQfbvvrSEcYtfAI0yoAJMWYFc1OY6y+v+h8fZxoZ8eqK1h
         0qHQ==
X-Forwarded-Encrypted: i=1; AJvYcCWFwGONdc1Cx4DGYKxppEAjmKVOwgvekjrlYlOyWJDEmcYlpwxOtN03PdKKLHkYTdL0Zj/iXOXfhf0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9KXNbrdPGMOTBko4Tazv12ZW5e56hCTofbJL7ALpOhGcMrW8t
	yhDwcxqxD62OVQjN1wd2cL4ywAF5hsuDHUrUGwaTQK2lwk8I7eX5HIW00b39yQ+qwLHjWF87wKS
	aNDXX79Wuzo/aCI08x+OXKnEjxSF+5d6iXMyzjfTR
X-Gm-Gg: ASbGncvY0t4ydZcBVqZtyTq7LpTd9OQLp4nUx/LbSJt5hXKAY/rRm+oCX7zwxVxy9h5
	rgxGRRSoUsdYPsF7tlqqgrAfWbT54u3oRjPjMSo3uFdN9feRerQgNeplhiCaHSjao52zANsskEG
	oUmMpjRrN09ii34VUb4UNs2I4nd2/tWB2DZa4ZCygngnUmpvGC4kPI5Z5PrMAc+YRk3yLyVDEEt
	MQhTML1E7Ru6jPstH8qAIkRDdjQP2NIn/6AlGpIXA+GLr85KIODy1spkg==
X-Google-Smtp-Source: AGHT+IFcLpRsdpcaR2Zbamq8gP687RXFQRE4U1ntmAJRlT1y+cLD7TO7+OK6VdTfQ8je95KqqncHaDR1YcpaNnM6xxo=
X-Received: by 2002:a17:903:186:b0:24c:863a:4ccc with SMTP id
 d9443c01a7336-25114efbaaamr929595ad.4.1757107096329; Fri, 05 Sep 2025
 14:18:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250818071304.1717183-1-elena.reshetova@intel.com> <287a2652-bce6-4084-b9b5-c8feb24a2940@intel.com>
In-Reply-To: <287a2652-bce6-4084-b9b5-c8feb24a2940@intel.com>
From: Vishal Annapurve <vannapurve@google.com>
Date: Fri, 5 Sep 2025 14:18:02 -0700
X-Gm-Features: Ac12FXwylkx_TogxWguH-xMuqhZXQbHUyMu-O4qezVTEb5xVX9w6CcUkZbgeMHE
Message-ID: <CAGtprH8rPg30gsrhJ9=44uaePqf-Ay=R+O_+D8isH8TzM4uQXQ@mail.gmail.com>
Subject: Re: [PATCH v15 0/5] Enable automatic SVN updates for SGX enclaves
To: Dave Hansen <dave.hansen@intel.com>
Cc: Elena Reshetova <elena.reshetova@intel.com>, jarkko@kernel.org, seanjc@google.com, 
	kai.huang@intel.com, mingo@kernel.org, linux-sgx@vger.kernel.org, 
	linux-kernel@vger.kernel.org, x86@kernel.org, asit.k.mallick@intel.com, 
	vincent.r.scarlata@intel.com, chongc@google.com, erdemaktas@google.com, 
	bondarn@google.com, scott.raynor@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 5, 2025 at 12:37=E2=80=AFPM Dave Hansen <dave.hansen@intel.com>=
 wrote:
>
> On 8/18/25 00:11, Elena Reshetova wrote:
> > Testing
> > -------
> >
> > Tested on EMR machine using kernel 6.17.0_rc1 & sgx selftests.
> > Also tested on a Kaby Lake machine without EUPDATESVN support.
> > If Google folks in CC can test on their side, it would be greatly
> > appreciated.
>
> Yeah, lots of @google.com addresses on Cc, but there's a dearth of tags
> from those addresses.

Apologies for the delay on this one, Elena. We will get back on this
early next week.
