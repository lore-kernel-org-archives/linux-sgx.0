Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D6326289;
	Thu, 27 Mar 2025 21:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743110939; cv=none; b=kp71Rk5rrEgOkbPIsgW0pi31adt+k7prQnv33SVeSA02ApjTsKYzzo8cNpwM/FMw4wcY7UjhFjahfXj9bY8Tr4DCI4fTuujn5+lWYIl0xRPzrOSpVOC1lY+zud7hKF/kHIA1wmRatOcdA8kkBmL4grrvPtDkgPpqJf3qSl0CZLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743110939; c=relaxed/simple;
	bh=WiLrfU+LP++scAnoWFMiY79wCpV1nlGlwqnHdfpKrlU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NVR5vl0Y3jy5b7r1OI6n0IAxPHGrkSyjrlBKI+MyVgcRUMdZzkEN3TMk8OCF+kwtiP/MgGJyt1TACXoxU2AJDtcagYWt7JyBYgeA+VHdQ8FvkvbdAaSw7DDP8GcrY11mG7ZJF4A6z0kYew9vjhuoFiryAEEJct8NBUWV04vhHGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EWBWR4/W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EWBWR4/W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F32FC4CEDD;
	Thu, 27 Mar 2025 21:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743110937;
	bh=WiLrfU+LP++scAnoWFMiY79wCpV1nlGlwqnHdfpKrlU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EWBWR4/WC5scIx0dbtVikkG4lPVWw0w81dPIq5c65WAGDJogDVXW7YPtAdkxLpmBg
	 vfpXq3zRVwtfKc5s5wnqyFBHMyKhSdJBuVhiuVmEgNmqtaFycKnj1KgVu7yT3iX5XO
	 Ft7gyHqTBdBClAzoQ2PjCpMWmjQzwGfd5Lu4fYDghZ5P7nV+ovNaHx2fpgr8gIfpxk
	 c1KNG74cp3Haa/5KvgdUWSa592RM45phSgkUDm52gazl075BZyMHDmwpDjsyHsGaRN
	 Nodk/8p9cKGB76RkVoyYrOUB+ItUijjn51AVjRBseXFNZmAOZb1tc+EbRaIpA1fxZy
	 UMxLzlKjNHOlQ==
Date: Thu, 27 Mar 2025 23:28:52 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: "Reshetova, Elena" <elena.reshetova@intel.com>
Cc: "Hansen, Dave" <dave.hansen@intel.com>,
	"linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>,
	"Mallick, Asit K" <asit.k.mallick@intel.com>,
	"Scarlata, Vincent R" <vincent.r.scarlata@intel.com>,
	"Cai, Chong" <chongc@google.com>,
	"Aktas, Erdem" <erdemaktas@google.com>,
	"Annapurve, Vishal" <vannapurve@google.com>,
	"dionnaglaze@google.com" <dionnaglaze@google.com>,
	"bondarn@google.com" <bondarn@google.com>,
	"Raynor, Scott" <scott.raynor@intel.com>,
	"Shutemov, Kirill" <kirill.shutemov@intel.com>
Subject: Re: [PATCH 1/4] x86/sgx: Add total number of EPC pages
Message-ID: <Z-XDFDj8Tc5i-GBg@kernel.org>
References: <20250321123938.802763-1-elena.reshetova@intel.com>
 <20250321123938.802763-2-elena.reshetova@intel.com>
 <Z98yki-gH4ewlpbP@kernel.org>
 <DM8PR11MB57508A3681C614C9B185B04EE7A42@DM8PR11MB5750.namprd11.prod.outlook.com>
 <Z-RY8-bL2snpRKTB@kernel.org>
 <DM8PR11MB575029FAC2C833553CE422CFE7A12@DM8PR11MB5750.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DM8PR11MB575029FAC2C833553CE422CFE7A12@DM8PR11MB5750.namprd11.prod.outlook.com>

oN Thu, Mar 27, 2025 at 03:29:53PM +0000, Reshetova, Elena wrote:
> 
> > On Mon, Mar 24, 2025 at 12:12:41PM +0000, Reshetova, Elena wrote:
> > > > On Fri, Mar 21, 2025 at 02:34:40PM +0200, Elena Reshetova wrote:
> > > > > In order to successfully execute ENCLS[EUPDATESVN], EPC must be
> > empty.
> > > > > SGX already has a variable sgx_nr_free_pages that tracks free
> > > > > EPC pages. Add a new variable, sgx_nr_total_pages, that will keep
> > > > > track of total number of EPC pages. It will be used in subsequent
> > > > > patch to change the sgx_nr_free_pages into sgx_nr_used_pages and
> > > > > allow an easy check for an empty EPC.
> > > >
> > > > First off, remove "in subsequent patch".
> > >
> > > Ok
> > >
> > > >
> > > > What does "change sgx_nr_free_pages into sgx_nr_used_pages" mean?
> > >
> > > As you can see from patch 2/4, I had to turn around the meaning of the
> > > existing sgx_nr_free_pages atomic counter not to count the # of free pages
> > > in EPC, but to count the # of used EPC pages (hence the change of name
> > > to sgx_nr_used_pages). The reason for doing this is only apparent in patch
> > 
> > Why you *absolutely* need to invert the meaning and cannot make
> > this work by any means otherwise?
> > 
> > I doubt highly doubt this could not be done other way around.
> 
> I can make it work. The point that this way is much better and no damage to
> existing logic is done. The sgx_nr_free_pages counter that is used only for page reclaiming
> and checked in a single piece of code.
> To give you an idea the previous iteration of the code looked like below.
> First, I had to define a new unconditional spinlock to protect the EPC page allocation:
> 
> diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> index c8a2542140a1..4f445c28929b 100644
> --- a/arch/x86/kernel/cpu/sgx/main.c
> +++ b/arch/x86/kernel/cpu/sgx/main.c
> @@ -31,6 +31,7 @@ static DEFINE_XARRAY(sgx_epc_address_space);
>   */
>  static LIST_HEAD(sgx_active_page_list);
>  static DEFINE_SPINLOCK(sgx_reclaimer_lock);
> +static DEFINE_SPINLOCK(sgx_allocate_epc_page_lock);



>  
>  static atomic_long_t sgx_nr_free_pages = ATOMIC_LONG_INIT(0);
>  static unsigned long sgx_nr_total_pages;
> @@ -457,7 +458,10 @@ static struct sgx_epc_page *__sgx_alloc_epc_page_from_node(int nid)
>   page->flags = 0;
>  
>   spin_unlock(&node->lock);
> +
> + spin_lock(&sgx_allocate_epc_page_lock);
>   atomic_long_dec(&sgx_nr_free_pages);
> + spin_unlock(&sgx_allocate_epc_page_lock);
>  
>   return page;
>  }
> 
> And then also take spinlock every time eupdatesvn attempts to run:
> 
> int sgx_updatesvn(void)
> +{
> + int ret;
> + int retry = 10;

Reverse xmas tree order.

> +
> + spin_lock(&sgx_allocate_epc_page_lock);

You could use guard for this.

https://elixir.bootlin.com/linux/v6.13.7/source/include/linux/cleanup.h

> +
> + if (atomic_long_read(&sgx_nr_free_pages) != sgx_nr_total_pages) {
> + spin_unlock(&sgx_allocate_epc_page_lock);
> + return SGX_EPC_NOT_READY;

Don't use uarch error codes. 

> + }
> +
> + do {
> + ret = __eupdatesvn();
> + if (ret != SGX_INSUFFICIENT_ENTROPY)
> + break;
> +
> + } while (--retry);
> +
> + spin_unlock(&sgx_allocate_epc_page_lock);
> 
> Which was called from each enclave create ioctl:
> 
> @@ -163,6 +163,11 @@ static long sgx_ioc_enclave_create(struct sgx_encl *encl, void __user *arg)
>   if (copy_from_user(&create_arg, arg, sizeof(create_arg)))
>   return -EFAULT;
>  
> + /* Unless running in a VM, execute EUPDATESVN if instruction is avalible */
> + if ((cpuid_eax(SGX_CPUID) & SGX_CPUID_EUPDATESVN) &&
> +    !boot_cpu_has(X86_FEATURE_HYPERVISOR))
> + sgx_updatesvn();
> +
>   secs = kmalloc(PAGE_SIZE, GFP_KERNEL);
>   if (!secs)
>   return -ENOMEM;
> 
> Would you agree that this way it is much worse even code/logic-wise even without benchmarks? 

Yes but obviously I cannot promise that I'll accept this as it is
until I see the final version

Also you probably should use mutex given the loop where we cannot
temporarily exit the lock (like e.g. in keyrings gc we can).

> 
> Best Regards,
> Elena. 

BR, Jarkko


