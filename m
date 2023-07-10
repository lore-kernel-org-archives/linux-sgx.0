Return-Path: <linux-sgx-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 880DCEB64D9
	for <linux-sgx@archiver.kernel.org>; Mon, 10 Jul 2023 22:03:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbjGJWDE (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 10 Jul 2023 18:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbjGJWDD (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 10 Jul 2023 18:03:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E46CDB;
        Mon, 10 Jul 2023 15:03:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E8CEC61219;
        Mon, 10 Jul 2023 22:03:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB56BC433C8;
        Mon, 10 Jul 2023 22:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689026581;
        bh=QkD3M45pBf5ZdiitEq+NQPv2vInySkvd4mwkzR+lFIQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ukVuAUHZaF72E1Be1WHOTj+eiHFvWZ/qXZZXFN2/tbflwkd5Mn9GhB8XIEIxOHYuu
         i9+KPPiGlcrYzOsV5ffLTQN1lQr7biJy2T2WK6GLj37+BPUfwdXIBGpOA+K430yo0W
         CEQjU69mBojxHzd3oNs1Rp3EMux+zy3dQIuGTRMLB5TQ35ryIZg73QyzuiUj1fyLYc
         tr5b66X/Rp71YY44d8faHh/F0w4fAEud01dcDShRRFGJ08LnUL14CDfnsbrS6fiyW8
         Ovqf9YjQb6vNlERwRzp63eceQOIeqVnDJymZG+C7q6xePprg6rCw1hMJ80oyO+8vm2
         eu2wteowKmq+g==
Message-ID: <e0fe4f98d28e98d04611c06bd9320bee53998e65.camel@kernel.org>
Subject: Re: [PATCH 21/26] x86/sgx: use array_size
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Julia Lawall <Julia.Lawall@inria.fr>
Cc:     keescook@chromium.org, kernel-janitors@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 11 Jul 2023 01:02:57 +0300
In-Reply-To: <20230623211457.102544-22-Julia.Lawall@inria.fr>
References: <20230623211457.102544-1-Julia.Lawall@inria.fr>
         <20230623211457.102544-22-Julia.Lawall@inria.fr>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.1-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, 2023-06-23 at 23:14 +0200, Julia Lawall wrote:
> Use array_size to protect against multiplication overflows.
>=20
> The changes were done using the following Coccinelle semantic patch:
>=20
> // <smpl>
> @@
>     expression E1, E2;
>     constant C1, C2;
>     identifier alloc =3D {vmalloc,vzalloc};
> @@
>    =20
> (
>       alloc(C1 * C2,...)
> >=20
>       alloc(
> -           (E1) * (E2)
> +           array_size(E1, E2)
>       ,...)
> )
> // </smpl>
>=20
> Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>
>=20
> ---
>  arch/x86/kernel/cpu/sgx/main.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/mai=
n.c
> index 166692f2d501..3a234942c586 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -628,7 +628,8 @@ static bool __init sgx_setup_epc_section(u64 phys_add=
r, u64 size,
>  	if (!section->virt_addr)
>  		return false;
> =20
> -	section->pages =3D vmalloc(nr_pages * sizeof(struct sgx_epc_page));
> +	section->pages =3D vmalloc(array_size(nr_pages,
> +					    sizeof(struct sgx_epc_page)));
>  	if (!section->pages) {
>  		memunmap(section->virt_addr);
>  		return false;
>=20

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko
