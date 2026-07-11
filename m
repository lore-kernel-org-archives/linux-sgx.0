Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCFD82264C0;
	Sat, 11 Jul 2026 06:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783751700; cv=none; b=uSDqagBLneyuuMUSdBi6QtHTBHrD4PchsXKCEXxXNeEgrqi2hDeBRqQJHxMMbeDULtXcFs6SDdkdZSIEc5dz7ouPqV2PNXK97lNguL7zMj5s6t3t/DQenAHNeIE3bM3wh93sbc0sMHtskDLRIx9ADelhsOu9+iGGW7liQiurw0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783751700; c=relaxed/simple;
	bh=LcVpu5n9Px0aNntls5Ti5FkbgET7fFzrYzyLaRzMgKA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OnpGrt3MJV3iBzgqAGgnrzZ3jQk817B14BLTSFfYSREBIEFszHba3vsdJ0zTXQJCiomTHN88Tz/Cdy4UsRX7CNt2ndbwaHKaVfLOVMLWu3JHfMWDVOyAtDX3+th5xL91dU/OaK72Xdy4Q30b/psyGIJ9Cbe6TRq7y6Qs+fSppEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OSFAG2xz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OSFAG2xz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81E831F000E9;
	Sat, 11 Jul 2026 06:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783751699;
	bh=GJJhsK9UGkbC0fJg0T/BshNksgm9QoTCT4bawaC+z7g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OSFAG2xzhmr/8YQvg4NEImxF07jxqbUEEh7NwCiLHgeM7x3UggZev3LSdvaUAskdK
	 yMdFPgyqXym8+YxpIqdArYXwrA1e31glpfB+vT/AGy+UyHYaEl3EbzmDMBMqm6oS9S
	 rV8S1zftmc37pBGjvzyZ/9mf/PmAlQDTR2GR/5LsbXiF9Yys9XqwBQ/oO5Iu/PACIz
	 T34DpydP7RCQVGW7fAb+/e81YQv/kgHEj2uwBZjxXoCQIImeX4HjT8vV8otTJkUR3J
	 rJWAp3wgwbORSmHnmAU7zE5h3zYF3v1IbJdUxD0WIe4MXsxHGIBwL2tCYLpNTApr1C
	 S5LVbRXET280g==
Date: Sat, 11 Jul 2026 07:34:36 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Gregory Price <gourry@gourry.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
	Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>, 
	Pedro Falcato <pfalcato@suse.de>, Russell King <linux@armlinux.org.uk>, 
	Dinh Nguyen <dinguyen@kernel.org>, Simon Schuster <schuster.simon@siemens-energy.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, Helge Deller <deller@gmx.de>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Dan Williams <djbw@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, James Clark <james.clark@linaro.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, 
	SJ Park <sj@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Huang Rui <ray.huang@amd.com>, Matthew Auld <matthew.auld@intel.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>, 
	Shameer Kolothum <skolothumtho@nvidia.com>, Kevin Tian <kevin.tian@intel.com>, 
	Ankit Agrawal <ankita@nvidia.com>, Alex Williamson <alex@shazbot.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, iommu@lists.linux.dev, 
	kasan-dev@googlegroups.com, linux-sgx@vger.kernel.org, etnaviv@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org, freedreno@lists.freedesktop.org, 
	linux-tegra@vger.kernel.org, kvm@vger.kernel.org, 
	Russell King <linux+etnaviv@armlinux.org.uk>
Subject: Re: [PATCH v2 32/33] tools/testing/vma: default VMA, mm flag bits to
 64-bit
Message-ID: <alHjzZxfXOTMOC4I@lucifer>
References: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
 <20260710-b4-pre-scalable-cow-v2-32-2a5aa403d977@kernel.org>
 <alFewd7j_uiNP1Vw@gourry-fedora-PF4VCD3F>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alFewd7j_uiNP1Vw@gourry-fedora-PF4VCD3F>

On Fri, Jul 10, 2026 at 05:08:30PM -0400, Gregory Price wrote:
> On Fri, Jul 10, 2026 at 09:17:13PM +0100, Lorenzo Stoakes wrote:
> > With all of the sanitisers turned on, setting the VMA and mm flag bits
> > depth to 128 by default results in overly long build times.
> >
> > Reduce this to 64 - we can always manipulate these later for testing of
> > larger bitmaps as needed.
> >
> > Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
>
> I've never had a "too main recipients" error with my email client
> before.  Bravo.

Yeah I kinda just let b4 add recipients unlike the 1st where I trimmed. Any v3
will be trimmed again because even my usually super reliable mail client is
err... slow on this thread :)

(Apologies all for noise...!)

>
> Reviewed-by: Gregory Price <gourry@gourry.net>

Thanks!

>
> > ---
> >  tools/testing/vma/Makefile | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/tools/testing/vma/Makefile b/tools/testing/vma/Makefile
> > index e72b45dedda5..ef6cc558afe1 100644
> > --- a/tools/testing/vma/Makefile
> > +++ b/tools/testing/vma/Makefile
> > @@ -10,7 +10,7 @@ OFILES = $(SHARED_OFILES) main.o shared.o maple-shim.o
> >  TARGETS = vma
> >
> >  # These can be varied to test different sizes.
> > -CFLAGS += -DNUM_VMA_FLAG_BITS=128 -DNUM_MM_FLAG_BITS=128
> > +CFLAGS += -DNUM_VMA_FLAG_BITS=64 -DNUM_MM_FLAG_BITS=64
> >
> >  main.o: main.c shared.c shared.h vma_internal.h tests/merge.c tests/mmap.c tests/vma.c ../../../mm/vma.c ../../../mm/vma_init.c ../../../mm/vma_exec.c ../../../mm/vma.h include/custom.h include/dup.h include/stubs.h
> >
> >
> > --
> > 2.55.0
> >

Cheers, Lorenzo
