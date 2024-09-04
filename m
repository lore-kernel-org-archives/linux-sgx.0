Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E72171DFE3E;
	Wed,  4 Sep 2024 14:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725459449; cv=none; b=KS269b3tp4BFg0w6iya9Xb0Rn/DV7BSebNwHtQwzGfEvri/cE0nPGfUjwQAqyfwxLfr2PvkKffDzG8yx/jcdZ3vlFeD9dj2jlRV8E5gn5HJXqL7FOdnWPuwW3vfqqmYApr53z7aqd5pehTRln0vMY89jciLabzZphnnDJvMAx2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725459449; c=relaxed/simple;
	bh=eH6bW4sexyXRXcNaSxzi/8wNw2/wByog0ovvggmCDpk=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:
	 References:In-Reply-To; b=WHtn6KcM07QzB2rKBIOBf15QS2jr/BJInWAq4fPJldMLLEUaWYR5tjxPl6ZSCtuZCKHIQfQ4NVtaTf2bqVqqPONSvt/fSJDXyZ5C+UVtr2TBoqclUuQBUhoV0jXvrZsLJI99PqXrfUSRf+eLtyxzJeVM4YVS0ezD2C5SMPe53H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iYODs4Ap; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iYODs4Ap"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23830C4CEC3;
	Wed,  4 Sep 2024 14:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725459448;
	bh=eH6bW4sexyXRXcNaSxzi/8wNw2/wByog0ovvggmCDpk=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=iYODs4ApxkoiRDBdX7jDtDqY5U3vZ31zujSr5SdCQFXyRPu0mmvFnGpXUrUqXL2CT
	 MY2v0QybDpEn8RtA9eqrgxBkS+E5F8Hwhc3EgLTTNFvKUqWZGopoDQMSzRPl5Z4djG
	 bsFVJ0wTgJM3jJOnG2VOZh7581X9vfZ8NgcycDClIMd20bSQukx9FajTNSg6TZyHR5
	 SZgaI2H4zSzQKR5aPRNYilGvFyQ9MvwNZtlhiOnJ44P0gD7iZLBeCbfo3Y9FpGsxSM
	 a/g2rg6nDy+WWBjVcVMf4kbkDAajgQpFujTuQzme73mrVttbQMPri3qsoEia0CaHbZ
	 14/cdNeCgL7NQ==
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 04 Sep 2024 17:17:24 +0300
Message-Id: <D3XKBPX6DBX4.2BYXD4D5NZGWZ@kernel.org>
Subject: Re: [PATCH] x86/sgx: Fix deadloop in __sgx_alloc_epc_page()
From: "Jarkko Sakkinen" <jarkko@kernel.org>
To: "Aaron Lu" <aaron.lu@intel.com>
Cc: "Dave Hansen" <dave.hansen@linux.intel.com>, <x86@kernel.org>,
 <linux-sgx@vger.kernel.org>, <linux-kernel@vger.kernel.org>, "Zhimin Luo"
 <zhimin.luo@intel.com>
X-Mailer: aerc 0.18.2
References: <20240829023800.1671210-1-aaron.lu@intel.com>
 <D3SJOVADFM48.JNOIOZJ0J6OE@kernel.org> <ZtFjPwNWS_hfs4px@ziqianlu-kbl>
 <D3WS02D8SZMG.62T9IWX6WZI4@kernel.org> <Zte6ROmqrwdCSIn8@ziqianlu-kbl>
In-Reply-To: <Zte6ROmqrwdCSIn8@ziqianlu-kbl>

On Wed Sep 4, 2024 at 4:39 AM EEST, Aaron Lu wrote:
> On Tue, Sep 03, 2024 at 07:05:40PM +0300, Jarkko Sakkinen wrote:
> > On Fri Aug 30, 2024 at 9:14 AM EEST, Aaron Lu wrote:
> > > On Thu, Aug 29, 2024 at 07:44:13PM +0300, Jarkko Sakkinen wrote:
> > > > On Thu Aug 29, 2024 at 5:38 AM EEST, Aaron Lu wrote:
> > > > > When current node doesn't have a EPC section configured by firmwa=
re and
> > > > > all other EPC sections memory are used up, CPU can stuck inside t=
he
> > > > > while loop in __sgx_alloc_epc_page() forever and soft lockup will=
 happen.
> > > > > Note how nid_of_current will never equal to nid in that while loo=
p because
> > > >                                                      ~~~~
> > > >=20
> > > > Oh *that* while loop ;-) Please be more specific.
> > >
> > > What about:
> > > Note how nid_of_current will never be equal to nid in the while loop =
that
> > > searches an available EPC page from remote nodes because nid_of_curre=
nt is
> > > not set in sgx_numa_mask.
> >=20
> > That would work I think!
>
> While rewriting the changelog, I find it more natural to explain this
> "while loop" when I first mentioned it, i.e.
>
>     When the current node doesn't have an EPC section configured by firmw=
are
>     and all other EPC sections are used up, CPU can get stuck inside the
>     while loop that looks for an available EPC page from remote nodes
>     indefinitely, leading to a soft lockup. Note how nid_of_current will
>     never be equal to nid in that while loop because nid_of_current is no=
t
>     set in sgx_numa_mask.
>
> I hope this looks fine to you.

Yes, it is. I just want the storyline to the commit message as
a reminder why we did this, that's all. It helps a lot later on
when having to look into commit history.

BR, Jarkko
