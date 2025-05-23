Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D923234;
	Fri, 23 May 2025 23:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748043940; cv=none; b=H9ZsIgKkK2JCpCs7MBDzfSuZ5DCEptvC/Fan8Nb44Tuhq6h+8Fp+1o025Gku7FhbIDu4NuVgET6w5BGScPbyN0eEr23XR+I7kpvv7dZlU2fdtTwPf6r3jaPimOFWmsLe79x7+lRuJrb5rFo1SN6LjNRFMbfVhFCWDpwJRg3hA74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748043940; c=relaxed/simple;
	bh=SEXK0VK+JQU/bOtW0FBQ1kj27ypF75gXMt/6JeftB+0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Sks87qflK/EDJDy6ZY6Hc3JhCZ7xF62caJKhBRZyINmBBGVH5q+oNb6sXP7LeM/UNAE3edScZKDpl7pGxkl4g36gd2skoYNrYcn7KUUq+Q65eG0vHQk8ud+XtDu8oj5+FQdWzA8HVtJpoKAjjggo0nr5ELtyNL/cRtC2xuwDuDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QfVSJRNz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QfVSJRNz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D13BC4CEE9;
	Fri, 23 May 2025 23:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748043939;
	bh=SEXK0VK+JQU/bOtW0FBQ1kj27ypF75gXMt/6JeftB+0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QfVSJRNzUG1hW3jU1qF0ubSxdC6GTmQkbo6jbd/3DcXog/evrLgMrmYMBoXfUXEZH
	 ntnubQA/zydqiY4LJGxnvbbX29vsj5ZMZ06VcSvwfjoATGWgS/Yeb68GYz3g6a69ZG
	 FefxKmwLSeQR8kR90/qxxDxLlEFzgcyOQ71o5XEEJlU3ct2IyjEaetTev0mY+uWUuP
	 3oWHbi1GVMrV5dJ1Y7h5ep2cKr2MPR8+RcZQYFrFsCo4iER9cLE4gIotKV6zPaenVt
	 dbIQGmNOlUuXLT7AHVqXZZHD7aB+jadMYFDGjlZKPpNYgPOYazP1qznvWnO/gVvw+q
	 Z0g7oTNHyHtyQ==
Date: Sat, 24 May 2025 02:45:35 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Elena Reshetova <elena.reshetova@intel.com>, seanjc@google.com,
	kai.huang@intel.com, mingo@kernel.org, linux-sgx@vger.kernel.org,
	linux-kernel@vger.kernel.org, x86@kernel.org,
	asit.k.mallick@intel.com, vincent.r.scarlata@intel.com,
	chongc@google.com, erdemaktas@google.com, vannapurve@google.com,
	dionnaglaze@google.com, bondarn@google.com, scott.raynor@intel.com
Subject: Re: [PATCH v6 1/5] x86/sgx: Introduce a counter to count the
 sgx_(vepc_)open()
Message-ID: <aDEIn4Ra6HMEVy9R@kernel.org>
References: <20250522092237.7895-1-elena.reshetova@intel.com>
 <20250522092237.7895-2-elena.reshetova@intel.com>
 <aDCaH2WAMhLhFAVE@kernel.org>
 <d7ae8e13-2b44-4466-b345-fb06b40a24d3@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d7ae8e13-2b44-4466-b345-fb06b40a24d3@intel.com>

On Fri, May 23, 2025 at 08:58:54AM -0700, Dave Hansen wrote:
> On 5/23/25 08:54, Jarkko Sakkinen wrote:
> >> +void sgx_dec_usage_count(void)
> >> +{
> >> +	atomic64_dec(&sgx_usage_count);
> >> +}
> > I think these both should be static inlines in arch/x86/kernel/cpu/sgx.h.
> > Global symbols is over the top. Even if I think disassembly (when doing
> > debugging, bug hunting or similar tasks), it'd nicer that way.
> 
> If they're just used in a single file, make them 'static' and let the
> compiler decide whether to inline them or not.

This would be totally fine.

BR, Jarkko
