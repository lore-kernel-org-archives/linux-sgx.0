Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEB56421885
	for <linux-sgx@vger.kernel.org>; Thu,  9 Jul 2026 15:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783612249; cv=none; b=drf5S0aiQb32hVVi00TExeA+803GtQ75HmYr9Ti9ZFQ91lCvuPHMHtlXM+oPleOzL+m9M2zA+7E6XrSdJSO4BDb9E9TVDTdx9H+stY2oOKAJqVdHVVJtEOjlnZ6opc3JDyMeF0X0mZ7VJ4dP6MzOFVcoDEXNUBPKrg9Kce7SzPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783612249; c=relaxed/simple;
	bh=ooFqL0kdzm3Mqvprf/ktKH8mQbzOh+NePJH/rGI4MOY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TuPqacRz8n2bmt4Q9zuqTIZjP8+WJEkE0O31ZAKtRlsiOzNmjtvHw5oYeyJdlu+ysBakeMYkuOh5FIYm6rckk43w/drtD4e6p0lWj3rdtExG6YDoERI9OZsmbOutAeaeGlnB3WJ2u7ip7AF4SnuZoMppf/4JCj4XePoVakB2a3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=ICpnBr24; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="ICpnBr24"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-51c0c45c580so15065341cf.0
        for <linux-sgx@vger.kernel.org>; Thu, 09 Jul 2026 08:50:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783612247; x=1784217047; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4H58DRU6wxIzBQ0PfS3OOFxFy6X9tDniNwjExlFI+ak=;
        b=ICpnBr246mLQLo6J/c6CeHFuXpKGWS+yv4AMt5rkdjgStwdTQfBJeXld2RX9OS3KxS
         T1XZ0CZwHP2uMMpYQIu2MKkeDygOdG4vvodfYMESBetFa3AfxSeYFwNvlLie36mOY3Pe
         R0zqfTMG7doZsH7uhykqwy8Nm9me5EkINJlDDHbizdvgrmWeujiQ50g8XcevN63m9l//
         5mkwF44uINVA+qtg/OwITJbeeF57OE3ZcrBkL7593XeWfd2UC2z64c+0gHv4j6EjbdwG
         /lRYBkU5BmTRVIw6iDSpw0UC5XgIySiXza1IeRpgrqXZdoRKJ7ISY10E+5yfZZzerBSO
         5HLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783612247; x=1784217047;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4H58DRU6wxIzBQ0PfS3OOFxFy6X9tDniNwjExlFI+ak=;
        b=h21CLK6eXOjBwlMTgK6DdYGcuBKAXVkGW6mTNol0VAi3/S4WAZ2qEyeygEuLiifq8A
         0BgndHVCis9+4XOAaYy3Bo5bDhSzU9pUhjkTjdxxt6Gev7ZKarO5ATmqWVCt3LU1qTBm
         fT2xBh1McUkiCQJv3pX/olmTCkqGqV405TP62I4td6dZt+T16GVhOwGpZuxPrGzjddN8
         j4uktUDw9sCvBof0Wo+1dn1YtCB12XJ3zHCLUx8nxwJgtDGh6qeVI8AvGIeLXVEce0H0
         5VJWSgV+bRAjDCJsuIdXAOtBa2Iq1kA0cqaN1kwTp1MI276YEIRq56CKMzpiIvuzcMix
         GmfQ==
X-Forwarded-Encrypted: i=1; AHgh+RoOWLSGl9NSXjat6EuIF860zZF6mfL8z1FLDGcvpYhK0see43p3ypproA/nOZRtDQQ8YnbTsWKAegQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzWJ+Bp8Dolvy7eQkhOxrm2nSnmVJPA12AjJugJ07nGqkA/HueT
	y90ZewccX7CrxJqEBJiQYa3CjEZ4qJ3D1EXnpHKxt9HwUnYfCarQ3MRpUYAxwftAzq8=
X-Gm-Gg: AfdE7claPAT15+yaIdbWwT/E4SqaawIQiOVCpi/UsBVaX72esecnIdN2ZjMsNERSDaN
	zBlQ+czdLK87bKwfo9jWDR1qRHUl/8weLqzWKPrV6vtdmk9x5ndFt4m/iMFrP9R7LWyFD6/+aQx
	SbKOjXASGILhytn/+ztgWs5yD4gdEJWii7DabYJMR3PSkJ5bMCPpVS31/NF1XAPCVbhY0klb9U5
	FSWCF6yMXpFD9RF5R3nUl2ZOLO0TAtk9mcIzIZfdZG3dtrusls9bAsCMFkkOjAHCc9Q9JR8KW/W
	fVImQjyaj5xWYAYaZ1eAoky5pksi6F3hl/9gCL82oQUXmqpcy0JbtUnZ4X0wIlFnFghxd2yNPv+
	I91bMTpWfV3DINKgPGMUeF0pfy7J7VtZIjhCy3HI1nlnuQ8I/YcDpAq2n+SaBUvUmNXFzYlD73f
	s8IpngWlKhwlRSJGmKTgGGno+/gx/TBsLbdZ4MFLQPQttflQnC37wzef8ktNJ62HeXuNJ1
X-Received: by 2002:ac8:5f0a:0:b0:51a:8c9c:7f52 with SMTP id d75a77b69052e-51c8b40a675mr79940341cf.69.1783612246884;
        Thu, 09 Jul 2026 08:50:46 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51c4202366csm161049781cf.30.2026.07.09.08.50.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 08:50:45 -0700 (PDT)
Date: Thu, 9 Jul 2026 11:50:40 -0400
From: Gregory Price <gourry@gourry.net>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
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
	damon@lists.linux.dev, Pedro Falcato <pfalcato@suse.de>,
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: Re: [PATCH 18/30] mm/vma: remove duplicative vma_pgoff_offset()
 helper
Message-ID: <ak_DUDt-1tb-V3b2@gourry-fedora-PF4VCD3F>
References: <cover.1782735110.git.ljs@kernel.org>
 <10671c2fc5d0dd4e3bf497181923e63e46053df1.1782735110.git.ljs@kernel.org>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10671c2fc5d0dd4e3bf497181923e63e46053df1.1782735110.git.ljs@kernel.org>

On Mon, Jun 29, 2026 at 01:23:29PM +0100, Lorenzo Stoakes wrote:
> This is doing what linear_page_index() does, so eliminate it and replace it
> with linear_page_index().
> 
> Update the VMA userland tests to reflect this change.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Gregory Price <gourry@gourry.net>

