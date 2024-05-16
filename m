Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D66038F86;
	Thu, 16 May 2024 08:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715848012; cv=none; b=rE9DOiLnE9ubakQvFUA1ZN9dVLTzIUH7iHjfayyn743gUdK2j6LD2RQiwJkmlJFLSfTSpOcN3+f2VC4u1bba8Wbo5Rs6zvduXD7PHkKvMSeVS9DHDYojWK4UZmoiqDNIwwJI0lLDWr/pTRA7QSrtpXQyTXkWZNI5wN7+nKp0oRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715848012; c=relaxed/simple;
	bh=WIoFwH8zB7Jl59HZ7oYwJwNcVULcP10JP5xKKdRoIzk=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=rWyGyRvaMgsu8UMZ0YzsK4atjdMTMUNSPbUWdfjgFN0jujlaZZFzF7IgKAm4Bv2+1KEVvZTds87ZYw6ewb1rUzwA/bJDjFNRSNcv8DQ8sSmRH1pko/CLF0ZJTrntaEKrcT2g1cLFynAOq0MJWeYdfysaILzXhu7ZNo6QitSAam8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BxI8gMgx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BxI8gMgx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DAA7C113CC;
	Thu, 16 May 2024 08:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715848011;
	bh=WIoFwH8zB7Jl59HZ7oYwJwNcVULcP10JP5xKKdRoIzk=;
	h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
	b=BxI8gMgxAB54Z/Lzl2eEiuuLAipJD0jCmNzMpUmypjQCeLCmTwPfTqYfwXQPbseOX
	 G9TI6Sqpf6rlLLqBIJKuHHG4NrrfHAu/wTFh9YSY8MUSS5aRVOQcSTnAnDhROB2ZqZ
	 lNenUAIGvgX3zKINmCVA5eopDspokXpbNS7XRbMUQczJbpejPgLsBs7VY2nNcRHQUS
	 bS7tzd72HIKU82VM2zVE0kYOXws9gO2cYjLu3dq4Oi/zQkBiDH3sOqSQkgfCqD/eqU
	 0/TIBmtb4wNaRdQcKO/CZzC31dGqOUxnZhjYy7ynXqVWXd2pDhonVS23a+maZqKId1
	 FC9JqjYxt25Sw==
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 16 May 2024 11:26:48 +0300
Message-Id: <D1AXCT1OTHA9.2TJ6JYNJBBT44@kernel.org>
Cc: <reinette.chatre@intel.com>, =?utf-8?b?5YiY5Y+MKOi9qeWxuSk=?=
 <ls123674@antgroup.com>
Subject: Re: [RFC PATCH v3 1/1] x86/sgx: Explicitly give up the CPU in
 EDMM's ioctl() to avoid softlockup
From: "Jarkko Sakkinen" <jarkko@kernel.org>
To: "Haitao Huang" <haitao.huang@linux.intel.com>,
 <linux-kernel@vger.kernel.org>, <linux-sgx@vger.kernel.org>,
 <dave.hansen@linux.intel.com>, "Bojun Zhu" <zhubojun.zbj@antgroup.com>
X-Mailer: aerc 0.17.0
References: <20240515065521.67908-1-zhubojun.zbj@antgroup.com>
 <20240515065521.67908-2-zhubojun.zbj@antgroup.com>
 <op.2nt1vls9wjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <op.2nt3fzsnwjvjmi@hhuan26-mobl.amr.corp.intel.com>
In-Reply-To: <op.2nt3fzsnwjvjmi@hhuan26-mobl.amr.corp.intel.com>

On Thu May 16, 2024 at 1:29 AM EEST, Haitao Huang wrote:
> On Wed, 15 May 2024 16:55:59 -0500, Haitao Huang =20
> <haitao.huang@linux.intel.com> wrote:
>
> > On Wed, 15 May 2024 01:55:21 -0500, Bojun Zhu =20
> > <zhubojun.zbj@antgroup.com> wrote:
> >
> >> EDMM's ioctl()s support batch operations, which may be
> >> time-consuming. Try to explicitly give up the CPU as the prefix
> >> operation at the every begin of "for loop" in
> >> sgx_enclave_{ modify_types | restrict_permissions | remove_pages}
> >> to give other tasks a chance to run, and avoid softlockup warning.
> >>
> >> Additionally perform pending signals check as the prefix operation,
> >> and introduce sgx_check_signal_and_resched(),
> >> which wraps all the checks.
> >>
> >> The following has been observed on Linux v6.9-rc5 with kernel
> >> preemptions disabled(by configuring "PREEMPT_NONE=3Dy"), when kernel
> >> is requested to restrict page permissions of a large number of EPC =20
> >> pages.
> >>
> >>     ------------[ cut here ]------------
> >>     watchdog: BUG: soft lockup - CPU#45 stuck for 22s!
> >>     ...
> >>     RIP: 0010:sgx_enclave_restrict_permissions+0xba/0x1f0
> >>     ...
> >>     Call Trace:
> >>      sgx_ioctl
> >>      __x64_sys_ioctl
> >>      x64_sys_call
> >>      do_syscall_64
> >>      entry_SYSCALL_64_after_hwframe
> >>     ------------[ end trace ]------------
> >>
> >> Signed-off-by: Bojun Zhu <zhubojun.zbj@antgroup.com>
> >> ---
> >>  arch/x86/kernel/cpu/sgx/ioctl.c | 40 +++++++++++++++++++++++---------=
-
> >>  1 file changed, 28 insertions(+), 12 deletions(-)
> >>
> >> diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c =20
> >> b/arch/x86/kernel/cpu/sgx/ioctl.c
> >> index b65ab214bdf5..6199f483143e 100644
> >> --- a/arch/x86/kernel/cpu/sgx/ioctl.c
> >> +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
> >> @@ -365,6 +365,20 @@ static int sgx_validate_offset_length(struct =20
> >> sgx_encl *encl,
> >>  	return 0;
> >>  }
> >> +/*
> >> + * Check signals and invoke scheduler. Return true for a pending =20
> >> signal.
> >> + */
> >> +static bool sgx_check_signal_and_resched(void)
> >> +{
> >> +	if (signal_pending(current))
> >> +		return true;
> >> +
> >> +	if (need_resched())
> >> +		cond_resched();
> >> +
> >> +	return false;
> >> +}
> >> +
> >>  /**
> >>   * sgx_ioc_enclave_add_pages() - The handler for =20
> >> %SGX_IOC_ENCLAVE_ADD_PAGES
> >>   * @encl:       an enclave pointer
> >> @@ -409,7 +423,7 @@ static long sgx_ioc_enclave_add_pages(struct =20
> >> sgx_encl *encl, void __user *arg)
> >>  	struct sgx_enclave_add_pages add_arg;
> >>  	struct sgx_secinfo secinfo;
> >>  	unsigned long c;
> >> -	int ret;
> >> +	int ret =3D -ERESTARTSYS;
> >> 	if (!test_bit(SGX_ENCL_CREATED, &encl->flags) ||
> >>  	    test_bit(SGX_ENCL_INITIALIZED, &encl->flags))
> >> @@ -432,15 +446,8 @@ static long sgx_ioc_enclave_add_pages(struct =20
> >> sgx_encl *encl, void __user *arg)
> >>  		return -EINVAL;
> >> 	for (c =3D 0 ; c < add_arg.length; c +=3D PAGE_SIZE) {
> >> -		if (signal_pending(current)) {
> >> -			if (!c)
> >> -				ret =3D -ERESTARTSYS;
> >> -
> >> +		if (sgx_check_signal_and_resched())
> >>  			break;
> >> -		}
> >
> > ERESTARTSYS is only appropriate if we have not EADDed any pages yet.
> > If we got interrupted in the middle, we should return 0. User space =20
> > would check the 'count' returned and decide to recall this ioctl() with=
 =20
> > 'offset'  reset to the next page, and adjust length.
>
> NVM, I misread it. ret will be changed to zero in subsequent iteration.
>
> Reviewed-by: Haitao Huang <haitao.huang@linux.intel.com>

Duh, and I responded too quickly. OK, I revisited the original
patch and yes ret gets reseted. Ignore my previous response ;-)

My tags still hold, sorry.

BR, Jarkko
