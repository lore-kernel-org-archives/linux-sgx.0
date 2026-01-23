Received: from mail-dy1-f196.google.com (mail-dy1-f196.google.com [74.125.82.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B85A2FD1B1
	for <linux-sgx@vger.kernel.org>; Fri, 23 Jan 2026 06:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.196
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769148971; cv=pass; b=a0vQR13egfI4vpzxcfX/7XsG9yZiOYP7MfhIONfMdwtUxLH8dWmExBNRUtTzmFDX3UwfnqC0WhsKwWRPsOQ2aOAdNce4fdPOIUjCxu9yDzHuDMlJ3ESaUrcVT7JZFm2QOY/LGy11xSn5CqiCkRT43qp7nQ/4vVj0QrNFJ3VMd3g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769148971; c=relaxed/simple;
	bh=f24jpAGxUc+FDhGBnCqyLFjLv2kQfPn72xdfy9qQ+t4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uZ0D0+IoOqJERt42DuSAb4eQBlzQs9Z62QTJkDtSKeMrOlYlusWe5mNcQfLzw3HzgPWEKve7w991+hqAfiN6n/g5yUkQPR1vwMZ+5stQ3VjCmat4MMGE8pluxcaW9N4eyRXN5uBDRKFHxU6sq+P7rHmmWUk6RwiRTmjMn9yJzCs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hGeHYKRm; arc=pass smtp.client-ip=74.125.82.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hGeHYKRm"
Received: by mail-dy1-f196.google.com with SMTP id 5a478bee46e88-2b6fd5bec41so4544257eec.1
        for <linux-sgx@vger.kernel.org>; Thu, 22 Jan 2026 22:16:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769148961; cv=none;
        d=google.com; s=arc-20240605;
        b=By+xEsejdBNZAC3b2NgqGnh9oclEABNLD/7CcPFHsIXBqUbtlEyKYMGBYa336hqMNj
         rkdOq6ov+18gkNVyrLAn5AoYS3GCEBscWlh0Smuwlt7EXL/XtnXe/3xynA6dNN3wKmsX
         umyhi5m0gVGZjwlJSGFg58wsDsum6FHHisuUqCZDsH3cZEd6761TxV0CxMX9UQVvMaYT
         SkJjcIKMsOFjFR0uoYVA2y+LqaIaAxIB67c6jyp3rxqJs/evxDGHInuS0X5s0+WOF1tM
         FX2K92FOsuabjyQjh8R3m3+rE56pz5DZTqIHc7AdVkZk/foQbn+mXesp5dx/ulafVo6N
         Hjkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Ppuv8pgq/T4vwgCe1Bz/dr6NK7BtTW4qbcESoNeMtPI=;
        fh=N95pT4w9Jom+jHZ1sR54NAQGw22ZRiDQIA8IE2Ml6Xg=;
        b=hqu/PzO9WHUSX7uVSs6DOPRXz2E5CUv8NhY9ekS2U4T+NvehKC5i6RJqKN/60UHGPH
         mOZuWWpsbrWC4k7hqkysbfowA9go6a2NkTvFbd+mydF+vK6LUdrJd3af/kfjj/got2r7
         MWGMsOSYp/lRdLXY7DmAdqnFoMgNPIxTcQqGD8vacRMMTGedIduYC6bSuIOkZGhBSdF6
         UtM/BGicvP+fK+aj7qj11c+1fXBfuwJD+cV/oAdem47opWYI2+1Cw/UDO8EZzHnPcQ7P
         wyWxQf1Qd7QEDaA5oUEHuZiCQCPr1QaXLKcarZau/rELmKsyptXyQ/wZf7G5OH4DhLQG
         0VYg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769148961; x=1769753761; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ppuv8pgq/T4vwgCe1Bz/dr6NK7BtTW4qbcESoNeMtPI=;
        b=hGeHYKRm+khXKjDXdah5i+s/Ue07iEjdhkGoTIxs6KXTs0NFbAF1Gg5pNss1oL81Fj
         MMxLBRC0ZkPe2+AW8Ian69w217U10l/iMSs1cxwad+zqzzDuRKXp0z3klRaf1DgNPAku
         qanH5TBK4IqZmmPxMZX0r5muUx7g8WEutqX67pPsUZB4Gv85rHqqWnfZS1pKgfcTwozH
         /jKNOFf76FGuaMoOYW2HHx2YGFHKWaNpedtyRP8aolg9pZGxfFDqd0w4x/tIVa28PzWl
         rdO0y+FN87h7YElt2aHjDFAO1bybyE0tnLiAgG2u6Zfea3WPQJsey8M/j5Mn8/0a+Taw
         5Yiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769148961; x=1769753761;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ppuv8pgq/T4vwgCe1Bz/dr6NK7BtTW4qbcESoNeMtPI=;
        b=RqXdhAlgPbU9LnwLGVBQiid5d/ow0HfKf1EMaiaun5P8yykeiV5pDdBdphj33g1mvO
         3sfwij33QGpDGHy4c5Dwo1haxWqySOusy/FVJqb8TMH0QFsQTtHaStsmMUdJAJfk0PAS
         m/pAAHQTA/Rfs38WRYls4Kd0m7TByC5Pxs0qy1nxevA9eAQ5fNyXEkJNpVsHWqPbfbSi
         lrEGqAH5mM0IiCMxOt5L0JMqT60LZ/96H2HU3cv0YcdBoiVZxEfE4peyvjyVyrct0sIw
         PsOlGCVsaIDQWUQRI5PbThBONThjCh9PKiVtEv38wejyKh//sQrM7IS/sjOBYAfhLSgX
         0eIw==
X-Forwarded-Encrypted: i=1; AJvYcCXWR1zwcEIh8O15YWXXRqhMz+6wUXNIuNvnPJBi3ncXHZZuelL1fKlvWSF2Dp0fzccLsB4rstU7t3o=@vger.kernel.org
X-Gm-Message-State: AOJu0YxGsDVxjCzaeeTi/klcW5t52aEUdVTu7z8nn6jYEAsvb4Kcce9Y
	jA+j9SO/O3g6+Ux96BeZRFWOO/d9LujPG/uRI1c2FwpfYYCHGrwoOA90JU6onQGbebP33K6LGkB
	TteQNUw4Z6cnFtg9RzSxH701SbwdGzDU=
X-Gm-Gg: AZuq6aJqZBsSWgEHM3wyUsxdf7XoSSOjjJup80JiY+Brv+sSn7FOED7zFtXN5eUMW6r
	Rc4rVzQYYkdDWBWySDevvrLiLAaiU0xImKUtQNh9AZt7x2n3yYbLZeTEXDLx6jmJr0vKgD9xzQH
	7pbwjGIG0fJOHPS2zxrAWKSgma0VvSkArBmL3i3REHfbpc488k9ogKXRMy39i0s8h1LxHUAyORW
	ev9nWAfuck1JBNj5qxgIHt+zPq6Vl2NcRfOjE2lTgXI30EWdZPtDPYwssrxsPk7Wgg7NQOPsdLH
	S4UTElXQ
X-Received: by 2002:a05:7301:2f86:b0:2b0:5c2f:6bf8 with SMTP id
 5a478bee46e88-2b74285218amr94165eec.23.1769148960619; Thu, 22 Jan 2026
 22:16:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260122055435.95911-1-tianwentong2000@gmail.com> <bfaa49c58626932e65096b433c7f37a2c35ca382.camel@intel.com>
In-Reply-To: <bfaa49c58626932e65096b433c7f37a2c35ca382.camel@intel.com>
From: TwT pupupu <tianwentong2000@gmail.com>
Date: Fri, 23 Jan 2026 14:15:49 +0800
X-Gm-Features: AZwV_Qh772i394vRC9QB89k62wNoreVJOAo8TWYwMOfwq0n_HtLm7G8PGn9a4qg
Message-ID: <CAGPELS5G42Esir0LHz6gAHKsO5gas48XiMtfOeQ+Kn62rDuicg@mail.gmail.com>
Subject: Re: [PATCH] x86/sgx: use vm_flags_t for vm_prot_bits
To: "Huang, Kai" <kai.huang@intel.com>
Cc: "jarkko@kernel.org" <jarkko@kernel.org>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, 
	"linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"mingo@redhat.com" <mingo@redhat.com>, "tglx@kernel.org" <tglx@kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "bp@alien8.de" <bp@alien8.de>, 
	"x86@kernel.org" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 22, 2026 at 7:42 PM Huang, Kai <kai.huang@intel.com> wrote:
> Not sure we should change that too:
>
> struct sgx_encl_page {
> unsigned long desc;
> vm_flags_t vm_max_prot_bits:8;
> ...
> };
>
> ?
Hi, I'll include this in v2 for consistency. The :8
width is unchanged, so no functional or storage difference.

Huang, Kai <kai.huang@intel.com> =E6=96=BC 2026=E5=B9=B41=E6=9C=8822=E6=97=
=A5=E9=80=B1=E5=9B=9B =E4=B8=8B=E5=8D=887:42=E5=AF=AB=E9=81=93=EF=BC=9A
>
> On Thu, 2026-01-22 at 13:54 +0800, Wentong Tian wrote:
> > The vm_flags_t type is the dedicated type for virtual memory flags.
> > Architecture and driver code should use this type instead of assuming
> > vm_flags is an unsigned long, as the underlying type may change in the
> > future.
> >
> > This follows the cleanup in commit d75fa3c94750 ("mm: update
> > architecture and driver code to use vm_flags_t") by converting the
> > remaining vm_prot_bits usage in SGX code.
> >
> > No functional change intended.
> >
> > Signed-off-by: Wentong Tian <tianwentong2000@gmail.com>
> > ---
> >  arch/x86/kernel/cpu/sgx/encl.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/e=
ncl.c
> > index cf149b9f4916..814edcde225d 100644
> > --- a/arch/x86/kernel/cpu/sgx/encl.c
> > +++ b/arch/x86/kernel/cpu/sgx/encl.c
> > @@ -281,7 +281,7 @@ static struct sgx_encl_page *sgx_encl_load_page_in_=
vma(struct sgx_encl *encl,
> >                                                      unsigned long addr=
,
> >                                                      vm_flags_t vm_flag=
s)
> >  {
> > -     unsigned long vm_prot_bits =3D vm_flags & VM_ACCESS_FLAGS;
> > +     vm_flags_t vm_prot_bits =3D vm_flags & VM_ACCESS_FLAGS;
> >       struct sgx_encl_page *entry;
> >
> >       entry =3D xa_load(&encl->page_array, PFN_DOWN(addr));
>
> Since commit d75fa3c94750 ("mm: update
> architecture and driver code to use vm_flags_t") already converted one
> 'vm_prot_bits' to vm_flags_t in sgx_encl_may_map(), this looks good to me
> too.
>
> One thing though:
>
> 'vm_prot_bits' is later bit-ANDed with entry->vm_max_prot_bits:
>
>         if ((entry->vm_max_prot_bits & vm_prot_bits) !=3D vm_prot_bits)
>                 return ERR_PTR(-EFAULT);
>
> But 'vm_max_prot_bits' a 8-bit field of 'unsigned long' in 'struct
> sgx_encl_page':
>
>         struct sgx_encl_page {
>                 unsigned long desc;
>                 unsigned long vm_max_prot_bits:8;
>                 ...
>         };
>
> Not sure we should change that too:
>
>         struct sgx_encl_page {
>                 unsigned long desc;
>                 vm_flags_t vm_max_prot_bits:8;
>                 ...
>         };
>
> ?
