Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 051DD4C85;
	Wed, 12 Feb 2025 00:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739320364; cv=none; b=QvIZVRya8P9P5CFFaI455FYYns8OtKj+BMObFAfPcCuwxBlIQgOFPKGp/afCa6OOcLrsc1sKAMugChVT7kPRqlh3bjVmfNDywer+BTbgXBAic22v4u8uHXkQYMkDvtFiWyAWcf6PGyI20UUQ4obsuHc93wJE14UVJqhmHvjiI9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739320364; c=relaxed/simple;
	bh=INafOtvVgfU2/5jLKb7M47xE8R4ByKk4w6RaRrzaREA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V+VvX1ccesKkzcXjPvQhbkgjnh3c0PYEkPXaVbgfMk8hNnO/R1M76dO5pGx5qFcl2JeyNmywsgWTPQrq7yAeYwxwUMFuZ7J3TIAqNCvovwj6a5UKH512qDscOA0cEuwPPMSx2gmmTQ3uBaSrzYtQZy7q0pTYNK6ICF41pi1Igws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QKhSunag; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QKhSunag"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-30761be8fa8so61204091fa.2;
        Tue, 11 Feb 2025 16:32:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739320361; x=1739925161; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3cbaSxx3fTJQYhiPm6GuM469KznJGiwY2dCuPZpQUo8=;
        b=QKhSunagxxtIexGurp3yvKX9xFfOMWRubVezeMorRnl9Esbmr1e1CslGYzB+32vi6Z
         eHyij7f2uTjPX4qz0rsSVAAW2qfQQcZnTXzUKkpBdoNRxvt2hAQ2vEvQund6uqZKqbPc
         yS39IWf6NERzpJZdqnLeBK7cFECDx48wQuE1WhN2ughXew6sV7vYrEi/zm/8KrcIK+1p
         +9Z6ViKcwdGeh8izMfkHG4ccT8cQdNtktQ/TKdPeBZmiBtCqjS3z3gKv9fP3D/1Cvmx+
         M0Umfkh+tYz/0y8p7jboSzaclEWlICpAjfI5z0LnbRHH15/rf4wsHqLtmqWHkFDbdAh5
         t9eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739320361; x=1739925161;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3cbaSxx3fTJQYhiPm6GuM469KznJGiwY2dCuPZpQUo8=;
        b=J2OjpAXul5qyn/kkwrNttidlsUkS1u9/Gdt2K0hd8UMKKTEAOx9DSfO30PI42b7Zuc
         P1Gx834pZTDCp3+puzR7D0z+GKkqCaW0qm4Mu3hjrDQ2ca27j/gmYkDENU8rK6PnahRC
         7W5OqJE8HFZGFHlHaRcDeYgQaOgd24w7J4xHrhk8kUP5SydYSHbdJC9eaHIE0ZhlXeKT
         uFyAa3RRWdBNgh7n1OwcA+Bt8H5+mhz9+Lx9uAywdTK8+tWlViFL61ACr+qOX/ijGCRI
         zCs+6cZup9RFDWKyeXR4W8bS46fWb+HRYLP9bDPOimymgIAKOVYVdUFeIhpqH610KxyN
         /MDg==
X-Forwarded-Encrypted: i=1; AJvYcCUpVygocPvt3jdKVde/3waQtWHecl/7fgAHKTXGHufrBGMwAD7gmahsjlU/DAlqYirv30pRTMEXw8W2Bak=@vger.kernel.org, AJvYcCWIbbIU++CreMp0DoAqPA28H95CIoskV7/AC6dSWdMtNjUPwkSJEDaQv4wtnYPTKwOmfnA1SO10lLwC@vger.kernel.org
X-Gm-Message-State: AOJu0YzGoft7Wc/OXcyMeY6LuTwF5O3M84ZtD737H5sUEfWdGN8OkIVx
	/OU8oUd+n2awk1aTNojS8cP3r7MjIe24AxczvjqgtaLgErHuGwgy+HgbGYRsbX2JVFXNT3nfm+O
	3hw6bZ+IRGkLvIbdJVsfbuSF9GGw=
X-Gm-Gg: ASbGncvSb/pqNiw325GsS8wOI3tI2/32Ppt9HsthS+bNaK9tNC4kX9DfMD2RS5aGtiL
	HVCD4NEZNwBOCpjHBbMrvyXPKhp6TROjDSfN25O/QyKyK8kX6wZGxrd8JJh+ge7x07nGXZ4Yg
X-Google-Smtp-Source: AGHT+IGVR2V2jPvchKiXoslE8teeZA9AjF23iqCKnXxMoD6fhw/AA3TZrbmKqAo5g79sTCWEcLvG6npZ6faHZL5y2jo=
X-Received: by 2002:a2e:a9a2:0:b0:308:f455:1f8f with SMTP id
 38308e7fff4ca-30903669af1mr5116121fa.16.1739320360745; Tue, 11 Feb 2025
 16:32:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250211150150.519006-1-andrew.zaborowski@intel.com>
 <3bd497be-54d7-43b8-a392-4bf82bf64679@intel.com> <Z6u7PEQKb-L8X4e6@kernel.org>
 <4a1c8b84-d8ee-414a-bd6d-a8633302dab4@intel.com> <7ed9b288-69a2-446c-9f7f-50ef6bc56673@intel.com>
In-Reply-To: <7ed9b288-69a2-446c-9f7f-50ef6bc56673@intel.com>
From: andrzej zaborowski <balrogg@gmail.com>
Date: Wed, 12 Feb 2025 01:32:29 +0100
X-Gm-Features: AWEUYZmPbWshnFq7daFRsrpbr8Hy3jIpylTiYW0FCkofA88nu19ikWal8z3gyoA
Message-ID: <CAOq732KGpve688KWFCh1zdrme3vm7GxEiw6UjHswk5h6B3cNDg@mail.gmail.com>
Subject: Re: [PATCH] x86: sgx: Don't track poisoned pages for reclaiming
To: Dave Hansen <dave.hansen@intel.com>
Cc: "Huang, Kai" <kai.huang@intel.com>, Jarkko Sakkinen <jarkko@kernel.org>, x86@kernel.org, 
	linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dave Hansen <dave.hansen@linux.intel.com>, Tony Luck <tony.luck@intel.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>, 
	"H . Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 12 Feb 2025 at 00:31, Dave Hansen <dave.hansen@intel.com> wrote:
> On 2/11/25 13:18, Huang, Kai wrote:
> >>> This requires low-level SGX implementation knowledge to fully
> >>> understand. Both what "ETRACK, EBLOCK and EWB" are in the first place=
,
> >>> how they are involved in reclaim and also why EREMOVE doesn't lead to
> >>> the same fate.
> >>
> >> Does it? [I'll dig up Intel SDM to check this]
> >>
> > I just did. =F0=9F=99=82
> >
> > It seems EREMOVE only reads and updates the EPCM entry for the target
> > EPC page but won't actually access that EPC page.
>
> Actually, now that I think about it even more, why would ETRACK or
> EBLOCK access the page itself? They seem superficially like they'd be
> metadata-only too.

I haven't seen a crash in either of these (always in EWB), I didn't
want to imply that.  But starting that sequence seems wrong knowing we
cannot reclaim the page.

Best regards
