Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C128D54654;
	Sat, 22 Mar 2025 21:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742680726; cv=none; b=FB2PIK3vOusemOA/T0W1FfF8c6pdPIeVFjDx4u2I18rqh7clMh2QABWBUHo1Bt1lDAfC7Ow1ppqAcypTPOw7tFSAsezFaDS/6ffj7oElgrlgovC7YvAo6/UaacRLWMPrU3iCye35wnjffbESIOwcVgOBQ2gIebubWG6yZ6qZtRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742680726; c=relaxed/simple;
	bh=cy9ZWIHTb+rP28jMKm0pKV+/hp1M6pQwsR6b+gLIe+s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JU/Naos7+bc72SxoQ2S9mN0NG5M3afJV0V3PqLrw+5HkFq++hW57oxdJH2o6Zg3wK/4sgyOIkmY72LB96CvfkyiBYB2Mt/07XpnU67kWAhnALABBlkMgDLbxS+f0mKY91Z0cgf/T02pTp4Lod9QyKba14OBPpcLJKQgiZTVAc6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MuiJFbNF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MuiJFbNF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7094C4CEDD;
	Sat, 22 Mar 2025 21:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742680726;
	bh=cy9ZWIHTb+rP28jMKm0pKV+/hp1M6pQwsR6b+gLIe+s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MuiJFbNF5qtDzY8OFSZ9kpOqQ41P08DmLyqaj9JMA5S3BpDHHlbNmGqBOhIScU5lI
	 sdawXeTIHXRCvVE8YhsPLaNLcdiJpgzMVydKaYTK78/K1gOHaVNS2V00kUZJcEgTK9
	 mWuZuWhPrz7j7gXw5NnDUt+ZOLEXB95+lD4NCVfY2zoqSdCxFG6mmwlUK6zvwbKPH9
	 tu9domaxpd6RKsuzjlS++i8LhasAGPoPckTXOWCM4R+lTptmBKsa46dJAKNL1GkAZf
	 sBqnlEQJtGULN4I6YPA1MKvmFe1yNsK5tzKQG9tvJdXN8AjB+TOechZVNMHVNwuNeW
	 f17s81iS4nFwA==
Date: Sat, 22 Mar 2025 23:58:42 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: dave.hansen@intel.com, linux-sgx@vger.kernel.org,
	linux-kernel@vger.kernel.org, x86@kernel.org,
	asit.k.mallick@intel.com, vincent.r.scarlata@intel.com,
	chongc@google.com, erdemaktas@google.com, vannapurve@google.com,
	dionnaglaze@google.com, bondarn@google.com, scott.raynor@intel.com
Subject: Re: [PATCH 1/4] x86/sgx: Add total number of EPC pages
Message-ID: <Z98yki-gH4ewlpbP@kernel.org>
References: <20250321123938.802763-1-elena.reshetova@intel.com>
 <20250321123938.802763-2-elena.reshetova@intel.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250321123938.802763-2-elena.reshetova@intel.com>

On Fri, Mar 21, 2025 at 02:34:40PM +0200, Elena Reshetova wrote:
> In order to successfully execute ENCLS[EUPDATESVN], EPC must be empty.
> SGX already has a variable sgx_nr_free_pages that tracks free
> EPC pages. Add a new variable, sgx_nr_total_pages, that will keep
> track of total number of EPC pages. It will be used in subsequent
> patch to change the sgx_nr_free_pages into sgx_nr_used_pages and
> allow an easy check for an empty EPC.

First off, remove "in subsequent patch".

What does "change sgx_nr_free_pages into sgx_nr_used_pages" mean?

> 
> Note: The serialization for sgx_nr_total_pages is not needed because
> the variable is only updated during the initialization and there's no
> concurrent access.
> 
> Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
> ---
>  arch/x86/kernel/cpu/sgx/main.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index 8ce352fc72ac..d5df67dab247 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -33,6 +33,7 @@ static LIST_HEAD(sgx_active_page_list);
>  static DEFINE_SPINLOCK(sgx_reclaimer_lock);
>  
>  static atomic_long_t sgx_nr_free_pages = ATOMIC_LONG_INIT(0);
> +static unsigned long sgx_nr_total_pages;
>  
>  /* Nodes with one or more EPC sections. */
>  static nodemask_t sgx_numa_mask;
> @@ -648,6 +649,8 @@ static bool __init sgx_setup_epc_section(u64 phys_addr, u64 size,
>  		list_add_tail(&section->pages[i].list, &sgx_dirty_page_list);
>  	}
>  
> +	sgx_nr_total_pages += nr_pages;
> +
>  	return true;
>  }
>  
> -- 
> 2.45.2
> 

BR, Jarkko
