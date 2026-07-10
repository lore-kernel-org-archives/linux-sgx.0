Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D44F937702C
	for <linux-sgx@vger.kernel.org>; Fri, 10 Jul 2026 18:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783709851; cv=none; b=QpLbETQjyxS3MsAJET4KHHBkef0BP3oBexeCL4a60ha3WurZn2jy4re/kGWxlg2AvJydlJWrQ2SPFxFsZ0bfMHd41+jWbUxrhvgBvEHeKWej5ZBQvWATx/mJdYWR3gxyKDTllidM+G4XCp2kH1zczhGi/6jBogDLVb+WW71fENQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783709851; c=relaxed/simple;
	bh=mfAQ6U6Pagde6/OTMZV/3pa3xVR9imBJSf9e6QtJA6o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BYCRSO0E/mfA+w2ag2LSNhMC6gHlS5NjqupkOaT5PeYLX5MHyqNuz05zJjU/hl7dKqPyK4NIC82yI1WwgjouDH1vgnr3e1w6NPZ5dDU3oabmXb/WE8mTWQag1F7gS8rBry1jBhpeCQ129O6q/zOogAeYKIJAPaGDdAMV5emFB48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=fxaRVrzr; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="fxaRVrzr"
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-92e54f8c051so64509285a.3
        for <linux-sgx@vger.kernel.org>; Fri, 10 Jul 2026 11:57:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783709847; x=1784314647; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kUriDsQ9XZtRyYKZZfoXUueFFJuZPgSg6lCZHNic6sM=;
        b=fxaRVrzr0pu8Uz/SO7/A7nmTf/OpotguYO9NJQKIkwviKFH5uDnq4kTQpYDajWVd+9
         faZwKB1PVsoYOX/6WOFdDBt5VUDMlX+XBugqcTfI4I+8aywYSLm2Gts3IcALhGIvCG/K
         hHZgu/Zw6gcJZ+xoWFWQcNmy6X8husI3BglEromZ8sXqN5+EvW/wDw0IrUu+X3nSmczz
         PE8+czA5trAIhNeulj7pYBJMlBucJKhEzcYLF+F/qHpTTu4+JBGJTqXP18vS9QbjkqOI
         TaQZUztVq1axOw86ojkd+MdfZfF986LEDKifyKhbCywDWB9d93mAwvELkPXX/paVW27p
         tzvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783709847; x=1784314647;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kUriDsQ9XZtRyYKZZfoXUueFFJuZPgSg6lCZHNic6sM=;
        b=nTTJRUAlC7ElD7k7iXQ5wlyz38IzaKM2cEWEISEcCgNiVNOvX0vtmF6jjaJsYcDMjp
         m9bHut3O23nCQlbw/di1A+PKSFFEl3z/I6DzDYR37cqWdmSgyJlXSuGfY4zhUjdV1Cw3
         IpDy/Z+mrxBhxtPkLEbV99TGn79vq2PfNmv0210RMESELjL1WDklNB+jsrcCzPKsk/uC
         8ejOk4dcIaZdbrUUWTA35PV0g/YDag/Tw8xoAElZmqiwGuSiWlWBBatEpkIyRL91Qav/
         8GexJhS+OudvAhedYkdBIKzJGAuyv/oeiNZM/JzOJP0u0WCQxTKlgxyVO8l1FH8YXSr6
         NTJA==
X-Forwarded-Encrypted: i=1; AHgh+RrYFtE8qWxp5+PS4qDoujracipq2UEyAUO/xS4CJHAARV8UKRHsiBVDItaethU7jdHCknDyGqG+AZU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2zLf/VDSSuaUkPcVN8xD1Nostz0fQuNF7JAOJmolUkk8EmUzM
	sV6C9P94BTzTH7M2DhFVOilAJLbAIv26wNfihiXIWjZAA/ttHnQ7qFvhfBYVThpGoyA=
X-Gm-Gg: AfdE7cm4PB/3oXi4b002JD8iLVtXz7Oaw3lnPFrCeSmU+lJYXggild3IT1RDtcAFNlJ
	jWzm1vNezEzN9ktYEnM12I2U2JhLUZsLy6jEY5UqBRqwvHDaM9yHjzPkClA/UQvzPCvNE6rRoyO
	9pPWE49LhzcWmAQyao6P3HKYMfWy2r2pdNJ2yUPTjnwuGcBD8MMdK4myUvL4x7vpDKv0tOKwaw9
	Anx3vNf6WQm1FR/se6iIFhM0bMJLfxaC0kf2q1rITVhLXCceCEs/4VRZlnuddbPVVYeZjsop9NH
	IxyqNr1Jz02OwsCM0NulJ1OpwL5T5ZIpOAWzB3j0oM1J07kr8cn9bhpSOt4aIS2gjNy/m8laQ0a
	oK9IyZU/bFcE9uppq8uYB7G1L0alebcCnH1l8saAXVTw0AD4gRA11jUFLq5Ivzo+Hbds30XUIfX
	0JJunLYz+2taISgeF4NgPka7RnfQ5K97jYEtx/jkP84onQk466tAoMaNxAOYyy4WQCDEha
X-Received: by 2002:a05:620a:d8e:b0:92e:9d63:a6f2 with SMTP id af79cd13be357-92ef2c1ab7bmr45629785a.70.1783709846741;
        Fri, 10 Jul 2026 11:57:26 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92ee5cfdf6fsm275995385a.24.2026.07.10.11.57.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 11:57:26 -0700 (PDT)
Date: Fri, 10 Jul 2026 14:57:21 -0400
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
Subject: Re: [PATCH 23/30] mm/vma: make vma_set_range() static, drop
 insert_vm_struct() decl
Message-ID: <alFAkWCnkYv--Us0@gourry-fedora-PF4VCD3F>
References: <cover.1782735110.git.ljs@kernel.org>
 <62efd70f9f39570724c9552cc7f2aeb5c322b2ff.1782735110.git.ljs@kernel.org>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62efd70f9f39570724c9552cc7f2aeb5c322b2ff.1782735110.git.ljs@kernel.org>

On Mon, Jun 29, 2026 at 01:23:34PM +0100, Lorenzo Stoakes wrote:
> With __install_special_mapping() moved to vma.c, vma_set_range() can be
> made into a static function there and is now completely isolated from the
> rest of mm.
> 
> While we're here, we can also remove the insert_vm_struct() declaration
> from mm.h - the function is implemented in vma.c and already declared in
> vma.h, and has no users outside of mm.
> 
> Also update the VMA userland tests to reflect this change.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
> ---
>  5 files changed, 8 insertions(+), 24 deletions(-)

Net negative lines of code, the best kind of commit

Reviewed-by: Gregory Price <gourry@gourry.net>
