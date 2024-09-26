Received: from meesny.iki.fi (meesny.iki.fi [195.140.195.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA2BC1D5AD4
	for <linux-sgx@vger.kernel.org>; Thu, 26 Sep 2024 10:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=195.140.195.201
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727344940; cv=pass; b=I4LIWjRXfOuaY+jVICsRuj7ejeHeU9JoXEizhcjBJqWV+dbCz4af9aEKUNsT+rFdbXJ1Etstp7uAnpFi2to4z/RtgZnnaDNSuDRpGWLeGjdNRSgQk0RiXiK8+1nRkrUmO05VlO2krkiWBnxoL9da6qk4W2QEtW/LA2mGzT5eCgs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727344940; c=relaxed/simple;
	bh=UOVynPbTvkAqeVxeDiYF3kW7x7Ypj8mbNxu3W0+8HQo=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:
	 References:In-Reply-To; b=kVff3d+pLhBT47EOcZZxZ4XTlqAKh3U5ANOOA+iUSDeiAMeebO8C/wH6pzhBXXQHOSu+1EcasbzV9sjdaWx+dVvCW4MrG78aTi+XRNPSjGHAm/HY8v2PlpPpGBroGnf6/PacSozWV4YiPR1qvJjtJOTq0i/0dQDYblkdkaKFyBQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi; spf=pass smtp.mailfrom=iki.fi; dkim=pass (1024-bit key) header.d=iki.fi header.i=@iki.fi header.b=dU0jrlX9; arc=pass smtp.client-ip=195.140.195.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iki.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=iki.fi header.i=@iki.fi header.b="dU0jrlX9"
Received: from localhost (83-245-197-106.elisa-laajakaista.fi [83.245.197.106])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: sakkinen)
	by meesny.iki.fi (Postfix) with ESMTPSA id 4XDpzp5Q8bzySM;
	Thu, 26 Sep 2024 13:02:14 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=meesny;
	t=1727344935;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OqOXY2WlnbuScs6wgk1Tpd/TbMCXCpPRNzBO/1u7lRg=;
	b=dU0jrlX9seTeC67nok9paLPxhasftsN6+7pDO3NoKxTzN39TBt4pmQTJXRzbrHar4bQInz
	IPg35xZY9BVsACGPPKMH55g63n8EiAnk8YlVRvTVnAGmC6wlm1P0c4apHvHcWeiGnF/4qI
	IR+m8ODnpGYNCsN7Dt6c9ANNqy+JgVg=
ARC-Seal: i=1; s=meesny; d=iki.fi; t=1727344935; a=rsa-sha256; cv=none;
	b=T6yn7uqAruqZW1/jGTT4jzjpZgD7g/1FXOVZS6mYKcc5KKCdmo3QJGZ9rHVTKPi97kh6Hm
	WAlH71HO5zUiAo4JBEGxR12MNVg+n6hlsSN7yBsrQNmIXE4lep5C7HNLRbUPGi/ZI2XEzP
	sWtGymBvUBgA3ZAubRsnvu841yq15Jk=
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=sakkinen smtp.mailfrom=jarkko.sakkinen@iki.fi
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
	s=meesny; t=1727344935;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OqOXY2WlnbuScs6wgk1Tpd/TbMCXCpPRNzBO/1u7lRg=;
	b=ZRMmpT+NOuhpHpygurIojS0tHZi6aKJlVcexUtrVrAw+JRcnVqWpSxQ4kLZEBmkw3h6PEw
	NCNs08OQ3aPN7Xr/vb1sANT9DbDWeZCxaG1bWB3IgwsDd6nW8XwOPjgMHnVBSDtqwMXOp7
	12dvnUQJxXGgNFON849COn5pzTD7rQM=
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 26 Sep 2024 13:02:13 +0300
Message-Id: <D4G4OBN5HB1N.R3OYU6TQRJXY@iki.fi>
Subject: Re: VMA merging updateds?
From: "Jarkko Sakkinen" <jarkko.sakkinen@iki.fi>
To: "Jarkko Sakkinen" <jarkko@kernel.org>, "Huang, Kai"
 <kai.huang@intel.com>, <linux-sgx@vger.kernel.org>, <linux-mm@kvack.org>
X-Mailer: aerc 0.18.2
References: <D4CYD3HMAUGG.YY8GFV53V84@kernel.org>
 <D4CYJI7CQCK8.1ZRAUTU1V7KO7@iki.fi> <D4CZ02NF1J3S.I8A5PEL72AKX@kernel.org>
 <D4DHY7Y23KCG.3TWCYP0D8HN7J@kernel.org>
 <51631b6d-5138-4195-8722-651d9ea79dc1@intel.com>
 <D4FSKQJ45J56.38A19ZT8CDTR0@iki.fi>
 <bd784be9-3723-4ad8-94a8-058f4a001042@intel.com>
 <D4FU5RJEFG44.2QYNE8R6J2GMP@iki.fi> <D4FU6N3RZ30A.2TY1PVOBZ6K8X@kernel.org>
In-Reply-To: <D4FU6N3RZ30A.2TY1PVOBZ6K8X@kernel.org>

On Thu Sep 26, 2024 at 4:48 AM EEST, Jarkko Sakkinen wrote:
> > 7f8f08121000-7f8f0814a000 rw-s 00000000 00:05 84                       =
  /dev/sgx_enclave
> > 7f8f0814a000-7f8f08162000 rw-s 00000000 00:05 84                       =
  /dev/sgx_enclave
> > 7f8f08162000-7f8f08177000 rw-s 00000000 00:05 84                       =
  /dev/sgx_enclave
> > 7f8f08177000-7f8f081a0000 rw-s 00000000 00:05 84                       =
  /dev/sgx_enclave
> > 7f8f081a0000-7f8f081c1000 rw-s 00000000 00:05 84                       =
  /dev/sgx_enclave
> > 7f8f081c1000-7f8f081d6000 rw-s 00000000 00:05 84                       =
  /dev/sgx_enclave
> > 7f8f081d6000-7f8f081ff000 rw-s 00000000 00:05 84                       =
  /dev/sgx_enclave
> > 7f8f081ff000-7f8f08228000 rw-s 00000000 00:05 84                       =
  /dev/sgx_enclave
> > 7f8f08228000-7f8ffffff000 ---p 00000000 00:00 0
> > 7f8ffffff000-7f9000000000 rw-s 00000000 00:05 84                       =
  /dev/sgx_enclave
>
> Just giving ridiculous answer to a ridiculous question.
>
> You clearly started commenting w/o reading the original thread.

It is two years since I did my own merging algorithm in user space [1].

If I recall correctly, since SGX driver does not have vm_close() by
mapping over in brk() shim you can fixup that. Obviously this needs [1]
so that you can check up from somewhere that you're doing adjacent map
with matching perms.

If nothing is done in user space, then VMA space can literally blow up
depending on the memory access pattern of the payload (in the case Enarx
it is an arbitrary program compiled to wasm, the enclave includes WASM
JIT as static payload).

I totally get if this absolute NO for core mm. Just thinking that is
SGX really the only existing location in kernel where you have:

1. pfnmap
2. bunch of regions
3. regions have varying permissions

And could there be some minimal weaker set of constraints that would
allow merges. Obviously it cannot be "any pfnmap" will go. If not,
**** it, I don't care, that's just life ;-) Stronger than pfnmap,
weaker than "struct page".

[1] https://github.com/enarx/mmledger/blob/main/src/lib.rs

BR, Jarkko
