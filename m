Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793973062;
	b=s5KKLhBnlTaZabKbUY/D3ADQhwyzGXMCTf/PIaSv4ob6Kto/Gqppwk6vB5doMNYjHSDy
	 OjUy70NCLNrpCMpAW+fsGWYFR+Pn+Yzbm8B2RMsnQDWppqe32/8PeYZfilhL9iGd4NVv+
	 codbvzOl6HaBEELpa/98AfS8wnxkGddJD170OYnjsh+0mCwDbgtvejgfwUmiybA4c9r+C
	 8I7H0DCcRqAI8W6j6LiXHEz+HqGDjABwa7PMTOhYWCHLx2034UueL5g/pjmDJhLr7nq15
	 xo5F2EY4MqJvHtGzFcZdWlBt7iqGIVUxkvWkSAQ7tmtaPAcw1w4A2dbcpna63MTqoXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793973062;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=SvbdRNqL/8qCTDSGCTb8M0taIrstvBniNfZYFufgM5Y=;
	b=t/3kMgbIUXtvUXjpUxyV+DzKhmgg+cN3lpB298/6+lZtoGk2wCCmjmpgExTludiOvNJy
	 rf35bbBfBMcshbo8ZtFBMqVvWAaaexR9mC/wBpaN1JevPLx+LlJLfs96S+ET2j4aIuv/c
	 mmb/8Jbo7zh/dT/XrRVsMahPRmybxZprWzts2IIOcAvxiPr9EOqmjqIhlb8DW4uw1d/FG
	 KqxMtMtJwvM/u6JsTm9WZybBdLj/5P7KjrhDKcL/d5ReQ4avFyTCoSa74+elxKCLUHYph
	 P6gM+aiLudKlY5r8YjGFCmDRo5qt70ZDIdu43dXH1hw5KMa6yUqSoDFBcEBYPRISg4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L33pwgZS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id EFC62606A329;
	Fri,  6 Nov 2026 13:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L33pwgZS
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 257841F0089F;
	Fri,  6 Nov 2026 13:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793973061;
	bh=SvbdRNqL/8qCTDSGCTb8M0taIrstvBniNfZYFufgM5Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=L33pwgZSVggirArZ13tgig1B1UCQKbjbxP46ClHAA2P14xrsBYu6ITrSuDWxD75nm
	 951iQE/lYInSkLK7zdv01x692IZ8EISZoenRxG8xR7Tk2E4p6mjAl59/Ld/fabYaci
	 0O0y4X0ZqJB89xAkdhFcg47FJX/vGN9YxDmynA2wfSj58zxVe28UDKojH8xPKB9pkm
	 JrmLw6sGmd3K1zoXLZ0badUqpxNhCbLlgu742muYZwUmimGIDQRTbhteYmZgvMqpeS
	 Vw7E7CJ3LK4waVWLimdiYEbfq546n85vZyX7ijnIUWr58UPgYMuJVskiiDeWqRCa4Y
	 8e/9k+FsTIHQw==
Date: Fri, 6 Nov 2026 15:50:57 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>, Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowangio@gmail.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>, Jan Kara <jack@suse.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Ondrej =?utf-8?B?TW9zbsOhxI1law==?= <omosnacek@gmail.com>,
	Joel Stanley <joel@jms.id.au>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Ryan Chen <ryan_chen@aspeedtech.com>,
	Billy Tsai <billy_tsai@aspeedtech.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Abel Vesa <abelvesa@kernel.org>, Jens Wiklander <jenswi@kernel.org>,
	Sumit Garg <sumit.garg@kernel.org>,
	Scott Branden <scott.branden@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Richard Cochran <richardcochran@gmail.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
	linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev,
	linux-sgx@vger.kernel.org, selinux@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-aspeed@lists.ozlabs.org,
	linux-arm-msm@vger.kernel.org, op-tee@lists.trustedfirmware.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH 00/14] mm: convert further simple mmap hooks to
 mmap_prepare
Message-ID: <au3bQYYHRxR9VRfh@kernel.org>
References: <20261105-late-2026-mmap_prepare-v1-0-c56aadfbab8a@kernel.org>
 <CAHC9VhQvpFeEJaEyPDaqj8_S752puSaNe0Rn-hxjh=ugCoFsxA@mail.gmail.com>
 <au2odtvEhpLJY4eD@gremlin>
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Post: <mailto:linux-sgx@vger.kernel.org>
List-Help: <mailto:linux-sgx+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sgx+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <au2odtvEhpLJY4eD@gremlin>

On Fri, Nov 06, 2026 at 10:18:06AM +0000, Lorenzo Stoakes (ARM) wrote:
> > Granted I've only properly looked at the SELinux patch (7/14), the
> > rest I've just skimmed through, but these are all independent patches,
> > right?  Is there any reason why individual subsystem maintainers
> > shouldn't just pick up their associated patch?  Yes, perhaps chasing
> > down individual maintainers is a bit more work, but isn't that the way
> > this should work?
> 
> I've no objection to people taking patches independently, the concern is people
> lagging on that and holding up a key conversion which is entirely mechanical, +
> generally tree-wide stuff like this has been via the mm tree.

This is probably the best way forward, as for a subsystem this is just a
different API for doing the exact same thing (and that way "idempotent").

And looking at the intersection points overall, the changes are neither
likely to cause any major merge conflicts...

Br, Jarkko
