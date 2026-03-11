Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA1533DE43D
	for <linux-sgx@vger.kernel.org>; Wed, 11 Mar 2026 12:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773230663; cv=none; b=AuZpl08Qf736ahihXqBQfn0x1r7ersQSEvCB37Hx38QPO1S6RzNkkyEtjyZ1FIrMZFwlZEO5N4nLfQ/yi8R8r7mtZhCTP+6Y5e/JAgnSGJ9EJ5lqE09bOGIoFTONoBrJAT0nQvb/0igU9+JJzu+USuTB57egwLiI5NGvup04ZYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773230663; c=relaxed/simple;
	bh=s5EMe7bYHKODG/rm1X+QIPDr4bQTLFjKqTjmSxuIYLA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IKUKPrtvDZZKr+vjdx/nN35/GWNlzaEhCDB+JtnF+NI9dgMdpZx12jK8KPSr0VbiA6EjdaK8x8vRCVsg/5lR2EoLOt8CTC01D6uy/FMxgGQSPkSmwSCy28D4oHq72H2N68YwLeEyTVNSp0o6pQQ6/Y6pq1j4aFUx4wmE2oh5284=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=oJbNeSzI; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="oJbNeSzI"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-89a09ef1e3aso124822946d6.0
        for <linux-sgx@vger.kernel.org>; Wed, 11 Mar 2026 05:04:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1773230661; x=1773835461; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=s5EMe7bYHKODG/rm1X+QIPDr4bQTLFjKqTjmSxuIYLA=;
        b=oJbNeSzIwFnPHScHsQshxjdJjgN5YRgniLu4SRX713CC6CAYeQLHkIfpbljvCRRAnH
         8GCdREp96tRlupjpA0l3esjCjroz6Q5dt0kA190IMCBZe9Y6TypRzoJM5ya12V1OkVub
         EUQ+KzKHFncYXagt1P6wWI3tx3xXAcJ9nVqE0WJcPYHWyuoYrh+bRaAymwSQo3rHPIU3
         l4mxZ//9rXYowokM76ZULSkPHRFaWLXI9DeuKwC79yu3oKxE8Iq2+zzTOrCWXVjPZrH9
         CEu/YAUe//Hit+usny9ISZgFfiOdMPYNDj9YWIjqEKoVggIDs+kCLw9eATV/2xna2ACe
         /3LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773230661; x=1773835461;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s5EMe7bYHKODG/rm1X+QIPDr4bQTLFjKqTjmSxuIYLA=;
        b=GZ0dx2ex85GrEMFeqIsP9/GVJgxWb+liODMz27bsp7aqlh5UuNQlEPnvz+RsrtXp61
         0Cua7axsnY66Jjhl4jP6eRKANgLXNZf3LKpBLyhiP4npNpPJsBvW0XydJrBaoDyTqmgs
         1uOowigupftrpP4zPLigjfDgtfMTBTNvaP8eImyZywdMXPfFWbULQ2/xQD9WX4xu5WxV
         S6V/WO4VYsfdGGSJfCTLikjom2ofgsOIGmQ+6BtWSH5ZaJ1QQjqy238s8PQL4DxUZOAZ
         UrUzwuby9bKaLdqqrW8WlZy7KmAELK2tzPFWRDFYvzHL97+b7wzUaVzXXVhMhJ3bbSwt
         sD2w==
X-Forwarded-Encrypted: i=1; AJvYcCWORGSO+xAOSVfEzxwEMKMu4JNBtXop8dovQKqgor9Xwv7f+J8HKR7MJl626Etp+45AaFRyrr41hnY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzQeNhZxTu2Oa2Z4HK+YMm0BcQh7aejtfYjwx17s3lVOEipTruP
	Yu+x5vJ1PZuRMl1f3s7VoOqcctNQYBEj/O3xvndb0a2/tBUnAKvhlkNyUY4KuLonHIM=
X-Gm-Gg: ATEYQzxxPWWoF8yCL279ZRrii+cM95SMjySNduYf41LwIsm40UM+5+ngLEZ2FcOYng3
	61MRizxTTDrTvvnwxjzXBoKCBdTYFi0FC2bCGJ4kYf2DHbJE9vOIL1rkWXg1VzMnZauAj9guJ/8
	aNl3MqvUJtlRvL8PfQZzmES4MRzbktJJEynctmrGBdM8E83pNzCnP+ff/IDH+TdTWkJ0TSOvG2C
	glLIJNcctVAliwefkJ8jTMp0e0o8uJR25OhLaEXE0ZRoRC4QafgI1BMKQtRTocb9Ww/49vsfa3H
	f9DxWwKxxFpAyeIobf/AKB1KGfGHlqV/9u/lg9dVEYFHqlfc1rUKm0Yc9Uz+v5CafEDGVHohk//
	XrsE4DIcQLov24Q3O2QOAeid6Lxq3qmU/QTM6lf5fFZBR9oWJcY4wg/2alusv5Rj7SxA3yXwEi8
	0eW6s5mqNyJ9KOa/9HLRY95exPcqmxN1XVWNnDR9O0h6033300ZejDlr5u1CByWYgA6Bcs2KWom
	9UjT2yY6FxPecXa46s=
X-Received: by 2002:a05:6214:f2d:b0:899:fd8c:55c6 with SMTP id 6a1803df08f44-89a66a5858dmr29432376d6.23.1773230660563;
        Wed, 11 Mar 2026 05:04:20 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89a65d17023sm12745086d6.49.2026.03.11.05.04.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 05:04:19 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1w0IIU-000000069iv-3jx0;
	Wed, 11 Mar 2026 09:04:18 -0300
Date: Wed, 11 Mar 2026 09:04:18 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alice Ryhl <aliceryhl@google.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	linux-kernel@vger.kernel.org,
	"linux-mm @ kvack . org" <linux-mm@kvack.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
	Todd Kjos <tkjos@android.com>,
	Christian Brauner <brauner@kernel.org>,
	Carlos Llamas <cmllamas@google.com>, Ian Abbott <abbotti@mev.co.uk>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Leon Romanovsky <leon@kernel.org>,
	Dimitri Sivanich <dimitri.sivanich@hpe.com>,
	Arnd Bergmann <arnd@arndb.de>, Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Andy Lutomirski <luto@kernel.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Eric Dumazet <edumazet@google.com>,
	Neal Cardwell <ncardwell@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>, Miguel Ojeda <ojeda@kernel.org>,
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
	linux-s390@vger.kernel.org, linux-sgx@vger.kernel.org,
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	linux-rdma@vger.kernel.org, bpf@vger.kernel.org,
	linux-perf-users@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	netdev@vger.kernel.org, rust-for-linux@vger.kernel.org,
	x86@kernel.org
Subject: Re: [PATCH v1 16/16] mm/memory: support VM_MIXEDMAP in
 zap_special_vma_range()
Message-ID: <20260311120418.GU1687929@ziepe.ca>
References: <20260227200848.114019-1-david@kernel.org>
 <20260227200848.114019-17-david@kernel.org>
 <20260309142954.GM1687929@ziepe.ca>
 <61df6369-333c-430a-bd18-c5b1acae68ea@kernel.org>
 <abE4JYo223OxWCBQ@google.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abE4JYo223OxWCBQ@google.com>

On Wed, Mar 11, 2026 at 09:38:45AM +0000, Alice Ryhl wrote:
> It doesn't really make sense to have multiple binder VMAs. What happens
> with Rust Binder is that process A is receiving transactions and has the
> VMA mapped once.

IIRC the problem is the kernel doesn't guarentee singleton VMAs,
userspace can always clone them with fork or something. Did binder
solve this somehow?

Since you can't assume there is only one VMA the locking becomes a
mess to cover all the cases where userspace can trigger a VMA clone.

address space deals with this internally.

Thus, zap_special_vma_range() is extremely hard to use.

Jason
