Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.216.44
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793920343;
	b=5Vur7nSPl7Dct5w/IFkKjj0q+WFG37IdNgKeE0kUJJf3o+3QcaSnlYbf6xay+UO5250f
	 PnbP38L0Vg4KY/nWh9qzeUDf4ZBzmVqMMqHbeAehFeMSylNq4Ecisz8mrXyvLJBcxtUTH
	 9yz35ftX2DYmyTSkPeUvbuczUzmnZniJLaZIqTsvlLGcH3wUfYWVY4BVn/6eV2fV9JBhp
	 JNDPtNlsf+/w3MlXssIoi4MKl7IXNBm88ws1+HV0HeUeHr5amY8J5iDuOf4XTVzsYV8t/
	 mFqiQ22JMI5km4EJw6/sfXcedh35xnfFEo6WRlmQPgIAR2AyHdFr1z9s5V5MBZh778g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793920343;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=w+g0xKR97zcXC//9XGcArRTzIRGbaLo0LA3je3jFgFY=;
	b=Bo2HEoJalu5LVhcR49V/2BE40z6u2mxobLmf5s2ecE56u1KsxAqCXsgJt+7VAxPSDr6Y
	 NL6sCS4u8pu/BncIsX30K7fgB4jR2INgZVFSCtAr5Q0PRresQT6dB1oSCMvZBrcO6wmcY
	 NCIe60GyvAlH8fiJW0PYI28hrLsbj5L/YxFa1d+EnqmMIsTNKtBl46fuZXzY4xg13xXuF
	 D+HvSq0zZWCubrxqWFheG3Ez8AEwhUXYbYM/1tPqKRaJku3YkPnf/vcerUwPptDET0haL
	 1khGmpEyKf9q3ZAdRrgR+kpV7OdriWHNf3IhyNLJQ2aCnUmX94oz0C4ELlifB0SfwpA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=paul-moore.com;
	spf=pass smtp.mailfrom=paul-moore.com;
	dkim=pass header.d=paul-moore.com header.i=@paul-moore.com header.a=rsa-sha256 header.s=google header.b=ePSbskAw;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.216.44
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 017B9606A32D
	for <linux-sgx@vger.kernel.org>; Thu,  5 Nov 2026 23:12:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 017B9606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=paul-moore.com header.i=@paul-moore.com header.a=rsa-sha256 header.s=google header.b=ePSbskAw
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3ac91ac8924so22490a91.1
        for <linux-sgx@vger.kernel.org>; Thu, 05 Nov 2026 15:12:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793920341; cv=none;
        d=google.com; s=arc-20260327;
        b=HM/Qb5xzZ4HbRDE9vspsjRnJRRwCbZj7+SkYnAG9A7Cg0K11XAmRGmaHTB6CEQnc2w
         yBV9C8HzP6pw6TvcBsXCjEFL0RLSXjYgjz0FOE3tMn0Jr5bjB4biv6CAmiPHxzTdiIH3
         PakamKvVJtsNyW9d5+kYFjPB0RESv8vuFjYH1HhqJBSTqWECEmdzeXv+3uN1mE+Qs2Ry
         wTEqcuLXop3dF73vj1ygOapXzBNH6Gy87BNWo+6XVw+Fs9b3Uc8cHXtKFpqX6kwXVopQ
         8CLqBI+QAai8BF3dN+4NQQQ/upM/hsRHbK1Cs+ptrjnT0LzfE3bkZrXvNLBMPWEVXRIY
         l4gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=w+g0xKR97zcXC//9XGcArRTzIRGbaLo0LA3je3jFgFY=;
        fh=UpUcdExMWdgdeltAn00wrg9NUsGSU+K6oDWShLOO7Qw=;
        b=Z9MWIsx1e5t7t+hpvQ+AEBhyDaZsOl3XTG+HC0oHaRQqXG1OyCvmkcpjIjoDfz8s1W
         JbXkrKlnxP9zqfYHzYwK7ab+i4WHng+2s9gFiSU5xl/Yyl+41EYLHHt/VN9oCYgD/53P
         e9AiLBjTS4aqK5AAwXalS3PoBbSFoLe2CwpNHWKEmmuHK2sNouLzYO5pVyZVa+V+DMxR
         NmkwnKYg+NNguTf2TZmQEH6aFq0gfRHbtLwbf0kL5P98GJll/fdI7Ug6x7Ri+K0Mu2ho
         UIJjkTWann+31XWtzvOjyyUWu4XckXQz89zn9n9znWEeNAkIShCqmWG/6ACgDdU95Ed3
         2cMg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1793920341; x=1794525141; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=w+g0xKR97zcXC//9XGcArRTzIRGbaLo0LA3je3jFgFY=;
        b=ePSbskAwea0d9B6NpBdXuFYsWvLDCToKGcxFrN9C/fQLJKxAOsbctr8qBrrZUslJXJ
         9CLcMCSIkKD7ZW5JSZB/FlpnXL7wVvbFlxAaV35NsJbH9Ct+Vj1AE0PSCxPZMXuxmspf
         S8DzKorUUKYgddL+oYJfDiSPHAXfQ8DdRb1gIJCpXWqjafW5TeuSLk2tBK8Xu5u2Toof
         wmqoUSerZIxxVmbDxgyvtDxt3hKRgQ27SfmnssLj7BFyrZUgbmKG7qeTDPokQzsw8F3e
         sMOi8Cm8Fp7SxcfGGOrWu3vbz980QOeeJXGWbY7zrPoyxcb1MpuMc94aw2AmHxsi0GQi
         jm0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793920341; x=1794525141;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=w+g0xKR97zcXC//9XGcArRTzIRGbaLo0LA3je3jFgFY=;
        b=v0hL8hYWhrt++sRKe0X1PptW0pmdHi8IYoS8e4qe03bImx/nL/fgjnVWAPtnnhtXke
         y1yFbtth7R/gd5LxUxzEJjiZQI+ij2RHX5Cu6OXXjx73w5fyk9l9z6ta23pgZhztPwp1
         XlvCEjJqGAiIoLvJ3a4ERO9Xr2gI+6OOI1H3Vm6k5rxlWNpFFKDf1LbIQXeCVY+H53dT
         QMiWRwZVXrqtygadA8AGoVmQJV2RHxeJlytFEf0jDpaxuww3jKh4P+7NjEN3GCSplYff
         a6AZ3CBvuv2SqQ+D+U2ttutW6O0V6uJhzPNfmKMaPLUZfq49U8+TfMQfgnNWB9Ww71w4
         AErA==
X-Forwarded-Encrypted: i=1; AKwUvBw9w5P0APGxG3r3eS4LhMQU6N7W20rdQIG8q0i2J23Qwl/X5hoaGj0GK5HLJLQup73Xg1iQgCvbmRg=@vger.kernel.org
X-Gm-Message-State: APuU4Z+sB+R2GGbRsifzUH5MDt+sbzM5lgPMe7xqnzDfcfgmileo0Ife
	itux/Libmp9G9oL4St4ejh0ZXMSyvXNNFWXl+5eDWEULP7Jr49Oi/a9Pz6nJjCwkBUY1zTHdpzh
	FLQlHSoWhfnrtpjV6QpHMWNELymrDj88Uv6wmxgvP
X-Gm-Gg: AYBFou3GUe9Fr30mtNImvX/jsLEe+j9C3LSd+2RxBq/eKjCPppLlWWSshslTpsUhTrl
	WI3FmR8a6VPqsUsCcjMxD8sl9g7dIsJusXpdJo6xsYH6Aw94XeKWMTw7woA/qr96NZJT3ZIfrF6
	Gds5JwA+IYob8loXR3DTtctadwREP0GbVOEXt7caPdYPK5+drWNfKXeREikxyKqggWq/yCtbL1D
	HWn+fnSkIitVelnOWwJp01iAnd2Rr1XlKU7H38Jk4YJqk2cHsk4EUrELLsUUsN0JrnTxcleXhlL
	iWwDA9b8xrFVUDJGmCzEVRHMMOekwDThp7v6ikSgOUAbc4FnOFtd2JuEj0sfsWJbrgK0rfZtZ0n
	XR/BgJRrauaBeTUJqUcIliELrGNvWoBsGxeOxLvav8TKRIf5Q56jTBdcLUDatZGuVv1DH
X-Received: by 2002:a17:90a:d88f:b0:3ac:b867:81df with SMTP id
 98e67ed59e1d1-3b0db6fbe69mr555739a91.39.1793920341210; Thu, 05 Nov 2026
 15:12:21 -0800 (PST)
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Post: <mailto:linux-sgx@vger.kernel.org>
List-Help: <mailto:linux-sgx+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sgx+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261105-late-2026-mmap_prepare-v1-0-c56aadfbab8a@kernel.org>
In-Reply-To: <20261105-late-2026-mmap_prepare-v1-0-c56aadfbab8a@kernel.org>
From: Paul Moore <paul@paul-moore.com>
Date: Thu, 5 Nov 2026 18:12:09 -0500
X-Gm-Features: AclHuK9SAmQ1s59IzUj_GoyUW49QmobrDei9zDR78OY4d10Tcv8mWs8d-l1JUg8
Message-ID: <CAHC9VhQvpFeEJaEyPDaqj8_S752puSaNe0Rn-hxjh=ugCoFsxA@mail.gmail.com>
Subject: Re: [PATCH 00/14] mm: convert further simple mmap hooks to mmap_prepare
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Juergen Gross <jgross@suse.com>, Stefano Stabellini <sstabellini@kernel.org>, 
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Shrikanth Hegde <sshegde@linux.ibm.com>, Haiyang Zhang <haiyangz@microsoft.com>, 
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowangio@gmail.com>, 
	=?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Jan Kara <jack@suse.com>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>, 
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
	linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org, linux-hyperv@vger.kernel.org, 
	virtualization@lists.linux.dev, linux-sgx@vger.kernel.org, 
	selinux@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-aspeed@lists.ozlabs.org, linux-arm-msm@vger.kernel.org, 
	op-tee@lists.trustedfirmware.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 5, 2026 at 4:06=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.or=
g> wrote:
>
> Continue the conversion of users of the deprecated f_op->mmap callback to
> f_op->mmap_prepare. Keep things gentle this cycle by targeting simple
> cases.
>
> No functional change intended.
>
> Build tested on x86-64 (allmodconfig, each patch individually), i386,
> arm64 and ppc64le.
>
> <<>>
>
> David, Andrew - I wonder whether one of you guys could take this series
> through your tree? Since it's kernel-wide it seems sensible to take it
> through an mm tree.

Granted I've only properly looked at the SELinux patch (7/14), the
rest I've just skimmed through, but these are all independent patches,
right?  Is there any reason why individual subsystem maintainers
shouldn't just pick up their associated patch?  Yes, perhaps chasing
down individual maintainers is a bit more work, but isn't that the way
this should work?

> Lorenzo Stoakes (ARM) (14):
>       xen/privcmd: convert mmap hook to mmap_prepare
>       KVM: PPC: Book3S: convert spapr TCE mmap hook to mmap_prepare
>       mshv_vtl: convert mmap hooks to mmap_prepare
>       vduse: convert IOVA domain mmap hook to mmap_prepare
>       x86/sgx: convert vepc mmap hook to mmap_prepare
>       udf: convert mmap hook to mmap_prepare
>       selinuxfs: convert mmap hooks to mmap_prepare
>       xen: convert xenstore interface mmap hooks to mmap_prepare
>       soc: aspeed: convert LPC and P2A control mmap hooks to mmap_prepare
>       soc: qcom: rmtfs_mem: convert mmap hook to mmap_prepare
>       tee: convert shm mmap hook to mmap_prepare
>       misc: bcm-vk: convert mmap hook to mmap_prepare
>       ptp: vmclock: convert mmap hook to mmap_prepare
>       vhost-vdpa: convert mmap hook to mmap_prepare
>
>  arch/powerpc/kvm/book3s_64_vio.c        |  6 +++---
>  arch/x86/kernel/cpu/sgx/virt.c          | 15 ++++++++-------
>  drivers/hv/mshv_vtl_main.c              | 14 +++++++-------
>  drivers/misc/bcm-vk/bcm_vk_dev.c        | 20 ++++++++++----------
>  drivers/ptp/ptp_vmclock.c               | 19 +++++++++----------
>  drivers/soc/aspeed/aspeed-lpc-ctrl.c    | 20 +++++++++-----------
>  drivers/soc/aspeed/aspeed-p2a-ctrl.c    | 22 ++++++++--------------
>  drivers/soc/qcom/rmtfs_mem.c            | 22 ++++++++++------------
>  drivers/tee/tee_shm.c                   | 14 +++++++-------
>  drivers/vdpa/vdpa_user/iova_domain.c    | 12 ++++++------
>  drivers/vhost/vdpa.c                    | 23 ++++++++++++-----------
>  drivers/xen/privcmd.c                   | 11 +++++------
>  drivers/xen/xenbus/xenbus_dev_backend.c | 14 ++++++--------
>  drivers/xen/xenfs/xenstored.c           | 14 ++++++--------
>  fs/udf/file.c                           |  8 ++++----
>  security/selinux/selinuxfs.c            | 24 +++++++++++-------------
>  16 files changed, 121 insertions(+), 137 deletions(-)

--=20
paul-moore.com
