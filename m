Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA7EF383C96
	for <linux-sgx@vger.kernel.org>; Mon,  2 Mar 2026 10:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772445676; cv=none; b=cjbBfNOljVUi3arm0T/rD41Kq65TlTElqk7nKa7NFqdy6qtE566Z+TR8aucE0pv05c6+V8hSWMn73HkJsNKY7W3KtmDwWvC++ahLq9UPgAor0Zw+evapKoIZJUy9oCDNGZqI6C6Kq5oi+nXRHWED8s9Q0AQbpo2tt3kJsGp10cI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772445676; c=relaxed/simple;
	bh=XcDBiF+tm+FToq8gICWmU+m/nRh9Ny7buWewqeSSE5s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=n4hj8UNSIt1Fukv1p6XL8gkBCBR+W5Sg/LTHtIVOK3gVpzqFVcgUu5bB8WK2bzFerozlgoXMk10t/CzgC1y6+Qp/h3p/lvLYp5sypsGYfW2IsYM6CekFDEcOboY9bvWvWeGPnxYZIz+sV7H+i3zMQoCcsOfpa6FDJu4B45yhwtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pKcMeK5z; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pKcMeK5z"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4836b7c302fso43405825e9.1
        for <linux-sgx@vger.kernel.org>; Mon, 02 Mar 2026 02:01:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772445672; x=1773050472; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=tjS8FX592qmj/rFkafjn+lojx6cnlsSGWxK3ppaLTGU=;
        b=pKcMeK5zFCeuyEDqN9uC2KaA70X8zgbgjnqAslsyyaFYEXtkS9V6COy+BZIyCzxSmQ
         pOEovWK8dwfeI8hGnwiaqcOR0b2SAyvlou6AEigYeorhF6m2bin/+hJiFLV9gNI5yJ9X
         5VbDb+pbUiHmxG/B6jxauf6w66cmYQoGlfDcBBhNz9g73G6Xfxxfk2cqgDlaiRQTKaSH
         2TMAEi4ATjIBTiC2y3HnwO5ZQIREWjEyEayiTutzK8+3fCDcwXrIjy29bqj+MgfJewS+
         TQdyTuXurfVHvukuPqLt4qL+/V7ElyQD1yki55tyknaGoKa4sg5MjKF7WPiUKOM217sF
         9gCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772445672; x=1773050472;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tjS8FX592qmj/rFkafjn+lojx6cnlsSGWxK3ppaLTGU=;
        b=Uk+G1DaH3pl64Ru0+tVlmaDzgTIuPjl+vd+xBA8amC1Yc6BF4qIAg+L7bSAyRRjB0c
         4PwB4m0zG/z+9EaHAbkuhx9VpmYVFW8EltEyWsjE9bEtqrK7BVwJBOSY4ElUIa13N2Dp
         uzzF/TRXtGPdFd/mdJSGAiw8px94y1sOp1VVH+IfKgEsCQPw5Nk+6i4p7ZRsFNua3jD3
         +yHta4kpE8VjAmLN/S0B8DYQD+T/GESEzzO9VKKFk5yyxkCpWIUW2gHzyiCUI+GqwGxw
         uKh0Hf9detHHF7OkjS4eetKoDjETpCAjR//urm1cnOh1r8i0SxpO1SCe6RsSYJx3dzy2
         if/g==
X-Forwarded-Encrypted: i=1; AJvYcCVQmCuC4udSndy5DbudHfvAv0Wf3apGk3vAXMxhwgKv0U+zq98+NUJDRuJVspjiZ1Jhes4UJ1Rm5h4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyzlcIk6pay/W34LzdBIiBJdxk1VR4CiYbn8qwXZV9fmExVulcC
	41EkbFvojqBUnK1lztms6sJTwVgNqLj9SSwZfe0cnfu+CKyA9uh1gNV9k0Rpwm8i7eMUW52ODl9
	0KhvHv2vCvwHPj2Y13A==
X-Received: from wmbg9.prod.google.com ([2002:a05:600c:a409:b0:483:7827:ade4])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3110:b0:480:2521:4d92 with SMTP id 5b1f17b1804b1-483c9c23ffbmr196674855e9.24.1772445671732;
 Mon, 02 Mar 2026 02:01:11 -0800 (PST)
Date: Mon, 2 Mar 2026 10:01:10 +0000
In-Reply-To: <8a27e9ac-2025-4724-a46d-0a7c90894ba7@kernel.org>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260227200848.114019-1-david@kernel.org> <20260227200848.114019-3-david@kernel.org>
 <aaLh2BxSgC9Jl5iS@google.com> <8a27e9ac-2025-4724-a46d-0a7c90894ba7@kernel.org>
Message-ID: <aaVf5gv4XjV6Ddt-@google.com>
Subject: Re: [PATCH v1 02/16] mm/memory: remove "zap_details" parameter from zap_page_range_single()
From: Alice Ryhl <aliceryhl@google.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, 
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
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Arve =?utf-8?B?SGrDuG5uZXbDpWc=?=" <arve@android.com>, Todd Kjos <tkjos@android.com>, 
	Christian Brauner <brauner@kernel.org>, Carlos Llamas <cmllamas@google.com>, Ian Abbott <abbotti@mev.co.uk>, 
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
Content-Type: text/plain; charset="utf-8"

On Mon, Mar 02, 2026 at 09:18:45AM +0100, David Hildenbrand (Arm) wrote:
> On 2/28/26 13:38, Alice Ryhl wrote:
> > On Fri, Feb 27, 2026 at 09:08:33PM +0100, David Hildenbrand (Arm) wrote:
> >> Nobody except memory.c should really set that parameter to non-NULL. So
> >> let's just drop it and make unmap_mapping_range_vma() use
> >> zap_page_range_single_batched() instead.
> >>
> >> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> > 
> >> diff --git a/rust/kernel/mm/virt.rs b/rust/kernel/mm/virt.rs
> >> index da21d65ccd20..b8e59e4420f3 100644
> >> --- a/rust/kernel/mm/virt.rs
> >> +++ b/rust/kernel/mm/virt.rs
> >> @@ -124,7 +124,7 @@ pub fn zap_page_range_single(&self, address: usize, size: usize) {
> >>          // sufficient for this method call. This method has no requirements on the vma flags. The
> >>          // address range is checked to be within the vma.
> >>          unsafe {
> >> -            bindings::zap_page_range_single(self.as_ptr(), address, size, core::ptr::null_mut())
> >> +            bindings::zap_page_range_single(self.as_ptr(), address, size)
> >>          };
> > 
> > Please run rustfmt on Rust changes. Here, rustfmt leads to this being
> > formatted on a single line:
> 
> Having to run tooling I don't even have installed when removing a single
> function parameter; did not expect that :)

Well, rustfmt comes with the compiler, and it would be ideal to build
test changes before sending them :)

But no worries, I took care of testing it. Thanks for taking the time to
update the Rust code as well.

Documentation/rust/quick-start.rst has details for most distros.

Alice
