Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E39AE173
	for <linux-sgx@vger.kernel.org>; Sun, 22 Sep 2024 16:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727022452; cv=none; b=J2tiGAz5CY9ojBMzQ0z9FY3+MX5FbuV1UlCI/hLH9Gqfx9G3bN4wpL0oZ1cCknTNAGnXt0woxojgr6f5Nds4UTisa64duOsQAqvtECel6omz7lM+HnGNmAxgCc9+TTMj6iJbTJy/hxcZ6X5Qcxz/Rxekezm2RycuagR9hMAveKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727022452; c=relaxed/simple;
	bh=nproVoOJry28qPPRYE3y3WhqDmUbgVUlN0LejTP8IUU=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To; b=iMXxAv75a2IpzhS0H1OXyu872k0ih1dJQxocYMK8RaVKS6nt4DVmdP8AQc2Lxznah1oauha0h/766MijQaKyURQgatibFTILg/n3Y4IMQPOlK2bmD3bBialBAbhZyz1aB1AeKItBVCXR565HMmwjiVxQ1bnGkA7v5QnlMxQHcPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G+dPtClJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G+dPtClJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAB96C4CEC3;
	Sun, 22 Sep 2024 16:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727022451;
	bh=nproVoOJry28qPPRYE3y3WhqDmUbgVUlN0LejTP8IUU=;
	h=Date:Subject:From:To:From;
	b=G+dPtClJ3i7qOGDYnjhv0WKw/nAtyxbi/5eOhfT9kEuuX2+NruoCMGfgYIVC6D0ah
	 ZqtQcwTnnhc3znem2+qb3z6xtW8vzprFk2Vxzr+EXn1WcDDPdxn2LWh/T9faRrgnCZ
	 SoWt7uaM/N/AOmh7AL1/1NLlxSB7fXkoc4HWbEUc4kGMNT75UUMh7FnIxr50cCyQDQ
	 A8wg4g/1Rf1yz8Xl5atUrB+k+CnZSxT6NvZHRzp35URznauL5VoLEW3/Ns/WLjssFy
	 r065PQ+fvtjKRZPVQ2d0WjCTx4khaZBt3uA/P1AqCkVcTqWNMGXaGexNoFN0OvoEh6
	 2xlV31ESBYmow==
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sun, 22 Sep 2024 19:27:27 +0300
Message-Id: <D4CYD3HMAUGG.YY8GFV53V84@kernel.org>
Subject: VMA merging updateds?
From: "Jarkko Sakkinen" <jarkko@kernel.org>
To: <linux-sgx@vger.kernel.org>, <linux-mm@kvack.org>
X-Mailer: aerc 0.18.2

Hi

I started to look into this old issue with mm subsystem and SGX, i.e.
can we make SGX VMA's to merge together?

This demonstrates the problem pretty well:

https://lore.kernel.org/linux-sgx/884c7ea454cf2eb0ba2e95f7c25bd42018824f97.=
camel@kernel.org/

It was result of brk() syscall being applied a few times.

BR, Jarkko
