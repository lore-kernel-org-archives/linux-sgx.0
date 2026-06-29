Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA268436352
	for <linux-sgx@vger.kernel.org>; Mon, 29 Jun 2026 15:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782746856; cv=none; b=ZsCFpGuUPOCDVxZwdK9sbaOkZ7W8ZmLnSWX3V1Vw04Q7x4s8xFEYNsEuk5HCdlzv18b7DD1lgYeHo5TSwIpEijRGbmUtN5sCgMdiwUKUMRpEXsczeAEXUv6SlfVYhhx+GALQb1+DfiHtBpZ2s7lnIlXNE3svdw9bP5wAvvHLfWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782746856; c=relaxed/simple;
	bh=S0czybLrYjf/ynP1kVMlwjsL14pOds5Rs5BBJNaJCXo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pUHjofw94cvgCZ59IJzzqDUCupj1QxxaxpBLZoG67LMDImTZdDI8EaUdc+aAK6XcpE7nREzTRH/vBEuxfmgWlZTawkbt9KvkPZANfn3dXglw+SmD+BFpnhK1QA0LQLaCeb/gTCrOEy1m91AOTcTnDeK1kmIkJeKF/EneYsfLOeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=YD4ldY6J; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="YD4ldY6J"
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-92e50a650a0so84128985a.1
        for <linux-sgx@vger.kernel.org>; Mon, 29 Jun 2026 08:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782746853; x=1783351653; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YVSnUoP7z1l2IjNO7QqWpl688BIslf+DGUxd2Ln6LGs=;
        b=YD4ldY6J9yYSngwoVnhz/rOLEfNM+a/QDH3N+mFU+kbbZbNNGaMSxOOMmCnLOAhX9k
         UPvcm/NDvNBkiffkqjJXPTNcQjgH8ZjtDe5QarFc2KSRhjvRuex5SwpDS4/S4NDHaUI4
         TrfYPXVIQKHe00dCaRIy+NqU6orKJiLqGgHxpQlUVqRHHnTmyKo067DpGBzaUU3lVQ9O
         6XqDD59n4np8Vd/UbftErbKU6Dvq3czt5Wx/pXSB3yKfVfENQ9Y+vXLgyeEcT5qaBphr
         O52YE4fYwfcWs/zQPj+id41/fNx48SJO9srg4qDeOXfbVNpd81DK03X4NrenRmLZo45O
         ziPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782746853; x=1783351653;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YVSnUoP7z1l2IjNO7QqWpl688BIslf+DGUxd2Ln6LGs=;
        b=NV+iM/LxVGrZD1lsYksq4UdN1WkaeoZ/5lvsNfk7d+tA+9pC3jZEwvunqWhsPXWxwC
         VoxfI5XGgxBJpbtKX3iN/DPQEmBPVK29g+Ea3cfgwSWO6j2Ae6FvEFLDe6aOOOE0WzQ3
         GCKnJFuF+pLFCjy4z/+l5XEN6kFEP4xlIeZr07YdSc01PdZSQbZo0UKkbz/g9vhWhDGK
         C23sU0oaY5m5IakS1YHkj3568njNZ5hbRoO3lsFdrpqjyF0ohiDOrwLO7eTw2XHBZbdE
         jr5zlsQmwaJet1vAN3D4oA6Skqxj+CcELCOfzK8+El57GTZ8qk65oRXPWDLOGOxs06Dl
         hE6g==
X-Forwarded-Encrypted: i=1; AFNElJ+XW7g+docd6cvK4nsf4AGoFIvPfaOIa9Ixt1yYzASvLzF5wthnKXZikqEM+lW7KLByJmJQ7118b5w=@vger.kernel.org
X-Gm-Message-State: AOJu0YyOenzK1Cctbx7aVAA5F7LIfEfOr9b5O5mE2cjaaUP6ab2Y5uNw
	6zf60sM+CCmVWdBBWQ7KYLOKth4LT5ZvwQ7o2pkcJb++nZWberxSMlHB5Aq2Kxb193s=
X-Gm-Gg: AfdE7cm2o/zm5zpcKX64Rk3N+545MoIi6Dvyu7P5Pw8JL+8/er6+brI6xsfhEs2eG2h
	4XO/PyziSJUZlu3Pp2DBaLw7pJ9e74y0OU16iQ89rXiP9NixrrNqqgkgrAi8MNOPqLBBfwXmreG
	06LrPznjBQBqqT69NKNPdqo7xylgA7B47sDqSG6CcI0twVMfCWV+1jDGqcFH9FG13w+0Pf8Pta/
	UK/auLthzahXRnoxITmPDmNqAohQRWP0hOm59hMx5NK/xTo3JGjz8Bxz3oAW8JaHlBUKR3JBHJi
	U/DvUNad7Y0NJU8NzFiusgUmtZKodfObG6bW/6bgKgq60DjOvG7y8g/FhWgyz8nPPt3FpkpY80x
	atTP5mjfwhN5wQW6cvF7MfxAnP6zBBcXdzXovzoZRAzVIZ/nAFKzo49mPiqavNm6BqFXS6hipQZ
	OZMnXe11NUgcpm+D2e/UcmqJkQnXW5w5ESg+P5dCaY8BSpIORkFTLhq+w9dhemP83R3Q6TFfspI
	i0CDUM=
X-Received: by 2002:a05:620a:7002:b0:921:9df8:d38f with SMTP id af79cd13be357-92e62785c63mr1415985a.43.1782746852526;
        Mon, 29 Jun 2026 08:27:32 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92e621943b3sm7429785a.19.2026.06.29.08.27.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 08:27:32 -0700 (PDT)
Date: Mon, 29 Jun 2026 11:27:26 -0400
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
Subject: Re: [PATCH 01/30] mm: move vma_start_pgoff() into mm.h and clean up
Message-ID: <akKO3vnNmWIJAZ7z@gourry-fedora-PF4VCD3F>
References: <cover.1782735110.git.ljs@kernel.org>
 <b28b698df4c009e85c4728446ca5863d8e633164.1782735110.git.ljs@kernel.org>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b28b698df4c009e85c4728446ca5863d8e633164.1782735110.git.ljs@kernel.org>

On Mon, Jun 29, 2026 at 01:23:12PM +0100, Lorenzo Stoakes wrote:
> vma_last_pgoff() already lives there, so it's a bit odd to keep
> vma_start_pgoff() in mm/interval_tree.c. Move them together.
> 
> These each return unsigned long, which pgoff_t is typedef'd to. Make this
> consistent and have these functions return pgoff_t instead.
> 
> Additionally, express vma_last_pgoff() in terms of vma_start_pgoff(), since
> we wrap the vma->vm_pgoff access, we may as well use it here.
> 
> Also while we're here, const-ify the VMA and cleanup a bit.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Gregory Price <gourry@gourry.net>

