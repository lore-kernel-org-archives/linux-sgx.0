Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB5C39FD6;
	Thu,  5 Sep 2024 14:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725546119; cv=none; b=Nue8AiOdG3R2ngQ7P1uWHHBb7VpMVpbWW+pzUbzC9K4HrbbSHoaZ1xUoMbfARMKEmhaf5vsKMIXw6ZLlZk0XNFnK6yi1zaeaaPv+i1lOtR1egKuOyCB4OGn0JgSxWh8AKSmiW4CMLOVFhzKS1YH0KDnEKQIpwfpYdY7bbGteXEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725546119; c=relaxed/simple;
	bh=Zb7oHMprDtfjoUgEL0nk+8rkRgsGaBfl/DbNtiqtvFk=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:
	 References:In-Reply-To; b=fIwnyoi15wHQtYd1Cr5nkk7USvJDOLrfl9gbM3fTPDWK8oOEoytr90K6Qym7Dn9NnAUjwrWztdJAet1vxrcNhb0BhlLdV5aC+xHjG7EbDQiG6DwSri+Tg2v8xMmZpZwImLhLIbQij0xriT3E4XqiTWhbKcsI9SpepoZE40iIjIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tGWHg4Pe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tGWHg4Pe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E2E8C4CEC3;
	Thu,  5 Sep 2024 14:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725546118;
	bh=Zb7oHMprDtfjoUgEL0nk+8rkRgsGaBfl/DbNtiqtvFk=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=tGWHg4Pe+q91TU3NaDHi0MHO9SI7seZNIPCQ7KMQ5AQzPlkJWADSPD79wgIeplXq0
	 38HMfv7yLEnycDqxLfhPa00gHvv4QL93W855rvYyD+cGHnY0ZHQhEa7PYKfn/evy2F
	 BHqW2z0767J7CEdFhPGn/3BqntJloJ+iSJzoFr7x8lZZYXbkE9P0s18pi86KFEjL/o
	 y+fk69KSAtN5Xb1erxXMpamVPKzQBHSbJ1wKoA/kyLI6TS4Hq2Iv7xZAXPxOUhnZUu
	 TUMTsrW0Xj76Vk0k4HgyYBY5c3ddlIp2xJz3/lEfgTgVtxNvhZCAVTAYaSMotWyl4T
	 iFS57r6C6frVQ==
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 05 Sep 2024 17:21:54 +0300
Message-Id: <D3YF1PO93RI0.2V31UQ4D620TT@kernel.org>
Subject: Re: [PATCH v2 1/2] x86/sgx: Fix deadlock in SGX NUMA node search
From: "Jarkko Sakkinen" <jarkko@kernel.org>
To: "Aaron Lu" <aaron.lu@intel.com>, "Dave Hansen"
 <dave.hansen@linux.intel.com>, "Kai Huang" <kai.huang@intel.com>
Cc: "Molina Sabido, Gerardo" <gerardo.molina.sabido@intel.com>, "Zhimin Luo"
 <zhimin.luo@intel.com>, <linux-sgx@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <x86@kernel.org>
X-Mailer: aerc 0.18.2
References: <20240905080855.1699814-1-aaron.lu@intel.com>
 <20240905080855.1699814-2-aaron.lu@intel.com>
In-Reply-To: <20240905080855.1699814-2-aaron.lu@intel.com>

On Thu Sep 5, 2024 at 11:08 AM EEST, Aaron Lu wrote:
> When the current node doesn't have an EPC section configured by firmware
> and all other EPC sections are used up, CPU can get stuck inside the
> while loop that looks for an available EPC page from remote nodes
> indefinitely, leading to a soft lockup. Note how nid_of_current will
> never be equal to nid in that while loop because nid_of_current is not
> set in sgx_numa_mask.
>
> Also worth mentioning is that it's perfectly fine for the firmware not
> to setup an EPC section on a node. While setting up an EPC section on
> each node can enhance performance, it is not a requirement for
> functionality.
>
> Rework the loop to start and end on *a* node that has SGX memory. This
> avoids the deadlock looking for the current SGX-lacking node to show up
> in the loop when it never will.
>
> Fixes: 901ddbb9ecf5 ("x86/sgx: Add a basic NUMA allocation scheme to sgx_=
alloc_epc_page()")
> Reported-by: "Molina Sabido, Gerardo" <gerardo.molina.sabido@intel.com>
> Tested-by: Zhimin Luo <zhimin.luo@intel.com>
> Reviewed-by: Kai Huang <kai.huang@intel.com>
> Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/main.c | 27 ++++++++++++++-------------
>  1 file changed, 14 insertions(+), 13 deletions(-)
>
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/mai=
n.c
> index 1a000acd933a..694fcf7a5e3a 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -475,24 +475,25 @@ struct sgx_epc_page *__sgx_alloc_epc_page(void)
>  {
>  	struct sgx_epc_page *page;
>  	int nid_of_current =3D numa_node_id();
> -	int nid =3D nid_of_current;
> +	int nid_start, nid;
> =20
> -	if (node_isset(nid_of_current, sgx_numa_mask)) {
> -		page =3D __sgx_alloc_epc_page_from_node(nid_of_current);
> -		if (page)
> -			return page;
> -	}
> -
> -	/* Fall back to the non-local NUMA nodes: */
> -	while (true) {
> -		nid =3D next_node_in(nid, sgx_numa_mask);
> -		if (nid =3D=3D nid_of_current)
> -			break;
> +	/*
> +	 * Try local node first. If it doesn't have an EPC section,
> +	 * fall back to the non-local NUMA nodes.
> +	 */
> +	if (node_isset(nid_of_current, sgx_numa_mask))
> +		nid_start =3D nid_of_current;
> +	else
> +		nid_start =3D next_node_in(nid_of_current, sgx_numa_mask);
> =20
> +	nid =3D nid_start;
> +	do {
>  		page =3D __sgx_alloc_epc_page_from_node(nid);
>  		if (page)
>  			return page;
> -	}
> +
> +		nid =3D next_node_in(nid, sgx_numa_mask);
> +	} while (nid !=3D nid_start);
> =20
>  	return ERR_PTR(-ENOMEM);
>  }

Looks good to me:

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

BR, Jarkko
