Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06DF81CAA86;
	Fri, 28 Mar 2025 18:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743185215; cv=none; b=b0BKslJGHHKZ4ONHvzcKlx6sQJxYCofXBPlccd+o+JVuY1yVaCBcMdbHJI5vm0m7w81n5TR555ItYRQuZ6ckx2OOh1cZvxhZHSM0cimX42VuaHkvvqqdRL4zWfKbpeWc0xuhv9rT22ppmm4/Dp8We1UHbglEtxPPmtV6YpAy4aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743185215; c=relaxed/simple;
	bh=rTIJI4MeYIGiwGC7iTIv2fRjjO/e/c49sVnVsZ7O1UY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u3dF2f3jnT7V/wQdkhh5wGDFwoppLpsjZo8K9oGKI+WCmIMzA3ccLXstIN4kZWUxOjvikLvxupJVkYELnwMtk//H15Y81n7I2mFtzeFG9JPciL6Shj9bCIcUamxUGP3bxmWvLgXKnRsP42R4Pm0YqBsW2fJkV08vF7tIrb8aLRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bzQL842f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bzQL842f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEFA6C4CEE4;
	Fri, 28 Mar 2025 18:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743185214;
	bh=rTIJI4MeYIGiwGC7iTIv2fRjjO/e/c49sVnVsZ7O1UY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bzQL842flLbiGhEEZcrJEhVeQaE6cWeZjDuhHMX0cx25DEnF/KX7llfaFCr1Y0j8+
	 Hv7F9u63CnZ/aiTyFyqUWj+4YRzjDjkgrSjWmyej29Bc8c4Xj6jk6RiOt+lCgNrgVx
	 kkIDSScxuCAbHcHvg08FNUb4qBGZZj/FP+GqTK1N7xgXgPyAAT/SGtStFMzEI/T7Ut
	 fBX7mFdduQ//ns67JnF3AoDzcIKWVBIjbaebnYI2RNkBDxiplBQMQQpro04CYgz+SF
	 KBsqUKUxHNmnaFUs4GfNr4oGcmzNISM0ItuIJ6R27dkT+FwODvwTOKzcMN6RHol7A9
	 jWTMMrc9AY1Pw==
Date: Fri, 28 Mar 2025 20:06:49 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: dave.hansen@intel.com, linux-sgx@vger.kernel.org,
	linux-kernel@vger.kernel.org, x86@kernel.org,
	asit.k.mallick@intel.com, vincent.r.scarlata@intel.com,
	chongc@google.com, erdemaktas@google.com, vannapurve@google.com,
	dionnaglaze@google.com, bondarn@google.com, scott.raynor@intel.com
Subject: Re: [PATCH v2 2/2] x86/sgx: Implement EUPDATESVN and
 opportunistically call it during first EPC page alloc
Message-ID: <Z-blOQ94ymUsDwPn@kernel.org>
References: <20250328125859.73803-1-elena.reshetova@intel.com>
 <20250328125859.73803-3-elena.reshetova@intel.com>
 <Z-bhczXA6aHdCYHq@kernel.org>
Precedence: bulk
X-Mailing-List: linux-sgx@vger.kernel.org
List-Id: <linux-sgx.vger.kernel.org>
List-Subscribe: <mailto:linux-sgx+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-sgx+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z-bhczXA6aHdCYHq@kernel.org>

On Fri, Mar 28, 2025 at 07:50:43PM +0200, Jarkko Sakkinen wrote:
> On Fri, Mar 28, 2025 at 02:57:41PM +0200, Elena Reshetova wrote:
> > SGX architecture introduced a new instruction called EUPDATESVN
> > to Ice Lake. It allows updating security SVN version, given that EPC
> > is completely empty. The latter is required for security reasons
> > in order to reason that enclave security posture is as secure as the
> > security SVN version of the TCB that created it.
> > 
> > Additionally it is important to ensure that while ENCLS[EUPDATESVN]
> > runs, no concurrent page creation happens in EPC, because it might
> > result in #GP delivered to the creator. Legacy SW might not be prepared
> > to handle such unexpected #GPs and therefore this patch introduces
> > a locking mechanism to ensure no concurrent EPC allocations can happen.
> > 
> > It is also ensured that ENCLS[EUPDATESVN] is not called when running
> > in a VM since it does not have a meaning in this context (microcode
> > updates application is limited to the host OS) and will create
> > unnecessary load.
> > 
> > This patch is based on previous submision by Cathy Zhang
> > https://lore.kernel.org/all/20220520103904.1216-1-cathy.zhang@intel.com/
> > 
> > Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
> > ---
> >  arch/x86/include/asm/sgx.h      | 41 +++++++++++++--------
> >  arch/x86/kernel/cpu/sgx/encls.h |  6 ++++
> >  arch/x86/kernel/cpu/sgx/main.c  | 63 ++++++++++++++++++++++++++++++++-
> >  arch/x86/kernel/cpu/sgx/sgx.h   |  1 +
> >  4 files changed, 95 insertions(+), 16 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/sgx.h b/arch/x86/include/asm/sgx.h
> > index 6a0069761508..5caf5c31ebc6 100644
> > --- a/arch/x86/include/asm/sgx.h
> > +++ b/arch/x86/include/asm/sgx.h
> > @@ -26,23 +26,26 @@
> >  #define SGX_CPUID_EPC_SECTION	0x1
> >  /* The bitmask for the EPC section type. */
> >  #define SGX_CPUID_EPC_MASK	GENMASK(3, 0)
> > +/* EUPDATESVN presence indication */
> > +#define SGX_CPUID_EUPDATESVN	BIT(10)
> >  
> >  enum sgx_encls_function {
> > -	ECREATE	= 0x00,
> > -	EADD	= 0x01,
> > -	EINIT	= 0x02,
> > -	EREMOVE	= 0x03,
> > -	EDGBRD	= 0x04,
> > -	EDGBWR	= 0x05,
> > -	EEXTEND	= 0x06,
> > -	ELDU	= 0x08,
> > -	EBLOCK	= 0x09,
> > -	EPA	= 0x0A,
> > -	EWB	= 0x0B,
> > -	ETRACK	= 0x0C,
> > -	EAUG	= 0x0D,
> > -	EMODPR	= 0x0E,
> > -	EMODT	= 0x0F,
> > +	ECREATE		= 0x00,
> > +	EADD		= 0x01,
> > +	EINIT		= 0x02,
> > +	EREMOVE		= 0x03,
> > +	EDGBRD		= 0x04,
> > +	EDGBWR		= 0x05,
> > +	EEXTEND		= 0x06,
> > +	ELDU		= 0x08,
> > +	EBLOCK		= 0x09,
> > +	EPA		= 0x0A,
> > +	EWB		= 0x0B,
> > +	ETRACK		= 0x0C,
> > +	EAUG		= 0x0D,
> > +	EMODPR		= 0x0E,
> > +	EMODT		= 0x0F,
> > +	EUPDATESVN	= 0x18,
> >  };
> >  
> >  /**
> > @@ -73,6 +76,11 @@ enum sgx_encls_function {
> >   *				public key does not match IA32_SGXLEPUBKEYHASH.
> >   * %SGX_PAGE_NOT_MODIFIABLE:	The EPC page cannot be modified because it
> >   *				is in the PENDING or MODIFIED state.
> > + * %SGX_INSUFFICIENT_ENTROPY:	Insufficient entropy in RNG.
> > + * %SGX_EPC_NOT_READY:		EPC is not ready for SVN update.
> > + * %SGX_NO_UPDATE:		EUPDATESVN was successful, but CPUSVN was not
> > + *				updated because current SVN was not newer than
> > + *				CPUSVN.
> >   * %SGX_UNMASKED_EVENT:		An unmasked event, e.g. INTR, was received
> >   */
> >  enum sgx_return_code {
> > @@ -81,6 +89,9 @@ enum sgx_return_code {
> >  	SGX_CHILD_PRESENT		= 13,
> >  	SGX_INVALID_EINITTOKEN		= 16,
> >  	SGX_PAGE_NOT_MODIFIABLE		= 20,
> > +	SGX_INSUFFICIENT_ENTROPY	= 29,
> > +	SGX_EPC_NOT_READY		= 30,
> > +	SGX_NO_UPDATE			= 31,
> >  	SGX_UNMASKED_EVENT		= 128,
> >  };
> >  
> > diff --git a/arch/x86/kernel/cpu/sgx/encls.h b/arch/x86/kernel/cpu/sgx/encls.h
> > index 99004b02e2ed..3d83c76dc91f 100644
> > --- a/arch/x86/kernel/cpu/sgx/encls.h
> > +++ b/arch/x86/kernel/cpu/sgx/encls.h
> > @@ -233,4 +233,10 @@ static inline int __eaug(struct sgx_pageinfo *pginfo, void *addr)
> >  	return __encls_2(EAUG, pginfo, addr);
> >  }
> >  
> > +/* Update CPUSVN at runtime. */
> > +static inline int __eupdatesvn(void)
> > +{
> > +	return __encls_ret_1(EUPDATESVN, "");
> > +}
> > +
> >  #endif /* _X86_ENCLS_H */
> > diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> > index b61d3bad0446..24563110811d 100644
> > --- a/arch/x86/kernel/cpu/sgx/main.c
> > +++ b/arch/x86/kernel/cpu/sgx/main.c
> > @@ -32,6 +32,11 @@ static DEFINE_XARRAY(sgx_epc_address_space);
> >  static LIST_HEAD(sgx_active_page_list);
> >  static DEFINE_SPINLOCK(sgx_reclaimer_lock);
> >  
> > +/* This lock is held to prevent new EPC pages from being created
> > + * during the execution of ENCLS[EUPDATESVN].
> > + */
> > +static DEFINE_SPINLOCK(sgx_epc_eupdatesvn_lock);
> > +
> >  static atomic_long_t sgx_nr_used_pages = ATOMIC_LONG_INIT(0);
> >  static unsigned long sgx_nr_total_pages;
> >  
> > @@ -457,7 +462,17 @@ static struct sgx_epc_page *__sgx_alloc_epc_page_from_node(int nid)
> >  	page->flags = 0;
> >  
> >  	spin_unlock(&node->lock);
> > -	atomic_long_inc(&sgx_nr_used_pages);
> > +
> > +	if (!atomic_long_inc_not_zero(&sgx_nr_used_pages)) {
> > +		spin_lock(&sgx_epc_eupdatesvn_lock);
> > +		/* Only call sgx_updatesvn() once the first enclave's
> > +		 * page is allocated from EPC
> > +		 */
> > +		if (atomic_long_read(&sgx_nr_used_pages) == 0)
> > +			sgx_updatesvn();
> > +		atomic_long_inc(&sgx_nr_used_pages);
> > +		spin_unlock(&sgx_epc_eupdatesvn_lock);
> > +	}
> >  
> >  	return page;
> >  }
> > @@ -970,3 +985,49 @@ static int __init sgx_init(void)
> >  }
> >  
> >  device_initcall(sgx_init);
> > +
> > +/**
> > + * sgx_updatesvn() - Issue ENCLS[EUPDATESVN]
> > + * If EPC is ready, this instruction will update CPUSVN to the currently
> > + * loaded microcode update SVN and generate new cryptographic assets.
> > + */
> > +void sgx_updatesvn(void)
> > +{
> > +	int retry = 10;
> > +	int ret;
> > +
> > +	lockdep_assert_held(&sgx_epc_eupdatesvn_lock);
> > +
> > +	if (!(cpuid_eax(SGX_CPUID) & SGX_CPUID_EUPDATESVN))
> > +		return;
> > +
> > +	/* Do not execute ENCLS[EUPDATESVN] if running in a VM since
> > +	 * microcode updates are only meaningful to be applied on the host.
> > +	 */
> > +	if (boot_cpu_has(X86_FEATURE_HYPERVISOR))
> > +		return;
> > +
> > +	do {
> > +		ret = __eupdatesvn();
> > +		if (ret != SGX_INSUFFICIENT_ENTROPY)
> > +			break;
> > +
> > +	} while (--retry);
> > +
> > +	switch (ret) {
> > +	case 0:
> > +		pr_info("EUPDATESVN: success\n");
> > +		break;
> > +	case SGX_EPC_NOT_READY:
> > +	case SGX_INSUFFICIENT_ENTROPY:
> > +	case SGX_EPC_PAGE_CONFLICT:
> > +		pr_err("EUPDATESVN: error %d\n", ret);
> > +		break;
> > +	case SGX_NO_UPDATE:
> > +		break;
> > +	default:
> > +		pr_err("EUPDATESVN: unknown error %d\n", ret);
> > +		break;
> > +	}
> 
> Overall, I think you're right in that "inversion" does make sense,
> now that other stuff is better aligned.
> 
> At least when there is spurious error, I think ioctl's should stop
> responding and driver should not do anything useful anymore. I.e.,
> it should go out-of-service.
> 
> I don't think the driver should tear-down, just stop servicing
> VM's and responding ioctl's.
> 
> Possibly thish should be also right action for other errors than
> "insufficient entropy" but I'm open for comments for this.

Or actually actually I take one step back with my suggestions
because this really should be a question for which I don't have
the definitive answer.

The current code works like this: if anything that we don't
like happens, we re-iterate.

Should some of the "exceptional conditions" have a different
recovery or not?

BR, Jarkko


