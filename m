Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99FE03B9601
	for <linux-sgx@vger.kernel.org>; Fri, 10 Jul 2026 21:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783718653; cv=none; b=PhHUZR0aqWxPwWiNQxhxzmDsK0xvofIpuHdzHJjLxgELRZuAZ4H0hzqvliD9aOZBvEpkartXNNm6eEXCKGHlk6yblXMw7QnqtsRx32ayPTn4tjfn7GR2R78wdrEg+0BggOt6nFRg5eQtqYW9vYnUMrCKwoDJxXUvEsMHjdZjZPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783718653; c=relaxed/simple;
	bh=Yv3pRZ4OX8PGYFLQCiz3pIFR252YmyQ+OnNGPLtq1u0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rCjsGxUHlvG+j63pymij6yPH3T2wDVjP58BugKGdNfTnM4OF7B/OnTOcFkeKsa7F1bMZPEBtnW7YGxcHmM88Sh4LnJODSy1Xi9nYYgBzgbb/FJyKgqkOfX1KIvhsSi6NdA1JJF6elYlwD8yumHuCwlIjGFMiSDc8cz9Eq+2fvLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=FL0K6NB3; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="FL0K6NB3"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-8f1e274ccb9so8114736d6.2
        for <linux-sgx@vger.kernel.org>; Fri, 10 Jul 2026 14:24:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783718651; x=1784323451; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hyoj4hjMSeCH2l8wiR4N5JqU7D2zu2bS+BNg0w05A5I=;
        b=FL0K6NB3hTo1xsdzE4NyALnsu64Ws+e+cSv71NFPTjSIJJhJ1lUMN+qQTXWyuIJWGm
         /m8gjRDZ8G9j7ziZ4jGbj32iS95QtRTsFqbZaJGDm6HyW9ScRB3knNPq6mVxEfTNXuGA
         lv2X/ccQX63tMmcZtGil1iChHRYYZuUY8SBq3xJprEVTwhW4fBN3mG2/WbEj1e/k/S75
         QCHF+djSBHVVuXnTdMXSV029iIL1Cezyv3VJT5Q5oi+D4MPA4bMUdpqFo9tJPO/CTgTA
         9yBqcMofZpygCKqEZ+FKogDFNfv421Lg6VfGw9fE+So36GtIL2zEzgJY+X1FeL2KjS7M
         EGoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783718651; x=1784323451;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hyoj4hjMSeCH2l8wiR4N5JqU7D2zu2bS+BNg0w05A5I=;
        b=G81UAAS+dOfwR+hFBwvXh3WPujpgSgdOKeTHiYZal0J/87ZQ16yDqLchdiNO4w1fFH
         gWqxEvJAJs1R9MXN3tFFFysHjequdWF46CQu9Ts4g/NRvkWMAKCpNL0KH9u6NbXlYe43
         dA+fdeQYmonNFOH3v0s49GtXJPLO3RFDWBok6QE4BvH5dJgJKkOjc5ABshz3t9O9+4wl
         wgKOAwoGnZkSdKdI0CQW2eMJYtRfZGoB0JokC32L04rYLsCKiQ1GW7mVMcB9tescR1AF
         VrJtLHHPnAWe5kAXHs0jn/tBwHkznn6dDv8wElEcVZ8lvG1qLuMfNJlUJ18uHFgP5qZf
         FqtA==
X-Forwarded-Encrypted: i=1; AHgh+RoL5WnkIEJxIjATKXbdr6DSTDMXjuQ70h5jtK3lWNJlpcSA3XeoH8LWtmMk1GT1uHgwE4zaGxvr09c=@vger.kernel.org
X-Gm-Message-State: AOJu0YxlVB7n1rouF0kiBf7sSbFMq1orIi7wvUd4DJQJmP2Mhbo1NEw6
	HdmsCRFAaT0sH82qn/w7dq36aP3jMNinDl6tzYwYa5+EqEJgvy/2dhgwgqgxUIKAMxk=
X-Gm-Gg: AfdE7cmOcIctNENEMragZt33r/zuHIiLNn8xmLho9jLYI4POaWW+dWcfPu6NCsPEtgM
	1JKg4a1Y8jRNa73muS0ImQoXnfL3JF7VikpyT8KtFqHz9JsKccsjsLHU7g4baWMYtzGHgYv/jG8
	ZgiZBeP9VCOPNf/5ioEQMg0GsICsgnFYFL54/HOGeummBqchKW0s0Qx1yVaY/ghVnymjOYL4UNu
	yYdRTwCffAmCm0cJSnM2KkXAdVK4yPOh0Y4KQLVQK4iwditOssrQXMVJw3NIvW4p5+HHADsTB96
	2YayouK9VsDoZJ1vybaaNoJv/Ut8R9W8RSUWndO8xhAWsQRRzHgiSBDhLVdFWlSgOqAXsj/x7ND
	jH6XNqZVIj2+SXLi4S0FHmM+EBg+gRjRL3GRYRNPuJliuJyThqAlRxOXOidBtaHYk8CzDlcUAml
	axVPXqonRHTyOJ/ugF1QaFbmKgDIMOlADJUax6C7ulg1QJxY7L2oDQoVYZ+UJFCZTgN7lg
X-Received: by 2002:a05:6214:5b10:b0:901:730f:5eab with SMTP id 6a1803df08f44-9040038208amr9843886d6.27.1783718650605;
        Fri, 10 Jul 2026 14:24:10 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd82e9d5csm50431486d6.41.2026.07.10.14.24.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 14:24:09 -0700 (PDT)
Date: Fri, 10 Jul 2026 17:24:03 -0400
From: Gregory Price <gourry@gourry.net>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>,
	Lance Yang <lance.yang@linux.dev>, Pedro Falcato <pfalcato@suse.de>,
	Russell King <linux@armlinux.org.uk>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Simon Schuster <schuster.simon@siemens-energy.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Helge Deller <deller@gmx.de>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Dan Williams <djbw@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	James Clark <james.clark@linaro.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>,
	x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
	Ian Abbott <abbotti@mev.co.uk>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	Christian Gmeiner <christian.gmeiner@gmail.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Alex Williamson <alex@shazbot.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-parisc@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, damon@lists.linux.dev,
	iommu@lists.linux.dev, kasan-dev@googlegroups.com,
	linux-sgx@vger.kernel.org, etnaviv@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
	freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org,
	kvm@vger.kernel.org, Russell King <linux+etnaviv@armlinux.org.uk>
Subject: Re: [PATCH v2 22/33] mm/vma: introduce vma_assert_can_modify()
Message-ID: <alFi5J3-UQtvTzxV@gourry-fedora-PF4VCD3F>
References: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
 <20260710-b4-pre-scalable-cow-v2-22-2a5aa403d977@kernel.org>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-22-2a5aa403d977@kernel.org>

On Fri, Jul 10, 2026 at 09:17:03PM +0100, Lorenzo Stoakes wrote:
> vma_assert_write_locked() and vma_assert_attached() are useful for their
> own purposes, however VMA code absolutely does allow the modification of
> non-write locked VMAs if they are at that point detached (i.e. unreachable
> from anywhere).
> 
> It's therefore useful to be able to assert that a VMA is either
> detached (modification doesn't matter) or write locked (you're explicitly
> locked for modification).
> 
> Therefore introduce vma_assert_can_modify() for this purpose.
> 
> While we're here, make vma_is_attached() available generally - if
> !CONFIG_PER_VMA_LOCK, then there's no sense in which a VMA is
> detached (vma_mark_detached() is a noop), so have this default to true in
> this case.
> 
> Also update VMA userland tests to reflect this change, correcting the
> previously open-coded vma_assert_[attached,detached]() there.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Gregory Price <gourry@gourry.net>
