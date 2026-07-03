Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABEB63D0924
	for <linux-sgx@vger.kernel.org>; Fri,  3 Jul 2026 14:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783088374; cv=none; b=Li/sPig0ADHwU5yCFmmmVYdmTRqH2M8IWpaPJUSTOG8ry3UXzpLG1czxSwcmtW93NIfKf+AYUkr4iJmTP7hOplaywulHpj7tKV/7dC6NGaIxgZS7v3CVA7ib4otr9Oh1Qbtth0lQVuvvSOQhDRSya+J/maqgipbEAMaC8vD/P10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783088374; c=relaxed/simple;
	bh=fwBNMGsGRW7LvE0wmMyeo41PuP5/RmLAB5AFTN8r+GQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s+t+8L8jKjgTruO7ljYdZs3AV4t46M0G2dQIaIogjmOYXuTfiKd520U5q5INr2btnhPNiC4RUvjGCUUkzoSckPUz5ss8ZiyOkXkWBqIZTlJ6M9ZJ+7a23JoII1+MIYCI5+apYrnfq9ofP7KOFVGpziS0jRl/zR62T+yuUCkpFCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=VXa2HykD; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="VXa2HykD"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-4706f016316so78514f8f.3
        for <linux-sgx@vger.kernel.org>; Fri, 03 Jul 2026 07:19:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1783088371; x=1783693171; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7AtJfCkfnFMyzgye8dfK/HYrK6u/oQ9FNgRgisJiufQ=;
        b=VXa2HykDu7tPrzRJFgLIlJuq6R9LgUv/0gSGCTICAf+Xvq4sNQ+JJwhgrB47bepXw1
         TzI+Bhn3ERoBZllGBFTtB0XHQYVsVCqnsyoO0Ntdgux1y2LJlaxmuIsaj19Ty2ma2jvG
         kMUqQBrPsH7FFUjr7p1j96S+dYep2FWx4hJ8RiviFBz4/xPH2uwCKhYmZc1PEUu9R2ax
         RougdRAiZVmUoE78yW+N6U4LU3d4atY0z6U0/mD0gLGa30dQtSbbgBufn2wVvg0MiQL9
         yTfk9YvWxPBu+ryhAS63jrmbWtStA4Q76QO26aaBtqf6BTNqBwAuj8EWRM58FSMzK23A
         MgbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783088371; x=1783693171;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7AtJfCkfnFMyzgye8dfK/HYrK6u/oQ9FNgRgisJiufQ=;
        b=CJYDmlbP4sLfwqpOBlQr0yxfljuKbHgrr3FIHcMZhigfL2l7c/Gd+MJUmQWftrWDuN
         lKBM308eFzKM5H6aNg+Brr4m6xzpYnxOHlBi9tdG8Fj3S+DgpC3B02935tRrQikxR1ME
         diKXhM711hqvXilfwmQO840Cvxj4aoa3cAoeATm7EqhBA93cKU1ANLW4z8PY34+WJb8h
         x4vNtvbohthPxosyNlsm5q4UtmZt18DTN8uoNCng/bLvHFkd0/TPUrKGAWwYN0xEbKc1
         iD0ciwJugNKTd77S66OlKwI7OY6YgvQUqgvH/QfKIkKoQfwckm/UV4MUQjPblKNoiXPz
         yx0A==
X-Forwarded-Encrypted: i=1; AFNElJ9G/CBj7WBG9ROujZe20oaFpml/u8ipJ3k+Iz7h9g0uLr/Wpc0g7kl4gv4mDIaPl8qDq4rGoOsFP3Y=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/3zFzZfEdK4VPEpBj4BJ8Zh3AUznFfo0Nvk2zaKrEq1Foi4Pt
	7oTX87Bhw7KgffFIRPdQbhj1t9J9ffZiU7D8pj1EWFDq/jgmEO8yeSvOsBo7OvuSIcw=
X-Gm-Gg: AfdE7cn/sbjzPjg3QehcBdYKgH2ujcKMPZeH6Yv1Q8J3EcjiXniP8hzNjJO134HMZMT
	vxbd7rBOEDamDLGIFJ021V7Pzpb2Fk1yuRJmaHnMTJNK9lM2qJUgdRrVxUaKjGYKjDMqUC0YNgm
	O9ClFur5FHcNEAMsAiljHS7ZVZ08aWspCjaUr6O0OW0s8mtgBvwF7QIAKywrbbSbnKpia7W4gA4
	uo6Cg1Z7+C+P21gGHp+qs3FHI8LopIw/M+1SGPx9QgmqwJhFLmQcGh8e08QgITWWZ8LYPQ2D4vt
	pzm4gabjB+4BTNvgcgga4mgTuXhaeuuRjB8TB7JKq+ckes6V3ukZIp6Ylalwkyk2KcTkhO5W2NR
	g1xqh+2d4FW5ItVzTLDhaLqQ011VhxwDoH1hQoK/++rSw5DdGeypQTg0WmJvRy+OMmVrO8gpLR+
	GE5e/3Hss=
X-Received: by 2002:a05:600c:3596:b0:493:bda2:8d92 with SMTP id 5b1f17b1804b1-493d0f3dfa7mr471185e9.5.1783088371071;
        Fri, 03 Jul 2026 07:19:31 -0700 (PDT)
Received: from ?IPV6:2001:1a48:8:903::e14? ([2001:1a48:8:903::e14])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493bef23feasm171149305e9.2.2026.07.03.07.19.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jul 2026 07:19:30 -0700 (PDT)
Message-ID: <458898c9-cfe6-4be5-ba83-f7961ed84329@suse.com>
Date: Fri, 3 Jul 2026 16:19:28 +0200
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/30] mm: add kdoc comments for vma_start/last_pgoff()
Content-Language: en-US
To: Lorenzo Stoakes <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King <linux@armlinux.org.uk>, Dinh Nguyen <dinguyen@kernel.org>,
 Simon Schuster <schuster.simon@siemens-energy.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 Helge Deller <deller@gmx.de>, Jarkko Sakkinen <jarkko@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, Ian Abbott <abbotti@mev.co.uk>,
 H Hartley Sweeten <hsweeten@visionengravers.com>,
 Lucas Stach <l.stach@pengutronix.de>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>,
 Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 Rob Clark <robin.clark@oss.qualcomm.com>, Dmitry Baryshkov
 <lumag@kernel.org>, Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
 Thierry Reding <thierry.reding@kernel.org>,
 Mikko Perttunen <mperttunen@nvidia.com>,
 Jonathan Hunter <jonathanh@nvidia.com>,
 Christian Koenig <christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>,
 Ankit Agrawal <ankita@nvidia.com>, Alex Williamson <alex@shazbot.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Dan Williams <djbw@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, "Liam R . Howlett" <liam@infradead.org>,
 Matthew Wilcox <willy@infradead.org>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>,
 Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
 SeongJae Park <sj@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>,
 Hugh Dickins <hughd@google.com>, Mike Rapoport <rppt@kernel.org>,
 Kees Cook <kees@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
 linux-sgx@vger.kernel.org, etnaviv@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
 linux-tegra@vger.kernel.org, kvm@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev, linux-mm@kvack.org,
 iommu@lists.linux.dev, linux-perf-users@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
 damon@lists.linux.dev, Pedro Falcato <pfalcato@suse.de>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Jann Horn <jannh@google.com>
References: <cover.1782735110.git.ljs@kernel.org>
 <8c618dfd7de419e3b797b8bd1cd921d4c5b8878b.1782735110.git.ljs@kernel.org>
From: Vlastimil Babka <vbabka@suse.com>
Autocrypt: addr=vbabka@suse.com; keydata=
 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
 pYekxJujNeEDkUlky0Y=
In-Reply-To: <8c618dfd7de419e3b797b8bd1cd921d4c5b8878b.1782735110.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/29/26 14:23, Lorenzo Stoakes wrote:
> Describe what vma_start_pgoff() and vma_last_pgoff() actually provide in
> detail.
> 
> This is in order that we can differentiate this between functions that will
> be added in a subsequent patch which provide a different page offset.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  include/linux/mm.h | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 059144435729..2f00c75e66bd 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4278,11 +4278,37 @@ static inline unsigned long vma_pages(const struct vm_area_struct *vma)
>  	return (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
>  }
>  
> +/**
> + * vma_start_pgoff() - Get the page offset of the start of @vma
> + * @vma: The VMA whose page offset is required.
> + *
> + * If the VMA is file-backed, this is the page offset into the file.
> + *
> + * If the VMA is anonymous, this is the virtual page offset of the start of the
> + * VMA - if unfaulted, then vma->vm_start >> PAGE_SHIFT, if faulted then the
> + * virtual page offset at the time of first fault.
> + *
> + * Note that if @vma is a MAP_PRIVATE file-backed mapping, then this returns the
> + * file offset.
> + *
> + * Returns: The page offset of the start of @vma.
> + */
>  static inline pgoff_t vma_start_pgoff(const struct vm_area_struct *vma)
>  {
>  	return vma->vm_pgoff;
>  }
>  
> +/**
> + * vma_last_pgoff() - Get the page offset of the last page in @vma
> + * @vma: The VMA whose last page offset is required.
> + *
> + * This returns the last page offset contained within @vma.
> + *
> + * See the description of vma_start_pgoff() for a description of VMA page
> + * offsets.
> + *
> + * Returns: The last page offset of @vma.
> + */
>  static inline pgoff_t vma_last_pgoff(const struct vm_area_struct *vma)
>  {
>  	return vma_start_pgoff(vma) + vma_pages(vma) - 1;

