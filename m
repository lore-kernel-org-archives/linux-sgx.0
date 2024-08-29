Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F190D1B5EBE;
	Thu, 29 Aug 2024 16:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724949859; cv=none; b=RG9vhXnlLk3xG4fPGFvgn7SLx4J7B5wtlPrw1Q0FOw5S1AtTQ533w4ua0iwGAKOquZrVGHO3livqYuo/gFmhHdYP08h++T0Crko2yz/Mpy5fGZ6yb8jVlLVLZg9vhQ0j5quvAotP2BBxsVuQ++Gn/in5CE3302HBfCJNacDCHsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724949859; c=relaxed/simple;
	bh=zv4qrl6Jy/6yhSQ5CBr6vZy+qjLwUITn7De5Wk8i6wU=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=RhHOOyFQGgA01pUrWB6HRcsJOU5WXdaiNGcSnR+WYKOok+P/dG3KanKWXLVO6eYxTxKy0WbJeK42Lia+WF4QGad9IsC1RiyacrylgbznFDKuL2gqSMx1XqXaJvMkVUl6u7m70aEfmd3sV0navZjtwKPhvWzsC+0rYPVTr547nNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PD23EhSq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PD23EhSq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4D9AC4CEC1;
	Thu, 29 Aug 2024 16:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724949858;
	bh=zv4qrl6Jy/6yhSQ5CBr6vZy+qjLwUITn7De5Wk8i6wU=;
	h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
	b=PD23EhSq1N3X9DefKcjA3yXC+fuUonH7eegXxaJePpP0WRJDP8gp+KGQzlWmm6i6w
	 nWkxnbp9gO1p9iRD1ROkp3K0kwnbZiA3YIxGXSOJc+SM78+10m0nL0Iqe9L8hEOf5Y
	 w8FW7IGD6tlnBU5rfbAcur/HlxTE0QH72ROvgPuVL4i8vvlFxjsg+g1W49ytEPSTD6
	 ASPmSzAmOR/G+Sr5Sa5uVeB/uyAaDAAGEM7gLSDiQmlrP348DhU+JXDUOSbWC6dWlQ
	 pz4xevnJPlrpsEDlFEriUmYNqw8zqDyhxRoPGjI6rV1GBkeod1kg7ssYbzxQN5N8me
	 j9ZwtH1vgQJSg==
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 29 Aug 2024 19:44:13 +0300
Message-Id: <D3SJOVADFM48.JNOIOZJ0J6OE@kernel.org>
Cc: <x86@kernel.org>, <linux-sgx@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, "Zhimin Luo" <zhimin.luo@intel.com>
Subject: Re: [PATCH] x86/sgx: Fix deadloop in __sgx_alloc_epc_page()
From: "Jarkko Sakkinen" <jarkko@kernel.org>
To: "Aaron Lu" <aaron.lu@intel.com>, "Dave Hansen"
 <dave.hansen@linux.intel.com>
X-Mailer: aerc 0.18.2
References: <20240829023800.1671210-1-aaron.lu@intel.com>
In-Reply-To: <20240829023800.1671210-1-aaron.lu@intel.com>

On Thu Aug 29, 2024 at 5:38 AM EEST, Aaron Lu wrote:
> When current node doesn't have a EPC section configured by firmware and
> all other EPC sections memory are used up, CPU can stuck inside the
> while loop in __sgx_alloc_epc_page() forever and soft lockup will happen.
> Note how nid_of_current will never equal to nid in that while loop becaus=
e
                                                     ~~~~

Oh *that* while loop ;-) Please be more specific.

> nid_of_current is not set in sgx_numa_mask.
>
> Also worth mentioning is that it's perfectly fine for firmware to not
> seup an EPC section on a node. Setting an EPC section on each node can
> be good for performance but that's not a requirement functionality wise.

This lacks any description of what is done to __sgx_alloc_epc_page().

>
> Fixes: 901ddbb9ecf5 ("x86/sgx: Add a basic NUMA allocation scheme to sgx_=
alloc_epc_page()")
> Reported-by: Zhimin Luo <zhimin.luo@intel.com>
> Tested-by: Zhimin Luo <zhimin.luo@intel.com>
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>

BR, Jarkko
