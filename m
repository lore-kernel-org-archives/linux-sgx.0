Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEB06226CF4;
	Mon, 10 Mar 2025 09:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741599877; cv=none; b=f1Va5LgHscWRlBXP3XiFGYQSjuOss9zb8W7A+eGoBLSiE6TDaqfIXlZy4XpFsa8cre+0IvIgai7eDGX9Z/RfGn7nWAi4xE1d6va+TtztOIFA0P3e5aymyjZ6X+D8PVeKT3FppAlwTj58WIMl66GCinKA3XQUm42kCak+FcjdtN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741599877; c=relaxed/simple;
	bh=mW+HGFl9pijv6Y13n7rhWie0eRqRBZv5zMhBMfe1XjY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K+lXeUD5VELwGJdnNoh7jKQqb2yWgHFveudElscEsKeEBp4BldJ8NV2oVTezQ5MWjbddSD5T5PLqdPJvPZpsmJmO6jAqqLwpqrXlcHQF6zIRnSDu+inPHo3Wk9AIc9dSUe3pTyXJ+6FctmgrOLn7z6LKHcxfFBkrHQv78aIvUAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c+I/UHGs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c+I/UHGs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC8C8C4CEE5;
	Mon, 10 Mar 2025 09:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741599876;
	bh=mW+HGFl9pijv6Y13n7rhWie0eRqRBZv5zMhBMfe1XjY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=c+I/UHGsN77ZHd0V4gwNp9OaevgOF2J0vdzxi/Z1MpATLZbmJUyEL+ndLn/KMz8ZL
	 1w2doVUP7/EqP4w37C1rFpSaa82M4+tbd1I9JuE8eOstLCU6iJ4nNy41rrykRfmeBp
	 GWS8MjXB2nqOUaCAAMJse/sHVCmaIweXkxAUMwwHhsNUdsg1fG7IRjwZ4Eo5AVzxUi
	 L8LVVcEOVKUACmOEoLQaIY/QrQaNcCYUICLbobc/2FE0Or8C/5S2JzTO2F0ngoK5y1
	 CrtI/VsWHs58iJ3oQs2Zu3Ruqn/tGwRQ92i3bVfTqxX/NVeEctvYiq3WC04sMImbW7
	 NHo/UyQFesqDg==
Date: Mon, 10 Mar 2025 11:44:32 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Vladis Dronov <vdronov@redhat.com>
Cc: linux-sgx@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/sgx: Warn explicitly if X86_FEATURE_SGX_LC is not
 enabled
Message-ID: <Z860gFRrwI8Cxycq@kernel.org>
References: <20250309165805.8996-2-vdronov@redhat.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250309165805.8996-2-vdronov@redhat.com>

On Sun, Mar 09, 2025 at 05:58:06PM +0100, Vladis Dronov wrote:
> A kernel requires X86_FEATURE_SGX_LC to be able to create SGX enclaves.
> There is quite a number of hardware which has X86_FEATURE_SGX but not
> X86_FEATURE_SGX_LC. A kernel running on such a hardware does not create
> /dev/sgx* devices silently. Explicitly warn if X86_FEATURE_SGX_LC is not
> enabled to properly nofity a user about this condition.
                      ~~~~~~
		      notify

> 
> The X86_FEATURE_SGX_LC is a CPU feature that enables LE hash MSRs to be
> writable when running native enclaves, i.e. using a custom root key rather
> than the Intel proprietary key for enclave signing.
> 
> Signed-off-by: Vladis Dronov <vdronov@redhat.com>
> ---
> 
> an out-of-commit-message note:
> 
> I've hit this issue myself and have spent some time researching where are
> my /dev/sgx* devices on an SGX-enabled hardware, so this is a bit personal.
> 
> Links related:
> https://github.com/intel/linux-sgx/issues/837
> https://patchwork.kernel.org/project/platform-driver-x86/patch/20180827185507.17087-3-jarkko.sakkinen@linux.intel.com/
> 
>  arch/x86/kernel/cpu/sgx/driver.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx/driver.c
> index 22b65a5f5ec6..df4fbfaa6616 100644
> --- a/arch/x86/kernel/cpu/sgx/driver.c
> +++ b/arch/x86/kernel/cpu/sgx/driver.c
> @@ -150,8 +150,10 @@ int __init sgx_drv_init(void)
>  	u64 xfrm_mask;
>  	int ret;
>  
> -	if (!cpu_feature_enabled(X86_FEATURE_SGX_LC))
> +	if (!cpu_feature_enabled(X86_FEATURE_SGX_LC)) {
> +		pr_err("SGX disabled: SGX launch control is not available.\n");

I think this should not be error, as the system is not failing.

Since it is informative, it should be info-level message.

>  		return -ENODEV;
> +	}
>  
>  	cpuid_count(SGX_CPUID, 0, &eax, &ebx, &ecx, &edx);
>  
> -- 
> 2.48.1
> 

BR, Jarkko
