Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3537941B34F
	for <linux-sgx@vger.kernel.org>; Mon, 29 Jun 2026 15:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782748496; cv=none; b=ZY9kUStRsRoQ5Zh52663Kv6ww2w0dTfwV32EsHfCu/EXEVoXAIxS+27n73L/6r5psSX29a6v1VMyImiOabtiWZrtbXhp4EY6ODT8h2z3vjYEHRuw6pzpeiX0HbDfjM/lYJG1gW+QFGtGYYO8PITrdPQfsR8S9mB2a7+nHoBjRaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782748496; c=relaxed/simple;
	bh=vSc4ORRRpUbp5nwMJk1U6F/78ha49jf3UdrgblxYv9I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GmgQyzakzX+xHIqKYoLaO+q6UfrYLiCp9j+9K2DgcFTl5S6nMnRiEJ3hlfjsj2eMl5SHpCxnXBt+LFsX7He5RouNlXxevqe8ePGLZpegXL0AcBoQakXMiIWHu+QArB3EvLZsfk4qhfO3EHGgxZlb/xA7DpToJcxySdyT91RiBLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=JM0fnN0H; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="JM0fnN0H"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-8eec5dfdb65so9350576d6.0
        for <linux-sgx@vger.kernel.org>; Mon, 29 Jun 2026 08:54:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782748493; x=1783353293; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4r3nyg8MsZ+G0ckW9OOGJtlL6QAvCNLsDtm+wiwuKtE=;
        b=JM0fnN0HJKUi6uSnA3IrfoUPrcjauK6XThjH2DReQOmpX1gM2LZPfoF1ZbHc/BfOsW
         XI9kmoGCt6lvgHoZXI6Sh1Ty6+UIIveqPkZsQXGuZVY3CysSg9QdBDdUJ6g0L87cTIHt
         p/0MmTIL7mZvw71fhcyjCRfTkRh/O+Dwx6mRwAg+epfM+SqLwiyuwSs1n0Sz3N8cV2mH
         AUIUyTmBdyr+54ccj7lbpXdws+p31Q+ZmFOiRb6ngfzp1k0eL6vsPmNcaCqY0tFQzoIQ
         wj5Gh2CoyjJm0JjYVxbpgfxq/lylqC7ox+tH4VrNSX1XtlLyydAen95MqgFL+zI/X2z6
         T5nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782748493; x=1783353293;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4r3nyg8MsZ+G0ckW9OOGJtlL6QAvCNLsDtm+wiwuKtE=;
        b=sk2gixsxBvr9sUrAB3kcTYwkZzQo0aAQy9kuGUh8CVkYh1NVQ1dbK2hiuJuK14GKDF
         yvz/3guqOB7KjiNX6JPRPkwrbt/o3nDvGtbS7Gawu2Lq4fx57id2cDT1RaL9llbMFcFe
         OYulrxy0qfV5z5AEI+L15lRjZ7S3JBGl1O9aJ1R9WNYFtSUrYksWv8Or+5+kMLMQIEZ4
         6FA/DrVmv39FUKuRRoXvOQ12PtrKGWJXZN3tshzq8vnGCxznqdZO8DfSVlJ637Ayblo1
         /Ruj2ReA8pVpMlsXpL35TEVOpU60Klmx9bXs2cvT7nReQqetefjCCAVqjJSnCQ/riL37
         fLYQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr0QQfmgap2nzdsGWRZBTh+xUU8mwmu0gXWcMDKF6SDKLvkVNSyDLO7Df0oDzY8q/z6oc1n8qmrZao=@vger.kernel.org
X-Gm-Message-State: AOJu0YwYH/zChtKkp1URAMIIFGFaShHA5HZsRiaSSiIewoLzyBgbLKk/
	DGEUebH7fyXJsYLuSp1pYbCIlZw19dTJKRerbkbbPy9AAkarNb7MkmqxIeGaNOeS/lw=
X-Gm-Gg: AfdE7cnLVjnCBtjcAofX3y5bGd8YIYVxHeFQx8TsPQPt2OTA7wH7g1h2jOe744kqnui
	tAu7dZt9hw2V6RqLF8GRXPrx8unCSxmNTRh7JQUItk6u9MDORy1tC5LP9C+slvSp8GCRhznZu9i
	N/8LSsYwi7wK+4mOmVZChUogfEaKmKFmOwpIvy6wQm6b2aN75zF3LGbnJGXsyqDav3D4ou2OcGA
	113kXybavOCSWmeYJ6MEr/D1G7fPHDk0yNC23ZNNzkGvSAeQ7PedeEuK1P5G6vKV16pEGctQ73q
	hb4jmWZjQZajJb3phQEeDoGtmw9RKT6LGrKGkci8VEZJkJFe38qEQSX9/IpcTwYVBPqJFJHpPp9
	TqGbecE5HoicTHiYKuegIGLSFnQ8ALInCdrLzTurQ1gH0rVyxvxx9VdxYtz+yaxJ2vqx0oJ/HF+
	RWlnQO45FnislT/qmYvOjMTnHr+ABwjo5nxbDdTH+iFwJwDgxM2LqLTgAcjklOLfUJZenJNECPY
	3ikdFw=
X-Received: by 2002:a05:6214:c65:b0:8f0:5b55:1f6c with SMTP id 6a1803df08f44-8f05b552223mr58558406d6.43.1782748492988;
        Mon, 29 Jun 2026 08:54:52 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8f1a26f1b34sm1726396d6.3.2026.06.29.08.54.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 08:54:52 -0700 (PDT)
Date: Mon, 29 Jun 2026 11:54:47 -0400
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
Subject: Re: [PATCH 04/30] mm: introduce and use vma_end_pgoff()
Message-ID: <akKVR2wNSjbLDt1-@gourry-fedora-PF4VCD3F>
References: <cover.1782735110.git.ljs@kernel.org>
 <e379a1cb6a897126ad96e3a263fdb91d6c11f6cb.1782735110.git.ljs@kernel.org>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e379a1cb6a897126ad96e3a263fdb91d6c11f6cb.1782735110.git.ljs@kernel.org>

On Mon, Jun 29, 2026 at 01:23:15PM +0100, Lorenzo Stoakes wrote:
> We already have vma_last_pgoff() which retrieves the last page offset
> within a VMA.
> 
> However, code often wishes to span a page offset range, which requires the
> exclusive end of this range.
> 
> So provide this in vma_end_pgoff() and update vma_last_pgoff() to use this
> function.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Gregory Price <gourry@gourry.net>

