Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 463363750B5
	for <linux-sgx@vger.kernel.org>; Tue,  3 Mar 2026 20:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772570962; cv=pass; b=JDCzc60r5tsaW8hZMbbnmFZSSn034IOAzIUFN7OitDqWIUGgOrNPvB2gFceXvhOSL4v0JgXMXCCkDFjI8TsXq9nXm4mcKKnlBQ7f8UpQbz/tzb3GXIJLUKQuIWmC4tesIH5t5LVVL4a09M71GgAlErL+8mCdYqU7tex8H/AAHtU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772570962; c=relaxed/simple;
	bh=z5K9TC0MkEO8By22h3GqX8xxcKLeF0UtxgZ/D1gjfh8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NiIuPw3zUoke6J3Xl7J/AoLZozKk0IyKbnnhBmEPflj0o/2Yv4zbTLguPXYI4oV9qZYcg++17E2Kgr73MjN5ZDlzk/ghQvm4yPIqkeIVfaTTT6exXMKFAQ5fTtNZz9PFsLmVdw3WeB/h+5J3ED9H8G6gSMxn3C2U/nKAFab9uQk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MC/6UvpH; arc=pass smtp.client-ip=74.125.82.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MC/6UvpH"
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-2bda3b4318dso570459eec.1
        for <linux-sgx@vger.kernel.org>; Tue, 03 Mar 2026 12:49:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772570960; cv=none;
        d=google.com; s=arc-20240605;
        b=Zq8GrdMcfdEAfaVY03IUx2X/LPDyzcx6rES/xYQ8SouKxi8nM6FiXoSFIAdcNOgYRt
         rB+lOgx54VQ+5LSDd4auaStCmZqkj6SeuzlvxKcQwl+EHEbm8018ziUD1TN9FRTZcWqV
         JH7UGqwFgcl40/jp6CDNEWhptAi3IXwY7yUclbbTIJLL680LzhL3C5SpdrsRY592eTL3
         S89HTRpX/j9h+meK4Tm0NQsxB88mG8cRKN8hBEdOWSZSd5c2iDLrhvquVjolxGm0ppGK
         AyXCwAmLagl2KLUjCKmZey4mutkGPtzI3OfTiw2tav9TjkZwNSQpSSwSsc0sE37hwbHF
         +0DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=z5K9TC0MkEO8By22h3GqX8xxcKLeF0UtxgZ/D1gjfh8=;
        fh=AbungCuoQJ8eg1ogR54jK8Ikm46v8qwTmUm8iosn42I=;
        b=J8i/4p7BmCGs+ihkiE432AD0iq9oqobl2SQuZVPVOPzNyOHMC9c2VxjYqPZdjDtshR
         fPT8l8epJpSDDOwKbCwbQ1cOyCqGxXerYOCkHIJ3bU1b5orgtpPkKBQJnqERlrUHmaaN
         1oKFWUJu9iP6BWCTYCWcZuL7xuaZYBrWhbL6jh40U4vNzmOIZ2j2kdKi27NTEh9I3VC1
         FU5A9avLY86fb48x3QVi/n01emFZ9Wo6QLxMN4mX3F+77+QxdM28dxPbnZ3UrszQzVmE
         CStvUvmNhgv/fx9mMwbQcfRjT32FQ/BKoPcuagggWadLXCZIzZgywiMeeadsOps7+Ymr
         hw4w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772570960; x=1773175760; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z5K9TC0MkEO8By22h3GqX8xxcKLeF0UtxgZ/D1gjfh8=;
        b=MC/6UvpHT4SEnjb/NMu4nCD7Y/CgFLGhB10BzWPvEDjKvZA2lZ9okaGCUCGB3IbeLy
         cGgqGyj71FN7/CioLy93vdYXiKOMJe3vR+j+biXyjvWiP1VvwY0SpZuEnET7WI0E0PLq
         BBf1WqOSwDjAumUHPBfJGMcqZXc4B6Yuz6rp/ed69z6jmhyN3Yhj3DTtzwNIYZQmx/SF
         jhT5DwBvS3xmxNKPvfei0LpqgbJOmZuKLyUK2wYyCE/Tg1IJjSJ0URjLr+TYYhp768vW
         OGrdSbrtyYfSf/xo+vB+w4pxsweRRJyYX/6uv1dcXSw8p0Wob8DVrGmxbm0/OVwZigJr
         6Z+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772570960; x=1773175760;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=z5K9TC0MkEO8By22h3GqX8xxcKLeF0UtxgZ/D1gjfh8=;
        b=ccxQKRhE44puEr3IOP4IaUgXEWl1zROOfZqJ9cET77W6WRgt1Elp6f7vc5cXJnGilk
         27KwAj8ofzzQnnIAKNPNAGLbSmjkE7qJQ0PIyznFljG3sv5TKtNQ7EvFqftvvAXHFUhZ
         q7wg2dhxmLWtVtnvX9UMJnrMHLJjL2ikr/Mh3aZrVYBdo11EO0ap+yE/eZewWfJg0c0v
         WbrDz3JlaRGwPFofn1mxLRfIRh6Z3TpdmSBbmS+G5M5DNAe5i6+Sx+fFd+6TLCLBrWEB
         pRAchzwSKqcwKEsQKu4WvUBQlys2yUcshZyy68p84yD2FhCSnNOs6JL2w9AOPURVLN2q
         df6g==
X-Forwarded-Encrypted: i=1; AJvYcCVJi7J2zkMF3quBcXgfrl3Bp1IERnloK5mE2eFTG2LR1s/0EpKDHysbb8UbG2qOvYW/wVHbbQkfiSM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yynxy/0xSm0YMEM+LMdL2JpG9mK3qfln4WCVuwMBoA/cnnzXUk7
	C//O5KDX7k1/bExkyVkE4RtYGpvdi9dOkCM5WcJxr4kcBObsymwJtNVWcRt9SV7pDNGD1e1NDOK
	E0PMbflV/+Pt1HBLjtJawV0JAFs2d+mw=
X-Gm-Gg: ATEYQzwSTXzb9sEv6MVTql2jxaPJzcqFhOt9ndvtITkPCF4vt6fNZlkmAvJ9gImarxp
	xWvQpvIAg7UDtX5POxIQfTMRmmY+PnEwsIFw4f5HBYuKZn5u91vbt1f/gUcRMsd/jDyJM2uoT7H
	tAf54RURu1ChBN1staQSoDjnIMXK17HvDOaOIq8f/gHhLq+nLCimW8ufi3dLib3xZg+bgoz854N
	WgsmvyrW3ZqS6K0s2fAR6hWSLQe7aHSAPGDNQBJz4l/uFSQhvF80s42SoYFKl2v/kyyiOBdyIux
	PSWABoES40HfENqjloc5cNfDLDYrX3JwM7zEHVz7fSWzQuK4zf+K0BREvtYYTX0ZyPBZ/YQ4fX1
	nQ1c+1EL/be2P5JUdgjfPI2zr
X-Received: by 2002:a05:7300:231e:b0:2b7:103a:7697 with SMTP id
 5a478bee46e88-2bde1d4bc79mr3350396eec.5.1772570960234; Tue, 03 Mar 2026
 12:49:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260227200848.114019-1-david@kernel.org> <20260227200848.114019-3-david@kernel.org>
 <aaLh2BxSgC9Jl5iS@google.com> <8a27e9ac-2025-4724-a46d-0a7c90894ba7@kernel.org>
 <aaVf5gv4XjV6Ddt-@google.com> <f2f3a8a1-3dbf-4ef9-a89a-a6ec20791d1c@kernel.org>
 <aaVnifbdxKhBddQp@google.com> <5f8dcb7f-9e4f-4484-b160-3a9ce541d63c@kernel.org>
 <aaWvtn48X8UizaaN@google.com>
In-Reply-To: <aaWvtn48X8UizaaN@google.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 3 Mar 2026 21:49:06 +0100
X-Gm-Features: AaiRm50lUTXkxHRxiLsKpWNGF1HIgeoo2SkrDpQfQSxM22wzlSiellk8rvn7q80
Message-ID: <CANiq72nK8P1rUYw=y3fMzWZR3f_mW2v0_LSLWR1i0dQTtOqu2w@mail.gmail.com>
Subject: Re: [PATCH v1 02/16] mm/memory: remove "zap_details" parameter from zap_page_range_single()
To: Alice Ryhl <aliceryhl@google.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, linux-kernel@vger.kernel.org, 
	"linux-mm @ kvack . org" <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, David Rientjes <rientjes@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, 
	Claudio Imbrenda <imbrenda@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Jarkko Sakkinen <jarkko@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>, 
	Todd Kjos <tkjos@android.com>, Christian Brauner <brauner@kernel.org>, 
	Carlos Llamas <cmllamas@google.com>, Ian Abbott <abbotti@mev.co.uk>, 
	H Hartley Sweeten <hsweeten@visionengravers.com>, Jani Nikula <jani.nikula@linux.intel.com>, 
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Tvrtko Ursulin <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
	Dimitri Sivanich <dimitri.sivanich@hpe.com>, Arnd Bergmann <arnd@arndb.de>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, Andy Lutomirski <luto@kernel.org>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Eric Dumazet <edumazet@google.com>, 
	Neal Cardwell <ncardwell@google.com>, "David S. Miller" <davem@davemloft.net>, 
	David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Miguel Ojeda <ojeda@kernel.org>, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-s390@vger.kernel.org, linux-sgx@vger.kernel.org, 
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, 
	linux-rdma@vger.kernel.org, bpf@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	netdev@vger.kernel.org, rust-for-linux@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 2, 2026 at 4:41=E2=80=AFPM Alice Ryhl <aliceryhl@google.com> wr=
ote:
>
> It's not relevant in this patch, but another thing that may be useful is
> to add CLIPPY=3D1 to the make invocation when building normally. This
> causes additional warnings to be checked using a tool called clippy.

Yes, please do use `CLIPPY=3D1` -- the build should be Clippy clean
modulo exceptional cases that may slip through (and soon linux-next
will probably start reporting those warnings too).

Thanks!

Cheers,
Miguel
