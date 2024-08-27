Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79DD11C8FB0;
	Tue, 27 Aug 2024 18:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724782782; cv=none; b=c4c53yH/e57WCJXF3KsTGOFs7pyf/Gt7axyUUY4F3hwq00yOQJjiZYKWcNygSuNGdOz1l0RcPLP/+IlKEmq2u4zkcMWznbp8SU7XpCdfsuBkwoAzHMf0NeUeObclE0Ex8B3atIowJkhUBYPbSJOh1BYWA1DZjP1krDT4PXhPia8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724782782; c=relaxed/simple;
	bh=PbEqLqS9u3785t/eXJdo2OjO8MY5tj2zq5YTUPyyCWI=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:
	 References:In-Reply-To; b=KlPGNGnIH5E/67+PDUoNAoCpRJQ3nlUcoDg+nxpZ84OUFOkBw7P2hlqXt4tnzxJOmAbL9gcA0xQJEurgxmf8bEm8NPU81EiJuz/NtlCW1LJk16B0OEe+4yNSBl5wMuyNRnRLOAoLg5Gy/3zYQv2Sm/uEaudj5b3k3nIQLOpKTzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NAc00yse; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NAc00yse"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1169C4AF0F;
	Tue, 27 Aug 2024 18:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724782782;
	bh=PbEqLqS9u3785t/eXJdo2OjO8MY5tj2zq5YTUPyyCWI=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=NAc00yseS0X3OSqp/Wejlf6Jh5FmXtp43NLM9qbn2Vj29SzlmDJuvYAQdX/GcYIq2
	 j2113s9kvITcoJ0OimQSm30jatfC/5HbTCGJJXZ+NEAmrbXNFXM3NsNOZmQk3YC/Ep
	 nyXZ7GlAS3LKYZOLagMP+76ELtnIzmCgIFY59lQ2oJXwEllF/Vv4LNkhAvt4bmKbkh
	 60Lvdxj+4SAf2uJLfdZY3PyNnR0YErP9symdGeYYZzaqYxzcNtu7/oFnQSsqPelT9x
	 iMyvdRG3/BvAlyNybCehkZxpHxXbsum4g93jobbVLeuhqmcRQu+FwOAr2v2zPBLrjs
	 Ufl+duiaU1ryg==
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 27 Aug 2024 21:19:38 +0300
Message-Id: <D3QWGTWLAX0R.11U42QH2Y1TLB@kernel.org>
Subject: Re: [PATCH v5 1/3] x86/sgx: Split SGX_ENCL_PAGE_BEING_RECLAIMED
 into two flags
From: "Jarkko Sakkinen" <jarkko@kernel.org>
To: "Dmitrii Kuvaiskii" <dmitrii.kuvaiskii@intel.com>,
 <dave.hansen@linux.intel.com>, <kai.huang@intel.com>,
 <haitao.huang@linux.intel.com>, <reinette.chatre@intel.com>,
 <linux-sgx@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Cc: <mona.vij@intel.com>, <kailun.qin@intel.com>, <stable@vger.kernel.org>
X-Mailer: aerc 0.17.0
References: <20240821100215.4119457-1-dmitrii.kuvaiskii@intel.com>
 <20240821100215.4119457-2-dmitrii.kuvaiskii@intel.com>
In-Reply-To: <20240821100215.4119457-2-dmitrii.kuvaiskii@intel.com>

On Wed Aug 21, 2024 at 1:02 PM EEST, Dmitrii Kuvaiskii wrote:
> The page reclaimer thread sets SGX_ENC_PAGE_BEING_RECLAIMED flag when
> the enclave page is being reclaimed (moved to the backing store). This
> flag however has two logical meanings:
>
> 1. Don't attempt to load the enclave page (the page is busy), see
>    __sgx_encl_load_page().
> 2. Don't attempt to remove the PCMD page corresponding to this enclave
>    page (the PCMD page is busy), see reclaimer_writing_to_pcmd().
>
> To reflect these two meanings, split SGX_ENCL_PAGE_BEING_RECLAIMED into
> two flags: SGX_ENCL_PAGE_BUSY and SGX_ENCL_PAGE_PCMD_BUSY. Currently,
> both flags are set only when the enclave page is being reclaimed (by the
> page reclaimer thread). A future commit will introduce new cases when
> the enclave page is being operated on; these new cases will set only the
> SGX_ENCL_PAGE_BUSY flag.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Dmitrii Kuvaiskii <dmitrii.kuvaiskii@intel.com>
> Reviewed-by: Haitao Huang <haitao.huang@linux.intel.com>
> Acked-by: Kai Huang <kai.huang@intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/encl.c | 16 +++++++---------
>  arch/x86/kernel/cpu/sgx/encl.h | 10 ++++++++--
>  arch/x86/kernel/cpu/sgx/main.c |  4 ++--
>  3 files changed, 17 insertions(+), 13 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/enc=
l.c
> index 279148e72459..c0a3c00284c8 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.c
> +++ b/arch/x86/kernel/cpu/sgx/encl.c
> @@ -46,10 +46,10 @@ static int sgx_encl_lookup_backing(struct sgx_encl *e=
ncl, unsigned long page_ind
>   * a check if an enclave page sharing the PCMD page is in the process of=
 being
>   * reclaimed.
>   *
> - * The reclaimer sets the SGX_ENCL_PAGE_BEING_RECLAIMED flag when it
> - * intends to reclaim that enclave page - it means that the PCMD page
> - * associated with that enclave page is about to get some data and thus
> - * even if the PCMD page is empty, it should not be truncated.
> + * The reclaimer sets the SGX_ENCL_PAGE_PCMD_BUSY flag when it intends t=
o
> + * reclaim that enclave page - it means that the PCMD page associated wi=
th that
> + * enclave page is about to get some data and thus even if the PCMD page=
 is
> + * empty, it should not be truncated.
>   *
>   * Context: Enclave mutex (&sgx_encl->lock) must be held.
>   * Return: 1 if the reclaimer is about to write to the PCMD page
> @@ -77,8 +77,7 @@ static int reclaimer_writing_to_pcmd(struct sgx_encl *e=
ncl,
>  		 * Stop when reaching the SECS page - it does not
>  		 * have a page_array entry and its reclaim is
>  		 * started and completed with enclave mutex held so
> -		 * it does not use the SGX_ENCL_PAGE_BEING_RECLAIMED
> -		 * flag.
> +		 * it does not use the SGX_ENCL_PAGE_PCMD_BUSY flag.
>  		 */
>  		if (addr =3D=3D encl->base + encl->size)
>  			break;
> @@ -91,8 +90,7 @@ static int reclaimer_writing_to_pcmd(struct sgx_encl *e=
ncl,
>  		 * VA page slot ID uses same bit as the flag so it is important
>  		 * to ensure that the page is not already in backing store.
>  		 */
> -		if (entry->epc_page &&
> -		    (entry->desc & SGX_ENCL_PAGE_BEING_RECLAIMED)) {
> +		if (entry->epc_page && (entry->desc & SGX_ENCL_PAGE_PCMD_BUSY)) {
>  			reclaimed =3D 1;
>  			break;
>  		}
> @@ -257,7 +255,7 @@ static struct sgx_encl_page *__sgx_encl_load_page(str=
uct sgx_encl *encl,
> =20
>  	/* Entry successfully located. */
>  	if (entry->epc_page) {
> -		if (entry->desc & SGX_ENCL_PAGE_BEING_RECLAIMED)
> +		if (entry->desc & SGX_ENCL_PAGE_BUSY)
>  			return ERR_PTR(-EBUSY);
> =20
>  		return entry;
> diff --git a/arch/x86/kernel/cpu/sgx/encl.h b/arch/x86/kernel/cpu/sgx/enc=
l.h
> index f94ff14c9486..b566b8ad5f33 100644
> --- a/arch/x86/kernel/cpu/sgx/encl.h
> +++ b/arch/x86/kernel/cpu/sgx/encl.h
> @@ -22,8 +22,14 @@
>  /* 'desc' bits holding the offset in the VA (version array) page. */
>  #define SGX_ENCL_PAGE_VA_OFFSET_MASK	GENMASK_ULL(11, 3)
> =20
> -/* 'desc' bit marking that the page is being reclaimed. */
> -#define SGX_ENCL_PAGE_BEING_RECLAIMED	BIT(3)
> +/* 'desc' bit indicating that the page is busy (being reclaimed). */
> +#define SGX_ENCL_PAGE_BUSY	BIT(2)
> +
> +/*
> + * 'desc' bit indicating that PCMD page associated with the enclave page=
 is
> + * busy (because the enclave page is being reclaimed).
> + */
> +#define SGX_ENCL_PAGE_PCMD_BUSY	BIT(3)
> =20
>  struct sgx_encl_page {
>  	unsigned long desc;
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/mai=
n.c
> index 166692f2d501..e94b09c43673 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -204,7 +204,7 @@ static void sgx_encl_ewb(struct sgx_epc_page *epc_pag=
e,
>  	void *va_slot;
>  	int ret;
> =20
> -	encl_page->desc &=3D ~SGX_ENCL_PAGE_BEING_RECLAIMED;
> +	encl_page->desc &=3D ~(SGX_ENCL_PAGE_BUSY | SGX_ENCL_PAGE_PCMD_BUSY);
> =20
>  	va_page =3D list_first_entry(&encl->va_pages, struct sgx_va_page,
>  				   list);
> @@ -340,7 +340,7 @@ static void sgx_reclaim_pages(void)
>  			goto skip;
>  		}
> =20
> -		encl_page->desc |=3D SGX_ENCL_PAGE_BEING_RECLAIMED;
> +		encl_page->desc |=3D SGX_ENCL_PAGE_BUSY | SGX_ENCL_PAGE_PCMD_BUSY;
>  		mutex_unlock(&encl_page->encl->lock);
>  		continue;
> =20

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko
