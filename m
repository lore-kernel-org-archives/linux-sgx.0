Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D175014A611;
	Thu, 15 Aug 2024 18:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723746585; cv=none; b=I3DkYwH4WfmJdUWIOoCLP6T2KqvfjuhnoRfUjsDpz/JxDAAdZlRIVgH/GHQHydPloLeQEj9t2b6ssAjocpnRdd5/vf4z5ffs9nEj18DFVuaMK4Vt4M6bVR2kIIZqX7SRpX07PnXJWR6Q6mIx4UJZ09GVgxuYooORuEYySbf05EM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723746585; c=relaxed/simple;
	bh=q+X3CuPONGnArmBPh6/5ecdvtUZ7RXqcLb4yZqhSmy4=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=X7cgwIGBLcjT4/aGc7MooaGF/rHFbRFUsrdWjrnzCD/de1SQjoEuDsatHMe0SEtlCPGb6Cti/z6TThI2rszZqaLMbKyNP5RmcowEZxmMV/LLu+L0s/Fg4eatacmgz85TVWfnnZQFgXlIAawru8kdZHOrfFjjhGYNizhBvbEa4ZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cjly4LUv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cjly4LUv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 476CAC4AF1C;
	Thu, 15 Aug 2024 18:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723746585;
	bh=q+X3CuPONGnArmBPh6/5ecdvtUZ7RXqcLb4yZqhSmy4=;
	h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
	b=cjly4LUvcF1Ir6t0RXFi/Z8P2t7RoIwKSKP5ehVcv4AGuBf8WRy2c+wDycLaH8OXL
	 0euhMAgi5v4Ohoi9mDPdPZwsWAz0lyCBAHsXQZkR7sVQFpmM4xl5SoHlx/hT7GjBi6
	 9b+SkZ6buWr+C9efl5gdfH2lYroJ7tq12pk7OdKUOIWKG9uB/Ncmq0wynZTGgIWVRY
	 ywctw+LcLv/ATUrVE/G5nGenKmo2azmxHn/ri/rxROYZihjwZivTHL8U97evHWiGL+
	 yKkp7/yR8RjyMYDMRzKappu0u6Tgk8iuLnVV4ZIGmW7yJW9CCUcXLAcgvn2ESRBgeR
	 OsnfflLBu8YRA==
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 15 Aug 2024 21:29:41 +0300
Message-Id: <D3GP5ZP0ZQB0.27BP8Q6T6978H@kernel.org>
Cc: <dave.hansen@linux.intel.com>, <haitao.huang@linux.intel.com>,
 <kai.huang@intel.com>, <kailun.qin@intel.com>,
 <linux-kernel@vger.kernel.org>, <linux-sgx@vger.kernel.org>,
 <mona.vij@intel.com>, <reinette.chatre@intel.com>, <stable@vger.kernel.org>
Subject: Re: [PATCH v4 1/3] x86/sgx: Split SGX_ENCL_PAGE_BEING_RECLAIMED
 into two flags
From: "Jarkko Sakkinen" <jarkko@kernel.org>
To: "Dmitrii Kuvaiskii" <dmitrii.kuvaiskii@intel.com>
X-Mailer: aerc 0.17.0
References: <D2RQXM679U0X.1XY6BWHSFTRFZ@kernel.org>
 <20240812081216.3006639-1-dmitrii.kuvaiskii@intel.com>
In-Reply-To: <20240812081216.3006639-1-dmitrii.kuvaiskii@intel.com>

On Mon Aug 12, 2024 at 11:12 AM EEST, Dmitrii Kuvaiskii wrote:
> On Wed, Jul 17, 2024 at 01:36:08PM +0300, Jarkko Sakkinen wrote:
> > On Fri Jul 5, 2024 at 10:45 AM EEST, Dmitrii Kuvaiskii wrote:
> > > SGX_ENCL_PAGE_BEING_RECLAIMED flag is set when the enclave page is be=
ing
> > > reclaimed (moved to the backing store). This flag however has two
> > > logical meanings:
> >           ~~~~~~~~
> >         side-effects
>
> Could you clarify the required action here? Do you expect me to replace
> "This flag however has two logical meanings" with "This flag however has
> two logical side-effects"? The suggested word doesn't seem to apply nicel=
y
> to this case. In my text, I have the following two sentences: "Don't
> attempt to load the enclave page" and "Don't attempt to remove the PCMD
> page ...". I don't think it's proper English to say that "Don't attempt
> ..." is a side effect. Or do you want me to also modify the two sentences
> in the list?

I agree with you here, you can ignore this comment.

BR, Jarkko
