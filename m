Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5559077F12;
	Thu, 15 Aug 2024 18:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723746722; cv=none; b=D3CcsuiCyzwxwqf67q9Cd4ExFa7WiLRvLCJbsQCPg9b6BxrTwVAZZsGS0xMzOt9xWqKPOf3rV24g/sWI5rwyyBzq5xNAOqELCviwTk7K146flahgzAx9fwAdxxKblffZXHWXNao0ZRp7kHFKBu+rsDdF3qH911dC5gw6gyC85yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723746722; c=relaxed/simple;
	bh=Y7EHmwd/CeR/SS+7FWAk45oeR4TrV6QE9IqVtB7xOPY=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=SD+m10NqIiH8IvVbkX6f2vTkA6jfsyFWxbwTlhvszsYwcrMYj0qhl0UilK+7AJ0J8crLqBMlSiU6tUwFZ1qTOfIqDjmveVMdE2JMhxFdVhCm1ojBmgj0j0sVfP3ZXLDzxiKO8TaDMLqN+P4+rSDYVPU7XMquCkatLC7cy10o/k8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lAC6EpKe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lAC6EpKe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84173C32786;
	Thu, 15 Aug 2024 18:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723746721;
	bh=Y7EHmwd/CeR/SS+7FWAk45oeR4TrV6QE9IqVtB7xOPY=;
	h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
	b=lAC6EpKeE4LTEp7pP3exbqqQQVdZhj4dmL/Z8jSbWYAMrWCshMfaU9EjFMQkxyUU1
	 r+eDNVUAxb+0gMKVGWJsY1mT4y5bJaVEGLee4q0xeZr+FEgKPVdF+aJvVe8KW6BoPY
	 m2S7TnZEJNfB0kaXAcny6k0qu2wXgPy/CvqJw4HLk4O/0DNDh3zbaBZOdCryGsjnCU
	 F8YdeuQS6xxIGFKdppqu5X29/M+PTq+0s79dWMvrZu9NATjLWdUxOVErrVA3xB5Vqa
	 HKtyH60xZqiVL7BumlJNsWFlUNdLX8edWAkJpbeBrt9o5D55YQ1OCXsm/yf7kcWrdy
	 HraMlCVsrbv4Q==
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 15 Aug 2024 21:31:58 +0300
Message-Id: <D3GP7QBXLI5I.23OK0CUOYY93A@kernel.org>
Cc: <dave.hansen@linux.intel.com>, <haitao.huang@linux.intel.com>,
 <kai.huang@intel.com>, <kailun.qin@intel.com>,
 <linux-kernel@vger.kernel.org>, <linux-sgx@vger.kernel.org>,
 <mona.vij@intel.com>, <mwk@invisiblethingslab.com>,
 <reinette.chatre@intel.com>, <stable@vger.kernel.org>
Subject: Re: [PATCH v4 2/3] x86/sgx: Resolve EAUG race where losing thread
 returns SIGBUS
From: "Jarkko Sakkinen" <jarkko@kernel.org>
To: "Dmitrii Kuvaiskii" <dmitrii.kuvaiskii@intel.com>
X-Mailer: aerc 0.17.0
References: <D2RQZIG59264.2S8OC7IYWLA0F@kernel.org>
 <20240812082128.3084051-1-dmitrii.kuvaiskii@intel.com>
In-Reply-To: <20240812082128.3084051-1-dmitrii.kuvaiskii@intel.com>

On Mon Aug 12, 2024 at 11:21 AM EEST, Dmitrii Kuvaiskii wrote:
> On Wed, Jul 17, 2024 at 01:38:37PM +0300, Jarkko Sakkinen wrote:
>
> > Fixes should be in the head of the series so please reorder.
>
> Do you mean that the preparation patch [1] should be applied after the tw=
o
> bug fixes? This seems to not make sense -- isn't it more correct to first
> refactor code, and then to fix in a cleaner way? I thought that was the
> point of previous Dave Hansen's comments [2].
>
> [1] https://lore.kernel.org/all/20240705074524.443713-2-dmitrii.kuvaiskii=
@intel.com/
> [2] https://lore.kernel.org/all/1d405428-3847-4862-b146-dd57711c881e@inte=
l.com/
>
> --
> Dmitrii Kuvaiskii

OK, I read the references you put, and  agree with you here. Thanks for the=
 remarks.

BR, Jarkko
