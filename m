Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3288C1946A0;
	Thu,  8 May 2025 20:13:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746735210; cv=none; b=PTIfhyCzltnzBBAH30cGCOCdO9YtPyvE5ycgZTlwa0XbLdCq3b6JmGGeglmVuQ3zU3o9KgYDBFlqblX6eVnpbY/Ul0p/Wb3gtF94lH2B3YjIJhzzdHxU1hQf6XoMp5Q2t5EYAXGSJOw59jLRtYXlatyL5HTNR/VePAflWsrElAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746735210; c=relaxed/simple;
	bh=z6NpZWEcNQggE4OQ7TSBqvkSy2e5LuYgPu+vmnQn+Fg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AGVVaOxtL9PFp7lTZohLgrf4rnOneAPrQRmZRGMCSD77bCFXr7R/TPFIJlkLS0pL+xL/nmOa7HVWG3CORewA1D3Yr2Gcw5Uj8v/mJcfJ+jg5Iwf0Kdouv0KctLUeh7r6W1t19ERwCswV1UGjE6jdDd7ytVz4PMIeo92ayJnUxSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mvdrqLhw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mvdrqLhw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 173EEC4CEE7;
	Thu,  8 May 2025 20:13:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1746735209;
	bh=z6NpZWEcNQggE4OQ7TSBqvkSy2e5LuYgPu+vmnQn+Fg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mvdrqLhwkGxpp8TULqq3TGy6Q5SWzD6bOxJCvrO7nlUEKSQ9YkGBYDEjMrR4oRXEK
	 mhZn1sIzaAkcSUB49D4sADshZpDXQxBmkI4ti6kWhyAQCNaAlxZw8yFIG+aKPh/bfb
	 a/mnBlnvell8Adk/wlUW3aXDbjnNLTUE9hlKe9TDkOTRDfopM+fi6VFj5e1446udnx
	 +0YLgkg5pUR+UKzYKA8TyovRzH7nKExoPLioRdh9++uAuzw2M7xYetSaGKoqHEruDj
	 ET+Z+QiRMb2Qyuq9jWn4xGRhVaTaxt9kom6IC1lGee7+Lnibu3w6CWoljMEDOoxZgf
	 Q13m3/v+vAzCg==
Date: Thu, 8 May 2025 23:13:24 +0300
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: dave.hansen@intel.com, seanjc@google.com, kai.huang@intel.com,
	linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
	x86@kernel.org, asit.k.mallick@intel.com,
	vincent.r.scarlata@intel.com, chongc@google.com,
	erdemaktas@google.com, vannapurve@google.com,
	dionnaglaze@google.com, bondarn@google.com, scott.raynor@intel.com
Subject: Re: [PATCH v4 1/1] x86/sgx: Enable automatic SVN updates for SGX
 enclaves
Message-ID: <aB0QZP4Mi4hydNSx@kernel.org>
References: <20250507111542.709858-1-elena.reshetova@intel.com>
 <20250507111542.709858-2-elena.reshetova@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250507111542.709858-2-elena.reshetova@intel.com>

On Wed, May 07, 2025 at 02:14:00PM +0300, Elena Reshetova wrote:
  
> diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx/driver.c
> index 7f8d1e11dbee..669e44d61f9f 100644
> --- a/arch/x86/kernel/cpu/sgx/driver.c
> +++ b/arch/x86/kernel/cpu/sgx/driver.c
> @@ -19,6 +19,10 @@ static int sgx_open(struct inode *inode, struct file *file)
>  	struct sgx_encl *encl;
>  	int ret;
>  
> +	ret = sgx_inc_usage_count();
> +	if (ret)
> +		return ret;
> +
>  	encl = kzalloc(sizeof(*encl), GFP_KERNEL);
>  	if (!encl)
>  		return -ENOMEM;

The rollback looks broken to me.

Let's clean up error handling a bit:

	encl = kzalloc(sizeof(*encl), GFP_KERNEL);
	if (!encl) {
		ret = -ENOMEM;
		goto err_usage_count;
	}

And later on in the same function:

	ret = init_srcu_struct(&encl->srcu);
	if (ret)
		goto err_encl;

And finally tail:

	return 0;

err_encl:
	kfree(encl);

err_usage_count:
	sgx_dec_usage_count();
	return ret;
}

BR, Jarkko
