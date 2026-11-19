Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795102493;
	b=Jyu/KNUnN+jTmq/aRFRHYq0S+JDyHdwmrQ0IeYDrA8beX0qSJlJs05rNAzEO6oGjr3xz
	 XU0hbWnZyOm0y0QEWkDl5ZFkI59zNTJVtqH62ZRyoYo2aZFkpmrrjjAok3CEop1BTuRr7
	 hAXlN+79vILkb0mcLlva1ekWVRToc96ccb6ADnv4ViKoQPuwxZeGskxKQXBGBjp2minEl
	 GMjI4k0gA5QxLtzeRtLM6FOYTUVlnR1CJORp+R1A7H1Y+AYvXZLYR2GcjE6EptGisfmWT
	 6tKWE0/zfcCaTMPytMgnW6WrcoHElrP6EFA8qWUXhHcO89j+dpz1dIR9g7oX4CmlC3w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795102493;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=APdHxhVevbSPgpurjsZdo42O+VpO7Vh8nV06rY8boD4=;
	b=sQvXAlN258/tlDndtxXj24vp+MJBewGTM1M44D3AMoec/vvcNGfqWx1X1Y3LVfSf3b+g
	 L09EHupC46p9poAYZDbbTJnDcFeRUBo5s8Ygph242biywhw5RjRk1XR/SMKHAKOijHPmm
	 vCr79IiBDYzJYqk0qBImiqRmoluHtZim7yA8V8J6UGUnLxeK1qQOwJk6JxFTswhLou6vM
	 BhLkUsnnhhaUDfXtDTK7uVy91ryWMRzwmLVCv+syiF3Kks4Nq6yNIy3YyeyOcdXSsPkiw
	 DGKBAUGoXEMmnFMdtP4uRwy5u4dYi7PbZbP/C3sbTOKfJ2CfEy+1KlCHoKWsVziXQLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SYXclQdv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F35860A380D;
	Thu, 19 Nov 2026 15:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SYXclQdv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EB681F000D2;
	Thu, 19 Nov 2026 15:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795102492;
	bh=APdHxhVevbSPgpurjsZdo42O+VpO7Vh8nV06rY8boD4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SYXclQdv+b2ige8985m5EUIy/JLoQxmabD6L38JETBlbyWyOxafAyDnLaHlFuiZzI
	 /kleeHI2fRI6NlzXJQ+01EHgKqPnrnWz2GxHUPBkmWq8xGnEhcqswjtufMMr/JVuVd
	 Oim6b/4sspvRWabq5lRrDi7ieeWfcppAjZwnNFriQGxgZJKPjQ+ITgzNBkJeLjptSm
	 CTkKZeFxoBR+bIZ90Rq28z+bZEO3fqgYVpxkcjnPYAi5DmrrR+9PwiAVnTogrtm68z
	 UT9kNPLjCKpIduy7cFAblizPGwX/paLojDgejUv3m13aRTjQL6aa4KuAJwRT+HywIe
	 ifbBCB27Cbtkw==
Date: Thu, 19 Nov 2026 15:34:40 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Juergen Gross <jgross@suse.com>, 
	Stefano Stabellini <sstabellini@kernel.org>, Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Nicholas Piggin <npiggin@gmail.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Shrikanth Hegde <sshegde@linux.ibm.com>, 
	Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, 
	Jason Wang <jasowangio@gmail.com>, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Jan Kara <jack@suse.com>, Paul Moore <paul@paul-moore.com>, 
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
Subject: Re: [PATCH 14/14] vhost-vdpa: convert mmap hook to mmap_prepare
Message-ID: <av8VB40ncsb5yEtr@gremlin>
References: <20261105-late-2026-mmap_prepare-v1-0-c56aadfbab8a@kernel.org>
 <20261105-late-2026-mmap_prepare-v1-14-c56aadfbab8a@kernel.org>
 <20261119100450-mutt-send-email-mst@kernel.org>
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
In-Reply-To: <20261119100450-mutt-send-email-mst@kernel.org>

On Thu, Nov 19, 2026 at 10:05:05AM -0500, Michael S. Tsirkin wrote:
> On Thu, Nov 05, 2026 at 09:05:45PM +0000, Lorenzo Stoakes (ARM) wrote:
> > Move from the deprecated mmap hook to the new mmap_prepare hook. The hook
> > only validates the request and sets the VMA flags, operations and page
> > protection.
> >
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>
>
> feel free to merge with rest of this.

Thanks, sorry I missed your previous mail re: merging, I think ideally best
merged together!

--
Cheers, Lorenzo
