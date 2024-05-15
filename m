Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D908F2CCD0;
	Wed, 15 May 2024 12:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715774782; cv=none; b=ebk0BQ3kyeZiKnj5W5oAxe7Ud0+zY0pfb4NhATAiS6nxW10CLwjR6AsbP6P+FpAkMJILZBHQuczFFyMpz1p0Kkw9ATr5Jy0mLdfKnlzMfodsn7Mn7j8uboDUyyqRcrboj+Q+R+FQENmrt5Zhzwk1jF5MaOI9Rc+EeHa2K/QzMK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715774782; c=relaxed/simple;
	bh=fBp/tINIW/W/kb+0aD/MBS7XiS6Vf70YTcOdC+Nzzu8=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=BHLV35ZHNN07j06ioT0a3nC+KE6PQFCVbbkTgH6lcFj0zAnWh5I7UVr6BUa/xMazhwJujuDWkv3Hbrl/EGdvAH0bGIcaELmiPX+GIoTvDD2bQBu2QIy9+1CZEjWmNj+9g1LBPVa8swvZ7t+u1VB/G+t0XB3I7mKvF+DVxP0EzAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jE1G4tFl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jE1G4tFl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11B7BC32782;
	Wed, 15 May 2024 12:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715774781;
	bh=fBp/tINIW/W/kb+0aD/MBS7XiS6Vf70YTcOdC+Nzzu8=;
	h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
	b=jE1G4tFlE8+tZ8b7ToRce/5HR6xRftU+pd65LJYbajyMV/mZYwddKcvqi4HmBn/05
	 tTqZMTURRct4InNdr4d3cRWODupifG2OZvahfm2gYqAiXwLfqmJRMSSWsYUgrb4RwA
	 mpE1zQHh54/LLouqht5Fm5a2Xq2gxZTAX3xu0TB2eCZNCr5bwocuywfoWuYmVCaflz
	 4ox3qPgixEQ8oyUbeTcZtwrZ/WEFvxBZs6vlTzn5l5MzKmZzBR1RkuALCEmAmGnmTF
	 SIW69+AvQTznfCIabF1Xi1L57+rnWomUPJ+FljglAsJ9Aou+Z+W60A9JAIDhryJBui
	 LeMNcZfMH2WBA==
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 15 May 2024 15:06:18 +0300
Message-Id: <D1A7EBO71WXC.P08C5KQ97AA0@kernel.org>
Cc: <reinette.chatre@intel.com>, =?utf-8?b?5YiY5Y+MKOi9qeWxuSk=?=
 <ls123674@antgroup.com>
Subject: Re: [RFC PATCH v3 1/1] x86/sgx: Explicitly give up the CPU in
 EDMM's ioctl() to avoid softlockup
From: "Jarkko Sakkinen" <jarkko@kernel.org>
To: "Bojun Zhu" <zhubojun.zbj@antgroup.com>, <linux-kernel@vger.kernel.org>,
 <linux-sgx@vger.kernel.org>, <dave.hansen@linux.intel.com>
X-Mailer: aerc 0.17.0
References: <20240515065521.67908-1-zhubojun.zbj@antgroup.com>
 <20240515065521.67908-2-zhubojun.zbj@antgroup.com>
In-Reply-To: <20240515065521.67908-2-zhubojun.zbj@antgroup.com>

On Wed May 15, 2024 at 9:55 AM EEST, Bojun Zhu wrote:
> EDMM's ioctl()s support batch operations, which may be
> time-consuming. Try to explicitly give up the CPU as the prefix
> operation at the every begin of "for loop" in
> sgx_enclave_{ modify_types | restrict_permissions | remove_pages}
> to give other tasks a chance to run, and avoid softlockup warning.
>
> Additionally perform pending signals check as the prefix operation,
> and introduce sgx_check_signal_and_resched(),
> which wraps all the checks.
>
> The following has been observed on Linux v6.9-rc5 with kernel
> preemptions disabled(by configuring "PREEMPT_NONE=3Dy"), when kernel
> is requested to restrict page permissions of a large number of EPC pages.
>
>     ------------[ cut here ]------------
>     watchdog: BUG: soft lockup - CPU#45 stuck for 22s!
>     ...
>     RIP: 0010:sgx_enclave_restrict_permissions+0xba/0x1f0
>     ...
>     Call Trace:
>      sgx_ioctl
>      __x64_sys_ioctl
>      x64_sys_call
>      do_syscall_64
>      entry_SYSCALL_64_after_hwframe
>     ------------[ end trace ]------------
>

Suggested-by: Jarkko Sakkinen <jarkko@kernel.org>

> Signed-off-by: Bojun Zhu <zhubojun.zbj@antgroup.com>
> ---
>  arch/x86/kernel/cpu/sgx/ioctl.c | 40 +++++++++++++++++++++++----------
>  1 file changed, 28 insertions(+), 12 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/io=
ctl.c
> index b65ab214bdf5..6199f483143e 100644
> --- a/arch/x86/kernel/cpu/sgx/ioctl.c
> +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
> @@ -365,6 +365,20 @@ static int sgx_validate_offset_length(struct sgx_enc=
l *encl,
>  	return 0;
>  }
> =20
> +/*
> + * Check signals and invoke scheduler. Return true for a pending signal.
> + */
> +static bool sgx_check_signal_and_resched(void)
> +{
> +	if (signal_pending(current))
> +		return true;
> +
> +	if (need_resched())
> +		cond_resched();
> +
> +	return false;
> +}
> +
>  /**
>   * sgx_ioc_enclave_add_pages() - The handler for %SGX_IOC_ENCLAVE_ADD_PA=
GES
>   * @encl:       an enclave pointer
> @@ -409,7 +423,7 @@ static long sgx_ioc_enclave_add_pages(struct sgx_encl=
 *encl, void __user *arg)
>  	struct sgx_enclave_add_pages add_arg;
>  	struct sgx_secinfo secinfo;
>  	unsigned long c;
> -	int ret;
> +	int ret =3D -ERESTARTSYS;
> =20
>  	if (!test_bit(SGX_ENCL_CREATED, &encl->flags) ||
>  	    test_bit(SGX_ENCL_INITIALIZED, &encl->flags))
> @@ -432,15 +446,8 @@ static long sgx_ioc_enclave_add_pages(struct sgx_enc=
l *encl, void __user *arg)
>  		return -EINVAL;
> =20
>  	for (c =3D 0 ; c < add_arg.length; c +=3D PAGE_SIZE) {
> -		if (signal_pending(current)) {
> -			if (!c)
> -				ret =3D -ERESTARTSYS;
> -
> +		if (sgx_check_signal_and_resched())
>  			break;
> -		}
> -
> -		if (need_resched())
> -			cond_resched();
> =20
>  		ret =3D sgx_encl_add_page(encl, add_arg.src + c, add_arg.offset + c,
>  					&secinfo, add_arg.flags);
> @@ -740,12 +747,15 @@ sgx_enclave_restrict_permissions(struct sgx_encl *e=
ncl,
>  	unsigned long addr;
>  	unsigned long c;
>  	void *epc_virt;
> -	int ret;
> +	int ret =3D -ERESTARTSYS;
> =20
>  	memset(&secinfo, 0, sizeof(secinfo));
>  	secinfo.flags =3D modp->permissions & SGX_SECINFO_PERMISSION_MASK;
> =20
>  	for (c =3D 0 ; c < modp->length; c +=3D PAGE_SIZE) {
> +		if (sgx_check_signal_and_resched())
> +			goto out;
> +
>  		addr =3D encl->base + modp->offset + c;
> =20
>  		sgx_reclaim_direct();
> @@ -898,7 +908,7 @@ static long sgx_enclave_modify_types(struct sgx_encl =
*encl,
>  	unsigned long addr;
>  	unsigned long c;
>  	void *epc_virt;
> -	int ret;
> +	int ret =3D -ERESTARTSYS;
> =20
>  	page_type =3D modt->page_type & SGX_PAGE_TYPE_MASK;
> =20
> @@ -913,6 +923,9 @@ static long sgx_enclave_modify_types(struct sgx_encl =
*encl,
>  	secinfo.flags =3D page_type << 8;
> =20
>  	for (c =3D 0 ; c < modt->length; c +=3D PAGE_SIZE) {
> +		if (sgx_check_signal_and_resched())
> +			goto out;
> +
>  		addr =3D encl->base + modt->offset + c;
> =20
>  		sgx_reclaim_direct();
> @@ -1095,12 +1108,15 @@ static long sgx_encl_remove_pages(struct sgx_encl=
 *encl,
>  	unsigned long addr;
>  	unsigned long c;
>  	void *epc_virt;
> -	int ret;
> +	int ret =3D -ERESTARTSYS;
> =20
>  	memset(&secinfo, 0, sizeof(secinfo));
>  	secinfo.flags =3D SGX_SECINFO_R | SGX_SECINFO_W | SGX_SECINFO_X;
> =20
>  	for (c =3D 0 ; c < params->length; c +=3D PAGE_SIZE) {
> +		if (sgx_check_signal_and_resched())
> +			goto out;
> +
>  		addr =3D encl->base + params->offset + c;
> =20
>  		sgx_reclaim_direct();

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko
