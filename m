Received: from lahtoruutu.iki.fi (lahtoruutu.iki.fi [185.185.170.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED8A2581
	for <linux-sgx@vger.kernel.org>; Sun, 22 Sep 2024 16:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=185.185.170.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727022963; cv=pass; b=C3j0GVcPnZYVB+S4gJR6aJ3NAq0xvYCZPStTQUBS2Q0NBxv5IPfQzCIWlz+t/KwFAyGw7HS3Q4+tV7DofEvVw4co62y304XSu1JdJAVckD5gyBFBx/nVHkO9V1GRTpggznFOzNt6GLhXTXZsBnjg5fcy66RpJsrj8P3yOBPr8zA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727022963; c=relaxed/simple;
	bh=Oop7S144Azj6frEeY7zGUTml4vgySyz66/n/Dm959iY=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:
	 References:In-Reply-To; b=acgeDzIbUBOTTKJlxKzizevN7o1PUlyIyyhwWw+pzFoXHxQjH1dQKrYVq8uOPMgdHZ9SVf8QW8n8jt3Pb9ssekBc6dCWc63lNtN7lI73CZlxALAQRQBvFIpZAsYLhB5lFSivqyXmZggQrESLpyhvECY+eSpl8L+ro/gr7Zu5eSs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi; spf=pass smtp.mailfrom=iki.fi; dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b=RrNQst4a; arc=pass smtp.client-ip=185.185.170.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iki.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b="RrNQst4a"
Received: from localhost (83-245-197-106.elisa-laajakaista.fi [83.245.197.106])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: sakkinen)
	by lahtoruutu.iki.fi (Postfix) with ESMTPSA id 4XBWvp736Dz49Q2C;
	Sun, 22 Sep 2024 19:35:50 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=lahtoruutu;
	t=1727022951;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Oop7S144Azj6frEeY7zGUTml4vgySyz66/n/Dm959iY=;
	b=RrNQst4ahZTYbduKoq0c0p5tTycKHSKvIpZljEyp5JZAnHAiMHW+YNrb1Z3JBxeXBdWLbw
	9c7FHNpa4Lkyd+B/OMKrfAK+zxIYBVK6NcE/aIqGyOBiXTp32xZfAmVzgvwPF5BLZ3WlmZ
	zSJ2NEVF4OT/KQgGtC4zv35lw/HrEeDUf+D7/cRwZ6lvmbqXtYVCJPW4ab+5X9YADUaHth
	dRuoMOjiX6Ol50GbK+pFngzQ5AIkKVingaDGyiAtKWQ5mdfg8dsuvmlvqt2BiTS0vrf3am
	CsvfPoWLjhxqoLuDb5e77p0CNCIfT/csB4EWOj+ZDBjodGjvbHLb9fgWRLdpZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
	s=lahtoruutu; t=1727022951;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Oop7S144Azj6frEeY7zGUTml4vgySyz66/n/Dm959iY=;
	b=q89nAZSY3225qXOqC/153RtOdlnk855QbCstunW6EYxTh4BfhDTD4uODJjVmvstAW955QC
	ygDJq5eN9K9d1UlGeQH+Z2umnSdexd6V/SnDR8X1lYdzZUbt7CE5V6Ox5PjkTJwC6oc6gC
	LgUgjA2V3iFYW1BC3D7XPNGSqC0gmT/gSHxPFfS1o2H9OhUY1LOxK+kC+MliquK5CXXhnl
	8FSWIxbuPsk8+uzzBFKeQpYMYsjpO4CNXrKaRV+LsJ9GuvArveStfrEOgGO+xQoptm+tuc
	BaRLKVrIcvNBzri2TX51efwhlp8pYv8SiCl952ZmRILBbWesrLMY9/D0XtQWAA==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=sakkinen smtp.mailfrom=jarkko.sakkinen@iki.fi
ARC-Seal: i=1; s=lahtoruutu; d=iki.fi; t=1727022951; a=rsa-sha256;
	cv=none;
	b=QUb1BfNiyAzzJAxDl94372FGDraQImzlHs/8SRKcPgaaPkcbaeb+HjmaCatNYsyv/+voeC
	AQWdsLSUJi0Fp7AIHLJeNUIPn0dH9FjDX/z34/Hsg+0cqtbrWRgRiMn+xyyGxGAcwZ3Dh9
	emcIMFYK81dg1VVINDpD4YgkRQWqi9kT9LEYJ7pmN/49Dw8Xw02U/J+b6kwZRncaN1YNHn
	qEs1mJvQfyAKeJWnUvYNlKd3jpRg8+IWfMH8jlsPyZpOmHkZCdTs0XxweoGRg3BqBr8KCd
	PkGOUFGgdfLhx5Z15z/4M7wuRLo/NSZMbQfaNPS+368STzsp2aBHD0MWTL7Qrw==
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sun, 22 Sep 2024 19:35:49 +0300
Message-Id: <D4CYJI7CQCK8.1ZRAUTU1V7KO7@iki.fi>
Subject: Re: VMA merging updateds?
From: "Jarkko Sakkinen" <jarkko.sakkinen@iki.fi>
To: "Jarkko Sakkinen" <jarkko@kernel.org>, <linux-sgx@vger.kernel.org>,
 <linux-mm@kvack.org>
X-Mailer: aerc 0.18.2
References: <D4CYD3HMAUGG.YY8GFV53V84@kernel.org>
In-Reply-To: <D4CYD3HMAUGG.YY8GFV53V84@kernel.org>

s/VMA merging updateds/SGX VMA merging updates/

Pressed S by mistake in aerc.


On Sun Sep 22, 2024 at 7:27 PM EEST, Jarkko Sakkinen wrote:
> Hi
>
> I started to look into this old issue with mm subsystem and SGX, i.e.
> can we make SGX VMA's to merge together?
>
> This demonstrates the problem pretty well:
>
> https://lore.kernel.org/linux-sgx/884c7ea454cf2eb0ba2e95f7c25bd42018824f9=
7.camel@kernel.org/
>
> It was result of brk() syscall being applied a few times.

BR, Jarkko
