Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B5F3C433F5
	for <linux-sgx@archiver.kernel.org>; Tue, 28 Sep 2021 02:30:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4CE1611CE
	for <linux-sgx@archiver.kernel.org>; Tue, 28 Sep 2021 02:30:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238669AbhI1CcG (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 27 Sep 2021 22:32:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:41894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238657AbhI1CcG (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 27 Sep 2021 22:32:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A1CD61156;
        Tue, 28 Sep 2021 02:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632796228;
        bh=aZb19eGc04KPVg8WtjUECbhjBtWRKXthQX+SHAeqxpE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=kbKTftO6LkTowUIQmdHo7A7AGjR/burbJeX20fHoChoreDIo0Ux8XFxxgb1yq0YZP
         Lo7hXuWU7x/wGra8pKRLK6U1Ao/mmEhVDN64jNaQTmVu/uhhAbNJlKc0mkBvX5zKrW
         5i3jkZD2Ld45OcxLpPX7CNvMb1i0fHecaLGlfSFdO2/M2AyLALFS/DpdSWzJqWkdS+
         zAFBqlcS4KrIe0Y/spDN5RcaNG9L7MBNAP1TB6BtNtz2PvzPB18plNdB4HbZOeQNa1
         kjsACxAY7fK5c6VFoV741+6iNo7tkPrF96h3gc8SFJNHl90dv+Bn2uT+oiZ7tqyDHr
         MxMqbqhBTgSLg==
Message-ID: <a3daa17517f452c1ca6bd3f7d674feb0c679bae5.camel@kernel.org>
Subject: Re: [PATCH v7 2/7] x86/sgx: Add infrastructure to identify SGX EPC
 pages
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Tony Luck <tony.luck@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Dave Hansen <dave.hansen@intel.com>
Cc:     Cathy Zhang <cathy.zhang@intel.com>, linux-sgx@vger.kernel.org
Date:   Tue, 28 Sep 2021 05:30:25 +0300
In-Reply-To: <20210927213452.212470-3-tony.luck@intel.com>
References: <20210922182123.200105-1-tony.luck@intel.com>
         <20210927213452.212470-1-tony.luck@intel.com>
         <20210927213452.212470-3-tony.luck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, 2021-09-27 at 14:34 -0700, Tony Luck wrote:
> X86 machine check architecture reports a physical address when there
> is a memory error. Handling that error requires a method to determine
> whether the physical address reported is in any of the areas reserved
> for EPC pages by BIOS.
>=20
> SGX EPC pages do not have Linux "struct page" associated with them.
>=20
> Keep track of the mapping from ranges of EPC pages to the sections
> that contain them using an xarray.
>=20
> Create a function arch_is_platform_page() that simply reports whether an =
address
> is an EPC page for use elsewhere in the kernel. The ACPI error injection
> code needs this function and is typically built as a module, so export it=
.
>=20
> Note that arch_is_platform_page() will be slower than other similar "what=
 type
> is this page" functions that can simply check bits in the "struct page".
> If there is some future performance critical user of this function it
> may need to be implemented in a more efficient way.
>=20
> Note also that the current implementation of xarray allocates a few
> hundred kilobytes for this usage on a system with 4GB of SGX EPC memory
> configured. This isn't ideal, but worth it for the code simplicity.
>=20
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/main.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>=20
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/mai=
n.c
> index d18988a46c13..09fa42690ff2 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -20,6 +20,7 @@ struct sgx_epc_section sgx_epc_sections[SGX_MAX_EPC_SEC=
TIONS];
>  static int sgx_nr_epc_sections;
>  static struct task_struct *ksgxd_tsk;
>  static DECLARE_WAIT_QUEUE_HEAD(ksgxd_waitq);
> +static DEFINE_XARRAY(sgx_epc_address_space);
> =20
>  /*
>   * These variables are part of the state of the reclaimer, and must be a=
ccessed
> @@ -650,6 +651,8 @@ static bool __init sgx_setup_epc_section(u64 phys_add=
r, u64 size,
>  	}
> =20
>  	section->phys_addr =3D phys_addr;
> +	xa_store_range(&sgx_epc_address_space, section->phys_addr,
> +		       phys_addr + size - 1, section, GFP_KERNEL);
> =20
>  	for (i =3D 0; i < nr_pages; i++) {
>  		section->pages[i].section =3D index;
> @@ -661,6 +664,12 @@ static bool __init sgx_setup_epc_section(u64 phys_ad=
dr, u64 size,
>  	return true;
>  }
> =20
> +bool arch_is_platform_page(u64 paddr)
> +{
> +	return !!xa_load(&sgx_epc_address_space, paddr);
> +}
> +EXPORT_SYMBOL_GPL(arch_is_platform_page);
> +
>  /**
>   * A section metric is concatenated in a way that @low bits 12-31 define=
 the
>   * bits 12-31 of the metric and @high bits 0-19 define the bits 32-51 of=
 the

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

/Jarkko

