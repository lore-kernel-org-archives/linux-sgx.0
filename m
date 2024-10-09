Received: from lahtoruutu.iki.fi (lahtoruutu.iki.fi [185.185.170.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7721319B589
	for <linux-sgx@vger.kernel.org>; Wed,  9 Oct 2024 14:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=185.185.170.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728482600; cv=fail; b=PdqBSZ92dwwa3fLrWhVqzDFnNc83f+/0zbYJmZcuq9NT0xO940qTlOem5juP1wMNaDu68Gw3Dc/P6jyhohKC+LqOQlOHBVyibFH2Ef8T+sBMTnguLavNjYWrE34fafiR5c2JFuuY0tdhqngDlQi+a45cKH5OiWONcb83fTnW8sA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728482600; c=relaxed/simple;
	bh=1WhxVXkOe67dMgsIbtILe5TqIMke8WpifQF/naTxgbs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fhpUElAQ3kSfQI/jwpJc1FczBNJtZEjx1ZjiiywLrs5O3LbtgacmNVmg+LzxVuSpqWrLj3vSDZ8+s8bfIp24uauC0VKH3LF1/I/rFFRykD9+Dlqe5Rg/DQOHogkGfgUYTArmLFTf2Px9mtMAa1f1eDyRUNMBfLjgf2oN7k0jyjM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi; spf=pass smtp.mailfrom=iki.fi; dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b=CEvAyKG7; arc=fail smtp.client-ip=185.185.170.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iki.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b="CEvAyKG7"
Received: from localhost (83-245-197-106.elisa-laajakaista.fi [83.245.197.106])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: sakkinen)
	by lahtoruutu.iki.fi (Postfix) with ESMTPSA id 4XNvjm1syxz49PyG;
	Wed,  9 Oct 2024 17:03:08 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=lahtoruutu;
	t=1728482589;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1WhxVXkOe67dMgsIbtILe5TqIMke8WpifQF/naTxgbs=;
	b=CEvAyKG7jB4GHtT0fl8JyI7vwTyf+S+iCGPyFsZb0+K+O5WBW9UpwM68wNSK/IA5ivn7vR
	x/JtC3qLfoR0bVGFWi36k94wK6yryggOa/yLQXSxOdzjrDI/uhZMFCFproGif134OTzMtO
	N4KppaoRSSNFtNTH4ee5+/zQAO9T2LiRZ/3clz6fvCZzIScp1ZZXr1usC4/TiWMiz/Rsll
	0M4dU+LdvwYJbhwcNyQIjWEIPQQ2c6Iov+aacnOGuYeNtrUfjTjW+ruvx4nUh5SQYs40nj
	CbFVQ7iGpDs5NpcLD0C+XKum5HimY4sSk3b7IsZFH7i0Vr9a4MSXVq2S90Vx7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
	s=lahtoruutu; t=1728482589;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1WhxVXkOe67dMgsIbtILe5TqIMke8WpifQF/naTxgbs=;
	b=U4t91hFRBZb6RaGySkQhm33ubrPYItqIioBOA9XpnHSDaIJXt+hRTte401ab37H4K7jJ2q
	J0MsRNW6wWYcJDLdovlE9EZOTMRmo5nMLCIz0m81pgMGhlF4Ka9dTa84+xpA2FGbQiAoK6
	frYaUXjmFWgn71z/HhHtZ7Q79aQLo3qqcpw27PFjUaxI3/1xB3jRC/IFShDgENPp/Ffqcp
	xRPXK3r1EYRCzstVzAPjOM0CiTLV5htPsnR6/D1ZpW/YVGu6nKMXXvqs64MrfnDDbXh7Jw
	w/CpW0pzZCBVy3d/Ir1yp/uZSQXGaozuI1BMMttYoksyt/vrVD+06CrSmYSd6w==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=sakkinen smtp.mailfrom=jarkko.sakkinen@iki.fi
ARC-Seal: i=1; s=lahtoruutu; d=iki.fi; t=1728482589; a=rsa-sha256;
	cv=none;
	b=qoocbuawjCnwvoHoTlOjBGRn5O1iCST8F38ExWGE6qvl3v/HgS+UUK83sxdFcq2188GePA
	WbN3V0RRjAEqj8vd4lYTzITequFL8Rka0DqsMhdS6Bo6J86Atj9f0A0C3uNPmXkqauTwe1
	0W1Jj0LKr2jMDh/U1gJKbGkaqUFnxZI0yHwV3PxfhkVdUgLVBZXl+Cvbr+2yb7oXrNA09l
	6CR10uXS3CBscLWeR3coCivO7WsaC5SIF0Rfs+DW/Sl0Ysbno3D55JBL6nXEk0fqXrYfKy
	DqP1H+rbxwy/HFjvzSxDuwqz26mp8wIPKGMKkhlEHz0cuvkaRcvg8fcRJouFLA==
Message-ID: <8a696002d50823c9fefdc07db5e5d56ecf3e1c7d.camel@iki.fi>
Subject: Re: VMA merging updateds?
From: Jarkko Sakkinen <jarkko.sakkinen@iki.fi>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Huang, Kai" <kai.huang@intel.com>, linux-sgx@vger.kernel.org, 
	linux-mm@kvack.org
Date: Wed, 09 Oct 2024 17:03:07 +0300
In-Reply-To: <4ed9e4bb-5daa-4241-863d-4bbe923a7ffc@lucifer.local>
References: <D4CYD3HMAUGG.YY8GFV53V84@kernel.org>
	 <D4CYJI7CQCK8.1ZRAUTU1V7KO7@iki.fi> <D4CZ02NF1J3S.I8A5PEL72AKX@kernel.org>
	 <D4DHY7Y23KCG.3TWCYP0D8HN7J@kernel.org>
	 <51631b6d-5138-4195-8722-651d9ea79dc1@intel.com>
	 <2ba91a26-71b6-4150-9d8d-d5517d316808@lucifer.local>
	 <D4J4L636HVPC.QH7CETQ7SGVN@kernel.org>
	 <4ed9e4bb-5daa-4241-863d-4bbe923a7ffc@lucifer.local>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 (3.52.4-1.fc40) 
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2024-09-30 at 09:05 +0100, Lorenzo Stoakes wrote:
> > So I get on this first and come back to this lore thread later when
> > I have some more experience on the topic.
>=20
> OK cool let's revisit this when you've done that.
>=20
> I think if you did want assistance from VMA merging what I delineated
> above
> is the only sensible way forward, afaict.

So I did run some tests and since a TEE (trusted execution environment)
needs in all cases idea what it expects kernel to do all TEE's need a
memory manager. Enarx is multi-arch, and in the case of SGX there is
permissions bits per page owned by the enclave, on VM based confidential
computing (such as AMD SEN-SNP) there's some other weird shenanigans but
across all arhitectures there exists a constraint, which causes the
need. I.e. whatever happens in mm in kernel side cannot simplify the
implementation.

The current implementation of Enarx does not merge but I did some
experimental change doing "munmap and mmap" dance and I don't see
any mentionable change in the benchmarks.

So I came from the wrong early assumptions and made wrong conclusions
in the first place, i.e. somehow this mmledger crate could rendered
out. Had not looked at the code base either for 1.5 years but should
have started what I've now done first in order to recall all the
consraints.

BR, Jarkko
