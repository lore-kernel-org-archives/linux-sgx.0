Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793960301;
	b=WrJGACGeg+dKJenMpzNtyir4vbxyWVbIb4OBu4sZbd9Jrbmb2LR95YloPytyin82dGR7
	 04Hqj0ggk4LTSMG/4jfn4DuoM4lemLcmurzZn5XWZNsmkuhAntRJoSqE5iP4GOBnb2vsX
	 cezKTnga5MqCSCI0M8tyyc+94kYrLgqqGx+p7IoN89/d0Hj8vJJ0C6uouU54x53NmigPD
	 X41tA397HEj3F4ryOMyjEKwjCnFMTpbpzwwIUOogyoUaE6ahNh+FpjOWVkT81xME7JS3N
	 ilWXGB0Y7TvEkhkNcjH9G7LRCw/BvfhuKE1gCKKHgywM6HOXGaKNFzJZYEmNnBgR0+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793960301;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=WRJXIR3G73/bAoeCrNJcFgak4mvp+3ngQ+qpnIKUqWQ=;
	b=Nt2TLyWksU2I+LkSmxbn4AjFaBtOwA9/Mh7GKBmPQKf99FO4Zh1ddH2q2dDiCABoLOoa
	 8JT6BDN9EbFmLqhOwQwiS8GqyFKTwJ7ufYcVbWVYvV+OnCWOupL7KBRZMbFU6WMPazFQK
	 icDnodctUsLw4zUwqAgVNVcbiH++VVgierwEWAhBA2Y6+XgxNNohVRLsUwFq0BzlKISOT
	 FnF54ZubHNxQJtYgyQ9rn4o5KDxMr6aOiHvRCiJAhsNlzvH1+/TNdaUGHtjxfoksmaMev
	 A/Yl8usCHVpr+5TADG8a2oxhz/6zNItgTx+LgZzgJqJv/rgPiOMchKqGGapFjByTpZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l2m6k6Gq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0696606A329;
	Fri,  6 Nov 2026 10:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l2m6k6Gq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CFC01F0089F;
	Fri,  6 Nov 2026 10:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793960300;
	bh=WRJXIR3G73/bAoeCrNJcFgak4mvp+3ngQ+qpnIKUqWQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=l2m6k6GqXZKAI6ai2Tun1aF46awXpI/z2hhpm9C9mWFFrwb28EgYdeM12++TFdXHC
	 tZPDcNtqorI1JgQeh4d/V0oUoA8wTmUuwUWJnczsn3SnNHjwPhjBcdo7A1YGDV2mTG
	 KcYpC48NxWmRQWs88tJMsCh3bVG0uv6meLjHSwr1ICrXX3Vw/iw6HMzgoNOlCZ+Cr/
	 4yqxl3LXfTuCElZyaokutxEyEknbHWSUP2DCjtT8OlSb46KYExKXDg1tVpuuXc3j/i
	 oBl8kAvxU+cGtuwjokkyklXwgQ5yXoGFuePAoE1OqzN7B+weZmt4UCKvb6LGDNbMBE
	 27H/f4pFzu1cw==
Date: Fri, 6 Nov 2026 10:18:06 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Paul Moore <paul@paul-moore.com>
Cc: Juergen Gross <jgross@suse.com>, 
	Stefano Stabellini <sstabellini@kernel.org>, Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Nicholas Piggin <npiggin@gmail.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Shrikanth Hegde <sshegde@linux.ibm.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowangio@gmail.com>, 
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>, 
	Jarkko Sakkinen <jarkko@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, Jan Kara <jack@suse.com>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Ondrej =?utf-8?B?TW9zbsOhxI1law==?= <omosnacek@gmail.com>, 
	Joel Stanley <joel@jms.id.au>, Andrew Jeffery <andrew@codeconstruct.com.au>, 
	Ryan Chen <ryan_chen@aspeedtech.com>, Billy Tsai <billy_tsai@aspeedtech.com>, 
	Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	Abel Vesa <abelvesa@kernel.org>, Jens Wiklander <jenswi@kernel.org>, 
	Sumit Garg <sumit.garg@kernel.org>, Scott Branden <scott.branden@broadcom.com>, 
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Richard Cochran <richardcochran@gmail.com>, 
	David Woodhouse <dwmw2@infradead.org>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, xen-devel@lists.xenproject.org, 
	linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev, linux-sgx@vger.kernel.org, 
	selinux@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-aspeed@lists.ozlabs.org, linux-arm-msm@vger.kernel.org, op-tee@lists.trustedfirmware.org, 
	netdev@vger.kernel.org
Subject: Re: [PATCH 00/14] mm: convert further simple mmap hooks to
 mmap_prepare
Message-ID: <au2odtvEhpLJY4eD@gremlin>
References: <20261105-late-2026-mmap_prepare-v1-0-c56aadfbab8a@kernel.org>
 <CAHC9VhQvpFeEJaEyPDaqj8_S752puSaNe0Rn-hxjh=ugCoFsxA@mail.gmail.com>
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Post: <mailto:linux-sgx@vger.kernel.org>
List-Help: <mailto:linux-sgx+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sgx+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHC9VhQvpFeEJaEyPDaqj8_S752puSaNe0Rn-hxjh=ugCoFsxA@mail.gmail.com>

On Thu, Nov 05, 2026 at 06:12:09PM -0500, Paul Moore wrote:
> On Thu, Nov 5, 2026 at 4:06 PM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> >
> > Continue the conversion of users of the deprecated f_op->mmap callback to
> > f_op->mmap_prepare. Keep things gentle this cycle by targeting simple
> > cases.
> >
> > No functional change intended.
> >
> > Build tested on x86-64 (allmodconfig, each patch individually), i386,
> > arm64 and ppc64le.
> >
> > <<>>
> >
> > David, Andrew - I wonder whether one of you guys could take this series
> > through your tree? Since it's kernel-wide it seems sensible to take it
> > through an mm tree.
>
> Granted I've only properly looked at the SELinux patch (7/14), the
> rest I've just skimmed through, but these are all independent patches,
> right?  Is there any reason why individual subsystem maintainers
> shouldn't just pick up their associated patch?  Yes, perhaps chasing
> down individual maintainers is a bit more work, but isn't that the way
> this should work?

I've no objection to people taking patches independently, the concern is people
lagging on that and holding up a key conversion which is entirely mechanical, +
generally tree-wide stuff like this has been via the mm tree.

The mmap_prepare stuff is actually important for security (pertinent given
current AI fix storm) as it's by design super locked down vs. mmap which has
caused several genuine issues including a nasty 0-day.

So am keen to keep that rolling!

In this case each patch is mechanical and simple, so little surface area for
issues.

--
Cheers, Lorenzo
