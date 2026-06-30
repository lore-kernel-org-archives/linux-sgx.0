Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54E15466B59
	for <linux-sgx@vger.kernel.org>; Tue, 30 Jun 2026 15:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782834920; cv=none; b=JG7TJjPwugybd1RL1iPLBV7vClMowCDYL3G8Oj6xxep3DqajMvhlc1cWEPuHE1d+INycwcymDkbko0eBWcOvPYt7SXHphr8aemF/nBbjLRG/tkz0UEGdodoGE847ImeUA1VMCYJWOY5b7EO5NpuAXaHuDFFsROFsMZbal082BuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782834920; c=relaxed/simple;
	bh=q/CdBZIJ6A6qBJyymYNRI6oVTAoCPywZ7vcualAVIBs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G3kM8bVfJvmuEKXdWUzzH9dgwtguZNquDrWG/x/i6HbMHoQU7/n2ZdZd87XuboTfCC8EV9gOv4w1SZHWl8M5dXqeds/hS/IyZM0aqsQf668zP/mJo1DdAllAnUk05i1Xz4uPu+4ABmIsJiojFcQnXliNmAkOPRBEvpwnSXLnxY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=hAXgfuyB; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="hAXgfuyB"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-51c1d487f2cso3267301cf.1
        for <linux-sgx@vger.kernel.org>; Tue, 30 Jun 2026 08:55:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782834918; x=1783439718; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BHpENWZilS5aqo8aP9kraE35F/fs2tmonTK7cFttpS4=;
        b=hAXgfuyBmNSRLBE9y2YF+F07dfSGqHp1xa4sOxR62JYnFeKn0O8SVUpt0MG/md/bBA
         JctoHB5oCxWZ0Vqte8bR8RSDqbwrPbLPyAVhB0DByHbOdA2IOjZEXwL28LDk2LiqVjrv
         z7cG0BHGgqC45FdoWw1cu4SJuJyQa88fRtGXXXfw7jyqkOqfCXplQUZeMMFCZELfo79Z
         1rk+m2RY+h+2uqsjj4YAZSp59JxW4a4ytdwsdrD3N7DKSKtyf+EXlgO8ty+/hiKhPyOz
         5gPFlMDUP1DBAOlIJqYE17f25yvB/zUT9IPprAkfMavu6WBQtA17ghH9sjittg5ZdSha
         jlVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782834918; x=1783439718;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BHpENWZilS5aqo8aP9kraE35F/fs2tmonTK7cFttpS4=;
        b=TIbgxlXk1oAW5Dk0hgirJJ6uHgyggKbTMgs25nHAHlBj+YgnntjgR9TbYQB1gJlQLI
         SL55VFH0S2v+VpI0PAfaUyXxulV/Q+JoFvwCymahYH6ER4450DIyog6kx173tcXhlgDN
         jZdHxsQUUo/Ntl74UzRfFA4X64d1CtOl+D03VdT192cuPQWtdETitujidHjmLpNHUs8w
         qYnC2ibwkaY4E71Wp+loerCTCZYJ3boOPYYmzS5Vk4aEyCtgMfKy+3/+d5eldV30UMuI
         oimjnz8UaKUGV/28sgDQ+kCb574xMRq2qyvFH47RUd45tZHNGaZOJLOa6pzSYRZ2hMZR
         a/iA==
X-Forwarded-Encrypted: i=1; AFNElJ94dQOxr0LWr32s149M6tiZ/uY1rnEhrdCQn+B6LYW/lrDwVa410P57Gg6M/3TOsBUVLwp13kmLlh4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzua1pJwU254ogwjdgM/N4QshAup2MycdWqAo6yxKJnx5vPLLjI
	hMygWL284VdzZoi9iFQOJmnoHIbPxIWTko7XYqQNbdHBe/IZF37BpHuKeYP8iNZWYPQ=
X-Gm-Gg: AfdE7cm11fMZzarpVzsmSEuHqJFz972Zt4kdO9VZx61vGPTBS7wmPOur/f2y/lUl4zT
	rGsHxm3IBfBHwaAuUd57argtMbxCoVGZRKQEdsqfUyiDWxu2MhW01j23/bFoeFzeDUktjrmpv4o
	tUBeNQPvogROtc+5h+mR4LyfXNPxaCYBAqr0m4Y1hXi7Dcg0Cy/5WiMa9RzJff9RQM614RXhcLh
	kuibjs1FfzOLSP3u7vQKmN+o18tHp8EzXZ+sRWp7HglOM0qH+JUIMooAf1atD9FCc3Fg65F2kjA
	3Pkhq1Gccv+IftUus0TQsCEb4b6MN+/SLqq3h4lZbgMBLyfFO+wcDXLxhdG+clEWBc6O/ri7MZj
	iBY9pr5QLzqKn5VUH7+3oWsV7PUujNV2lHiSZZCDsU5HzGy3XHjc7DjdwCqXxq/4X16NM1l9El/
	2J6ZYdjcGAlTFmu1GN17i/P1mltBl+V/4eoBonR2bH7yOWE3ulc3JAA/lbnSHGSw1xy6Iu
X-Received: by 2002:a05:622a:586:b0:51a:8c97:fb94 with SMTP id d75a77b69052e-51c10911601mr53620781cf.61.1782834918282;
        Tue, 30 Jun 2026 08:55:18 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51c1080d149sm23102481cf.1.2026.06.30.08.55.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 08:55:17 -0700 (PDT)
Date: Tue, 30 Jun 2026 11:55:12 -0400
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
Subject: Re: [PATCH 09/30] mm/rmap: parameterise anon_vma_interval_tree_*()
 by anon_vma
Message-ID: <akPm4FlwTj0FsZU9@gourry-fedora-PF4VCD3F>
References: <cover.1782735110.git.ljs@kernel.org>
 <1c1df7b905ef340cbf2effef769a4e770a8e0eb1.1782735110.git.ljs@kernel.org>
 <akPk5o_gHD1SxX_0@gourry-fedora-PF4VCD3F>
 <akPlUrNWzl1ZPw1S@lucifer>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akPlUrNWzl1ZPw1S@lucifer>

On Tue, Jun 30, 2026 at 04:49:45PM +0100, Lorenzo Stoakes wrote:
> On Tue, Jun 30, 2026 at 11:46:46AM -0400, Gregory Price wrote:
> > On Mon, Jun 29, 2026 at 01:23:20PM +0100, Lorenzo Stoakes wrote:
> > > Similar to what we did with mapping_interval_tree*(), let's declare
> > > anon_vma_interval_tree*() in terms of anon_vma rather than rb_root_cached.
> > >
> > > In each case the rb tree referenced is &anon_vma->rb_root, so just pass
> > > anon_vma and the functions can figure this out themselves.
> > >
> > > Additionally, rename 'node' to 'avc', 'index' to 'pgoff_start', and 'last'
> > > to 'pgoff_last' to make clear what is being passed.
> > >
> >
> > would it be possible to split the pure rename changes out from the
> > changed function declarations?  It's hard to pick out this as something
> > that needs to be looked at as more than just a %s/x/y/
> 
> Hmmm do I have to? :P 

I mean, no :]

> I mean sure I can on a respin potentially, but it is a
> pretty trivial change? Just mechnically as above.
> 

And yeah certainly not worth a respin.  Just learning some of the
friction points of reviewing as I spend a little more time doing it
every day.

~Gregory
