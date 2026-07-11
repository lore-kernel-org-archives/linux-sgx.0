Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 318932264C0;
	Sat, 11 Jul 2026 06:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783751600; cv=none; b=MGEn2XOdUtZGEZv/EI5qpqFiZEcubQuRy15IpafqOc/34qXanRYWgVTR0AQXtiPxwCcdImBfFpsEBDb9guDxj8U4lN7N3xUDFk1hIwRiE7FwNRD0RELwOuzku8S7fD2MW01e8ZXgiUD8yKjJxuUKROOEdjD/vKdctymyJI022Oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783751600; c=relaxed/simple;
	bh=IhuKekt2PQXuM2aC1ZwPWPJ0ZHIWcPpVLch8ZcQ+oPU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f9xD4M61lWQACoZT2MCw2gsU838xsqH7WukoO8YINH9E9ld6h/sBYYKp6pG6XzNDIBqHjfyx4d+DVjRpNlTIPRcEw+zQsRi4k5u0ZBfQUahoFf4zg8k74qlPYkTNO8VXns6sYnWvUgwGcJjhAow8ICHaOKyNP9eOI+4hNcO6XEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EPG2DeF4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EPG2DeF4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D80AA1F000E9;
	Sat, 11 Jul 2026 06:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783751598;
	bh=IhuKekt2PQXuM2aC1ZwPWPJ0ZHIWcPpVLch8ZcQ+oPU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EPG2DeF4UTCSaR61iBwMXCgHQEn643ddtwajqsHEeGX2acXFY9ki43vFQ7gy8Bl0W
	 BuXOW3LXg2kAEBfh13Hs0ZYMFR91r8JsrHpYYyQ3iVnNER02xUYKPYy+XAphOKNsC9
	 WxQoVUhR1TUlCSyiEB/VspCyJtQW/GzjedFjyCgZJPJ6Q/gQG6rVW2boHGQqSDe7fZ
	 b4ZROnX7C4o1b1i8MbQJXaxv8hBq+sorHlvvkjlhjEhEf1cNal0kos9Dmx4MMB3uPX
	 +caq0W8QPJajr44BSXmfelnlwPZUxmrKpz84RfDbyY5pbBa8+xpkhUS3UCT0amuC6h
	 49Cf5nI8dBADw==
Date: Sat, 11 Jul 2026 07:32:51 +0100
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
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Hugh Dickins <hughd@google.com>, Peter Xu <peterx@redhat.com>, Kees Cook <kees@kernel.org>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Alexander Potapenko <glider@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Thomas Gleixner <tglx@kernel.org>, 
	Borislav Petkov <bp@alien8.de>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	Huang Rui <ray.huang@amd.com>, Matthew Auld <matthew.auld@intel.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>, 
	Shameer Kolothum <skolothumtho@nvidia.com>, Kevin Tian <kevin.tian@intel.com>, 
	Ankit Agrawal <ankita@nvidia.com>, Alex Williamson <alex@shazbot.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	iommu@lists.linux.dev, kasan-dev@googlegroups.com, linux-sgx@vger.kernel.org, 
	etnaviv@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org, 
	freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org, kvm@vger.kernel.org, 
	Russell King <linux+etnaviv@armlinux.org.uk>
Subject: Re: [PATCH v2 33/33] tools/testing/vma: output compared expression
 on ASSERT_[EQ, NE]()
Message-ID: <alHjL4lT8WLrJ1uj@lucifer>
References: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
 <20260710-b4-pre-scalable-cow-v2-33-2a5aa403d977@kernel.org>
 <alFfopehgN0dkMzM@gourry-fedora-PF4VCD3F>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alFfopehgN0dkMzM@gourry-fedora-PF4VCD3F>

On Fri, Jul 10, 2026 at 05:09:54PM -0400, Gregory Price wrote:
> On Fri, Jul 10, 2026 at 09:17:14PM +0100, Lorenzo Stoakes wrote:
> > Update the macros to output the compared values at hex for easier debugging
> > when test asserts fail.
> >
> > We have to be careful not to re-evaluate expressions as they may have
> > side-effects. So update the code to take local copies and use these for
> > both the test and the debug output.
>
> Aw you found it before i reported it :]

Claude did :) I take no credit for it :P I guess I thought the re-eval wouldn't
be an issue but obviously when it's a side-effect and the userland tests do do
that, it's very important you DON'T re-evaluate :P

Human 'meh that'll probably be fine-ish' vs. robot/Gregory laser-focused vision
doing the whole 'Sorry Dave I'm afraid I can't do that' ;)

>
> >
> > Also remove unused IS_SET() macro.
> >
> > Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
>
>
> Reviewed-by: Gregory Price <gourry@gourry.net>
>

Cheers, Lorenzo
