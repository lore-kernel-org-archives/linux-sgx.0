Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0722F19A;
	Wed, 17 Jul 2024 10:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721212664; cv=none; b=KqRu/tlsswdw0PWQliAX+bHzXCwpS2dUvyEJkJu81X3vOAl6ZFxOcnELfpeYxPc456GRjWnylbweYxS0YpyzkRqTVHchQkjgYXj2UIOuBpVy+gvi7fzFm5aUzXLe7ikAJyRIyJsgA32208KQjtPP0TVwQJTIDMg+EdR0/GJbeME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721212664; c=relaxed/simple;
	bh=Q6yyNkLiYys3XP9OlDbfuiCgNIFjGCNTRdJbEkT/PXc=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=T0L9QnXCevcIbMYerXw7FeQa0g9HVsUehUQJayojSYanoH6+w+iIt2adFkCzz/5XRmOmyWbO6eIKIEU1Uqnijq7brc64NTxG0rmEWVipjez5FEH3bsDa50PeSzIZUUiGbh7zkGYXS0slb58gl6Swl3LNo6Wek3lIsWX+ySmVyZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rkheZPyq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rkheZPyq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DF4CC32782;
	Wed, 17 Jul 2024 10:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721212663;
	bh=Q6yyNkLiYys3XP9OlDbfuiCgNIFjGCNTRdJbEkT/PXc=;
	h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
	b=rkheZPyqtD98e2RUHQaBGgQxUg0mDrE9Pwit7Q74g34rDIbxkO1sK95yIVa3wCRX5
	 b3XCtK1VdPD8i8+8Fehl38nxd1txOCisrpcbyCMhZ+ViQnCgvv0e7qqvHSJo1mneKg
	 TekrnKj3NNn3ZrllBLRsRjFpyxeMTsnD5m7dvZiF4t8g1O84AQHbUiwWYuQ9mfhP0r
	 AMS5MP9Sdde18wMnyk5n323j2LspjxZnFsWcPL/H4KKYBePvwTsf6+ZXT/gp8BzExC
	 YGRvLZ7l2jPj0Q9uyCqZJDUPf4Ay22M01moPuJh0SDNIIhvrbuj59/HgolKfayhzsF
	 b1qmhpC5u9z2Q==
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 17 Jul 2024 13:37:39 +0300
Message-Id: <D2RQYS2CVEWL.3IU1P67NT0D5Y@kernel.org>
Cc: <mona.vij@intel.com>, <kailun.qin@intel.com>, <stable@vger.kernel.org>
Subject: Re: [PATCH v4 1/3] x86/sgx: Split SGX_ENCL_PAGE_BEING_RECLAIMED
 into two flags
From: "Jarkko Sakkinen" <jarkko@kernel.org>
To: "Dmitrii Kuvaiskii" <dmitrii.kuvaiskii@intel.com>,
 <dave.hansen@linux.intel.com>, <kai.huang@intel.com>,
 <haitao.huang@linux.intel.com>, <reinette.chatre@intel.com>,
 <linux-sgx@vger.kernel.org>, <linux-kernel@vger.kernel.org>
X-Mailer: aerc 0.17.0
References: <20240705074524.443713-1-dmitrii.kuvaiskii@intel.com>
 <20240705074524.443713-2-dmitrii.kuvaiskii@intel.com>
In-Reply-To: <20240705074524.443713-2-dmitrii.kuvaiskii@intel.com>

On Fri Jul 5, 2024 at 10:45 AM EEST, Dmitrii Kuvaiskii wrote:
> +/*
> + * 'desc' bit indicating that PCMD page associated with the enclave page=
 is
> + * busy (e.g. because the enclave page is being reclaimed).
> + */
> +#define SGX_ENCL_PAGE_PCMD_BUSY	BIT(3)

What are other situations when this flag is set than being
reclaimed? The comment says that it is only one use for this
flag.

BR, Jarkko
