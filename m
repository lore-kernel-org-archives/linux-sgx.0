Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D6838F86;
	Thu, 16 May 2024 08:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715847894; cv=none; b=hfg6l1sEgOvK3RGbLxNzgKteK1bSPREKnd/5KOOLrLff/pn3SfkRHYvMatmhWxnSBNX5Wa0EwNz9+eLmZvOrKwAPao2CYut1mYW/NF/QIowOF78JPN2mTBf5mUnsFplVuMi5CkqQo8Vvd4jFaVslGocI5aVRn5QY7UzxTG23DgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715847894; c=relaxed/simple;
	bh=mfmOSWeRpr06S6hnFqVfVeZE8LfmZzNlFfPbTukt/dM=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:Cc:Subject:From:
	 References:In-Reply-To; b=NbTBdbLGli44x6N7FnleKcCf95Y+tn00Zo6nrzqsEZV4AsCHG6AfaScnFa/AZVGJPYVN2M3JhvNKVI6Vk+WOAsCcMPdaxKcjnhvru/bYslGsyqUvfoL+Y70rl/HaNc09FyLAveR+p8klar0H5Vp1u28JuQJnVpWws7g4yEqCQsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FUWnh2mw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FUWnh2mw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72544C113CC;
	Thu, 16 May 2024 08:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715847893;
	bh=mfmOSWeRpr06S6hnFqVfVeZE8LfmZzNlFfPbTukt/dM=;
	h=Date:To:Cc:Subject:From:References:In-Reply-To:From;
	b=FUWnh2mw8dx4iLAKE+vH3FOKbTruo+x6R9YeaA30lqaDHhvTbW0K2njOKdmZ5XxYs
	 GDXiK9Pr51kX6TzNmiJQ6QWxa/ksZugcB1Pw5NNOHAyYHlkWol97uLONwGDFrgE19J
	 6zo9Maxe8ppDeRY8idEEY+WxxjdTrzyqaG9HqDFAOBgNm1e3Cpp5mBPc2W9T7YRgyo
	 N5AG0IxKcrr8GN2SWEDIm3Quc/oBT2RErssXjKicNcRLdHGmm4K14ogFmsORwgdkJu
	 zXTA/s+/9BOLFVF1iVLgtP7LxVe5Ps86ybCMj4l0eNIQuNUzXpIb94fbcT81KrvlG2
	 RdNOy6ZmbN1Mg==
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 16 May 2024 11:24:50 +0300
Message-Id: <D1AXBB05CMIB.3STPF6CZCSMK3@kernel.org>
To: "Haitao Huang" <haitao.huang@linux.intel.com>,
 <linux-kernel@vger.kernel.org>, <linux-sgx@vger.kernel.org>,
 <dave.hansen@linux.intel.com>, "Bojun Zhu" <zhubojun.zbj@antgroup.com>
Cc: <reinette.chatre@intel.com>, =?utf-8?b?5YiY5Y+MKOi9qeWxuSk=?=
 <ls123674@antgroup.com>
Subject: Re: [RFC PATCH v3 1/1] x86/sgx: Explicitly give up the CPU in
 EDMM's ioctl() to avoid softlockup
From: "Jarkko Sakkinen" <jarkko@kernel.org>
X-Mailer: aerc 0.17.0
References: <20240515065521.67908-1-zhubojun.zbj@antgroup.com>
 <20240515065521.67908-2-zhubojun.zbj@antgroup.com>
 <op.2nt1vls9wjvjmi@hhuan26-mobl.amr.corp.intel.com>
In-Reply-To: <op.2nt1vls9wjvjmi@hhuan26-mobl.amr.corp.intel.com>

On Thu May 16, 2024 at 12:55 AM EEST, Haitao Huang wrote:
> On Wed, 15 May 2024 01:55:21 -0500, Bojun Zhu <zhubojun.zbj@antgroup.com>=
 =20
> wrote:
>
> > EDMM's ioctl()s support batch operations, which may be
> > time-consuming. Try to explicitly give up the CPU as the prefix
> > operation at the every begin of "for loop" in
> > sgx_enclave_{ modify_types | restrict_permissions | remove_pages}
> > to give other tasks a chance to run, and avoid softlockup warning.
> >
> > Additionally perform pending signals check as the prefix operation,
> > and introduce sgx_check_signal_and_resched(),
> > which wraps all the checks.
> >
> > The following has been observed on Linux v6.9-rc5 with kernel
> > preemptions disabled(by configuring "PREEMPT_NONE=3Dy"), when kernel
> > is requested to restrict page permissions of a large number of EPC page=
s.
> >
> >     ------------[ cut here ]------------
> >     watchdog: BUG: soft lockup - CPU#45 stuck for 22s!
> >     ...
> >     RIP: 0010:sgx_enclave_restrict_permissions+0xba/0x1f0
> >     ...
> >     Call Trace:
> >      sgx_ioctl
> >      __x64_sys_ioctl
> >      x64_sys_call
> >      do_syscall_64
> >      entry_SYSCALL_64_after_hwframe
> >     ------------[ end trace ]------------
> >
> > Signed-off-by: Bojun Zhu <zhubojun.zbj@antgroup.com>
> > ---
> >  arch/x86/kernel/cpu/sgx/ioctl.c | 40 +++++++++++++++++++++++----------
> >  1 file changed, 28 insertions(+), 12 deletions(-)
> >
> > diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c =20
> > b/arch/x86/kernel/cpu/sgx/ioctl.c
> > index b65ab214bdf5..6199f483143e 100644
> > --- a/arch/x86/kernel/cpu/sgx/ioctl.c
> > +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
> > @@ -365,6 +365,20 @@ static int sgx_validate_offset_length(struct =20
> > sgx_encl *encl,
> >  	return 0;
> >  }
> > +/*
> > + * Check signals and invoke scheduler. Return true for a pending signa=
l.
> > + */
> > +static bool sgx_check_signal_and_resched(void)
> > +{
> > +	if (signal_pending(current))
> > +		return true;
> > +
> > +	if (need_resched())
> > +		cond_resched();
> > +
> > +	return false;
> > +}
> > +
> >  /**
> >   * sgx_ioc_enclave_add_pages() - The handler for =20
> > %SGX_IOC_ENCLAVE_ADD_PAGES
> >   * @encl:       an enclave pointer
> > @@ -409,7 +423,7 @@ static long sgx_ioc_enclave_add_pages(struct =20
> > sgx_encl *encl, void __user *arg)
> >  	struct sgx_enclave_add_pages add_arg;
> >  	struct sgx_secinfo secinfo;
> >  	unsigned long c;
> > -	int ret;
> > +	int ret =3D -ERESTARTSYS;
> > 	if (!test_bit(SGX_ENCL_CREATED, &encl->flags) ||
> >  	    test_bit(SGX_ENCL_INITIALIZED, &encl->flags))
> > @@ -432,15 +446,8 @@ static long sgx_ioc_enclave_add_pages(struct =20
> > sgx_encl *encl, void __user *arg)
> >  		return -EINVAL;
> > 	for (c =3D 0 ; c < add_arg.length; c +=3D PAGE_SIZE) {
> > -		if (signal_pending(current)) {
> > -			if (!c)
> > -				ret =3D -ERESTARTSYS;
> > -
> > +		if (sgx_check_signal_and_resched())
> >  			break;
> > -		}
>
> ERESTARTSYS is only appropriate if we have not EADDed any pages yet.
> If we got interrupted in the middle, we should return 0. User space would=
 =20
> check the 'count' returned and decide to recall this ioctl() with =20
> 'offset'  reset to the next page, and adjust length.

Good catch! Thanks Haitao for the remark.

BR, Jarkko
