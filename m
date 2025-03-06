Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149D125A65F
	for <linux-sgx@vger.kernel.org>; Thu,  6 Mar 2025 18:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741285736; cv=none; b=OmHiOV1jT8KEwy5UZ+mhX3iglrAQbwOCX/I2QowAtJoFKpXQbDXhI05UlsoT9zGMOkrQ9/RgWv6A/qIYtaHLKNKun7hHc86F1QKwbpcl1VlAEmGFuCl+uWsp/rxF5nWTu97RspFe9Ff/0KEmQF7Xy8FFnqmSDeIJh0qtWke4gkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741285736; c=relaxed/simple;
	bh=r0IMHC/yoRfQ2HR2/H4b/9WctwCr6+o1h47RZVBW/3I=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fZ5ruY47YAW6SlqVJQbvP1j8Dh+6R0WPKx/biQoUzaFw83fAZGXsfoN7ZmuGnUFONlLNcBotei46W/kHpZJmfiFrRmgU5y+yBPpGZysmBSRrDCc17aUJMBFK7W/6gl/ULgbLvUEh+dEQyrvEYGZ2ilOqELweOk55bFIU+vKbaPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n6ZNwWq+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n6ZNwWq+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06D08C4CEE4;
	Thu,  6 Mar 2025 18:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741285735;
	bh=r0IMHC/yoRfQ2HR2/H4b/9WctwCr6+o1h47RZVBW/3I=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=n6ZNwWq+xhWsk1oT8wOk6PUFOk+zyGx1EsYvC5Lz9XLEEXbROZqStAGH5unAyaR/7
	 5xFtZYG2MJuKJavWdZyHMuz5r0f3u2bby/uz1NIrfg1LxAi4maDBGwIbBNiHVF8E5I
	 cZk+G4uz0y28OjZ91KYyFc8gbShDM/rtMN68+JJsSZ0bwwREd+0WEgNfGv9f43qH8m
	 TIUA3WsaKQIkogJYJ9X/I+y8F8nTycQOIG1aOb36L+zFMuZt8PNLq5Kow9dchPT4B3
	 sDVKYky/tEU17WzvRlddf2LOpAwhhhhTt2z09F2SyHaNwjNjc7QHKX747RXjNI5K+W
	 MDwxdndUvHXVg==
Message-ID: <fdbd04be53e434df57125893b5eb43b2c91ffe0e.camel@kernel.org>
Subject: Re: [bug report] x86/sgx: Add SGX_IOC_ENCLAVE_CREATE
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: linux-sgx@vger.kernel.org
Date: Thu, 06 Mar 2025 20:28:50 +0200
In-Reply-To: <25ff0eb0-2730-4cc3-89f5-0e5be68e02e6@stanley.mountain>
References: <c87e01a0-e7dd-4749-a348-0980d3444f04@stanley.mountain>
	 <Z8d5n9e4tBZo892q@kernel.org>
	 <25ff0eb0-2730-4cc3-89f5-0e5be68e02e6@stanley.mountain>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 (3.54.3-1.fc41) 
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2025-03-05 at 10:44 +0300, Dan Carpenter wrote:
> > I'd just love to learn how to use it in
> > order to make sure that my fix will address the bug.
>=20
> This is something I'm still working on so it's not published yet.

OK, if you put out anything related to the this tool to LKML, please
CC me. And thanks again for reporting the bug!

>=20
> regards,
> dan carpenter
>=20

BR, Jarkko
