Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED202EE498F
	for <linux-sgx@archiver.kernel.org>; Fri, 18 Aug 2023 18:09:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379357AbjHRSJF (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 18 Aug 2023 14:09:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379413AbjHRSIx (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 18 Aug 2023 14:08:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 522D23C38;
        Fri, 18 Aug 2023 11:08:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DBC2A62094;
        Fri, 18 Aug 2023 18:08:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 490ECC433C7;
        Fri, 18 Aug 2023 18:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692382131;
        bh=RDs4i4sX+Hdg92wPMKtBk4ewJ7xvCreddYKAyrVaBo0=;
        h=Date:To:Cc:Subject:From:References:In-Reply-To:From;
        b=pN5ZsSX8WMgq3EBY75PXoe6tsbcwf/dS+EV0L9DS2H/J/q4M4StYLtVGpGGbUln6W
         BTeijhdh2nmlH19AwWVTP70tm5wdbDWrqtiqSClcSfrwQ7hH6lUFO1e+2a2fbDn5pB
         REUYD8LpEtmQe6uhIwiH89JM13JwZiC82o0UUAo9zgJ/ICHX2i9UI5+4d9p4UFKJE2
         dbxq42qTd1VjRFzrAwjydDFlkPiIdDkH9Zaa9mEdX3k6i2YHMT0/8FVJEvuBcD3tXf
         zIdFVtyJnwbYovp1xItzuq82Jhbc9u1CKRTFHSt2g1MpZ3bo9zt19uydSVBh0JxoiS
         spa/8HbAQGBgQ==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 18 Aug 2023 21:08:48 +0300
Message-Id: <CUVVE8SANDIJ.2JT54YFSV9TTN@suppilovahvero>
To:     "Jack Wang" <jinpu.wang@ionos.com>, <linux-sgx@vger.kernel.org>
Cc:     "Haitao Huang" <haitao.huang@linux.intel.com>,
        <stable@vger.kernel.org>, "Yu Zhang" <yu.zhang@ionos.com>
Subject: Re: [PATCHv3] x86/sgx: Avoid softlockup from sgx_vepc_release
From:   "Jarkko Sakkinen" <jarkko@kernel.org>
X-Mailer: aerc 0.14.0
References: <20230818180702.4621-1-jinpu.wang@ionos.com>
In-Reply-To: <20230818180702.4621-1-jinpu.wang@ionos.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri Aug 18, 2023 at 9:07 PM EEST, Jack Wang wrote:
> We hit softlocup with following call trace:
>
> ? asm_sysvec_apic_timer_interrupt+0x16/0x20
> xa_erase+0x21/0xb0
> ? sgx_free_epc_page+0x20/0x50
> sgx_vepc_release+0x75/0x220
> __fput+0x89/0x250
> task_work_run+0x59/0x90
> do_exit+0x337/0x9a0
>
> Similar like commit 8795359e35bc ("x86/sgx: Silence softlockup detection
> when releasing large enclaves"). The test system has 64GB of enclave memo=
ry,
> and all assigned to a single VM. Release vepc take longer time and trigge=
rs
> the softlockup warning.
>
> Add cond_resched() to give other tasks a chance to run and placate
> the softlockup detector.
>
> Cc: Jarkko Sakkinen <jarkko@kernel.org>
> Cc: Haitao Huang <haitao.huang@linux.intel.com>
> Cc: stable@vger.kernel.org
> Fixes: 540745ddbc70 ("x86/sgx: Introduce virtual EPC for use by KVM guest=
s")
> Reported-by: Yu Zhang <yu.zhang@ionos.com>
> Tested-by: Yu Zhang <yu.zhang@ionos.com>
> Acked-by: Haitao Huang <haitao.huang@linux.intel.com>
> Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
> Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
> ---
> v3:
> * improve commit message as suggested.
> * Add cond_resched() to the 3rd loop too.
>  arch/x86/kernel/cpu/sgx/virt.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/arch/x86/kernel/cpu/sgx/virt.c b/arch/x86/kernel/cpu/sgx/vir=
t.c
> index c3e37eaec8ec..7aaa3652e31d 100644
> --- a/arch/x86/kernel/cpu/sgx/virt.c
> +++ b/arch/x86/kernel/cpu/sgx/virt.c
> @@ -204,6 +204,7 @@ static int sgx_vepc_release(struct inode *inode, stru=
ct file *file)
>  			continue;
> =20
>  		xa_erase(&vepc->page_array, index);
> +		cond_resched();
>  	}
> =20
>  	/*
> @@ -222,6 +223,7 @@ static int sgx_vepc_release(struct inode *inode, stru=
ct file *file)
>  			list_add_tail(&epc_page->list, &secs_pages);
> =20
>  		xa_erase(&vepc->page_array, index);
> +		cond_resched();
>  	}
> =20
>  	/*
> @@ -243,6 +245,7 @@ static int sgx_vepc_release(struct inode *inode, stru=
ct file *file)
> =20
>  		if (sgx_vepc_free_page(epc_page))
>  			list_add_tail(&epc_page->list, &secs_pages);
> +		cond_resched();
>  	}
> =20
>  	if (!list_empty(&secs_pages))
> --=20
> 2.34.1

Just acknowledging that my reviewed-by still holds for this patch.

BR, Jarkko
