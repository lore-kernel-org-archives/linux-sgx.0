Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3DBD57CA1;
	Wed, 15 May 2024 13:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715781394; cv=none; b=hdFAjlMSgo6xdpwd7/A1mig2mwhSHojM3CS3Z3fSjcU+MQdJt0O3Fg5C7LFtpHxcd96nlzfMWtIQTpvq+XdzWYr0ifo4ATvyQGjQROjPjqTTBi4WFEV4eoOL+uoBdZbqUrhHWD9BkzamqrevTvwCDiR/Aj1Ih+fEpcMkXDqVpYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715781394; c=relaxed/simple;
	bh=x5d5maiHYQceAd2mdSo7gyBviByo2OZ+3BbIm3Oj2T4=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:Cc:Subject:From:
	 References:In-Reply-To; b=di6tnSoqOvJaNnH3liGvNncoP47xxkhWcdFqgSQXD1Gy2NjWJ6l2x7FoAdm8A6sSoEXWfzcp1mKBOLdViAyGu8yMR+HR9+uq5yA6rFLlem4MBLLsgNRScPZ7wrA6UlUAkVqfdKHKfvZnPrpo4em9O9QmVJ4KFUO4d4eJYMdCATk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HUjyS7Qa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HUjyS7Qa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F172DC116B1;
	Wed, 15 May 2024 13:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715781394;
	bh=x5d5maiHYQceAd2mdSo7gyBviByo2OZ+3BbIm3Oj2T4=;
	h=Date:To:Cc:Subject:From:References:In-Reply-To:From;
	b=HUjyS7Qa8zShSh+L6xvl2u3ru30ewgN07Pi7AJnUIjJqSnbGdNs1eIIhbCzwSCBQb
	 0pt/nEhcuTg+kfv/pVRd/BSZXseGv58KzHN9Elp+JSnnouVfX2P3zvE3qqG/SXPwz2
	 nWfjryzIQKbMJGeFNFyx3TFk3s7hLXc5VKIoM257DF0CJxFdZqKoLGrlX0fqQTJBeh
	 8YiuOkQEGbqQD9fZt9YjFwgm+h2IMRWublOlacp0pnpEUIMA6Xtv4/b5Xxu9HF148l
	 jNVIwLutbCy2CD1n3/cdKywlBWfBR/+61rDRtfsyYasnrDpz+5aZlScY0gj52UxZ6m
	 Clm1gN04v+PMw==
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 15 May 2024 16:56:30 +0300
Message-Id: <D1A9QP6G0PW4.2HI60Q8GUT5YE@kernel.org>
To: "Jarkko Sakkinen" <jarkko@kernel.org>, "Dmitrii Kuvaiskii"
 <dmitrii.kuvaiskii@intel.com>, <dave.hansen@linux.intel.com>,
 <kai.huang@intel.com>, <haitao.huang@linux.intel.com>,
 <reinette.chatre@intel.com>, <linux-sgx@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
Cc: <mona.vij@intel.com>, <kailun.qin@intel.com>, <stable@vger.kernel.org>,
 =?utf-8?q?Marcelina_Ko=C5=9Bcielnicka?= <mwk@invisiblethingslab.com>
Subject: Re: [PATCH v2 1/2] x86/sgx: Resolve EAUG race where losing thread
 returns SIGBUS
From: "Jarkko Sakkinen" <jarkko@kernel.org>
X-Mailer: aerc 0.17.0
References: <20240515131240.1304824-1-dmitrii.kuvaiskii@intel.com>
 <20240515131240.1304824-2-dmitrii.kuvaiskii@intel.com>
 <D1A9PC6LWL2S.38KB2X3EL9X79@kernel.org>
In-Reply-To: <D1A9PC6LWL2S.38KB2X3EL9X79@kernel.org>

On Wed May 15, 2024 at 4:54 PM EEST, Jarkko Sakkinen wrote:
> On Wed May 15, 2024 at 4:12 PM EEST, Dmitrii Kuvaiskii wrote:
> > diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/e=
ncl.c
> > index 279148e72459..41f14b1a3025 100644
> > --- a/arch/x86/kernel/cpu/sgx/encl.c
> > +++ b/arch/x86/kernel/cpu/sgx/encl.c
> > @@ -382,8 +382,11 @@ static vm_fault_t sgx_encl_eaug_page(struct vm_are=
a_struct *vma,
> >  	 * If ret =3D=3D -EBUSY then page was created in another flow while
> >  	 * running without encl->lock
> >  	 */
> > -	if (ret)
> > +	if (ret) {
> > +		if (ret =3D=3D -EBUSY)
> > +			vmret =3D VM_FAULT_NOPAGE;
> >  		goto err_out_shrink;
> > +	}
>
> I agree that there is a bug but it does not categorize as race
> condition.
>
> The bug is simply that for a valid page SIGBUS might be returned.
> The fix is correct but the claim is not.
>
> > =20
> >  	pginfo.secs =3D (unsigned long)sgx_get_epc_virt_addr(encl->secs.epc_p=
age);
> >  	pginfo.addr =3D encl_page->desc & PAGE_MASK;
> > @@ -419,7 +422,7 @@ static vm_fault_t sgx_encl_eaug_page(struct vm_area=
_struct *vma,
> >  err_out_shrink:
> >  	sgx_encl_shrink(encl, va_page);
> >  err_out_epc:
> > -	sgx_encl_free_epc_page(epc_page);
> > +	sgx_free_epc_page(epc_page);
> >  err_out_unlock:
> >  	mutex_unlock(&encl->lock);
> >  	kfree(encl_page);
>
> Agree with code change 100% but not with the description.
>
> I'd cut out 90% of the description out and just make the argument of
> the wrong error code, and done. The sequence is great for showing
> how this could happen. The prose makes my head hurt tbh.

Also please remember that stable maintainers need to read all of that
if this is a bug fix (it is a bug fix!) :-) So shorted possible legit
argument, no prose and the sequence was awesome :-)

BR, Jarkko
