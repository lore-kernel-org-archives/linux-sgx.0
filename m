Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B4B113F427;
	Wed, 15 May 2024 13:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715781288; cv=none; b=NmGZlvCf+aHz5pZTW/Yxoch5W/EeG+120Wespd7n2UW54Y3bA9WuLitxiTpjpjmJE1juzCR5rUm0KgeTEs+4uXorTOyzKc01eODLK4ZzxktxWd0+ug7UAvzkiDxa7CcYeoH25hKoudwzudLePn02uh1eEqST71UVxz7MZeS0RVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715781288; c=relaxed/simple;
	bh=aNGBFfluPLrID2GK0RnkRS1qTZInjc6Ydx13s+5hfbY=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:Cc:Subject:From:
	 References:In-Reply-To; b=NZ1GOI/0Y3qa4GKbMb5Eu+MmmaN7ITI+PD6EdpP3TsBP0X4X89LCA42RETaYckd9eMJ5AUoMqwSnj6y8lCQQh6KKM61s1G3RJOouV4RzI2G866OF/FTfzbTPEMNJnvwITgG4oMlMLy31Q6b7C/obcwLijiCE/GaBfo9waX7Z+8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qg7R0Khw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qg7R0Khw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 844BFC4AF08;
	Wed, 15 May 2024 13:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715781287;
	bh=aNGBFfluPLrID2GK0RnkRS1qTZInjc6Ydx13s+5hfbY=;
	h=Date:To:Cc:Subject:From:References:In-Reply-To:From;
	b=qg7R0KhwJOI0A/AvL36SPK+Qh66Ef8ejT5DyfwwtQ6eH1jTDB/WUrwpYBBYbbGbII
	 OtNgRWbiYV6Vjssp5wX5QJ0OLYDIspefBu9FLFy8YfmOCBsSMxD+6Xcofh0sU6lr9m
	 BdRqP1P+gSnKdFxLMTdK85oRIWjVwZdU10FA0JWruh56cmrnrf60SMXXp7l2blGW9B
	 MR+HXRL+/wwmS5BOcjly54WEI6Lf88d6I84HzQuLKDwy29lr4Ks17ze0e2tGOJekSk
	 YJvWgqSD0J59TVIGrqip2zb6fs9CaPMQ3b3bbNz6PEeHd3ZBF0oOtpF3B1ZbTJQIJO
	 h61WTfPBrKFOw==
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 15 May 2024 16:54:43 +0300
Message-Id: <D1A9PC6LWL2S.38KB2X3EL9X79@kernel.org>
To: "Dmitrii Kuvaiskii" <dmitrii.kuvaiskii@intel.com>,
 <dave.hansen@linux.intel.com>, <kai.huang@intel.com>,
 <haitao.huang@linux.intel.com>, <reinette.chatre@intel.com>,
 <linux-sgx@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Cc: <mona.vij@intel.com>, <kailun.qin@intel.com>, <stable@vger.kernel.org>,
 =?utf-8?q?Marcelina_Ko=C5=9Bcielnicka?= <mwk@invisiblethingslab.com>
Subject: Re: [PATCH v2 1/2] x86/sgx: Resolve EAUG race where losing thread
 returns SIGBUS
From: "Jarkko Sakkinen" <jarkko@kernel.org>
X-Mailer: aerc 0.17.0
References: <20240515131240.1304824-1-dmitrii.kuvaiskii@intel.com>
 <20240515131240.1304824-2-dmitrii.kuvaiskii@intel.com>
In-Reply-To: <20240515131240.1304824-2-dmitrii.kuvaiskii@intel.com>

On Wed May 15, 2024 at 4:12 PM EEST, Dmitrii Kuvaiskii wrote:
> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/enc=
l.c
> index 279148e72459..41f14b1a3025 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -382,8 +382,11 @@ static vm_fault_t sgx_encl_eaug_page(struct vm_area_=
struct *vma,
>  	 * If ret =3D=3D -EBUSY then page was created in another flow while
>  	 * running without encl->lock
>  	 */
> -	if (ret)
> +	if (ret) {
> +		if (ret =3D=3D -EBUSY)
> +			vmret =3D VM_FAULT_NOPAGE;
>  		goto err_out_shrink;
> +	}

I agree that there is a bug but it does not categorize as race
condition.

The bug is simply that for a valid page SIGBUS might be returned.
The fix is correct but the claim is not.

> =20
>  	pginfo.secs =3D (unsigned long)sgx_get_epc_virt_addr(encl->secs.epc_pag=
e);
>  	pginfo.addr =3D encl_page->desc & PAGE_MASK;
> @@ -419,7 +422,7 @@ static vm_fault_t sgx_encl_eaug_page(struct vm_area_s=
truct *vma,
>  err_out_shrink:
>  	sgx_encl_shrink(encl, va_page);
>  err_out_epc:
> -	sgx_encl_free_epc_page(epc_page);
> +	sgx_free_epc_page(epc_page);
>  err_out_unlock:
>  	mutex_unlock(&encl->lock);
>  	kfree(encl_page);

Agree with code change 100% but not with the description.

I'd cut out 90% of the description out and just make the argument of
the wrong error code, and done. The sequence is great for showing
how this could happen. The prose makes my head hurt tbh.

BR, Jarkko
