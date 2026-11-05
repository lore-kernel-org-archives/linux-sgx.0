Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793915008;
	b=YC2d3lxZ+xdYtYVIQ1Gets1P9uEhzTnPPB4autnz0zXaiZsBRWKpwzSz76fcHih0kKeA
	 k6m1g18KWEU9FDJU1zbGXX0qZa2MPOWVujCYHiS10v025y4od05xwl9A9oD2FfDpSvki0
	 A6hTXBQzLnDEmAmDaGoaQIUfnEP8T7vc+qw/pzoEDhfdGROi9cjzFKvmpNF91CyGgVs1u
	 lf1v/w2SflXEohOkjNNrySEyswUOymoCZBzJVTkJn+9pOqtYqD19kTdS81sP5YUnjhd2Y
	 WkGBfxccMBXSjxaen0vlxUHMRqWF0Sy6ywPUFQfcywo1pN4ASzSdU/dyYCmDo+OwOGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793915008;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=nnsNMtUi8B/PfO4GG0OW4lr6jLs4u50NUe2xEiA6RC0=;
	b=eaXvzoqyiCBoR+f0jPBzGX9KQ428npqD2s7gfoAAZby0+JDtyN2kU3Nbw30MXUwutcHa
	 biy23HSyPb2qDXtCAX2avu5V0EA5FKzY74A3dle++4ESh/2WOwr+3PpGuC+rCNO0nJqzh
	 InQVF724oMGidILBy1+lzYWigoS4qW438260I/YDRUpSzbsFHWrUFsUDzaGMb+Hl/l20K
	 aCDKFjuqdNXVpKbrdJAouL4igPR9fk5yOJ9TQIHIxzGCIIKUbvMoVn6tzrcxGL9IHf/0S
	 6Nlg7wVbN+qZy9tc7vf4cLfMvFXwMovd0xKTKcxgroc09y9YNHKrpLIe+8XTCYLgp5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KFA+ZicK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 0B1DC606A326;
	Thu,  5 Nov 2026 21:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KFA+ZicK
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0AE881F0089F;
	Thu,  5 Nov 2026 21:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793915007;
	bh=nnsNMtUi8B/PfO4GG0OW4lr6jLs4u50NUe2xEiA6RC0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KFA+ZicKHpTxqbxZeNU9rKNH0zDIw+G9WkxRcTelADPJIyDG9z+SV38MG0CjPlcEC
	 1gjbq2m9ysrv8pBHAJrvqPnMERLZq6W4rxcogl2DlIDB44RylaSdblCTSEXNnxfcbK
	 l3RbrI5Oxv1bkdw/nOHwLpMlw6rPe3TmPXrqXYMaHNImuFIqgFREHKoGTzOn5W2eUw
	 HnogndejHth27NGEbdc3qPN/i0WWKweuYdEdmiZr5RDjCfk6/mEdy1F9Yu6XlveCU2
	 QfoEW83U8XIbYRbkOdJsXHQEOAAPFI6k6EpuBWa/BFfpmagRIXSu+HdiZvkzWIUa8b
	 kW/HsHhM4i4og==
Date: Thu, 5 Nov 2026 23:43:23 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Juergen Gross <jgross@suse.com>,
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
	Paul Moore <paul@paul-moore.com>,
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
Subject: Re: [PATCH 05/14] x86/sgx: convert vepc mmap hook to mmap_prepare
Message-ID: <auz4e81zm0mTMknq@kernel.org>
References: <20261105-late-2026-mmap_prepare-v1-0-c56aadfbab8a@kernel.org>
 <20261105-late-2026-mmap_prepare-v1-5-c56aadfbab8a@kernel.org>
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
In-Reply-To: <20261105-late-2026-mmap_prepare-v1-5-c56aadfbab8a@kernel.org>

On Thu, Nov 05, 2026 at 09:05:36PM +0000, Lorenzo Stoakes (ARM) wrote:
> Move from the deprecated mmap hook to the new mmap_prepare hook. The hook
> only checks that the mapping is shared and sets VMA flags, operations and
> private data.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  arch/x86/kernel/cpu/sgx/virt.c | 15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/virt.c
> index 6a1933ddc6fc..850990519ca5 100644
> --- a/arch/x86/kernel/cpu/sgx/virt.c
> +++ b/arch/x86/kernel/cpu/sgx/virt.c
> @@ -98,17 +98,18 @@ static const struct vm_operations_struct sgx_vepc_vm_ops = {
>  	.fault = sgx_vepc_fault,
>  };
>  
> -static int sgx_vepc_mmap(struct file *file, struct vm_area_struct *vma)
> +static int sgx_vepc_mmap_prepare(struct vm_area_desc *desc)
>  {
> -	struct sgx_vepc *vepc = file->private_data;
> +	struct sgx_vepc *vepc = desc->file->private_data;
>  
> -	if (!(vma->vm_flags & VM_SHARED))
> +	if (!vma_desc_test(desc, VMA_SHARED_BIT))
>  		return -EINVAL;
>  
> -	vma->vm_ops = &sgx_vepc_vm_ops;
> +	desc->vm_ops = &sgx_vepc_vm_ops;
>  	/* Don't copy VMA in fork() */
> -	vm_flags_set(vma, VM_PFNMAP | VM_IO | VM_DONTDUMP | VM_DONTCOPY);
> -	vma->vm_private_data = vepc;
> +	vma_desc_set_flags(desc, VMA_PFNMAP_BIT, VMA_IO_BIT, VMA_DONTDUMP_BIT,
> +			   VMA_DONTCOPY_BIT);
> +	desc->private_data = vepc;
>  
>  	return 0;
>  }
> @@ -315,7 +316,7 @@ static const struct file_operations sgx_vepc_fops = {
>  	.unlocked_ioctl	= sgx_vepc_ioctl,
>  	.compat_ioctl	= sgx_vepc_ioctl,
>  	.release	= sgx_vepc_release,
> -	.mmap		= sgx_vepc_mmap,
> +	.mmap_prepare	= sgx_vepc_mmap_prepare,
>  };
>  
>  static struct miscdevice sgx_vepc_dev = {
> 
> -- 
> 2.56.0
> 

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

Br, Jarkko
