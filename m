Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C1B33B97A
	for <linux-sgx@vger.kernel.org>; Thu,  9 Jul 2026 15:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783612169; cv=none; b=ive5RTeeY9BYVkHaBncxA3EYY/nHE+TTP0AKWYFcYNxKzozbnhxDVSHD+DRBeL4kCg3oZpRmNe4D6AKslSVb25qpaqWkqvcOnTQmkdNsOUhVNlAcqz6Xc4LyM5wjDJiF3GbJygfpOM91QHxa7hRXIuIuBI5Z1OI8v066E//N82Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783612169; c=relaxed/simple;
	bh=0qkqAHRaBHgpB2UR0C6dAMPOVUmsbtzeoEt8MNK67Xo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q36yZ3StuIXiXxLqV85jHaVBxzqMFO4QOG2Od6PMmCgN2Jo6f3mn1xVOs+MGUuDyNCu9vMf368c5SUlhHN0VX1P+hnqXORLEWw1z1AXL4bOtkp3DjrOubK0jZPUmUrP0VT5HRwxte9PROvV1RoVbw8aZ29zNl7Gz7y3osE1vhDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=MkQCpSd2; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="MkQCpSd2"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-8efef6533aaso436056d6.0
        for <linux-sgx@vger.kernel.org>; Thu, 09 Jul 2026 08:49:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783612166; x=1784216966; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hryUWYzOZzjuIh9gJx+Hzg+n+E360+tJZh4R7BZGeLA=;
        b=MkQCpSd2m04untsXU1nx9KbvtduhWS0cCQoIcza8A3pVIhVf9PRW/CsEN/DZAtCuls
         p7RoVeKsjloxBKU2AfxnCCAN8lhXWQBNDMfPG7gVZRfQmXhyKackY8MGGcFAEPPVy0Fv
         SDU2e8AQxkDk3sY44SjU+DAZTvcrqgnaYjF6Y4p8tOSybH+22dFesBK1qZJowyT//dMI
         6ZToGGs97IuDvRPOGP/+9UTODYx8cfsPo8904OY1zAoe+0Q0w2DVPfcKw8nstjaGRKyi
         ELgcN2ve0gKuNONy45AfjzXvUlPyOrsp6pJgUy/3Xnn2gf7Puzf5UJmIyCvxOjIpgVPr
         CZNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783612166; x=1784216966;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hryUWYzOZzjuIh9gJx+Hzg+n+E360+tJZh4R7BZGeLA=;
        b=ItwOJZlo0Ynu9gE13iCi7y5Jv6Se7ALxCQwaHch40BYKWqHAswmCZgCG0e1Ukt0BDm
         64dfk4aAxRGvO5vI+grUJUarOvtpvwa9sfYAsgKBQdSLKSXXyJKHlsqyWgPICWIXgZrZ
         QrnjdLJ5xiOuAYqrQAKf6zU/ThqOQ/Lqw90ILxNJfsb8RanxR+zMRomnxidg2OVVPZxw
         eAJZeWLu83cPNwg9iZybtZfJ3waRiz/JkIRJu0VdAY90lBXCHeGsn/BqaojWc9wq/0nM
         e+9dIsAejrYErmJ7AxVlbWwbMgQo0Ap2SYxgyyB1CG2LxRXPSwTmd7yeAMO1bKvrBV74
         jxuQ==
X-Forwarded-Encrypted: i=1; AHgh+Rqjp3tFnFWHO64YaCJGLLayAugM4GYupqbcuDl1mqf7ec7ugPf/5UzPL9r+lZFo7vp1JZbY0y1//AM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzIWvSL787rV2qUp7OO+hA7AuBgPaMpnJ7N0zVkx07VFwC19hVc
	cLXp1gknSvOnDWK6p59XeXA0nO1V+wc814k42Y2VckqZn0HzgVP/4tcP/H2BMO1gPq0=
X-Gm-Gg: AfdE7cn6/YRGewhlNXfpT+8kMLLCAMsn3qd+lZjjuQZNev/eBXzxlHA23MLLu8cEVwc
	YWv1xvjgk4GpB6gH0jWhOeLTUvIMGK+j6qxHALyu5y4U8Dnstdw9thWg/dZt7yXhtyT7EgQdE9u
	zsOpyU3q86o4jmJzfXq+pixsBSKuKv9Y2sMa6Qh0YArc9eEyy6Unb734PkvvFxL+Iru8ScLV3ck
	JuS3TzGqYodlFaJR5Xepl4HGPsmjw1di9ZfbqvK0kLHmpgXmY85P+bTLuA0i/kYkBywi0UvljKE
	MiV7wji/+J1JYJdmyhUiI2WE1D5X7Ajam/Yadxmo4+HibxN3kz+tgrypHOTvf17wAlvCTzi04XD
	RY4fcQ/HzcYoqhS7kdVa1xK4T4qu/Z7ORsr9aIEvNkYx13jKUcwr8vmoaapIt+F3bWobhhKa8n0
	r6l6ys60hWxUsOMyNipP3NdyLGboWx/2kM/YlyVN8UUw/tXBhBsje2mNYRH/wUUIMxCFg3
X-Received: by 2002:ad4:5c8a:0:b0:8cc:2a92:48e4 with SMTP id 6a1803df08f44-8fec217b8bfmr87997286d6.32.1783612165998;
        Thu, 09 Jul 2026 08:49:25 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd7c1d9f6sm20164456d6.23.2026.07.09.08.49.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 08:49:24 -0700 (PDT)
Date: Thu, 9 Jul 2026 11:49:18 -0400
From: Gregory Price <gourry@gourry.net>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Russell King <linux@armlinux.org.uk>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Simon Schuster <schuster.simon@siemens-energy.com>,
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>,
	Helge Deller <deller@gmx.de>, Jarkko Sakkinen <jarkko@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	Ian Abbott <abbotti@mev.co.uk>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Dmitry Baryshkov <lumag@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>, Ankit Agrawal <ankita@nvidia.com>,
	Alex Williamson <alex@shazbot.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Dan Williams <djbw@kernel.org>, Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Matthew Wilcox <willy@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>, SeongJae Park <sj@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>, Hugh Dickins <hughd@google.com>,
	Mike Rapoport <rppt@kernel.org>, Kees Cook <kees@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org,
	linux-sgx@vger.kernel.org, etnaviv@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
	freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org,
	kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-mm@kvack.org, iommu@lists.linux.dev,
	linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
	damon@lists.linux.dev, Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>
Subject: Re: [PATCH 17/30] mm: prefer vma_[start,end]_pgoff() to
 vma->vm_pgoff in kernel/
Message-ID: <ak_C_o2ehS17Q5HV@gourry-fedora-PF4VCD3F>
References: <cover.1782735110.git.ljs@kernel.org>
 <ea87349d63205bf4c26ea79854f179a9bf8cfb0b.1782735110.git.ljs@kernel.org>
 <akZCg73F-oGzDp1a@pedro-suse.lan>
 <akZGqclqQ6gS12Vv@lucifer>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akZGqclqQ6gS12Vv@lucifer>

On Thu, Jul 02, 2026 at 12:30:59PM +0100, Lorenzo Stoakes wrote:
> 
...
> static inline unsigned long vma_offset(const struct vm_area_struct *vma,
> 				       const unsigned long address)
> {
> 	/* Retains page offset and tags. */
> 	return address - vma->vm_start;
> }
> 
...
> And I'm not sure it's really all that useful. Perhaps retaining vma_offset()
> would be though.
> 

Silly question:

   What's the purpose of retaining tags in a non-address value?

That sounds like there's fragility just waiting to be broken.

(I presume you are talking about things like ARM MTE and such, right?)

> This is one that I think makes more sense.
> 
> But in general, I'd rather hold off from yet more churn here.
> 
> I'm making these changes to establish a basis for virtual page offsets
> introduced in [0], rather than just cleaning up in general.
> 

I agree with this.  If the refactors here suddenly have to think about
corner cases on things like tags, that's better resolved separately.

~Gregory
