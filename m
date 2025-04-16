Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7923D10E9;
	Wed, 16 Apr 2025 18:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744829444; cv=none; b=e9zt1J+ms0fkZMytMPvwQaiuqACWGYAJdx61LfGCsmiRoe2CU09d0s7RXhvxQgEysf365PZUJt6bEOciULI1rF54xP8llgxnkiNjCbUSukfZd2Eyiudxixtj/kyzOdtxsilEicl60JVOwUHnpS0axfF7t3uXGiLd3/ucZNwyqmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744829444; c=relaxed/simple;
	bh=D0x2mO0w3EWwoOU4pSO/LBh/nbRAj64kO7zbNOvpi4A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b4EgvO4ugUKdWkeunnuPOepspx7UTsaGpZYqF5w2ujoqcPDyP905a9R3dYR3zU5/u+mes+9r2qFGjEr7+t8DZj4vSP8ehV38PU0/2mgh/wlJ7mRO9eCBiWJzFa/qlan5o7WIu6RHW0eoxNcjssj9saPLMJczRkDwV8yQBFLR0Zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XqHLoEZa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XqHLoEZa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF475C4CEE2;
	Wed, 16 Apr 2025 18:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744829444;
	bh=D0x2mO0w3EWwoOU4pSO/LBh/nbRAj64kO7zbNOvpi4A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XqHLoEZawaLmRazJc+T+ITk6NJKyN2ToACQ2DdONQbDDgoUkRe4J1kP+yu+cUFs2u
	 smdLXvYFneZUAUfI0Y6DGg3l8S2iwJU3ynoV2ymN3V4qkfT6ETxlVh4j4bC0J/6av4
	 /mkude8YWiDXagBV6QZja6W/J8dV8pTSPA5SEDppxSVfO4TBdKI6wCH5NKTeUVJuBP
	 yyGXaO9Yhah/HnJK65y1C12jv48lbMk/5Vnh6cQauuFSZc2+r/fGLOidYpOn15tqWd
	 gDbLvfukq5l26PdQNX/I3b8mygFecKo1JdXDrMjQs7CVmUnTMyCw2G8iCNuiFZdzGB
	 VnxTZrP63p3RA==
Date: Wed, 16 Apr 2025 21:50:40 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: dave.hansen@intel.com, linux-sgx@vger.kernel.org,
	linux-kernel@vger.kernel.org, x86@kernel.org,
	asit.k.mallick@intel.com, vincent.r.scarlata@intel.com,
	chongc@google.com, erdemaktas@google.com, vannapurve@google.com,
	dionnaglaze@google.com, bondarn@google.com, scott.raynor@intel.com
Subject: Re: [PATCH v3 1/2] x86/sgx: Use sgx_nr_used_pages for EPC page count
 instead of sgx_nr_free_pages
Message-ID: <Z__8AHPhZzyhB5A5@kernel.org>
References: <20250415115213.291449-1-elena.reshetova@intel.com>
 <20250415115213.291449-2-elena.reshetova@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250415115213.291449-2-elena.reshetova@intel.com>

On Tue, Apr 15, 2025 at 02:51:21PM +0300, Elena Reshetova wrote:
> Note: The serialization for sgx_nr_total_pages is not needed because
> the variable is only updated during the initialization and there's no
> concurrent access.

No. It's

- not a side-note but core part of the rationale.
- the reasoning here is nonsense, or more like it does not exist at all.

sgx_nr_free_pages can be substituted with sgx_nr_used_pages at the sites
where sgx_free_pages was previously used *exactly* because
sgx_reclaimer_init() is called only after sgx_page_cache_init(). This
gives the invariant of it to be constant whenever sgx_alloc_epc_page()
is called.

These type of changes give a proof of the legitimity of the invariant,
which I addressed here.

BR, Jarkko
