Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CE362209B;
	Wed, 15 May 2024 16:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715791190; cv=none; b=AMjaU63KNAkBmdJXDJt6gzI1dPcRFWN8fI97U8+kzNn1cbKuPHDNNZ2xZQ8K/C2j3c7d5OFt/vMDhG5VhEOzdnaRP2eMy2Ze54oqcgpI+BBpx4jSVYOGPeV7TlXOhJESnznggn0c5rsIx8xujAHZ2+G85KA/VQqE0F4S6o2/EAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715791190; c=relaxed/simple;
	bh=wVQS9PyXJTPge3GG1BVQ/CMbNxmQTVtV2LG0XqKIl1s=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:To:Cc:Subject:
	 References:In-Reply-To; b=tMCcjWcJ9EunB+1Td1c5cAe/oZDVFsh2LTzrSbK+BNMu0u5QUi01B4fIZ0VYiYJCizIb81+cDShulHNHHaJBje9yhlwHmxeXD3Niy+arMfRstV++bzq6eDEfAs4319AwfzBI0oyPZv/XabaePdloHEigw4XHKPx/Pl0RbGPs9/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QESPciVv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QESPciVv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58BA5C116B1;
	Wed, 15 May 2024 16:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715791189;
	bh=wVQS9PyXJTPge3GG1BVQ/CMbNxmQTVtV2LG0XqKIl1s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QESPciVvmfC/QTRzoOQPd/uRWhQffHyTKlkULr8ljGpBIXhumomD00NYeDeKN4qdx
	 fZ2wpMzv5gQLUnNGA9U9u9kBnUaQJbSvWIedpysBfo8hfrhOdxrvrEMBfLPPDTiDne
	 iyR/ha8knEF7nRWrlfds7kKiasXv+FGY53Ri6rNO5uft5SgQaAJ0I6eokhpdHG/3kw
	 CQyNw2MvnkbRQpOAm1sH7z5mY54+r1GIpgZzmFkBKO7enfkj8+A9WSgBKjJhj0nc/8
	 uU8O1W3NIN+MS80BgI/uVw+WgqlZ4F2sJCo/kl/luc8fTAgUgdQxuG3ixcMdy7w7FB
	 Tx/hFBFcRow6A==
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 15 May 2024 19:39:45 +0300
Message-Id: <D1AD7P1JQ8P4.3AODO6SN55NWO@kernel.org>
From: "Jarkko Sakkinen" <jarkko@kernel.org>
To: "Reinette Chatre" <reinette.chatre@intel.com>, "Dmitrii Kuvaiskii"
 <dmitrii.kuvaiskii@intel.com>, <dave.hansen@linux.intel.com>,
 <kai.huang@intel.com>, <haitao.huang@linux.intel.com>,
 <linux-sgx@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Cc: <mona.vij@intel.com>, <kailun.qin@intel.com>, <stable@vger.kernel.org>,
 =?utf-8?q?Marcelina_Ko=C5=9Bcielnicka?= <mwk@invisiblethingslab.com>
Subject: Re: [PATCH v2 1/2] x86/sgx: Resolve EAUG race where losing thread
 returns SIGBUS
X-Mailer: aerc 0.17.0
References: <20240515131240.1304824-1-dmitrii.kuvaiskii@intel.com>
 <20240515131240.1304824-2-dmitrii.kuvaiskii@intel.com>
 <149a736f-8817-400b-93e7-0059b71af9f0@intel.com>
In-Reply-To: <149a736f-8817-400b-93e7-0059b71af9f0@intel.com>

> Thank you very much. I understand the changelog is still being discussed
> and those changes look good to me, to which you can add:
>
> Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>

also for this (with changelog tweak Dave suggested) so that we don't
need a new round:

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko
