Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B36F53B38B9
	for <linux-sgx@vger.kernel.org>; Fri, 10 Jul 2026 21:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783717805; cv=none; b=IBrtwI7j5QOgEH/t91AK2oE8EERyLK6A3bNBlD4L0hrz4MCwUZnMySp9cw+0p7JBXJ/EeU4WwgSTuFkqo3h3JLBWmyyfbwQHyRwfLjlkPWtqKTxFPrkgbbw+bP1n3JiEysFNCfZ8yPK2x17t6gJx3584sYTfOp2TaKoIT6Y0IWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783717805; c=relaxed/simple;
	bh=dNW60Nn0Pk4RAFrYvjK4f4wy+wh7S7nAq4Uli4yrIhU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iX9zYNYTce/PSyz478ATLA9YtJAo7P0s2J+n1smCBv+Z2MUSR3OI3fXTe7CYAj2L22rEScoGaucCTcb5DFbljzEbBuJCztxx5c0U50mX3xe7eQJx0O4uVIntyYgiLzlI39Cg944d0x9ggYrAmSUt4J/EjelGzktU1CsuIeQ24Mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=IeOfG/44; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="IeOfG/44"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-8eeadbc5e21so10662806d6.3
        for <linux-sgx@vger.kernel.org>; Fri, 10 Jul 2026 14:10:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783717801; x=1784322601; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FM5wmgcpnXqQ2LPOtHbLfNIfX5IHSF2YMfcySjsQd8k=;
        b=IeOfG/44lUDhZNIy2n53/oJ2urnUwg/8zqSNAqnWhDDzsuc2hRT/2MJ44iW3PIUUdY
         0cKCLWB1ldejcRPaxLKKE2HNwwb5n6ERzHg4JGWFDufdCh56F770PixKeR5QwDzQznz1
         Jmx/9iGCwJs5BmrWXg5kE7KtFI3LPyXEmWOGL3lAh64raZt3/H3BRH4jM+3Ckk1pq0gS
         AVdCqYlgpu3IdxLLPaWkz2qyyo3FTRx6zjiABH8qF1KwW2Jm/HULxy3PrZTkOXDKa4ZT
         b0yZMAD13765/Yo1FNsj9VMVnFaBJKi3QlTJITHTFpoqoSFecjMGs9mDCknxy9BlA7ql
         oyTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783717801; x=1784322601;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FM5wmgcpnXqQ2LPOtHbLfNIfX5IHSF2YMfcySjsQd8k=;
        b=cgN2AkcQYvRNDoVGxUBhf0IZ6owIvWW/ieuNsKGbAHfDoZr3vVw8dd19Qgc1PdE98s
         NS8zTdLkWJa8NctGVVZXizvTVx0d0vp1+YwAxL4BHtk6iyX6gPpuFLJw2y3/CL4qityb
         ZaHXJZwA5V/urQGWkIcqwJJZ3pQwE2BOthdEgtBkxvtsoavHhMbUNe1sFP264KfbJvuy
         acSKK6tBYGWwaew3I7HLkNttWaYdW7p8ci0kEdtQTJDwILwljvTPew2t1FqS6tWJKr6Y
         6tikC3WYf+S/P2z5P4PA3NJEE7UCIc4QhLeRgQPkiyWKr1yL8t/36+241Q96qvhecpI9
         vQjg==
X-Forwarded-Encrypted: i=1; AHgh+RoVm7sF7eZR6Odg4u52UXhM/B0Md0F6dyuSkDAZRH/xGRVfXhsc8EJM6cABpz8S9tT327ni8y6ujs0=@vger.kernel.org
X-Gm-Message-State: AOJu0YxnE4Q8vFjJJO+WOZKmxyn+sw95OtqwjAcK/u0Q6tUBNQEyw7Q1
	UAsd0vhVJjYKorz8k5GB74tilr5ESTHxN5hpD37hW1gmenT3vh2zb61P1r251w0Sc4w=
X-Gm-Gg: AfdE7cmZNxTQ+Kwa1wsJYiBbksmzMXxTK0nwwyM85Amw+eYMebw1tghEVyHy4MX6QWX
	Ol3+xyjOanyhd4e8Y2JVOQUUnNcDTLdCB2i1FHovp/9cPVIEUEtLGxFyefjYPcFwaouw6/KhRC/
	epMRyF/7yFc3fhH2Yc6oGDYQWsZKc9uAcsfqFaBcg6gqaWT9gG1s0Sc4qIfpjODA0Q6q9Z9QCXa
	S0UxDfU/qLxvstaTj6WGlwaJx7mnRMyIxk/Y3/S3cTy2ItuzyRT9ScW1NUvb5M27bSy3AdQLxDE
	9Iew6ROKeigbi4hwOULaoycB5Avjykih5y6Ey7G/qM+3hsvyi7hj88AbKv3p9wWaHCr/uZ/y11X
	PCAvswuToxDasBz/TrVtGdUQPl32VXuW6I+wtW4/yCqugz1Cx1Dp/sAW9SnASU+3Ls+mtA5qYwk
	3Zio/mT6HnfQ5KnfS6U89+KaWI91qFg8Rv2o5k6Xb6HPVZDqqfWhFHIm+o8WlnMQIdtEWb
X-Received: by 2002:a05:6214:31a1:b0:8d1:d1e1:8360 with SMTP id 6a1803df08f44-90400b7f3e1mr9010646d6.39.1783717800595;
        Fri, 10 Jul 2026 14:10:00 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd87c8d4csm52955776d6.44.2026.07.10.14.09.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 14:09:59 -0700 (PDT)
Date: Fri, 10 Jul 2026 17:09:54 -0400
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
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>, SJ Park <sj@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Hugh Dickins <hughd@google.com>, Peter Xu <peterx@redhat.com>,
	Kees Cook <kees@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>,
	x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
	Huang Rui <ray.huang@amd.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>,
	Shameer Kolothum <skolothumtho@nvidia.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Alex Williamson <alex@shazbot.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, iommu@lists.linux.dev,
	kasan-dev@googlegroups.com, linux-sgx@vger.kernel.org,
	etnaviv@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	linux-arm-msm@vger.kernel.org, freedreno@lists.freedesktop.org,
	linux-tegra@vger.kernel.org, kvm@vger.kernel.org,
	Russell King <linux+etnaviv@armlinux.org.uk>
Subject: Re: [PATCH v2 33/33] tools/testing/vma: output compared expression
 on ASSERT_[EQ, NE]()
Message-ID: <alFfopehgN0dkMzM@gourry-fedora-PF4VCD3F>
References: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
 <20260710-b4-pre-scalable-cow-v2-33-2a5aa403d977@kernel.org>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-33-2a5aa403d977@kernel.org>

On Fri, Jul 10, 2026 at 09:17:14PM +0100, Lorenzo Stoakes wrote:
> Update the macros to output the compared values at hex for easier debugging
> when test asserts fail.
> 
> We have to be careful not to re-evaluate expressions as they may have
> side-effects. So update the code to take local copies and use these for
> both the test and the debug output.

Aw you found it before i reported it :]

> 
> Also remove unused IS_SET() macro.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>


Reviewed-by: Gregory Price <gourry@gourry.net>

