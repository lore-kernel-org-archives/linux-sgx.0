Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23C8DEEB1;
	Mon, 19 May 2025 08:00:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747641628; cv=none; b=W1s+v8OLt1mN8oFZ2ktQVWsyoy9tzJBkayPZ1iF904HvR2jd4c4CkwgrRINsIqpK3/OfBOZALgohfLjB56Y9zH3eiTV7JlWUXkP0c80PGvhN81bCsAhfWF+spj1NoQCQEWQZihGgxeuB10LkOtcpDUn8OgvZhpTNG53wbmi8vKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747641628; c=relaxed/simple;
	bh=ReIrpwlMjRINoXhV5GK1FvcnhwaVGliGmgqbamixfGk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mp0JfVDUBLE0WpZkuxUszY79huUeWYEqqMc/uHs3WxOulvPFV2u/bUMuUSNeMdMH0MfxlzTJlUmQPhFuImoM6CGjxZg2BCQFhzkIsfFvtqsa6r8JhQ4fzTE2Jb3QxaihHOYEO3Cu6h6juDwvJxc4A/BJEHqAQ5snyPExS3GGeIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b6ZqJEZD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b6ZqJEZD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 758E8C4CEED;
	Mon, 19 May 2025 08:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747641628;
	bh=ReIrpwlMjRINoXhV5GK1FvcnhwaVGliGmgqbamixfGk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b6ZqJEZDybTM8hFVHrbgfhtZT7xtJMM79xEA66TDU40YEeAg7RG1uytrNIPKHjiZ2
	 PDGNv1psljultl4PyoQEBlnBwxo5TAD1ovk/0OffyenffymQJBGhDU5Jp7P7I/moPA
	 cfnotFHdGYqBleoG4TwIxrPmPxtAP+x88BeoZJxTEcoMJ1bsv6YUToKqJczSyeT7hk
	 IndpwlIkxo/KrvzTNpv38pwJJqZ5gvqWsuPq4XWEyxMXt63QfdxhngNbTcSLiuXBho
	 YWo6DgmCey2y9/jeQBMox77T2IOTh9X0/8S6Zr6IMGdPvkWwC6y7aBnnhhfd4vDbJl
	 dATKG2pHdLnHg==
Date: Mon, 19 May 2025 10:00:21 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: dave.hansen@intel.com, jarkko@kernel.org, seanjc@google.com,
	kai.huang@intel.com, linux-sgx@vger.kernel.org,
	linux-kernel@vger.kernel.org, x86@kernel.org,
	asit.k.mallick@intel.com, vincent.r.scarlata@intel.com,
	chongc@google.com, erdemaktas@google.com, vannapurve@google.com,
	dionnaglaze@google.com, bondarn@google.com, scott.raynor@intel.com
Subject: Re: [PATCH v5 5/5] x86/sgx: Enable automatic SVN updates for SGX
 enclaves
Message-ID: <aCrlFfl2lAzzHOA8@gmail.com>
References: <20250519072603.328429-1-elena.reshetova@intel.com>
 <20250519072603.328429-6-elena.reshetova@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250519072603.328429-6-elena.reshetova@intel.com>


* Elena Reshetova <elena.reshetova@intel.com> wrote:

> @@ -19,10 +19,15 @@ static int sgx_open(struct inode *inode, struct file *file)
>  	struct sgx_encl *encl;
>  	int ret;
>  
> +	ret = sgx_inc_usage_count();
> +	if (ret)
> +		return -EBUSY;

So if sgx_inc_usage_count() returns nonzero, it's in use already and we 
return -EBUSY, right?

But:

>  int sgx_inc_usage_count(void)
>  {
> +	int ret;
> +
> +	/*
> +	 * Increments from non-zero indicate EPC other
> +	 * active EPC users and EUPDATESVN is not attempted.
> +	 */
> +	if (atomic64_inc_not_zero(&sgx_usage_count))
> +		return 0;

If sgx_usage_count is 1 here (ie. it's busy), this will return *zero*, 
and sgx_open() will not run into the -EBUSY condition and will continue 
assuming it has claimed the usage count, while it hasn't ...

Furthermore, in the sgx_open() error paths we can then run into 
sgx_dec_usage_count(), which will merrily underflow the counter into 
negative:

 +void sgx_dec_usage_count(void)
 +{
 +       atomic64_dec(&sgx_usage_count);
 +}

How is this all supposed to work?

Thanks,

	Ingo
