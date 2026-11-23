Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=13.77.154.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795476504;
	b=JPpw3+mYuFa37gMhOfUqBUoRdIf5HMfgsz+REPFRHm7Ans5e1JaLUwTMs8VGfcOnsQUI
	 oCrWiLmDAP5IKnqefhTXc22t1E2jwT6ugWVPAwaNF5A9mgwLv+Qg0xsAYcYt62FQi4Tmh
	 kdq32hhdpcSND2lr/AwFmey1fk2MUXWiEvrMOcxMVrJweQit0kJQY+yGxxuPQAwFcQxds
	 tf7pVLmOVon3gZcmQyBNVtNypsEl6ETwcw2jygiXtAa85aO0cPb5sQC9xmFVergvnadNt
	 Jnsn1nJl1Cg+RIS1cRqGvrO/amHHfcvijUvMopnC4s5lg5N6amyOC89gS0gK/DIRPQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795476504;
	h=DMARC-Filter:Received:DKIM-Filter:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=Z4q2lcvDeMyQnvMma/TSV0pjEr8kXRVVL/7uiZixGfQ=;
	b=GmXV8TMZsQxCfITlv+MzVcNL5bYgDgcrpAx9d2SDpNcfhsJ10XCAVR6BILs2Rgp9Tlx1
	 PrM+HPWkP73i1Y8BXm8y5RBaTkojVzAA7xz1H9zA8wdabtAj6+L7qysVlnRh1bb1o8jXG
	 qk6Jv6bqNgrv6MIcUrmbuUQVbHpKGwWdxWaTLsTsrDF9WlTUbyombohma9mAoSDFoUW+0
	 NozGRttGAp5H6lGCeImiwrD7p1dH3rPtGzosojCh2aINF9oI3xLGAiv1eiRFZcLF8F1PK
	 t+T5/gVLABB68iyJDojqdCZaKgrbZNgJsptukIFfuDusf9x+1PxSSj15IrWd2JeMXbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.microsoft.com;
	spf=pass smtp.mailfrom=linux.microsoft.com;
	dkim=pass header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=GBCBOGHy;
	arc=none smtp.remote-ip=13.77.154.182
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E976E606A321;
	Mon, 23 Nov 2026 23:28:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E976E606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.a=rsa-sha256 header.s=default header.b=GBCBOGHy
Received: from [192.168.159.19] (unknown [4.194.122.136])
	by linux.microsoft.com (Postfix) with ESMTPSA id DCBAB20B7167;
	Mon, 23 Nov 2026 15:27:54 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com DCBAB20B7167
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1795476499;
	bh=Z4q2lcvDeMyQnvMma/TSV0pjEr8kXRVVL/7uiZixGfQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=GBCBOGHyS/woweuMXp/5IiE28nI/q/RWX2fOSyY1oqRdeq6mlJhA0Uy5CY+vntB9X
	 OBTSWMmuYPNMyZOn37AlljwgO2+M5LQQTDHUqK0know9vyyT8rD60yDr0IBXlfgUHN
	 T50QratbJQPYi89ozm+6Qtlk7+5eXdmnoqz5Vvmg=
Message-ID: <ba8c4cdb-ba60-4166-8d0f-812db13ee90a@linux.microsoft.com>
Date: Mon, 23 Nov 2026 15:27:55 -0800
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Post: <mailto:linux-sgx@vger.kernel.org>
List-Help: <mailto:linux-sgx+help@vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-sgx+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/14] mshv_vtl: convert mmap hooks to mmap_prepare
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
 linux-hyperv@vger.kernel.org, virtualization@lists.linux.dev,
 linux-sgx@vger.kernel.org, selinux@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-aspeed@lists.ozlabs.org,
 linux-arm-msm@vger.kernel.org, op-tee@lists.trustedfirmware.org,
 netdev@vger.kernel.org, Juergen Gross <jgross@suse.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Shrikanth Hegde <sshegde@linux.ibm.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Jason Wang <jasowangio@gmail.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?=
 <eperezma@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
 Jarkko Sakkinen <jarkko@kernel.org>,
 Dave Hansen <dave.hansen@linux.intel.com>, Thomas Gleixner
 <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Jan Kara <jack@suse.com>,
 Paul Moore <paul@paul-moore.com>,
 Stephen Smalley <stephen.smalley.work@gmail.com>,
 =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>,
 Joel Stanley <joel@jms.id.au>, Andrew Jeffery <andrew@codeconstruct.com.au>,
 Ryan Chen <ryan_chen@aspeedtech.com>, Billy Tsai
 <billy_tsai@aspeedtech.com>, Bjorn Andersson <andersson@kernel.org>,
 Konrad Dybcio <konradybcio@kernel.org>, Abel Vesa <abelvesa@kernel.org>,
 Jens Wiklander <jenswi@kernel.org>, Sumit Garg <sumit.garg@kernel.org>,
 Scott Branden <scott.branden@broadcom.com>,
 Broadcom internal kernel review list
 <bcm-kernel-feedback-list@broadcom.com>, Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Richard Cochran <richardcochran@gmail.com>,
 David Woodhouse <dwmw2@infradead.org>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
References: <20261105-late-2026-mmap_prepare-v1-0-c56aadfbab8a@kernel.org>
 <20261105-late-2026-mmap_prepare-v1-3-c56aadfbab8a@kernel.org>
Content-Language: en-US
From: Kameron Carr <kameroncarr@linux.microsoft.com>
In-Reply-To: <20261105-late-2026-mmap_prepare-v1-3-c56aadfbab8a@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/5/2026 1:05 PM, Lorenzo Stoakes (ARM) wrote:
> Move from the deprecated mmap hook to the new mmap_prepare hook for both
> the mshv_vtl and mshv_vtl_low devices. These only set VMA operations and
> flags.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

I don't see this causing any functional changes, but quickly ran basic
regression testing on it anyway. I couldn't find b61fa14ce; I tested
based on v7.4-rc1.

No issues seen.

Tested-by: Kameron Carr <kameroncarr@linux.microsoft.com>
Reviewed-by: Kameron Carr <kameroncarr@linux.microsoft.com>

-- 
Regards,
Kameron

> ---
>  drivers/hv/mshv_vtl_main.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/hv/mshv_vtl_main.c b/drivers/hv/mshv_vtl_main.c
> index d8225242c73f..e372d4c0188d 100644
> --- a/drivers/hv/mshv_vtl_main.c
> +++ b/drivers/hv/mshv_vtl_main.c
> @@ -832,9 +832,9 @@ static const struct vm_operations_struct mshv_vtl_vm_ops = {
>  	.fault = mshv_vtl_fault,
>  };
>  
> -static int mshv_vtl_mmap(struct file *filp, struct vm_area_struct *vma)
> +static int mshv_vtl_mmap_prepare(struct vm_area_desc *desc)
>  {
> -	vma->vm_ops = &mshv_vtl_vm_ops;
> +	desc->vm_ops = &mshv_vtl_vm_ops;
>  
>  	return 0;
>  }
> @@ -852,7 +852,7 @@ static const struct file_operations mshv_vtl_fops = {
>  	.owner = THIS_MODULE,
>  	.unlocked_ioctl = mshv_vtl_ioctl,
>  	.release = mshv_vtl_release,
> -	.mmap = mshv_vtl_mmap,
> +	.mmap_prepare = mshv_vtl_mmap_prepare,
>  };
>  
>  static void mshv_vtl_synic_mask_vmbus_sint(void *info)
> @@ -1283,10 +1283,10 @@ static const struct vm_operations_struct mshv_vtl_low_vm_ops = {
>  	.huge_fault = mshv_vtl_low_huge_fault,
>  };
>  
> -static int mshv_vtl_low_mmap(struct file *filp, struct vm_area_struct *vma)
> +static int mshv_vtl_low_mmap_prepare(struct vm_area_desc *desc)
>  {
> -	vma->vm_ops = &mshv_vtl_low_vm_ops;
> -	vm_flags_set(vma, VM_HUGEPAGE | VM_MIXEDMAP);
> +	desc->vm_ops = &mshv_vtl_low_vm_ops;
> +	vma_desc_set_flags(desc, VMA_HUGEPAGE_BIT, VMA_MIXEDMAP_BIT);
>  
>  	return 0;
>  }
> @@ -1294,7 +1294,7 @@ static int mshv_vtl_low_mmap(struct file *filp, struct vm_area_struct *vma)
>  static const struct file_operations mshv_vtl_low_file_ops = {
>  	.owner		= THIS_MODULE,
>  	.open		= mshv_vtl_low_open,
> -	.mmap		= mshv_vtl_low_mmap,
> +	.mmap_prepare	= mshv_vtl_low_mmap_prepare,
>  };
>  
>  static struct miscdevice mshv_vtl_low = {
> 
