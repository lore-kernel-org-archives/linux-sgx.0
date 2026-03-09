Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20B2F3CF667
	for <linux-sgx@vger.kernel.org>; Mon,  9 Mar 2026 14:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773066598; cv=none; b=aDIeOITakEVSnmI6VO2+h3Rf75bNv22v5dgcqfrbDGWnt24o9Ak7flMgDVbYhsnq3dxpvAcuAwd4dsiUs2ZZUqo37tmsPDwmDPnf52lDJjVFXpckwCox8eBUHLkz0ur/qeVBVGDASXO+YqZPoN8axiA3d6WoBYp6NZPYq12tc3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773066598; c=relaxed/simple;
	bh=qGkfUw0cAuRi50whdAw9tYXjFfsurpxdwyuHiMRzvHk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GnZeIH5jInyMWqoyZGhlhc2qOWTQPnBSgkYhaBp4RqOqhvKR2e5F9y/5YjJ+2DPbSfFHwD5Ppk/Tw9urUtyL1cDJ0rssDmUVnfmf+EJ1dj6eQSz2VOYs5rAUhIF95ORTbi6amHxMZSEgKCiBOV6ilZgS6EnxTxmYcmEK/paa01Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=ihyQWMnv; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="ihyQWMnv"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-8cd759f502dso233246585a.3
        for <linux-sgx@vger.kernel.org>; Mon, 09 Mar 2026 07:29:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1773066596; x=1773671396; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0bCgFz4UpYVbBeKSYmRS1UHS00xtZH8a/t+DzU0dS+U=;
        b=ihyQWMnvVuXvR909Z1cWQbCW/x6Uje2bNeYH28gk0StuBuzAOqigvjL7w1dE9RCBvz
         ZoZwM7cx4GGinybPk7GhMgYWs8ydFH/+Jkrso2JRthaffI2Zbp5XMm+3eSXkDs8OrWPp
         1PdirPb87UjX0oH7606aIZq+oaAGP7vKybDN2bYMkprfF7k83xhQjnzcnPUik0YOPAdr
         2/KizCv3zVMKKDWmAMInYE8tZ68AN+LVOAzGdtD0I5zgKs6YmQZljOhOH1YH4QRwNHq0
         ro70VHn1/JFY0xIEfw2/X2a1ANbJoQ6e9TuLfleRF6ybM460qzLn7jf0fGZVrlG5Po2P
         lTEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773066596; x=1773671396;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0bCgFz4UpYVbBeKSYmRS1UHS00xtZH8a/t+DzU0dS+U=;
        b=VZ6McgLSDDbThx8bI6MJ8sUGvB75R8YN8b4KXEQteK2DJpOAsLFO0b024iayF355Js
         m4mNuKJemORVlh+LV6adeN1Hp6S66tDl/o+kObWKT4MsOHNicqAuQGNOX3j61n5P07VR
         3gnEwHU+gTzOh1m60+T8U3tCtkpaSMiVWicaJnvIvGUvpa/orkFiCOHxZi5H0JM/Jo91
         EsPkOpBvFUdkkqOcuG4P3DeuOptf2hqtLk+rR8BYStlR4SHli2mIH4CZXZXfOZZvvT1j
         9YM5+SWK93xG63UV3sdm3jN80dWRGBgweDq8U7yZvx07Et6v+TXmdihN29hF63YuKw3u
         y5uA==
X-Forwarded-Encrypted: i=1; AJvYcCXHRZ+K9wWz/YHsj3I0AM6F9YToT/yW6duD9n8OknuuOaZCIprG/nFwAb2LKn8s6eXgxBoe/qq2l8U=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzo9gouewUXKRCLn4Q0OUmKPmJX+gO6ut3lGYgkPYErVA8gKc0W
	QIn0B2+Ei/H2BkOHooTf5Bt/EOpAP4MHKgoX7ZuqII1q+U5vtgAfC6PwIn4lirD8SXI=
X-Gm-Gg: ATEYQzw/n9ku5+TSKGkZaHOuxiRYj3MuwHcEbSQJoiImgxJmfTRUly3Rs0BqlJvoR1i
	Z/KCTCHXyvqZ2UobqjS0Icr9+5tQt8tnjsfWlW9tBfjpltyhCLkM7R0hea+G3FtaB5BTOPkZXo5
	JVL+ffZsXw96bpAHvhDv51x35HNrM0jTWViXQhcsNZYGMK9WruSdvSmsw70syPYi0zNExkg7k4T
	heYVDRJRRtsA3SgxoX4muouwYrhOV2ApA4Wa06wr33DYpzRLHOoxUM+FKcfaFqMLe2IbNhQXUOV
	Q6iwwHz8R8dt23JnKIW4KjOGEWHiUxKt7yThP7wagrhlZU3i5BLYyjQYBHd7xkyWydHuHH++NgA
	OO4uJSLBX2iy8w4obTl0DN4Yk0PXAhydXZjnVQq5ZU80w0AU3wxswc1h7PEjw3LZLxMFNxwBO9q
	SfzsjnrlLeWxEYsatGK5NDa14Sqb6jBh/8LJ7si9CjpuYs9WUfVqvWNppGe3DTofYZcJ39ADE6A
	4A0dOtL
X-Received: by 2002:a05:620a:4809:b0:8ca:305b:749b with SMTP id af79cd13be357-8cd6d4d5456mr1426307785a.60.1773066595964;
        Mon, 09 Mar 2026 07:29:55 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-112-119.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.112.119])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cd8d4cad48sm148711185a.33.2026.03.09.07.29.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2026 07:29:55 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vzbcI-0000000GTxY-2R0b;
	Mon, 09 Mar 2026 11:29:54 -0300
Date: Mon, 9 Mar 2026 11:29:54 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org,
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
	Alice Ryhl <aliceryhl@google.com>,
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
Message-ID: <20260309142954.GM1687929@ziepe.ca>
References: <20260227200848.114019-1-david@kernel.org>
 <20260227200848.114019-17-david@kernel.org>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260227200848.114019-17-david@kernel.org>

On Fri, Feb 27, 2026 at 09:08:47PM +0100, David Hildenbrand (Arm) wrote:
> There is demand for also zapping page table entries by drivers in
> VM_MIXEDMAP VMAs[1].
> 
> Nothing really speaks against supporting VM_MIXEDMAP for driver use. We
> just don't want arbitrary drivers to zap in ordinary (non-special) VMAs.
> 
> [1] https://lore.kernel.org/r/aYSKyr7StGpGKNqW@google.com

Are we sure about this?

This whole function seems like a hack to support drivers that are not
using an address_space.

I say that as one of the five driver authors who have made this
mistake.

The locking to safely use this function is really hard to do properly,
IDK if binder can shift to use address_space ??

Jason
