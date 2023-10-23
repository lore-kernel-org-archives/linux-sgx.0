Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC93AC00A8F
	for <linux-sgx@archiver.kernel.org>; Mon, 23 Oct 2023 23:30:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbjJWXaU (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 23 Oct 2023 19:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjJWXaT (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 23 Oct 2023 19:30:19 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09A65A6;
        Mon, 23 Oct 2023 16:30:18 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34448C433C7;
        Mon, 23 Oct 2023 23:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1698103817;
        bh=/Cp0OWUVyZIik3/L+URbEHtp91y6DDa0GoZFwNGqVMk=;
        h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
        b=Kpad+aHh5nu0l7B4yeOPwCDVBB26oZaqTCNYorKEJfmhfDxGfNPZf+tA5YAhZWdKV
         NUIaFcQX7uNAk1QG+wuDXryuxFU9a6S7PzBWkuHIou5M0LXFZhZdUaWtUzu5Fyq7Cg
         /EselnecXKyodJzfQroPpKzrOdgkUFYPk6USD5gVdbXBNT5aH2mWz0SwkvM0alP+cU
         ryd9fwsuUedqfjrFpzAbSqhPSLk6UBgEsBKk6x9asCy3416Vmz/1VTTbhW+PTdQZCc
         Pjqv9Fv/EOTIzxLKHCi042Malcym3yrRaYbaapQ7REq3MqYOUD7rm0Zz6yiC71aAT3
         a7oEgQ5t1Xdrg==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 24 Oct 2023 02:30:13 +0300
Message-Id: <CWG7KARCO4TX.257MYGX7AHV8T@suppilovahvero>
Cc:     <reinette.chatre@intel.com>, <kai.huang@intel.com>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH] x86/sgx: Return VM_FAULT_SIGBUS for EPC exhaustion
From:   "Jarkko Sakkinen" <jarkko@kernel.org>
To:     "Haitao Huang" <haitao.huang@linux.intel.com>,
        <dave.hansen@linux.intel.com>, <linux-sgx@vger.kernel.org>,
        <x86@kernel.org>
X-Mailer: aerc 0.15.2
References: <20231020025353.29691-1-haitao.huang@linux.intel.com>
In-Reply-To: <20231020025353.29691-1-haitao.huang@linux.intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri Oct 20, 2023 at 5:53 AM EEST, Haitao Huang wrote:
> In the EAUG on page fault path, VM_FAULT_OOM is returned when the
> Enclave Page Cache (EPC) runs out. This may trigger unneeded OOM kill
> that will not free any EPCs. Return VM_FAULT_SIGBUS instead.
>
> Fixes: 5a90d2c3f5ef ("x86/sgx: Support adding of pages to an initialized =
enclave")
> Cc: stable@vger.kernel.org # v6.0+
> Signed-off-by: Haitao Huang <haitao.huang@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/encl.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/enc=
l.c
> index 279148e72459..d13b7e4ad0f5 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -322,7 +322,7 @@ struct sgx_encl_page *sgx_encl_load_page(struct sgx_e=
ncl *encl,
>   * ENCLS[EAUG] instruction.
>   *
>   * Returns: Appropriate vm_fault_t: VM_FAULT_NOPAGE when PTE was install=
ed
> - * successfully, VM_FAULT_SIGBUS or VM_FAULT_OOM as error otherwise.
> + * successfully, VM_FAULT_SIGBUS as error otherwise.
>   */
>  static vm_fault_t sgx_encl_eaug_page(struct vm_area_struct *vma,
>  				     struct sgx_encl *encl, unsigned long addr)
> @@ -348,7 +348,7 @@ static vm_fault_t sgx_encl_eaug_page(struct vm_area_s=
truct *vma,
>  	secinfo_flags =3D SGX_SECINFO_R | SGX_SECINFO_W | SGX_SECINFO_X;
>  	encl_page =3D sgx_encl_page_alloc(encl, addr - encl->base, secinfo_flag=
s);
>  	if (IS_ERR(encl_page))
> -		return VM_FAULT_OOM;
> +		return VM_FAULT_SIGBUS;
> =20
>  	mutex_lock(&encl->lock);
> =20

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko
