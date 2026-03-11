Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BDB52ECE93
	for <linux-sgx@vger.kernel.org>; Wed, 11 Mar 2026 09:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773221932; cv=none; b=OALKuxJudkvUL+IyrGMxNXbt3Odnic/+rKX1udq4Yy2Z6+UQVkgrnkw598E/M2oyvfUkP0YlaMLx9QytF5vw0Uong+TbO/OKvFD5f2/zrkH3Rm/n2PoCeIABmhqdo4P8d1dzRXjLjtx+7sZd/PP8GJW/KoJ+qWzYSddWARuDM70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773221932; c=relaxed/simple;
	bh=ceq7ItjI410zJHY9ex/lB3H7siEVATfaO1bldTHFjis=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Mqr5YngqhWdDDjCitKw/LzFT7I9hGUoRhhOlhj/kgLeNfk06/JzFlEwpEI4QAJ2jPVyOktorxzP9WCbeHvtTDK9C9IfrsUSJ4L7mIO5Nd/tbfzoNMmeRWJ/5VhuFkeldNx9sak5QjjFkOvaB60QQZDxc7hmVgyUiZtmC9aJnD1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BnNzevha; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--aliceryhl.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BnNzevha"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-b9410af72c3so686235366b.2
        for <linux-sgx@vger.kernel.org>; Wed, 11 Mar 2026 02:38:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773221929; x=1773826729; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RQubQpcCCRw5LR5oprIFTZzoSHmrBMbhMG4Ewb+bDNM=;
        b=BnNzevhaOLmgv2VG3RJz5MjAMfYffQeX/O07otWuu5Vg3kJ+l8eK/VwR8aD0JHqx0v
         0GBpWmAirkhFhsFyBUr2+qtsdtvU/Lz7VkN4rbvt52T98j10+k9rEUbNYNi5Rt2KlRij
         dFrMaZnAsT0/bqy0ITXDFUhyOssdQGYMQejLlmohDF01F4I6EEyWj2S4T0VUqzvhY9O3
         IviyDvBhD0KWS7EKN5Siyu5lacrKas35yFDnt9cw7pzdUqdhFCkHT1+1l/yRmadDjUpo
         74N+8NuOP1haXz8kZkdGH/F6OjcC9IZMSl03SJnjQAHciV/kfZCCsJ4JMMHYQLotg7m6
         aHGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773221929; x=1773826729;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RQubQpcCCRw5LR5oprIFTZzoSHmrBMbhMG4Ewb+bDNM=;
        b=q+TD8Hpoz4/bz5qzNLhGafymSFaE9gahlEaPAe2L3WCRvXbVvIdM05LP+ttLRxqza1
         387K/bK5iTftipS/f06TIpVSzPBs8T4Gs9NEFswaKfnb1ys/cYUJ/m1Lq5Wypksqk9FN
         XqDXiyCv4UgOhMmI8tYnt51yTlMO4wzJahU+iwX/pAsSH0HP3AHJDujrjX1gfu9hn4Dp
         Xz2bKnQ5mGNuEv0EdlLhW7j6nO41K+ZK5Dm3YEEPr5W9cQYcO+Vcocc3WUVnEehhZbe0
         U5Bcz05ZeeRaxlt5BpdmXBWC3JZAuY62EM5ci3BV4OCKsXng/y2G6JXVo9sAm1Hkkkly
         NT8Q==
X-Forwarded-Encrypted: i=1; AJvYcCUuDt5lwuBQAhOwAGIh+FSBU9B+fY7AX9qfhTYzvp7ub8ue2gnmOHEjKviitmV6GS2x286gcxSnxwk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxr4W5g+rJihETXQ/CIQksrkPcq0l5p0eILzRNVS5ZvBCckqG+k
	OHZ2CbDmtV8IKA1r9LOwzPPjyy2HqlddK9EfK/aX+1dNrc/V2BZnCv13SMh3u3KGd87QDfVmL1x
	UsOVu/o9oohUkt9pi+Q==
X-Received: from ejja22.prod.google.com ([2002:a17:906:3e96:b0:b8e:ad99:be59])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:f592:b0:b87:2abc:4a32 with SMTP id a640c23a62f3a-b972e1d254cmr101140266b.18.1773221928398;
 Wed, 11 Mar 2026 02:38:48 -0700 (PDT)
Date: Wed, 11 Mar 2026 09:38:45 +0000
In-Reply-To: <61df6369-333c-430a-bd18-c5b1acae68ea@kernel.org>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260227200848.114019-1-david@kernel.org> <20260227200848.114019-17-david@kernel.org>
 <20260309142954.GM1687929@ziepe.ca> <61df6369-333c-430a-bd18-c5b1acae68ea@kernel.org>
Message-ID: <abE4JYo223OxWCBQ@google.com>
Subject: Re: [PATCH v1 16/16] mm/memory: support VM_MIXEDMAP in zap_special_vma_range()
From: Alice Ryhl <aliceryhl@google.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, linux-kernel@vger.kernel.org, 
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
	Simona Vetter <simona@ffwll.ch>, Leon Romanovsky <leon@kernel.org>, 
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

On Wed, Mar 11, 2026 at 10:15:12AM +0100, David Hildenbrand (Arm) wrote:
> On 3/9/26 15:29, Jason Gunthorpe wrote:
> > On Fri, Feb 27, 2026 at 09:08:47PM +0100, David Hildenbrand (Arm) wrote:
> >> There is demand for also zapping page table entries by drivers in
> >> VM_MIXEDMAP VMAs[1].
> >>
> >> Nothing really speaks against supporting VM_MIXEDMAP for driver use. We
> >> just don't want arbitrary drivers to zap in ordinary (non-special) VMAs.
> >>
> >> [1] https://lore.kernel.org/r/aYSKyr7StGpGKNqW@google.com
> > 
> > Are we sure about this?
> 
> Yes, I don't think relaxing this for drivers to use it on VM_MIXEDMAP is
> a problem.
> 
> > 
> > This whole function seems like a hack to support drivers that are not
> > using an address_space.
> 
> I assume, then using
> unmap_mapping_folio()/unmap_mapping_pages()/unmap_mapping_range() instead.
> 
> > 
> > I say that as one of the five driver authors who have made this
> > mistake.
> > 
> > The locking to safely use this function is really hard to do properly,
> > IDK if binder can shift to use address_space ??
> I cannot really tell.
> 
> Skimming over the code, it looks like it really always handles "single
> VMA" stuff ("Since a binder_alloc can only be mapped once, we ensure the
> vma corresponds to this mapping by checking whether the binder_alloc is
> still mapped"), which makes the locking rather trivial.
> 
> It does seem to mostly allocate/free pages in a single VMA, where I
> think the existing usage of zap_vma_range() makes sense.
> 
> So I'm not sure if using address_space would really be an improvement there.
> 
> Having that said, maybe binder folks can be motivated to look into that.
> But I would consider that future work.

It doesn't really make sense to have multiple binder VMAs. What happens
with Rust Binder is that process A is receiving transactions and has the
VMA mapped once.

* Process B sends a transaction to process A, and the ioctl (running in
  process B) will memcpy the message to A directly into the pages of A's
  VMA.
* Then, B wakes up A, which causes A to return from the receive ioctl.
* The return value of the receive ioctl is a pointer, which points
  somewhere inside A's VMA to the location containing the message from
  B.
* Process A will deref the pointer to read the message from B.
* Once Process A is done handling the transaction, it invokes another
  ioctl to tell the kernel that it is done with this transaction, that
  is, it is not safe for the kernel to reuse that subset of the VMA for
  new incoming transactions.

When Binder returns from its ioctl and gives you a pointer, it needs to
know where the VMA is mapped, because otherwise it can't really give you
a pointer into the VMA.

It's generally not safe for userspace to touch its Binder VMA unless it
has been told that there is a message there. Pages that do not contain
any messages may be entirely missing, and trying to read them leads to
segfault. (Though such pages may also be present if there was previously
a message in the page. The unused pages are kept around to reuse them
for future messages, unless there is memory pressure.)

Alice
