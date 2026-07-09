Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F02801548C
	for <linux-sgx@vger.kernel.org>; Thu,  9 Jul 2026 00:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783555569; cv=pass; b=gK2e5sHsCK/E1bvphzX2xw9B5yy49C8Ffsx67eFe8zJH5L6s7w1N5O25NB/VyfH37t35v688p966qKYKjxUBVu67eDQAA0Uj2LDAmSrAj7F7MQFrSnG+D2gr5kwdi4oo09LjSTmELW6+qYQHwv/dza8m4Deae6qY2JJpyAGj+Hc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783555569; c=relaxed/simple;
	bh=yJaHiIAKdt59/nUs88AHXAG1seHCynr9U+jmRjUBOEg=;
	h=From:In-Reply-To:References:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Q4+LTkMdyl3ebtE7tj2WQFHs5Y3n7cDQ5B30zM0Q/0nKCJG7WB6Q0v51emjq9eVTYwNzpEMIjMm1e+mybmGaUhyWqV3BZm+DD3g1HkAmqN/O6sADVpHmvY3KBOnMWbv2klVbwtiQjzVcRV1VKaE5N5hx61Y8LxIBpaZUPXHzak8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=km73nMuQ; arc=pass smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="km73nMuQ"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-c999f162c9aso720842a12.3
        for <linux-sgx@vger.kernel.org>; Wed, 08 Jul 2026 17:06:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783555565; cv=none;
        d=google.com; s=arc-20260327;
        b=BI2lzTzKvy5zHsfHmT67kGDhOHWW4QB+SxgfcnoHWfTdSfhGad8uERPZW59XPTo1Xn
         q4GylUKNNeDjxu0wNUwmPMFYGIwMJE0VTWVUnPjL0Gugz0ca1i8l+JHDnj7+b5XNbDze
         L+zH5RlKRx9QWkPnyOWL2aXAaK780k7fBEjkA68NbNtIeIRsPjk/1FzNcvHxlEv4G/+/
         HBVAEzxO4VBcrXoDUcD46g52ULFp0WAriX22/XUxNDT9pLvPxVQnyY619dQ9jsX7X65N
         cMiNq5E/mB7oLk/ueDRnFLkCTjLYwNqtDI/xyn6GtGr2Fu26719xhCK/GKErRQXeFMmg
         hM0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=yJaHiIAKdt59/nUs88AHXAG1seHCynr9U+jmRjUBOEg=;
        fh=NZy7X634gwd2WBRGYuFNR+CAxn+lNHjbctB4OXYmrow=;
        b=Vdi1X/OKM3sXvOtf966A8gk3alQqugOPu9Awgujxb5vSKUbKnDZte0XjF2A4Zv5pAq
         44u7zOLhUEUFAOOU3/KbqPYPzHKgRqIuou4FBc5OaITAnem76/TMbMT3bW3/DKtCazba
         EwufrDZz+0vpL06mxcZi+vQZZsoX1atFbscmzrJ7OsimCxVnm8hIRh4dqwMTzxVxXpoZ
         lR9hnmIyAKeJ04FM7K0qg9GspobmYxZ6srVcakFfMnZJ2NcVEZzhp5wgD1KeR5G2sRjL
         YY3AT7+RzNreRrWtNgk+U863HqPVRcuzYjA9Zxi9g0veroAaSS85XRi0lBW8jkC3cyEw
         XTeQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783555565; x=1784160365; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yJaHiIAKdt59/nUs88AHXAG1seHCynr9U+jmRjUBOEg=;
        b=km73nMuQirX6WkgaiDewtefUUpLqHsLA9lhojmRVu/O5GWXI+qspHLrIcP28hPedd1
         IdrQ4w2WUGkGZnfsvZbX4i/0vv+f8zy6UYrbx+r+6VAltUS4BsKAcMEEAqGPcoKiR6RJ
         oJPaYYcMOCkbcbYn6DUg2jPj6RwRgKn8b5KjbPN0LTaLwabP3wAFOO6JrbWd8+/V2xJm
         8qmB+NxqEb/SagF5FxCEtMVuCK+ov8IPbs0gvdfNk2TGZa0FvtOnzr4ElVQGCDXTFRjv
         zpPIU07tYAE6O/XcExlihB295hDnRUteCnX4/vklcg+GnLTnFl9WQaUB6cAitmsgQsSS
         bmvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783555565; x=1784160365;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yJaHiIAKdt59/nUs88AHXAG1seHCynr9U+jmRjUBOEg=;
        b=eWuE65eKPujUvb8yZclL8gGvvozfaXmcvlcv2o5N3yVAk8r1dIy9mzdurV5GpOmvOq
         1AjBwZ+/UZPps1V1Y+rdQ0Ds61OYky8kLd6zelD6eYKl2p98mKkjFAisbDpkaR/etxHZ
         zElm0EqJD0bemgql1dzYbqCLRI8WSKeW5qaY4Xp+FYWMKx4FCF4fVpMzqZeirjHF419V
         x+pWzfopozmNfJH2I2nPYonjRUsIHOSlBKSm9psXeshbZ3VNjoRv8ikotSfPJbmd1IUL
         yTN5I/Oo1smM+nbZZ3F8qVkEF5dVq0VUWee9PQ7SX6cAmXkrg3CjXJaFinn+PZzNiuX5
         uYFA==
X-Forwarded-Encrypted: i=1; AHgh+RqR3YVPreGX0RdzXs7TzwpYqigvbXQEEVX0jTO/v2NW8tCaQ6f2cYWwO7mxGH3iX9sAKp8Uht8KyLw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwvyobS6rpLqAIXmTuyzKqenNIn2/0O3ji8oQbex8E+MHzAq5Wr
	Ysd/tlPKzph5AJuVhbnzp4lEpp2cnUWS9K5RioQ6LhvOsshNZNpaLLF7wZqNVv+1csHH/5b/dD9
	hWktu4cK8Zg7YEzAoxcm/TqW7jHJ7e57DUSH8Z8Nu
X-Gm-Gg: AfdE7ckVAkPkRUFk4Qaa+9y/khehFX2RuVbeQyQq9pvvF24+oDY3SuQnn1pazsRCAXA
	xam9UtQMs9HDTD8tqQRlLMCOWIETZYf/jSCf/ga7SWkrqxtuyX8JJ9tErjkyL7qlrhSB/DS9RjR
	mjLbK87UxaJDZAOg/1N57WZjdCo/YvjWe4M8xjTMbd/U96yUMXFntU6ptovBPA1qLgK+Wza3Cur
	bGzqJU+SAoHAGuw9DjHRDh6hdZajYOsGnGTrI2ZviKK0HKs4QrRKWf7fXeV6lfK3jTHn40vTzfG
	o+PCjvP9Ul6XpJIGHWKyLFSSsEwXgPfVtkDA4X8gyoZLiVbQneH0m9MY9ldf2JxbLe/R6Q==
X-Received: by 2002:a05:6a21:7482:b0:3b4:669c:ee32 with SMTP id
 adf61e73a8af0-3c0bcbc1353mr5760887637.37.1783555564841; Wed, 08 Jul 2026
 17:06:04 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 8 Jul 2026 17:06:04 -0700
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 8 Jul 2026 17:06:03 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <eedf589778aaab33e6df2ad6556dcde536e13460.1782735110.git.ljs@kernel.org>
References: <cover.1782735110.git.ljs@kernel.org> <eedf589778aaab33e6df2ad6556dcde536e13460.1782735110.git.ljs@kernel.org>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 8 Jul 2026 17:06:03 -0700
X-Gm-Features: AVVi8Ceg-PSWltTScKU18ZF0mdbBsNHDv0s-VKhIaqzjwQ-q80D6zfZMKk_VWII
Message-ID: <CAEvNRgE-JJAzC0jp+bY8+e1+gYSH+MjT6JqX_DfCcpaxOM-Dtw@mail.gmail.com>
Subject: Re: [PATCH 15/30] mm: introduce and use linear_page_delta()
To: Lorenzo Stoakes <ljs@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King <linux@armlinux.org.uk>, Dinh Nguyen <dinguyen@kernel.org>, 
	Simon Schuster <schuster.simon@siemens-energy.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, Helge Deller <deller@gmx.de>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Ian Abbott <abbotti@mev.co.uk>, H Hartley Sweeten <hsweeten@visionengravers.com>, 
	Lucas Stach <l.stach@pengutronix.de>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Patrik Jakobsson <patrik.r.jakobsson@gmail.com>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, Rob Clark <robin.clark@oss.qualcomm.com>, 
	Dmitry Baryshkov <lumag@kernel.org>, Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>, 
	Thierry Reding <thierry.reding@kernel.org>, Mikko Perttunen <mperttunen@nvidia.com>, 
	Jonathan Hunter <jonathanh@nvidia.com>, Christian Koenig <christian.koenig@amd.com>, 
	Huang Rui <ray.huang@amd.com>, Ankit Agrawal <ankita@nvidia.com>, 
	Alex Williamson <alex@shazbot.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Dan Williams <djbw@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Matthew Wilcox <willy@infradead.org>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Steven Rostedt <rostedt@goodmis.org>, SeongJae Park <sj@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Hugh Dickins <hughd@google.com>, Mike Rapoport <rppt@kernel.org>, Kees Cook <kees@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-parisc@vger.kernel.org, 
	linux-sgx@vger.kernel.org, etnaviv@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org, 
	freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org, 
	kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-mm@kvack.org, iommu@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, kasan-dev@googlegroups.com, 
	damon@lists.linux.dev, Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>, 
	Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>
Content-Type: text/plain; charset="UTF-8"

Lorenzo Stoakes <ljs@kernel.org> writes:

> It's often useful to obtain the number of pages a given address lies at
> within a VMA.
>
> Add linear_page_delta() to determine this and update linear_page_index() to
> make use of it.
>
> Add comments to describe both linear_page_delta() and linear_page_index().
>
> No functional change intended.
>
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Ackerley Tng <ackerleytng@google.com>

>
> [...snip...]
>
